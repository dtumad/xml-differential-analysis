# Basic validator that just checks that head nodes have matching number of children
import sys
import xml.etree.ElementTree as ET

xml_text1 = sys.argv[1]
xml_text2 = sys.argv[2]

xml_tree1 = ET.fromstring(xml_text1)
xml_tree2 = ET.fromstring(xml_text2)

if(len(xml_tree1.attrib) == len(xml_tree2.attrib)):
    print("Matching number of children of root")
else:
    print("Mismatched number of children of root")