# Non-parsing program that lists every check as successful. Mainly for script testing purposes
xml_text1 = input()
xml_text2 = input()

if "parsing_failure" in xml_text1:
    print("INVALID: First parser being validated returned failure")
elif "parsing_failure" in xml_text2:
    print("INVALID: Second parser being validated returned failure")
else:
    print("VALID")