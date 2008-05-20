import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;

class ActorsListParser extends AbstractPersonListParser {
    public ActorsListParser(File file) throws IOException {
        super(file, "THE ACTORS LIST");
    }

    protected String getName() {
        return "Actor";
    }

    protected URL getURL() throws MalformedURLException {
        return new URL("http://" + Main.HOST + "/UploadCastMember");
    }

    protected String getSaveFile() {
        return "actorsList.saveFile";
    }
}
