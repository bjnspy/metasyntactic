package org.metasyntactic.automata.compiler.python.scanner;

import org.metasyntactic.automata.compiler.framework.parsers.Source;
import org.metasyntactic.automata.compiler.framework.parsers.SourceToken;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.PackratScanner;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.Rule;
import org.metasyntactic.automata.compiler.python.scanner.delimiters.DelimiterToken;
import org.metasyntactic.automata.compiler.python.scanner.keywords.KeywordToken;
import org.metasyntactic.automata.compiler.python.scanner.literals.FloatingPointLiteralToken;
import org.metasyntactic.automata.compiler.python.scanner.literals.ImaginaryNumberLiteralToken;
import org.metasyntactic.automata.compiler.python.scanner.literals.IntegerLiteralToken;
import org.metasyntactic.automata.compiler.python.scanner.literals.StringLiteralToken;
import org.metasyntactic.automata.compiler.python.scanner.operators.OperatorToken;
import org.metasyntactic.automata.compiler.util.Function4;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.IdentityHashMap;
import java.util.Map;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 25, 2008 Time: 2:34:40 PM To change this template use File |
 * Settings | File Templates.
 */
public class PythonScanner extends PackratScanner<PythonToken> {
  private static final Map<String, Function4<Object, Source, Integer, Integer, Object>> actions = new IdentityHashMap<String, Function4<Object, Source, Integer, Integer, Object>>();

  static {
    actions.put(PythonLexicalSpecification.KEYWORD_RULE.getVariable(),
                new Function4<Object, Source, Integer, Integer, Object>() {
                   public Object apply(Object o, Source source, Integer start, Integer end) {
                    String text = source.getText().substring(start, end);
                    return makeToken(KeywordToken.getKeywordToken(text), source, start, end);
                  }
                });

    actions.put(PythonLexicalSpecification.DELIMITER_RULE.getVariable(),
                new Function4<Object, Source, Integer, Integer, Object>() {
                   public Object apply(Object o, Source source, Integer start, Integer end) {
                    String text = source.getText().substring(start, end);
                    return makeToken(DelimiterToken.getDelimiterToken(text), source, start, end);
                  }
                });

    actions.put(PythonLexicalSpecification.OPERATOR_RULE.getVariable(),
                new Function4<Object, Source, Integer, Integer, Object>() {
                   public Object apply(Object o, Source source, Integer start, Integer end) {
                    String text = source.getText().substring(start, end);
                    return makeToken(OperatorToken.getOperatorToken(text), source, start, end);
                  }
                });

    actions.put(PythonLexicalSpecification.LINE_CONTINUATION_RULE.getVariable(),
                new Function4<Object, Source, Integer, Integer, Object>() {
                   public Object apply(Object o, Source source, Integer start, Integer end) {
                    return makeToken(LineContinuationToken.instance, source, start, end);
                  }
                });

    addAction(PythonLexicalSpecification.COMMENT_RULE, CommentToken.class);
    addAction(PythonLexicalSpecification.FLOATING_POINT_LITERAL_RULE, FloatingPointLiteralToken.class);
    addAction(PythonLexicalSpecification.IMAGINARY_NUMBER_LITERAL_RULE, ImaginaryNumberLiteralToken.class);
    addAction(PythonLexicalSpecification.IDENTIFIER_RULE, IdentifierToken.class);
    addAction(PythonLexicalSpecification.INTEGER_LITERAL_RULE, IntegerLiteralToken.class);
    addAction(PythonLexicalSpecification.ERROR_RULE, ErrorToken.class);
    addAction(PythonLexicalSpecification.NEWLINE_RULE, NewlineToken.class);
    addAction(PythonLexicalSpecification.STRING_LITERAL_RULE, StringLiteralToken.class);
    addAction(PythonLexicalSpecification.WHITESPACE_RULE, WhitespaceToken.class);
  }

  private static void addAction(Rule rule, Class<? extends PythonToken> tokenClass) {
    final Constructor<? extends PythonToken> constructor;
    try {
      constructor = tokenClass.getConstructor(String.class);
    } catch (NoSuchMethodException e) {
      throw new RuntimeException(e);
    }

    actions.put(rule.getVariable(), new Function4<Object, Source, Integer, Integer, Object>() {

      public Object apply(Object argument1, Source source, Integer start, Integer end) {
        String text = source.getText().substring(start, end);
        try {
          PythonToken token = constructor.newInstance(text);
          return makeToken(token, source, start, end);
        } catch (InstantiationException e) {
          throw new RuntimeException(e);
        } catch (IllegalAccessException e) {
          throw new RuntimeException(e);
        } catch (InvocationTargetException e) {
          throw new RuntimeException(e);
        }
      }
    });
  }

  private static SourceToken<PythonToken> makeToken(PythonToken token, Source source, int start, int end) {
    return new SourceToken<PythonToken>(token, source.getSpan(start, end));
  }

  public PythonScanner(Source input) {
    super(PythonLexicalSpecification.instance, actions, input);
  }
}
