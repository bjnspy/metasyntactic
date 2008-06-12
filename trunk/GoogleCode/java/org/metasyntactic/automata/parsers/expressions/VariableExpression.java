package org.metasyntactic.automata.parsers.expressions;

import org.metasyntactic.automata.parsers.Grammar;
import org.metasyntactic.automata.parsers.Rule;
import org.metasyntactic.automata.parsers.Variable;

public class VariableExpression<V extends Variable> extends Expression<V> {
    V variable;

    VariableExpression(V variable) {
        this.variable = variable;
    }

    public <T> T accept(ExpressionVisitor<T, V> visitor) {
        return visitor.visit(this);
    }

    public V getVariable() {
        return variable;
    }

    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof VariableExpression)) return false;

        VariableExpression that = (VariableExpression) o;

        if (!variable.equals(that.variable)) return false;

        return true;
    }

    public int hashCode() {
        return variable.hashCode();
    }

    protected void appendTo(StringBuilder builder) {
        builder.append(variable.getName());
    }

    public MatchResult match(String input, int position, Grammar<V> grammar) {
        Rule<V> rule = grammar.getRule(variable);
        return rule.getExpression().match(input, position, grammar);
    }
}
