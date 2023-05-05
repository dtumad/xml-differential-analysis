// Use java's built in dom parser to read and then serialize an xml file.
import java.io.*;
import javax.xml.parsers.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import java.util.Scanner;
import java.nio.charset.StandardCharsets;
import org.w3c.dom.Document;

class java_dom {
    public static void main(String[] args) {
        try{
            StringBuilder sb = new StringBuilder();
            Scanner scanner = new Scanner(System.in);
            while (scanner.hasNext()) {sb.append(scanner.nextLine()).append(System.lineSeparator());}
            InputStream stream = new ByteArrayInputStream(sb.toString().getBytes(StandardCharsets.UTF_8));

            DocumentBuilder builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
            Document doc = builder.parse(stream);

            DOMSource dom = new DOMSource(doc);
            Transformer transformer = TransformerFactory.newInstance()
                .newTransformer();

            transformer.transform(dom, new StreamResult(System.out));
        }
        catch (Exception e) {
            System.out.println("<parsing_failure> " + e.toString() + " </parsing_failure>");
        }

    }
}


