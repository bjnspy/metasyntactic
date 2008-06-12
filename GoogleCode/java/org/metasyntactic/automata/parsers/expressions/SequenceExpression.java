package org.metasyntactic.automata.parsers.expressions;

import org.metasyntactic.automata.parsers.Variable;
import org.metasyntactic.automata.parsers.Grammar;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class SequenceExpression<V extends Variable> extends Expression<V> {
    private final List<Expression<V>> children;

    public SequenceExpression(List<Expression<V>> children) {
        this.children = new ArrayList<Expression<V>>(children);
    }

    public <T> T accept(ExpressionVisitor<T, V> visitor) {
        return visitor.visit(this);
    }

    protected void appendTo(StringBuilder builder) {
        for (Expression<V> e : children) {
            if (e instanceof ChoiceExpression) {
                builder.append('(');
                e.appendTo(builder);
                builder.append(')');
            } else {
                e.appendTo(builder);
            }
        }
    }

    public List<Expression<V>> getChildren() {
        return Collections.unmodifiableList(children);
    }

    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof SequenceExpression)) return false;

        SequenceExpression that = (SequenceExpression) o;

        if (!children.equals(that.children)) return false;

        return true;
    }

    public int hashCode() {
        return children.hashCode();
    }

    public MatchResult match(String input, int position, Grammar<V> grammar) {
        int currentPosition = position;

        for (Expression<V> child : children) {
            MatchResult result = child.match(input, currentPosition, grammar);

            if (!result.succeeded()) {
                return new MatchResult(position, false);
            }

            currentPosition = result.getPosition();
        }

        return new MatchResult(currentPosition, true);
    }
}
