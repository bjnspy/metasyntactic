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

import org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions.ChoiceExpression;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions.Expression;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions.SequenceExpression;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions.VariableExpression;
import org.metasyntactic.automata.compiler.java.parser.JavaGrammar;
import org.metasyntactic.automata.compiler.java.scanner.JavaToken;
import org.metasyntactic.collections.HashMultiMap;
import org.metasyntactic.collections.MultiMap;

import java.io.IOException;
import java.io.LineNumberReader;
import java.io.PrintWriter;
import java.io.StringReader;
import java.util.Collection;

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

        interfaces += "I"+ i + "Node";
      }
      writeAndIndent("public interface I" + rule.getVariable() + "Node extends " + interfaces + " {");
    }


    Expression expression = rule.getExpression();
    if (expression instanceof SequenceExpression) {
      SequenceExpression se = (SequenceExpression)expression;
      for (int i = 0; i < se.getChildNames().length; i++) {
        write("Object get" + se.getChildNames()[i] + "();");
      }
    }


    dedentAndWrite("}");
  }

  public static void main(String... args) {
    GrammarNodeWriter<JavaToken.Type> writer = new GrammarNodeWriter<JavaToken.Type>(JavaGrammar.instance, new PrintWriter(System.out, true));
    writer.write();
  }
}
