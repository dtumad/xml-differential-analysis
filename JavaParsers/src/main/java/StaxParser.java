import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamConstants;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;

public class StaxParser {
    public StaxParser(String xmlFilePath) {
        try {
            InputStream xmlInputStream = new FileInputStream(xmlFilePath);
            XMLInputFactory factory = XMLInputFactory.newInstance();
            XMLStreamReader reader = factory.createXMLStreamReader(xmlInputStream);

            String currentElement = "";
            while (reader.hasNext()) {
                int event = reader.next();
                switch (event) {
                    case XMLStreamConstants.START_ELEMENT:
                        currentElement = reader.getLocalName();
                        System.out.print("<" + currentElement);
                        for (int i = 0; i < reader.getAttributeCount(); i++) {
                            System.out.print(" " + reader.getAttributeLocalName(i) + "=\"" + reader.getAttributeValue(i) + "\"");
                        }
                        System.out.print(">");
                        break;
                    case XMLStreamConstants.END_ELEMENT:
                        System.out.print("</" + reader.getLocalName() + ">");
                        break;
                    case XMLStreamConstants.CHARACTERS:
                        String text = reader.getText().trim();
                        if (!text.isEmpty()) {
                            System.out.print(text);
                        }
                        break;
                    case XMLStreamConstants.START_DOCUMENT:
                        System.out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
                        break;
                    default:
                        break;
                }
            }
            System.out.println();
        } catch (FileNotFoundException | XMLStreamException e) {
            e.printStackTrace();
        }
}}



