# Validator to check that neither of the parsers being tested returned failure.
xml_text1 = input()
xml_text2 = input()

if "parsing_failure" in xml_text1:
    print(f"INVALID: First parser being validated returned failure -- {xml_text1}")
elif "parsing_failure" in xml_text2:
    print(f"INVALID: Second parser being validated returned failure -- {xml_text2}")
else:
    print("VALID")