// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.framework.parsers.packrat;

import com.google.automata.compiler.framework.parsers.Token;
import com.google.automata.compiler.framework.parsers.packrat.expressions.CharacterExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.ChoiceExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.EmptyExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.Expression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.ExpressionVisitor;
import com.google.automata.compiler.framework.parsers.packrat.expressions.ExpressionVoidVisitor;
import com.google.automata.compiler.framework.parsers.packrat.expressions.FunctionExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.NotExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.OneOrMoreExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.RecursionExpressionVisitor;
import com.google.automata.compiler.framework.parsers.packrat.expressions.RepetitionExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.SequenceExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.TerminalExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.TokenExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.TypeExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.VariableExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.DelimitedSequenceExpression;
import com.google.common.base.Preconditions;
import com.google.common.collect.HashMultimap;
import com.google.common.collect.Multimap;

import java.util.ArrayDeque;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.IdentityHashMap;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Queue;
import java.util.Set;

/**
 * Formally, a parsing expression grammar consists of: <ul> <li>A finite set N of nonterminal symbols.</li> <li>A finite
 * set ? of terminal symbols that is disjoint from N.</li> <li>A finite set P of parsing rules.</li> <li>A distinguished
 * variable S; the start rule for the grammar.  It must be an element of N.</li> </ul>
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class Grammar {
  private final Set<Rule> rules;
  private final Rule startRule;
  private final Map<String, Rule> map = new IdentityHashMap<String, Rule>();

  public Grammar(Rule startRule, Rule... remainingRules) {
    this(startRule, createSet(startRule, remainingRules));
  }

  private static Set<Rule> createSet(Rule rule, Rule... ruleArray) {
    Set<Rule> rules = new LinkedHashSet<Rule>();
    rules.add(rule);
    rules.addAll(Arrays.asList(ruleArray));
    return rules;
  }

  public Grammar(Rule startRule, Set<Rule> rules) {
    Preconditions.checkNotNull(startRule);
    Preconditions.checkContentsNotNull(rules);
    Preconditions.checkArgument(rules.contains(startRule));

    this.rules = new LinkedHashSet<Rule>(rules);
    this.startRule = startRule;

    for (Rule rule : rules) {
      map.put(rule.getVariable(), rule);
    }

    checkRules();

    createSets();

    /*
    System.out.println("Nullable variables  : " + nullableVariables);
    System.out.println("Nullable expressions:");
    for (Expression e : nullableExpressions) {
      System.out.println("\t" + e);
    }
    */

/*
    System.out.println("Accepts any token: ");
    System.out.println(acceptsAnyToken);
    System.out.println();

    System.out.println("First tokens: ");

    for (Object key : firstTokenMap.keySet()) {
      System.out.println(key + " -> " + firstTokenMap.getCollection(key));
    }

    System.out.println();
    System.out.println("First types: ");
    for (Object key : firstTypeMap.keySet()) {
      System.out.println(key + " -> " + firstTypeMap.getCollection(key));
    }
    */
  }

  private final Set<String> nullableVariables = new LinkedHashSet<String>();
  private final Set<Expression> nullableExpressions = new LinkedHashSet<Expression>();

  private final Set<String> acceptsAnyToken = new LinkedHashSet<String>();
  private final Multimap<String,Token> firstTokenMap = new HashMultimap<String, Token>();
  private final Multimap<String,Integer> firstTypeMap = new HashMultimap<String,Integer>();

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
    /*
    Collection<Class<? extends Token>> types = firstTypeMap.getCollection(variable);
    if (types != null) {
      Class<? extends Token> actualType = token.getClass();
      for (Class<? extends Token> expectedType : types) {
        if (expectedType.isAssignableFrom(actualType)) {
          return true;
        }
      }
    }

    return false;
    */
  }

  private void createSets() {
    createNullableSets();
    createFirstSets();
  }

  private void createFirstSets() {
    Set<Expression> acceptsAnyTokenExpression = new LinkedHashSet<Expression>();
    Multimap<Expression,Token> expresionToFirstTokens = new HashMultimap<Expression, Token>();
    Multimap<Expression,Integer> expressionToFirstTypes = new HashMultimap<Expression, Integer>();

    boolean changed;

    do {
      changed = false;

      for (Rule rule : rules) {
        changed |= processFirstSets(rule, acceptsAnyTokenExpression, expresionToFirstTokens,
            expressionToFirstTypes);
      }

    } while (changed);

    for (Rule rule : rules) {
      if (acceptsAnyTokenExpression.contains(rule.getExpression())) {
        acceptsAnyToken.add(rule.getVariable());
      }

      firstTokenMap.putAll(rule.getVariable(), expresionToFirstTokens.get(
          rule.getExpression()));
      firstTypeMap.putAll(rule.getVariable(), expressionToFirstTypes.get(
          rule.getExpression()));
    }
  }

  private boolean processFirstSets(
      Rule rule,
      final Set<Expression> acceptsAnyTokenExpression,
      final Multimap<Expression, Token> expresionToFirstTokens,
      final Multimap<Expression, Integer> expressionToFirstTypes) {
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

        return process(variableExpression, child);
      }

      private boolean process(Expression parent, Expression child) {
        boolean changed = child.accept(this);

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
        return expresionToFirstTokens.putAll(tokenExpression, Collections.singleton(
            tokenExpression.getToken()));
      }

      @Override public Boolean visit(TypeExpression typeExpression) {
        //return expressionToFirstTypes.putAll(typeExpression, Collections.singleton(typeExpression.getType()));
        return expressionToFirstTypes.putAll(typeExpression, Collections.singleton(
            typeExpression.getTypeValue()));
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

  private void checkRules() {
    for (Rule rule : rules) {
      rule.getExpression().accept(new RecursionExpressionVisitor() {
        @Override public void visit(VariableExpression expression) {
          if (!map.containsKey(expression.getVariable())) {
            throw new IllegalArgumentException(
                "No rule found with the variable: " + expression.getVariable());
          }
        }
      });
    }

    for (Rule rule : rules) {
      checkForLeftRecursion(rule);
    }
  }

  private void checkForLeftRecursion(Rule rule) {
    Queue<Rule> rulesStack = Collections.asLifoQueue(new ArrayDeque<Rule>());
    checkForLeftRecursion(rule, rulesStack);
  }

  private void checkForLeftRecursion(Rule rule, final Queue<Rule> rulesStack) {
    if (rulesStack.contains(rule)) {
      StringBuilder builder = new StringBuilder("Left recursion found in: ");
      builder.append(rule);
      builder.append(". Path:");

      for (Rule problemRule : rulesStack) {
        builder.append("\n\t");
        builder.append(problemRule);
      }

      throw new IllegalArgumentException(builder.toString());
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
    return map.get(variable);
  }

  @Override public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof Grammar)) {
      return false;
    }

    Grammar grammar = (Grammar) o;

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
}
