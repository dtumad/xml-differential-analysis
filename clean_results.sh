#!/bin/bash

xml_samples="xml_samples" # Directory with xml files to test.

normalizers="parsing_normalizers" # Directory of programs to run the sample xml files through.
xml_normalized="xml_normalized" # Directory to output normalized xml files.

validators="parsing_validators" # Directory of programs to test if two normalized files match.
xml_validated="xml_validated" # Directory to output results of validation.
validation_results="validation_results" # CSV to collect validation results

echo "Removing results of previous runs"

# Clear previous results of running normalizers and validators.
rm -r "$xml_normalized" 2> /dev/null
rm -r "$xml_validated" 2> /dev/null
rm -r "$validation_results" 2> /dev/null
for class_file in $normalizers/*.class; do
    rm "$class_file" 2> /dev/null
done
for class_file in $validators/*.class; do
    rm "$class_file" 2> /dev/null
done
for rustc_file in $normalizers/*.rso; do
        rm "$rustc_file" 2> /dev/null
done
for rustc_file in $validators/*.rso; do
        rm "$rustc_file" 2> /dev/null
done

exit 0