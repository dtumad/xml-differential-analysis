# Parse an XML file and write it back out write away
import sys
import xml.etree.ElementTree as ET

xml_text = sys.argv[1]
xml_tree = ET.fromstring(xml_text)

print(str(ET.tostring(xml_tree, encoding="unicode")))