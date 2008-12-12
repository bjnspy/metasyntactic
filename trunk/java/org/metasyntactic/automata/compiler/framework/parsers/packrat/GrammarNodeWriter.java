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
import org.metasyntactic.collections.HashMultiMap;
import org.metasyntactic.collections.MultiMap;
import static org.metasyntactic.utilities.ReflectionUtilities.getSimpleName;

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
          changed |= promotedTokens.put(getSimpleName(te.getToken().getClass()), rule.getVariable());
        } else if (child instanceof TypeExpression) {
          TypeExpression te = (TypeExpression) child;
          changed |= promotedTokens.put(te.getName(), rule.getVariable());
        } else if (child instanceof VariableExpression) {
        } else {
          throw new RuntimeException();
        }
      }
    } else if (expression instanceof TokenExpression) {
      TokenExpression te = (TokenExpression) expression;
      changed |= promotedTokens.put(getSimpleName(te.getToken().getClass()), null);
    } else if (expression instanceof TypeExpression) {
      TypeExpression te = (TypeExpression) expression;
      changed |= promotedTokens.put(te.getName(), null);
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

  private void indent() {
    indentLevel++;
  }

  private void dedentAndWrite(String s) {
    dedent();
    write(s);
  }

  private void dedent() {indentLevel--;}

  public void write() {
    writeFunctions();
    writeINode();
    writeVisitor();
    //writeTransformer();
    writeNode();

    writePromotedTokenNodes();

    for (Rule rule : grammar.getRules()) {
      writeInterface(rule);
    }

    for (Rule rule : grammar.getRules()) {
      writeClass(rule);
    }
  }

  private void writeFunctions() {
    writeAndIndent("private static List<Object> trimList(List<Object> list) {");

    writeAndIndent("if (list.isEmpty()) {");
    write("return Collections.emptyList();");
    dedentAndWrite("}");

    writeAndIndent("if (list.size() == 1) {");
    write("return Collections.singletonList(list.get(0));");
    dedentAndWrite("}");

    write("return Collections.unmodifiableList(list);");

    dedentAndWrite("}");
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

    writeAndIndent("protected List<Object> getChildrenWorker() {");
    write("return Collections.<Object>singletonList(token);");
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

    writeAndIndent("public String getName() {");
    write("return token.toString();");
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

  class Member {
    String type;
    String name;
    boolean isToken;
    boolean isList;
    boolean isDelimitedList;

    Member(String type, String name, boolean isToken, boolean isList, boolean isDelimitedList) {
      this.type = type;
      this.name = name;
      this.isToken = isToken;
      this.isList = isList;
      this.isDelimitedList = isDelimitedList;
    }
  }

  private List<Member> getNodeMembers(Rule rule) {
    List<Member> members = getMembers(rule);
    List<Member> result = new ArrayList<Member>();

    for (Member member : members) {
      if (!member.isToken) {
        result.add(member);
      }
    }
    return result;
  }

  List<Member> getMembers(Rule rule) {
    List<Member> result = new ArrayList<Member>();

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

        result.add(new Member(getExpressionType(childExpression), name, isTokenType(childExpression),
                              isListType(childExpression), isDelimitedListType(childExpression)));
      }
    } else if (expression instanceof ChoiceExpression) {
    } else if (expression instanceof DelimitedSequenceExpression) {
      DelimitedSequenceExpression dse = (DelimitedSequenceExpression) expression;
      result.add(new Member(
          "DelimitedList<" +
          getExpressionType(dse.getElement()) + ", " +
          getExpressionType(dse.getDelimiter()) + ">",
          getExpressionName(dse.getElement()) + "List", isTokenType(dse.getElement()), false, true));
    } else if (expression instanceof RepetitionExpression) {
      RepetitionExpression re = (RepetitionExpression) expression;

      result.add(new Member("List<" + getExpressionType(re.getChild()) + ">", getExpressionName(re.getChild()) +
                                                                              "List", isTokenType(re.getChild()), true,
                                                                                      false));
    } else if (expression instanceof TokenExpression) {
      TokenExpression te = (TokenExpression) expression;
      result.add(
          new Member("SourceToken<" + getSimpleName(te.getToken().getClass()) + ">", getExpressionName(te), true, false,
                     false));
    } else {
      throw new RuntimeException();
    }

    return result;
  }

  private boolean isDelimitedListType(Expression expression) {
    return expression.accept(new DefaultExpressionVisitor<Object, Boolean>() {
      protected Boolean defaultCase(Expression expression) {
        return false;
      }

      public Boolean visit(OptionalExpression expression) {
        return expression.getChild().accept(this);
      }

      public Boolean visit(DelimitedSequenceExpression expression) {
        return true;
      }
    });
  }

  private boolean isListType(Expression expression) {
    return expression.accept(new DefaultExpressionVisitor<Object, Boolean>() {
      protected Boolean defaultCase(Expression expression) {
        return false;
      }

      public Boolean visit(OneOrMoreExpression expression) {
        return true;
      }

      public Boolean visit(OptionalExpression expression) {
        return expression.getChild().accept(this);
      }

      public Boolean visit(RepetitionExpression expression) {
        return true;
      }
    });
  }

  private boolean isTokenType(Expression expression) {
    return expression.accept(new DefaultExpressionVisitor<Object, Boolean>() {
      protected Boolean defaultCase(Expression expression) {
        return false;
      }

      public Boolean visit(OptionalExpression expression) {
        return expression.getChild().accept(this);
      }

      public Boolean visit(TypeExpression expression) {
        return true;
      }

      public Boolean visit(TokenExpression expression) {
        return true;
      }

      public Boolean visit(RepetitionExpression expression) {
        return expression.getChild().accept(this);
      }

      public Boolean visit(OneOrMoreExpression expression) {
        return expression.getChild().accept(this);
      }
    });
  }

  private void writeINode() {
    writeAndIndent("public static interface INode {");
    write("String getName();");
    write("void accept(INodeVisitor visitor);");
    write("List<Object> getChildren();");
    dedentAndWrite("}");
  }

  private void writeNode() {
    writeAndIndent("public static abstract class AbstractNode implements INode {");

    write("private List<Object> children;");
    writeAndIndent("public List<Object> getChildren() {");
    writeAndIndent("if (children == null) {");
    write("children = getChildrenWorker();");
    dedentAndWrite("}");
    write("return children;");
    dedentAndWrite("}");
    write("protected abstract List<Object> getChildrenWorker();");

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

    writeAndIndent("public String toString() {");
    write("return getName();");
    dedentAndWrite("}");

    dedentAndWrite("}");
  }

  private void writeTransformer() {
    writeAndIndent("public static interface INodeTransformer {");
    for (Rule rule : grammar.getRules()) {
      write("I" + rule.getVariable() + "Node transform(I" + rule.getVariable() + "Node node);");
    }
    dedentAndWrite("}");

    writeAndIndent("public static class NodeTransformer implements INodeTransformer {");
    for (Rule rule : grammar.getRules()) {
      List<Member> members = getMembers(rule);

      writeAndIndent("public I" + rule.getVariable() + "Node transform(I" + rule.getVariable() + "Node node) {");
      for (Member member : members) {
        if (!member.isToken) {
          write(member.type + " " + camelCase(member.name) + " = node.get" + member.name + "().accept(this);");
        }
      }

      String check = "";
      for (Member member : members) {
        if (!member.isToken) {
          if (!check.equals("")) {
            check += " && \n    ";
          }

          check += camelCase(member.name) + " == node.get" + member.name + "()";
        }
      }

      writeAndIndent("if (" + check + ") {");
      write("return node;");
      dedentAndWrite("}");

      String arguments = "";
      for (Member member : members) {
        if (!arguments.equals("")) {
          arguments += ", ";
        }

        if (member.isToken) {
          arguments += "node.get" + member.name + "()";
        } else {
          arguments += camelCase(member.name);
        }
      }

      write("return new " + rule.getVariable() + "Node(" + arguments + ");");
      dedentAndWrite("}");
    }
    dedentAndWrite("}");
  }

  private void writeVisitor() {
    writeAndIndent("public static interface INodeVisitor {");
    for (Rule rule : grammar.getRules()) {
      if (getMembers(rule).size() > 0) {
        write("void visit(I" + rule.getVariable() + "Node node);");
      }
    }
    for (String tokenName : promotedTokens.keySet()) {
      write("void visit(I" + tokenName + "Node node);");
    }
    dedentAndWrite("}");
  }

  private void writeClass(Rule rule) {
    if (getMembers(rule).size() > 0) {
      writeAndIndent(
          "public static class " + rule.getVariable() + "Node extends AbstractNode implements I" + rule.getVariable() +
          "Node {");
      writeClassFields(rule);
      writeClassConstructor(rule);
      writeGetters(rule);
      writeGetChildren(rule);
      writeAccept(rule);
      writeEquals(rule);
      writeHashCode(rule);
      writeToString(rule);

      dedentAndWrite("}");
    }
  }

  private void writeToString(Rule rule) {
    writeAndIndent("public String getName() {");
    write("return \"I" + rule.getVariable() + "Node\";");
    dedentAndWrite("}");
  }

  private void writeGetChildren(Rule rule) {
    writeAndIndent("protected List<Object> getChildrenWorker() {");
    List<Member> members = getMembers(rule);
    if (members.isEmpty()) {
      write("return Collections.emptyList();");
    } else if (members.size() == 1 && !members.get(0).isList && !members.get(0).isDelimitedList) {
      writeAndIndent("if (" + camelCase(members.get(0).name) + " != null) {");
      write("return Collections.<Object>singletonList(" + camelCase(members.get(0).name) + ");");
      dedentAndWrite("}");
      write("return Collections.emptyList();");
    } else {
      write("List<Object> list = new ArrayList<Object>();");

      for (Member member : members) {
          writeAndIndent("if (" + camelCase(member.name) + " != null) {");
        if (member.isList) {
          write("list.addAll(" + camelCase(member.name) + ");");
        } else if (member.isDelimitedList) {
          write(camelCase(member.name) + ".addTo(list);");
        } else {
          write("list.add(" + camelCase(member.name) + ");");
        }
        dedentAndWrite("}");
      }

      write("return trimList(list);");
    }
    dedentAndWrite("}");
  }

  private void writeHashCode(Rule rule) {
    writeAndIndent("protected int hashCodeWorker() {");
    write("int hash = 0;");
    for (Member tan : getMembers(rule)) {
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

    for (Member tan : getMembers(rule)) {
      write("if (!equals(" + camelCase(tan.name) + ", __node.get" + tan.name + "())) { return false; }");
    }

    write("return true;");
    dedentAndWrite("}");
  }

  private void writeAccept(Rule rule) {
    writeAndIndent("public void accept(INodeVisitor visitor) {");
    write("visitor.visit(this);");
    dedentAndWrite("}");
    //writeAndIndent("public I" + rule.getVariable() + "Node accept(INodeTransformer transformer) {");
    //write("return transformer.transform(this);");
    //dedentAndWrite("}");
  }

  private void writeGetters(Rule rule) {
    for (Member tan : getMembers(rule)) {
      writeAndIndent("public " + tan.type + " get" + tan.name + "() {");
      write("return " + camelCase(tan.name) + ";");
      dedentAndWrite("}");
    }
  }

  private void writeClassConstructor(Rule rule) {
    List<Member> members = getMembers(rule);

    if (members.isEmpty()) {
      writeAndIndent("public " + rule.getVariable() + "Node() {");
    } else {
      writeAndIndent("public " + rule.getVariable() + "Node(");
    }

    for (int i = 0; i < members.size(); i++) {
      Member tan = members.get(i);
      boolean last = i == members.size() - 1;

      write(tan.type + " " + camelCase(tan.name) + (last ? ") {" : ","));
    }

    indent();

    for (Member tan : members) {
      write("this." + camelCase(tan.name) + " = " + camelCase(tan.name) + ";");
    }

    dedent();
    dedentAndWrite("}");
  }

  private void writeClassFields(Rule rule) {
    for (Member tan : getMembers(rule)) {
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

    for (Member tan : getMembers(rule)) {
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
      return "SourceToken<" + getSimpleName(tokenExpression.getToken().getClass()) + ">";
    }

    public String visit(TypeExpression typeExpression) {
      return "SourceToken<" + typeExpression.getName() + ">";
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
      String s = getSimpleName(tokenExpression.getToken().getClass());
      if (s.endsWith("Token")) {
        s = s.substring(0, s.length() - "Token".length());
      }
      return makeName(s);
    }

    public String visit(TypeExpression typeExpression) {
      String s = typeExpression.getName();
      if (s.endsWith("Token")) {
        s = s.substring(0, s.length() - "Token".length());
      }
      return makeName(s);
    }
  }
}
