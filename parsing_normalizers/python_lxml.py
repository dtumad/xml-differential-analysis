# Parse an XML file with lxml library and write it back out right away
from lxml import etree
import sys

xml_tree = input()

# Parse the XML input with lxml library
try: xml_tree = etree.fromstring(xml_tree)
except:
    print("<parsing_failure> Failed to parse XML input </parsing_failure>")
    sys.exit()

# Write the XML tree back out with lxml library
try: normalized_xml_text = etree.tostring(xml_tree, encoding="utf-8").decode("utf-8")
except:
    print("<parsing_failure> Failed to write XML tree back out </parsing_failure>")
    sys.exit()

# Return the
print(normalized_xml_text)