package org.metasyntactic.common.base;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: Jun 18, 2008
 * Time: 3:06:57 PM
 * To change this template use File | Settings | File Templates.
 */
public class Preconditions {
    private Preconditions() {

    }

    public static void checkNotNull(Object value) {
        if (value == null) {
            throw new IllegalArgumentException();
        }
    }

    public static void checkArgument(boolean expression) {
        if (!expression) {
            throw new IllegalArgumentException();
        }
    }

    public static void checkContentsNotNull(Iterable collection) {
        checkNotNull(collection);
        for (Object child : collection) {
            if (child instanceof Iterable) {
                checkContentsNotNull((Iterable)child);
            } else {
                checkNotNull(child);
            }
        }
    }
}