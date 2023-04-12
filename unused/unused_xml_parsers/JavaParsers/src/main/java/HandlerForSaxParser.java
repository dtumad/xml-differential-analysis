import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.ParserConfigurationException;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

public class HandlerForSaxParser extends DefaultHandler {

    private StringBuilder xmlData = new StringBuilder();
    private List<String> elements = new ArrayList<>();
    private StringBuilder currentElementValue = new StringBuilder();

    public void parse(InputStream xmlInputStream) throws ParserConfigurationException, SAXException, IOException {
        SAXParserFactory factory = SAXParserFactory.newInstance();
        SAXParser saxParser = factory.newSAXParser();
        saxParser.parse(xmlInputStream, this);
        System.out.println(xmlData.toString());
    }

    @Override
    public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
        xmlData.append("<").append(qName);
        for (int i = 0; i < attributes.getLength(); i++) {
            xmlData.append(" ").append(attributes.getQName(i)).append("=\"").append(attributes.getValue(i)).append("\"");
        }
        xmlData.append(">");
        elements.add(qName);
        currentElementValue = new StringBuilder();
    }

    @Override
    public void characters(char[] ch, int start, int length) throws SAXException {
        currentElementValue.append(ch, start, length);
    }

    @Override
    public void endElement(String uri, String localName, String qName) throws SAXException {
        String elementValue = currentElementValue.toString().trim();
        if (!elementValue.isEmpty()) {
            xmlData.append(elementValue);
        }
        xmlData.append("</").append(qName).append(">");
        elements.remove(elements.size() - 1);
    }

}
