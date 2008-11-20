package org.metasyntactic.automata.compiler.framework.parsers.packrat;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class EvaluationResult {
  public static final EvaluationResult failure = new EvaluationResult(0);

  public final int position;
  public final Object answer;

  private EvaluationResult(int position) {
    this.position = position;
    this.answer = null;
  }

  public EvaluationResult(int position, Object answer) {
    this.position = position;
    this.answer = answer;
  }

  @Override public String toString() {
    if (this.isFailure()) {
      return "(Result failed)";
    } else {
      return "(Result succeeded " + position + " " + answer + ")";
    }
  }

  public boolean isFailure() {
    return this == failure;
  }

  public boolean isSuccess() {
    return !isFailure();
  }
}