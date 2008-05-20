import java.io.*;
import java.net.*;
import java.util.*;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: May 17, 2008
 * Time: 11:00:03 PM
 * To change this template use File | Settings | File Templates.
 */
public abstract class AbstractPersonListParser extends AbstractListParser {
    protected HashSet<Person> savedPeople = new HashSet<Person>();
    protected PrintWriter writer;
    private final static String SEPARATOR = "|#|";

    protected AbstractPersonListParser(File file, String sentinel) throws IOException {
        super(file);

        readSavedInformation();
        writer = new PrintWriter(new FileWriter(getSaveFile(), true));

        readUntil(sentinel);
        readLines(4);
    }

    private void readSavedInformation() throws IOException {
        File file = new File(getSaveFile());
        if (!file.exists()) {
            return;
        }

        LineNumberReader in = new LineNumberReader(new FileReader(file));
        String line;
        while ((line = in.readLine()) != null) {
            int index = line.indexOf(SEPARATOR);
            if (index > 0) {
                String firstName = line.substring(0, index);
                String lastName = line.substring(index + 3);

                savedPeople.add(new Person(firstName, lastName, Collections.EMPTY_LIST));
            }
        }

        in.close();
    }

    protected abstract String getSaveFile();

    public boolean runWorker() throws IOException, URISyntaxException {
        String line;

        Person person;
        if ((person = readPerson(in)) != null) {
            total++;
            person.getMovies().retainAll(MoviesListParser.getMovies());

            if (!person.getMovies().isEmpty() && !savedPeople.contains(person)) {
                System.out.println(getName() + " - " + count + "/" + total + " : " + person);
                count++;
                uploadPerson(person);
            }


            return true;
        }

        return false;
    }

    protected abstract String getName();

    protected abstract URL getURL() throws MalformedURLException;

    private final static int BATCH_SIZE = 50;

    private void uploadPerson(Person person) throws IOException {
        List<Movie> movies = new ArrayList<Movie>(person.getMovies());

        for (int i = 0; i < movies.size(); i += BATCH_SIZE) {
            URL url = getURL();
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setDoOutput(true);

            PrintWriter out = new PrintWriter(new OutputStreamWriter(connection.getOutputStream(), "UTF-8"));

            out.println(person.getFirstName() + "|#|" + person.getLastName());

            for (Movie movie : movies.subList(i, Math.min(i + BATCH_SIZE, movies.size()))) {
                out.println(movie.getName() + "|#|" + movie.getYear());
            }

            out.flush();

            InputStream content = (InputStream) connection.getContent();
            content.close();
        }

        writer.println(person.getFirstName() + SEPARATOR + person.getLastName());
        writer.flush();
    }

    private Person readPerson(LineNumberReader in) throws IOException {
        String actorLine = in.readLine();

        if (actorLine == null) {
            return null;
        }

        if (actorLine.startsWith("----")) {
            return null;
        }

        int firstTab = actorLine.indexOf('\t');
        String name = actorLine.substring(0, firstTab);

        String movieLine = actorLine.substring(firstTab);

        Set<Movie> movies = new HashSet<Movie>();
        do {
            movieLine = movieLine.trim();
            if (movieLine.length() == 0) {
                break;
            }

            Movie movie = Movie.fromActorsList(movieLine);
            if (movie == null) {
                continue;
            }

            movies.add(movie);
        }
        while ((movieLine = in.readLine()) != null);

        String firstName = name;
        List<String> middleNames = Collections.emptyList();
        String lastName = "";
        if (name.contains(",")) {
            firstName = name.substring(name.indexOf(',') + 2);
            lastName = name.substring(0, name.indexOf(','));
        }

        return new Person(firstName, lastName, movies);
    }
}
