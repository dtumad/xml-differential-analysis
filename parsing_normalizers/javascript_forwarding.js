// Start reading stdin and create a handler for the xml input
let buffer = ''
process.stdin.resume();
process.stdin.setEncoding('utf8');
process.stdin.on('readable', () => {
    xml_text = process.stdin.read();
    if (xml_text != null) { buffer += console.log(xml_text) }
})