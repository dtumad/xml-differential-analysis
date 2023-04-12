import org.xml.sax.SAXException;

import javax.xml.parsers.ParserConfigurationException;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Scanner;

public class XMLParser {

    public static String filePath = "laptops.xml";

    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);
        System.out.println("Pick Your Parser Type:");
        System.out.println("Enter 1 for Dom Parser");
        System.out.println("Enter 2 for Sax Parser");
        System.out.println("Enter 3 for Stax Parser");
        System.out.println("Insert you Response:");

        int userInput = sc.nextInt();

        //Select with one to execute
        if (userInput == 1) {
            domParserExecute();
        } else if (userInput == 2) {
            saxParserExecute();
        } else if (userInput == 3) {
            StaxParserExecute();
        } else {
            System.out.println("Error");
        }


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

    public static void StaxParserExecute() {
        StaxParser staxParser = new StaxParser(filePath);
        System.out.println(staxParser);
    }

}
