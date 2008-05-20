import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.LinkedHashSet;
import java.util.Set;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: May 17, 2008
 * Time: 5:49:21 PM
 * To change this template use File | Settings | File Templates.
 */
public class MoviesListParser extends AbstractListParser {
    private static Set<Movie> movies = new LinkedHashSet<Movie>();

    public static Set<Movie> getMovies() {
        return movies;
    }

    public MoviesListParser(File file) throws IOException {
        super(file);
        readUntil("MOVIES LIST");
        readLines(2);
    }

    public boolean runWorker() throws IOException, URISyntaxException, InterruptedException {
        String line;
        if ((line = in.readLine()) != null) {
            total++;

            if (line.startsWith("----")) {
                return false;
            }

            Movie movie = Movie.fromMoviesList(line);
            if (movie != null) {
                movies.add(movie);

                count++;

                System.out.print("Movie - " + count + "/" + total + " : ");
                uploadMovie(movie);
            }
            return true;
        }

        return false;
    }

    private void uploadMovie(Movie movie) throws URISyntaxException, MalformedURLException {
        URI uri = new URI("http", null, "//metaboxoffice.appspot.com/UploadMovie",
                "name=" + movie.getName() + "&year=" + movie.getYear(), null);
        URL url = uri.toURL();
        System.out.println(url);

        if (true) {
            return;
        }

        try {
            InputStream content = (InputStream) url.getContent();
            content.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
