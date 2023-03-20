#!/bin/bash

xml_samples="xml_samples" # Directory with xml files to test.

normalizers="normalizers" # Directory of programs to run the sample xml files through.
xml_normalized="xml_normalized" # Directory to output normalized xml files.

validators="validators" # Directory of programs to test if two normalized files match.
xml_validated="xml_validated" # Directory to output results of validation.

# Clear previous results of running normalizers and validators.
rm -r "$xml_normalized" 2> /dev/null
rm -r "$xml_validated" 2> /dev/null
mkdir "$xml_normalized"
mkdir "$xml_validated"

# Run all normalizers in `$normalizers` on the file passed as argument `$1`.
run_normalizers() {
    # Grab the name of the file given by the input path
    xml_name=`echo "$1" | sed -r "s/.*\/(.*)\..*/\1/"`
    mkdir "./$xml_normalized/$xml_name"
    normalizer_program=""
    for normalizer_program in ./$normalizers/*; do
        # Store the result of normalizing `$xml_file` with `$normalizer_program` in `$new_xml`
        echo "Normalizing '$1' with '$normalizer_program'"
        # TODO: sub in a real command here
        new_xml=`python3 "$normalizer_program" "$(<$1)"`

        # Grab the specific name of the file being normalized and normalizer being used
        normalizer_name=`echo "$normalizer_program" | sed -r "s/.*\/(.*)\..*/\1/"`

        # Write the normalized text from `new_xml` to a new file in `$xml_normalized`
        out_regex="s/(.*)\/$xml_samples\/(.*)/\1\/$xml_normalized\/$normalizer_name\_\2/"
        normalized_file=`echo "$1" | sed -r "$out_regex"`
        echo "Outputting normalized file to: '$normalized_file'"
        echo "$new_xml" > "$normalized_file"
        echo ""
    done
}

# Run all validators in `$validators` on the two files passed as arguments `$1` and `$2`
run_validators() {
    validator_program=""
    for validator_program in ./$validators/*; do
        # Store the result of validating the viles with `$validator_program` in `$is_valid`
        echo "Validating $1 and $2 with $validator_program"
        # TODO: sub in a real command here
        is_valid=`python3 "$validator_program" "$(<$1)" "$(<$2)"`

        # Grab the specific name of the validator being used
        validator_name=`echo "$validator_program" | sed -r "s/.*\/(.*)\..*/\1/"`

        # Write the output of validation to a new file in `$xml_validated`
        out_regex="s/(.*)\/$xml_normalized\/(.*)\.xml/\1\/$xml_validated\/$validator_name\_\2.txt/"
        validated_file=`echo "$1" | sed -r "$out_regex"`
        echo "Outputting validation results to: '$validated_file'"
        echo "$is_valid" > "$validated_file"
        echo ""
    done
}

# Loop through all the sample xml files and run the normalizers on them.
xml_file="" # Global variable to store the current file to normalize
for xml_file in ./$xml_samples/*.xml; do
    run_normalizers "$xml_file"
done

# Loop through all pairs of normalized files and run the validators on them.
# TODO: This currently will validate all files against all other files.
normalized_file1="" # Normalized file to validate.
normalized_file2="" # Normalized file to validate against.
for normalized_file1 in ./$xml_normalized/*.xml; do
    for normalized_file2 in ./$xml_normalized/*.xml; do
        run_validators "$normalized_file1" "$normalized_file2"
    done
done
