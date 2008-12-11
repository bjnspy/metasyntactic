// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.framework.parsers.packrat;

import org.metasyntactic.automata.compiler.framework.parsers.ActionMap;
import org.metasyntactic.automata.compiler.framework.parsers.SourceToken;
import org.metasyntactic.automata.compiler.framework.parsers.Token;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions.Expression;
import org.metasyntactic.automata.compiler.util.Function4;

import java.util.List;

/**
 * TODO(cyrusn): javadoc
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class PackratParser<T extends Token> extends AbstractPackratParser<T> {
  protected PackratParser(PackratGrammar grammar, List<SourceToken<T>> input, ActionMap<T> actions) {
    super(grammar, input, actions);
  }

  protected PackratParser(PackratGrammar grammar, List<SourceToken<T>> input) {
    this(grammar, input, ActionMap.EMPTY_MAP);
  }


  public boolean equals(Object o) {
    return (o instanceof PackratParser) && super.equals(o);
  }

  protected EvaluationResult evaluateRule(final int position, final Rule rule) {
    EvaluationResult result = memoizationMap.get(position, rule);
    if (result == null) {
      result = evaluateRuleWorker(position, rule);

      memoizationMap.put(position, rule, result);
    }

    return result;
  }

  private EvaluationResult evaluateRuleWorker(int position, Rule rule) {
    EvaluationResult result = EvaluationResult.failure;

    if (checkToken(position, rule)) {
      result = evaluateExpression(position, rule.getExpression());

      if (result.isSuccess()) {
        Function4<Object, List<SourceToken<T>>, Integer, Integer, Object> action = actions.get(rule.getVariable());

        if (action != null) {
          Object value = action.apply(result.answer, input, position, result.position);

          if (value != result.answer) {
            result = new EvaluationResult(result.position, value);
          }
        }
      }
    }

    return result;
  }

  private final QuickQueue<EvaluationExpressionVisitor> visitors = new QuickQueue<EvaluationExpressionVisitor>();

   protected EvaluationResult evaluateExpression(final int position, final Expression expression) {
    furtherstPosition = Math.max(position, furtherstPosition);

    EvaluationExpressionVisitor visitor = visitors.poll();
    if (visitor == null) {
      visitor = new EvaluationExpressionVisitor();
    }

    visitor.position = position;

    EvaluationResult result = expression.accept(visitor);

    visitors.offer(visitor);

    return result;
  }
}