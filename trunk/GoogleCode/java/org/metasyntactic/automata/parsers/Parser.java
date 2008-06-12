package org.metasyntactic.automata.parsers;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: Jun 11, 2008
 * Time: 10:05:29 PM
 * To change this template use File | Settings | File Templates.
 */
public class Parser {
    private final Grammar grammar;

    public Parser(Grammar grammar) {
        this.grammar = grammar;
    }

    public void Parse(String input) {
        grammar.getStartRule().getExpression().match(input, 0, grammar);
    }
}
