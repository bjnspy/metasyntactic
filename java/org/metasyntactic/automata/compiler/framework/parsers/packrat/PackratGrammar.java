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

import java.util.*;

/**
 * Formally, a parsing expression grammar consists of: <ul> <li>A finite set N of nonterminal symbols.</li> <li>A finite
 * set ? of terminal symbols that is disjoint from N.</li> <li>A finite set P of parsing rules.</li> <li>A distinguished
 * variable S; the start rule for the grammar.  It must be an element of N.</li> </ul>
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class PackratGrammar implements Grammar {
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

    computeShortestDerivableTokenStreamMap();
    for (Rule rule : rules) {
      System.out.println(rule.getVariable());
      System.out.println("\t" + getShortestDerivableTokenStream(rule.getVariable()));
    }
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
  private final MultiMap<String, Token> firstTokenMap = new HashMultiMap<String, Token>();
  private final MultiMap<String, Integer> firstTypeMap = new HashMultiMap<String, Integer>();

  public boolean isNullable(String variable) {
    return nullableVariables.contains(variable);
  }

  public boolean acceptsAnyToken(String variable) {
    return acceptsAnyToken.contains(variable);
  }

  public boolean isFirstToken(String variable, Token token) {
    Collection<Token> tokens = firstTokenMap.get(variable);
    return tokens != null && tokens.contains(token);
  }

  public boolean isFirstType(String variable, Token token) {
    Collection<Integer> types = firstTypeMap.get(variable);
    return types != null && types.contains(token.getType());
  }

  private void createSets() {
    createNullableSets();
    createFirstSets();
  }

  private void createFirstSets() {
    Set<Expression> acceptsAnyTokenExpression = new LinkedHashSet<Expression>();
    MultiMap<Expression, Token> expresionToFirstTokens = new HashMultiMap<Expression, Token>();
    MultiMap<Expression, Integer> expressionToFirstTypes = new HashMultiMap<Expression, Integer>();

    boolean changed;

    do {
      changed = false;

      for (Rule rule : rules) {
        changed |= processFirstSets(rule, acceptsAnyTokenExpression, expresionToFirstTokens, expressionToFirstTypes);
      }
    } while (changed);

    for (Rule rule : rules) {
      if (acceptsAnyTokenExpression.contains(rule.getExpression())) {
        acceptsAnyToken.add(rule.getVariable());
      }

      firstTokenMap.putAll(rule.getVariable(), expresionToFirstTokens.get(rule.getExpression()));
      firstTypeMap.putAll(rule.getVariable(), expressionToFirstTypes.get(rule.getExpression()));
    }
  }

  private boolean processFirstSets(Rule rule, final Set<Expression> acceptsAnyTokenExpression,
                                   final MultiMap<Expression, Token> expresionToFirstTokens,
                                   final MultiMap<Expression, Integer> expressionToFirstTypes) {
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

        changed |= expresionToFirstTokens.putAll(parent, expresionToFirstTokens.get(child));
        changed |= expressionToFirstTypes.putAll(parent, expressionToFirstTypes.get(child));
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
        return expresionToFirstTokens.putAll(tokenExpression, Collections.singleton(tokenExpression.getToken()));
      }

      @Override public Boolean visit(TypeExpression typeExpression) {
        //return expressionToFirstTypes.putAll(typeExpression, Collections.singleton(typeExpression.getType()));
        return expressionToFirstTypes.putAll(typeExpression, Collections.singleton(typeExpression.getTypeValue()));
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

  private Map<Expression, List<Token>> shortestDerivableTokenStreamMap;

  private List<Token> getShortestDerivableTokenStream(Expression expression) {
    return shortestDerivableTokenStreamMap.get(expression);
  }

  public List<Token> getShortestDerivableTokenStream(String variable) {
    computeShortestDerivableTokenStreamMap();

    return shortestDerivableTokenStreamMap.get(variableToRuleMap.get(variable).getExpression());
  }

  private void computeShortestDerivableTokenStreamMap() {
    if (shortestDerivableTokenStreamMap != null) {
      return;
    }
    shortestDerivableTokenStreamMap = new LinkedHashMap<Expression, List<Token>>();

    boolean changed;
    do {
      changed = false;
      for (Rule rule : rules) {
        Expression expression = rule.getExpression();
        List<Token> oldTokenStream = shortestDerivableTokenStreamMap.get(expression);
        List<Token> newTokenStream = computeShortestDerivableTokenStream(expression);
        if (oldTokenStream == null || newTokenStream.size() < oldTokenStream.size()) {
          changed = true;
          shortestDerivableTokenStreamMap.put(expression, newTokenStream);
        }
      }
    } while (changed);
  }

  private List<Token> computeShortestDerivableTokenStream(Expression expression) {
    List<Token> result = expression.accept(new ShortestDerivableTokenStreamVisitor());
    shortestDerivableTokenStreamMap.put(expression, result);
    return result;
  }

  private class ShortestDerivableTokenStreamVisitor implements ExpressionVisitor<Object, List<Token>> {
    public List<Token> visit(EmptyExpression emptyExpression) {
      return Collections.emptyList();
    }

    public List<Token> visit(CharacterExpression characterExpression) {
      throw new RuntimeException("NYI");
    }

    public List<Token> visit(TerminalExpression terminalExpression) {
      throw new RuntimeException("NYI");
    }

    public List<Token> visit(VariableExpression variableExpression) {
      return getShortestDerivableTokenStream(variableExpression.getVariable());
    }

    public List<Token> visit(DelimitedSequenceExpression sequenceExpression) {
      return computeShortestDerivableTokenStream(sequenceExpression.getElement());
    }

    public List<Token> visit(SequenceExpression sequenceExpression) {
      List<Token> result = new ArrayList<Token>();

      for (Expression child : sequenceExpression.getChildren()) {
        List<Token> childResult = computeShortestDerivableTokenStream(child);
        if (childResult == null) {
          return null;
        }

        result.addAll(childResult);
      }

      return result;
    }

    public List<Token> visit(ChoiceExpression choiceExpression) {
      List<Token> result = null;

      for (Expression child : choiceExpression.getChildren()) {
        List<Token> childResult = computeShortestDerivableTokenStream(child);
        if (childResult != null) {
          if (result == null || childResult.size() < result.size()) {
            result = childResult;
          }
        }
      }

      return result;
    }

    public List<Token> visit(NotExpression notExpression) {
      return Collections.emptyList();
    }

    public List<Token> visit(RepetitionExpression repetitionExpression) {
      return Collections.emptyList();
    }

    public List<Token> visit(FunctionExpression<Object> functionExpression) {
      return functionExpression.getShortestDerivableTokenStream();
    }

    public List<Token> visit(OneOrMoreExpression oneOrMoreExpression) {
      return computeShortestDerivableTokenStream(oneOrMoreExpression.getChild());
    }

    public List<Token> visit(TokenExpression tokenExpression) {
      return Collections.singletonList(tokenExpression.getToken());
    }

    public List<Token> visit(TypeExpression typeExpression) {
      final Token representative;
      try {
        representative = (Token) typeExpression.getType().getField("representative").get(null);
      } catch (IllegalAccessException e) {
        throw new RuntimeException(e);
      } catch (NoSuchFieldException e) {
        throw new RuntimeException(e);
      }

      return Collections.singletonList(representative);
    }
  }
}
