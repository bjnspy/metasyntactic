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
import java.util.Collection;
import java.util.Set;
import java.util.LinkedHashSet;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class GrammarNodeWriter<TTokenType> {
  private final PackratGrammar<TTokenType> grammar;
  private final PrintWriter writer;
  private int indentLevel;

  private final MultiMap<String, String> implementsMap = new HashMultiMap<String, String>();

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
    boolean changed = false;
    changed |= determineImplementsRelation(rule);

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
      writer.print(' ');
    }
  }

  private void writeAndIndent(String s) {
    write(s);
    indentLevel++;
  }

  private void dedentAndWrite(String s) {
    indentLevel--;
    write(s);
  }

  public void write() {
    for (Rule rule : grammar.getRules()) {
      write(rule);
    }
  }

  private void write(Rule rule) {
    Collection<String> imp = implementsMap.get(rule.getVariable());

    if (imp.isEmpty()) {
      writeAndIndent("public interface I" + rule.getVariable() + "Node {");
    } else {
      String interfaces = "";
      for (String i : imp) {
        if (!interfaces.equals("")) {
          interfaces += ", ";
        }

        interfaces += "I" + i + "Node";
      }
      writeAndIndent("public interface I" + rule.getVariable() + "Node extends " + interfaces + " {");
    }

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
        write(getExpressionType(childExpression) + " get" + name + "();");
      }
    } else if (expression instanceof ChoiceExpression) {
    } else if (expression instanceof DelimitedSequenceExpression) {
      DelimitedSequenceExpression dse = (DelimitedSequenceExpression) expression;

      write("List<" + getExpressionType(dse.getElement()) + "> get" +
            dse.getElement().accept(new DetermineNameVisitor()) + "List();");
    } else if (expression instanceof RepetitionExpression) {
      RepetitionExpression re = (RepetitionExpression) expression;

      write("List<" + getExpressionType(re.getChild()) + "> get" + getExpressionName(re.getChild()) +
            "List();");
    } else if (expression instanceof TokenExpression) {
      TokenExpression te = (TokenExpression) expression;
      write(te.getToken().getClass().getSimpleName() + " get" + getExpressionName(te) + "();");
    } else {
      throw new RuntimeException();
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
      return "List<" + getExpressionType(sequenceExpression.getElement()) + ">";
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
      return tokenExpression.getToken().getClass().getSimpleName();
    }

    public String visit(TypeExpression typeExpression) {
      return typeExpression.getType().getSimpleName();
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
    //return s.substring(0, 1).toLowerCase() + s.substring(1);
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
