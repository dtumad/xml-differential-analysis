# This validator goes through both trees, checking that the number of children and all the node tags match
import xml.etree.ElementTree as ET
import sys

xml_text1 = input()
xml_text2 = input()

# Report that some validation error occurred and exit the program
def report_invalid(validation_error):
    print("INVALID: " + validation_error)
    sys.exit()

# Recurse through both trees checking that tree structures match, and all tags on nodes match.
def validate_tree(xml_tree1, xml_tree2):
    tag1 = xml_tree1.tag
    tag2 = xml_tree2.tag
    children1 = [c for c in xml_tree1]
    children2 = [c for c in xml_tree2]
    # Check that both nodes have the same tag and number of child nodes.
    if tag1 != tag2: report_invalid("mismatched tags: '{}' and '{}'".format(tag1, tag2))
    elif len(children1) != len(children2): report_invalid("different number of children at nodes '{}' and '{}'".format(tag1, tag2))
    # Recursively check the child nodes. Child nodes should be in the same order.
    for i in range(len(children1)):
        validate_tree(children1[i], children2[i])

if "parsing_failure" in xml_text1: report_invalid("First parser being validated returned failure")
elif "parsing_failure" in xml_text2: report_invalid("Second parser being validated returned failure")

try: xml_tree1 = ET.fromstring(xml_text1)
except: report_invalid("Validator failed to parse first of the XML files")

try: xml_tree2 = ET.fromstring(xml_text2)
except: report_invalid("Validator failed to parse second of the XML files")

try: validate_tree(xml_tree1, xml_tree2)
except: report_invalid("Validator crashed while traversing parsed tree")

print("VALID")