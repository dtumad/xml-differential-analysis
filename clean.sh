#!/bin/bash

echo "Removing results of previous runs"

xml_normalized="xml_normalized" # Directory to output normalized xml files.
xml_validated="xml_validated" # Directory to output results of validation.
validation_results="validation_results"

# Clear previous results of running normalizers and validators.
rm -r "$xml_normalized" 2> /dev/null
rm -r "$xml_validated" 2> /dev/null
rm -r "$validation_results" 2> /dev/null
