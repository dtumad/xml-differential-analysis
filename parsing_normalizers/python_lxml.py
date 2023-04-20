# Parse an XML file with lxml library and write it back out right away
from lxml import etree
xml_tree = input()

try:
    xml_tree = etree.fromstring(xml_tree)
    normalized_xml_text = etree.tostring(xml_tree).decode("utf-8")
    print(normalized_xml_text)
except:
    print("<parsing_failure>")