package org.metasyntactic.recreation.life;

import java.math.BigInteger;

public class Universe {
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
        this.root = root;
    }

    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();

        BigInteger widthHeight = TWO.pow(root.depth() + 1);

        printDashes(builder, widthHeight);
        builder.append('\n');

        for (BigInteger y = BigInteger.ZERO; y.compareTo(widthHeight) < 0; y = y.add(BigInteger.ONE)) {
            builder.append('|');

            for (BigInteger x = BigInteger.ZERO; x.compareTo(widthHeight) < 0; x = x.add(BigInteger.ONE)) {
                boolean b = root.getValue(x, y);

                builder.append(b ? '*' : ' ');
            }

            builder.append('|');
            builder.append('\n');
        }

        printDashes(builder, widthHeight);

        return builder.toString();
    }

    private void printDashes(StringBuilder builder, BigInteger widthHeight) {
        for (BigInteger y = BigInteger.ZERO; y.compareTo(widthHeight.add(TWO)) < 0; y = y.add(BigInteger.ONE)) {
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
        if (nextGeneration instanceof Leaf || ((Node)nextGeneration).expandsBeyondCenter()) {
            nextGeneration = nextGeneration.push();
        }

        return new Universe((Node)nextGeneration);
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
        while(true) {
            //System.out.println(u);
            u = u.step();
            i++;

            long now = System.currentTimeMillis();
            long diff = (now - start);
            double time = (double)diff / (double)i;
            System.out.println(time + "ms per step");
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
