import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.Attr;

import java.io.Writer;
import java.io.IOException;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: May 17, 2008
 * Time: 5:58:12 PM
 * To change this template use File | Settings | File Templates.
 */
public class Movie {
    private final String name;
    private final int year;

    public Movie(String name, int year) {
        this.name = name;
        this.year = year;
    }

    public int getYear() {
        return year;
    }

    public String getName() {
        return name;
    }

    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Movie)) return false;

        Movie movie = (Movie) o;

        if (!name.equals(movie.name)) return false;
        if (year != movie.year) return false;

        return true;
    }

    public int hashCode() {
        int result;
        result = year;
        result = 31 * result + name.hashCode();
        return result;
    }

    public String toString() {
        return "<Movie name=\"" + name + "\" year=\"" + year + "\"/>";
    }

    public static Movie fromMoviesList(String line) {
        if (true) {
            return fromActorsList(line);
        }
        line = line.trim();

        if (line.contains("(V)") || line.contains("(VG)")) {
            return null;
        }

        int index = line.lastIndexOf('\t');
        String yearString = line.substring(index + 1).trim();
        int year;
        try {
            year = Integer.parseInt(yearString);
        } catch (Exception e) {
            System.out.println("Skipping: " + line);
            return null;
        }

        index = line.lastIndexOf(yearString, index);
        if (index == -1) {
            System.out.println("Skipping: " + line);
            return null;
        }

        String name = line.substring(0, index - 1);

        return new Movie(trimQuotes(name), year);
    }

    public static Movie fromActorsList(String line) {
        line = line.trim();

        if (line.contains("(V)") || line.contains("(VG)")) {
            return null;
        }

        int openParen;
        int closeParen = line.length();

        for (int i = line.length() - 1; i >= 0; --i) {
            char c = line.charAt(i);

            if (c == ')') {
                closeParen = i;
            } else if (c == '(') {
                openParen = i;

                int year = getYear(line, openParen, closeParen);
                if (year == -1) {
                    continue;
                }

                String name = line.substring(0, openParen - 1);
                name = trimQuotes(name);

                if (AbstractListParser.isStrange(name)) {
                    return null;
                }

                return new Movie(name, year);
            }
        }

        return null;
    }

    private static String trimQuotes(String name) {
        if (name.startsWith("\"")) {
            name = name.substring(1);
        }
        if (name.endsWith("\"")) {
            name = name.substring(0, name.length() - 1);
        }
        return name;
    }

    private static int getYear(String line, int openParen, int closeParen) {
        String sub = line.substring(openParen + 1, closeParen);
        if (sub.length() > 4) {
            if (sub.charAt(4) == '/') {
                sub = sub.substring(0, 4);
            } else {
                return -1;
            }
        }

        for (int i = 0; i < sub.length(); i++) {
            if (!Character.isDigit(sub.charAt(i))) {
                return -1;
            }
        }

        return Integer.parseInt(sub);
    }

    public Node toElement(Document document) {
        Element element = document.createElement("Movie");
        element.setAttribute("name", name);
        element.setAttribute("year", String.valueOf(year));
        return element;
    }

    private Node createAttribute(Document document, String key, String value) {
        Attr attribute = document.createAttribute(key);
        attribute.setValue(value);
        return attribute;
    }

    public void writeTo(Writer writer) throws IOException {
        writer.write("Name=" + name);
        writer.write('\n');
        writer.write("Year=" + year);
        writer.write('\n');
    }
}
