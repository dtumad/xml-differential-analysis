// Parse an XML file with DOMParser library and write it back out right away
// const readline = require("readline")
const { DOMParser, XMLSerializer } = require('xmldom');

// const { stdin, stdout } = 'node:process';

// const rl = readline.createInterface({ stdin, stdout });
process.stdin.resume();
process.stdin.setEncoding('utf8');
process.stdin.on('readable', () => {
    xml_text = process.stdin.read();
    if (xml_text != null) {
        var parser = new DOMParser();
        var xml_tree = parser.parseFromString(xml_text, 'text/xml');

        var serializer = new XMLSerializer();
        var normalized_xml_text = serializer.serializeToString(xml_tree);

        console.log(normalized_xml_text);
    }
}
)

// var xml_text = readline();
// console.log(xml_text);


