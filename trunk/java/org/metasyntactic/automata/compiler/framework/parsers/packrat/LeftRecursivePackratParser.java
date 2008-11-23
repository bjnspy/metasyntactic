// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.framework.parsers.packrat;

import org.metasyntactic.automata.compiler.framework.parsers.*;
import org.metasyntactic.automata.compiler.framework.parsers.Grammar;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions.Expression;
import static org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions.Expression.*;
import org.metasyntactic.automata.compiler.java.parser.JavaGrammar;
import org.metasyntactic.automata.compiler.java.scanner.IdentifierToken;
import org.metasyntactic.automata.compiler.java.scanner.JavaToken;
import org.metasyntactic.automata.compiler.java.scanner.operators.MinusOperatorToken;

import java.util.*;

/**
 * TODO(cyrusn): javadoc
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class LeftRecursivePackratParser<T extends Token> extends AbstractPackratParser<T> {
  private LeftRecursionChain leftRecursionStack;
  private Map<Integer, Head> headsMap = new LinkedHashMap<Integer, Head>();

  public LeftRecursivePackratParser(PackratGrammar grammar, List<SourceToken<T>> tokens) {
    this(grammar, tokens, ActionMap.EMPTY_MAP);
  }

  public LeftRecursivePackratParser(PackratGrammar grammar, List<SourceToken<T>> tokens, ActionMap<T> actions) {
    super(grammar, tokens, actions);
  }

  @Override protected EvaluationResult evaluateExpression(int position, Expression expression) {
    furtherstPosition = Math.max(position, furtherstPosition);
    return expression.accept(new EvaluationExpressionVisitor(position));
  }

  @Override protected EvaluationResult evaluateRule(int position, Rule rule) {
    EvaluationResult memoEntry = recall(position, rule);

    if (memoEntry == null) {
      LeftRecursionChain lr = new LeftRecursionChain(null, rule.getVariable(), null, leftRecursionStack);
      leftRecursionStack = lr;

      memoEntry = new EvaluationResult(position, leftRecursionStack);
      memoizationMap.put(position, rule, memoEntry);

      EvaluationResult answer = evaluateExpression(position, rule.getExpression());

      memoEntry = new EvaluationResult(answer.position, memoEntry.answer);
      memoizationMap.put(position, rule, memoEntry);

      leftRecursionStack = leftRecursionStack.next;

      if (lr.head != null) {
        lr.seed = answer;
        return leftRecursionAnswer(position, rule);
      } else {
        memoizationMap.put(position, rule, answer);
        return answer;
      }
    } else {
      if (memoEntry.answer instanceof LeftRecursionChain) {
        LeftRecursionChain chain = (LeftRecursionChain) memoEntry.answer;
        setupLeftRecursion(rule, chain);
        return chain.seed;
      } else {
        return (EvaluationResult) memoEntry.answer;
      }
    }
  }

  private void setupLeftRecursion(Rule rule, LeftRecursionChain chain) {
    if (chain.head == null) {
      chain.head = new Head(rule.getVariable());
    }

    LeftRecursionChain s = leftRecursionStack;
    while (s.head != chain.head) {
      s.head = chain.head;
      chain.head.involvedSet.add(s.rule);
      s = s.next;
    }
  }

  private EvaluationResult leftRecursionAnswer(int position, Rule rule) {
    EvaluationResult memoEntry = memoizationMap.get(position, rule);

    LeftRecursionChain chain = (LeftRecursionChain) memoEntry.answer;
    Head head = chain.head;

    if (!head.variable.equals(rule.getVariable())) {
      return chain.seed;
    } else {
      memoEntry = chain.seed;
      memoizationMap.put(position, rule, memoEntry);

      if (memoEntry.isFailure()) {
        return EvaluationResult.failure;
      } else {
        return growLeftRecursion(position, rule, head);
      }
    }
  }

  private EvaluationResult recall(int position, Rule rule) {
    EvaluationResult memoEntry = memoizationMap.get(position, rule);
    Head head = headsMap.get(position);

    // If not growing a seed parse, just return what is stored in the memo
    // table.
    if (head == null) {
      return memoEntry;
    }

    // Do not evaluate any rule that is not involved in this left recursion.
    if (memoEntry == null && !rule.getVariable().equals(head.variable) && !head.involvedSet.contains(
        rule.getVariable())) {
      return EvaluationResult.failure;
    }

    // Allow involved rules to be evaluated, but only once, during a seed-
    // growing iteration.
    if (head.evaluationSet.remove(rule.getVariable())) {
      memoEntry = evaluateExpression(position, rule.getExpression());
      memoizationMap.put(position, rule, memoEntry);
    }

    return memoEntry;
  }

  private EvaluationResult growLeftRecursion(int position, Rule rule, Head head) {
    EvaluationResult memoEntry = memoizationMap.get(position, rule);
    headsMap.put(position, head);

    while (true) {
      head.evaluationSet.clear();
      head.evaluationSet.addAll(head.involvedSet);

      EvaluationResult result = evaluateExpression(position, rule.getExpression());
      if (result.isFailure() || result.position <= memoEntry.position) {
        break;
      }

      memoEntry = result;
      memoizationMap.put(position, rule, memoEntry);
    }

    headsMap.remove(position);
    return memoEntry;
  }

  private static class LeftRecursionChain {
    EvaluationResult seed;
    private String rule;
    private Head head;
    private LeftRecursionChain next;

    private LeftRecursionChain(EvaluationResult seed, String rule, Head head, LeftRecursionChain next) {
      this.seed = seed;
      this.rule = rule;
      this.head = head;
      this.next = next;
    }
  }

  private static class Head {
    private String variable;
    private Set<String> involvedSet = new LinkedHashSet<String>();
    private Set<String> evaluationSet = new LinkedHashSet<String>();

    public Head(String variable) {
      this.variable = variable;
    }
  }

  @Override public boolean equals(Object o) {
    return (o instanceof LeftRecursivePackratParser) && super.equals(o);
  }

  public static void main(String... args) {
    Object o1 = JavaGrammar.instance;

    Grammar g = new PackratGrammar<JavaToken.Type>(new Rule("x", variable("expr")), new Rule("expr", choice(sequence(
        variable("x"), token(MinusOperatorToken.instance), type(IdentifierToken.class)), type(
        IdentifierToken.class)))) {
      protected JavaToken.Type getTokenFromType(int type) {
        return JavaToken.Type.values()[type];
      }
    };
//        new Rule("num", character("5")));

    Span s = new SimpleSpan(new Position(0, 0), new Position(0, 0));
    System.out.println(g);
    Parser p = g.createParser(Arrays.asList(new SourceToken<JavaToken>(new IdentifierToken("1"), s),
                                            new SourceToken<JavaToken>(MinusOperatorToken.instance, s),
                                            new SourceToken<JavaToken>(new IdentifierToken("2"), s),
                                            new SourceToken<JavaToken>(MinusOperatorToken.instance, s),
                                            new SourceToken<JavaToken>(new IdentifierToken("3"), s)));

    Object o = p.parse();

    System.out.println();
  }
}
