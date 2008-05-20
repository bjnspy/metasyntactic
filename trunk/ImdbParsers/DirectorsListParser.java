import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: May 17, 2008
 * Time: 11:04:49 PM
 * To change this template use File | Settings | File Templates.
 */
public class DirectorsListParser extends AbstractPersonListParser {
    public DirectorsListParser(File file) throws IOException {
        super(file, "THE DIRECTORS LIST");
    }

    protected String getName() {
        return "Director";
    }

    protected URL getURL() throws MalformedURLException {
        return new URL("http://" + Main.HOST + "/UploadDirector");
    }

    protected String getSaveFile() {
        return "directorsList.saveFile";
    }
}
