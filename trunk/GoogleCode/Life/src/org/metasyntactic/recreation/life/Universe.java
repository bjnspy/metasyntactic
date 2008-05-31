package org.metasyntactic.recreation.life;

import org.apache.commons.collections.map.MultiValueMap;

import java.math.BigInteger;
import java.util.HashMap;
import java.util.Map;

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

    private Universe(Node root) {
        universeAge++;
        if (universeAge % 5000 == 0) {
            flushUniverse();
            this.root = (Node) root.canonicalize();
        } else {
            this.root = root;
        }
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

        int widthHeight = TWO.pow(root.depth() + 1).intValue();

        MultiValueMap liveLocations = root.getLiveLocations();

        printDashes(builder, widthHeight);
        builder.append('\n');

        for (int y = 0; y < widthHeight; y++) {
            builder.append('|');

            for (int x = 0; x < widthHeight; x++) {
                boolean b = liveLocations.containsValue(x, y);

                builder.append(b ? '*' : ' ');
            }

            builder.append('|');
            builder.append('\n');
        }

        printDashes(builder, widthHeight);

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

        return new Universe((Node) nextGeneration);
    }

    public static void main(String... args) {
        Universe u = new Universe();
        System.out.println(u);

        //*
        u = u.setValue(10, 10, true);
        u = u.setValue(10, 11, true);
        u = u.setValue(10, 12, true);
        u = u.setValue(11, 12, true);
        u = u.setValue(12, 11, true);
/*/
        u = u.setValue(10, 10, true);
        u = u.setValue(11, 10, true);
        u = u.setValue(12, 10, true);
        u = u.setValue(9, 9, true);
        u = u.setValue(10, 9, true);
        u = u.setValue(11, 9, true);
//*/
        //for (int i = 0; i < 20; i++) {
        int i = 0;
        long start = System.currentTimeMillis();
        while (true) {
            //System.out.println(u);
            u = u.step();
            i++;

            if (i % 1000 == 0) {
                long now = System.currentTimeMillis();
                long diff = (now - start);
                double time = (double) diff / (double) i;
                System.out.println(i + " - " + time + "ms per step");
            }
        }

        /*
        for (println();= 8; x < 24; x++) {
            for (int y = 8; y < 24; y++) {
                u = u.setValue(x, y, true);
                System.out.println(u);
            }
        }
        */
    }
}
