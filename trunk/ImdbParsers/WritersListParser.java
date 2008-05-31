import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: May 17, 2008
 * Time: 11:03:55 PM
 * To change this template use File | Settings | File Templates.
 */
public class WritersListParser extends AbstractPersonListParser {
    public WritersListParser(File file) throws IOException {
        super(file, "THE WRITERS LIST");
    }

    protected String getName() {
        return "Writer";
    }

    protected URL getURL() throws MalformedURLException {
        return new URL("http://" + Main.HOST + "/UploadWriter");
    }

    protected String getSaveFile() {
        return "writersList.saveFile";
    }
}
