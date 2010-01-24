import java.util.Date;
import java.util.Calendar;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: Jan 24, 2010
 * Time: 11:27:03 AM
 * To change this template use File | Settings | File Templates.
 */
public class Snippet {
  private Date start;
  private Date end;
  private String text;

  public Snippet(Date start, Date end, String text) {
    this.start = start;
    this.end = end;
    this.text = text;
  }

  public Date getStart() {
    return start;
  }

  public Date getEnd() {
    return end;
  }

  public String getText() {
    return text;
  }

  public String toString() {
    return toString(start) + " --> " + toString(end) + "\r\n" + text;
  }

  private static String toString(Date d) {
    Calendar c = Calendar.getInstance();
    c.setTime(d);
    int hour = c.get(Calendar.HOUR_OF_DAY);
    int minute = c.get(Calendar.MINUTE);
    int second = c.get(Calendar.SECOND);
    int ms = c.get(Calendar.MILLISECOND);

    return String.format("%1$02d:%2$02d:%3$02d,%4$d", hour, minute, second, ms);
  }

  public Snippet offset(int offset) {
    long startTime = start.getTime();
    long endTime = end.getTime();

    return new Snippet(new Date(startTime + offset),  new Date(endTime + offset), text);
  }
}
