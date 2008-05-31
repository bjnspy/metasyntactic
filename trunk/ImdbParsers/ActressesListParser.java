import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: May 17, 2008
 * Time: 11:06:24 PM
 * To change this template use File | Settings | File Templates.
 */
public class ActressesListParser extends AbstractPersonListParser {
    public ActressesListParser(File file) throws IOException {
        super(file, "THE ACTRESSES LIST");
    }

    protected String getName() {
        return "Actress";
    }

    protected URL getURL() throws MalformedURLException {
        return new URL("http://" + Main.HOST + "/UploadCastMember");
    }

    protected String getSaveFile() {
        return "actressesList.saveFile";
    }
}
