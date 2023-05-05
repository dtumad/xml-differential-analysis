#!/bin/bash

xml_samples=${1:-'xml_samples/basic'} # Default directory to look for xml sample files

normalizers="parsing_normalizers" # Directory of programs to run the sample xml files through.
xml_normalized="xml_normalized" # Directory to output normalized xml files.

validators="parsing_validators" # Directory of programs to test if two normalized files match.
xml_validated="xml_validated" # Directory to output results of validation.
validation_results="validation_results" # CSV to collect validation results.

###################################################################
####################### UTILITY FUNCTIONS #########################
###################################################################

# Reset the folders for the validation results and intermediate files.
make_output_dirs() {
    rm -r "$xml_normalized" 2> /dev/null
    rm -r "$xml_validated" 2> /dev/null
    rm -r "$validation_results" 2> /dev/null
    mkdir "$xml_normalized"
    mkdir "$xml_validated"
    mkdir "$validation_results"
}

# Get the name of a file, removing the leading path and trailing file extension.
extract_name() {
    echo "$1" | sed -r "s/.*\/(.*)\..*/\1/"
}

extract_extension() {
    echo "$1" | sed -r "s/.*\/.*\.(.*)/\1/"
}

# Remove compiled parser files
clean_build() {
    for class_file in $normalizers/*.class; do
        rm "$class_file" 2> /dev/null
    done
    for rustc_file in $normalizers/*.rso; do
        rm "$rustc_file" 2> /dev/null
    done
}

# Loop through and compile re-compile programs for languages like java.
run_compilers() {
    cd "$normalizers"
    for java_file in ./*.java; do
        javac "$java_file"
    done
    for rust_file in ./*.rs; do
        file_name=`extract_name "$rust_file"`
        rustc "$rust_file" -o "$file_name.rso"
    done
    cd ".."
}

# Add header rows to each of the eventual csv files to be generated.
add_csv_headers() {
    for validator_program in ./$validators/*; do
        validator_name=`extract_name "$validator_program"`
        validated_csv="./$validation_results/$validator_name.csv"
        echo "Original XML Sample,First Parser,Second Parser,Validation Results" > "$validated_csv"
    done
}

###################################################################
################### MAIN ANALYSIS FUNCTIONS #######################
###################################################################

# Run the given normalizer program on the given XML text.
call_parser() {
    result=""
    extension=`extract_extension "$1"`
    program_name=`extract_name "$1"`
    if [[ $extension == "py" ]] # Run with python3 interpreter
    then result=`echo "$2" | python3 $1`
    elif [[ $extension == "js" ]] # Run with node interpreter
    then result=`echo "$2" | node $1`
    elif [[ $extension == "java" ]] # Run compiled java file
    then cd "./$3" && result=`echo "$2" | java $program_name` && cd ..
    elif [[ $extension == "rs" ]] # Run the compiled rust file
    then cd "./$3" && result=`echo "$2" | `./$program_name.rso`` && cd ..
    fi
    echo "$result"
}

# Run all normalizers in `$normalizers` on the file passed in as argument `$1`.
# The results are stored in a directory named by the xml file, with files named by the normalizer.
run_normalizers() {
    # Grab the name of the file given by the input path, create output directory.
    xml_name=`extract_name "$1"`
    mkdir "./$xml_normalized/$xml_name"

    normalizer_program=""
    for normalizer_program in ./$normalizers/*; do
        # Get the result of normalizing the input file with the current normalizer.
        echo "Normalizing '$xml_name' with '$normalizer_program'"
        xml_text=`cat "$1" | tr "\n" " "`
        normalized_xml=`call_parser $normalizer_program "$xml_text" $normalizers`

        # Write the normalized text to a new file in `$xml_normalized`.
        normalizer_name=`extract_name "$normalizer_program"`
        normalized_file="./$xml_normalized/$xml_name/$normalizer_name.xml"
        echo "$normalized_xml" > "$normalized_file"
    done
}

# Run all validators in `$validators` on the two files passed as arguments `$2` and `$3`.
# The result files are named by the validator, xml file (from `$1`), and two normalizers.
run_validators() {
    validator_program=""
    for validator_program in ./$validators/*; do
        # Grab the specific name of the validator being used and corresponding normalizers.
        validator_name=`extract_name "$validator_program"`
        normalizer_name1=`extract_name "$2"`
        normalizer_name2=`extract_name "$3"`

        # Store the result of validating the files with `$validator_program` in `$is_valid`.
        echo "Validating $2 and $3 with $validator_name"
        xml_text1=`cat "$2" | tr "\n" " "`
        xml_text2=`cat "$3" | tr "\n" " "`
        combined_text="$xml_text1
$xml_text2"
        is_valid=`call_parser $validator_program "$combined_text" $validators`

        # Write the output of validation to a new file in `$xml_validated`.
        validated_file="./$xml_validated/$1/$validator_name-$normalizer_name1-$normalizer_name2.txt"
        echo "$is_valid" > "$validated_file"

        # Write the output of validation as an entry in the aggregated csv file.
        validated_csv="./$validation_results/$validator_name.csv"
        echo "$1.xml,$normalizer_name1,$normalizer_name2,$is_valid" >> "$validated_csv"
    done
}

# Run validation on all pairs of files in the directory given as a path in argument `$1`.
# Note that we both validate files against themselves and in both possible orders.
validate_files() {
    # Extract just the name of the directory of normalized files.
    directory_name=`echo "$1" | sed -r "s/.*\/(.*)/\1/"`
    normalized_file1="" # Normalized file to validate.
    normalized_file2="" # Normalized file to validate against.

    # Create folder for the validation results on this set of files, and add csv headers.
    mkdir "./$xml_validated/$directory_name"

    for normalized_file1 in $1/*.xml; do
        for normalized_file2 in $1/*.xml; do
            run_validators "$directory_name" "$normalized_file1" "$normalized_file2"
        done
    done
}

###################################################################
########################## MAIN RUNNER ############################
###################################################################

make_output_dirs
clean_build
run_compilers
add_csv_headers

# Loop through all the sample xml files and run the normalizers on them.
for xml_file in ./$xml_samples/*; do
    run_normalizers "$xml_file" &
done
wait

# Loop through all pairs of normalized files and run the validators on them.
for normalized_xml_directory in ./$xml_normalized/*; do
    validate_files "$normalized_xml_directory" &
done
wait

clean_build
exit 0