# Normalize an XML file using the python `lxml.etree` parser.
# Note that there needs to be some weird hacks with encoding and decoding to properly handle unicode.
from lxml import etree
import sys

xml_tree = input()

# Parse the XML input with lxml library
try: xml_tree = etree.fromstring(xml_tree.encode("utf-8"), parser = etree.XMLParser(encoding = 'utf-8'))
except Exception as e:
    print(f"<parsing_failure> Failed to parse XML input: {str(e)} </parsing_failure>")
    sys.exit()

# Write the XML tree back out with lxml library
try: normalized_xml_text = etree.tostring(xml_tree, encoding="utf-8").decode("utf-8")
except:
    print(f"<parsing_failure> Failed to serialize XML output: {str(e)} </parsing_failure>")
    sys.exit()

print(normalized_xml_text)