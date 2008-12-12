package org.metasyntactic.automata.compiler.java.scanner;

import org.metasyntactic.automata.compiler.framework.parsers.Source;
import org.metasyntactic.automata.compiler.framework.parsers.SourceToken;
import org.metasyntactic.automata.compiler.framework.parsers.Span;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.PackratScanner;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.Rule;
import org.metasyntactic.automata.compiler.java.scanner.keywords.KeywordToken;
import org.metasyntactic.automata.compiler.java.scanner.literals.*;
import org.metasyntactic.automata.compiler.java.scanner.operators.OperatorToken;
import org.metasyntactic.automata.compiler.java.scanner.separators.SeparatorToken;
import org.metasyntactic.automata.compiler.util.Function4;

import java.util.*;

public class JavaScanner extends PackratScanner<JavaToken> {
  private final static Map<String, Function4<Object, Source, Integer, Integer, Object>> actions = new IdentityHashMap<String, Function4<Object, Source, Integer, Integer, Object>>();

  static {
    final Set<String> keywords = new HashSet<String>(Arrays.asList(KeywordToken.getKeywords()));

    actions.put(JavaLexicalSpecification.KEYWORD_OR_IDENTIFIER_RULE.getVariable(),
                new Function4<Object, Source, Integer, Integer, Object>() {

                  public Object apply(Object argument1, Source source, Integer start, Integer end) {
                    String text = source.getText().substring(start, end);

                    if (text.equals("true")) {
                      return makeToken(TrueBooleanLiteralToken.instance, source, start, end);
                    } else if (text.equals("false")) {
                      return makeToken(FalseBooleanLiteralToken.instance, source, start, end);
                    } else if (text.equals("null")) {
                      return makeToken(NullLiteralToken.instance, source, start, end);
                    } else if (keywords.contains(text)) {
                      return makeToken(KeywordToken.getKeywordToken(text), source, start, end);
                    } else {
                      return makeToken(new IdentifierToken(text), source, start, end);
                    }
                  }
                });

    actions.put(JavaLexicalSpecification.SEPARATOR_RULE.getVariable(),
                new Function4<Object, Source, Integer, Integer, Object>() {

                  public Object apply(Object argument1, Source source, Integer start, Integer end) {
                    String text = source.getText().substring(start, end);
                    return makeToken(SeparatorToken.getSeparatorToken(text), source, start, end);
                  }
                });

    actions.put(JavaLexicalSpecification.OPERATOR_RULE.getVariable(),
                new Function4<Object, Source, Integer, Integer, Object>() {

                  public Object apply(Object argument1, Source source, Integer start, Integer end) {
                    String text = source.getText().substring(start, end);
                    return makeToken(OperatorToken.getOperatorToken(text), source, start, end);
                  }
                });

    addAction(JavaLexicalSpecification.WHITESPACE_RULE, new TokenCreator() {
      public JavaToken create(String text) {
        return new WhitespaceToken(text);
      }
    });
    addAction(JavaLexicalSpecification.CHARACTER_LITERAL_RULE, new TokenCreator() {
      public JavaToken create(String text) {
        return new CharacterLiteralToken(text);
      }
    });
    addAction(JavaLexicalSpecification.COMMENT_RULE, new TokenCreator() {
      public JavaToken create(String text) {
        return new CommentToken(text);
      }
    });
    addAction(JavaLexicalSpecification.FLOATING_POINT_LITERAL_RULE, new TokenCreator() {
      public JavaToken create(String text) {
        return new FloatingPointLiteralToken(text);
      }
    });
    addAction(JavaLexicalSpecification.INTEGER_LITERAL_RULE, new TokenCreator() {
      public JavaToken create(String text) {
        return new IntegerLiteralToken(text);
      }
    });
    addAction(JavaLexicalSpecification.ERROR_RULE, new TokenCreator() {
      public JavaToken create(String text) {
        return new ErrorToken(text);
      }
    });
    addAction(JavaLexicalSpecification.STRING_LITERAL_RULE, new TokenCreator() {
      public JavaToken create(String text) {
        return new StringLiteralToken(text);
      }
    });
  }

  private interface TokenCreator {
    JavaToken create(String text);
  }

  private static void addAction(Rule rule, final TokenCreator creator) {
    actions.put(rule.getVariable(), new Function4<Object, Source, Integer, Integer, Object>() {
      public Object apply(Object argument1, Source source, Integer start, Integer end) {
        String text = source.getText().substring(start, end);
        JavaToken token = creator.create(text);
        return makeToken(token, source, start, end);
      }
    });
  }

  private static SourceToken<JavaToken> makeToken(JavaToken token, Source source, Integer start, Integer end) {
    return new SourceToken<JavaToken>(token, span(source, start, end));
  }

  private static Span span(final Source source, final Integer start, final Integer end) {
    return source.getSpan(start, end);
  }

  public JavaScanner(Source input) {
    super(JavaLexicalSpecification.instance, actions, preprocess(input));
  }

  private static Source preprocess(Source input) {
    return new JavaPreprocessor().preprocess(input);
  }
}
