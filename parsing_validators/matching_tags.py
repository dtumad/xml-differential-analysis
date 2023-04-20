# This validator goes through both trees, checking that the number of children and all the node tags match
import xml.etree.ElementTree as ET

xml_text1 = input() #sys.argv[1]
xml_text2 = input() #sys.argv[2]

# Recurse through both trees checking that all the XML tags match
def validate_tree(xml_tree1, xml_tree2):
    tag1 = xml_tree1.tag
    tag2 = xml_tree2.tag
    children1 = [c for c in xml_tree1]
    children2 = [c for c in xml_tree2]
    # Check that both nodes have the same tag and number of child nodes
    if tag1 != tag2: return "INVALID - mismatched tags: '{}' and '{}'".format(tag1, tag2)
    elif len(children1) != len(children2):
        return "INVALID - different number of children at nodes '{}' and '{}'".format(tag1, tag2)
    # Recursively check the child nodes. Child nodes should be in the same order
    for i in range(len(children1)):
        child_validation_result = validate_tree(children1[i], children2[i])
        if child_validation_result != None:
            return child_validation_result
    return None

try:
    xml_tree1 = ET.fromstring(xml_text1)
    xml_tree2 = ET.fromstring(xml_text2)
    try:
        validation_errors = validate_tree(xml_tree1, xml_tree2)
    except:
        validation_errors = "INVALID - error while traversing trees"
    if validation_errors == None: print("VALID")
    else: print(validation_errors)
except:
    print("invalid: failed to parse one of the XML files")