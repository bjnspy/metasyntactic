package org.metasyntactic.recreation.life;

import org.apache.commons.collections.map.MultiValueMap;

import java.math.BigInteger;

public class Node extends AbstractNode {
    AbstractNode northWest, northEast, southWest, southEast;

    Node(AbstractNode northWest, AbstractNode northEast, AbstractNode southWest, AbstractNode southEast) {
        this.northWest = northWest;
        this.northEast = northEast;
        this.southWest = southWest;
        this.southEast = southEast;
    }

    Boolean expandsBeyondCenter;

    public boolean expandsBeyondCenter() {
        if (expandsBeyondCenter == null) {
            expandsBeyondCenter = expandsBeyondCenterWorker();
        }

        return expandsBeyondCenter;

    }

    private boolean expandsBeyondCenterWorker() {
        if (northWest instanceof Node) {
            return nodeExpandsBeyondCenter();
        } else {
            return leafExpandsBeyondCenter();
        }
    }

    private boolean leafExpandsBeyondCenter() {
        Leaf nw = (Leaf) northWest, ne = (Leaf) northEast,
                sw = (Leaf) southWest, se = (Leaf) southEast;

        return nw.getSouthWest() != 0 ||
                nw.getNorthWest() != 0 ||
                nw.getNorthEast() != 0 ||
                ne.getNorthWest() != 0 ||
                ne.getNorthEast() != 0 ||
                ne.getSouthEast() != 0 ||
                se.getNorthEast() != 0 ||
                se.getSouthEast() != 0 ||
                se.getSouthWest() != 0 ||
                sw.getSouthEast() != 0 ||
                sw.getSouthWest() != 0 ||
                sw.getNorthWest() != 0;
    }

    private boolean nodeExpandsBeyondCenter() {
        Node nw = (Node) northWest, ne = (Node) northEast,
                sw = (Node) southWest, se = (Node) southEast;

        return !nw.southWest.isEmpty() ||
                !nw.northWest.isEmpty() ||
                !nw.northEast.isEmpty() ||
                !ne.northWest.isEmpty() ||
                !ne.northEast.isEmpty() ||
                !ne.southEast.isEmpty() ||
                !se.northEast.isEmpty() ||
                !se.southEast.isEmpty() ||
                !se.southWest.isEmpty() ||
                !sw.southEast.isEmpty() ||
                !sw.southWest.isEmpty() ||
                !sw.northWest.isEmpty();
    }

    Boolean isEmpty;

    public boolean isEmpty() {
        if (isEmpty == null) {
            isEmpty = northWest.isEmpty() &&
                    northEast.isEmpty() &&
                    southWest.isEmpty() &&
                    southEast.isEmpty();
        }

        return isEmpty;
    }

    AbstractNode nextGeneration;

    public AbstractNode nextGeneration() {
        if (nextGeneration == null) {
            nextGeneration = nextGenerationWorker();
        }

        return nextGeneration;
    }

    protected AbstractNode nextGenerationWorker() {
        if (isEmpty()) {
            return Universe.emptyNode(depth() - 1);
        }
        if (northWest instanceof Node) {
            return nextNodeGeneration();
        } else {
            return nextLeafGeneration();
        }
    }

    private Leaf nextLeafGeneration() {
        Leaf nw = (Leaf) northWest, ne = (Leaf) northEast,
                sw = (Leaf) southWest, se = (Leaf) southEast;

        char t00 = nw.getOneGenerationLater();
        char t01 = Leaf.newLeaf(nw.getNorthEast(), ne.getNorthWest(), nw.getSouthEast(), ne.getSouthWest()).getOneGenerationLater();
        char t02 = ne.getOneGenerationLater();
        char t10 = Leaf.newLeaf(nw.getSouthWest(), nw.getSouthEast(), sw.getNorthWest(), sw.getNorthEast()).getOneGenerationLater();
        char t11 = Leaf.newLeaf(nw.getSouthEast(), ne.getSouthWest(), sw.getNorthEast(), se.getNorthWest()).getOneGenerationLater();
        char t12 = Leaf.newLeaf(ne.getSouthWest(), ne.getSouthEast(), se.getNorthWest(), se.getNorthEast()).getOneGenerationLater();
        char t20 = sw.getOneGenerationLater();
        char t21 = Leaf.newLeaf(sw.getNorthEast(), se.getNorthWest(), sw.getSouthEast(), se.getSouthWest()).getOneGenerationLater();
        char t22 = se.getOneGenerationLater();

        return Leaf.newLeaf(
                combine4(t00, t01, t10, t11),
                combine4(t01, t02, t11, t12),
                combine4(t10, t11, t20, t21),
                combine4(t11, t12, t21, t22));
    }

    private int combine4(char t00, char t01, char t10, char t11) {
        return (((t00 << 10) & 0xcc00) | ((t01 << 6) & 0x3300) |
                ((t10 >> 6) & 0xcc) | ((t11 >> 10) & 0x33));
    }

    private AbstractNode nextNodeGeneration() {
        Node nw = (Node) northWest, ne = (Node) northEast,
                sw = (Node) southWest, se = (Node) southEast;

        AbstractNode
                t00 = nw.nextGeneration(),
                t01 = Node.newNode(nw.northEast, ne.northWest, nw.southEast, ne.southWest).nextGeneration(),
                t02 = ne.nextGeneration(),
                t10 = Node.newNode(nw.southWest, nw.southEast, sw.northWest, sw.northEast).nextGeneration(),
                t11 = Node.newNode(nw.southEast, ne.southWest, sw.northEast, se.northWest).nextGeneration(),
                t12 = Node.newNode(ne.southWest, ne.southEast, se.northWest, se.northEast).nextGeneration(),
                t20 = sw.nextGeneration(),
                t21 = Node.newNode(sw.northEast, se.northWest, sw.southEast, se.southWest).nextGeneration(),
                t22 = se.nextGeneration();

        if (t00 instanceof Node) {
            return Node.newNode(
                    Node.newNode(((Node) t00).southEast, ((Node) t01).southWest, ((Node) t10).northEast, ((Node) t11).northWest),
                    Node.newNode(((Node) t01).southEast, ((Node) t02).southWest, ((Node) t11).northEast, ((Node) t12).northWest),
                    Node.newNode(((Node) t10).southEast, ((Node) t11).southWest, ((Node) t20).northEast, ((Node) t21).northWest),
                    Node.newNode(((Node) t11).southEast, ((Node) t12).southWest, ((Node) t21).northEast, ((Node) t22).northWest));
        } else {
            return Node.newNode(
                    Leaf.newLeaf(((Leaf) t00).getSouthEast(), ((Leaf) t01).getSouthWest(), ((Leaf) t10).getNorthEast(), ((Leaf) t11).getNorthWest()),
                    Leaf.newLeaf(((Leaf) t01).getSouthEast(), ((Leaf) t02).getSouthWest(), ((Leaf) t11).getNorthEast(), ((Leaf) t12).getNorthWest()),
                    Leaf.newLeaf(((Leaf) t10).getSouthEast(), ((Leaf) t11).getSouthWest(), ((Leaf) t20).getNorthEast(), ((Leaf) t21).getNorthWest()),
                    Leaf.newLeaf(((Leaf) t11).getSouthEast(), ((Leaf) t12).getSouthWest(), ((Leaf) t21).getNorthEast(), ((Leaf) t22).getNorthWest()));
        }
    }

    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Node)) return false;

        Node node = (Node) o;

        if (depth() != node.depth()) {
            return false;
        }
        if (northEast != node.northEast) return false;
        if (northWest != node.northWest) return false;
        if (southEast != node.southEast) return false;
        if (southWest != node.southWest) return false;

        return true;
    }

    private int hashCode;

    public int hashCode() {
        if (hashCode == 0) {
            int result = depth();
            result = 31 * result + System.identityHashCode(northWest);
            result = 31 * result + System.identityHashCode(northEast);
            result = 31 * result + System.identityHashCode(southWest);
            result = 31 * result + System.identityHashCode(southEast);
            hashCode = result;
        }

        return hashCode;
    }

    public static Node newNode(AbstractNode northWest, AbstractNode northEast,
                               AbstractNode southWest, AbstractNode southEast) {
        if (northWest.isEmpty() && northEast.isEmpty() && southEast.isEmpty() && southWest.isEmpty()) {
            return (Node) Universe.emptyNode(northEast.depth() + 1);
        }

        Node node = new Node(northWest, northEast, southWest, southEast);
        return (Node) Universe.lookupNode(node);
    }

    public int depth() {
        return 1 + northWest.depth();
    }

    public Node push() {
        AbstractNode empty = Universe.emptyNode(depth() - 1);

        return Node.newNode(
                Node.newNode(empty, empty, empty, northWest),
                Node.newNode(empty, empty, northEast, empty),
                Node.newNode(empty, southWest, empty, empty),
                Node.newNode(southEast, empty, empty, empty));
    }

    private final static BigInteger TWO = new BigInteger("2");

    public boolean getValue(BigInteger x, BigInteger y) {
        int depth = depth();
        BigInteger halfWidthHeight = TWO.pow(depth);
        BigInteger widthHeight = halfWidthHeight.multiply(TWO);

        assert x.compareTo(BigInteger.ZERO) >= 0;
        assert x.compareTo(widthHeight) < 0;
        assert y.compareTo(BigInteger.ZERO) >= 0;
        assert x.compareTo(widthHeight) < 0;

        if (x.compareTo(halfWidthHeight) < 0) {
            if (y.compareTo(halfWidthHeight) < 0) {
                return northWest.getValue(x, y);
            } else {
                return southWest.getValue(x, y.subtract(halfWidthHeight));
            }
        } else {
            if (y.compareTo(halfWidthHeight) < 0) {
                return northEast.getValue(x.subtract(halfWidthHeight), y);
            } else {
                return southEast.getValue(x.subtract(halfWidthHeight), y.subtract(halfWidthHeight));
            }
        }
    }

    public Node setValue(BigInteger x, BigInteger y, boolean value) {
        int depth = depth();
        BigInteger halfWidthHeight = TWO.pow(depth);
        BigInteger widthHeight = halfWidthHeight.multiply(TWO);

        if (x.compareTo(BigInteger.ZERO) < 0) {
            throw new IllegalArgumentException();
        }
        if (x.compareTo(widthHeight) >= 0) {
            throw new IllegalArgumentException(x + " >= " + widthHeight);
        }
        if (y.compareTo(BigInteger.ZERO) < 0) {
            throw new IllegalArgumentException();
        }
        if (x.compareTo(widthHeight) >= 0) {
            throw new IllegalArgumentException();
        }

        AbstractNode newNW = northWest, newNE = northEast,
                newSW = southWest, newSE = southEast;
        if (x.compareTo(halfWidthHeight) < 0) {
            if (y.compareTo(halfWidthHeight) < 0) {
                newNW = northWest.setValue(x, y, value);
            } else {
                newSW = southWest.setValue(x, y.subtract(halfWidthHeight), value);
            }
        } else {
            if (y.compareTo(halfWidthHeight) < 0) {
                newNE = northEast.setValue(x.subtract(halfWidthHeight), y, value);
            } else {
                newSE = southEast.setValue(x.subtract(halfWidthHeight), y.subtract(halfWidthHeight), value);
            }
        }

        return Node.newNode(newNW, newNE, newSW, newSE);
    }

    public double coverageWorker() {
        return (northWest.coverageWorker() + northEast.coverageWorker() +
                southWest.coverageWorker() + southEast.coverageWorker()) / 4;
    }

    public Node canonicalize() {
        return newNode(northWest, northEast, southWest, southEast);
    }

    protected int getLiveLocations(int xStart, int yStart, MultiValueMap map) {
        int heightWidth = northWest.getLiveLocations(xStart, yStart, map);

        northEast.getLiveLocations(xStart + heightWidth, yStart, map);
        southWest.getLiveLocations(xStart, yStart + heightWidth, map);
        southEast.getLiveLocations(xStart + heightWidth, yStart + heightWidth, map);

        return 2 * heightWidth;
    }
}