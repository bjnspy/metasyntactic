package org.metasyntactic.automata.parsers.expressions;

import org.metasyntactic.automata.parsers.Variable;
import org.metasyntactic.automata.parsers.Grammar;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class ChoiceExpression<V extends Variable> extends Expression<V> {
    private final List<Expression<V>> children;

    public ChoiceExpression(List<Expression<V>> children) {
        this.children = new ArrayList<Expression<V>>(children);
    }

    public <T> T accept(ExpressionVisitor<T, V> visitor) {
        return visitor.visit(this);
    }

    @Override
    protected void appendTo(StringBuilder builder) {
        if (children.size() == 2 && children.get(1) instanceof EmptyExpression) {
            Expression<V> expression = children.get(0);
            if (expression instanceof ChoiceExpression ||
                    expression instanceof SequenceExpression) {
                builder.append('(');
                expression.appendTo(builder);
                builder.append(')');
            } else {
                expression.appendTo(builder);
            }

            builder.append('*');
        } else {
            builder.append(children.get(0));
            for (int i = 1; i < children.size(); i++) {
                builder.append('/');
                builder.append(children.get(i));
            }
        }
    }

    public List<Expression<V>> getChildren() {
        return Collections.unmodifiableList(children);
    }

    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ChoiceExpression)) return false;

        ChoiceExpression that = (ChoiceExpression) o;

        if (!children.equals(that.children)) return false;

        return true;
    }

    public int hashCode() {
        return children.hashCode();
    }

    public MatchResult match(String input, int position, Grammar<V> grammar) {
        for (Expression<V> child : children) {
            MatchResult result = child.match(input, position, grammar);

            if (result.succeeded()) {
                return result;
            }
        }

        return new MatchResult(position, false);
    }
}
