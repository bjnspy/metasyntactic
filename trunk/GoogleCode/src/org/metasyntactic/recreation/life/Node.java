package org.metasyntactic.recreation.life;

import java.lang.ref.SoftReference;
import java.math.BigInteger;

public class Node extends AbstractNode {
    AbstractNode northWest, northEast, southWest, southEast;

    private Node(AbstractNode northWest, AbstractNode northEast, AbstractNode southWest, AbstractNode southEast) {
        this.northWest = northWest;
        this.northEast = northEast;
        this.southWest = southWest;
        this.southEast = southEast;

        if (!((northEast instanceof Node && northWest instanceof Node && southEast instanceof Node && southWest instanceof Node) ||
                (northEast instanceof Leaf && northWest instanceof Leaf && southEast instanceof Leaf && southWest instanceof Leaf))) {
            throw new IllegalArgumentException();
        }
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

        return nw.southWest != 0 ||
                nw.northWest != 0 ||
                nw.northEast != 0 ||
                ne.northWest != 0 ||
                ne.northEast != 0 ||
                ne.southEast != 0 ||
                se.northEast != 0 ||
                se.southEast != 0 ||
                se.southWest != 0 ||
                sw.southEast != 0 ||
                sw.southWest != 0 ||
                sw.northWest != 0;
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

    SoftReference<AbstractNode> cachedNextGeneration;

    public AbstractNode nextGeneration() {
        AbstractNode result;
        if (cachedNextGeneration == null || (result = cachedNextGeneration.get()) == null) {
            result = nextGenerationWorker();
            cachedNextGeneration = new SoftReference<AbstractNode>(result);
        }

        return result;
    }

    protected AbstractNode nextGenerationWorker() {
        if (northWest instanceof Node) {
            return nextNodeGeneration();
        } else {
            return nextLeafGeneration();
        }
    }

    private Leaf nextLeafGeneration() {
        Leaf nw = (Leaf) northWest, ne = (Leaf) northEast,
                sw = (Leaf) southWest, se = (Leaf) southEast;

        char t00 = nw.result1;
        char t01 = Leaf.newLeaf(nw.northEast, ne.northWest, nw.southEast, ne.southWest).result1;
        char t02 = ne.result1;
        char t10 = Leaf.newLeaf(nw.southWest, nw.southEast, sw.northWest, sw.northEast).result1;
        char t11 = Leaf.newLeaf(nw.southEast, ne.southWest, sw.northEast, se.northWest).result1;
        char t12 = Leaf.newLeaf(ne.southWest, ne.southEast, se.northWest, se.northEast).result1;
        char t20 = sw.result1;
        char t21 = Leaf.newLeaf(sw.northEast, se.northWest, sw.southEast, se.southWest).result1;
        char t22 = se.result1;

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
                    Leaf.newLeaf(((Leaf) t00).southEast, ((Leaf) t01).southWest, ((Leaf) t10).northEast, ((Leaf) t11).northWest),
                    Leaf.newLeaf(((Leaf) t01).southEast, ((Leaf) t02).southWest, ((Leaf) t11).northEast, ((Leaf) t12).northWest),
                    Leaf.newLeaf(((Leaf) t10).southEast, ((Leaf) t11).southWest, ((Leaf) t20).northEast, ((Leaf) t21).northWest),
                    Leaf.newLeaf(((Leaf) t11).southEast, ((Leaf) t12).southWest, ((Leaf) t21).northEast, ((Leaf) t22).northWest));
        }
    }

    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Node)) return false;

        Node node = (Node) o;

        if (northEast != node.northEast) return false;
        if (northWest != node.northWest) return false;
        if (southEast != node.southEast) return false;
        if (southWest != node.southWest) return false;

        return true;
    }

    private Integer hashCode;

    public int hashCode() {
        if (hashCode == null) {
            int result = northWest.hashCode();
            result = 31 * result + northEast.hashCode();
            result = 31 * result + southWest.hashCode();
            result = 31 * result + southEast.hashCode();
            hashCode = result;
        }

        return hashCode;
    }

    public static Node newNode(AbstractNode northWest, AbstractNode northEast,
                               AbstractNode southWest, AbstractNode southEast) {
        Node node = new Node(northWest, northEast, southWest, southEast);

        Node result = (Node) internMap.get(node);
        if (result == null) {
            result = node;
            internMap.put(result, result);
        }

        return result;
    }

    public int depth() {
        return 1 + northWest.depth();
    }

    public Node push() {
        AbstractNode empty = emptyNode(depth() - 1);

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
            throw new IllegalArgumentException();
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
}