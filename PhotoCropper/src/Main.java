import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.*;
import java.util.List;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: Nov 19, 2009
 * Time: 5:47:22 PM
 * To change this template use File | Settings | File Templates.
 */
public class Main {
  public static void main(String... args) throws IOException {
    for (String file : args) {
      processFile(new File(file));
    }
  }

  private static void processFile(File file) throws IOException {
    BufferedImage image = ImageIO.read(file);
    List<BufferedImage> photos = processImage(image);

    String fullName = file.getName();
    String name = fullName.substring(0, fullName.lastIndexOf('.'));
    String ext = fullName.substring(fullName.lastIndexOf('.') + 1);

    int i = 1;
    for (BufferedImage photo : photos) {
      ImageIO.write(photo, "png", new File(file.getParentFile(), name + "-" + i++ + ".png"));
    }
  }

  private static List<BufferedImage> processImage(BufferedImage image) {
    Set<Pix> seenPixels = new HashSet<Pix>();

    List<BufferedImage> result = new ArrayList<BufferedImage>();

    BufferedImage photo;
    while ((photo = extractPhoto(image, seenPixels)) != null) {
      result.add(photo);
    }

    return result;
  }

  private static BufferedImage extractPhoto(BufferedImage image, Set<Pix> seenPixels) {
    int height = image.getHeight();
    int width = image.getWidth();

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        Pix pixel = new Pix(x, y);
        if (seenPixels.contains(pixel)) {
          continue;
        }
        seenPixels.add(pixel);

        if (!passesWhiteThreshold(image, pixel)) {
          continue;
        }

        Set<Pix> flood = floodFill(image, pixel);
        Rectangle rectangle = getBoundingRectangle(flood);

        if (largeEnough(image, rectangle)) {
          seenPixels.addAll(flood);
          return image.getSubimage(rectangle.x, rectangle.y, rectangle.width, rectangle.height);
        }
      }
    }

    return null;
  }

  private static boolean largeEnough(BufferedImage image, Rectangle rectangle) {
    return rectangle.getWidth() > image.getWidth() / 5 &&
           rectangle.getHeight() > image.getHeight() / 5;
  }

  private static Rectangle getBoundingRectangle(Set<Pix> flood) {
    int minX = Integer.MAX_VALUE;
    int minY = Integer.MAX_VALUE;
    int maxX = Integer.MIN_VALUE;
    int maxY = Integer.MIN_VALUE;

    for (Pix pix : flood) {
      minX = Math.min(minX, pix.getX());
      minY = Math.min(minY, pix.getY());
      maxX = Math.max(maxX, pix.getX());
      maxX = Math.max(maxX, pix.getY());
    }

    return new Rectangle(minX, minY, maxX - minX, maxY - minY);
  }

  private static Set<Pix> floodFill(BufferedImage image, Pix start) {
    Set<Pix> result = new HashSet<Pix>();
    SortedSet<Pix> worklist = new TreeSet<Pix>();
    Set<Pix> alreadySeen = new HashSet<Pix>();
    worklist.add(start);

    while (!worklist.isEmpty()) {
      Pix current = worklist.first();
      worklist.remove(current);

      result.add(current);
      Pix[] surrounding = {current.up(), current.down(), current.left(), current.right()};

      for (Pix neighbor : surrounding) {
        if (!inImage(image, neighbor)) {
          continue;
        }
        if (alreadySeen.contains(neighbor)) {
          continue;
        }
        alreadySeen.add(neighbor);
        if (passesWhiteThreshold(image, neighbor)) {
          worklist.add(neighbor);
        }
      }
    }

    return result;
  }

  private static boolean inImage(BufferedImage image, Pix neighbor) {
    return neighbor.getX() >= 0 && neighbor.getX() < image.getWidth() &&
           neighbor.getY() >= 0 && neighbor.getY() < image.getHeight();
  }


  private static boolean passesWhiteThreshold(BufferedImage image, Pix pixel) {
    int rgb = image.getRGB(pixel.getX(), pixel.getY());
    Color color = new Color(rgb);

    int threshold = 256 - 16;
    return color.getRed() > threshold && color.getGreen() > threshold && color.getBlue() > threshold;
  }

  private static class Pix implements Comparable<Pix> {
    private final int x;
    private final int y;

    private Pix(int x, int y) {
      this.x = x;
      this.y = y;
    }

    public int getX() {
      return x;
    }

    public int getY() {
      return y;
    }

    @Override
    public boolean equals(Object o) {
      if (this == o) return true;
      if (!(o instanceof Pix)) return false;

      Pix pix = (Pix) o;

      if (x != pix.x) return false;
      if (y != pix.y) return false;

      return true;
    }

    @Override
    public int hashCode() {
      int result = x;
      result = 31 * result + y;
      return result;
    }

    public int compareTo(Pix pix) {
      int diff = getX() - pix.getX();
      if (diff != 0) {
        return diff;
      }

      return getY() - pix.getY();
    }

    public Pix up() {
      return new Pix(getX(), getY() - 1);
    }

    public Pix down() {
      return new Pix(getX(), getY() + 1);
    }

    public Pix left() {
      return new Pix(getX() - 1, getY());
    }

    public Pix right() {
      return new Pix(getX() + 1, getY());
    }
  }
}
