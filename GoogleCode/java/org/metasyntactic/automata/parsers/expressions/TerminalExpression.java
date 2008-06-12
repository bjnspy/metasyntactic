package org.metasyntactic.automata.parsers.expressions;

import org.metasyntactic.automata.parsers.Grammar;
import org.metasyntactic.automata.parsers.Variable;

public class TerminalExpression<V extends Variable> extends Expression<V> {
    private final String terminal;

    TerminalExpression(String terminal) {
        this.terminal = terminal;

        if (terminal == null || terminal.length() == 0) {
            throw new IllegalArgumentException();
        }
    }

    public <T> T accept(ExpressionVisitor<T, V> visitor) {
        return visitor.visit(this);
    }

    public String getTerminal() {
        return terminal;
    }

    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof TerminalExpression)) return false;

        TerminalExpression that = (TerminalExpression) o;

        if (!terminal.equals(that.terminal)) return false;

        return true;
    }

    public int hashCode() {
        return terminal.hashCode();
    }

    protected void appendTo(StringBuilder builder) {
        builder.append(terminal);
    }

    public MatchResult match(String input, int position, Grammar<V> grammar) {
        if (position + terminal.length() <= input.length()) {
            if (terminal.equals(input.substring(position, terminal.length()))) {
                // match
                // return (someTree, position);
                return new MatchResult(position + terminal.length(), true);
            }
        }

        return new MatchResult(position, false);
    }
}
