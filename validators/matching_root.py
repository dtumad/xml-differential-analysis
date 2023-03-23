# Basic validator that just checks that head nodes match
import sys
import xml.etree.ElementTree as ET

xml_text1 = sys.argv[1]
xml_text2 = sys.argv[2]

xml_tree1 = ET.fromstring(xml_text1)
xml_tree2 = ET.fromstring(xml_text2)

# print("valid")
if(xml_tree1.tag == xml_tree2.tag):
    print("Matching root")
else:
    print("Mismatched root node")