import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: May 17, 2008
 * Time: 11:06:57 PM
 * To change this template use File | Settings | File Templates.
 */
public class Main {
    //public static final String HOST = "localhost:8080";
    //public static final String HOST = "metaboxoffice.appspot.com";
    public static final String HOST = "metaboxoffice2.appspot.com";

    public static void main(String... args) throws IOException, ParserConfigurationException, TransformerException, InterruptedException {
        if (false) {
            while (true) {
                try {
                    URL url = new URL("http://" + HOST + "/DeleteAllUsers");
                    InputStream in = (InputStream) url.getContent();
                    in.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
                try {
                    URL url = new URL("http://" + HOST + "/DeleteAllMovies");
                    InputStream in = (InputStream) url.getContent();
                    in.close();

                    System.out.print(".");
                } catch (Exception e) {
                    e.printStackTrace();
                }

            }
        }

        if (false) {
            URL url = new URL("http://" + HOST + "/UploadDirector");
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setDoOutput(true);

            PrintWriter out = new PrintWriter(new OutputStreamWriter(connection.getOutputStream()));

            Person person = new Person("Cyrus", "Najmabadi", Arrays.asList(
                    new Movie("Yo", 1998),
                    new Movie("That's right", 2008)
            ));

            person.print(out);
            out.flush();

            InputStream in = (InputStream) connection.getContent();
            String s = "";
            int i;
            while ((i = in.read()) > 0) {
                s = s + (char) i;
            }


            in.close();


            return;
        }

        parseLists();
    }

    private static void parseLists() throws IOException, InterruptedException {
        MoviesListParser movieParser = new MoviesListParser(new File("movies.list"));
        try {
            while (movieParser.run()) {
            }
        } catch (URISyntaxException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        } catch (InterruptedException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }

        ActorsListParser actorParser = new ActorsListParser(new File("actors.list"));
        ActressesListParser actressesParser = new ActressesListParser(new File("actresses.list"));
        WritersListParser writersParser = new WritersListParser(new File("writers.list"));
        DirectorsListParser directorsParser = new DirectorsListParser(new File("directors.list"));

        AbstractListParser[] parsers = new AbstractListParser[]{
                //movieParser,
                actorParser,
                actressesParser,
                writersParser,
                directorsParser
        };


        List<Thread> threads = new ArrayList<Thread>();

        for (final AbstractListParser parser : parsers) {
            Thread thread = new Thread() {
                public void run() {
                    int sleepSeconds = 0;

                    while (true) {
                        try {
                            if (!parser.run()) {
                                return;
                            }
                        } catch (Exception e) {
                            e.printStackTrace();

                            if (sleepSeconds == 0) {
                                sleepSeconds = 3;
                            } else {
                                sleepSeconds *= 2;
                                sleepSeconds = Math.min(120, sleepSeconds);
                            }
                        }

                        if (sleepSeconds > 0) {
                            System.out.println("Sleeping for: " + sleepSeconds);
                            try {
                                Thread.sleep(sleepSeconds * 1000);
                            } catch (InterruptedException e) {
                                throw new RuntimeException(e);
                            }

                            System.out.println("Reducing sleep length");
                            sleepSeconds--;
                        }
                    }
                }
            };

            thread.start();
        }

        for (Thread thread : threads) {
            thread.join();
        }

/*
        boolean again;
        do {
            again = false;

            for (AbstractListParser parser : parsers) {
                try {
                    again |= parser.run();
                } catch (Exception e) {
                    e.printStackTrace();

                    if (sleepSeconds == 0) {
                        sleepSeconds = 5;
                    } else {
                        sleepSeconds *= 2;
                        sleepSeconds = Math.max(120, sleepSeconds);
                    }
                }

                if (sleepSeconds > 0) {
                    System.out.println("Sleeping for: " + sleepSeconds);
                    Thread.sleep(sleepSeconds * 1000);

                    System.out.println("Reducing sleep length");
                    sleepSeconds--;
                }
            }
        } while (again);
*/
    }
}
