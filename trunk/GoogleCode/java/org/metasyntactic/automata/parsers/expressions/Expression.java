package org.metasyntactic.automata.parsers.expressions;

import org.metasyntactic.automata.parsers.Variable;
import org.metasyntactic.automata.parsers.Grammar;


public abstract class Expression<V extends Variable> {
    public abstract <T> T accept(ExpressionVisitor<T,V> visitor);

    @Override public String toString() {
        StringBuilder builder = new StringBuilder();

        this.appendTo(builder);

        return builder.toString();
    }

    protected abstract void appendTo(StringBuilder builder);

    public abstract MatchResult match(String input, int position, Grammar<V> grammar);
}