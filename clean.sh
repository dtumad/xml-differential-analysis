#!/bin/bash

xml_normalized="xml_normalized" # Directory to output normalized xml files.
xml_validated="xml_validated" # Directory to output results of validation.

# Clear previous results of running normalizers and validators.
rm -r "$xml_normalized" || true
rm -r "$xml_validated" || true