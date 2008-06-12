package org.metasyntactic.automata.parsers.expressions;

import org.metasyntactic.automata.parsers.Variable;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: Jun 11, 2008
 * Time: 9:10:00 PM
 * To change this template use File | Settings | File Templates.
 */
public interface ExpressionVisitor<T,V extends Variable> {
    T visit(ChoiceExpression<V> expression);
    T visit(EmptyExpression<V> expression);
    T visit(NotExpression<V> expression);
    T visit(RepititionExpression<V> expression);
    T visit(SequenceExpression<V> expression);
    T visit(TerminalExpression<V> expression);
    T visit(VariableExpression<V> expression);
}