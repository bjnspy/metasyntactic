package org.metasyntactic.automata.parsers;

import org.metasyntactic.automata.parsers.expressions.Expression;

public class Rule<V extends Variable> {
    private final V variable;
    private final Expression<V> expression;

    public Rule(V variable, Expression<V> expression) {
        this.variable = variable;
        this.expression = expression;
    }

    public V getVariable() {
        return variable;
    }

    public Expression<V> getExpression() {
        return expression;
    }

    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Rule)) return false;

        Rule rule = (Rule) o;

        if (!expression.equals(rule.expression)) return false;
        if (!variable.equals(rule.variable)) return false;

        return true;
    }

    public int hashCode() {
        int result;
        result = variable.hashCode();
        result = 31 * result + expression.hashCode();
        return result;
    }
}
