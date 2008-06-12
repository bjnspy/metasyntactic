package org.metasyntactic.automata.parsers.expressions;

import org.metasyntactic.automata.parsers.Variable;
import org.metasyntactic.automata.parsers.Grammar;

public class NotExpression<V extends Variable> extends Expression<V> {
    private final Expression<V> expression;

    public NotExpression(Expression<V> expression) {
        this.expression = expression;
    }

    public <T> T accept(ExpressionVisitor<T, V> visitor) {
        return visitor.visit(this);
    }

    @Override
    protected void appendTo(StringBuilder builder) {
        if (expression instanceof NotExpression) {
            builder.append('&');
            ((NotExpression) expression).expression.appendTo(builder);
        } else {
            builder.append('!');

            String childString = expression.toString();

            if (expression instanceof ChoiceExpression ||
                    expression instanceof SequenceExpression) {
                builder.append('(');
                expression.appendTo(builder);
                builder.append(')');
            } else {
                expression.appendTo(builder);
            }
        }
    }

    public Expression<V> getExpression() {
        return expression;
    }

    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof NotExpression)) return false;

        NotExpression that = (NotExpression) o;

        if (!expression.equals(that.expression)) return false;

        return true;
    }

    public int hashCode() {
        return expression.hashCode();
    }

    public MatchResult match(String input, int position, Grammar grammar) {
        MatchResult result = expression.match(input, position, grammar);
        return new MatchResult(position, !result.succeeded());
    }
}
