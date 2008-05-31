import java.io.*;
import java.util.HashSet;
import java.util.Set;
import java.net.URISyntaxException;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: May 17, 2008
 * Time: 5:50:13 PM
 * To change this template use File | Settings | File Templates.
 */
public abstract class AbstractListParser {
    protected static Set<String> dictionary = new HashSet<String>();

    static {
        try {
            LineNumberReader in = new LineNumberReader(new FileReader("dictionary_standard"));
            String line;
            while ((line = in.readLine()) != null) {
                dictionary.add(line.toLowerCase());
            }
        } catch (IOException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
    }

    LineNumberReader in;

      protected  int total = 0;
    protected    int count = 0;
    protected boolean done = false;

    protected AbstractListParser(File file) throws FileNotFoundException {
        in = new LineNumberReader(new FileReader(file));
    }

    public boolean run() throws IOException, URISyntaxException, InterruptedException {
        if (!done) {
            if (runWorker()) {
                return true;
            }
        }

        done = true;
        return false;
    }

    protected abstract boolean runWorker() throws IOException, URISyntaxException, InterruptedException ;

    protected void readLines(int count) throws IOException {
        for (int i = 0; i < count; i++) {
            in.readLine();
        }
    }

    protected void readUntil(String value) throws IOException {
        String line;
        while ((line = in.readLine()) != null) {
            if (line.equals(value)) {
                return;
            }
        }
    }

    public static boolean isStrange(String name) {
        int badCount = 0;
        for (int i = 0; i < name.length(); i++) {
            char c = name.charAt(i);
            if(Character.isLetter(c)) {
                char lower = Character.toLowerCase(c);

                if (!(lower >= 'a' && lower <= 'z')) {
                    badCount++;

                    if (badCount == 2) {
                        return true;
                    }
                }
            }
        }

        String[] words = name.split(" ");
        if (words.length > 1) {
            for (String word : words) {
                while (word.length() > 0 && !Character.isLetter(word.charAt(0))) {
                    word = word.substring(1);
                }

                while (word.length() > 0 && !Character.isLetter(word.charAt(word.length() - 1))) {
                    word = word.substring(0, word.length() - 1);
                }

                if (dictionary.contains(word.toLowerCase())) {
                    return false;
                }
            }
        }

        return true;
    }
}
