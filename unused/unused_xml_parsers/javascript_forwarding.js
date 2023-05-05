// Javascript parser to read in and write back out text unchanged, mainly for testing purposes

let buffer = ""
process.stdin.resume();
process.stdin.setEncoding('utf8');
process.stdin.on('readable', () => {
    xml_text = process.stdin.read();
    if (xml_text != null) { buffer += xml_text }
})
process.stdin.on('end', () => {
    console.log(buffer)
})
