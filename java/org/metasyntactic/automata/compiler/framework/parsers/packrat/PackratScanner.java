package org.metasyntactic.automata.compiler.framework.parsers.packrat;

import org.metasyntactic.automata.compiler.framework.parsers.Scanner;
import org.metasyntactic.automata.compiler.framework.parsers.Source;
import org.metasyntactic.automata.compiler.framework.parsers.SourceToken;
import org.metasyntactic.automata.compiler.framework.parsers.Token;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions.*;
import org.metasyntactic.automata.compiler.util.Function4;
import org.metasyntactic.common.base.Preconditions;

import java.util.*;

public class PackratScanner<T extends Token> implements Scanner<T> {
  private final Source input;
  private final PackratGrammar lexicalSpecification;
  private final Map<String, Function4<Object, Source, Integer, Integer, Object>> actions;

  public PackratScanner(
      PackratGrammar lexicalSpecification,
      Map<String, Function4<Object, Source, Integer, Integer, Object>> actions,
      Source input) {
    Preconditions.checkNotNull(input);
    Preconditions.checkNotNull(lexicalSpecification);
    Preconditions.checkNotNull(actions);

    this.input = input;
    this.lexicalSpecification = lexicalSpecification;
    this.actions = Collections.unmodifiableMap(actions);
  }

  public PackratScanner(PackratGrammar lexicalSpecification, Source input) {
    this(lexicalSpecification, Collections.EMPTY_MAP, input);
  }

  public PackratGrammar getLexicalSpecification() {
    return lexicalSpecification;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof PackratScanner)) {
      return false;
    }

    PackratScanner scanner = (PackratScanner) o;

    if (!input.equals(scanner.input)) {
      return false;
    }
    if (!actions.equals(scanner.actions)) {
      return false;
    }
    if (!lexicalSpecification.equals(scanner.lexicalSpecification)) {
      return false;
    }

    return true;
  }

  @Override public int hashCode() {
    int result;
    result = input.hashCode();
    result = 31 * result + lexicalSpecification.hashCode();
    result = 31 * result + actions.hashCode();
    return result;
  }

  @Override public List<SourceToken<T>> scan() {
    return scan(0);
  }

  private List<SourceToken<T>> scan(int position) {
    EvaluationResult result = evaluateRule(position, lexicalSpecification.getStartRule());

    if (result.isSuccess()) {
      List list = flatten(result.answer);
      return list;
    } else {
      return null;
    }
  }

  private List<Object> flatten(Object value) {
    List<Object> result = new ArrayList<Object>();
    flatten(value, result);
    return Collections.unmodifiableList(result);
  }

  private void flatten(Object o, List<Object> result) {
    if (o instanceof List) {
      for (Object child : (List) o) {
        flatten(child, result);
      }
    } else {
      result.add(o);
    }
  }

  private EvaluationResult evaluateRule(final int position, final Rule rule) {
    EvaluationResult result = evaluateExpression(position, rule.getExpression());

    if (result.isSuccess()) {
      Function4<Object, Source, Integer, Integer, Object> action = rule.getAction(actions);

      if (action != null) {
        Object value = action.apply(result.answer, input, position, result.position);

        if (value != result.answer) {
          result = new EvaluationResult(result.position, value);
        }
      }
    }

    return result;
  }

  private final QuickQueue<EvaluationExpressionVisitor> visitors =
      new QuickQueue<EvaluationExpressionVisitor>();

  private EvaluationResult evaluateExpression(
      final int position,
      final Expression expression) {
    EvaluationExpressionVisitor visitor = visitors.poll();
    if (visitor == null) {
      visitor = new EvaluationExpressionVisitor();
    }

    visitor.position = position;

    EvaluationResult result = expression.accept(visitor);

    visitors.offer(visitor);

    return result;
  }

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

  private class EvaluationExpressionVisitor implements ExpressionVisitor<Source, EvaluationResult> {
    private int position;

    public EvaluationExpressionVisitor() {
    }

    @Override public EvaluationResult visit(EmptyExpression emptyExpression) {
      return new EvaluationResult(position, null);
    }

    @Override public EvaluationResult visit(CharacterExpression characterExpression) {
      final String text = input.getText();

      if (position < text.length()) {
        char c = text.charAt(position);
        if (c == characterExpression.getCharacter()) {
          return new EvaluationResult(position + 1, c);
        }
      }

      return EvaluationResult.failure;
    }

    @Override public EvaluationResult visit(TerminalExpression terminalExpression) {
      final String terminal = terminalExpression.getTerminal();
      final String text = input.getText();

      if (position + terminal.length() > text.length()) {
        return EvaluationResult.failure;
      }

      for (int i = 0; i < terminal.length(); i++) {
        if (terminal.charAt(i) != text.charAt(position + i)) {
          return EvaluationResult.failure;
        }
      }

      return new EvaluationResult(position + terminal.length(), terminal);
    }

    @Override public EvaluationResult visit(VariableExpression variableExpression) {
      Rule rule = variableExpression.getRule(lexicalSpecification);
      return evaluateRule(position, rule);
    }

    @Override public EvaluationResult visit(DelimitedSequenceExpression sequenceExpression) {
      throw new RuntimeException("Not yet implemented.");
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
      ArrayList<Object> values = null;

      EvaluationResult result = evaluateExpression(position, oneOrMoreExpression.getChild());
      if (result.isFailure()) {
        return result;
      }

      while (true) {
        int currentPosition = result.position;
        values = addValue(values, result);

        result = evaluateExpression(currentPosition, oneOrMoreExpression.getChild());
        if (!result.isFailure()) {
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
      if (result.isSuccess()) {
        return EvaluationResult.failure;
      } else {
        return new EvaluationResult(position, result.answer);
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

    @Override public EvaluationResult visit(FunctionExpression<Source> functionExpression) {
      return functionExpression.apply(input, position);
    }

    @Override public EvaluationResult visit(TokenExpression tokenExpression) {
      throw new UnsupportedOperationException();
    }

    @Override public EvaluationResult visit(TypeExpression typeExpression) {
      throw new UnsupportedOperationException();
    }
  }
}