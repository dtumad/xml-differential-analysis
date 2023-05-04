# Normalize an XML file using the python `etree.ElementTree` parser.
import xml.etree.ElementTree as ET, sys

xml_text = input()

try: xml_tree = ET.fromstring(xml_text)
except Exception as e:
    print(f"<parsing_failure> Failed to parse XML input: {str(e)} </parsing_failure>")
    sys.exit()

try: normalized_xml_text = str(ET.tostring(xml_tree, encoding="unicode"))
except Exception as e:
    print(f"<parsing_failure> Failed to serialize XML output: {str(e)} </parsing_failure>")
    sys.exit()

print(normalized_xml_text)