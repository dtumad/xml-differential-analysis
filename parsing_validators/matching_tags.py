# Basic validator that just checks that nodes have matching tags
import sys
import xml.etree.ElementTree as ET

xml_text1 = sys.argv[1]
xml_text2 = sys.argv[2]

try:
    xml_tree1 = ET.fromstring(xml_text1)
    xml_tree2 = ET.fromstring(xml_text2)

    # TODO: actually recurse through the rest of the tree
    current_result = "valid"
    if(xml_tree1.tag != xml_tree2.tag):
        current_result = "mismatched tags"

    print(current_result)
except:
    print("Failed to parse one of the XML files")