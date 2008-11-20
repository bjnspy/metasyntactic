// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.framework.parsers.packrat;

import com.google.automata.compiler.framework.parsers.ActionMap;
import com.google.automata.compiler.framework.parsers.Parser;
import com.google.automata.compiler.framework.parsers.SourceToken;
import com.google.automata.compiler.framework.parsers.Token;
import com.google.automata.compiler.framework.parsers.packrat.expressions.CharacterExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.ChoiceExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.DelimitedSequenceExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.EmptyExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.Expression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.ExpressionVisitor;
import com.google.automata.compiler.framework.parsers.packrat.expressions.FunctionExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.NotExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.OneOrMoreExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.RepetitionExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.SequenceExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.TerminalExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.TokenExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.TypeExpression;
import com.google.automata.compiler.framework.parsers.packrat.expressions.VariableExpression;
import com.google.common.base.Preconditions;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * TODO(cyrusn): javadoc
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public abstract class AbstractPackratParser<T extends Token> implements Parser {
  private final PackratGrammar grammar;
  protected final ActionMap<T> actions;
  protected final MemoMap memoizationMap = new MemoMap();
  int furtherstPosition;

  protected final List<SourceToken<T>> input;

  protected AbstractPackratParser(
      PackratGrammar grammar,
      List<SourceToken<T>> input,
      ActionMap<T> actions) {
    Preconditions.checkNotNull(grammar);
    Preconditions.checkNotNull(actions);
    this.grammar = grammar;
    this.actions = actions;
    this.input = Collections.unmodifiableList(new ArrayList<SourceToken<T>>(input));
  }

  public PackratGrammar getGrammar() {
    return grammar;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof AbstractPackratParser)) {
      return false;
    }

    AbstractPackratParser parser = (AbstractPackratParser) o;

    if (!actions.equals(parser.actions)) {
      return false;
    }
    if (!grammar.equals(parser.grammar)) {
      return false;
    }

    return true;
  }

  @Override public int hashCode() {
    int result;
    result = grammar.hashCode();
    result = 31 * result + actions.hashCode();
    return result;
  }

  @Override public Object parse() {
    return parse(0);
  }

  private Object parse(int position) {
    EvaluationResult result = evaluateRule(position, grammar.getStartRule());

    if (result.isSuccess()) {
      return result.answer;
    } else {
      return null;
    }
  }
  protected abstract EvaluationResult evaluateRule(final int position, final Rule rule);

  protected final boolean checkToken(int position, Rule rule) {
    if (position < input.size()) {
      Token token = input.get(position).getToken();
      String variable = rule.getVariable();

      if (!grammar.isNullable(variable) &&
          !grammar.acceptsAnyToken(variable) &&
          !grammar.isFirstToken(variable, token) &&
          !grammar.isFirstType(variable, token)) {
        return false;
      }
    }

    return true;
  }

  protected abstract EvaluationResult evaluateExpression(
      final int position,
      final Expression expression);

  private static List<Object> trimList(ArrayList<Object> values) {
    if (values == null || values.isEmpty()) {
      return Collections.emptyList();
    } else if (values.size() == 1) {
      return Collections.singletonList(values.get(0));
    } else {
      values.trimToSize();
      return values;
    }
  }

  protected static class EvaluationKey {
    public String rule;
    public int position;

    protected EvaluationKey(String rule, int position) {
      this.rule = rule;
      this.position = position;
    }

    @Override public boolean equals(Object o) {
      if (this == o) {
        return true;
      }
      if (!(o instanceof EvaluationKey)) {
        return false;
      }

      EvaluationKey that = (EvaluationKey) o;

      if (position != that.position) {
        return false;
      }
      if (rule != that.rule) {
        return false;
      }

      return true;
    }

    @Override public int hashCode() {
      int result;
      result = rule.hashCode();
      result = 31 * result + position;
      return result;
    }

    @Override public String toString() {
      return "(Key " + rule + " " + position + ")";
    }
  }

  protected class EvaluationExpressionVisitor implements
      ExpressionVisitor<List<SourceToken<T>>, EvaluationResult> {
    protected int position;

    public EvaluationExpressionVisitor() {
    }

    public EvaluationExpressionVisitor(int position) {
      this.position = position;
    }

    @Override public EvaluationResult visit(EmptyExpression emptyExpression) {
      return new EvaluationResult(position, null);
    }

    @Override public EvaluationResult visit(TerminalExpression terminalExpression) {
      throw new UnsupportedOperationException();
    }

    @Override public EvaluationResult visit(CharacterExpression characterExpression) {
      throw new UnsupportedOperationException();
    }

    @Override public EvaluationResult visit(VariableExpression variableExpression) {
      Rule rule = variableExpression.getRule(grammar);
      return evaluateRule(position, rule);
    }

    @Override public EvaluationResult visit(DelimitedSequenceExpression sequenceExpression) {
      ArrayList<Object> elements = null;
      ArrayList<Object> delimiters = null;

      EvaluationResult result = evaluateExpression(position, sequenceExpression.getElement());
      if (result.isFailure()) {
        return EvaluationResult.failure;
      }

      elements = addValue(elements, result);
      while (true) {
        int currentPosition = result.position;

        EvaluationResult delimiterResult =
            evaluateExpression(currentPosition, sequenceExpression.getDelimiter());
        if (delimiterResult.isFailure()) {
          return new EvaluationResult(
              currentPosition,
              Arrays.asList(trimList(elements), trimList(delimiters)));
        }

        result = evaluateExpression(delimiterResult.position, sequenceExpression.getElement());
        if (result.isFailure()) {
          if (sequenceExpression.allowsTrailingDelimiter()) {
            // accept the last delimiter.
            delimiters = addValue(delimiters, delimiterResult);
          }

          return new EvaluationResult(
              currentPosition,
              Arrays.asList(trimList(elements), trimList(delimiters)));
        }

        elements = addValue(elements, result);
      }
    }

    @Override public EvaluationResult visit(SequenceExpression sequenceExpression) {
      int currentPosition = position;
      ArrayList<Object> values = null;

      for (Expression child : sequenceExpression.getChildren()) {
        EvaluationResult result = evaluateExpression(currentPosition, child);
        if (result.isFailure()) {
          return EvaluationResult.failure;
        }

        currentPosition = result.position;
        values = addValue(values, result);
      }

      return new EvaluationResult(currentPosition, trimList(values));
    }

    @Override public EvaluationResult visit(OneOrMoreExpression oneOrMoreExpression) {
      EvaluationResult result = evaluateExpression(position, oneOrMoreExpression.getChild());
      if (result.isFailure()) {
        return EvaluationResult.failure;
      }

      ArrayList<Object> values = null;

      while (true) {
        int currentPosition = result.position;
        values = addValue(values, result);

        result = evaluateExpression(currentPosition, oneOrMoreExpression.getChild());
        if (result.isFailure()) {
          return new EvaluationResult(currentPosition, trimList(values));
        }
      }
    }

    @Override public EvaluationResult visit(ChoiceExpression choiceExpression) {
      for (Expression child : choiceExpression.getChildren()) {
        EvaluationResult result = evaluateExpression(position, child);
        if (result.isSuccess()) {
          return result;
        }
      }

      return EvaluationResult.failure;
    }

    @Override public EvaluationResult visit(NotExpression notExpression) {
      EvaluationResult result = evaluateExpression(position, notExpression.getChild());
      if (result.isFailure()) {
        return EvaluationResult.failure;
      } else {
        return new EvaluationResult(position, null);
      }
    }

    @Override public EvaluationResult visit(RepetitionExpression repetitionExpression) {
      int currentPosition = position;
      ArrayList<Object> values = null;

      while (true) {
        EvaluationResult result = evaluateExpression(currentPosition,
            repetitionExpression.getChild());

        if (result.isSuccess()) {
          currentPosition = result.position;
          values = addValue(values, result);
        } else {
          return new EvaluationResult(currentPosition, trimList(values));
        }
      }
    }

    private ArrayList<Object> addValue(ArrayList<Object> values, EvaluationResult result) {
      Object value = result.answer;

      if (value != null) {
        if (values == null) {
          values = new ArrayList<Object>();
        }

        values.add(value);
      }

      return values;
    }

    @Override public EvaluationResult visit(
        FunctionExpression<List<SourceToken<T>>> functionExpression) {
      return functionExpression.apply(input, position);
    }

    @Override public EvaluationResult visit(TokenExpression tokenExpression) {
      if (position < input.size()) {
        SourceToken<T> token = input.get(position);

        if (tokenExpression.getToken() == token.getToken()) {
          return new EvaluationResult(position + 1, token);
        }
      }

      return EvaluationResult.failure;
    }

    @Override public EvaluationResult visit(TypeExpression typeExpression) {
      if (position < input.size()) {
        SourceToken<T> token = input.get(position);

        Class<? extends Token> expectedType = typeExpression.getType();
        Class<? extends Token> actualType = token.getToken().getClass();

        if (expectedType.isAssignableFrom(actualType)) {
          return new EvaluationResult(position + 1, token);
        }
      }

      return EvaluationResult.failure;
    }
  }

  protected static class MemoMap {
    private final Map<EvaluationKey, EvaluationResult> memoizationMap =
        new LinkedHashMap<EvaluationKey, EvaluationResult>();

    private final EvaluationKey key = new EvaluationKey(null, 0);

    protected final void put(int position, Rule rule, EvaluationResult result) {
      key.position = position;
      key.rule = rule.getVariable();
      memoizationMap.put(key, result);
    }

    protected final EvaluationResult get(int position, Rule rule) {
      key.rule = rule.getVariable();
      key.position = position;

      return memoizationMap.get(key);
    }
  }
}