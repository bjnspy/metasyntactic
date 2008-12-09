// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.framework.parsers.packrat;

import org.metasyntactic.automata.compiler.framework.parsers.ActionMap;
import org.metasyntactic.automata.compiler.framework.parsers.Grammar;
import org.metasyntactic.automata.compiler.framework.parsers.SourceToken;
import org.metasyntactic.automata.compiler.framework.parsers.Token;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions.*;
import org.metasyntactic.collections.HashMultiMap;
import org.metasyntactic.collections.MultiMap;
import org.metasyntactic.common.base.Preconditions;
import org.metasyntactic.utilities.SetUtilities;

import java.util.*;

/**
 * Formally, a parsing expression grammar consists of: <ul> <li>A finite set N of nonterminal symbols.</li> <li>A finite
 * set ? of terminal symbols that is disjoint from N.</li> <li>A finite set P of parsing rules.</li> <li>A distinguished
 * variable S; the start rule for the grammar.  It must be an element of N.</li> </ul>
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public abstract class PackratGrammar<TTokenType> implements Grammar {
  private final Set<Rule> rules;
  private final Rule startRule;
  private final Map<String, Rule> variableToRuleMap = new IdentityHashMap<String, Rule>();
  protected boolean leftRecursive;

  public PackratGrammar(Rule startRule, Rule... remainingRules) {
    this(startRule, createSet(startRule, remainingRules));
  }

  private static Set<Rule> createSet(Rule rule, Rule... ruleArray) {
    Set<Rule> rules = new LinkedHashSet<Rule>();
    rules.add(rule);
    rules.addAll(Arrays.asList(ruleArray));
    return rules;
  }

  public PackratGrammar(Rule startRule, Set<Rule> rules) {
    Preconditions.checkNotNull(startRule);
    Preconditions.checkContentsNotNull(rules);
    Preconditions.checkArgument(rules.contains(startRule));

    this.rules = new LinkedHashSet<Rule>(rules);
    this.startRule = startRule;

    for (Rule rule : rules) {
      variableToRuleMap.put(rule.getVariable(), rule);
    }

    checkForMissingRules();
    checkForLeftRecursion();

    createSets();

    /*
    for (Rule rule : rules) {
      System.out.println("Rule     : " + rule);
      Collection<Integer> first = firstMap.get(rule.getVariable());
      Set<TTokenType> firstSet = new LinkedHashSet<TTokenType>();
      for (Integer i : first) {
        firstSet.add(getTokenFromType(i));
      }
      System.out.println("First set: " + firstSet);
      System.out.println();
    }
    */

    /*
    computeShortestDerivableTokenStreamMap();
    for (Rule rule : rules) {
      System.out.println(rule.getVariable());
      List<Integer> shortest = getShortestDerivableTokenStream(rule.getVariable());
      List<TTokenType> shortestList = new ArrayList<TTokenType>();
      for (Integer i : shortest) {
        shortestList.add(getTokenFromTerminal(i));
      }

      System.out.println("\t" + shortestList);
    }
    */

    /*
    computeShortestPrefixMap();

    for (Rule rule : rules) {
      for (int token : getTerminals()) {
        List<Integer> prefix = getShortestPrefix(rule.getVariable(), token);
        List<TTokenType> prefixList = null;
        if (prefix == null) {
          continue;
        }
        System.out.println("E(" + rule.getVariable() + ", " + getTokenFromTerminal(token) + ")");
        prefixList = new ArrayList<TTokenType>();
        for (int i : prefix) {
          prefixList.add(getTokenFromTerminal(i));
        }

        System.out.println("\t" + prefixList);
        System.out.println();
      }
    }
    */
  }

  public abstract TTokenType getTokenFromTerminal(int terminal);

  protected abstract Set<Integer> getTerminalsWorker();

  private Set<Integer> tokens;

  protected Set<Integer> getTerminals() {
    if (tokens == null) {
      tokens = getTerminalsWorker();
    }

    return tokens;
  }

  protected Map<String, Rule> getVariableToRuleMap() {
    return variableToRuleMap;
  }

  @Override public <T extends Token> AbstractPackratParser<T> createParser(List<SourceToken<T>> tokens) {
    return createParser(tokens, ActionMap.EMPTY_MAP);
  }

  @Override public <T extends Token> AbstractPackratParser<T> createParser(List<SourceToken<T>> tokens,
                                                                           ActionMap<T> map) {
    if (leftRecursive) {
      return new LeftRecursivePackratParser<T>(this, tokens, map);
    } else {
      return new PackratParser<T>(this, tokens, map);
    }
  }

  private void checkForLeftRecursion() {
    for (Rule rule : rules) {
      checkForLeftRecursion(rule);
    }
  }

  private final Set<String> nullableVariables = new LinkedHashSet<String>();
  private final Set<Expression> nullableExpressions = new LinkedHashSet<Expression>();

  private final Set<String> acceptsAnyToken = new LinkedHashSet<String>();
  private final MultiMap<String, Integer> firstMap = new HashMultiMap<String, Integer>();

  public boolean isNullable(String variable) {
    return nullableVariables.contains(variable);
  }

  public boolean acceptsAnyToken(String variable) {
    return acceptsAnyToken.contains(variable);
  }

  public boolean isFirstToken(String variable, Token token) {
    Collection<Integer> types = firstMap.get(variable);
    return types.contains(token.getType());
  }

  public Collection<Integer> getFirstTokens(String variable) {
    return firstMap.get(variable);
  }

  private void createSets() {
    createNullableSets();
    createFirstSets();
  }

  private void createFirstSets() {
    Set<Expression> acceptsAnyTokenExpression = new LinkedHashSet<Expression>();
    MultiMap<Expression, Integer> expresionToFirstTokens = new HashMultiMap<Expression, Integer>();

    boolean changed;

    do {
      changed = false;

      for (Rule rule : rules) {
        changed |= processFirstSets(rule, acceptsAnyTokenExpression, expresionToFirstTokens);
      }
    } while (changed);

    for (Rule rule : rules) {
      if (acceptsAnyTokenExpression.contains(rule.getExpression())) {
        acceptsAnyToken.add(rule.getVariable());
      }

      firstMap.putAll(rule.getVariable(), expresionToFirstTokens.get(rule.getExpression()));
    }
  }

  private boolean processFirstSets(Rule rule, final Set<Expression> acceptsAnyTokenExpression,
                                   final MultiMap<Expression, Integer> expressionToFirstTokens) {
    return rule.getExpression().accept(new ExpressionVisitor<Object, Boolean>() {
      @Override public Boolean visit(EmptyExpression emptyExpression) {
        return false;
      }

      @Override public Boolean visit(CharacterExpression characterExpression) {
        return false;
      }

      @Override public Boolean visit(TerminalExpression terminalExpression) {
        return false;
      }

      @Override public Boolean visit(VariableExpression variableExpression) {
        Rule rule = getRule(variableExpression.getVariable());
        Expression child = rule.getExpression();

        return addChildSetsToParent(variableExpression, child, false);
      }

      private boolean process(Expression parent, Expression child) {
        boolean changed = child.accept(this);

        changed = addChildSetsToParent(parent, child, changed);

        return changed;
      }

      private boolean addChildSetsToParent(Expression parent, Expression child, boolean changed) {
        if (acceptsAnyTokenExpression.contains(child)) {
          changed |= acceptsAnyTokenExpression.add(parent);
        }

        changed |= expressionToFirstTokens.putAll(parent, expressionToFirstTokens.get(child));
        return changed;
      }

      @Override public Boolean visit(DelimitedSequenceExpression sequenceExpression) {
        boolean changed = process(sequenceExpression, sequenceExpression.getElement());
        if (nullableExpressions.contains(sequenceExpression.getElement())) {
          changed |= process(sequenceExpression, sequenceExpression.getDelimiter());
        }
        return changed;
      }

      @Override public Boolean visit(SequenceExpression sequenceExpression) {
        boolean changed = false;

        for (Expression child : sequenceExpression.getChildren()) {
          changed |= process(sequenceExpression, child);

          if (!nullableExpressions.contains(child)) {
            break;
          }
        }

        return changed;
      }

      @Override public Boolean visit(ChoiceExpression choiceExpression) {
        boolean changed = false;

        for (Expression child : choiceExpression.getChildren()) {
          changed |= process(choiceExpression, child);
        }

        return changed;
      }

      @Override public Boolean visit(NotExpression notExpression) {
        return acceptsAnyTokenExpression.add(notExpression);
      }

      @Override public Boolean visit(RepetitionExpression repetitionExpression) {
        return process(repetitionExpression, repetitionExpression.getChild());
      }

      @Override public Boolean visit(FunctionExpression<Object> functionExpression) {
        return acceptsAnyTokenExpression.add(functionExpression);
      }

      @Override public Boolean visit(OneOrMoreExpression oneOrMoreExpression) {
        return process(oneOrMoreExpression, oneOrMoreExpression.getChild());
      }

      @Override public Boolean visit(TokenExpression tokenExpression) {
        return expressionToFirstTokens.putAll(tokenExpression, Collections.singleton(
            tokenExpression.getToken().getType()));
      }

      @Override public Boolean visit(TypeExpression typeExpression) {
        return expressionToFirstTokens.putAll(typeExpression, typeExpression.getTypes());
      }

      @Override public Boolean visit(OptionalExpression optionalExpression) {
        return process(optionalExpression, optionalExpression.getChild());
      }
    });
  }

  private void createNullableSets() {
    boolean changed;
    do {
      changed = false;

      for (Rule rule : rules) {
        if (!nullableVariables.contains(rule.getVariable())) {
          if (isNullable(rule)) {
            nullableVariables.add(rule.getVariable());
            changed = true;
          }
        }
      }
    } while (changed);
  }

  private boolean isNullable(Rule rule) {
    return rule.getExpression().accept(new NullableExpressionVisitor());
  }

  private void checkForMissingRules() {
    for (Rule rule : rules) {
      rule.getExpression().accept(new RecursionExpressionVisitor() {
        @Override public void visit(VariableExpression expression) {
          if (!variableToRuleMap.containsKey(expression.getVariable())) {
            throw new IllegalArgumentException("No rule found with the variable: " + expression.getVariable());
          }
        }
      });
    }
  }

  private void checkForLeftRecursion(Rule rule) {
    Queue<Rule> rulesStack = Collections.asLifoQueue(new ArrayDeque<Rule>());
    checkForLeftRecursion(rule, rulesStack);
  }

  private void checkForLeftRecursion(Rule rule, final Queue<Rule> rulesStack) {
    if (rulesStack.contains(rule)) {
      leftRecursive = true;
      return;
    }

    rulesStack.offer(rule);

    rule.getExpression().accept(new LeftRecursionExpressionVisitor(rulesStack));

    rulesStack.remove();
  }

  public Set<Rule> getRules() {
    return Collections.unmodifiableSet(rules);
  }

  public Rule getStartRule() {
    return startRule;
  }

  public Rule getRule(String variable) {
    return variableToRuleMap.get(variable);
  }

  @Override public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof PackratGrammar)) {
      return false;
    }

    PackratGrammar grammar = (PackratGrammar) o;

    if (!rules.equals(grammar.rules)) {
      return false;
    }
    if (!startRule.equals(grammar.startRule)) {
      return false;
    }

    return true;
  }

  @Override public int hashCode() {
    int result;
    result = rules.hashCode();
    result = 31 * result + startRule.hashCode();
    return result;
  }

  @Override public String toString() {
    StringBuilder builder = new StringBuilder("(Grammar ");
    builder.append(getStartRule());
    builder.append(" (");

    for (Rule rule : getRules()) {
      builder.append("\n\t");
      builder.append(rule);
    }

    builder.append("))");

    return builder.toString();
  }

  private class LeftRecursionExpressionVisitor implements ExpressionVoidVisitor {
    private final Queue<Rule> rulesStack;

    public LeftRecursionExpressionVisitor(Queue<Rule> rulesStack) {
      this.rulesStack = rulesStack;
    }

    @Override public void visit(EmptyExpression emptyExpression) { }

    @Override public void visit(CharacterExpression characterExpression) { }

    @Override public void visit(TerminalExpression terminalExpression) { }

    @Override public void visit(FunctionExpression functionExpression) { }

    @Override public void visit(TokenExpression tokenExpression) { }

    @Override public void visit(TypeExpression typeExpression) { }

    @Override public void visit(VariableExpression variableExpression) {
      checkForLeftRecursion(getRule(variableExpression.getVariable()), rulesStack);
    }

    @Override public void visit(DelimitedSequenceExpression sequenceExpression) {
      sequenceExpression.getElement().accept(this);
    }

    @Override public void visit(SequenceExpression sequenceExpression) {
      sequenceExpression.getChildren()[0].accept(this);
    }

    @Override public void visit(ChoiceExpression choiceExpression) {
      for (Expression child : choiceExpression.getChildren()) {
        child.accept(this);
      }
    }

    @Override public void visit(NotExpression notExpression) {
      notExpression.getChild().accept(this);
    }

    @Override public void visit(RepetitionExpression repetitionExpression) {
      repetitionExpression.getChild().accept(this);
    }

    @Override public void visit(OneOrMoreExpression oneOrMoreExpression) {
      oneOrMoreExpression.getChild().accept(this);
    }

    @Override public void visit(OptionalExpression optionalExpression) {
      optionalExpression.getChild().accept(this);
    }
  }

  private class NullableExpressionVisitor implements ExpressionVisitor<Object, Boolean> {
    @Override public Boolean visit(EmptyExpression emptyExpression) {
      nullableExpressions.add(emptyExpression);
      return true;
    }

    @Override public Boolean visit(TerminalExpression terminalExpression) {
      return false;
    }

    @Override public Boolean visit(CharacterExpression characterExpression) {
      return false;
    }

    @Override public Boolean visit(VariableExpression variableExpression) {
      if (nullableVariables.contains(variableExpression.getVariable())) {
        nullableExpressions.add(variableExpression);
        return true;
      }

      return false;
    }

    @Override public Boolean visit(DelimitedSequenceExpression sequenceExpression) {
      return sequenceExpression.getElement().accept(this);
    }

    @Override public Boolean visit(SequenceExpression sequenceExpression) {
      boolean result = true;

      for (Expression child : sequenceExpression.getChildren()) {
        if (!child.accept(this)) {
          result = false;
        }
      }

      if (result) {
        nullableExpressions.add(sequenceExpression);
      }

      return result;
    }

    @Override public Boolean visit(ChoiceExpression choiceExpression) {
      boolean result = false;

      for (Expression child : choiceExpression.getChildren()) {
        if (child.accept(this)) {
          result = true;
        }
      }

      if (result) {
        nullableExpressions.add(choiceExpression);
      }

      return result;
    }

    public Boolean visit(OptionalExpression optionalExpression) {
      nullableExpressions.add(optionalExpression);
      return true;
    }

    @Override public Boolean visit(NotExpression notExpression) {
      nullableExpressions.add(notExpression);
      return true;
    }

    @Override public Boolean visit(RepetitionExpression repetitionExpression) {
      nullableExpressions.add(repetitionExpression);
      return true;
    }

    @Override public Boolean visit(FunctionExpression<Object> functionExpression) {
      if (functionExpression.isNullable()) {
        nullableExpressions.add(functionExpression);
        return true;
      }

      return false;
    }

    @Override public Boolean visit(OneOrMoreExpression oneOrMoreExpression) {
      if (oneOrMoreExpression.getChild().accept(this)) {
        nullableExpressions.add(oneOrMoreExpression);
        return true;
      }

      return false;
    }

    @Override public Boolean visit(TokenExpression tokenExpression) {
      return false;
    }

    @Override public Boolean visit(TypeExpression typeExpression) {
      return false;
    }
  }

  private Map<Expression, List<Integer>> shortestDerivableTokenStreamMap;

  private List<Integer> getShortestDerivableTokenStream(Expression expression) {
    return shortestDerivableTokenStreamMap.get(expression);
  }

  public List<Integer> getShortestDerivableTokenStream(String variable) {
    computeShortestDerivableTokenStreamMap();

    return getShortestDerivableTokenStream(variableToRuleMap.get(variable).getExpression());
  }

  private void computeShortestDerivableTokenStreamMap() {
    if (shortestDerivableTokenStreamMap != null) {
      return;
    }
    shortestDerivableTokenStreamMap = new LinkedHashMap<Expression, List<Integer>>();

    boolean changed;
    do {
      changed = false;
      for (Rule rule : rules) {
        Expression expression = rule.getExpression();
        List<Integer> oldTokenStream = shortestDerivableTokenStreamMap.get(expression);
        List<Integer> newTokenStream = computeShortestDerivableTokenStream(expression);
        if (oldTokenStream == null || newTokenStream.size() < oldTokenStream.size()) {
          changed = true;
          shortestDerivableTokenStreamMap.put(expression, newTokenStream);
        }
      }
    } while (changed);
  }

  private List<Integer> computeShortestDerivableTokenStream(Expression expression) {
    List<Integer> result = expression.accept(new ShortestDerivableTokenStreamVisitor());
    shortestDerivableTokenStreamMap.put(expression, result);
    return result;
  }

  private class ShortestDerivableTokenStreamVisitor implements ExpressionVisitor<Object, List<Integer>> {
    public List<Integer> visit(EmptyExpression emptyExpression) {
      return Collections.emptyList();
    }

    public List<Integer> visit(CharacterExpression characterExpression) {
      throw new RuntimeException("NYI");
    }

    public List<Integer> visit(TerminalExpression terminalExpression) {
      throw new RuntimeException("NYI");
    }

    public List<Integer> visit(VariableExpression variableExpression) {
      return getShortestDerivableTokenStream(variableExpression.getVariable());
    }

    public List<Integer> visit(DelimitedSequenceExpression sequenceExpression) {
      return computeShortestDerivableTokenStream(sequenceExpression.getElement());
    }

    public List<Integer> visit(SequenceExpression sequenceExpression) {
      List<Integer> result = new ArrayList<Integer>();

      for (Expression child : sequenceExpression.getChildren()) {
        List<Integer> childResult = computeShortestDerivableTokenStream(child);
        if (childResult == null) {
          return null;
        }

        result.addAll(childResult);
      }

      return result;
    }

    public List<Integer> visit(ChoiceExpression choiceExpression) {
      List<Integer> result = null;

      for (Expression child : choiceExpression.getChildren()) {
        List<Integer> childResult = computeShortestDerivableTokenStream(child);
        if (childResult != null) {
          if (result == null || childResult.size() < result.size()) {
            result = childResult;
          }
        }
      }

      return result;
    }

    public List<Integer> visit(OptionalExpression optionalExpression) {
      return Collections.emptyList();
    }

    public List<Integer> visit(NotExpression notExpression) {
      return Collections.emptyList();
    }

    public List<Integer> visit(RepetitionExpression repetitionExpression) {
      return Collections.emptyList();
    }

    public List<Integer> visit(FunctionExpression<Object> functionExpression) {
      return functionExpression.getShortestDerivableTokenStream();
    }

    public List<Integer> visit(OneOrMoreExpression oneOrMoreExpression) {
      return computeShortestDerivableTokenStream(oneOrMoreExpression.getChild());
    }

    public List<Integer> visit(TokenExpression tokenExpression) {
      return Collections.singletonList(tokenExpression.getToken().getType());
    }

    public List<Integer> visit(TypeExpression typeExpression) {
      return Collections.singletonList(SetUtilities.any(typeExpression.getTypes()));
    }
  }

  private Map<Expression, Map<Integer, List<Integer>>> shortestPrefixMap;

  protected abstract double prefixCost(List<Integer> tokens);

  private List<Integer> getShortestPrefix(Expression expression, int token) {
    Map<Integer, List<Integer>> map = shortestPrefixMap.get(expression);
    if (map == null) {
      map = new LinkedHashMap<Integer, List<Integer>>();
      shortestPrefixMap.put(expression, map);
    }

    return map.get(token);
  }

  public List<Integer> getShortestPrefix(String variable, int token) {
    computeShortestPrefixMap();

    return shortestPrefixMap.get(variableToRuleMap.get(variable).getExpression()).get(token);
  }

  private void computeShortestPrefixMap() {
    if (shortestPrefixMap != null) {
      return;
    }
    computeShortestDerivableTokenStreamMap();
    shortestPrefixMap = new LinkedHashMap<Expression, Map<Integer, List<Integer>>>();

    for (Rule rule : rules) {
      shortestPrefixMap.put(getVariableToRuleMap().get(rule.getVariable()).getExpression(),
                            new LinkedHashMap<Integer, List<Integer>>());
    }

    boolean changed;
    do {
      changed = false;
      for (Rule rule : rules) {
        for (int token : getTerminals()) {
          TTokenType terminal = getTokenFromTerminal(token);

          Expression expression = rule.getExpression();
          List<Integer> oldTokenStream = getShortestPrefix(expression, token);
          List<Integer> newTokenStream = computeShortestPrefix(expression, token);

          if (prefixCost(newTokenStream) < prefixCost(oldTokenStream)) {
              changed = true;
              shortestPrefixMap.get(expression).put(token, newTokenStream);
/*
              System.out.println("E(" + rule.getVariable() + ", " + terminal + ")");
              List<TTokenType> prefixList = new ArrayList<TTokenType>();
              for (int i : newTokenStream) {
                prefixList.add(getTokenFromTerminal(i));
              }

              System.out.println("\t" + prefixList);
              System.out.println();
              */
          }
        }
      }
    } while (changed);
  }

  private List<Integer> computeShortestPrefix(Expression expression, int token) {
    List<Integer> result = expression.accept(new ShortestPrefixVisitor(token));
    Map<Integer, List<Integer>> map = shortestPrefixMap.get(expression);
    if (map == null) {
      map = new LinkedHashMap<Integer, List<Integer>>();
      shortestPrefixMap.put(expression, map);
    }
    map.put(token, result);
    return result;
  }

  private class ShortestPrefixVisitor implements ExpressionVisitor<Object, List<Integer>> {
    private final int token;

    public ShortestPrefixVisitor(int token) {
      this.token = token;
    }

    public List<Integer> visit(EmptyExpression emptyExpression) {
      return null;
    }

    public List<Integer> visit(CharacterExpression characterExpression) {
      throw new RuntimeException("NYI");
    }

    public List<Integer> visit(TerminalExpression terminalExpression) {
      throw new RuntimeException("NYI");
    }

    public List<Integer> visit(VariableExpression variableExpression) {
      return getShortestPrefix(variableExpression.getVariable(), token);
    }

    public List<Integer> visit(DelimitedSequenceExpression sequenceExpression) {
      List<Integer> result = computeShortestPrefix(sequenceExpression.getElement(), token);
      if (result != null) {
        return result;
      }

      result = computeShortestPrefix(sequenceExpression.getDelimiter(), token);
      if (result != null) {
        // say we have the delimited sequence:   a, b, c
        // and the token is ','
        // Then the shortest prefix will be: 'a,'
        // so we tack on the shortest deriable string of our element type
        // and then add on the delimiter
        List<Integer> list = new ArrayList<Integer>();
        list.addAll(getShortestDerivableTokenStream(sequenceExpression.getElement()));
        list.addAll(result);
        return list;
      }

      return null;
    }

    public List<Integer> visit(SequenceExpression sequenceExpression) {
      // find the first child that can derive this token
      final Expression[] children = sequenceExpression.getChildren();
      for (int i = 0; i < children.length; i++) {
        List<Integer> result = computeShortestPrefix(children[i], token);
        if (result != null) {
          // add all the derivable strings in the children before hte match
          List<Integer> list = new ArrayList<Integer>();
          for (int j = 0; j < i; j++) {
            list.addAll(getShortestDerivableTokenStream(children[j]));
          }
          list.addAll(result);
          return list;
        }
      }

      return null;
    }

    public List<Integer> visit(ChoiceExpression choiceExpression) {
      List<Integer> result = null;
      for (Expression child : choiceExpression.getChildren()) {
        List<Integer> list = computeShortestPrefix(child, token);
        if (prefixCost(list) < prefixCost(result)) {
            result = list;
        }
      }
      return result;
    }

    public List<Integer> visit(OptionalExpression optionalExpression) {
      return null;
    }

    public List<Integer> visit(NotExpression notExpression) {
      return null;
    }

    public List<Integer> visit(RepetitionExpression repetitionExpression) {
      return computeShortestPrefix(repetitionExpression.getChild(), token);
    }

    public List<Integer> visit(FunctionExpression<Object> functionExpression) {
      return functionExpression.getShortestPrefix(token);
    }

    public List<Integer> visit(OneOrMoreExpression oneOrMoreExpression) {
      return computeShortestPrefix(oneOrMoreExpression.getChild(), token);
    }

    public List<Integer> visit(TokenExpression tokenExpression) {
      if (tokenExpression.getToken().getType() == token) {
        return Collections.emptyList();
      } else {
        return null;
      }
    }

    public List<Integer> visit(TypeExpression typeExpression) {
      if (typeExpression.getTypes().contains(token)) {
        return Collections.emptyList();
      } else {
        return null;
      }
    }
  }
}
