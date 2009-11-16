/**
 * Created by IntelliJ IDEA.
* User: cyrusn
* Date: Nov 16, 2009
* Time: 1:52:13 PM
* To change this template use File | Settings | File Templates.
*/
public class Pair {
  public final String first;
  public final String second;

  Pair(final String first, final String second) {
    this.first = first;
    this.second = second;
  }

  @Override
  public boolean equals(final Object o) {
    if (this == o) return true;
    if (!(o instanceof Pair)) return false;

    final Pair pair = (Pair) o;

    if (!first.equals(pair.first)) return false;
    if (!second.equals(pair.second)) return false;

    return true;
  }

  @Override
  public int hashCode() {
    int result = first.hashCode();
    result = 31 * result + second.hashCode();
    return result;
  }
}
