import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.File;

public class DomParser {


    /*
     * Import the Document Build
     * Get Input Document
     * Normalize the xml structure
     * Get all the element by the tag names
     */

    public DomParser(String filePath) {
        try {
            // Load the XML file into a Document object
            File inputFile = new File(filePath);
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc = dBuilder.parse(inputFile);
            doc.getDocumentElement().normalize();

            // Get a list of all the laptop nodes
            NodeList laptopNodes = doc.getElementsByTagName("laptop");

            // Loop through each laptop node
            for (int i = 0; i < laptopNodes.getLength(); i++) {
                Node laptopNode = laptopNodes.item(i);
                if (laptopNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element laptopElement = (Element) laptopNode;
                    String laptopName = laptopElement.getAttribute("name");
                    System.out.println("Laptop name: " + laptopName);

                    // Get the price node
                    Element priceElement = (Element) laptopElement.getElementsByTagName("price").item(0);
                    String priceValue = priceElement.getAttribute("value");
                    System.out.println("Price: $" + priceValue);

                    // Get the RAM node
                    Element ramElement = (Element) laptopElement.getElementsByTagName("ram").item(0);
                    String ramValue = ramElement.getAttribute("value");
                    System.out.println("RAM: " + ramValue);

                    // Check if there's an SSD or hard drive node
                    Element storageElement = (Element) laptopElement.getElementsByTagName("ssd").item(0);
                    if (storageElement != null) {
                        String storageValue = storageElement.getAttribute("value");
                        System.out.println("Storage: " + storageValue + " SSD");
                    } else {
                        storageElement = (Element) laptopElement.getElementsByTagName("hardDrive").item(0);
                        String storageValue = storageElement.getAttribute("value");
                        System.out.println("Storage: " + storageValue + " hard drive");
                    }

                    System.out.println();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}


