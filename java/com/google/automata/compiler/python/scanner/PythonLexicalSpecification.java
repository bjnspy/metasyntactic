package com.google.automata.compiler.python.scanner;

import com.google.automata.compiler.framework.parsers.Source;
import com.google.automata.compiler.framework.parsers.SourceToken;
import com.google.automata.compiler.framework.parsers.packrat.PackratGrammar;
import com.google.automata.compiler.framework.parsers.packrat.Rule;
import static com.google.automata.compiler.framework.parsers.packrat.expressions.Expression.*;
import com.google.automata.compiler.python.scanner.delimiters.DelimiterToken;
import com.google.automata.compiler.python.scanner.keywords.KeywordToken;
import com.google.automata.compiler.python.scanner.operators.OperatorToken;

import java.io.*;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

public class PythonLexicalSpecification extends PackratGrammar {
  private final static Rule pythonStartRule;
  private final static Set<Rule> pythonRules;

  public static Rule WHITESPACE_RULE = new Rule("Whitespace",
      oneOrMore(
          choice(
              terminal(" "),
              terminal("\t"),
              terminal("\f"))
      ));

  public static Rule NEWLINE_RULE = new Rule("NewLine",
      choice(
          "\r\n",
          "\r",
          "\n"
      ));

  public static Rule LINE_CONTINUATION_RULE = new Rule("LineContinuation",
      terminal("\\"));

  public static Rule COMMENT_RULE = new Rule("Comment",
      sequence(
          terminal("#"),
          // keep on reading characters until we hit a newline or the end of the input
          repetition(
              sequence(
                  not(
                      choice(
                          variable("NewLine"),
                          endOfStream()
                      )
                  ), anyCharacter()
              )
          )
      ));

  public static Rule KEYWORD_RULE = new Rule("Keyword",
      choice(KeywordToken.getKeywords()));

  public static Rule FLOATING_POINT_LITERAL_RULE = new Rule("FloatingPointLiteral",
      choice(
          variable("PointFloatingPointLiteral"),
          variable("ExponentFloatingPointLiteral")
      ));

  public static Rule INTEGER_LITERAL_RULE = new Rule("IntegerLiteral",
      sequence(
          choice(
              variable("OctalInteger"),
              variable("HexInteger"),
              variable("DecimalInteger")
          ),
          optional(choice("l", "L"))
      ));

  public static Rule IMAGINARY_NUMBER_LITERAL_RULE = new Rule("ImaginaryNumberLiteral",
      sequence(
          choice(
              variable("FloatingPointLiteral"),
              variable("IntegerPart")
          ),
          choice("j", "J")
      ));

  public static Rule STRING_LITERAL_RULE = new Rule("StringLiteral",
      sequence(
          optional(choice(
              "r", "u", "ur", "R", "U", "UR", "Ur", "uR"
          )),
          choice(
              variable("LongString"),
              variable("ShortString")
          )
      ));

  public static Rule IDENTIFIER_RULE = new Rule("Identifier",
      sequence(
          choice(
              variable("Letter"),
              terminal("_")
          ),
          repetition(
              choice(
                  variable("Letter"),
                  variable("Digit"),
                  terminal("_")
              )
          )
      ));

  public static Rule OPERATOR_RULE = new Rule("Operator",
      choice(OperatorToken.getOperators()));

  public static Rule DELIMITER_RULE = new Rule("Delimiter",
      choice(DelimiterToken.getDelimiters()));

  public static Rule ERROR_RULE = new Rule("Error", anyCharacter());

  static {
    pythonStartRule = new Rule("Input", repetition(variable("InputElement")));

    pythonRules = new LinkedHashSet<Rule>();
    pythonRules.add(pythonStartRule);

    makeRules(pythonRules);
  }

  private PythonLexicalSpecification() {
    super(pythonStartRule, pythonRules);
  }

  public static final PythonLexicalSpecification instance = new PythonLexicalSpecification();

  private static Set<Rule> makeRules(Set<Rule> rules) {

    // identifiers have to be last so that they don't absorb keywords or literals
    rules.add(new Rule("InputElement", choice(
        variable("Whitespace"),
        variable("NewLine"),
        variable("LineContinuation"),
        variable("Comment"),
        variable("Keyword"),
        variable("Literal"),
        variable("Identifier"),
        variable("Operator"),
        variable("Delimiter"),
        variable("Error"))));

    rules.add(WHITESPACE_RULE);
    rules.add(NEWLINE_RULE);
    rules.add(LINE_CONTINUATION_RULE);

    comments(rules);
    keywords(rules);
    literals(rules);
    identifier(rules);
    operators(rules);
    delimiters(rules);

    rules.add(ERROR_RULE);

    return rules;
  }

  private static void delimiters(Set<Rule> rules) {
    rules.add(DELIMITER_RULE);
  }

  private static void operators(Set<Rule> rules) {
    rules.add(OPERATOR_RULE);
  }

  private static void identifier(Set<Rule> rules) {
    rules.add(IDENTIFIER_RULE);

    rules.add(new Rule("Letter",
        choice(
            range('a', 'z'),
            range('A', 'Z')
        )));

    rules.add(new Rule("Digit",
        range('0', '9')));
  }

  private static void comments(Set<Rule> rules) {
    rules.add(COMMENT_RULE);

    rules.add(new Rule("TraditionalComment", sequence(
        terminal("/*"),
        repetition(sequence(not(terminal("*/")), anyCharacter())),
        terminal("*/"))));

    rules.add(new Rule("EndOfLineComment", sequence(
        terminal("//"),
        repetition(sequence(not(variable("NewLine")), anyCharacter())))));
  }

  private static void keywords(Set<Rule> rules) {
    rules.add(KEYWORD_RULE);
  }

  private static void literals(Set<Rule> rules) {
    // Floating points have to be before the integers so that the integers don't match first.
    rules.add(new Rule("Literal", choice(
        variable("FloatingPointLiteral"),
        variable("IntegerLiteral"),
        variable("StringLiteral"),
        variable("ImaginaryNumberLiteral")
    )));

    integerLiterals(rules);
    floatingPointLiterals(rules);
    stringLiterals(rules);
    imaginaryNumberLiterals(rules);
  }

  private static void imaginaryNumberLiterals(Set<Rule> rules) {
    rules.add(IMAGINARY_NUMBER_LITERAL_RULE);
  }

  private static void stringLiterals(Set<Rule> rules) {
    rules.add(STRING_LITERAL_RULE);

    rules.add(new Rule("ShortString",
        choice(
            sequence(
                terminal("'"),
                repetition(variable("SingleQuoteShortStringItem")),
                terminal("'")
            ),
            sequence(
                terminal("\""),
                repetition(variable("DoubleQuoteShortStringItem")),
                terminal("\"")
            )
        )));

    rules.add(new Rule("LongString",
        choice(
            sequence(
                terminal("'''"),
                repetition(variable("SingleQuoteLongStringItem")),
                terminal("'''")
            ),
            sequence(
                terminal("\"\"\""),
                repetition(variable("DoubleQuoteLongStringItem")),
                terminal("\"\"\"")
            )
        )));

    rules.add(new Rule("SingleQuoteShortStringItem",
        choice(
            variable("SingleQuoteStringCharacter"),
            variable("EscapeSequence")
        )));

    rules.add(new Rule("DoubleQuoteShortStringItem",
        choice(
            variable("DoubleQuoteStringCharacter"),
            variable("EscapeSequence")
        )));

    rules.add(new Rule("SingleQuoteStringCharacter",
        sequence(
            not(choice(
                terminal("\\"),
                variable("NewLine"),
                terminal("'")
            )),
            anyCharacter()
        )));

    rules.add(new Rule("DoubleQuoteStringCharacter",
        sequence(
            not(choice(
                terminal("\\"),
                variable("NewLine"),
                terminal("\"")
            )),
            anyCharacter()
        )));

    rules.add(new Rule("SingleQuoteLongStringItem",
        choice(
            variable("SingleQuoteLongStringCharacter"),
            variable("EscapeSequence")
        )));

    rules.add(new Rule("DoubleQuoteLongStringItem",
        choice(
            variable("DoubleQuoteLongStringCharacter"),
            variable("EscapeSequence")
        )));

    rules.add(new Rule("SingleQuoteLongStringCharacter",
        sequence(
            not(
                choice(
                  terminal("\\"),
                  terminal("'''")
                )
            ),
            anyCharacter()
        )));

    rules.add(new Rule("DoubleQuoteLongStringCharacter",
        sequence(
            not(
                choice(
                  terminal("\\"),
                  terminal("\"\"\"")
                )
            ),
            anyCharacter()
        )));


    rules.add(new Rule("EscapeSequence",
        sequence(
            terminal("\\"),
            anyCharacter()
        )));
  }

  private static void floatingPointLiterals(Set<Rule> rules) {
    rules.add(FLOATING_POINT_LITERAL_RULE);

    rules.add(new Rule("PointFloatingPointLiteral",
        choice(
            sequence(
                optional(variable("IntegerPart")),
                variable("Fraction")
            ),
            sequence(
                variable("IntegerPart"),
                terminal(".")
            )
        )));

    rules.add(new Rule("ExponentFloatingPointLiteral",
        sequence(
            choice(
                variable("IntegerPart"),
                variable("PointFloatingPointLiteral")
            ),
            variable("Exponent")
        )));

    rules.add(new Rule("IntegerPart",
        oneOrMore(variable("Digit"))));

    rules.add(new Rule("Fraction",
        sequence(terminal("."), variable("IntegerPart"))));

    rules.add(new Rule("Exponent",
        sequence(
            choice(
                terminal("e"),
                terminal("E")
            ),
            optional(choice(
                terminal("+"),
                terminal("-")
            )),
            variable("IntegerPart")
        )));
  }

  private static void integerLiterals(Set<Rule> rules) {
    // Note: decimal must come last so that we interpret 01 to be octal.
    rules.add(INTEGER_LITERAL_RULE);

    rules.add(new Rule("DecimalInteger",
        choice(
            sequence(range('1', '9'), repetition(variable("Digit"))),
            terminal("0")
        )));

    rules.add(new Rule("OctalInteger",
        sequence(
            terminal("0"),
            oneOrMore(range('0', '7'))
        )));

    rules.add(new Rule("HexInteger",
        sequence(
            terminal("0"),
            choice("x", "X"),
            oneOrMore(variable("HexDigit"))
        )));

    rules.add(new Rule("HexDigit",
        choice(
            variable("Digit"),
            range('a', 'f'),
            range('A', 'F')
        )));
  }

  static long totalTime = 0;
  static long fileSize = 0;
  static long fileCount = 0;

  public static void main(String... args) throws IOException {
    System.out.println(PythonLexicalSpecification.instance);

    File directory = new File("/Applications/MacPython 2.4");
    scan(directory);
  }

  private static void scan(File directory) throws IOException {
    for (File file : directory.listFiles()) {
      if (file.isDirectory()) {
        scan(file);
      } else if (file.getName().endsWith(".py")) {
        String contents = readFile(file);
        PythonScanner scanner = new PythonScanner(new Source(contents));
        List<SourceToken<PythonToken>> tokens = scanner.scan();

        if (tokens == null) {
          System.out.println("Couldn't understand: " + file.getPath());
        } else {
          for (SourceToken<PythonToken> token : tokens) {
            if (token.getToken() instanceof ErrorToken) {
              System.out.println("Got error token: " + token);
              System.out.println("  at: " + token.getSpan());
              System.out.println("  in: " + file.getPath());
            }
          }
        }
      }
    }
  }

  private static boolean restrictedFile(File child) {
    return
        child.getName().contains("X-") ||
            child.getPath().contains("auto-videos/AdSense") ||
            child.getPath().contains("Eng/podcast-test");
  }

  private static String readFile(File file) throws IOException {
    StringWriter writer = new StringWriter();
    Reader in = new FileReader(file);

    int c;
    while ((c = in.read()) != -1) {
      writer.write(c);
    }

    in.close();
    return writer.toString();
  }
}