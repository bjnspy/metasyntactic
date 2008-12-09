// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.framework.parsers.packrat.generator.java;

import org.metasyntactic.automata.compiler.framework.parsers.packrat.PackratGrammar;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.Rule;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions.*;
import static org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions.Expression.empty;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.generator.ParserGenerator;
import org.metasyntactic.automata.compiler.java.parser.JavaGrammar;
import org.metasyntactic.automata.compiler.java.scanner.JavaToken;
import org.metasyntactic.automata.compiler.util.IndentingWriter;

import java.io.IOException;
import java.io.StringWriter;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * TODO(cyrusn): javadoc
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class JavaParserGenerator<TTokenType> implements ParserGenerator {
  private final PackratGrammar<TTokenType> grammar;
  private final String namespace;
  private final String name;

  private final StringWriter stringWriter = new StringWriter();
  private final IndentingWriter writer = new IndentingWriter(stringWriter);

  public JavaParserGenerator(PackratGrammar<TTokenType> grammar, String name, String namespace) {
    this.grammar = grammar;
    this.name = name;
    this.namespace = namespace;
  }

  @Override public String generate() {
    try {
      generateWorker();
    } catch (IOException e) {
      throw new RuntimeException(e);
    }

    return stringWriter.toString();
  }

  private void generateWorker() throws IOException {
    writer.writeLine("package " + namespace + ";");
    writer.writeLine();
    writer.writeLine("import java.util.*;");
    writer.writeLine("import org.metasyntactic.automata.compiler.framework.parsers.*;");
    writer.writeLine("import org.metasyntactic.automata.compiler.java.scanner.*;\n" +
                     "import org.metasyntactic.automata.compiler.java.scanner.keywords.*;\n" +
                     "import org.metasyntactic.automata.compiler.java.scanner.literals.*;\n" +
                     "import org.metasyntactic.automata.compiler.java.scanner.operators.*;\n" +
                     "import org.metasyntactic.automata.compiler.java.scanner.separators.*;");
    writer.writeLine();
    writer.writeLineAndIndent("public abstract class " + name + " {");

    writer.writeLine("protected static class EvaluationResult {\n" +
                     "  public static final EvaluationResult failure = new EvaluationResult(false, 0);\n" + "\n" +
                     "  public final boolean succeeded;\n" +
                     "  private final int position;\n" +
                     "  private final Object value;\n" + "\n" +
                     "  public EvaluationResult(boolean succeeded, int position, Object value) {\n" +
                     "    this.succeeded = succeeded;\n" +
                     "    this.position = position;\n" +
                     "    this.value = value;\n" +
                     "  }\n" + "\n" +
                     "  public EvaluationResult(boolean succeeded, int position) {\n" +
                     "    this(succeeded, position, null);\n" +
                     "  }\n" + "\n" +
                     "  public int getPosition() {\n" + "      return position;\n" + "    }\n" + "\n" +
                     "  public Object getValue() {\n" + "      return value;\n" + "    }\n" + "\n" +
                     "  @Override public String toString() {\n" +
                     "    if (succeeded) {\n" +
                     "      return \"(Result succeeded \" + position + (value == null ? \")\" : value + \")\");\n" +
                     "    } else {\n" +
                     "      return \"(Result failed)\";\n" +
                     "    }\n" +
                     "  }\n" +
                     "}\n" +
                     "\n" +
                     "private static Map<Integer, EvaluationResult> initializeMap(Map<Integer,EvaluationResult> map) {\n" +
                     "  if (map == null) {\n" +
                     "    map = new HashMap<Integer,EvaluationResult>();\n" +
                     "  }\n" +
                     "\n" +
                     "  return map;\n" +
                     "}");

    writer.writeLine("protected final List<SourceToken<Token>> tokens;");
    writer.writeLine();

    writer.writeLineAndIndent("protected " + name + "(List<SourceToken<Token>> tokens) {");
    writer.writeLine("this.tokens = new ArrayList<SourceToken<Token>>(tokens);");
    writer.dedentAndWriteLine("}");
    writer.writeLine();

    writer.writeLine("  private static List<Object> trimList(ArrayList<Object> values) {\n" +
                     "    if (values == null || values.isEmpty()) {\n" +
                     "      return Collections.emptyList();\n" +
                     "    } else if (values.size() == 1) {\n" +
                     "      return Collections.singletonList(values.get(0));\n" + "    } else {\n" +
                     "      values.trimToSize();\n" + "      return values;\n" + "    }\n" + "  }\n" + "\n" +
                     "  private ArrayList<Object> addValue(ArrayList<Object> values, EvaluationResult result) {\n" +
                     "    Object value = result.getValue();\n" + "\n" + "    if (value != null) {\n" +
                     "      if (values == null) {\n" + "        values = new ArrayList<Object>();\n" + "      }\n" +
                     "\n" + "      values.add(value);\n" + "    }\n" + "\n" + "    return values;\n" + "  }\n" + "\n" +
                     "  private EvaluationResult evaluateToken(int position, Token expected) {\n" +
                     "    if (position < tokens.size()) {\n" +
                     "      SourceToken<Token> token = tokens.get(position);\n" +
                     "      if (expected.equals(token.getToken())) {\n" +
                     "        return new EvaluationResult(true, position + 1, token);\n" + "      }\n" + "    }\n" +
                     "    return EvaluationResult.failure;\n" + "  }");

    writer.writeLine();

    writer.writeLineAndIndent("public Object parse() {");
    writer.writeLine("EvaluationResult result = parse" + grammar.getStartRule().getVariable() + "(0);");
    writer.writeLineAndIndent("if (result.succeeded) {");
    writer.writeLine("return result.getValue();");
    writer.dedentWriteLineAndIndent("} else {");
    writer.writeLine("return null;");
    writer.dedentAndWriteLine("}");
    writer.dedentAndWriteLine("}");

    for (Rule rule : grammar.getRules()) {
      writeCheckTokenMethod(rule);
    }

    for (Rule rule : grammar.getRules()) {
      createExpressionNames(rule.getVariable(), rule.getExpression());
    }

    for (Expression expression : expressionMap.keySet()) {
      writeEvaluateMethod(expression);
    }

    for (Rule rule : grammar.getRules()) {
      writeParseMethod(rule);
    }

    for (Rule rule : grammar.getRules()) {
      writeFunctions(rule);
    }

    writer.dedentAndWriteLine("}");
  }

  private boolean canCheckFirstToken(Rule rule) {
    return !grammar.isNullable(rule.getVariable()) && !grammar.acceptsAnyToken(rule.getVariable());
  }

  private void writeCheckTokenMethod(Rule rule) {
    if (!canCheckFirstToken(rule)) {
      return;
    }
    writer.writeLineAndIndent("private boolean checkToken_" + rule.getVariable() + "(int position) {");
    writer.writeLineAndIndent("if (position < tokens.size()) {");
    writer.writeLine("Token token = tokens.get(position).getToken();");
    writer.writeLine("// Fall through any matching cases");
    writer.writeLineAndIndent("switch (token.getType()) {");
    writer.writeLine("default: return false;");
    for (int i : grammar.getFirstTokens(rule.getVariable())) {
      writer.writeLine("case " + i + ": // " + grammar.getTokenFromTerminal(i));
    }
    writer.dedentAndWriteLine("}");
    writer.dedentAndWriteLine("}");
    writer.writeLine("return true;");
    writer.dedentAndWriteLine("}");
    writer.writeLine();
  }

  private void writeFunctions(Rule rule) {
    rule.getExpression().accept(new RecursionExpressionVisitor() {
      @Override public void visit(FunctionExpression expression) {
        writer.writeLine();
        writer.writeLine("protected abstract EvaluationResult " + expression.getName() + "(int position);");
      }
    });
  }

  private void writeParseMethod(Rule rule) throws IOException {
    writer.writeLine();

    writer.writeLine("private Map<Integer,EvaluationResult> " + getMapName(rule) + ";");

    writer.writeLineAndIndent("private EvaluationResult parse" + rule.getVariable() + "(int position) {");
    writer.writeLine("EvaluationResult result = (" + getMapName(rule) + " == null ? null : " + getMapName(rule) +
                     ".get(position));");

    writer.writeLineAndIndent("if (result == null) {");
    if (canCheckFirstToken(rule)) {
      writer.writeLineAndIndent("if (checkToken_" + rule.getVariable() + "(position)) {");
      writer.writeLine("result = " + callExpression(rule.getExpression(), "position") + ";");
      writer.dedentWriteLineAndIndent("} else {");
      writer.writeLine("result = EvaluationResult.failure;");
      writer.dedentAndWriteLine("}");
    } else {
      writer.writeLine("result = " + callExpression(rule.getExpression(), "position") + ";");
    }
    writer.writeLine(getMapName(rule) + " = initializeMap(" + getMapName(rule) + ");");
    writer.writeLine(getMapName(rule) + ".put(position, result);");
    writer.dedentAndWriteLine("}");

    writer.writeLine("return result;");
    writer.dedentAndWriteLine("}");
  }

  private String callExpression(Expression expr, final String position) {
    return expr.accept(new DefaultExpressionVisitor<Object, String>() {
      @Override protected String defaultCase(Expression expression) {
        return "evaluate" + expressionMap.get(expression) + "(" + position + ")";
      }

      @Override public String visit(VariableExpression expression) {
        return "parse" + expression.getVariable() + "(" + position + ")";
      }

      @Override public String visit(EmptyExpression expression) {
        return "new EvaluationResult(true, " + position + ")";
      }

      @Override public String visit(TokenExpression expression) {
        return "evaluateToken(" + position + ", " + expression.getToken().getClass().getSimpleName() + ".instance)";
      }

      @Override public String visit(FunctionExpression<Object> expression) {
        return expression.getName() + "(" + position + ")";
      }
    });
  }

  private void writeEvaluateMethod(Expression expression) throws IOException {
    writer.writeLineAndIndent("private EvaluationResult evaluate" + expressionMap.get(expression) + "(int position) {");

    expression.accept(new ExpressionVoidVisitor() {
      @Override public void visit(EmptyExpression emptyExpression) {
        throw new UnsupportedOperationException();
      }

      @Override public void visit(CharacterExpression characterExpression) {
        throw new UnsupportedOperationException();
      }

      @Override public void visit(TerminalExpression terminalExpression) {
        throw new UnsupportedOperationException();
      }

      @Override public void visit(VariableExpression variableExpression) {
        throw new UnsupportedOperationException();
      }

      @Override public void visit(FunctionExpression objectFunctionExpression) {
        throw new UnsupportedOperationException();
      }

      @Override public void visit(SequenceExpression sequenceExpression) {
        writer.writeLine("ArrayList<Object> values = null;");
        writer.writeLine();

        Expression[] children = sequenceExpression.getChildren();

        writer.writeLine("EvaluationResult result = " + callExpression(children[0], "position") + ";");
        writer.writeLine("if (!result.succeeded) { return EvaluationResult.failure; }");
        writer.writeLine("values = addValue(values, result);");
        writer.writeLine();

        for (int i = 1; i < children.length; i++) {
          writer.writeLine("result = " + callExpression(children[i], "result.getPosition()") + ";");
          writer.writeLine("if (!result.succeeded) { return EvaluationResult.failure; }");
          writer.writeLine("values = addValue(values, result);");
          writer.writeLine();
        }

        writer.writeLine("return new EvaluationResult(true, result.getPosition(), trimList(values));");
      }

      @Override public void visit(DelimitedSequenceExpression sequenceExpression) {
        writer.writeLine("ArrayList<Object> elements = null;");
        writer.writeLine("ArrayList<Object> delimiters = null;");

        writer.writeLine(
            "EvaluationResult result = " + callExpression(sequenceExpression.getElement(), "position") + ";");
        writer.writeLine("if (!result.succeeded) { return EvaluationResult.failure; }");
        writer.writeLine("elements = addValue(elements, result);");
        writer.writeLineAndIndent("while (true) {");
        writer.writeLine("int currentPosition = result.position;");
        writer.writeLine();
        writer.writeLine("EvaluationResult delimiterResult = " +
                         callExpression(sequenceExpression.getDelimiter(), "currentPosition") + ";");
        writer.writeLineAndIndent("if (!delimiterResult.succeeded) {");
        writer.writeLine(
            "return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));");
        writer.dedentAndWriteLine("}");
        writer.writeLine();
        writer.writeLine(
            "result = " + callExpression(sequenceExpression.getElement(), "delimiterResult.position") + ";");
        writer.writeLineAndIndent("if (!result.succeeded) {");
        if (sequenceExpression.allowsTrailingDelimiter()) {
          // accept the last delimiter.
          writer.writeLine("delimiters = addValue(delimiters, delimiterResult)");
        }
        writer.writeLine(
            "return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));");
        writer.dedentAndWriteLine("}");
        writer.writeLine("elements = addValue(elements, result);");
        writer.dedentAndWriteLine("}");

        /*
           EvaluationResult delimiterResult = evaluateExpression(currentPosition, sequenceExpression.getDelimiter());
        if (delimiterResult.isFailure()) {
          return new EvaluationResult(currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
        }

        result = evaluateExpression(delimiterResult.position, sequenceExpression.getElement());
        if (result.isFailure()) {
          if (sequenceExpression.allowsTrailingDelimiter()) {
            // accept the last delimiter.
            delimiters = addValue(delimiters, delimiterResult);
          }

          return new EvaluationResult(currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
        }

        elements = addValue(elements, result);
      }
         */
      }

      @Override public void visit(ChoiceExpression choiceExpression) {
        writer.writeLine("EvaluationResult result;");

        Expression[] children = choiceExpression.getChildren();

        for (int i = 0; i < children.length - 1; i++) {
          writer.writeLine(
              "if ((result = " + callExpression(children[i], "position") + ").succeeded) { return result; }");
        }

        writer.writeLine("return " + callExpression(children[children.length - 1], "position") + ";");
      }

      @Override public void visit(OptionalExpression optionalExpression) {
        writer.writeLine("EvaluationResult result;");
        writer.writeLine("if ((result = " + callExpression(optionalExpression.getChild(), "position") +
                         ").succeeded) { return result; }");

        writer.writeLine("return " + callExpression(empty(), "position") + ";");
      }

      @Override public void visit(NotExpression notExpression) {
        writer.writeLine("EvaluationResult result = " + callExpression(notExpression.getChild(), "position") + ";");
        writer.writeLine("return new EvaluationResult(!result.succeeded, position);");
      }

      @Override public void visit(RepetitionExpression repetitionExpression) {
        writer.writeLine("int currentPosition = position;");
        writer.writeLine("ArrayList<Object> values = null;");

        writer.writeLineAndIndent("while (true) {");
        writer.writeLine(
            "EvaluationResult result = " + callExpression(repetitionExpression.getChild(), "currentPosition") + ";");

        writer.writeLineAndIndent("if (result.succeeded) {");
        writer.writeLine("currentPosition = result.getPosition();");
        writer.writeLine("values = addValue(values, result);");
        writer.dedentWriteLineAndIndent("} else {");
        writer.writeLine("return new EvaluationResult(true, currentPosition, trimList(values));");
        writer.dedentAndWriteLine("}");
        writer.dedentAndWriteLine("}");
      }

      @Override public void visit(OneOrMoreExpression oneOrMoreExpression) {
        writer.writeLine("ArrayList<Object> values = null;");
        writer.writeLine(
            "EvaluationResult result = " + callExpression(oneOrMoreExpression.getChild(), "position") + ";");
        writer.writeLineAndIndent("if (!result.succeeded) {");
        writer.writeLine("return EvaluationResult.failure;");
        writer.dedentAndWriteLine("}");

        writer.writeLineAndIndent("while (true) {");
        writer.writeLine("int currentPosition = result.getPosition();");
        writer.writeLine("values = addValue(values, result);");
        writer.writeLine("result = " + callExpression(oneOrMoreExpression.getChild(), "currentPosition") + ";");
        writer.writeLineAndIndent("if (!result.succeeded) {");
        writer.writeLine("return new EvaluationResult(true, currentPosition, trimList(values));");
        writer.dedentAndWriteLine("}");
        writer.dedentAndWriteLine("}");
      }

      @Override public void visit(TokenExpression tokenExpression) {
        writer.writeLineAndIndent("if (position < tokens.size()) {");
        writer.writeLine("SourceToken<Token> token = tokens.get(position);");

        writer.writeLineAndIndent("if (" + tokenExpression.getToken().getClass()
            .getSimpleName() + ".instance.equals(token.getToken())) {");
        writer.writeLine("return new EvaluationResult(true, position + 1, token);");
        writer.dedentAndWriteLine("}");
        writer.dedentAndWriteLine("}");

        writer.writeLine("return EvaluationResult.failure;");
      }

      @Override public void visit(TypeExpression typeExpression) {
        writer.writeLineAndIndent("if (position < tokens.size()) {");
        writer.writeLine("SourceToken<Token> token = tokens.get(position);");

        writer.writeLine("Class<? extends Token> actualType = token.getToken().getClass();");

        writer.writeLineAndIndent("if (" + typeExpression.getType()
            .getSimpleName() + ".class.isAssignableFrom(actualType)) {");
        writer.writeLine("return new EvaluationResult(true, position + 1, token);");
        writer.dedentAndWriteLine("}");
        writer.dedentAndWriteLine("}");

        writer.writeLine("return EvaluationResult.failure;");
      }
    });

    writer.dedentAndWriteLine("}");
  }

  private void createExpressionNames(final String variable, Expression expr) {
    expr.accept(new RecursionExpressionVisitor() {

      @Override public void visit(TerminalExpression expression) {
        super.visit(expression);
        getExpressionId(variable, expression);
      }

      @Override public void visit(VariableExpression expression) {}

      @Override public void visit(TokenExpression expression) {}

      @Override public void visit(EmptyExpression expression) {}

      @Override public void visit(FunctionExpression expression) { }

      @Override public void visit(SequenceExpression expression) {
        super.visit(expression);
        getExpressionId(variable, expression);
      }

      @Override public void visit(DelimitedSequenceExpression expression) {
        super.visit(expression);
        getExpressionId(variable, expression);
      }

      @Override public void visit(ChoiceExpression expression) {
        super.visit(expression);
        getExpressionId(variable, expression);
      }

      @Override public void visit(OptionalExpression expression) {
        super.visit(expression);
        getExpressionId(variable, expression);
      }

      @Override public void visit(NotExpression expression) {
        super.visit(expression);
        getExpressionId(variable, expression);
      }

      @Override public void visit(RepetitionExpression expression) {
        super.visit(expression);
        getExpressionId(variable, expression);
      }

      @Override public void visit(OneOrMoreExpression expression) {
        super.visit(expression);
        getExpressionId(variable, expression);
      }

      @Override public void visit(TypeExpression expression) {
        super.visit(expression);
        getExpressionId(variable, expression);
      }
    });
  }

  private String getExpressionId(String variable, Expression expression) {
    String id = expressionMap.get(expression);

    if (id == null) {
      String prefix = variable + "Expression_";
      int index = 0;

      do {
        id = prefix + index++;
      } while (expressionMap.containsValue(id));

      expressionMap.put(expression, id);
    }

    return id;
  }

  private Map<Expression, String> expressionMap = new LinkedHashMap<Expression, String>();

  private static String getMapName(Rule rule) {
    return rule.getVariable() + "Map";
  }

  public static void main(String... args) {
    JavaParserGenerator generator = new JavaParserGenerator<JavaToken.Type>(JavaGrammar.instance,
                                                                            "AbstractJavaGeneratedParser",
                                                                            "org.metasyntactic.automata.compiler.java.parser");
    String result = generator.generate();
    System.out.println(result);
  }
}
