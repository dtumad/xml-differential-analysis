// Parse an XML file with DOMParser library and write it back out right away
const { DOMParser, XMLSerializer } = require('xmldom');

let buffer = ""
process.stdin.resume();
process.stdin.on('readable', () => {
    xml_text = process.stdin.read();
    if (xml_text != null) { buffer += xml_text }
})
process.stdin.on('end', () => {
    var parser = new DOMParser({
        locator: {},
        errorHandler: { warning: function (w) { },
        error: function (e) { }, // Hide minor error outputs to not clutter command line.
        fatalError: function (e) { console.error("<parsing_error> " + e + " </parsing_error>") } }
    });
    var xml_tree = parser.parseFromString(buffer, 'text/xml');

    var serializer = new XMLSerializer();
    var normalized_xml_text = serializer.serializeToString(xml_tree);

    console.log(normalized_xml_text);
})