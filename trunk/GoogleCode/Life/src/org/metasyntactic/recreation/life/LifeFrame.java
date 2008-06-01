package org.metasyntactic.recreation.life;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.Random;

public class LifeFrame extends javax.swing.JFrame {

    private final static Random random = new Random();
    private LifePanel lifePanel;
    private Universe universe;

    private JButton stepButton;
    private JSlider timeLineSlider;

    /**
     * Creates new form LifeFrame
     */
    public LifeFrame(Universe universe) {
        this.universe = universe;
        lifePanel = new LifePanel();
        lifePanel.setUniverse(universe);

        initComponents();
        pack();
    }

    private void initComponents() {
        stepButton = new JButton();
        timeLineSlider = new JSlider();

        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent evt) {
                exitForm(evt);
            }
        });

        stepButton.setText("Step");
        stepButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent evt) {
                stepActionPerformed(evt);
            }
        });

        JPanel southPanel = new JPanel(new BorderLayout());
        southPanel.add(stepButton, BorderLayout.EAST);
        southPanel.add(timeLineSlider, BorderLayout.CENTER);

        getContentPane().add(lifePanel, BorderLayout.CENTER);
        getContentPane().add(southPanel, BorderLayout.SOUTH);
    }

    private void stepActionPerformed(ActionEvent evt) {
        while (true) {
            universe = universe.step();
            lifePanel.setUniverse(universe);
            this.update(this.getGraphics());
        }
    }

    private void exitForm(WindowEvent evt) {
        System.exit(0);
    }

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        if (args.length != 2) {
            System.out.println(usage());
            System.exit(-1);
        }

        final int rows = Integer.parseInt(args[0]);
        final int columns = Integer.parseInt(args[1]);

        Node node = Leaf.emptyLeaf().push();
        double depth = Math.log(Math.max(rows, columns)) / Math.log(2);
        while (node.depth() < depth) {
            node = node.push();
        }

        Universe universe = new Universe(node);
        for (int y = 0; y < rows; y++) {
            for (int x = 0; x < columns; x++) {
                universe = universe.setValue(x, y, random.nextBoolean());
            }
        }

        new LifeFrame(universe).setVisible(true);
    }

    public static String usage() {
        return "java " + LifeFrame.class + " rows columns";
    }
}
