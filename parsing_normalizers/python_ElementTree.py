# Parse an XML file and write it back out write away
import sys
import xml.etree.ElementTree as ET

xml_text : str = input() #sys.argv[1]

try:
    xml_tree = ET.fromstring(xml_text)
    normalized_xml_text : str = str(ET.tostring(xml_tree, encoding="unicode"))
    print(normalized_xml_text)
except:
    print("<parsing_failure>")