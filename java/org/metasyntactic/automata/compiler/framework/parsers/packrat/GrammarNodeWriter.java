// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package org.metasyntactic.automata.compiler.framework.parsers.packrat;

import org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions.*;
import org.metasyntactic.automata.compiler.java.parser.JavaGrammar;
import org.metasyntactic.automata.compiler.java.scanner.JavaToken;
import org.metasyntactic.collections.HashMultiMap;
import org.metasyntactic.collections.MultiMap;

import java.io.IOException;
import java.io.LineNumberReader;
import java.io.PrintWriter;
import java.io.StringReader;
import java.util.*;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class GrammarNodeWriter<TTokenType> {
  private final PackratGrammar<TTokenType> grammar;
  private final PrintWriter writer;
  private int indentLevel;

  private final MultiMap<String, String> implementsMap = new HashMultiMap<String, String>();
  private final MultiMap<String, String> promotedTokens = new HashMultiMap<String, String>();

  public GrammarNodeWriter(PackratGrammar<TTokenType> grammar, PrintWriter writer) {
    this.grammar = grammar;
    this.writer = writer;

    processGrammar();

    System.out.println(implementsMap);
  }

  private void processGrammar() {
    boolean changed;
    do {
      changed = false;
      for (Rule rule : grammar.getRules()) {
        changed |= processRule(rule);
      }
    } while (changed);
  }

  private boolean processRule(Rule rule) {
    boolean changed = determineImplementsRelation(rule);
    changed |= determinePromotedTokens(rule);

    return changed;
  }

  private boolean determinePromotedTokens(Rule rule) {
    Expression expression = rule.getExpression();

    boolean changed = false;
    if (expression instanceof ChoiceExpression) {
      ChoiceExpression ce = (ChoiceExpression) expression;

      for (Expression child : ce.getChildren()) {
        if (child instanceof TokenExpression) {
          TokenExpression te = (TokenExpression) child;
          changed |= promotedTokens.put(te.getToken().getClass().getSimpleName(), rule.getVariable());
        } else if (child instanceof TypeExpression) {
          TypeExpression te = (TypeExpression) child;
          changed |= promotedTokens.put(te.getType().getSimpleName(), rule.getVariable());
        } else if (child instanceof VariableExpression) {
        } else {
          throw new RuntimeException();
        }
      }
    } else if (expression instanceof TokenExpression) {
      TokenExpression te = (TokenExpression) expression;
      changed |= promotedTokens.put(te.getToken().getClass().getSimpleName(), null);
    } else if (expression instanceof TypeExpression) {
      TypeExpression te = (TypeExpression) expression;
      changed |= promotedTokens.put(te.getType().getSimpleName(), null);
    }

    return changed;
  }

  private boolean determineImplementsRelation(Rule rule) {
    Expression expression = rule.getExpression();

    if (expression instanceof VariableExpression) {
      VariableExpression ve = (VariableExpression) expression;
      return implementsMap.put(ve.getVariable(), rule.getVariable());
    } else if (expression instanceof ChoiceExpression) {

      boolean changed = false;
      for (Expression childExpression : ((ChoiceExpression) expression).getChildren()) {
        if (childExpression instanceof VariableExpression) {
          VariableExpression ve = (VariableExpression) childExpression;
          changed |= implementsMap.put(ve.getVariable(), rule.getVariable());
        }
      }
      return changed;
    }

    return false;
  }

  public void write(String s) {
    LineNumberReader reader = new LineNumberReader(new StringReader(s));
    String line;

    try {
      while ((line = reader.readLine()) != null) {
        writeIndent();
        writer.println(line);
      }
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }

  private void writeIndent() {
    for (int i = 0; i < indentLevel; i++) {
      writer.print("  ");
    }
  }

  private void writeAndIndent(String s) {
    write(s);
    indent();
  }

  private void indent() {indentLevel++;}

  private void dedentAndWrite(String s) {
    dedent();
    write(s);
  }

  private void dedent() {indentLevel--;}

  public void write() {
    writeINode();
    writeVisitor();
    writeNode();

    writePromotedTokenNodes();

    for (Rule rule : grammar.getRules()) {
      writeInterface(rule);
    }

    for (Rule rule : grammar.getRules()) {
      writeClass(rule);
    }
  }

  private void writePromotedTokenNodes() {
    for (String tokenName : promotedTokens.keySet()) {
      writePromotedTokenNodes(tokenName);
    }
  }

  private void writePromotedTokenNodes(String tokenName) {
    writePromotedTokenNodeInterface(tokenName);
    writePromotedTokenNodeClass(tokenName);
  }

  private void writePromotedTokenNodeClass(String tokenName) {
    writeAndIndent(
        "public static class " + tokenName + "Node extends AbstractNode implements I" + tokenName + "Node {");
    write("private final SourceToken<" + tokenName + "> token;");

    writeAndIndent("public " + tokenName + "Node(SourceToken<" + tokenName + "> token) {");
    write("this.token = token;");
    dedentAndWrite("}");

    writeAndIndent("public SourceToken<" + tokenName + "> getToken() {");
    write("return token;");
    dedentAndWrite("}");

    writeAndIndent("public boolean equals(Object __other) {");
    write("if (this == __other) { return true; }");
    write("if (__other == null) { return false; }");
    write("if (!(__other instanceof I" + tokenName + "Node)) { return false; }");
    write("I" + tokenName + "Node __node = (I" + tokenName + "Node)__other;");
    write("return equals(token, __node.getToken());");
    dedentAndWrite("}");

    writeAndIndent("protected int hashCodeWorker() {");
    write("return token.hashCode();");
    dedentAndWrite("}");

    writeAndIndent("public void accept(INodeVisitor visitor) {");
    write("visitor.visit(this);");
    dedentAndWrite("}");

    dedentAndWrite("}");
  }

  private void writePromotedTokenNodeInterface(String tokenName) {
    String interfaces = "INode";
    for (String iface : promotedTokens.get(tokenName)) {
      if (iface != null) {
        interfaces += ", I" + iface + "Node";
      }
    }
    writeAndIndent("public static interface I" + tokenName + "Node extends " + interfaces + " {");
    write("SourceToken<" + tokenName + "> getToken();");
    dedentAndWrite("}");
  }

  class TypeAndName {
    String type;
    String name;

    TypeAndName(String type, String name) {
      this.type = type;
      this.name = name;
    }
  }

  List<TypeAndName> getMembers(Rule rule) {
    List<TypeAndName> result = new ArrayList<TypeAndName>();

    Expression expression = rule.getExpression();
    if (expression instanceof SequenceExpression) {
      SequenceExpression se = (SequenceExpression) expression;
      Set<String> usedNames = new LinkedHashSet<String>();

      for (int i = 0; i < se.getChildren().length; i++) {
        Expression childExpression = se.getChildren()[i];
        if ((childExpression instanceof NotExpression)) {
          continue;
        }

        String name = getExpressionName(childExpression, usedNames);
        usedNames.add(name);

        result.add(new TypeAndName(getExpressionType(childExpression), name));
      }
    } else if (expression instanceof ChoiceExpression) {
    } else if (expression instanceof DelimitedSequenceExpression) {
      DelimitedSequenceExpression dse = (DelimitedSequenceExpression) expression;
      result.add(new TypeAndName(
          "DelimitedList<" +
          getExpressionType(dse.getElement()) + ", " +
          getExpressionType(dse.getDelimiter()) + ">",
          getExpressionName(dse.getElement()) + "List"));
    } else if (expression instanceof RepetitionExpression) {
      RepetitionExpression re = (RepetitionExpression) expression;

      result.add(new TypeAndName("List<" + getExpressionType(re.getChild()) + ">", getExpressionName(re.getChild()) +
                                                                                   "List"));
    } else if (expression instanceof TokenExpression) {
      TokenExpression te = (TokenExpression) expression;
      result.add(
          new TypeAndName("SourceToken<" + te.getToken().getClass().getSimpleName() + ">", getExpressionName(te)));
    } else {
      throw new RuntimeException();
    }

    return result;
  }

  private void writeINode() {
    writeAndIndent("public static interface INode {");
    write("void accept(INodeVisitor visitor);");
    dedentAndWrite("}");
  }

  private void writeNode() {
    writeAndIndent("public static abstract class AbstractNode implements INode {");
    write("private int hashCode = -1;");
    writeAndIndent("public int hashCode() {");
    writeAndIndent("if (hashCode == -1) {");
    write("hashCode = hashCodeWorker();");
    dedentAndWrite("}");
    write("return hashCode;");
    dedentAndWrite("}");
    write("protected abstract int hashCodeWorker();");
    writeAndIndent("protected boolean equals(Object o1, Object o2) {");
    write("return o1 == null ? o2 == null : o1.equals(o2);");
    dedentAndWrite("}");
    dedentAndWrite("}");
  }

  private void writeVisitor() {
    writeAndIndent("public static interface INodeVisitor {");
    for (Rule rule : grammar.getRules()) {
      write("void visit(I" + rule.getVariable() + "Node node);");
    }
    for (String tokenName : promotedTokens.keySet()) {
      write("void visit(I" + tokenName + "Node node);");
    }
    dedentAndWrite("}");
  }

  private void writeClass(Rule rule) {
    writeAndIndent(
        "public static class " + rule.getVariable() + "Node extends AbstractNode implements I" + rule.getVariable() +
        "Node {");
    writeClassFields(rule);
    writeClassConstructor(rule);
    writeGetters(rule);
    writeAccept(rule);
    writeEquals(rule);
    writeHashCode(rule);

    dedentAndWrite("}");
  }

  private void writeHashCode(Rule rule) {
    writeAndIndent("protected int hashCodeWorker() {");
    write("int hash = 0;");
    for (TypeAndName tan : getMembers(rule)) {
      write("hash = 31*hash + (" + camelCase(tan.name) + " == null ? 0 : " + camelCase(tan.name) + ".hashCode());");
    }
    write("return hash;");
    dedentAndWrite("}");
  }

  private void writeEquals(Rule rule) {
    writeAndIndent("public boolean equals(Object __other) {");
    write("if (this == __other) { return true; }");
    write("if (__other == null) { return false; }");
    write("if (!(__other instanceof I" + rule.getVariable() + "Node)) { return false; }");
    write("I" + rule.getVariable() + "Node __node = (I" + rule.getVariable() + "Node)__other;");

    for (TypeAndName tan : getMembers(rule)) {
      write("if (!equals(" + camelCase(tan.name) + ", __node.get" + tan.name + "())) { return false; }");
    }

    write("return true;");
    dedentAndWrite("}");
  }

  private void writeAccept(Rule rule) {
    writeAndIndent("public void accept(INodeVisitor visitor) {");
    write("visitor.visit(this);");
    dedentAndWrite("}");
  }

  private void writeGetters(Rule rule) {
    for (TypeAndName tan : getMembers(rule)) {
      writeAndIndent("public " + tan.type + " get" + tan.name + "() {");
      write("return " + camelCase(tan.name) + ";");
      dedentAndWrite("}");
    }
  }

  private void writeClassConstructor(Rule rule) {
    List<TypeAndName> members = getMembers(rule);

    if (members.isEmpty()) {
      writeAndIndent("public " + rule.getVariable() + "Node() {");
    } else {
      writeAndIndent("public " + rule.getVariable() + "Node(");
    }

    for (int i = 0; i < members.size(); i++) {
      TypeAndName tan = members.get(i);
      boolean last = i == members.size() - 1;

      write(tan.type + " " + camelCase(tan.name) + (last ? ") {" : ","));
    }

    indent();

    for (TypeAndName tan : members) {
      write("this." + camelCase(tan.name) + " = " + camelCase(tan.name) + ";");
    }

    dedent();
    dedentAndWrite("}");
  }

  private void writeClassFields(Rule rule) {
    for (TypeAndName tan : getMembers(rule)) {
      write("private final " + tan.type + " " + camelCase(tan.name) + ";");
    }
  }

  private String camelCase(String name) {
    return name.substring(0, 1).toLowerCase() + name.substring(1);
  }

  private void writeInterface(Rule rule) {
    Collection<String> imp = implementsMap.get(rule.getVariable());

    String interfaces = "INode";
    for (String i : imp) {
      interfaces += ", ";
      interfaces += "I" + i + "Node";
    }
    writeAndIndent("public static interface I" + rule.getVariable() + "Node extends " + interfaces + " {");

    for (TypeAndName tan : getMembers(rule)) {
      write(tan.type + " get" + tan.name + "();");
    }

    dedentAndWrite("}");
  }

  private class DetermineTypeVisitor extends DefaultExpressionVisitor<Object, String> {
    protected String defaultCase(Expression expression) {
      throw new RuntimeException();
    }

    public String visit(VariableExpression variableExpression) {
      return "I" + variableExpression.getVariable() + "Node";
    }

    public String visit(DelimitedSequenceExpression sequenceExpression) {
      return "DelimitedList<" +
             getExpressionType(sequenceExpression.getElement()) + ", " +
             getExpressionType(sequenceExpression.getDelimiter()) + ">";
    }

    public String visit(RepetitionExpression repetitionExpression) {
      return "List<" + getExpressionType(repetitionExpression.getChild()) + ">";
    }

    public String visit(OneOrMoreExpression oneOrMoreExpression) {
      return "List<" + getExpressionType(oneOrMoreExpression.getChild()) + ">";
    }

    public String visit(OptionalExpression optionalExpression) {
      return getExpressionType(optionalExpression.getChild());
    }

    public String visit(TokenExpression tokenExpression) {
      return "SourceToken<" + tokenExpression.getToken().getClass().getSimpleName() + ">";
    }

    public String visit(TypeExpression typeExpression) {
      return "SourceToken<" + typeExpression.getType().getSimpleName() + ">";
    }
  }

  private String getExpressionType(Expression expression) {
    return expression.accept(new DetermineTypeVisitor());
  }

  private String getExpressionName(Expression expression) {
    return getExpressionName(expression, new LinkedHashSet<String>());
  }

  private String getExpressionName(Expression expression, Set<String> usedNames) {
    String result = expression.accept(new DetermineNameVisitor());
    String temp = result;
    int i = 2;
    while (usedNames.contains(temp)) {
      temp = result + i++;
    }

    return temp;
  }

  private static String makeName(String s) {
    return s;
  }

  private class DetermineNameVisitor extends DefaultExpressionVisitor<Object, String> {
    protected String defaultCase(Expression expression) {
      throw new RuntimeException("Bad grammar!");
    }

    public String visit(VariableExpression variableExpression) {
      return makeName(variableExpression.getVariable());
    }

    public String visit(DelimitedSequenceExpression sequenceExpression) {
      return sequenceExpression.getElement().accept(this) + "List";
    }

    public String visit(NotExpression notExpression) {
      return "";
    }

    public String visit(RepetitionExpression repetitionExpression) {
      return repetitionExpression.getChild().accept(this) + "List";
    }

    public String visit(OneOrMoreExpression oneOrMoreExpression) {
      return oneOrMoreExpression.getChild().accept(this) + "List";
    }

    public String visit(OptionalExpression optionalExpression) {
      return "Optional" + optionalExpression.getChild().accept(this);
    }

    public String visit(TokenExpression tokenExpression) {
      String s = tokenExpression.getToken().getClass().getSimpleName();
      if (s.endsWith("Token")) {
        s = s.substring(0, s.length() - "Token".length());
      }
      return makeName(s);
    }

    public String visit(TypeExpression typeExpression) {
      String s = typeExpression.getType().getSimpleName();
      if (s.endsWith("Token")) {
        s = s.substring(0, s.length() - "Token".length());
      }
      return makeName(s);
    }
  }

  public static void main(String... args) {
    GrammarNodeWriter<JavaToken.Type> writer = new GrammarNodeWriter<JavaToken.Type>(JavaGrammar.instance,
                                                                                     new PrintWriter(System.out, true));
    writer.write();
  }
}
