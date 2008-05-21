/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: May 20, 2008
 * Time: 4:42:45 PM
 * To change this template use File | Settings | File Templates.
 */
public class StringUtilities {
    private StringUtilities() {}

    public static String massage(String string) {
        string = string.trim();
        string = string.replace('\t', ' ');

        while ((string.startsWith("'") && string.endsWith("'")) ||
               (string.startsWith("\"") && string.endsWith("\""))) {
            string = string.substring(1, string.length() - 1);
        }

        return string;
    }
}
