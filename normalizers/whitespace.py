# Basic normalizers that just adds some newlines and tabs, for basic script testing
import sys

xml_text = sys.argv[1]
for i in range(10):
    xml_text = "\n\t\n" + xml_text + "\t\n\t"
print(xml_text)