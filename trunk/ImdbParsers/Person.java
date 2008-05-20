import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import java.io.PrintWriter;
import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: May 17, 2008
 * Time: 6:08:10 PM
 * To change this template use File | Settings | File Templates.
 */
public class Person {
    private final String firstName;
    private final String lastName;
    private final Set<Movie> movies;

    public Person(String firstName, String lastName, Collection<Movie> movies) {
        this.firstName = trim(firstName);
        this.lastName = trim(lastName);
        this.movies = new HashSet<Movie>(movies);
    }

    private String trim(String name) {
        name = name.trim();

        while ((name.startsWith("'") && name.endsWith("'")) ||
               (name.startsWith("\"") && name.endsWith("\""))) {
            name = name.substring(1, name.length() - 1);
        }

        return name;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public Set<Movie> getMovies() {
        return movies;
    }

    public String toString() {
        return "<Person firstName=\"" + firstName + "\" lastName=\"" + lastName + "\"/>";
    }

    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Person)) return false;

        Person person = (Person) o;

        if (!firstName.equals(person.firstName)) return false;
        if (!lastName.equals(person.lastName)) return false;

        return true;
    }

    public int hashCode() {
        int result;
        result = firstName.hashCode();
        result = 31 * result + lastName.hashCode();
        return result;
    }

    public Element toElement(Document document) {
        Element personElement = document.createElement("Person");
        personElement.setAttribute("firstName", firstName);
        personElement.setAttribute("lastName", lastName);

        Element moviesElement = document.createElement("Movies");
        for (Movie movie : movies) {
            moviesElement.appendChild(movie.toElement(document));
        }
        personElement.appendChild(moviesElement);

        return personElement;
    }

    private Node createAttribute(Document document, String key, String value) {
        Attr attribute = document.createAttribute(key);
        attribute.setValue(value);
        return attribute;
    }

    public void print(PrintWriter out) {
        out.println(getFirstName() + "|#|" + getLastName());

        for (Movie movie : getMovies()) {
            out.println(movie.getName() + "|#|" + movie.getYear());
        }
    }
}
