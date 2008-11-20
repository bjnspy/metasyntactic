// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.python.scanner;

import com.google.automata.compiler.framework.parsers.SimpleSpan;
import com.google.automata.compiler.framework.parsers.Source;
import com.google.automata.compiler.framework.parsers.SourceToken;
import com.google.automata.compiler.framework.parsers.Span;
import com.google.automata.compiler.framework.parsers.SyntaxException;
import com.google.automata.compiler.framework.parsers.packrat.AbstractPackratParser;
import com.google.automata.compiler.python.parser.PythonGrammar;
import com.google.automata.compiler.python.scanner.delimiters.LeftBracketDelimiterToken;
import com.google.automata.compiler.python.scanner.delimiters.LeftCurlyDelimiterToken;
import com.google.automata.compiler.python.scanner.delimiters.LeftParenthesisDelimiterToken;
import com.google.automata.compiler.python.scanner.delimiters.RightBracketDelimiterToken;
import com.google.automata.compiler.python.scanner.delimiters.RightCurlyDelimiterToken;
import com.google.automata.compiler.python.scanner.delimiters.RightParenthesisDelimiterToken;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Queue;
import java.util.Set;

/**
 * TODO(cyrusn): javadoc
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class PythonLexicalAnalyzer {
  public List<SourceToken<PythonToken>> analyze(List<SourceToken<PythonToken>> tokens) {

    List<SourceToken<PythonToken>> result = tokens;

    result = processExplicitLineJoins(result);
    result = processComments(result);
    result = processImplicitLineJoins(result);
    result = processBlankLines(result);
    result = processIndentation(result);
    result = processWhitespace(result);

    return result;
  }

  private List<SourceToken<PythonToken>> processWhitespace(
      List<SourceToken<PythonToken>> tokens) {
    if (tokens.isEmpty()) {
      return tokens;
    }

    List<SourceToken<PythonToken>> result = new ArrayList<SourceToken<PythonToken>>();

    for (SourceToken<PythonToken> token : tokens) {
      if (!isWhitespace(token.getToken())) {
        result.add(token);
      }
    }

    return result;
  }

  private static List<SourceToken<PythonToken>> processComments(
      List<SourceToken<PythonToken>> tokens) {
    if (tokens.isEmpty()) {
      return tokens;
    }

    List<SourceToken<PythonToken>> result = new ArrayList<SourceToken<PythonToken>>();

    for (SourceToken<PythonToken> token : tokens) {
      if (!isComment(token.getToken())) {
        result.add(token);
      }
    }

    return result;
  }

  private static List<SourceToken<PythonToken>> processIndentation(List<SourceToken<PythonToken>> tokens) {
    if (tokens.isEmpty()) {
      return tokens;
    }

    // Indentation
    // Leading whitespace (spaces and tabs) at the beginning of a logical line
    // is used to compute the indentation level of the line, which in turn is
    // used to determine the grouping of statements.
    //
    // First, tabs are replaced (from left to right) by one to eight spaces such
    // that the total number of characters up to and including the replacement
    // is a multiple of eight (this is intended to be the same rule as used by
    // Unix). The total number of spaces preceding the first non-blank character
    // then determines the line's indentation. Indentation cannot be split over
    // multiple physical lines using backslashes; the whitespace up to the first
    // backslash determines the indentation.
    //
    // A formfeed character may be present at the start of the line; it will be
    // ignored for the indentation calculations above. Formfeed characters
    // occurring elsewhere in the leading whitespace have an undefined effect
    // (for instance, they may reset the space count to zero).
    //
    // The indentation levels of consecutive lines are used to generate INDENT
    // and DEDENT tokens, using a stack, as follows.
    //
    // Before the first line of the file is read, a single zero is pushed on the
    // stack; this will never be popped off again. The numbers pushed on the
    // stack will always be strictly increasing from bottom to top. At the
    // beginning of each logical line, the line's indentation level is compared
    // to the top of the stack. If it is equal, nothing happens. If it is
    // larger, it is pushed on the stack, and one INDENT token is generated. If
    // it is smaller, it must be one of the numbers occurring on the stack; all
    // numbers on the stack that are larger are popped off, and for each number
    // popped off a DEDENT token is generated. At the end of the file, a DEDENT
    // token is generated for each number remaining on the stack that is larger
    // than zero.
    List<SourceToken<PythonToken>> result = new ArrayList<SourceToken<PythonToken>>();
    Queue<Integer> stack = Collections.asLifoQueue(new ArrayDeque<Integer>());
    stack.add(0);

    boolean afterNewLine = true;

    for (int i = 0; i < tokens.size(); i++) {
      SourceToken<PythonToken> token = tokens.get(i);

      if (afterNewLine) {
        int currentIndent = 0;

        for (int j = i; j < tokens.size(); j++) {
          if (isWhitespace(tokens.get(j).getToken())) {
            currentIndent += calculateLength(tokens.get(j).getToken().getText());
          } else {
            i = j;
            break;
          }
        }

        if (currentIndent == stack.peek()) {
          // ignore
        } else {
          Span span = new SimpleSpan(
              token.getSpan().getStartPosition(),
              token.getSpan().getStartPosition());

          if (currentIndent > stack.peek()) {
            stack.add(currentIndent);
            result.add(new SourceToken<PythonToken>(IndentToken.instance, span));
          } else {
            while (stack.peek() > currentIndent) {
              stack.remove();
              result.add(new SourceToken<PythonToken>(DedentToken.instance, span));
            }

            if (currentIndent != stack.peek()) {
              throw new SyntaxException("Incorrect indentation: " + tokens.get(i));
            }
          }
        }
      }

      token = tokens.get(i);
      result.add(token);
      afterNewLine = isNewLine(token.getToken());
    }

    SourceToken<PythonToken> lastToken = tokens.get(tokens.size() - 1);
    Span span = new SimpleSpan(
        lastToken.getSpan().getEndPosition(),
        lastToken.getSpan().getEndPosition());

    while (stack.poll() != 0) {
      result.add(new SourceToken<PythonToken>(DedentToken.instance, span));
    }

    return result;
  }

  private static int calculateLength(String text) {
    int length = 0;

    for (int i = 0; i < text.length(); i++) {
      switch (text.charAt(i)) {
        case ' ':
          length++;
          break;

        case '\t':
          length += (8 - (length % 8));
          break;
      }
    }

    return length;
  }

  private static List<SourceToken<PythonToken>> processBlankLines(
      List<SourceToken<PythonToken>> tokens) {
    if (tokens.isEmpty()) {
      return tokens;
    }

    // Blank lines
    // A logical line that contains only spaces, tabs, formfeeds and possibly a
    // comment, is ignored (i.e., no NEWLINE token is generated).
    List<SourceToken<PythonToken>> result = new ArrayList<SourceToken<PythonToken>>();

    boolean afterNewLine = true;

    outer:
    for (int i = 0; i < tokens.size(); i++) {
      SourceToken<PythonToken> token = tokens.get(i);
      PythonToken pyToken = token.getToken();

      if (afterNewLine) {
        inner:
        for (int j = i; j < tokens.size(); j++) {
          if (isWhitespace(tokens.get(j).getToken())) {
            // skip these tokens
          } else if (isNewLine(tokens.get(j).getToken()) || j == tokens.size() - 1) {
            // we want to skip this line entirely
            i = j;
            continue outer;
          } else {
            // wasn't a blank line.  process normally
            break;
          }
        }
      }

      afterNewLine = isNewLine(pyToken);
      result.add(token);
    }

    return result;
  }

  private static List<SourceToken<PythonToken>> processImplicitLineJoins
      (List<SourceToken<PythonToken>> tokens) {
    if (tokens.isEmpty()) {
      return tokens;
    }

    // Implicit line joining
    // Expressions in parentheses, square brackets or curly braces can be split
    // over more than one physical line without using backslashes
    List<SourceToken<PythonToken>> result = new ArrayList<SourceToken<PythonToken>>();
    int openCount = 0;

    for (SourceToken<PythonToken> token : tokens) {
      PythonToken pyToken = token.getToken();
      if (pyToken == LeftParenthesisDelimiterToken.instance ||
          pyToken == LeftBracketDelimiterToken.instance ||
          pyToken == LeftCurlyDelimiterToken.instance) {
        openCount++;
      } else if (pyToken == RightParenthesisDelimiterToken.instance ||
          pyToken == RightBracketDelimiterToken.instance ||
          pyToken == RightCurlyDelimiterToken.instance) {
        openCount--;
        if (openCount < 0) {
          throw new SyntaxException("Mismatched delimiter: " + token);
        }
      } else if (isNewLine(pyToken) && openCount > 0) {
        // ignore this newline
        continue;
      }

      result.add(token);
    }

    return result;
  }

  private static boolean isNewLine(PythonToken token) {
    return NewlineToken.class.isAssignableFrom(token.getClass());
  }

  private static boolean isComment(PythonToken token) {
    return CommentToken.class.isAssignableFrom(token.getClass());
  }

  private static boolean isWhitespace(PythonToken token) {
    return WhitespaceToken.class.isAssignableFrom(token.getClass());
  }

  private static List<SourceToken<PythonToken>> processExplicitLineJoins(
      List<SourceToken<PythonToken>> tokens) {
    if (tokens.isEmpty()) {
      return tokens;
    }

    List<SourceToken<PythonToken>> result = new ArrayList<SourceToken<PythonToken>>();

    // Explicit line joining
    // Two or more physical lines may be joined into logical lines using
    // backslash characters (\), as follows: when a physical line ends in a
    // backslash that is not part of a string literal or comment, it is joined
    // with the following forming a single logical line, deleting the backslash
    // and the following end-of-line character.
    for (int i = 0; i < tokens.size(); i++) {
      SourceToken<PythonToken> token = tokens.get(i);
      if (token.getToken() != LineContinuationToken.instance) {
        result.add(token);
      } else if (i + 1 >= tokens.size()) {
        // done
      } else {
        SourceToken<PythonToken> nextToken = tokens.get(i + 1);

        if (!isNewLine(nextToken.getToken())) {
          throw new SyntaxException(
              "Token following line continuation character was not a new line: " + nextToken);
        }

        // Skip both the line continuation and the new line
        i++;
      }
    }

    return result;
  }

  static long totalInterpreterTime;
  static long totalParserTime;
  static long totalLexTime;
  static long totalFiles;
  static long totalFileSize;

  public static void main(String... args) throws IOException {
    //System.out.println(JavaGrammar.instance);

    if (false) {
      String input =
          "def perm(l):\n" +
          "        # Compute the list of all permutations of l\n" +
          "    if len(l) <= 1:\n" +
          "                  return [l]\n" +
          "    r = []\n" +
          "    for i in range(len(l)):\n" +
          "             s = l[:i] + l[i+1:]\n" +
          "             p = perm(s)\n" +
          "             for x in p:\n" +
          "              r.append(l[i:i+1] + x)\n" +
          "    return r";

      List<SourceToken<PythonToken>> tokens = new PythonScanner(new Source(input)).scan();
      List<SourceToken<PythonToken>> analyzedTokens = new PythonLexicalAnalyzer().analyze(tokens);
      System.out.println(analyzedTokens);

      return;
    }

    File start = new File("/home/cyrusn/Desktop/Lib");
    //File start = new File("/Users/cyrusn/Downloads/src/");
    Set<String> files = new LinkedHashSet<String>();
    collectFiles(start, files);

    for (String file : files) {
      processFile(new File(file));
    }

    System.out.println("Total ITime: " + totalInterpreterTime);
    System.out.println("Total PTime: " + totalParserTime);
    System.out.println("Total LTime: " + totalLexTime);
    System.out.println("Total Files: " + totalFiles);
    System.out.println("Total Size : " + totalFileSize);
  }

  private static void collectFiles(File start, Set<String> files) {
    for (File file : start.listFiles()) {
      if (file.isDirectory()) {
        collectFiles(file, files);
      } else if (file.getName().endsWith(".py")) {
        files.add(file.getPath());
      }
    }
  }

  private static void processFile(File file) throws IOException {
    if (file.getName().contains("X-")) {
      return;
    }

    totalFiles++;
    totalFileSize += file.length();

    String input = readFile(file);

    List<SourceToken<PythonToken>> tokens;
    {
      long start = System.currentTimeMillis();
      tokens = new PythonScanner(new Source(input)).scan();
      long diff = System.currentTimeMillis() - start;

      totalLexTime += diff;

      if (tokens == null) {
        System.out.println("Couldn't lex: " + file);
      }
    }
    List<SourceToken<PythonToken>> analyzedTokens = new PythonLexicalAnalyzer().analyze(tokens);

    {
      long start = System.currentTimeMillis();
      AbstractPackratParser<PythonToken> parser = PythonGrammar.instance.createParser(analyzedTokens);
      Object result = parser.parse();
      long diff = System.currentTimeMillis() - start;

      totalInterpreterTime += diff;

      if (result == null) {
        System.out.println("Couldn't parse: " + file);
      }
    }

    System.out.println("Parsed: " + file);
  }

  public static String readFile
      (File
          file) throws IOException {
    Reader in = new BufferedReader(new FileReader(file));

    StringBuilder sb = new StringBuilder();
    char[] chars = new char[1 << 16];
    int length;

    while ((length = in.read(chars)) > 0) {
      sb.append(chars, 0, length);
    }

    in.close();
    return sb.toString();
  }
}