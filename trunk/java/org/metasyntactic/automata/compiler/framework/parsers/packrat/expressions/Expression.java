// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions;

import org.metasyntactic.automata.compiler.framework.parsers.Source;
import org.metasyntactic.automata.compiler.framework.parsers.SourceToken;
import org.metasyntactic.automata.compiler.framework.parsers.Token;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.EvaluationResult;
import org.metasyntactic.common.base.Preconditions;

import java.util.*;

/**
 * A parsing expression is a hierarchical expression similar to a regular expression, which is constructed in the
 * following fashion: <ol> <li>An atomic parsing expression consists of: <ul> <li>any terminal symbol,</li> <li>any
 * nonterminal symbol, or</li> <li>the empty string ?.</li> </ul> </li> <li>Given any existing parsing expressions e,
 * e1, and e2, a new parsing expression can be constructed using the following operators: <ul> <li>Sequence: e1 e2</li>
 * <li>Ordered choice: e1 / e2</li> <li>Zero-or-more: e*</li> <li>Not-predicate: !e</li> </ul> </li> <li>Furthermore a
 * few common constructs are provided for convenience.  They include <ul> <li>One-or-more: e+.  Equivalent to: e e*</li>
 * <li>Optional: e?.  Equivalent to: e / ?</li> <li>And-predicate: &e.  Equivalent to !!e</li> </ul> </li> </ol>
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public abstract class Expression {
  public abstract <TInput, TResult> TResult accept(ExpressionVisitor<TInput, TResult> visitor);

  public abstract <TInput> void accept(ExpressionVoidVisitor<TInput> visitor);

  private int hashCode;

   public int hashCode() {
    if (hashCode == 0) {
      hashCode = hashCodeWorker();
    }

    return hashCode;
  }

  protected abstract int hashCodeWorker();

  /** @return the atomic parsing expression consisting of the supplied terminal. */
  public static Expression terminal(String value) {
    if (value.length() == 1) {
      return character(value.charAt(0));
    } else {
      return new TerminalExpression(value);
    }
  }

  public static Expression character(char c) {
    return new CharacterExpression(c);
  }

  public static Expression token(Token token) {
    return new TokenExpression(token);
  }

  public static Expression type(Class<? extends Token> clazz) {
    return new TypeExpression(clazz);
  }

  /** @return the atomic parsing expression consisting of the supplied variable. */
  public static Expression variable(String variable) {
    return new VariableExpression(variable);
  }

  /** @return the atomic parsing expression for the empty string ? */
  public static Expression empty() {
    return EmptyExpression.instance;
  }

  /** @return a new parsing expression representing: !subExpression */
  public static Expression not(Expression subExpression) {
    return new NotExpression(subExpression);
  }

  /** @return a new parsing expression representing: subExpression* */
  public static Expression repetition(Expression subExpression) {
    return new RepetitionExpression(subExpression);
  }

  /** @return a new parsing expression representing: &subExpression */
  public static Expression and(Expression subExpression) {
    return new NotExpression(new NotExpression(subExpression));
  }

  /** @return a new parsing expression representing: subExpression? */
  public static Expression optional(final Expression subExpression) {
    return new OptionalExpression(subExpression);
  }

  /** @return a new parsing expression representing: subExpression+ */
  public static Expression oneOrMore(Expression subExpression) {
    return new OneOrMoreExpression(subExpression);
  }

  /** @return A new parsing expression representing c_1 / c_2 / ... / c_n for all the c_i in {@code children} */
  public static Expression choice(List<Expression> children) {
    return new ChoiceExpression(children);
  }

  /** @see #choice(List) */
  public static Expression choice(Expression... children) {
    return new ChoiceExpression(children);
  }

  public static Expression choice(String... children) {
    Arrays.sort(children, new Comparator<String>() {
       public int compare(String s1, String s2) {
        if (s1.startsWith(s2)) {
          return -1;
        } else if (s2.startsWith(s1)) {
          return +1;
        } else {
          return s1.compareTo(s2);
        }
      }
    });

    List<Expression> expressions = new ArrayList<Expression>();
    for (String child : children) {
      expressions.add(new TerminalExpression(child));
    }

    return choice(expressions);
  }

  /** @return A new parsing expression representing c_1 c_2 ... c_n for all the c_i in {@code children} */
  public static Expression sequence(List<Expression> children) {
    return new SequenceExpression(children);
  }

  /** @see #sequence(List) */
  public static Expression sequence(Expression... children) {
    return new SequenceExpression(children);
  }

  public static Expression delimitedList(Expression expression, Expression delimeter) {
    return new DelimitedSequenceExpression(expression, delimeter);
  }

  public static Expression anyCharacter() {
    return ANY_CHARACTER_EXPRESSION;
  }

  public static Expression anyToken() {
    return ANY_TOKEN_EXPRESSION;
  }

  public static Expression endOfStream() {
    return not(anyCharacter());
  }

  public static Expression endOfTokens() {
    return not(anyToken());
  }

  private final static Expression ANY_TOKEN_EXPRESSION = new FunctionExpression<List<SourceToken<? extends Token>>>(
      "anyToken") {
     public EvaluationResult apply(List<SourceToken<? extends Token>> tokens, int position) {
      if (position >= tokens.size()) {
        return EvaluationResult.failure;
      } else {
        return new EvaluationResult(position + 1, tokens.get(position));
      }
    }

     public String toString() {
      return ".";
    }

     public boolean isNullable() {
      return false;
    }

     public List<Integer> getShortestDerivableTokenStream() {
      throw new RuntimeException("NYI");
    }

     public List<Integer> getShortestPrefix(int token) {
      return Collections.emptyList();
    }
  };

  private final static Expression ANY_CHARACTER_EXPRESSION = new FunctionExpression<Source>("anyCharacter") {
     public EvaluationResult apply(Source input, int position) {
      String text = input.getText();

      if (position >= text.length()) {
        return EvaluationResult.failure;
      } else {
        return new EvaluationResult(position + 1, text.substring(position, position + 1));
      }
    }

     public String toString() {
      return ".";
    }

     public boolean isNullable() {
      return false;
    }

     public List<Integer> getShortestDerivableTokenStream() {
      throw new RuntimeException("NYI");
    }

     public List<Integer> getShortestPrefix(int token) {
      throw new RuntimeException("NYI");
    }

    public String getCode() {
      return "          String text = input.getText();\n" +
             "\n" +
             "          if (position >= text.length()) {\n" +
             "            return EvaluationResult.failure;\n" +
             "          } else {\n" +
             "            return new EvaluationResult(true, position + 1, text.substring(position, position + 1));\n" +
             "          }";
    }
  };

  public static Expression range(final char startInclusive, final char endInclusive) {
    Preconditions.checkArgument(startInclusive <= endInclusive);

    return new FunctionExpression<Source>("range") {
       public EvaluationResult apply(Source input, int position) {
        String text = input.getText();

        if (position < text.length()) {
          char c = text.charAt(position);

          if (c >= startInclusive && c <= endInclusive) {
            return new EvaluationResult(position + 1, text.substring(position, position + 1));
          }
        }

        return EvaluationResult.failure;
      }

       public String toString() {
        return "[" + startInclusive + "-" + endInclusive + "]";
      }

       public boolean isNullable() {
        return false;
      }

       public List<Integer> getShortestDerivableTokenStream() {
      throw new RuntimeException("NYI");
      }

       public List<Integer> getShortestPrefix(int token) {
      throw new RuntimeException("NYI");
      }
    };
  }
}
