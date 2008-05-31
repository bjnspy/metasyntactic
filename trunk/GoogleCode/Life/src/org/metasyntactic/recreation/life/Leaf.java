package org.metasyntactic.recreation.life;

import org.apache.commons.collections.map.MultiValueMap;

import java.math.BigInteger;

public class Leaf extends AbstractNode {
    char northWest, northEast, southWest, southEast;
    char oneGenerationLater, twoGenerationLater;

    private Leaf(int northWest, int northEast, int southWest, int southEast) {
        this((char) northWest, (char) northEast, (char) southWest, (char) southEast);
    }

    private Leaf(char northWest, char northEast, char southWest, char southEast) {
        this.northWest = northWest;
        this.northEast = northEast;
        this.southWest = southWest;
        this.southEast = southEast;

        short t00 = liferules[northWest],
                t01 = liferules[((northWest << 2) & 0xcccc) | ((northEast >> 2) & 0x3333)],
                t02 = liferules[northEast],
                t10 = liferules[((northWest << 8) & 0xff00) | ((southWest >> 8) & 0x00ff)],
                t11 = liferules[((northWest << 10) & 0xcc00) | ((northEast << 6) & 0x3300) |
                        ((southWest >> 6) & 0x00cc) | ((southEast >> 10) & 0x0033)],
                t12 = liferules[((northEast << 8) & 0xff00) | ((southEast >> 8) & 0x00ff)],
                t20 = liferules[southWest],
                t21 = liferules[((southWest << 2) & 0xcccc) | ((southEast >> 2) & 0x3333)],
                t22 = liferules[southEast];

        oneGenerationLater =
                (char) ((t00 << 15) | (t01 << 13) | ((t02 << 11) & 0x1000) |
                        ((t10 << 7) & 0x880) | (t11 << 5) | ((t12 << 3) & 0x110) |
                        ((t20 >>> 1) & 0x8) | (t21 >>> 3) | (t22 >>> 5));

        twoGenerationLater =
                (char) ((liferules[(t00 << 10) | (t01 << 8) | (t10 << 2) | t11] << 10) |
                        (liferules[(t01 << 10) | (t02 << 8) | (t11 << 2) | t12] << 8) |
                        (liferules[(t10 << 10) | (t11 << 8) | (t20 << 2) | t21] << 2) |
                        (liferules[(t11 << 10) | (t12 << 8) | (t21 << 2) | t22]));
    }

    public boolean isEmpty() {
        if (this == empty) {
            return true;
        }

        return northWest == 0 && northEast == 0 &&
                southWest == 0 && southEast == 0;
    }

    public static Leaf newLeaf(int northWest, int northEast, int southWest, int southEast) {
        if (northEast == 0 && northWest == 0 &&
                southEast == 0 && southWest == 0) {
            return empty;
        }
        Leaf leaf = new Leaf(northWest, northEast, southWest, southEast);

        return (Leaf) Universe.lookupNode(leaf);
    }

    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Leaf)) return false;

        Leaf leaf = (Leaf) o;

        if (northEast != leaf.northEast) return false;
        if (northWest != leaf.northWest) return false;
        if (southEast != leaf.southEast) return false;
        if (southWest != leaf.southWest) return false;

        return true;
    }

    public int hashCode() {
        int result;
        result = (int) northWest;
        result = 31 * result + (int) northEast;
        result = 31 * result + (int) southWest;
        result = 31 * result + (int) southEast;
        return result;
    }

    public int depth() {
        return 2;
    }

    private final static Leaf empty = new Leaf(0, 0, 0, 0);

    static {
        Universe.lookupNode(empty);
    }

    public static Leaf emptyLeaf() {
        return empty;
    }

    public Node push() {
        return Node.newNode(
                Leaf.newLeaf(0, 0, 0, northWest),
                Leaf.newLeaf(0, 0, northEast, 0),
                Leaf.newLeaf(0, southWest, 0, 0),
                Leaf.newLeaf(southEast, 0, 0, 0));
    }

    private final static BigInteger EIGHT = new BigInteger("8");

    public boolean getValue(BigInteger bigX, BigInteger bigY) {
        assert bigX.compareTo(BigInteger.ZERO) >= 0;
        assert bigX.compareTo(EIGHT) < 0;
        assert bigY.compareTo(BigInteger.ZERO) >= 0;
        assert bigY.compareTo(EIGHT) < 0;

        int x = bigX.intValue();
        int y = bigY.intValue();

        return getValue(x, y);
    }

    private boolean getValue(int x, int y) {
        char quadrant;
        int offsetX = x;
        int offsetY = y;

        if (offsetX >= 4) {
            offsetX -= 4;
        }

        if (offsetY >= 4) {
            offsetY -= 4;
        }

        offsetX = 3 - offsetX;
        offsetY = 3 - offsetY;

        if (x < 4) {
            if (y < 4) {
                quadrant = northWest;
            } else {
                quadrant = southWest;
            }
        } else {
            if (y < 4) {
                quadrant = northEast;
            } else {
                quadrant = southEast;
            }
        }

        int bit = offsetY * 4 + offsetX;
        return ((quadrant >>> bit) & 0x1) == 1;
    }

    public Leaf setValue(BigInteger bigX, BigInteger bigY, boolean value) {
        assert bigX.compareTo(BigInteger.ZERO) >= 0;
        assert bigX.compareTo(EIGHT) < 0;
        assert bigY.compareTo(BigInteger.ZERO) >= 0;
        assert bigY.compareTo(EIGHT) < 0;

        int x = bigX.intValue();
        int y = bigY.intValue();

        return setValue(x, y, value);
    }

    private Leaf setValue(int x, int y, boolean value) {
        int offsetX = x;
        int offsetY = y;

        if (offsetX >= 4) {
            offsetX -= 4;
        }

        if (offsetY >= 4) {
            offsetY -= 4;
        }

        offsetX = 3 - offsetX;
        offsetY = 3 - offsetY;

        char newNW = northWest, newNE = northEast,
                newSW = southWest, newSE = southEast;

        int bit = offsetY * 4 + offsetX;
        int mask = 1 << bit;
        if (value == false) {
            mask = ~mask;
        }

        if (x < 4) {
            if (y < 4) {
                newNW = setBit(value, mask, northWest);
            } else {
                newSW = setBit(value, mask, southWest);
            }
        } else {
            if (y < 4) {
                newNE = setBit(value, mask, northEast);
            } else {
                newSE = setBit(value, mask, southEast);
            }
        }

        return Leaf.newLeaf(newNW, newNE, newSW, newSE);
    }

    private char setBit(boolean value, int mask, char quadrant) {
        return (char) (value ? (quadrant | mask) : (quadrant & mask));
    }

    public double coverageWorker() {
        return (coverage(northWest) + coverage(northEast) +
                coverage(southWest) + coverage(southEast)) / 4.0;
    }

    private double coverage(char quadrant) {
        int count = 0;
        while (quadrant > 0) {
            count += quadrant & 0x1;
            quadrant >>= 1;
        }

        return (double) count / 4.0;
    }

    public Leaf canonicalize() {
        return newLeaf(northWest, northEast, southWest, southEast);
    }

    protected int getLiveLocations(int xStart, int yStart, MultiValueMap map) {
        final int heightWidth = 8;
        if (!isEmpty()) {
            for (int x = 0; x < heightWidth; x++) {
                for (int y = 0; y < heightWidth; y++) {
                    boolean value = getValue(x, y);

                    if (value) {
                        map.put(x + xStart, y + yStart);
                    }
                }
            }
        }

        return heightWidth;
    }
}