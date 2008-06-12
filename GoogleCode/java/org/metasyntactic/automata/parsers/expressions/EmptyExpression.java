package org.metasyntactic.automata.parsers.expressions;

import org.metasyntactic.automata.parsers.Variable;
import org.metasyntactic.automata.parsers.Grammar;

public class EmptyExpression<V extends Variable> extends Expression<V> {
    public static final EmptyExpression instance = new EmptyExpression();

    private EmptyExpression() {

    }

    public <T> T accept(ExpressionVisitor<T, V> visitor) {
        return visitor.visit(this);
    }

    @Override protected void appendTo(StringBuilder builder) {
        builder.append("e'");
    }

    public MatchResult match(String input, int position, Grammar<V> grammar) {
        return new MatchResult(position, true);
    }
}