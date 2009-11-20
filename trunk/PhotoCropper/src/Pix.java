import java.util.Map;
import java.util.HashMap;

/**
 * Created by IntelliJ IDEA.
* User: cyrusn
* Date: Nov 19, 2009
* Time: 8:37:40 PM
* To change this template use File | Settings | File Templates.
*/
class Pix implements Comparable<Pix> {
  private final int x;
  private final int y;
  private Pix up;
  private Pix down;
  private Pix left;
  private Pix right;

  private Pix(int x, int y) {
    this.x = x;
    this.y = y;
  }

  private final static Map<Integer, Map<Integer, Pix>> map = new HashMap<Integer,Map<Integer,Pix>>();

  public static Pix create(int x, int y) {
    Map<Integer,Pix> submap = map.get(x);
    if (submap == null) {
      submap = new HashMap<Integer,Pix>();
      map.put(x, submap);
    }

    Pix pix = submap.get(y);
    if (pix == null) {
      pix = new Pix(x, y);
      submap.put(y, pix);
    }

    return pix;
  }

  public final int getX() {
    return x;
  }

  public final int getY() {
    return y;
  }

  @Override
  public final boolean equals(Object o) {
    if (this == o) return true;
    if (!(o instanceof Pix)) return false;

    Pix pix = (Pix) o;

    if (x != pix.x) return false;
    if (y != pix.y) return false;

    return true;
  }

  @Override
  public final int hashCode() {
    int result = x;
    result = 31 * result + y;
    return result;
  }

  public final int compareTo(Pix pix) {
    if (pix == this) {
      return 0;
    }
    int diff = getX() - pix.getX();
    if (diff != 0) {
      return diff;
    }

    return getY() - pix.getY();
  }

  public final Pix up() {
    if (up == null) {
      up = Pix.create(getX(), getY() - 1);
      up.down = this;
    }
    return up;
  }

  public final Pix down() {
    if (down == null) {
      down = Pix.create(getX(), getY() + 1);
      down.up = this;
    }
    return down;
  }

  public final Pix left() {
    if (left == null) {
      left = Pix.create(getX() - 1, getY());
      left.right = this;
    }
    return left;
  }

  public final Pix right() {
    if (right == null) {
      right = Pix.create(getX() + 1, getY());
      right.left = this;
    }
    return right;
  }

  @Override
  public String toString() {
    return "Pix{" +
        "x=" + x +
        ", y=" + y +
        '}';
  }
}
