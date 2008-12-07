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

package org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions;

import org.metasyntactic.common.base.Preconditions;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class OptionalExpression extends Expression {
  private final Expression child;

  OptionalExpression(Expression child) {
    Preconditions.checkNotNull(child);

    this.child = child;
  }

  public Expression getChild() {
    return child;
  }

  @Override public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof OptionalExpression)) {
      return false;
    }

    OptionalExpression that = (OptionalExpression) o;

    if (!child.equals(that.child)) {
      return false;
    }

    return true;
  }

  @Override public int hashCodeWorker() {
    return child.hashCode();
  }

  @Override public <TInput, TResult> TResult accept(ExpressionVisitor<TInput, TResult> visitor) {
    return visitor.visit(this);
  }

  @Override public <TInput> void accept(ExpressionVoidVisitor<TInput> visitor) {
    visitor.visit(this);
  }

  @Override public String toString() {
    return "(Optional " + getChild() + ")";
  }
}
