package org.metasyntactic.recreation.life;

import org.apache.commons.collections.map.MultiValueMap;

import javax.swing.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.util.Set;
import java.util.TreeSet;

public class LifePanel extends JPanel {
    private Universe universe;
    private Image offScreenBuffer;

    /**
     * Creates new form LifePanel
     */
    public LifePanel() {
        initComponents();
    }

    private void initComponents() {
        setLayout(new java.awt.BorderLayout());
    }

    public void setUniverse(Universe universe) {
        this.universe = universe;

        this.invalidate();
    }

    public void update(Graphics g) {
        if (universe == null) {
            return;
        }
        Graphics pseudoGraphics;

        if (offScreenBuffer == null ||
                (!(offScreenBuffer.getWidth(this) == this.getSize().width
                        && offScreenBuffer.getHeight(this) == this.getSize().height))) {

            offScreenBuffer = new BufferedImage(getSize().width, getSize().height, BufferedImage.TYPE_INT_ARGB);
        }

        pseudoGraphics = offScreenBuffer.getGraphics();

        paint(pseudoGraphics);

        g.drawImage(offScreenBuffer, 0, 0, this);
    }

    public void paint(final Graphics g) {
        if (universe == null) {
            return;
        }
        MultiValueMap liveLocations = universe.getRoot().getLiveLocations();
        if (liveLocations.isEmpty()) {
            return;
        }

        int minX = Integer.MAX_VALUE;
        int maxX = 0;
        int minY = Integer.MAX_VALUE;
        int maxY = 0;

        for (int x : (Set<Integer>) liveLocations.keySet()) {
            minX = Math.min(x, minX);
            maxX = Math.max(x, maxX);

            TreeSet<Integer> ys = (TreeSet<Integer>) liveLocations.getCollection(x);
            minY = Math.min(ys.first(), minY);
            maxY = Math.max(ys.last(), maxY);
        }

        int width = maxX - minX;
        int height = maxY - minY;

        this.setSize(width, height);

        g.setColor(Color.black);
        g.fillRect(0, 0, width + 2, height + 2);
        g.setColor(Color.red);

        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                boolean b = liveLocations.containsValue(minX + x, minY + y);

                if (b) {
                    g.drawLine(x + 1, y + 1, x + 1, y + 1);
                }
            }
        }
    }
}