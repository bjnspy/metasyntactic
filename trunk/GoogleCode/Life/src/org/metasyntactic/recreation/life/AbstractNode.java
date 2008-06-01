package org.metasyntactic.recreation.life;

import org.apache.commons.collections.map.MultiValueMap;

import java.math.BigInteger;
import java.util.TreeMap;
import java.util.TreeSet;

public abstract class AbstractNode {
    protected static byte[] shortpop = new byte[65536];
    protected static byte[] liferules = new byte[65536];

    static {
        for (int i = 1; i < 65536; i++) {
            shortpop[i] = (byte) (shortpop[i & (i - 1)] + 1);
        }

        String standardRules = "b3s23";
        byte[] birth = new byte[10], health = new byte[10];

        boolean isBirth = false;
        for (int i = 0; i < standardRules.length(); i++) {
            char p = standardRules.charAt(i);
            if (p == 'b') {
                isBirth = true;
            } else if (p == 's') {
                isBirth = false;
            } else if (p >= '0' && p <= '9') {
                if (isBirth) {
                    birth[p - '0'] = 1;
                } else {
                    health[p - '0' + 1] = 1;
                }
            }
        }

        for (int i = 0; i < 4096; i = ((i | 0x888) + 1) & 0x1777) {
            liferules[i] = ((i & 0x20) != 0 ? health : birth)[shortpop[i]];
        }

        for (int i = 0; i < 65536; i++) {
            liferules[i] = (byte) ((1 & liferules[i & 0x777]) +
                    ((1 & liferules[(i >> 1) & 0x777]) << 1) +
                    ((1 & liferules[(i >> 4) & 0x777]) << 4) +
                    ((1 & liferules[(i >> 5) & 0x777]) << 5));
        }
    }

    public abstract int depth();

    public abstract Node push();

    public abstract boolean getValue(BigInteger x, BigInteger y);

    public abstract AbstractNode setValue(BigInteger x, BigInteger y, boolean value);

    Double coverage;

    public double coverage() {
        if (coverage == null) {
            coverage = coverageWorker();
        }

        return coverage;
    }

    protected abstract double coverageWorker();

    public abstract boolean isEmpty();

    public abstract AbstractNode canonicalize();

    public MultiValueMap getLiveLocations() {
        int xStart = 0, yStart = 0;
        MultiValueMap map = MultiValueMap.decorate(new TreeMap(), TreeSet.class);

        getLiveLocations(xStart, yStart, map);

        return map;
    }

    protected abstract int getLiveLocations(int xStart, int yStart, MultiValueMap map);
}