// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.framework.parsers.packrat.generator.java;

import org.metasyntactic.automata.compiler.framework.parsers.packrat.PackratGrammar;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.Rule;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions.*;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.generator.ParserGenerator;
import org.metasyntactic.automata.compiler.java.parser.JavaGrammar;
import org.metasyntactic.automata.compiler.java.scanner.JavaToken;
import org.metasyntactic.automata.compiler.util.IndentingWriter;
import static org.metasyntactic.utilities.ReflectionUtilities.getSimpleName;

import java.io.IOException;
import java.io.StringWriter;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

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

  public String generate() {
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
                     "import org.metasyntactic.automata.compiler.java.scanner.separators.*;\n" +
                     "import static org.metasyntactic.automata.compiler.java.parser.Nodes.*;\n" +
                     "import org.metasyntactic.automata.compiler.util.ArrayDelimitedList;\n" +
                     "import org.metasyntactic.automata.compiler.util.DelimitedList;");
    writer.writeLine();
    writer.writeLineAndIndent("public abstract class " + name + " {");

    writer.writeLine("protected static class EvaluationResult<T> {\n" +
                     "  public static final EvaluationResult failure = new EvaluationResult(false, 0);\n" + "\n" +
                     "  public static <T> EvaluationResult<T> failure() { return failure; }\n" +
                     "  public final boolean succeeded;\n" +
                     "  public final int position;\n" +
                     "  public final T value;\n" + "\n" +
                     "  public EvaluationResult(boolean succeeded, int position, T value) {\n" +
                     "    this.succeeded = succeeded;\n" +
                     "    this.position = position;\n" +
                     "    this.value = value;\n" +
                     "  }\n" + "\n" +
                     "  public EvaluationResult(boolean succeeded, int position) {\n" +
                     "    this(succeeded, position, null);\n" +
                     "  }\n" + "\n" +
                     "   public String toString() {\n" +
                     "    if (succeeded) {\n" +
                     "      return \"(Result succeeded \" + position + (value == null ? \")\" : value + \")\");\n" +
                     "    } else {\n" +
                     "      return \"(Result failed)\";\n" +
                     "    }\n" +
                     "  }\n" +
                     "}\n" +
                     "\n" +
                     "private static <T> Map<Integer, EvaluationResult<? extends T>> initializeMap(Map<Integer,EvaluationResult<? extends T>> map) {\n" +
                     "  if (map == null) {\n" +
                     "    map = new HashMap<Integer,EvaluationResult<? extends T>>();\n" +
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

    writer.writeLine("private static <T> List<T> trimList(ArrayList<T> values) {\n" +
                     "  if (values == null || values.isEmpty()) {\n" +
                     "    return Collections.emptyList();\n" +
                     "  } else if (values.size() == 1) {\n" +
                     "    return Collections.singletonList(values.get(0));\n" +
                     "  } else {\n" +
                     "    values.trimToSize();\n" +
                     "    return values;\n" +
                     "  }\n" +
                     "}\n" +
                     "\n" +
                     "private <T> ArrayList<T> addValue(ArrayList<T> values, T value) {\n" +
                     "  if (value != null) {\n" +
                     "    if (values == null) {\n" +
                     "      values = new ArrayList<T>();\n" +
                     "    }\n" +
                     "\n" +
                     "    values.add(value);\n" +
                     "  }\n" +
                     "\n" +
                     "  return values;\n" +
                     "}\n" +
                     "\n");

    writer.writeLine();

    writer.writeLineAndIndent("public " + getNodeName(grammar.getStartRule()) + " parse() {");
    writer.writeLine("EvaluationResult<? extends " + getNodeName(grammar.getStartRule()) + "> result = parse" +
                     grammar.getStartRule().getVariable() + "(0);");
    writer.writeLineAndIndent("if (result.succeeded) {");
    writer.writeLine("return result.value;");
    writer.dedentWriteLineAndIndent("} else {");
    writer.writeLine("return null;");
    writer.dedentAndWriteLine("}");
    writer.dedentAndWriteLine("}");

    for (Rule rule : grammar.getRules()) {
      writeCheckTokenMethod(rule);
    }

    writeBoxTokenMethods();

    for (Rule rule : grammar.getRules()) {
      createExpressionNames(rule.getVariable(), rule.getExpression());
    }

    for (Expression expression : expressionNamesMap.keySet()) {
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

  private void writeBoxTokenMethods() {
    Set<String> tokens = new TreeSet<String>();

    for (Rule rule : grammar.getRules()) {
      Expression expression = rule.getExpression();
      if (expression instanceof ChoiceExpression) {
        ChoiceExpression ce = (ChoiceExpression) expression;

        for (Expression child : ce.getChildren()) {
          if (child instanceof TokenExpression) {
            TokenExpression te = (TokenExpression) child;
            tokens.add(getSimpleName(te.getToken().getClass()));
          } else if (child instanceof TypeExpression) {
            TypeExpression te = (TypeExpression) child;
            tokens.add(te.getName());
          } else if (child instanceof VariableExpression) {
          } else {
            throw new RuntimeException();
          }
        }
      } else if (expression instanceof TokenExpression) {
        TokenExpression te = (TokenExpression) expression;
        tokens.add(getSimpleName(te.getToken().getClass()));
      } else if (expression instanceof TypeExpression) {
        TypeExpression te = (TypeExpression) expression;
        tokens.add(te.getName());
      }
    }

    for (String token : tokens) {
      writer.writeLineAndIndent("private EvaluationResult<I" + token + "Node> box" + token +
                                "(EvaluationResult<? extends SourceToken<" + token + ">> result) {");
      writer.writeLine("if (!result.succeeded) { return EvaluationResult.failure(); }");
      writer.writeLine("return new EvaluationResult<I" + token + "Node>(true, result.position, new " + token +
                       "Node(result.value));");
      writer.dedentAndWriteLine("}");
    }
  }

  public String getNodeName(Rule rule) {
    return "I" + rule.getVariable() + "Node";
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
      public void visit(FunctionExpression expression) {
        writer.writeLine();
        writer.writeLine("protected abstract EvaluationResult " + expression.getName() + "(int position);");
      }
    });
  }

  private void writeParseMethod(Rule rule) throws IOException {
    Expression expression = rule.getExpression();

    if (expression instanceof TokenExpression || expression instanceof TypeExpression) {
      writeTokenParseMethod(rule);
    } else {
      writeNormalParseMethod(rule);
    }
  }

  private void writeTokenParseMethod(Rule rule) throws IOException {
    writer.writeLine();

    Expression expression = rule.getExpression();
    String tokenType = "";
    if (expression instanceof TokenExpression) {
      tokenType = "SourceToken<" + getSimpleName(((TokenExpression) expression).getToken().getClass()) + ">";
    } else {
      tokenType = "SourceToken<" + ((TypeExpression) expression).getName() + ">";
    }

    String interfaceName = getNodeName(rule);
    String className = interfaceName.substring(1);

    writer.writeLine(
        "private Map<Integer,EvaluationResult<? extends " + interfaceName + ">> " + getMapName(rule) + ";");

    writer.writeLineAndIndent(
        "private EvaluationResult<? extends " + interfaceName + "> parse" + rule.getVariable() +
        "(int position) {");
    writer.writeLine("EvaluationResult<? extends " + interfaceName + "> result = (" + getMapName(rule) +
                     " == null ? null : " + getMapName(rule) +
                     ".get(position));");

    writer.writeLineAndIndent("if (result == null) {");

    writer.writeLine("EvaluationResult<? extends " + tokenType + "> subresult = EvaluationResult.failure();");
    writer.writeLine("subresult = " + callExpression(rule.getExpression(), "position") + ";");

    writer.writeLineAndIndent("if (subresult.succeeded) {");
    writer.writeLine("result = new EvaluationResult<" + interfaceName +
                     ">(true, subresult.position, new " + className + "(subresult.value));");

    writer.dedentWriteLineAndIndent("} else {");
    writer.writeLine("result = EvaluationResult.failure();");
    writer.dedentAndWriteLine("}");

    writer.writeLine(getMapName(rule) + " = initializeMap(" + getMapName(rule) + ");");
    writer.writeLine(getMapName(rule) + ".put(position, result);");
    writer.dedentAndWriteLine("}");

    writer.writeLine("return result;");
    writer.dedentAndWriteLine("}");
  }

  private void writeNormalParseMethod(Rule rule) throws IOException {
    writer.writeLine();

    String interfaceName = getNodeName(rule);

    writer.writeLine(
        "private Map<Integer,EvaluationResult<? extends " + interfaceName + ">> " + getMapName(rule) + ";");

    writer.writeLineAndIndent(
        "private EvaluationResult<? extends " + interfaceName + "> parse" + rule.getVariable() +
        "(int position) {");
    writer.writeLine("EvaluationResult<? extends " + interfaceName + "> result = (" + getMapName(rule) +
                     " == null ? null : " + getMapName(rule) +
                     ".get(position));");

    writer.writeLineAndIndent("if (result == null) {");
    if (canCheckFirstToken(rule)) {
      writer.writeLineAndIndent("if (checkToken_" + rule.getVariable() + "(position)) {");
      writer.writeLine("result = " + callExpression(rule.getExpression(), "position") + ";");
      writer.dedentWriteLineAndIndent("} else {");
      writer.writeLine("result = EvaluationResult.failure();");
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
    return callExpression(expr, position, true);
  }

  private String callExpression(Expression expr, final String position, final boolean allowRawTokens) {
    return expr.accept(new DefaultExpressionVisitor<Object, String>() {
      protected String defaultCase(Expression expression) {
        return "evaluate" + expressionNamesMap.get(expression) + "(" + position + ")";
      }

      public String visit(VariableExpression expression) {
        return "parse" + expression.getVariable() + "(" + position + ")";
      }

      public String visit(EmptyExpression expression) {
        return "new EvaluationResult(true, " + position + ")";
      }

      public String visit(TokenExpression expression) {
        if (allowRawTokens) {
          return defaultCase(expression);
        } else {
          return "box" + getSimpleName(expression.getToken().getClass()) +
                 "(" + defaultCase(expression) + ")";
        }
      }

      public String visit(TypeExpression expression) {
        if (allowRawTokens) {
          return defaultCase(expression);
        } else {
          return "box" + expression.getName() +
                 "(" + defaultCase(expression) + ")";
        }
      }

      public String visit(FunctionExpression<Object> expression) {
        return expression.getName() + "(" + position + ")";
      }
    });
  }

  private void writeEvaluateMethod(Expression expression) throws IOException {
    final String interfaceType = getExpressionType(expression);
    final String classType = interfaceType.substring(1);

    writer.writeLineAndIndent(
        "@SuppressWarnings(\"unchecked\")\n" +
        "private EvaluationResult<? extends " + interfaceType + "> evaluate" +
        expressionNamesMap.get(expression) + "(int position) {");

    expression.accept(new ExpressionVoidVisitor() {
      public void visit(EmptyExpression emptyExpression) {
        throw new UnsupportedOperationException();
      }

      public void visit(CharacterExpression characterExpression) {
        throw new UnsupportedOperationException();
      }

      public void visit(TerminalExpression terminalExpression) {
        throw new UnsupportedOperationException();
      }

      public void visit(VariableExpression variableExpression) {
        throw new UnsupportedOperationException();
      }

      public void visit(FunctionExpression objectFunctionExpression) {
        throw new UnsupportedOperationException();
      }

      public void visit(SequenceExpression sequenceExpression) {
        Expression[] children = sequenceExpression.getChildren();

        writer.writeLine("EvaluationResult<? extends " + getExpressionType(children[0]) + "> result_" + 0 + " = " +
                         callExpression(children[0], "position") + ";");
        writer.writeLine("if (!result_" + 0 + ".succeeded) { return EvaluationResult.failure(); }");
        writer.writeLine();

        for (int i = 1; i < children.length; i++) {
          writer.writeLine("EvaluationResult<? extends " + getExpressionType(children[i]) + "> result_" + i + " = " +
                           callExpression(children[i], "result_" + (i - 1) + ".position") + ";");
          writer.writeLine("if (!result_" + i + ".succeeded) { return EvaluationResult.failure(); }");
          writer.writeLine();
        }

        String arguments = "";
        for (int i = 0; i < children.length; i++) {
          if (children[i] instanceof NotExpression) {
            continue;
          }

          if (!"".equals(arguments)) {
            arguments += ", ";
          }
          arguments += "result_" + i + ".value";
        }

        writer.writeLine(interfaceType + " node = new " + classType + "(" + arguments + ");");
        writer.writeLine("return new EvaluationResult<" + interfaceType + ">(true, result_" + (children.length - 1) +
                         ".position, node);");
      }

      public void visit(DelimitedSequenceExpression sequenceExpression) {
        boolean rhs = isRHSOfRule(sequenceExpression);
        String thisType = getExpressionType(sequenceExpression);
        String elementType = getExpressionType(sequenceExpression.getElement());
        String delimiterType = getExpressionType(sequenceExpression.getDelimiter());

        writer.writeLine("ArrayList<" + elementType + "> elements = null;");
        writer.writeLine("ArrayList<" + delimiterType + " > delimiters = null;");

        writer.writeLine(
            "EvaluationResult<? extends " + elementType + "> result = " +
            callExpression(sequenceExpression.getElement(), "position") + ";");
        writer.writeLine("if (!result.succeeded) { return EvaluationResult.failure(); }");
        writer.writeLine("elements = addValue(elements, result.value);");
        writer.writeLineAndIndent("while (true) {");
        writer.writeLine("int currentPosition = result.position;");
        writer.writeLine();
        writer.writeLine("EvaluationResult<? extends " + delimiterType + "> delimiterResult = " +
                         callExpression(sequenceExpression.getDelimiter(), "currentPosition") + ";");
        writer.writeLineAndIndent("if (!delimiterResult.succeeded) {");

        if (rhs) {
          writer.writeLine(
              "return new EvaluationResult<" + thisType + ">(true, currentPosition, new " + classType +
              "(new ArrayDelimitedList<" +
              elementType + ", " + delimiterType + ">(trimList(elements), trimList(delimiters))));");
        } else {
          writer.writeLine(
              "return new EvaluationResult<" + thisType + ">(true, currentPosition, new ArrayDelimitedList<" +
              elementType + ", " + delimiterType + ">(trimList(elements), trimList(delimiters)));");
        }
        writer.dedentAndWriteLine("}");
        writer.writeLine();
        writer.writeLine(
            "result = " + callExpression(sequenceExpression.getElement(), "delimiterResult.position") + ";");
        writer.writeLineAndIndent("if (!result.succeeded) {");
        if (sequenceExpression.allowsTrailingDelimiter()) {
          // accept the last delimiter.
          writer.writeLine("delimiters = addValue(delimiters, delimiterResult.value)");
        }

        if (rhs) {
          writer.writeLine(
              "return new EvaluationResult<" + thisType + ">(true, currentPosition, new " + classType +
              "(new ArrayDelimitedList<" +
              elementType + ", " + delimiterType + ">(trimList(elements), trimList(delimiters))));");
        } else {
          writer.writeLine(
              "return new EvaluationResult<" + thisType + ">(true, currentPosition, new ArrayDelimitedList<" +
              elementType + ", " + delimiterType + ">(trimList(elements), trimList(delimiters)));");
        }

        writer.dedentAndWriteLine("}");
        writer.writeLine("elements = addValue(elements, result.value);");
        writer.dedentAndWriteLine("}");
      }

      public void visit(ChoiceExpression choiceExpression) {
        String thisType = getExpressionType(choiceExpression);
        writer.writeLine("EvaluationResult<? extends " + thisType + "> result;");

        Expression[] children = choiceExpression.getChildren();

        for (int i = 0; i < children.length - 1; i++) {
          writer.writeLine(
              "if ((result = " + callExpression(children[i], "position", false) + ").succeeded) { return result; }");
        }

        writer.writeLine("return " + callExpression(children[children.length - 1], "position", false) + ";");
      }

      public void visit(OptionalExpression optionalExpression) {
        String thisType = getExpressionType(optionalExpression);
        writer.writeLine("EvaluationResult<? extends " + thisType + "> result;");
        writer.writeLine("if ((result = " + callExpression(optionalExpression.getChild(), "position") +
                         ").succeeded) { return result; }");

        writer.writeLine("return new EvaluationResult<" + thisType + ">(true, position, null);");
        //writer.writeLine("return " + callExpression(empty(), "position") + ";");
      }

      public void visit(NotExpression notExpression) {
        String thisType = getExpressionType(notExpression);
        writer.writeLine("EvaluationResult<? extends " + thisType + "> result = " +
                         callExpression(notExpression.getChild(), "position") + ";");
        writer.writeLine("return new EvaluationResult<" + thisType + ">(!result.succeeded, position);");
      }

      public void visit(RepetitionExpression repetitionExpression) {
        boolean isRHS = isRHSOfRule(repetitionExpression);
        String thisType = getExpressionType(repetitionExpression);
        String childType = getExpressionType(repetitionExpression.getChild());

        writer.writeLine("int currentPosition = position;");
        writer.writeLine("ArrayList<" + childType + "> values = null;");

        writer.writeLineAndIndent("while (true) {");
        writer.writeLine(
            "EvaluationResult<? extends " + childType + "> result = " +
            callExpression(repetitionExpression.getChild(), "currentPosition") + ";");

        writer.writeLineAndIndent("if (result.succeeded) {");
        writer.writeLine("currentPosition = result.position;");
        writer.writeLine("values = addValue(values, result.value);");
        writer.dedentWriteLineAndIndent("} else {");
        if (isRHS) {
          writer.writeLine("return new EvaluationResult<" + thisType + ">(true, currentPosition, new " +
                           thisType.substring(1) + "(trimList(values)));");
        } else {
          writer.writeLine("return new EvaluationResult<" + thisType + ">(true, currentPosition, trimList(values));");
        }
        writer.dedentAndWriteLine("}");
        writer.dedentAndWriteLine("}");
      }

      public void visit(OneOrMoreExpression oneOrMoreExpression) {
        String thisType = getExpressionType(oneOrMoreExpression);
        String childType = getExpressionType(oneOrMoreExpression.getChild());

        writer.writeLine("ArrayList<" + childType + "> values = null;");
        writer.writeLine(
            "EvaluationResult<? extends " + childType + "> result = " +
            callExpression(oneOrMoreExpression.getChild(), "position") + ";");
        writer.writeLineAndIndent("if (!result.succeeded) {");
        writer.writeLine("return EvaluationResult.failure();");
        writer.dedentAndWriteLine("}");

        writer.writeLineAndIndent("while (true) {");
        writer.writeLine("int currentPosition = result.position;");
        writer.writeLine("values = addValue(values, result.value);");
        writer.writeLine("result = " + callExpression(oneOrMoreExpression.getChild(), "currentPosition") + ";");
        writer.writeLineAndIndent("if (!result.succeeded) {");
        writer.writeLine("return new EvaluationResult<" + thisType + ">(true, currentPosition, trimList(values));");
        writer.dedentAndWriteLine("}");
        writer.dedentAndWriteLine("}");
      }

      public void visit(TokenExpression tokenExpression) {
        String thisType = getExpressionType(tokenExpression);

        writer.writeLineAndIndent("if (position < tokens.size()) {");
        writer.writeLine("SourceToken token = tokens.get(position);");

        writer.writeLineAndIndent("if (" + getSimpleName(tokenExpression.getToken().getClass()) +
                                  ".instance.equals(token.getToken())) {");
        writer.writeLine("return new EvaluationResult<" + thisType + ">(true, position + 1, token);");
        writer.dedentAndWriteLine("}");
        writer.dedentAndWriteLine("}");

        writer.writeLine("return EvaluationResult.failure();");
      }

      public void visit(TypeExpression typeExpression) {
        String thisType = getExpressionType(typeExpression);

        writer.writeLineAndIndent("if (position < tokens.size()) {");
        writer.writeLine("SourceToken token = tokens.get(position);");

        writer.writeLineAndIndent("switch (token.getToken().getType()) {");
        for (Integer i : typeExpression.getTypes()) {
          writer.writeLine("case " + i + ":");
        }
        writer.indent();
        writer.writeLine("return new EvaluationResult<" + thisType + ">(true, position + 1, token);");
        writer.dedent();
        writer.dedentAndWriteLine("}");
        writer.dedentAndWriteLine("}");

        writer.writeLine("return EvaluationResult.failure();");
      }
    });

    writer.dedentAndWriteLine("}");
  }

  private boolean isRHSOfRule(Expression expression) {
    for (Rule rule : grammar.getRules()) {
      if (rule.getExpression() == expression) {
        return true;
      }
    }

    return false;
  }

  private String getExpressionType(Expression expr) {
    Rule r2 = null;
    for (Rule r : grammar.getRules()) {
      if (r.getExpression() == expr) {
        r2 = r;
        break;
      }
    }

    final Rule rule = r2;

    if (rule != null) {
      return "I" + rule.getVariable() + "Node";
    }

    return expr.accept(new DefaultExpressionVisitor<Object, String>() {
      public String visit(OptionalExpression expression) {
        return expression.getChild().accept(this);
      }

      public String visit(ChoiceExpression expression) {
        return "I" + rule.getVariable() + "Node";
      }

      public String visit(SequenceExpression expression) {
        return "I" + rule.getVariable() + "Node";
      }

      public String visit(DelimitedSequenceExpression sequenceExpression) {
        return "DelimitedList<" +
               sequenceExpression.getElement().accept(this) + ", " +
               sequenceExpression.getDelimiter().accept(this) + ">";
      }

      public String visit(VariableExpression expression) {
        return "I" + expression.getVariable() + "Node";
      }

      public String visit(RepetitionExpression expression) {
        return "List<" + expression.getChild().accept(this) + ">";
      }

      public String visit(OneOrMoreExpression expression) {
        return "List<" + expression.getChild().accept(this) + ">";
      }

      public String visit(TokenExpression expression) {
        return "SourceToken<" + getSimpleName(expression.getToken().getClass()) + ">";
      }

      public String visit(TypeExpression expression) {
        return "SourceToken<" + expression.getName() + ">";
      }

      public String visit(NotExpression expression) {
        return expression.getChild().accept(this);
      }

      public String visit(FunctionExpression<Object> objectFunctionExpression) {
        return "Object";
      }
    });
  }

  private void createExpressionNames(final String variable, Expression expr) {
    expr.accept(new RecursionExpressionVisitor() {
      public void visit(TerminalExpression expression) {
        super.visit(expression);
        getExpressionId(variable, expression);
      }

      public void visit(VariableExpression expression) {}

      public void visit(EmptyExpression expression) {}

      public void visit(FunctionExpression expression) { }

      public void visit(SequenceExpression expression) {
        super.visit(expression);
        getExpressionId(variable, expression);
      }

      public void visit(DelimitedSequenceExpression expression) {
        super.visit(expression);
        getExpressionId(variable, expression);
      }

      public void visit(ChoiceExpression expression) {
        super.visit(expression);
        getExpressionId(variable, expression);
      }

      public void visit(OptionalExpression expression) {
        super.visit(expression);
        getExpressionId(variable, expression);
      }

      public void visit(NotExpression expression) {
        super.visit(expression);
        getExpressionId(variable, expression);
      }

      public void visit(RepetitionExpression expression) {
        super.visit(expression);
        getExpressionId(variable, expression);
      }

      public void visit(OneOrMoreExpression expression) {
        super.visit(expression);
        getExpressionId(variable, expression);
      }

      public void visit(TokenExpression expression) {
        super.visit(expression);
        expressionNamesMap.put(expression, getSimpleName(expression.getToken().getClass()));
      }

      public void visit(TypeExpression expression) {
        super.visit(expression);
        expressionNamesMap.put(expression, expression.getName());
      }
    });
  }

  private String getExpressionId(String variable, Expression expression) {
    String id = expressionNamesMap.get(expression);

    if (id == null) {
      String prefix = variable + "Expression_";
      int index = 0;

      do {
        id = prefix + index++;
      } while (expressionNamesMap.containsValue(id));

      expressionNamesMap.put(expression, id);
    }

    return id;
  }

  private Map<Expression, String> expressionNamesMap = new LinkedHashMap<Expression, String>();

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
