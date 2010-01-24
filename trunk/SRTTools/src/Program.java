import java.io.*;
import java.util.List;
import java.util.ArrayList;
import java.util.Date;
import java.util.Calendar;
import java.util.regex.Pattern;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: Jan 24, 2010
 * Time: 11:18:02 AM
 * To change this template use File | Settings | File Templates.
 */
public class Program {
  public static void main(String... args) throws IOException {
    FileReader reader = new FileReader(args[0]);
    LineNumberReader lineReader = new LineNumberReader(reader);

    String text = "";
    String line;

    while ((line = lineReader.readLine()) != null) {
      text += line.trim();
      text += "\n";
    }

    text.trim();

    String[] parts = text.split("\n\n");
    List<Snippet> snippets = parseSnippets(parts);
    snippets = removeSounds(snippets);
    snippets = offsetSnippets(snippets, -1250);
    String result = createSrt(snippets);

    FileWriter writer = new FileWriter(args[1]);
    writer.write(result);
    writer.flush();
    writer.close();
  }

  private static String createSrt(List<Snippet> snippets) {
    String result = "";

    for (int i = 0; i < snippets.size(); i++) {
      result += (i + 1);
      result += "\r\n";
      result += snippets.get(i);
      result += "\r\n\r\n";
    }

    return result;
  }

  private static List<Snippet> offsetSnippets(List<Snippet> snippets, int offset) {
    List<Snippet> result = new ArrayList<Snippet>();
    for (Snippet snippet : snippets) {
      result.add(snippet.offset(offset));
    }

    return result;
  }

  private static List<Snippet> removeSounds(List<Snippet> snippets) {
    List<Snippet> result = new ArrayList<Snippet>();
    for (Snippet snippet : snippets) {
      if (!isOnlySound(snippet)) {
        result.add(snippet);
      }
    }
    return result;
  }

  private static boolean isOnlySound(Snippet snippet) {
    String[] pieces = snippet.getText().split("\n");
    for (String part : pieces) {
      if (!isOnlySound(part)) {
        return false;
      }
    }

    return true;
  }

  private static Pattern sound1Pattern = Pattern.compile("\\[.*\\]");
  private static Pattern sound2Pattern = Pattern.compile("- \\[.*\\]");
  private static boolean isOnlySound(String part) {
    return sound1Pattern.matcher(part).matches() ||
        sound2Pattern.matcher(part).matches();
  }

  private static List<Snippet> parseSnippets(String[] parts) {
    List<Snippet> result = new ArrayList<Snippet>();
    for (String part : parts) {
      result.add(parseSnippet(part));
    }
    return result;
  }

  private static Snippet parseSnippet(String part) {
    String[] pieces = part.split("\n");
    String[] startEnd = pieces[1].split(" --> ");
    String start = startEnd[0];
    String end = startEnd[1];
    String text = "";
    for (int i = 2; i < pieces.length; i++) {
      text += pieces[i];
      text += "\n";
    }
    text = text.trim();
    Date startDate = parseDate(start.trim());
    Date endDate = parseDate(end.trim());

    return new Snippet(startDate, endDate, text);
  }

  private static Date parseDate(String text) {
    String[] parts = text.split(",");
    String secondPart = parts[0];
    String msPart = parts[1];
    String[] timeParts = secondPart.split(":");
    String hour = timeParts[0];
    String minute = timeParts[1];
    String second = timeParts[2];

    Calendar c = Calendar.getInstance();
    c.set(Calendar.HOUR_OF_DAY, Integer.parseInt(hour));
    c.set(Calendar.MINUTE, Integer.parseInt(minute));
    c.set(Calendar.SECOND, Integer.parseInt(second));
    c.set(Calendar.MILLISECOND, Integer.parseInt(msPart));

    return c.getTime();
  }
}
