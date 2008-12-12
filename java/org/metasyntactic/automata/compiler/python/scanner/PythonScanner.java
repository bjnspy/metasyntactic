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

    addAction(PythonLexicalSpecification.COMMENT_RULE, new TokenCreator() {
      public PythonToken create(String text) {
        return new CommentToken(text);
      }
    });
    addAction(PythonLexicalSpecification.FLOATING_POINT_LITERAL_RULE, new TokenCreator() {
      public PythonToken create(String text) {
        return new FloatingPointLiteralToken(text);
      }
    });
    addAction(PythonLexicalSpecification.IMAGINARY_NUMBER_LITERAL_RULE, new TokenCreator() {
      public PythonToken create(String text) {
        return new ImaginaryNumberLiteralToken(text);
      }
    });
    addAction(PythonLexicalSpecification.IDENTIFIER_RULE, new TokenCreator() {
      public PythonToken create(String text) {
        return new IdentifierToken(text);
      }
    });
    addAction(PythonLexicalSpecification.INTEGER_LITERAL_RULE, new TokenCreator() {
      public PythonToken create(String text) {
        return new IntegerLiteralToken(text);
      }
    });
    addAction(PythonLexicalSpecification.ERROR_RULE, new TokenCreator() {
      public PythonToken create(String text) {
        return new ErrorToken(text);
      }
    });
    addAction(PythonLexicalSpecification.NEWLINE_RULE, new TokenCreator() {
      public PythonToken create(String text) {
        return new NewlineToken(text);
      }
    });
    addAction(PythonLexicalSpecification.STRING_LITERAL_RULE, new TokenCreator() {
      public PythonToken create(String text) {
        return new StringLiteralToken(text);
      }
    });
    addAction(PythonLexicalSpecification.WHITESPACE_RULE, new TokenCreator() {
      public PythonToken create(String text) {
        return new WhitespaceToken(text);
      }
    });
  }

  private interface TokenCreator {
    PythonToken create(String text);
  }

  private static void addAction(Rule rule, final TokenCreator creator) {
    actions.put(rule.getVariable(), new Function4<Object, Source, Integer, Integer, Object>() {
      public Object apply(Object argument1, Source source, Integer start, Integer end) {
        String text = source.getText().substring(start, end);
        PythonToken token = creator.create(text);
        return makeToken(token, source, start, end);
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
