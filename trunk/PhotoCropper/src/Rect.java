/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: Nov 19, 2009
 * Time: 9:02:39 PM
 * To change this template use File | Settings | File Templates.
 */
public class Rect {
  private final int x;
  private final int y;
  private final int width;
  private final int height;

  public Rect(int x, int y, int width, int height) {
    if (x < 0 || y < 0 || width < 0 || height < 0) {
      System.out.println();
    }
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }

  public final int getX() {
    return x;
  }

  public final int getY() {
    return y;
  }

  public final int getWidth() {
    return width;
  }

  public final int getHeight() {
    return height;
  }

  @Override
  public final boolean equals(Object o) {
    if (this == o) return true;
    if (!(o instanceof Rect)) return false;

    Rect rect = (Rect) o;

    if (height != rect.height) return false;
    if (width != rect.width) return false;
    if (x != rect.x) return false;
    if (y != rect.y) return false;

    return true;
  }

  @Override
  public final int hashCode() {
    int result = x;
    result = 31 * result + y;
    result = 31 * result + width;
    result = 31 * result + height;
    return result;
  }

  public boolean containsPixel(Pix pixel) {
    return pixel.getX() >= x && pixel.getX() <= x + width &&
        pixel.getY() >= y && pixel.getY() <= y + height;
  }

  @Override
  public String toString() {
    return "Rect{" +
        "x=" + x +
        ", y=" + y +
        ", width=" + width +
        ", height=" + height +
        '}';
  }
}
