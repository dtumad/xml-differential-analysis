# Tool for Performing Differential Analysis of XML Parsers

This project provides scripting tools for comparing different XML parsers for deviating behavior (in the sense of behaving differently than each other).
The scripting is done via bash scripting, allowing support for parsers in arbitrary programming languages.

## Basic Approach

We consider two types of programs that are used in the testing process:

* **Normalizing Parsers** take in an XML string, parse it with some parsing library, and then un-parse the result back to a string. The program returns this final string.
* **Validating Parsers** take in two XML strings, parse them both with some parsing library, and perform some kind of comparison to check that both files are "equivalent" (e.g. that all nodes have the same number of children and tags). The program returns a classification of either valid or invalid.

Generally both types of programs will be fairly small, importing a pre-built library to handle the parsing.
Testing a particular parser is then essentially equivalent to importing and using it in one of the normalizing programs.

The testing approach is then to make use of both types of programs to cross-validate the behavior of them against each other, in four sequential phases:
1. Start with some large sample of XML files to run through the parsers (ideally with many edge cases).
2. For each XML file, run it through each normalizer, which will parse it and write back out a new XML string (if none of the parsers have bugs, then each of these results should be equivalent).
3. For each pair of new XML files, run them through each validator, to check that they are equivalent to each other.
4. Aggregate the results, and check to make sure all of the XML files were classified as valid.

For good results, ideally there are a large number of XML files, a decent number of normalizer programs, and a few very solid validator programs.

## File Structure and Organization

The main script to run the whole process is `run_tests.sh`. The script `clean.sh` deletes all the result files generated by `run_tests.sh`.
Test samples are organized into three main directories:
* `./xml_samples` contains all the XML files to be used in testing.
* `./parsing_normalizers` contains all the programs to use in the normalizing step.
* `./parsing_validators` contains all the programs to use in the validating steps.
* `./unused` is a dummy folder for work-in-progress XML files and parsers.

## Writing Normalizer Programs

The general idea of the normalizer programs is that they take in an xml string, parse it, and then convert back to an xml string which is returned.
If the parser works properly the input and output strings should be "equivalent".
If they aren't, then something must have gone wrong in either reading or writing the XML
(determining where the error happens requires manual analysis).

In order to integrate well with the bash scripting, there are essentially just three requirement:
* The program is a single file (although it should import libraries to do the parsing).
* The program accepts the XML input string from stdin (`input` in python for example).
* The program writes a final XML string to stdout (`print` in python for example).

In pseudo-code, this should usually look something like:
```
-- import the XML library that is being tested
import parser_library

-- read the input XML string from command line argument
original_xml = input()

parsed_xml = parser_library.parse(original_xml)
normalized_xml = parser_library.to_string(parsed_xml)

-- write the results back into stdout
write_line(normalized_xml)
```

The file `parsing_normalizers/python_ElementTree.py` gives a basic example of such a program in python, importing `ElementTree` from the standard library and using that to parse the input.

## Writing Validator Programs

The general idea of the validator programs is that they take in two XML strings, parse both, and then perform some comparison to test that the two XML strings "match".
The return value can be anything, and will be recorded in the final result aggregation, but the general convention is to return the string "valid" if no errors are found and an error message if discrepancies are found.

In order to integrate well with the bash scripting, there are essentially just three requirement:
* The program is a single file (although it should import libraries to do the parsing).
* The program accepts the two XML input strings as a pair of lines in stdin (calling `input` twice in python for example).
* The program writes a final classification to stdout (`print` in python for example).

In pseudo-code, this should usually look something like:
```
-- import the XML library that is being tested
import parser_library

-- read the input XML strings from command line argument
xml_sample1 = input()
xml_sample2 = input()

parsed_xml1 = parser_library.parse(xml_sample1)
parsed_xml2 = parser_library.parse(xml_sample2)

-- validate is some user defined function that compares the two trees
validation_result = validate(parsed_xml1, parsed_xml2)

-- write the results back into stdout
write_line(validation_result)
```

The file `parsing_validators/matching_tags.py` gives a basic example of such a program in python, checking that the nodes in both trees all have the same tags.

## Structure of the Results

The main results of the analysis are stored in `./validation_results` as csv files.
The file `./validation_results/{VALIDATOR}.csv` contains an aggregate of all the results of the differential analysis performed by `./parsing_validators/{VALIDATOR}`.
For example in `./validation_results/matching_tags.csv` will be a csv giving a list of how each set of parsers and normalizers were classified by `matching_tags.py`.

Each line of the csv file contains the original XML sample file, the two parsers being compared, and the final result of whether the two parsers gave the same result or not.
If there were no errors found, then each line of the file will list the result as succeeding, and if not some will be listed as failing.

The script also makes a number of directories with intermediate results as it runs.
They are mostly by-products of the running process, but can also be useful for debugging the final results that the script produces.
`clean.sh` will remove these, and `.gitignore` will exclude these from git.
They are designed to maintain the names of the original XML file, and the programs used to parse it, which is reflected in directory names and file names.
Note that each run of the script completely remakes these directories, so files stored here will be reset every run.

`./xml_normalized` contains the results of running each program in `./parsing_normalizers` on each file in `./xml_samples`.
In particular the file `./xml_normalized/{XML_NAME}/{PARSER}.xml` contains the XML file obtained by running `./xml_samples/{XML_NAME}.xml` through the program `./parsing_normalizers/{PARSER}`.

`./xml_validated` contains the results of running each pair of XML files in `./xml_normalized/{XML_NAME}` through each program in `./parsing_validators`.
In particular the file `./xml_validated/{XML_NAME}/{VALIDATOR}-{PARSER1}-{PARSER2}` contains the results of running `./parsing_validators/{VALIDATOR}` on the pair of inputs `./xml_normalized/{XML_NAME}/{PARSER1}.xml` and `./xml_normalized/{XML_NAME}/{PARSER2}.xml`.

## Support for Different Programming Languages

As the script goes through to run different parsing programs, it automatically checks for the file extension to know how to run the program.
Based on this it runs a hard coded command based on how that language works.
Supported languages are (TODO: need more of these to actually function properly, just python rn):
* Python (calls `python3` command)

# Future Work

* Handling programs that crash (doesn't work well with scripting now)
* Many More XML sample files.
* Better support for compiled programming languages.
* Parsers from more libraries and more languages.
* Better aggregation of errors to analyze them more easily.

# Other Notes

* XML samples don't play well with the script if there are spaces in file names. Running `for f in xml_samples/*\ *; do mv "$f" "${f// /_}"; done` will remove them.