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
    processDir(new File(args[0]));
  }

  private static void processDir(File dir) throws IOException {
    for (File file : dir.listFiles()) {
      processFile(file);
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
    Set<Rect> seenRects = new HashSet<Rect>();

    List<BufferedImage> result = new ArrayList<BufferedImage>();

    int height = image.getHeight();
    int width = image.getWidth();

    for (int x = 0; x < width; x++) {
      System.out.println("Moving to column: " + x);
      for (int y = 0; y < height; y++) {
        Pix pixel = Pix.create(x, y);

        if (isWhite(image, pixel)) {
          continue;
        }
        Rect rect = findRect(pixel, seenRects);
        if (rect != null) {
          y = rect.getY() + rect.getHeight();
          continue;
        }

        Rect rectangle = determineEdges(image, pixel);

        if (rectangle.getHeight() > 0 && rectangle.getWidth() > 0) {
          if (rectangle.getWidth() > image.getWidth() / 5 ||
              rectangle.getHeight() > image.getHeight() / 5) {
            System.out.println("Adding seen rect: " + rectangle);
            seenRects.add(rectangle);
          }
        }

        if (largeEnough(image, rectangle)) {
          result.add(image.getSubimage(rectangle.getX(), rectangle.getY(), rectangle.getWidth(), rectangle.getHeight()));
        }
      }
    }

    return result;
  }

  private static Rect findRect(Pix pixel, Set<Rect> seenRects) {
    for (Rect rect : seenRects) {
      if (rect.containsPixel(pixel)) {
        return rect;
      }
    }

    return null;
  }

  private static boolean containsPixel(Pix pixel, Set<Rect> seenRects) {
    for (Rect rect : seenRects) {
      if (rect.containsPixel(pixel)) {
        return true;
      }
    }
    return false;
  }

  private static Set<Pix> createFlood(Rectangle rectangle) {
    Set<Pix> set = new HashSet<Pix>();
    for (int x = rectangle.x; x < rectangle.x + rectangle.width; x++) {
      for (int y = rectangle.y; y < rectangle.y + rectangle.height; y++) {
        set.add(Pix.create(x, y));
      }
    }
    return set;
  }

  private static boolean largeEnough(BufferedImage image, Rect rectangle) {
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

  private static Rect determineEdges(BufferedImage image, Pix start) {
    int left = 0, right = 0, up = 0, down = 0;

    boolean changed;
    do {
      changed = false;

      int count;
      int nonWhite;

      count = 0;
      nonWhite = 0;
      for (int x = start.getX() - left; x <= start.getX() + right; x++) {
        Pix edge = Pix.create(x, start.getY() - (up + 1));
        if (!inImage(image, edge)) {
          break;
        }
        count++;
        if (!isWhite(image, edge)) {
          nonWhite++;
        }
      }
      if (count > 0 && ((double) nonWhite / (double) count) > .5) {
        up++;
        changed = true;
      }


      count = 0;
      nonWhite = 0;
      for (int x = start.getX() - left; x <= start.getX() + right; x++) {
        Pix edge = Pix.create(x, start.getY() + (down + 1));
        if (!inImage(image, edge)) {
          break;
        }
        count++;
        if (!isWhite(image, edge)) {
          nonWhite++;
        }
      }
      if (count > 0 && ((double) nonWhite / (double) count) > .5) {
        down++;
        changed = true;
      }


      count = 0;
      nonWhite = 0;
      for (int y = start.getY() - up; y <= start.getY() + down; y++) {
        Pix edge = Pix.create(start.getX() - (left + 1), y);
        if (!inImage(image, edge)) {
          break;
        }
        count++;
        if (!isWhite(image, edge)) {
          nonWhite++;
        }
      }
      if (count > 0 && ((double) nonWhite / (double) count) > .5) {
        left++;
        changed = true;
      }


      count = 0;
      nonWhite = 0;
      for (int y = start.getY() - up; y <= start.getY() + down; y++) {
        Pix edge = Pix.create(start.getX() + (right + 1), y);
        if (!inImage(image, edge)) {
          break;
        }
        count++;
        if (!isWhite(image, edge)) {
          nonWhite++;
        }
      }
      if (count > 0 && ((double) nonWhite / (double) count) > .5) {
        right++;
        changed = true;
      }
    } while (changed);

    int x = start.getX() - left;
    int y = start.getY() - up;
    int width = (start.getX() + right) - x;
    int height = (start.getY() + down) - up;

    return new Rect(x, y, width, height);
  }

  private static Set<Pix> floodFill1(BufferedImage image, Pix start) {
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
        if (isWhite(image, neighbor)) {
          continue;
        }

        worklist.add(neighbor);
      }
    }

    return result;
  }

  private static boolean inImage(BufferedImage image, Pix neighbor) {
    return neighbor.getX() >= 0 && neighbor.getX() < image.getWidth() &&
        neighbor.getY() >= 0 && neighbor.getY() < image.getHeight();
  }


  private static boolean isWhite(BufferedImage image, Pix pixel) {
    int rgb = image.getRGB(pixel.getX(), pixel.getY());
    int b = rgb & 0xFF;
    int g = (rgb >> 8) & 0xFF;
    int r = (rgb >> 16) & 0xFF;
    //Color color = new Color(rgb);

    int threshold = 256 - 16;
    return r > threshold && g > threshold && b > threshold;
  }

}
