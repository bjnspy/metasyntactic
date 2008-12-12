// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.framework.parsers.packrat;

import org.metasyntactic.automata.compiler.framework.parsers.ActionMap;
import org.metasyntactic.automata.compiler.framework.parsers.Parser;
import org.metasyntactic.automata.compiler.framework.parsers.SourceToken;
import org.metasyntactic.automata.compiler.framework.parsers.Token;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions.*;
import org.metasyntactic.common.base.Preconditions;

import java.util.*;

/**
 * TODO(cyrusn): javadoc
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public abstract class AbstractPackratParser<T extends Token> implements Parser {
  private final PackratGrammar grammar;
  protected final ActionMap<T> actions;
  protected final MemoMap memoizationMap = new MemoMap();
  int furtherstPosition;

  protected final List<SourceToken<T>> input;

  protected AbstractPackratParser(PackratGrammar grammar, List<SourceToken<T>> input, ActionMap<T> actions) {
    Preconditions.checkNotNull(grammar);
    Preconditions.checkNotNull(actions);
    this.grammar = grammar;
    this.actions = actions;
    this.input = Collections.unmodifiableList(new ArrayList<SourceToken<T>>(input));
  }

  public PackratGrammar getGrammar() {
    return grammar;
  }

  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof AbstractPackratParser)) {
      return false;
    }

    AbstractPackratParser parser = (AbstractPackratParser) o;

    return actions.equals(parser.actions) && grammar.equals(parser.grammar);
  }

  public int hashCode() {
    int result;
    result = grammar.hashCode();
    result = 31 * result + actions.hashCode();
    return result;
  }

  public Object parse() {
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
          !grammar.isFirstToken(variable,
                                token)) {
        return false;
      }
    }

    return true;
  }

  protected abstract EvaluationResult evaluateExpression(final int position, final Expression expression);

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

    public boolean equals(Object o) {
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

    public int hashCode() {
      int result;
      result = rule.hashCode();
      result = 31 * result + position;
      return result;
    }

    public String toString() {
      return "(Key " + rule + " " + position + ")";
    }
  }

  protected class EvaluationExpressionVisitor implements ExpressionVisitor<List<SourceToken<T>>, EvaluationResult> {
    protected int position;

    public EvaluationExpressionVisitor() {
    }

    public EvaluationExpressionVisitor(int position) {
      this.position = position;
    }

    public EvaluationResult visit(EmptyExpression emptyExpression) {
      return new EvaluationResult(position, null);
    }

    public EvaluationResult visit(TerminalExpression terminalExpression) {
      throw new UnsupportedOperationException();
    }

    public EvaluationResult visit(CharacterExpression characterExpression) {
      throw new UnsupportedOperationException();
    }

    public EvaluationResult visit(VariableExpression variableExpression) {
      Rule rule = variableExpression.getRule(grammar);
      return evaluateRule(position, rule);
    }

    public EvaluationResult visit(DelimitedSequenceExpression sequenceExpression) {
      ArrayList<Object> elements = null;
      ArrayList<Object> delimiters = null;

      EvaluationResult result = evaluateExpression(position, sequenceExpression.getElement());
      if (result.isFailure()) {
        return EvaluationResult.failure;
      }

      elements = addValue(elements, result);
      while (true) {
        int currentPosition = result.position;

        EvaluationResult delimiterResult = evaluateExpression(currentPosition, sequenceExpression.getDelimiter());
        if (delimiterResult.isFailure()) {
          return new EvaluationResult(currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
        }

        result = evaluateExpression(delimiterResult.position, sequenceExpression.getElement());
        if (result.isFailure()) {
          if (sequenceExpression.allowsTrailingDelimiter()) {
            // accept the last delimiter.
            delimiters = addValue(delimiters, delimiterResult);
            return new EvaluationResult(delimiterResult.position, Arrays.asList(trimList(elements), trimList(delimiters)));
          } else {
            // don't accept the last delimiter
            return new EvaluationResult(currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
          }
        }

        delimiters = addValue(delimiters, delimiterResult);
        elements = addValue(elements, result);
      }
    }

    public EvaluationResult visit(SequenceExpression sequenceExpression) {
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

    public EvaluationResult visit(OneOrMoreExpression oneOrMoreExpression) {
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

    public EvaluationResult visit(ChoiceExpression choiceExpression) {
      for (Expression child : choiceExpression.getChildren()) {
        EvaluationResult result = evaluateExpression(position, child);
        if (result.isSuccess()) {
          return result;
        }
      }

      return EvaluationResult.failure;
    }

    public EvaluationResult visit(OptionalExpression optionalExpression) {
      EvaluationResult result = evaluateExpression(position, optionalExpression.getChild());
      if (result.isSuccess()) {
        return result;
      }

      return new EvaluationResult(position, null);
    }

    public EvaluationResult visit(NotExpression notExpression) {
      EvaluationResult result = evaluateExpression(position, notExpression.getChild());
      if (result.isSuccess()) {
        return EvaluationResult.failure;
      } else {
        return new EvaluationResult(position, null);
      }
    }

    public EvaluationResult visit(RepetitionExpression repetitionExpression) {
      int currentPosition = position;
      ArrayList<Object> values = null;

      while (true) {
        EvaluationResult result = evaluateExpression(currentPosition, repetitionExpression.getChild());

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

    public EvaluationResult visit(FunctionExpression<List<SourceToken<T>>> functionExpression) {
      return functionExpression.apply(input, position);
    }

    public EvaluationResult visit(TokenExpression tokenExpression) {
      if (position < input.size()) {
        SourceToken<T> token = input.get(position);

        if (tokenExpression.getToken() == token.getToken()) {
          return new EvaluationResult(position + 1, token);
        }
      }

      return EvaluationResult.failure;
    }

    public EvaluationResult visit(TypeExpression typeExpression) {
      if (position < input.size()) {
        SourceToken<T> token = input.get(position);

        Set<Integer> types = typeExpression.getTypes();
        if (types.contains(token.getToken().getType())) {
          return new EvaluationResult(position + 1, token);
        }
      }

      return EvaluationResult.failure;
    }
  }

  protected static class MemoMap {
    private final Map<EvaluationKey, EvaluationResult> memoizationMap = new LinkedHashMap<EvaluationKey, EvaluationResult>();

    private final EvaluationKey key = new EvaluationKey(null, 0);

    protected final void put(int position, Rule rule, EvaluationResult result) {
      memoizationMap.put(new EvaluationKey(rule.getVariable(), position), result);
    }

    protected final EvaluationResult get(int position, Rule rule) {
      key.rule = rule.getVariable();
      key.position = position;

      return memoizationMap.get(key);
    }
  }
}