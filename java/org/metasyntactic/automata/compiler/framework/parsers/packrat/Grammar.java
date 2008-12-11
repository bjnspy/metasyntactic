// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.framework.parsers.packrat;

/**
 * Formally, a parsing expression grammar consists of: <ul> <li>A finite set N of nonterminal symbols.</li> <li>A finite
 * set ? of terminal symbols that is disjoint from N.</li> <li>A finite set P of parsing rules.</li> <li>A distinguished
 * variable S; the start rule for the grammar.  It must be an element of N.</li> </ul>
 *
 * @author cyrusn@google.c om (Cyrus Najmabadi)
 */
/*
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
    Collection<Integer> tokens = firstMap.get(variable);
    return tokens.contains(token.getType());
  }

  private void createSets() {
    createNullableSets();
    createFirstSets();
  }

  private void createFirstSets() {
    Set<Expression> acceptsAnyTokenExpression = new LinkedHashSet<Expression>();
    MultiMap<Expression, Integer> expressionToFirstTokens = new HashMultiMap<Expression, Integer>();

    boolean changed;

    do {
      changed = false;

      for (Rule rule : rules) {
        changed |= processFirstSets(rule, acceptsAnyTokenExpression, expressionToFirstTokens);
      }
    } while (changed);

    for (Rule rule : rules) {
      if (acceptsAnyTokenExpression.contains(rule.getExpression())) {
        acceptsAnyToken.add(rule.getVariable());
      }

      firstMap.putAll(rule.getVariable(), expressionToFirstTokens.get(rule.getExpression()));
    }
  }

  private boolean processFirstSets(Rule rule, final Set<Expression> acceptsAnyTokenExpression,
                                   final MultiMap<Expression, Integer> expressionToFirstTokens) {

    return rule.getExpression().accept(new ExpressionVisitor<Object, Boolean>() {
       public Boolean visit(EmptyExpression emptyExpression) {
        return false;
      }

       public Boolean visit(CharacterExpression characterExpression) {
        return false;
      }

       public Boolean visit(TerminalExpression terminalExpression) {
        return false;
      }

       public Boolean visit(VariableExpression variableExpression) {
        Rule rule = getRule(variableExpression.getVariable());
        Expression child = rule.getExpression();

        return process(variableExpression, child);
      }

      private boolean process(Expression parent, Expression child) {
        boolean changed = child.accept(this);

        if (acceptsAnyTokenExpression.contains(child)) {
          changed |= acceptsAnyTokenExpression.add(parent);
        }

        changed |= expressionToFirstTokens.putAll(parent, expressionToFirstTokens.get(child));

        return changed;
      }

       public Boolean visit(DelimitedSequenceExpression sequenceExpression) {
        boolean changed = process(sequenceExpression, sequenceExpression.getElement());
        if (nullableExpressions.contains(sequenceExpression.getElement())) {
          changed |= process(sequenceExpression, sequenceExpression.getDelimiter());
        }
        return changed;
      }

       public Boolean visit(SequenceExpression sequenceExpression) {
        boolean changed = false;

        for (Expression child : sequenceExpression.getChildren()) {
          changed |= process(sequenceExpression, child);

          if (!nullableExpressions.contains(child)) {
            break;
          }
        }

        return changed;
      }

       public Boolean visit(ChoiceExpression choiceExpression) {
        boolean changed = false;

        for (Expression child : choiceExpression.getChildren()) {
          changed |= process(choiceExpression, child);
        }

        return changed;
      }

      public Boolean visit(OptionalExpression optionalExpression) {
        return process(optionalExpression, optionalExpression.getChild());
      }

       public Boolean visit(NotExpression notExpression) {
        return acceptsAnyTokenExpression.add(notExpression);
      }

       public Boolean visit(RepetitionExpression repetitionExpression) {
        return process(repetitionExpression, repetitionExpression.getChild());
      }

       public Boolean visit(FunctionExpression<Object> functionExpression) {
        return acceptsAnyTokenExpression.add(functionExpression);
      }

       public Boolean visit(OneOrMoreExpression oneOrMoreExpression) {
        return process(oneOrMoreExpression, oneOrMoreExpression.getChild());
      }

       public Boolean visit(TokenExpression tokenExpression) {
        return expressionToFirstTokens.putAll(tokenExpression, Collections.singleton(
            tokenExpression.getToken().getType()));
      }

       public Boolean visit(TypeExpression typeExpression) {
        return expressionToFirstTokens.putAll(typeExpression, typeExpression.getTypes());
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
         public void visit(VariableExpression expression) {
          if (!map.containsKey(expression.getVariable())) {
            throw new IllegalArgumentException("No rule found with the variable: " + expression.getVariable());
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

  public Set<String> getVariables() {
    return map.keySet();
  }

   public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof Grammar)) {
      return false;
    }

    Grammar grammar = (Grammar) o;

    return rules.equals(grammar.rules) && startRule.equals(grammar.startRule);
  }

   public int hashCode() {
    int result;
    result = rules.hashCode();
    result = 31 * result + startRule.hashCode();
    return result;
  }

   public String toString() {
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

     public void visit(EmptyExpression emptyExpression) { }

     public void visit(CharacterExpression characterExpression) { }

     public void visit(TerminalExpression terminalExpression) { }

     public void visit(FunctionExpression functionExpression) { }

     public void visit(TokenExpression tokenExpression) { }

     public void visit(TypeExpression typeExpression) { }

     public void visit(VariableExpression variableExpression) {
      checkForLeftRecursion(getRule(variableExpression.getVariable()), rulesStack);
    }

     public void visit(DelimitedSequenceExpression sequenceExpression) {
      sequenceExpression.getElement().accept(this);
    }

     public void visit(SequenceExpression sequenceExpression) {
      sequenceExpression.getChildren()[0].accept(this);
    }

     public void visit(ChoiceExpression choiceExpression) {
      for (Expression child : choiceExpression.getChildren()) {
        child.accept(this);
      }
    }

     public void visit(OptionalExpression optionalExpression) {
      optionalExpression.getChild().accept(this);
    }

     public void visit(NotExpression notExpression) {
      notExpression.getChild().accept(this);
    }

     public void visit(RepetitionExpression repetitionExpression) {
      repetitionExpression.getChild().accept(this);
    }

     public void visit(OneOrMoreExpression oneOrMoreExpression) {
      oneOrMoreExpression.getChild().accept(this);
    }
  }

  private class NullableExpressionVisitor implements ExpressionVisitor<Object, Boolean> {
     public Boolean visit(EmptyExpression emptyExpression) {
      nullableExpressions.add(emptyExpression);
      return true;
    }

     public Boolean visit(TerminalExpression terminalExpression) {
      return false;
    }

     public Boolean visit(CharacterExpression characterExpression) {
      return false;
    }

     public Boolean visit(VariableExpression variableExpression) {
      if (nullableVariables.contains(variableExpression.getVariable())) {
        nullableExpressions.add(variableExpression);
        return true;
      }

      return false;
    }

     public Boolean visit(DelimitedSequenceExpression sequenceExpression) {
      return sequenceExpression.getElement().accept(this);
    }

     public Boolean visit(SequenceExpression sequenceExpression) {
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

     public Boolean visit(ChoiceExpression choiceExpression) {
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
      optionalExpression.getChild().accept(this);
      nullableExpressions.add(optionalExpression);
      return true;
    }

     public Boolean visit(NotExpression notExpression) {
      nullableExpressions.add(notExpression);
      return true;
    }

     public Boolean visit(RepetitionExpression repetitionExpression) {
      nullableExpressions.add(repetitionExpression);
      return true;
    }

     public Boolean visit(FunctionExpression<Object> functionExpression) {
      if (functionExpression.isNullable()) {
        nullableExpressions.add(functionExpression);
        return true;
      }

      return false;
    }

     public Boolean visit(OneOrMoreExpression oneOrMoreExpression) {
      if (oneOrMoreExpression.getChild().accept(this)) {
        nullableExpressions.add(oneOrMoreExpression);
        return true;
      }

      return false;
    }

     public Boolean visit(TokenExpression tokenExpression) {
      return false;
    }

     public Boolean visit(TypeExpression typeExpression) {
      return false;
    }
  }
}
*/