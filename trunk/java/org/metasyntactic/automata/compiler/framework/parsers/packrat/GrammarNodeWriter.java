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

import org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions.Expression;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions.VariableExpression;
import org.metasyntactic.collections.MultiMap;
import org.metasyntactic.collections.HashMultiMap;

import java.io.IOException;
import java.io.LineNumberReader;
import java.io.PrintWriter;
import java.io.StringReader;
import java.util.LinkedHashSet;
import java.util.Set;

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
    Expression expression = rule.getExpression();

    if (expression instanceof VariableExpression) {
      VariableExpression ve = (VariableExpression)expression;
      return implementsMap.put(ve.getVariable(), rule.getVariable());
    }

    return false;
  }

  public void write() {
    Set<Rule> alreadySeen = new LinkedHashSet<Rule>();
    write(grammar.getStartRule(), alreadySeen);
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

  private void write(Rule rule, Set<Rule> alreadySeen) {
    if (alreadySeen.contains(rule)) {
      return;
    }

    alreadySeen.add(rule);

    Set<Rule> rulesToProcess = new LinkedHashSet<Rule>();

    writeAndIndent("public interface I" + rule.getVariable() + "Node extends INode {");

    dedentAndWrite("}");

    for (Rule subRule : rulesToProcess) {
      write(subRule, alreadySeen);
    }
  }
}
