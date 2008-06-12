package org.metasyntactic.automata.parsers.expressions;

import org.metasyntactic.automata.parsers.Variable;
import org.metasyntactic.automata.parsers.Grammar;

public class RepititionExpression<V extends Variable> extends Expression<V> {
    private final Expression<V> expression;

    public RepititionExpression(Expression<V> expression) {
        this.expression = expression;
    }

    public <T> T accept(ExpressionVisitor<T, V> visitor) {
        return visitor.visit(this);
    }

    protected void appendTo(StringBuilder builder) {
        if (expression instanceof ChoiceExpression ||
            expression instanceof SequenceExpression) {
            builder.append('(');
            expression.appendTo(builder);
            builder.append(')');
        } else {
            expression.appendTo(builder);
        }

        builder.append('*');
    }

    public Expression<V> getExpression() {
        return expression;
    }

    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof RepititionExpression)) return false;

        RepititionExpression that = (RepititionExpression) o;

        if (!expression.equals(that.expression)) return false;

        return true;
    }

    public int hashCode() {
        return expression.hashCode();
    }

    public MatchResult match(String input, int position, Grammar<V> grammar) {
        int currentPosition = position;

        while (true) {
            MatchResult result = expression.match(input, currentPosition, grammar);
            if (!result.succeeded()) {
                break;
            }

            currentPosition = result.getPosition();
        }

        return new MatchResult(currentPosition, true);
    }
}
