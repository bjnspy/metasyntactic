package org.metasyntactic.recreation.life;

import org.apache.commons.collections.map.MultiValueMap;

import java.io.*;
import java.math.BigInteger;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

public class Universe {
    private final static Map<AbstractNode, AbstractNode> internMap =
            new HashMap<AbstractNode, AbstractNode>();
    private final static Map<Integer, AbstractNode> emptyNodes = new HashMap<Integer, AbstractNode>();

    public static AbstractNode lookupNode(AbstractNode node) {
        AbstractNode result = internMap.get(node);
        if (result == null) {
            result = node;
            internMap.put(result, result);
        }

        return result;
    }

    public static AbstractNode emptyNode(int depth) {
        AbstractNode node = emptyNodes.get(depth);
        if (node == null) {
            if (depth == 2) {
                node = Leaf.emptyLeaf();
            } else {
                AbstractNode subNode = emptyNode(depth - 1);
                node = new Node(subNode, subNode, subNode, subNode);
                internMap.put(node, node);
            }

            emptyNodes.put(depth, node);
        }

        return node;
    }

    private static int universeAge;

    private final Node root;
    private final static BigInteger TWO = new BigInteger("2");

    private final static Node defaultEmptyNode =
            Node.newNode(
                    Leaf.emptyLeaf(),
                    Leaf.emptyLeaf(),
                    Leaf.emptyLeaf(),
                    Leaf.emptyLeaf());

    public Universe() {
        this(Node.newNode(defaultEmptyNode, defaultEmptyNode, defaultEmptyNode, defaultEmptyNode));
    }

    public Universe(AbstractNode node) {
        this(node instanceof Leaf ? node.push() : (Node) node);
    }

    private Universe(Node root) {
        universeAge++;
        if (universeAge % 5000 == 0) {
            flushUniverse();
            this.root = (Node) root.canonicalize();
        } else {
            this.root = root;
        }
    }

    public Node getRoot() {
        return root;
    }

    private void flushUniverse() {
        internMap.clear();
        for (AbstractNode node : emptyNodes.values()) {
            internMap.put(node, node);
        }
    }

    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();


        MultiValueMap liveLocations = root.getLiveLocations();
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
        printDashes(builder, width);
        builder.append('\n');

        for (int y = 0; y < height; y++) {
            builder.append('|');

            for (int x = 0; x < width; x++) {
                boolean b = liveLocations.containsValue(minX + x, minY + y);

                builder.append(b ? '*' : ' ');
            }

            builder.append('|');
            builder.append('\n');
        }

        printDashes(builder, width);

        return builder.toString();
    }

    private void printDashes(StringBuilder builder, int widthHeight) {
        for (int y = 0; y < widthHeight + 2; y++) {
            builder.append('-');
        }
    }

    public Universe setValue(int x, int y, boolean value) {
        return setValue(new BigInteger(String.valueOf(x)),
                new BigInteger(String.valueOf(y)), value);
    }

    public Universe setValue(BigInteger x, BigInteger y, boolean value) {
        return new Universe(root.setValue(x, y, value));
    }

    public Universe step() {
        Node node = root.push();

        AbstractNode nextGeneration = node.nextGeneration();
        if (nextGeneration instanceof Leaf || ((Node) nextGeneration).expandsBeyondCenter()) {
            nextGeneration = nextGeneration.push();
        }

        return new Universe(nextGeneration);
    }

    public static AbstractNode read(File file) throws IOException, ClassNotFoundException {
        if (file.getName().toLowerCase().endsWith(".lifematrix")) {
            return readLifeMatrix(file);
        } else if (file.getName().toLowerCase().endsWith(".lifetree")) {
            return readLifeTree(file);
        } else {
            throw new IllegalArgumentException();
        }
    }

    private static AbstractNode readLifeTree(File file) throws IOException, ClassNotFoundException {
        ObjectInputStream in = new ObjectInputStream(new FileInputStream(file));

        AbstractNode node = (AbstractNode) in.readObject();

        return node;
    }

    private static AbstractNode readLifeMatrix(File file) throws IOException {
        LineNumberReader in = new LineNumberReader(new FileReader(file));
        String line;

        int maxY = 0;
        int maxX = 0;

        for (int y = 0; (line = in.readLine()) != null; y++) {
            if (line.trim().equals("#")) {
                break;
            }

            if (y > maxY) {
                maxY = y;
            }

            maxX = Math.max(maxX, line.length());
        }

        AbstractNode node = Leaf.emptyLeaf();
        while (node.depth() < Math.log(Math.max(maxX, maxY)) + 1) {
            node = node.push();
        }

        in.close();
        in = new LineNumberReader(new FileReader(file));
        for (int y = 0; (line = in.readLine()) != null; y++) {
            if (line.trim().equals("#")) {
                break;
            }

            BigInteger bigY = new BigInteger(String.valueOf(y));

            for (int x = 0; x < line.length(); x++) {
                if (line.charAt(x) != ' ') {
                    node = node.setValue(new BigInteger(String.valueOf(x)), bigY, true);
                }
            }
        }

        return node;
    }
}
