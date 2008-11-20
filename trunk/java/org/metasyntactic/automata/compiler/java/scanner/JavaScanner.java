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

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.*;

public class JavaScanner extends PackratScanner<JavaToken> {
  private final static Map<String, Function4<Object, Source, Integer, Integer, Object>> actions =
      new IdentityHashMap<String, Function4<Object, Source, Integer, Integer, Object>>();

  static {
    final Set<String> keywords = new HashSet<String>(Arrays.asList(KeywordToken.getKeywords()));

    actions.put(JavaLexicalSpecification.KEYWORD_OR_IDENTIFIER_RULE.getVariable(),
        new Function4<Object, Source, Integer, Integer, Object>() {
          @Override
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
          @Override
          public Object apply(Object argument1, Source source, Integer start, Integer end) {
            String text = source.getText().substring(start, end);
            return makeToken(SeparatorToken.getSeparatorToken(text), source, start, end);
          }
        });

    actions.put(JavaLexicalSpecification.OPERATOR_RULE.getVariable(),
        new Function4<Object, Source, Integer, Integer, Object>() {
          @Override
          public Object apply(Object argument1, Source source, Integer start, Integer end) {
            String text = source.getText().substring(start, end);
            return makeToken(OperatorToken.getOperatorToken(text), source, start, end);
          }
        });

    addAction(JavaLexicalSpecification.WHITESPACE_RULE, WhitespaceToken.class);
    addAction(JavaLexicalSpecification.CHARACTER_LITERAL_RULE, CharacterLiteralToken.class);
    addAction(JavaLexicalSpecification.COMMENT_RULE, CommentToken.class);
    addAction(JavaLexicalSpecification.FLOATING_POINT_LITERAL_RULE, FloatingPointLiteralToken.class);
    addAction(JavaLexicalSpecification.INTEGER_LITERAL_RULE, IntegerLiteralToken.class);
    addAction(JavaLexicalSpecification.ERROR_RULE, ErrorToken.class);
    addAction(JavaLexicalSpecification.STRING_LITERAL_RULE, StringLiteralToken.class);
  }

  private static void addAction(Rule rule, Class<? extends JavaToken> tokenClass) {
    final Constructor<? extends JavaToken> constructor;
    try {
      constructor = tokenClass.getConstructor(String.class);
    } catch (NoSuchMethodException e) {
      throw new RuntimeException(e);
    }

    actions.put(rule.getVariable(), new Function4<Object, Source, Integer, Integer, Object>() {
      @Override
      public Object apply(Object argument1, Source source, Integer start, Integer end) {
        String text = source.getText().substring(start, end);
        try {
          JavaToken token = constructor.newInstance(text);
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

  private static SourceToken<JavaToken> makeToken(JavaToken token, Source source, Integer start,
                                                  Integer end) {
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
