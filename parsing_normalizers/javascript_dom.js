// Parse an XML file with DOMParser library and write it back out right away
// const readline = require("readline")
const { DOMParser, XMLSerializer } = require('xmldom');

let buffer = ""
process.stdin.resume();
process.stdin.setEncoding('utf8');
process.stdin.on('readable', () => {
    xml_text = process.stdin.read();
    if (xml_text != null) { buffer += xml_text }
})
process.stdin.on('end', () => {
    // Hide the error outputs to not clutter command line.
    var parser = new DOMParser({
        locator: {},
        errorHandler: { warning: function (w) { },
        error: function (e) { },
        fatalError: function (e) { console.error("<parsing_error> " + e + "</parsing_error>") } }
    });
    var xml_tree = parser.parseFromString(buffer, 'text/xml');

    var serializer = new XMLSerializer();
    var normalized_xml_text = serializer.serializeToString(xml_tree);

    console.log(normalized_xml_text);
})

// // Start reading stdin and create a handler for the xml input
// process.stdin.resume();
// process.stdin.setEncoding('utf8');
// process.stdin.on('readable', () => {
//     xml_text = process.stdin.read();
//     if (xml_text != null) {
//         // Hide the error outputs to not clutter command line.
//         var parser = new DOMParser({
//             locator: {},
//             errorHandler: { warning: function (w) { },
//             error: function (e) { },
//             fatalError: function (e) { console.error(e) } }
//         });
//         var xml_tree = parser.parseFromString(xml_text, 'text/xml');

//         var serializer = new XMLSerializer();
//         var normalized_xml_text = serializer.serializeToString(xml_tree);

//         console.log(normalized_xml_text);
//     }
// })