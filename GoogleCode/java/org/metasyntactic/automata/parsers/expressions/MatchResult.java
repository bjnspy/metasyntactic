package org.metasyntactic.automata.parsers.expressions;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: Jun 11, 2008
 * Time: 10:17:25 PM
 * To change this template use File | Settings | File Templates.
 */
public class MatchResult {
    private final int position;
    private final boolean succeeded;

    public MatchResult(int position, boolean succeeded) {
        this.position = position;
        this.succeeded = succeeded;
    }

    public int getPosition() {
        return position;
    }

    public boolean succeeded() {
        return succeeded;
    }

    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof MatchResult)) return false;

        MatchResult that = (MatchResult) o;

        if (position != that.position) return false;
        if (succeeded != that.succeeded) return false;

        return true;
    }

    public int hashCode() {
        int result;
        result = position;
        result = 31 * result + (succeeded ? 1 : 0);
        return result;
    }
}
