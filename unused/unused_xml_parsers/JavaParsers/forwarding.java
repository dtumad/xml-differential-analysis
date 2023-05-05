import java.io.*;
import java.util.Scanner;

class forwarding {
    public static void main(String[] args) {
        StringBuilder sb = new StringBuilder();
        Scanner scanner = new Scanner(System.in);
        while (scanner.hasNext()) {
            sb.append(scanner.nextLine()).append(System.lineSeparator());
        }
        System.out.println(sb);
    }
}
