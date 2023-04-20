# Parse an XML file with etree library and write it back out right away
import xml.etree.ElementTree as ET
xml_text = input() #sys.argv[1]

try:
    xml_tree = ET.fromstring(xml_text)
    normalized_xml_text = str(ET.tostring(xml_tree, encoding="unicode"))
    print(normalized_xml_text)
except:
    print("<parsing_failure>")