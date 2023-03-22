import org.xml.sax.SAXException;

import javax.xml.parsers.ParserConfigurationException;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

public class XMLParser {

    public static String filePath = "laptops.xml";


    public static void main(String[] args) throws IOException, SAXException, ParserConfigurationException {

        //Select with one to execute
        //saxParserExecute();

        domParserExecute();


    }

    public static void saxParserExecute() {
        try (InputStream inputStream = new FileInputStream(filePath)) {
            HandlerForSaxParser parser = new HandlerForSaxParser();
            parser.parse(inputStream);
            System.out.println("SaxParser XML information printed.");
        } catch (Error | ParserConfigurationException | SAXException | IOException e) {
            e.printStackTrace();
        }
    }

    public static void domParserExecute() {
        DomParser domParser = new DomParser(filePath);
        System.out.println(domParser);
    }

}
