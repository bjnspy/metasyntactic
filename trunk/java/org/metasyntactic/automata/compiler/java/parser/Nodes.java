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

package org.metasyntactic.automata.compiler.java.parser;

import org.metasyntactic.automata.compiler.framework.parsers.SourceToken;
import org.metasyntactic.automata.compiler.java.scanner.IdentifierToken;
import org.metasyntactic.automata.compiler.java.scanner.keywords.*;
import org.metasyntactic.automata.compiler.java.scanner.literals.LiteralToken;
import org.metasyntactic.automata.compiler.java.scanner.operators.*;
import org.metasyntactic.automata.compiler.java.scanner.separators.*;
import org.metasyntactic.automata.compiler.util.DelimitedList;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class Nodes {
  private static List<Object> trimList(List<Object> list) {
    if (list.isEmpty()) {
      return Collections.emptyList();
    }
    if (list.size() == 1) {
      return Collections.singletonList(list.get(0));
    }
    return Collections.unmodifiableList(list);
  }

  public static interface INode {
    String getName();

    void accept(INodeVisitor visitor);

    List<Object> getChildren();
  }

  public static interface INodeVisitor {
    void visit(ICompilationUnitNode node);

    void visit(IPackageDeclarationNode node);

    void visit(IQualifiedIdentifierNode node);

    void visit(ISingleTypeImportDeclarationNode node);

    void visit(ITypeImportOnDemandDeclarationNode node);

    void visit(ISingleStaticImportDeclarationNode node);

    void visit(IStaticImportOnDemandDeclarationNode node);

    void visit(INormalClassDeclarationNode node);

    void visit(IModifiersNode node);

    void visit(ISuperNode node);

    void visit(IInterfacesNode node);

    void visit(IClassBodyNode node);

    void visit(IStaticInitializerNode node);

    void visit(INormalInterfaceDeclarationNode node);

    void visit(IExtendsInterfacesNode node);

    void visit(IClassOrInterfaceBodyNode node);

    void visit(IEnumDeclarationNode node);

    void visit(IEnumBodyNode node);

    void visit(IEnumConstantNode node);

    void visit(IArgumentsNode node);

    void visit(IAnnotationDeclarationNode node);

    void visit(IAnnotationBodyNode node);

    void visit(IAnnotationDefaultDeclarationNode node);

    void visit(IConstructorDeclarationNode node);

    void visit(IFieldDeclarationNode node);

    void visit(IVariableDeclaratorIdAndAssignmentNode node);

    void visit(IVariableDeclaratorIdNode node);

    void visit(IBracketPairNode node);

    void visit(IMethodDeclarationNode node);

    void visit(IFormalParameterNode node);

    void visit(IThrowsNode node);

    void visit(ITypeParametersNode node);

    void visit(ITypeParameterNode node);

    void visit(ITypeBoundNode node);

    void visit(IPrimitiveArrayReferenceTypeNode node);

    void visit(IClassOrInterfaceReferenceTypeNode node);

    void visit(IClassOrInterfaceTypeNode node);

    void visit(ISingleClassOrInterfaceTypeNode node);

    void visit(ITypeArgumentsNode node);

    void visit(IExtendsWildcardTypeArgumentNode node);

    void visit(ISuperWildcardTypeArgumentNode node);

    void visit(IOpenWildcardTypeArgumentNode node);

    void visit(INonWildcardTypeArgumentsNode node);

    void visit(INormalAnnotationNode node);

    void visit(IElementValuePairNode node);

    void visit(ISingleElementAnnotationNode node);

    void visit(IMarkerAnnotationNode node);

    void visit(IElementValueArrayInitializerNode node);

    void visit(IBlockNode node);

    void visit(ILocalVariableDeclarationStatementNode node);

    void visit(ILocalVariableDeclarationNode node);

    void visit(IEmptyStatementNode node);

    void visit(ILabeledStatementNode node);

    void visit(IExpressionStatementNode node);

    void visit(IIfStatementNode node);

    void visit(IElseStatementNode node);

    void visit(IMessageAssertStatementNode node);

    void visit(ISimpleAssertStatementNode node);

    void visit(ISwitchStatementNode node);

    void visit(ISwitchBlockStatementGroupNode node);

    void visit(ICaseSwitchLabelNode node);

    void visit(IDefaultSwitchLabelNode node);

    void visit(IWhileStatementNode node);

    void visit(IDoStatementNode node);

    void visit(IBasicForStatementNode node);

    void visit(IDelimitedExpressionListNode node);

    void visit(IEnhancedForStatementNode node);

    void visit(IBreakStatementNode node);

    void visit(IContinueStatementNode node);

    void visit(IReturnStatementNode node);

    void visit(IThrowStatementNode node);

    void visit(ISynchronizedStatementNode node);

    void visit(ITryStatementWithFinallyNode node);

    void visit(ITryStatementWithoutFinallyNode node);

    void visit(ICatchClauseNode node);

    void visit(IExpressionNode node);

    void visit(ITernaryExpressionNode node);

    void visit(IBinaryExpressionNode node);

    void visit(IInfixOperatorBinaryExpressionRestNode node);

    void visit(IInstanceofOperatorBinaryExpressionRestNode node);

    void visit(IUnsignedRightShiftNode node);

    void visit(ISignedRightShiftNode node);

    void visit(IPrefixExpressionNode node);

    void visit(IPossibleCastExpression_TypeNode node);

    void visit(IPossibleCastExpression_ExpressionNode node);

    void visit(IPrimaryExpressionNode node);

    void visit(IClassAccessNode node);

    void visit(IDotSelectorNode node);

    void visit(IArraySelectorNode node);

    void visit(IParenthesizedExpressionNode node);

    void visit(IMethodInvocationNode node);

    void visit(IThisConstructorInvocationNode node);

    void visit(ISuperConstructorInvocationNode node);

    void visit(IObjectCreationExpressionNode node);

    void visit(IArrayCreationExpressionNode node);

    void visit(IDimensionExpressionNode node);

    void visit(IArrayInitializerNode node);

    void visit(IThisKeywordTokenNode node);

    void visit(IVolatileKeywordTokenNode node);

    void visit(ITimesEqualsOperatorTokenNode node);

    void visit(IBitwiseNotOperatorTokenNode node);

    void visit(IExclusiveOrEqualsOperatorTokenNode node);

    void visit(IMinusEqualsOperatorTokenNode node);

    void visit(INativeKeywordTokenNode node);

    void visit(ILessThanOrEqualsOperatorTokenNode node);

    void visit(IDivideOperatorTokenNode node);

    void visit(IRightShiftEqualsOperatorTokenNode node);

    void visit(ILongKeywordTokenNode node);

    void visit(IIntKeywordTokenNode node);

    void visit(ILessThanOperatorTokenNode node);

    void visit(ILiteralTokenNode node);

    void visit(ILogicalNotOperatorTokenNode node);

    void visit(IIncrementOperatorTokenNode node);

    void visit(IEqualsOperatorTokenNode node);

    void visit(IStrictfpKeywordTokenNode node);

    void visit(IBitwiseRightShiftEqualsOperatorTokenNode node);

    void visit(IGreaterThanOrEqualsOperatorTokenNode node);

    void visit(IIdentifierTokenNode node);

    void visit(IProtectedKeywordTokenNode node);

    void visit(ILogicalAndOperatorTokenNode node);

    void visit(IPlusEqualsOperatorTokenNode node);

    void visit(IQuestionMarkOperatorTokenNode node);

    void visit(IEqualsEqualsOperatorTokenNode node);

    void visit(IDoubleKeywordTokenNode node);

    void visit(IModulusOperatorTokenNode node);

    void visit(ILeftShiftEqualsOperatorTokenNode node);

    void visit(IAndEqualsOperatorTokenNode node);

    void visit(ISynchronizedKeywordTokenNode node);

    void visit(ISemicolonSeparatorTokenNode node);

    void visit(IAbstractKeywordTokenNode node);

    void visit(ITimesOperatorTokenNode node);

    void visit(ILogicalOrOperatorTokenNode node);

    void visit(IPlusOperatorTokenNode node);

    void visit(ITransientKeywordTokenNode node);

    void visit(ISuperKeywordTokenNode node);

    void visit(IOrEqualsOperatorTokenNode node);

    void visit(IGreaterThanOperatorTokenNode node);

    void visit(IByteKeywordTokenNode node);

    void visit(IStaticKeywordTokenNode node);

    void visit(IFloatKeywordTokenNode node);

    void visit(IBitwiseAndOperatorTokenNode node);

    void visit(IBitwiseOrOperatorTokenNode node);

    void visit(IModulusEqualsOperatorTokenNode node);

    void visit(IMinusOperatorTokenNode node);

    void visit(IPrivateKeywordTokenNode node);

    void visit(ICharKeywordTokenNode node);

    void visit(IBooleanKeywordTokenNode node);

    void visit(IFinalKeywordTokenNode node);

    void visit(INotEqualsOperatorTokenNode node);

    void visit(ILeftShiftOperatorTokenNode node);

    void visit(IShortKeywordTokenNode node);

    void visit(IBitwiseExclusiveOrOperatorTokenNode node);

    void visit(IPublicKeywordTokenNode node);

    void visit(IVoidKeywordTokenNode node);

    void visit(IDecrementOperatorTokenNode node);

    void visit(IDivideEqualsOperatorTokenNode node);
  }

  public static abstract class AbstractNode implements INode {
    private List<Object> children;

    public List<Object> getChildren() {
      if (children == null) {
        children = getChildrenWorker();
      }
      return children;
    }

    protected abstract List<Object> getChildrenWorker();

    private int hashCode = -1;

    public int hashCode() {
      if (hashCode == -1) {
        hashCode = hashCodeWorker();
      }
      return hashCode;
    }

    protected abstract int hashCodeWorker();

    protected boolean equals(Object o1, Object o2) {
      return o1 == null ? o2 == null : o1.equals(o2);
    }

    public String toString() {
      return getName();
    }
  }

  public static interface IThisKeywordTokenNode extends INode, IValueExpressionNode {
    SourceToken<ThisKeywordToken> getToken();
  }

  public static class ThisKeywordTokenNode extends AbstractNode implements IThisKeywordTokenNode {
    private final SourceToken<ThisKeywordToken> token;

    public ThisKeywordTokenNode(SourceToken<ThisKeywordToken> token) {
      this.token = token;
    }

    public SourceToken<ThisKeywordToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IThisKeywordTokenNode)) { return false; }
      IThisKeywordTokenNode __node = (IThisKeywordTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IThisKeywordTokenNode";
    }
  }

  public static interface IVolatileKeywordTokenNode extends INode, IModifierNode {
    SourceToken<VolatileKeywordToken> getToken();
  }

  public static class VolatileKeywordTokenNode extends AbstractNode implements IVolatileKeywordTokenNode {
    private final SourceToken<VolatileKeywordToken> token;

    public VolatileKeywordTokenNode(SourceToken<VolatileKeywordToken> token) {
      this.token = token;
    }

    public SourceToken<VolatileKeywordToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IVolatileKeywordTokenNode)) { return false; }
      IVolatileKeywordTokenNode __node = (IVolatileKeywordTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IVolatileKeywordTokenNode";
    }
  }

  public static interface ITimesEqualsOperatorTokenNode extends INode, IAssignmentOperatorNode {
    SourceToken<TimesEqualsOperatorToken> getToken();
  }

  public static class TimesEqualsOperatorTokenNode extends AbstractNode implements ITimesEqualsOperatorTokenNode {
    private final SourceToken<TimesEqualsOperatorToken> token;

    public TimesEqualsOperatorTokenNode(SourceToken<TimesEqualsOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<TimesEqualsOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ITimesEqualsOperatorTokenNode)) { return false; }
      ITimesEqualsOperatorTokenNode __node = (ITimesEqualsOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "ITimesEqualsOperatorTokenNode";
    }
  }

  public static interface IBitwiseNotOperatorTokenNode extends INode, IPrefixOperatorNode {
    SourceToken<BitwiseNotOperatorToken> getToken();
  }

  public static class BitwiseNotOperatorTokenNode extends AbstractNode implements IBitwiseNotOperatorTokenNode {
    private final SourceToken<BitwiseNotOperatorToken> token;

    public BitwiseNotOperatorTokenNode(SourceToken<BitwiseNotOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<BitwiseNotOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IBitwiseNotOperatorTokenNode)) { return false; }
      IBitwiseNotOperatorTokenNode __node = (IBitwiseNotOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IBitwiseNotOperatorTokenNode";
    }
  }

  public static interface IExclusiveOrEqualsOperatorTokenNode extends INode, IAssignmentOperatorNode {
    SourceToken<ExclusiveOrEqualsOperatorToken> getToken();
  }

  public static class ExclusiveOrEqualsOperatorTokenNode extends AbstractNode
      implements IExclusiveOrEqualsOperatorTokenNode {
    private final SourceToken<ExclusiveOrEqualsOperatorToken> token;

    public ExclusiveOrEqualsOperatorTokenNode(SourceToken<ExclusiveOrEqualsOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<ExclusiveOrEqualsOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IExclusiveOrEqualsOperatorTokenNode)) { return false; }
      IExclusiveOrEqualsOperatorTokenNode __node = (IExclusiveOrEqualsOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IExclusiveOrEqualsOperatorTokenNode";
    }
  }

  public static interface IMinusEqualsOperatorTokenNode extends INode, IAssignmentOperatorNode {
    SourceToken<MinusEqualsOperatorToken> getToken();
  }

  public static class MinusEqualsOperatorTokenNode extends AbstractNode implements IMinusEqualsOperatorTokenNode {
    private final SourceToken<MinusEqualsOperatorToken> token;

    public MinusEqualsOperatorTokenNode(SourceToken<MinusEqualsOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<MinusEqualsOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IMinusEqualsOperatorTokenNode)) { return false; }
      IMinusEqualsOperatorTokenNode __node = (IMinusEqualsOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IMinusEqualsOperatorTokenNode";
    }
  }

  public static interface INativeKeywordTokenNode extends INode, IModifierNode {
    SourceToken<NativeKeywordToken> getToken();
  }

  public static class NativeKeywordTokenNode extends AbstractNode implements INativeKeywordTokenNode {
    private final SourceToken<NativeKeywordToken> token;

    public NativeKeywordTokenNode(SourceToken<NativeKeywordToken> token) {
      this.token = token;
    }

    public SourceToken<NativeKeywordToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof INativeKeywordTokenNode)) { return false; }
      INativeKeywordTokenNode __node = (INativeKeywordTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "INativeKeywordTokenNode";
    }
  }

  public static interface ILessThanOrEqualsOperatorTokenNode extends INode, IInfixOperatorNode {
    SourceToken<LessThanOrEqualsOperatorToken> getToken();
  }

  public static class LessThanOrEqualsOperatorTokenNode extends AbstractNode
      implements ILessThanOrEqualsOperatorTokenNode {
    private final SourceToken<LessThanOrEqualsOperatorToken> token;

    public LessThanOrEqualsOperatorTokenNode(SourceToken<LessThanOrEqualsOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<LessThanOrEqualsOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ILessThanOrEqualsOperatorTokenNode)) { return false; }
      ILessThanOrEqualsOperatorTokenNode __node = (ILessThanOrEqualsOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "ILessThanOrEqualsOperatorTokenNode";
    }
  }

  public static interface IDivideOperatorTokenNode extends INode, IInfixOperatorNode {
    SourceToken<DivideOperatorToken> getToken();
  }

  public static class DivideOperatorTokenNode extends AbstractNode implements IDivideOperatorTokenNode {
    private final SourceToken<DivideOperatorToken> token;

    public DivideOperatorTokenNode(SourceToken<DivideOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<DivideOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IDivideOperatorTokenNode)) { return false; }
      IDivideOperatorTokenNode __node = (IDivideOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IDivideOperatorTokenNode";
    }
  }

  public static interface IRightShiftEqualsOperatorTokenNode extends INode, IAssignmentOperatorNode {
    SourceToken<RightShiftEqualsOperatorToken> getToken();
  }

  public static class RightShiftEqualsOperatorTokenNode extends AbstractNode
      implements IRightShiftEqualsOperatorTokenNode {
    private final SourceToken<RightShiftEqualsOperatorToken> token;

    public RightShiftEqualsOperatorTokenNode(SourceToken<RightShiftEqualsOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<RightShiftEqualsOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IRightShiftEqualsOperatorTokenNode)) { return false; }
      IRightShiftEqualsOperatorTokenNode __node = (IRightShiftEqualsOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IRightShiftEqualsOperatorTokenNode";
    }
  }

  public static interface ILongKeywordTokenNode extends INode, IPrimitiveTypeNode {
    SourceToken<LongKeywordToken> getToken();
  }

  public static class LongKeywordTokenNode extends AbstractNode implements ILongKeywordTokenNode {
    private final SourceToken<LongKeywordToken> token;

    public LongKeywordTokenNode(SourceToken<LongKeywordToken> token) {
      this.token = token;
    }

    public SourceToken<LongKeywordToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ILongKeywordTokenNode)) { return false; }
      ILongKeywordTokenNode __node = (ILongKeywordTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "ILongKeywordTokenNode";
    }
  }

  public static interface IIntKeywordTokenNode extends INode, IPrimitiveTypeNode {
    SourceToken<IntKeywordToken> getToken();
  }

  public static class IntKeywordTokenNode extends AbstractNode implements IIntKeywordTokenNode {
    private final SourceToken<IntKeywordToken> token;

    public IntKeywordTokenNode(SourceToken<IntKeywordToken> token) {
      this.token = token;
    }

    public SourceToken<IntKeywordToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IIntKeywordTokenNode)) { return false; }
      IIntKeywordTokenNode __node = (IIntKeywordTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IIntKeywordTokenNode";
    }
  }

  public static interface ILessThanOperatorTokenNode extends INode, IInfixOperatorNode {
    SourceToken<LessThanOperatorToken> getToken();
  }

  public static class LessThanOperatorTokenNode extends AbstractNode implements ILessThanOperatorTokenNode {
    private final SourceToken<LessThanOperatorToken> token;

    public LessThanOperatorTokenNode(SourceToken<LessThanOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<LessThanOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ILessThanOperatorTokenNode)) { return false; }
      ILessThanOperatorTokenNode __node = (ILessThanOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "ILessThanOperatorTokenNode";
    }
  }

  public static interface ILiteralTokenNode extends INode, IValueExpressionNode {
    SourceToken<LiteralToken> getToken();
  }

  public static class LiteralTokenNode extends AbstractNode implements ILiteralTokenNode {
    private final SourceToken<LiteralToken> token;

    public LiteralTokenNode(SourceToken<LiteralToken> token) {
      this.token = token;
    }

    public SourceToken<LiteralToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ILiteralTokenNode)) { return false; }
      ILiteralTokenNode __node = (ILiteralTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "ILiteralTokenNode";
    }
  }

  public static interface ILogicalNotOperatorTokenNode extends INode, IPrefixOperatorNode {
    SourceToken<LogicalNotOperatorToken> getToken();
  }

  public static class LogicalNotOperatorTokenNode extends AbstractNode implements ILogicalNotOperatorTokenNode {
    private final SourceToken<LogicalNotOperatorToken> token;

    public LogicalNotOperatorTokenNode(SourceToken<LogicalNotOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<LogicalNotOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ILogicalNotOperatorTokenNode)) { return false; }
      ILogicalNotOperatorTokenNode __node = (ILogicalNotOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "ILogicalNotOperatorTokenNode";
    }
  }

  public static interface IIncrementOperatorTokenNode extends INode, IPostfixOperatorNode, IPrefixOperatorNode {
    SourceToken<IncrementOperatorToken> getToken();
  }

  public static class IncrementOperatorTokenNode extends AbstractNode implements IIncrementOperatorTokenNode {
    private final SourceToken<IncrementOperatorToken> token;

    public IncrementOperatorTokenNode(SourceToken<IncrementOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<IncrementOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IIncrementOperatorTokenNode)) { return false; }
      IIncrementOperatorTokenNode __node = (IIncrementOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IIncrementOperatorTokenNode";
    }
  }

  public static interface IEqualsOperatorTokenNode extends INode, IAssignmentOperatorNode {
    SourceToken<EqualsOperatorToken> getToken();
  }

  public static class EqualsOperatorTokenNode extends AbstractNode implements IEqualsOperatorTokenNode {
    private final SourceToken<EqualsOperatorToken> token;

    public EqualsOperatorTokenNode(SourceToken<EqualsOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<EqualsOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IEqualsOperatorTokenNode)) { return false; }
      IEqualsOperatorTokenNode __node = (IEqualsOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IEqualsOperatorTokenNode";
    }
  }

  public static interface IStrictfpKeywordTokenNode extends INode, IModifierNode {
    SourceToken<StrictfpKeywordToken> getToken();
  }

  public static class StrictfpKeywordTokenNode extends AbstractNode implements IStrictfpKeywordTokenNode {
    private final SourceToken<StrictfpKeywordToken> token;

    public StrictfpKeywordTokenNode(SourceToken<StrictfpKeywordToken> token) {
      this.token = token;
    }

    public SourceToken<StrictfpKeywordToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IStrictfpKeywordTokenNode)) { return false; }
      IStrictfpKeywordTokenNode __node = (IStrictfpKeywordTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IStrictfpKeywordTokenNode";
    }
  }

  public static interface IBitwiseRightShiftEqualsOperatorTokenNode extends INode, IAssignmentOperatorNode {
    SourceToken<BitwiseRightShiftEqualsOperatorToken> getToken();
  }

  public static class BitwiseRightShiftEqualsOperatorTokenNode extends AbstractNode
      implements IBitwiseRightShiftEqualsOperatorTokenNode {
    private final SourceToken<BitwiseRightShiftEqualsOperatorToken> token;

    public BitwiseRightShiftEqualsOperatorTokenNode(SourceToken<BitwiseRightShiftEqualsOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<BitwiseRightShiftEqualsOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IBitwiseRightShiftEqualsOperatorTokenNode)) { return false; }
      IBitwiseRightShiftEqualsOperatorTokenNode __node = (IBitwiseRightShiftEqualsOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IBitwiseRightShiftEqualsOperatorTokenNode";
    }
  }

  public static interface IGreaterThanOrEqualsOperatorTokenNode extends INode, IInfixOperatorNode {
    SourceToken<GreaterThanOrEqualsOperatorToken> getToken();
  }

  public static class GreaterThanOrEqualsOperatorTokenNode extends AbstractNode
      implements IGreaterThanOrEqualsOperatorTokenNode {
    private final SourceToken<GreaterThanOrEqualsOperatorToken> token;

    public GreaterThanOrEqualsOperatorTokenNode(SourceToken<GreaterThanOrEqualsOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<GreaterThanOrEqualsOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IGreaterThanOrEqualsOperatorTokenNode)) { return false; }
      IGreaterThanOrEqualsOperatorTokenNode __node = (IGreaterThanOrEqualsOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IGreaterThanOrEqualsOperatorTokenNode";
    }
  }

  public static interface IIdentifierTokenNode extends INode, IValueExpressionNode {
    SourceToken<IdentifierToken> getToken();
  }

  public static class IdentifierTokenNode extends AbstractNode implements IIdentifierTokenNode {
    private final SourceToken<IdentifierToken> token;

    public IdentifierTokenNode(SourceToken<IdentifierToken> token) {
      this.token = token;
    }

    public SourceToken<IdentifierToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IIdentifierTokenNode)) { return false; }
      IIdentifierTokenNode __node = (IIdentifierTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IIdentifierTokenNode";
    }
  }

  public static interface IProtectedKeywordTokenNode extends INode, IModifierNode {
    SourceToken<ProtectedKeywordToken> getToken();
  }

  public static class ProtectedKeywordTokenNode extends AbstractNode implements IProtectedKeywordTokenNode {
    private final SourceToken<ProtectedKeywordToken> token;

    public ProtectedKeywordTokenNode(SourceToken<ProtectedKeywordToken> token) {
      this.token = token;
    }

    public SourceToken<ProtectedKeywordToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IProtectedKeywordTokenNode)) { return false; }
      IProtectedKeywordTokenNode __node = (IProtectedKeywordTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IProtectedKeywordTokenNode";
    }
  }

  public static interface ILogicalAndOperatorTokenNode extends INode, IInfixOperatorNode {
    SourceToken<LogicalAndOperatorToken> getToken();
  }

  public static class LogicalAndOperatorTokenNode extends AbstractNode implements ILogicalAndOperatorTokenNode {
    private final SourceToken<LogicalAndOperatorToken> token;

    public LogicalAndOperatorTokenNode(SourceToken<LogicalAndOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<LogicalAndOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ILogicalAndOperatorTokenNode)) { return false; }
      ILogicalAndOperatorTokenNode __node = (ILogicalAndOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "ILogicalAndOperatorTokenNode";
    }
  }

  public static interface IPlusEqualsOperatorTokenNode extends INode, IAssignmentOperatorNode {
    SourceToken<PlusEqualsOperatorToken> getToken();
  }

  public static class PlusEqualsOperatorTokenNode extends AbstractNode implements IPlusEqualsOperatorTokenNode {
    private final SourceToken<PlusEqualsOperatorToken> token;

    public PlusEqualsOperatorTokenNode(SourceToken<PlusEqualsOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<PlusEqualsOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IPlusEqualsOperatorTokenNode)) { return false; }
      IPlusEqualsOperatorTokenNode __node = (IPlusEqualsOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IPlusEqualsOperatorTokenNode";
    }
  }

  public static interface IQuestionMarkOperatorTokenNode extends INode {
    SourceToken<QuestionMarkOperatorToken> getToken();
  }

  public static class QuestionMarkOperatorTokenNode extends AbstractNode implements IQuestionMarkOperatorTokenNode {
    private final SourceToken<QuestionMarkOperatorToken> token;

    public QuestionMarkOperatorTokenNode(SourceToken<QuestionMarkOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<QuestionMarkOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IQuestionMarkOperatorTokenNode)) { return false; }
      IQuestionMarkOperatorTokenNode __node = (IQuestionMarkOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IQuestionMarkOperatorTokenNode";
    }
  }

  public static interface IEqualsEqualsOperatorTokenNode extends INode, IInfixOperatorNode {
    SourceToken<EqualsEqualsOperatorToken> getToken();
  }

  public static class EqualsEqualsOperatorTokenNode extends AbstractNode implements IEqualsEqualsOperatorTokenNode {
    private final SourceToken<EqualsEqualsOperatorToken> token;

    public EqualsEqualsOperatorTokenNode(SourceToken<EqualsEqualsOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<EqualsEqualsOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IEqualsEqualsOperatorTokenNode)) { return false; }
      IEqualsEqualsOperatorTokenNode __node = (IEqualsEqualsOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IEqualsEqualsOperatorTokenNode";
    }
  }

  public static interface IDoubleKeywordTokenNode extends INode, IPrimitiveTypeNode {
    SourceToken<DoubleKeywordToken> getToken();
  }

  public static class DoubleKeywordTokenNode extends AbstractNode implements IDoubleKeywordTokenNode {
    private final SourceToken<DoubleKeywordToken> token;

    public DoubleKeywordTokenNode(SourceToken<DoubleKeywordToken> token) {
      this.token = token;
    }

    public SourceToken<DoubleKeywordToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IDoubleKeywordTokenNode)) { return false; }
      IDoubleKeywordTokenNode __node = (IDoubleKeywordTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IDoubleKeywordTokenNode";
    }
  }

  public static interface IModulusOperatorTokenNode extends INode, IInfixOperatorNode {
    SourceToken<ModulusOperatorToken> getToken();
  }

  public static class ModulusOperatorTokenNode extends AbstractNode implements IModulusOperatorTokenNode {
    private final SourceToken<ModulusOperatorToken> token;

    public ModulusOperatorTokenNode(SourceToken<ModulusOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<ModulusOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IModulusOperatorTokenNode)) { return false; }
      IModulusOperatorTokenNode __node = (IModulusOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IModulusOperatorTokenNode";
    }
  }

  public static interface ILeftShiftEqualsOperatorTokenNode extends INode, IAssignmentOperatorNode {
    SourceToken<LeftShiftEqualsOperatorToken> getToken();
  }

  public static class LeftShiftEqualsOperatorTokenNode extends AbstractNode
      implements ILeftShiftEqualsOperatorTokenNode {
    private final SourceToken<LeftShiftEqualsOperatorToken> token;

    public LeftShiftEqualsOperatorTokenNode(SourceToken<LeftShiftEqualsOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<LeftShiftEqualsOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ILeftShiftEqualsOperatorTokenNode)) { return false; }
      ILeftShiftEqualsOperatorTokenNode __node = (ILeftShiftEqualsOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "ILeftShiftEqualsOperatorTokenNode";
    }
  }

  public static interface IAndEqualsOperatorTokenNode extends INode, IAssignmentOperatorNode {
    SourceToken<AndEqualsOperatorToken> getToken();
  }

  public static class AndEqualsOperatorTokenNode extends AbstractNode implements IAndEqualsOperatorTokenNode {
    private final SourceToken<AndEqualsOperatorToken> token;

    public AndEqualsOperatorTokenNode(SourceToken<AndEqualsOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<AndEqualsOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IAndEqualsOperatorTokenNode)) { return false; }
      IAndEqualsOperatorTokenNode __node = (IAndEqualsOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IAndEqualsOperatorTokenNode";
    }
  }

  public static interface ISynchronizedKeywordTokenNode extends INode, IModifierNode {
    SourceToken<SynchronizedKeywordToken> getToken();
  }

  public static class SynchronizedKeywordTokenNode extends AbstractNode implements ISynchronizedKeywordTokenNode {
    private final SourceToken<SynchronizedKeywordToken> token;

    public SynchronizedKeywordTokenNode(SourceToken<SynchronizedKeywordToken> token) {
      this.token = token;
    }

    public SourceToken<SynchronizedKeywordToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ISynchronizedKeywordTokenNode)) { return false; }
      ISynchronizedKeywordTokenNode __node = (ISynchronizedKeywordTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "ISynchronizedKeywordTokenNode";
    }
  }

  public static interface ISemicolonSeparatorTokenNode extends INode, ITypeDeclarationNode, IMethodBodyNode {
    SourceToken<SemicolonSeparatorToken> getToken();
  }

  public static class SemicolonSeparatorTokenNode extends AbstractNode implements ISemicolonSeparatorTokenNode {
    private final SourceToken<SemicolonSeparatorToken> token;

    public SemicolonSeparatorTokenNode(SourceToken<SemicolonSeparatorToken> token) {
      this.token = token;
    }

    public SourceToken<SemicolonSeparatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ISemicolonSeparatorTokenNode)) { return false; }
      ISemicolonSeparatorTokenNode __node = (ISemicolonSeparatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "ISemicolonSeparatorTokenNode";
    }
  }

  public static interface IAbstractKeywordTokenNode extends INode, IModifierNode {
    SourceToken<AbstractKeywordToken> getToken();
  }

  public static class AbstractKeywordTokenNode extends AbstractNode implements IAbstractKeywordTokenNode {
    private final SourceToken<AbstractKeywordToken> token;

    public AbstractKeywordTokenNode(SourceToken<AbstractKeywordToken> token) {
      this.token = token;
    }

    public SourceToken<AbstractKeywordToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IAbstractKeywordTokenNode)) { return false; }
      IAbstractKeywordTokenNode __node = (IAbstractKeywordTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IAbstractKeywordTokenNode";
    }
  }

  public static interface ITimesOperatorTokenNode extends INode, IInfixOperatorNode {
    SourceToken<TimesOperatorToken> getToken();
  }

  public static class TimesOperatorTokenNode extends AbstractNode implements ITimesOperatorTokenNode {
    private final SourceToken<TimesOperatorToken> token;

    public TimesOperatorTokenNode(SourceToken<TimesOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<TimesOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ITimesOperatorTokenNode)) { return false; }
      ITimesOperatorTokenNode __node = (ITimesOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "ITimesOperatorTokenNode";
    }
  }

  public static interface ILogicalOrOperatorTokenNode extends INode, IInfixOperatorNode {
    SourceToken<LogicalOrOperatorToken> getToken();
  }

  public static class LogicalOrOperatorTokenNode extends AbstractNode implements ILogicalOrOperatorTokenNode {
    private final SourceToken<LogicalOrOperatorToken> token;

    public LogicalOrOperatorTokenNode(SourceToken<LogicalOrOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<LogicalOrOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ILogicalOrOperatorTokenNode)) { return false; }
      ILogicalOrOperatorTokenNode __node = (ILogicalOrOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "ILogicalOrOperatorTokenNode";
    }
  }

  public static interface IPlusOperatorTokenNode extends INode, IPrefixOperatorNode, IInfixOperatorNode {
    SourceToken<PlusOperatorToken> getToken();
  }

  public static class PlusOperatorTokenNode extends AbstractNode implements IPlusOperatorTokenNode {
    private final SourceToken<PlusOperatorToken> token;

    public PlusOperatorTokenNode(SourceToken<PlusOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<PlusOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IPlusOperatorTokenNode)) { return false; }
      IPlusOperatorTokenNode __node = (IPlusOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IPlusOperatorTokenNode";
    }
  }

  public static interface ITransientKeywordTokenNode extends INode, IModifierNode {
    SourceToken<TransientKeywordToken> getToken();
  }

  public static class TransientKeywordTokenNode extends AbstractNode implements ITransientKeywordTokenNode {
    private final SourceToken<TransientKeywordToken> token;

    public TransientKeywordTokenNode(SourceToken<TransientKeywordToken> token) {
      this.token = token;
    }

    public SourceToken<TransientKeywordToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ITransientKeywordTokenNode)) { return false; }
      ITransientKeywordTokenNode __node = (ITransientKeywordTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "ITransientKeywordTokenNode";
    }
  }

  public static interface ISuperKeywordTokenNode extends INode, IValueExpressionNode {
    SourceToken<SuperKeywordToken> getToken();
  }

  public static class SuperKeywordTokenNode extends AbstractNode implements ISuperKeywordTokenNode {
    private final SourceToken<SuperKeywordToken> token;

    public SuperKeywordTokenNode(SourceToken<SuperKeywordToken> token) {
      this.token = token;
    }

    public SourceToken<SuperKeywordToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ISuperKeywordTokenNode)) { return false; }
      ISuperKeywordTokenNode __node = (ISuperKeywordTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "ISuperKeywordTokenNode";
    }
  }

  public static interface IOrEqualsOperatorTokenNode extends INode, IAssignmentOperatorNode {
    SourceToken<OrEqualsOperatorToken> getToken();
  }

  public static class OrEqualsOperatorTokenNode extends AbstractNode implements IOrEqualsOperatorTokenNode {
    private final SourceToken<OrEqualsOperatorToken> token;

    public OrEqualsOperatorTokenNode(SourceToken<OrEqualsOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<OrEqualsOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IOrEqualsOperatorTokenNode)) { return false; }
      IOrEqualsOperatorTokenNode __node = (IOrEqualsOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IOrEqualsOperatorTokenNode";
    }
  }

  public static interface IGreaterThanOperatorTokenNode extends INode, IInfixOperatorNode {
    SourceToken<GreaterThanOperatorToken> getToken();
  }

  public static class GreaterThanOperatorTokenNode extends AbstractNode implements IGreaterThanOperatorTokenNode {
    private final SourceToken<GreaterThanOperatorToken> token;

    public GreaterThanOperatorTokenNode(SourceToken<GreaterThanOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<GreaterThanOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IGreaterThanOperatorTokenNode)) { return false; }
      IGreaterThanOperatorTokenNode __node = (IGreaterThanOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IGreaterThanOperatorTokenNode";
    }
  }

  public static interface IByteKeywordTokenNode extends INode, IPrimitiveTypeNode {
    SourceToken<ByteKeywordToken> getToken();
  }

  public static class ByteKeywordTokenNode extends AbstractNode implements IByteKeywordTokenNode {
    private final SourceToken<ByteKeywordToken> token;

    public ByteKeywordTokenNode(SourceToken<ByteKeywordToken> token) {
      this.token = token;
    }

    public SourceToken<ByteKeywordToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IByteKeywordTokenNode)) { return false; }
      IByteKeywordTokenNode __node = (IByteKeywordTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IByteKeywordTokenNode";
    }
  }

  public static interface IStaticKeywordTokenNode extends INode, IModifierNode {
    SourceToken<StaticKeywordToken> getToken();
  }

  public static class StaticKeywordTokenNode extends AbstractNode implements IStaticKeywordTokenNode {
    private final SourceToken<StaticKeywordToken> token;

    public StaticKeywordTokenNode(SourceToken<StaticKeywordToken> token) {
      this.token = token;
    }

    public SourceToken<StaticKeywordToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IStaticKeywordTokenNode)) { return false; }
      IStaticKeywordTokenNode __node = (IStaticKeywordTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IStaticKeywordTokenNode";
    }
  }

  public static interface IFloatKeywordTokenNode extends INode, IPrimitiveTypeNode {
    SourceToken<FloatKeywordToken> getToken();
  }

  public static class FloatKeywordTokenNode extends AbstractNode implements IFloatKeywordTokenNode {
    private final SourceToken<FloatKeywordToken> token;

    public FloatKeywordTokenNode(SourceToken<FloatKeywordToken> token) {
      this.token = token;
    }

    public SourceToken<FloatKeywordToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IFloatKeywordTokenNode)) { return false; }
      IFloatKeywordTokenNode __node = (IFloatKeywordTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IFloatKeywordTokenNode";
    }
  }

  public static interface IBitwiseAndOperatorTokenNode extends INode, IInfixOperatorNode {
    SourceToken<BitwiseAndOperatorToken> getToken();
  }

  public static class BitwiseAndOperatorTokenNode extends AbstractNode implements IBitwiseAndOperatorTokenNode {
    private final SourceToken<BitwiseAndOperatorToken> token;

    public BitwiseAndOperatorTokenNode(SourceToken<BitwiseAndOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<BitwiseAndOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IBitwiseAndOperatorTokenNode)) { return false; }
      IBitwiseAndOperatorTokenNode __node = (IBitwiseAndOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IBitwiseAndOperatorTokenNode";
    }
  }

  public static interface IBitwiseOrOperatorTokenNode extends INode, IInfixOperatorNode {
    SourceToken<BitwiseOrOperatorToken> getToken();
  }

  public static class BitwiseOrOperatorTokenNode extends AbstractNode implements IBitwiseOrOperatorTokenNode {
    private final SourceToken<BitwiseOrOperatorToken> token;

    public BitwiseOrOperatorTokenNode(SourceToken<BitwiseOrOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<BitwiseOrOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IBitwiseOrOperatorTokenNode)) { return false; }
      IBitwiseOrOperatorTokenNode __node = (IBitwiseOrOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IBitwiseOrOperatorTokenNode";
    }
  }

  public static interface IModulusEqualsOperatorTokenNode extends INode, IAssignmentOperatorNode {
    SourceToken<ModulusEqualsOperatorToken> getToken();
  }

  public static class ModulusEqualsOperatorTokenNode extends AbstractNode implements IModulusEqualsOperatorTokenNode {
    private final SourceToken<ModulusEqualsOperatorToken> token;

    public ModulusEqualsOperatorTokenNode(SourceToken<ModulusEqualsOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<ModulusEqualsOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IModulusEqualsOperatorTokenNode)) { return false; }
      IModulusEqualsOperatorTokenNode __node = (IModulusEqualsOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IModulusEqualsOperatorTokenNode";
    }
  }

  public static interface IMinusOperatorTokenNode extends INode, IPrefixOperatorNode, IInfixOperatorNode {
    SourceToken<MinusOperatorToken> getToken();
  }

  public static class MinusOperatorTokenNode extends AbstractNode implements IMinusOperatorTokenNode {
    private final SourceToken<MinusOperatorToken> token;

    public MinusOperatorTokenNode(SourceToken<MinusOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<MinusOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IMinusOperatorTokenNode)) { return false; }
      IMinusOperatorTokenNode __node = (IMinusOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IMinusOperatorTokenNode";
    }
  }

  public static interface IPrivateKeywordTokenNode extends INode, IModifierNode {
    SourceToken<PrivateKeywordToken> getToken();
  }

  public static class PrivateKeywordTokenNode extends AbstractNode implements IPrivateKeywordTokenNode {
    private final SourceToken<PrivateKeywordToken> token;

    public PrivateKeywordTokenNode(SourceToken<PrivateKeywordToken> token) {
      this.token = token;
    }

    public SourceToken<PrivateKeywordToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IPrivateKeywordTokenNode)) { return false; }
      IPrivateKeywordTokenNode __node = (IPrivateKeywordTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IPrivateKeywordTokenNode";
    }
  }

  public static interface ICharKeywordTokenNode extends INode, IPrimitiveTypeNode {
    SourceToken<CharKeywordToken> getToken();
  }

  public static class CharKeywordTokenNode extends AbstractNode implements ICharKeywordTokenNode {
    private final SourceToken<CharKeywordToken> token;

    public CharKeywordTokenNode(SourceToken<CharKeywordToken> token) {
      this.token = token;
    }

    public SourceToken<CharKeywordToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ICharKeywordTokenNode)) { return false; }
      ICharKeywordTokenNode __node = (ICharKeywordTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "ICharKeywordTokenNode";
    }
  }

  public static interface IBooleanKeywordTokenNode extends INode, IPrimitiveTypeNode {
    SourceToken<BooleanKeywordToken> getToken();
  }

  public static class BooleanKeywordTokenNode extends AbstractNode implements IBooleanKeywordTokenNode {
    private final SourceToken<BooleanKeywordToken> token;

    public BooleanKeywordTokenNode(SourceToken<BooleanKeywordToken> token) {
      this.token = token;
    }

    public SourceToken<BooleanKeywordToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IBooleanKeywordTokenNode)) { return false; }
      IBooleanKeywordTokenNode __node = (IBooleanKeywordTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IBooleanKeywordTokenNode";
    }
  }

  public static interface IFinalKeywordTokenNode extends INode, IModifierNode {
    SourceToken<FinalKeywordToken> getToken();
  }

  public static class FinalKeywordTokenNode extends AbstractNode implements IFinalKeywordTokenNode {
    private final SourceToken<FinalKeywordToken> token;

    public FinalKeywordTokenNode(SourceToken<FinalKeywordToken> token) {
      this.token = token;
    }

    public SourceToken<FinalKeywordToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IFinalKeywordTokenNode)) { return false; }
      IFinalKeywordTokenNode __node = (IFinalKeywordTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IFinalKeywordTokenNode";
    }
  }

  public static interface INotEqualsOperatorTokenNode extends INode, IInfixOperatorNode {
    SourceToken<NotEqualsOperatorToken> getToken();
  }

  public static class NotEqualsOperatorTokenNode extends AbstractNode implements INotEqualsOperatorTokenNode {
    private final SourceToken<NotEqualsOperatorToken> token;

    public NotEqualsOperatorTokenNode(SourceToken<NotEqualsOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<NotEqualsOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof INotEqualsOperatorTokenNode)) { return false; }
      INotEqualsOperatorTokenNode __node = (INotEqualsOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "INotEqualsOperatorTokenNode";
    }
  }

  public static interface ILeftShiftOperatorTokenNode extends INode, IInfixOperatorNode {
    SourceToken<LeftShiftOperatorToken> getToken();
  }

  public static class LeftShiftOperatorTokenNode extends AbstractNode implements ILeftShiftOperatorTokenNode {
    private final SourceToken<LeftShiftOperatorToken> token;

    public LeftShiftOperatorTokenNode(SourceToken<LeftShiftOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<LeftShiftOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ILeftShiftOperatorTokenNode)) { return false; }
      ILeftShiftOperatorTokenNode __node = (ILeftShiftOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "ILeftShiftOperatorTokenNode";
    }
  }

  public static interface IShortKeywordTokenNode extends INode, IPrimitiveTypeNode {
    SourceToken<ShortKeywordToken> getToken();
  }

  public static class ShortKeywordTokenNode extends AbstractNode implements IShortKeywordTokenNode {
    private final SourceToken<ShortKeywordToken> token;

    public ShortKeywordTokenNode(SourceToken<ShortKeywordToken> token) {
      this.token = token;
    }

    public SourceToken<ShortKeywordToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IShortKeywordTokenNode)) { return false; }
      IShortKeywordTokenNode __node = (IShortKeywordTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IShortKeywordTokenNode";
    }
  }

  public static interface IBitwiseExclusiveOrOperatorTokenNode extends INode, IInfixOperatorNode {
    SourceToken<BitwiseExclusiveOrOperatorToken> getToken();
  }

  public static class BitwiseExclusiveOrOperatorTokenNode extends AbstractNode
      implements IBitwiseExclusiveOrOperatorTokenNode {
    private final SourceToken<BitwiseExclusiveOrOperatorToken> token;

    public BitwiseExclusiveOrOperatorTokenNode(SourceToken<BitwiseExclusiveOrOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<BitwiseExclusiveOrOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IBitwiseExclusiveOrOperatorTokenNode)) { return false; }
      IBitwiseExclusiveOrOperatorTokenNode __node = (IBitwiseExclusiveOrOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IBitwiseExclusiveOrOperatorTokenNode";
    }
  }

  public static interface IPublicKeywordTokenNode extends INode, IModifierNode {
    SourceToken<PublicKeywordToken> getToken();
  }

  public static class PublicKeywordTokenNode extends AbstractNode implements IPublicKeywordTokenNode {
    private final SourceToken<PublicKeywordToken> token;

    public PublicKeywordTokenNode(SourceToken<PublicKeywordToken> token) {
      this.token = token;
    }

    public SourceToken<PublicKeywordToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IPublicKeywordTokenNode)) { return false; }
      IPublicKeywordTokenNode __node = (IPublicKeywordTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IPublicKeywordTokenNode";
    }
  }

  public static interface IVoidKeywordTokenNode extends INode, IPrimitiveTypeNode {
    SourceToken<VoidKeywordToken> getToken();
  }

  public static class VoidKeywordTokenNode extends AbstractNode implements IVoidKeywordTokenNode {
    private final SourceToken<VoidKeywordToken> token;

    public VoidKeywordTokenNode(SourceToken<VoidKeywordToken> token) {
      this.token = token;
    }

    public SourceToken<VoidKeywordToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IVoidKeywordTokenNode)) { return false; }
      IVoidKeywordTokenNode __node = (IVoidKeywordTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IVoidKeywordTokenNode";
    }
  }

  public static interface IDecrementOperatorTokenNode extends INode, IPostfixOperatorNode, IPrefixOperatorNode {
    SourceToken<DecrementOperatorToken> getToken();
  }

  public static class DecrementOperatorTokenNode extends AbstractNode implements IDecrementOperatorTokenNode {
    private final SourceToken<DecrementOperatorToken> token;

    public DecrementOperatorTokenNode(SourceToken<DecrementOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<DecrementOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IDecrementOperatorTokenNode)) { return false; }
      IDecrementOperatorTokenNode __node = (IDecrementOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IDecrementOperatorTokenNode";
    }
  }

  public static interface IDivideEqualsOperatorTokenNode extends INode, IAssignmentOperatorNode {
    SourceToken<DivideEqualsOperatorToken> getToken();
  }

  public static class DivideEqualsOperatorTokenNode extends AbstractNode implements IDivideEqualsOperatorTokenNode {
    private final SourceToken<DivideEqualsOperatorToken> token;

    public DivideEqualsOperatorTokenNode(SourceToken<DivideEqualsOperatorToken> token) {
      this.token = token;
    }

    public SourceToken<DivideEqualsOperatorToken> getToken() {
      return token;
    }

    protected List<Object> getChildrenWorker() {
      return Collections.<Object>singletonList(token);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IDivideEqualsOperatorTokenNode)) { return false; }
      IDivideEqualsOperatorTokenNode __node = (IDivideEqualsOperatorTokenNode) __other;
      return equals(token, __node.getToken());
    }

    protected int hashCodeWorker() {
      return token.hashCode();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public String getName() {
      return "IDivideEqualsOperatorTokenNode";
    }
  }

  public static interface ICompilationUnitNode extends INode {
    IPackageDeclarationNode getOptionalPackageDeclaration();

    List<IImportDeclarationNode> getImportDeclarationList();

    List<ITypeDeclarationNode> getTypeDeclarationList();
  }

  public static interface IPackageDeclarationNode extends INode {
    List<IAnnotationNode> getAnnotationList();

    SourceToken<PackageKeywordToken> getPackageKeyword();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public static interface IQualifiedIdentifierNode extends INode {
    DelimitedList<SourceToken<IdentifierToken>, SourceToken<DotSeparatorToken>> getIdentifierList();
  }

  public static interface IImportDeclarationNode extends INode {
  }

  public static interface ISingleTypeImportDeclarationNode extends INode, IImportDeclarationNode {
    SourceToken<ImportKeywordToken> getImportKeyword();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public static interface ITypeImportOnDemandDeclarationNode extends INode, IImportDeclarationNode {
    SourceToken<ImportKeywordToken> getImportKeyword();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SourceToken<DotSeparatorToken> getDotSeparator();

    SourceToken<TimesOperatorToken> getTimesOperator();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public static interface ISingleStaticImportDeclarationNode extends INode, IImportDeclarationNode {
    SourceToken<ImportKeywordToken> getImportKeyword();

    SourceToken<StaticKeywordToken> getStaticKeyword();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public static interface IStaticImportOnDemandDeclarationNode extends INode, IImportDeclarationNode {
    SourceToken<ImportKeywordToken> getImportKeyword();

    SourceToken<StaticKeywordToken> getStaticKeyword();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SourceToken<DotSeparatorToken> getDotSeparator();

    SourceToken<TimesOperatorToken> getTimesOperator();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public static interface ITypeDeclarationNode extends INode, IClassOrInterfaceMemberDeclarationNode {
  }

  public static interface IClassDeclarationNode extends INode, IBlockStatementNode, ITypeDeclarationNode {
  }

  public static interface INormalClassDeclarationNode extends INode, IClassDeclarationNode {
    IModifiersNode getModifiers();

    SourceToken<ClassKeywordToken> getClassKeyword();

    SourceToken<IdentifierToken> getIdentifier();

    ITypeParametersNode getOptionalTypeParameters();

    ISuperNode getOptionalSuper();

    IInterfacesNode getOptionalInterfaces();

    IClassBodyNode getClassBody();
  }

  public static interface IModifiersNode extends INode {
    List<IModifierNode> getModifierList();
  }

  public static interface IModifierNode extends INode {
  }

  public static interface ISuperNode extends INode {
    SourceToken<ExtendsKeywordToken> getExtendsKeyword();

    IClassOrInterfaceTypeNode getClassOrInterfaceType();
  }

  public static interface IInterfacesNode extends INode {
    SourceToken<ImplementsKeywordToken> getImplementsKeyword();

    DelimitedList<IClassOrInterfaceTypeNode, SourceToken<CommaSeparatorToken>> getClassOrInterfaceTypeList();
  }

  public static interface IClassBodyNode extends INode {
    SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator();

    List<IClassBodyDeclarationNode> getClassBodyDeclarationList();

    SourceToken<RightCurlySeparatorToken> getRightCurlySeparator();
  }

  public static interface IClassBodyDeclarationNode extends INode {
  }

  public static interface IStaticInitializerNode extends INode, IClassBodyDeclarationNode {
    SourceToken<StaticKeywordToken> getStaticKeyword();

    IBlockNode getBlock();
  }

  public static interface IInterfaceDeclarationNode extends INode, ITypeDeclarationNode {
  }

  public static interface INormalInterfaceDeclarationNode extends INode, IInterfaceDeclarationNode {
    IModifiersNode getModifiers();

    SourceToken<InterfaceKeywordToken> getInterfaceKeyword();

    SourceToken<IdentifierToken> getIdentifier();

    ITypeParametersNode getOptionalTypeParameters();

    IExtendsInterfacesNode getOptionalExtendsInterfaces();

    IClassOrInterfaceBodyNode getClassOrInterfaceBody();
  }

  public static interface IExtendsInterfacesNode extends INode {
    SourceToken<ExtendsKeywordToken> getExtendsKeyword();

    DelimitedList<IClassOrInterfaceTypeNode, SourceToken<CommaSeparatorToken>> getClassOrInterfaceTypeList();
  }

  public static interface IClassOrInterfaceBodyNode extends INode {
    SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator();

    List<IClassOrInterfaceMemberDeclarationNode> getClassOrInterfaceMemberDeclarationList();

    SourceToken<RightCurlySeparatorToken> getRightCurlySeparator();
  }

  public static interface IEnumDeclarationNode extends INode, IClassDeclarationNode {
    IModifiersNode getModifiers();

    SourceToken<EnumKeywordToken> getEnumKeyword();

    SourceToken<IdentifierToken> getIdentifier();

    IInterfacesNode getOptionalInterfaces();

    IEnumBodyNode getEnumBody();
  }

  public static interface IEnumBodyNode extends INode {
    SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator();

    DelimitedList<IEnumConstantNode, SourceToken<CommaSeparatorToken>> getOptionalEnumConstantList();

    SourceToken<SemicolonSeparatorToken> getOptionalSemicolonSeparator();

    List<IClassBodyDeclarationNode> getClassBodyDeclarationList();

    SourceToken<RightCurlySeparatorToken> getRightCurlySeparator();
  }

  public static interface IEnumConstantNode extends INode {
    List<IAnnotationNode> getAnnotationList();

    SourceToken<IdentifierToken> getIdentifier();

    IArgumentsNode getOptionalArguments();

    IClassOrInterfaceBodyNode getOptionalClassOrInterfaceBody();
  }

  public static interface IArgumentsNode extends INode {
    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IDelimitedExpressionListNode getOptionalDelimitedExpressionList();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();
  }

  public static interface IAnnotationDeclarationNode extends INode, IInterfaceDeclarationNode {
    IModifiersNode getModifiers();

    SourceToken<AtSeparatorToken> getAtSeparator();

    SourceToken<InterfaceKeywordToken> getInterfaceKeyword();

    SourceToken<IdentifierToken> getIdentifier();

    IAnnotationBodyNode getAnnotationBody();
  }

  public static interface IAnnotationBodyNode extends INode {
    SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator();

    List<IAnnotationElementDeclarationNode> getAnnotationElementDeclarationList();

    SourceToken<RightCurlySeparatorToken> getRightCurlySeparator();
  }

  public static interface IAnnotationElementDeclarationNode extends INode {
  }

  public static interface IAnnotationDefaultDeclarationNode extends INode, IAnnotationElementDeclarationNode {
    IModifiersNode getModifiers();

    ITypeNode getType();

    SourceToken<IdentifierToken> getIdentifier();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    SourceToken<DefaultKeywordToken> getDefaultKeyword();

    IElementValueNode getElementValue();
  }

  public static interface IClassOrInterfaceMemberDeclarationNode
      extends INode, IClassBodyDeclarationNode, IAnnotationElementDeclarationNode {
  }

  public static interface IConstructorDeclarationNode extends INode, IClassBodyDeclarationNode {
    IModifiersNode getModifiers();

    ITypeParametersNode getOptionalTypeParameters();

    SourceToken<IdentifierToken> getIdentifier();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    DelimitedList<IFormalParameterNode, SourceToken<CommaSeparatorToken>> getOptionalFormalParameterList();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    IThrowsNode getOptionalThrows();

    IBlockNode getBlock();
  }

  public static interface IFieldDeclarationNode extends INode, IClassOrInterfaceMemberDeclarationNode {
    IModifiersNode getModifiers();

    ITypeNode getType();

    DelimitedList<IVariableDeclaratorNode, SourceToken<CommaSeparatorToken>> getVariableDeclaratorList();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public static interface IVariableDeclaratorNode extends INode {
  }

  public static interface IVariableDeclaratorIdAndAssignmentNode extends INode, IVariableDeclaratorNode {
    IVariableDeclaratorIdNode getVariableDeclaratorId();

    SourceToken<EqualsOperatorToken> getEqualsOperator();

    IVariableDeclaratorAssignmentNode getVariableDeclaratorAssignment();
  }

  public static interface IVariableDeclaratorAssignmentNode extends INode {
  }

  public static interface IVariableDeclaratorIdNode extends INode, IVariableDeclaratorNode {
    SourceToken<IdentifierToken> getIdentifier();

    List<IBracketPairNode> getBracketPairList();
  }

  public static interface IBracketPairNode extends INode {
    SourceToken<LeftBracketSeparatorToken> getLeftBracketSeparator();

    SourceToken<RightBracketSeparatorToken> getRightBracketSeparator();
  }

  public static interface IMethodDeclarationNode extends INode, IClassOrInterfaceMemberDeclarationNode {
    IModifiersNode getModifiers();

    ITypeParametersNode getOptionalTypeParameters();

    ITypeNode getType();

    SourceToken<IdentifierToken> getIdentifier();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    DelimitedList<IFormalParameterNode, SourceToken<CommaSeparatorToken>> getOptionalFormalParameterList();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    List<IBracketPairNode> getBracketPairList();

    IThrowsNode getOptionalThrows();

    IMethodBodyNode getMethodBody();
  }

  public static interface IMethodBodyNode extends INode {
  }

  public static interface IFormalParameterNode extends INode {
    IModifiersNode getModifiers();

    ITypeNode getType();

    SourceToken<EllipsisSeparatorToken> getOptionalEllipsisSeparator();

    IVariableDeclaratorIdNode getVariableDeclaratorId();
  }

  public static interface IThrowsNode extends INode {
    SourceToken<ThrowsKeywordToken> getThrowsKeyword();

    DelimitedList<IClassOrInterfaceTypeNode, SourceToken<CommaSeparatorToken>> getClassOrInterfaceTypeList();
  }

  public static interface ITypeParametersNode extends INode {
    SourceToken<LessThanOperatorToken> getLessThanOperator();

    DelimitedList<ITypeParameterNode, SourceToken<CommaSeparatorToken>> getTypeParameterList();

    SourceToken<GreaterThanOperatorToken> getGreaterThanOperator();
  }

  public static interface ITypeParameterNode extends INode {
    SourceToken<IdentifierToken> getIdentifier();

    ITypeBoundNode getOptionalTypeBound();
  }

  public static interface ITypeBoundNode extends INode {
    SourceToken<ExtendsKeywordToken> getExtendsKeyword();

    DelimitedList<IClassOrInterfaceTypeNode, SourceToken<BitwiseAndOperatorToken>> getClassOrInterfaceTypeList();
  }

  public static interface ITypeNode extends INode {
  }

  public static interface IReferenceTypeNode extends INode, ITypeArgumentNode, ITypeNode {
  }

  public static interface IPrimitiveArrayReferenceTypeNode extends INode, IReferenceTypeNode {
    IPrimitiveTypeNode getPrimitiveType();

    List<IBracketPairNode> getBracketPairList();
  }

  public static interface IClassOrInterfaceReferenceTypeNode extends INode, IReferenceTypeNode {
    IClassOrInterfaceTypeNode getClassOrInterfaceType();

    List<IBracketPairNode> getBracketPairList();
  }

  public static interface IClassOrInterfaceTypeNode extends INode, IArrayCreationTypeNode {
    DelimitedList<ISingleClassOrInterfaceTypeNode, SourceToken<DotSeparatorToken>> getSingleClassOrInterfaceTypeList();
  }

  public static interface ISingleClassOrInterfaceTypeNode extends INode {
    SourceToken<IdentifierToken> getIdentifier();

    ITypeArgumentsNode getOptionalTypeArguments();
  }

  public static interface ITypeArgumentsNode extends INode {
    SourceToken<LessThanOperatorToken> getLessThanOperator();

    DelimitedList<ITypeArgumentNode, SourceToken<CommaSeparatorToken>> getTypeArgumentList();

    SourceToken<GreaterThanOperatorToken> getGreaterThanOperator();
  }

  public static interface ITypeArgumentNode extends INode {
  }

  public static interface IWildcardTypeArgumentNode extends INode, ITypeArgumentNode {
  }

  public static interface IExtendsWildcardTypeArgumentNode extends INode, IWildcardTypeArgumentNode {
    SourceToken<QuestionMarkOperatorToken> getQuestionMarkOperator();

    SourceToken<ExtendsKeywordToken> getExtendsKeyword();

    IReferenceTypeNode getReferenceType();
  }

  public static interface ISuperWildcardTypeArgumentNode extends INode, IWildcardTypeArgumentNode {
    SourceToken<QuestionMarkOperatorToken> getQuestionMarkOperator();

    SourceToken<SuperKeywordToken> getSuperKeyword();

    IReferenceTypeNode getReferenceType();
  }

  public static interface IOpenWildcardTypeArgumentNode extends INode, IWildcardTypeArgumentNode {
    SourceToken<QuestionMarkOperatorToken> getQuestionMarkOperator();
  }

  public static interface INonWildcardTypeArgumentsNode extends INode {
    SourceToken<LessThanOperatorToken> getLessThanOperator();

    DelimitedList<IReferenceTypeNode, SourceToken<CommaSeparatorToken>> getReferenceTypeList();

    SourceToken<GreaterThanOperatorToken> getGreaterThanOperator();
  }

  public static interface IPrimitiveTypeNode extends INode, IArrayCreationTypeNode, ITypeNode {
  }

  public static interface IAnnotationNode extends INode, IElementValueNode, IModifierNode {
  }

  public static interface INormalAnnotationNode extends INode, IAnnotationNode {
    SourceToken<AtSeparatorToken> getAtSeparator();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    DelimitedList<IElementValuePairNode, SourceToken<CommaSeparatorToken>> getOptionalElementValuePairList();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();
  }

  public static interface IElementValuePairNode extends INode {
    SourceToken<IdentifierToken> getIdentifier();

    SourceToken<EqualsOperatorToken> getEqualsOperator();

    IElementValueNode getElementValue();
  }

  public static interface ISingleElementAnnotationNode extends INode, IAnnotationNode {
    SourceToken<AtSeparatorToken> getAtSeparator();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IElementValueNode getElementValue();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();
  }

  public static interface IMarkerAnnotationNode extends INode, IAnnotationNode {
    SourceToken<AtSeparatorToken> getAtSeparator();

    IQualifiedIdentifierNode getQualifiedIdentifier();
  }

  public static interface IElementValueNode extends INode {
  }

  public static interface IElementValueArrayInitializerNode extends INode, IElementValueNode {
    SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator();

    DelimitedList<IElementValueNode, SourceToken<CommaSeparatorToken>> getOptionalElementValueList();

    SourceToken<CommaSeparatorToken> getOptionalCommaSeparator();

    SourceToken<RightCurlySeparatorToken> getRightCurlySeparator();
  }

  public static interface IBlockNode extends INode, IClassBodyDeclarationNode, IStatementNode, IMethodBodyNode {
    SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator();

    List<IBlockStatementNode> getBlockStatementList();

    SourceToken<RightCurlySeparatorToken> getRightCurlySeparator();
  }

  public static interface IBlockStatementNode extends INode {
  }

  public static interface ILocalVariableDeclarationStatementNode extends INode, IBlockStatementNode {
    ILocalVariableDeclarationNode getLocalVariableDeclaration();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public static interface ILocalVariableDeclarationNode extends INode, IForInitializerNode {
    IModifiersNode getModifiers();

    ITypeNode getType();

    DelimitedList<IVariableDeclaratorNode, SourceToken<CommaSeparatorToken>> getVariableDeclaratorList();
  }

  public static interface IStatementNode extends INode, IBlockStatementNode {
  }

  public static interface IEmptyStatementNode extends INode, IStatementNode {
    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public static interface ILabeledStatementNode extends INode, IStatementNode {
    SourceToken<IdentifierToken> getIdentifier();

    SourceToken<ColonOperatorToken> getColonOperator();

    IStatementNode getStatement();
  }

  public static interface IExpressionStatementNode extends INode, IStatementNode {
    IExpressionNode getExpression();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public static interface IIfStatementNode extends INode, IStatementNode {
    SourceToken<IfKeywordToken> getIfKeyword();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    IStatementNode getStatement();

    IElseStatementNode getOptionalElseStatement();
  }

  public static interface IElseStatementNode extends INode {
    SourceToken<ElseKeywordToken> getElseKeyword();

    IStatementNode getStatement();
  }

  public static interface IAssertStatementNode extends INode, IStatementNode {
  }

  public static interface IMessageAssertStatementNode extends INode, IAssertStatementNode {
    SourceToken<AssertKeywordToken> getAssertKeyword();

    IExpressionNode getExpression();

    SourceToken<ColonOperatorToken> getColonOperator();

    IExpressionNode getExpression2();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public static interface ISimpleAssertStatementNode extends INode, IAssertStatementNode {
    SourceToken<AssertKeywordToken> getAssertKeyword();

    IExpressionNode getExpression();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public static interface ISwitchStatementNode extends INode, IStatementNode {
    SourceToken<SwitchKeywordToken> getSwitchKeyword();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator();

    List<ISwitchBlockStatementGroupNode> getSwitchBlockStatementGroupList();

    List<ISwitchLabelNode> getSwitchLabelList();

    SourceToken<RightCurlySeparatorToken> getRightCurlySeparator();
  }

  public static interface ISwitchBlockStatementGroupNode extends INode {
    List<ISwitchLabelNode> getSwitchLabelList();

    List<IBlockStatementNode> getBlockStatementList();
  }

  public static interface ISwitchLabelNode extends INode {
  }

  public static interface ICaseSwitchLabelNode extends INode, ISwitchLabelNode {
    SourceToken<CaseKeywordToken> getCaseKeyword();

    IExpressionNode getExpression();

    SourceToken<ColonOperatorToken> getColonOperator();
  }

  public static interface IDefaultSwitchLabelNode extends INode, ISwitchLabelNode {
    SourceToken<DefaultKeywordToken> getDefaultKeyword();

    SourceToken<ColonOperatorToken> getColonOperator();
  }

  public static interface IWhileStatementNode extends INode, IStatementNode {
    SourceToken<WhileKeywordToken> getWhileKeyword();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    IStatementNode getStatement();
  }

  public static interface IDoStatementNode extends INode, IStatementNode {
    SourceToken<DoKeywordToken> getDoKeyword();

    IStatementNode getStatement();

    SourceToken<WhileKeywordToken> getWhileKeyword();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public static interface IForStatementNode extends INode, IStatementNode {
  }

  public static interface IBasicForStatementNode extends INode, IForStatementNode {
    SourceToken<ForKeywordToken> getForKeyword();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IForInitializerNode getOptionalForInitializer();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();

    IExpressionNode getOptionalExpression();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator2();

    IDelimitedExpressionListNode getOptionalDelimitedExpressionList();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    IStatementNode getStatement();
  }

  public static interface IForInitializerNode extends INode {
  }

  public static interface IDelimitedExpressionListNode extends INode, IForInitializerNode {
    DelimitedList<IExpressionNode, SourceToken<CommaSeparatorToken>> getExpressionList();
  }

  public static interface IEnhancedForStatementNode extends INode, IForStatementNode {
    SourceToken<ForKeywordToken> getForKeyword();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IModifiersNode getModifiers();

    ITypeNode getType();

    SourceToken<IdentifierToken> getIdentifier();

    SourceToken<ColonOperatorToken> getColonOperator();

    IExpressionNode getExpression();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    IStatementNode getStatement();
  }

  public static interface IBreakStatementNode extends INode, IStatementNode {
    SourceToken<BreakKeywordToken> getBreakKeyword();

    SourceToken<IdentifierToken> getOptionalIdentifier();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public static interface IContinueStatementNode extends INode, IStatementNode {
    SourceToken<ContinueKeywordToken> getContinueKeyword();

    SourceToken<IdentifierToken> getOptionalIdentifier();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public static interface IReturnStatementNode extends INode, IStatementNode {
    SourceToken<ReturnKeywordToken> getReturnKeyword();

    IExpressionNode getOptionalExpression();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public static interface IThrowStatementNode extends INode, IStatementNode {
    SourceToken<ThrowKeywordToken> getThrowKeyword();

    IExpressionNode getOptionalExpression();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public static interface ISynchronizedStatementNode extends INode, IStatementNode {
    SourceToken<SynchronizedKeywordToken> getSynchronizedKeyword();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    IBlockNode getBlock();
  }

  public static interface ITryStatementNode extends INode, IStatementNode {
  }

  public static interface ITryStatementWithFinallyNode extends INode, ITryStatementNode {
    SourceToken<TryKeywordToken> getTryKeyword();

    IBlockNode getBlock();

    List<ICatchClauseNode> getCatchClauseList();

    SourceToken<FinallyKeywordToken> getFinallyKeyword();

    IBlockNode getBlock2();
  }

  public static interface ITryStatementWithoutFinallyNode extends INode, ITryStatementNode {
    SourceToken<TryKeywordToken> getTryKeyword();

    IBlockNode getBlock();

    List<ICatchClauseNode> getCatchClauseList();
  }

  public static interface ICatchClauseNode extends INode {
    SourceToken<CatchKeywordToken> getCatchKeyword();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IFormalParameterNode getFormalParameter();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    IBlockNode getBlock();
  }

  public static interface IExpressionNode
      extends INode, IElementValueNode, IVariableInitializerNode, IVariableDeclaratorAssignmentNode {
    DelimitedList<IExpression1Node, IAssignmentOperatorNode> getExpression1List();
  }

  public static interface IAssignmentOperatorNode extends INode {
  }

  public static interface IExpression1Node extends INode {
  }

  public static interface ITernaryExpressionNode extends INode, IExpression1Node {
    IExpression2Node getExpression2();

    SourceToken<QuestionMarkOperatorToken> getQuestionMarkOperator();

    IExpressionNode getExpression();

    SourceToken<ColonOperatorToken> getColonOperator();

    IExpression1Node getExpression1();
  }

  public static interface IExpression2Node extends INode, IExpression1Node {
  }

  public static interface IBinaryExpressionNode extends INode, IExpression2Node {
    IExpression3Node getExpression3();

    List<IBinaryExpressionRestNode> getBinaryExpressionRestList();
  }

  public static interface IBinaryExpressionRestNode extends INode {
  }

  public static interface IInfixOperatorBinaryExpressionRestNode extends INode, IBinaryExpressionRestNode {
    IInfixOperatorNode getInfixOperator();

    IExpression3Node getExpression3();
  }

  public static interface IInstanceofOperatorBinaryExpressionRestNode extends INode, IBinaryExpressionRestNode {
    SourceToken<InstanceofKeywordToken> getInstanceofKeyword();

    ITypeNode getType();
  }

  public static interface IInfixOperatorNode extends INode {
  }

  public static interface IUnsignedRightShiftNode extends INode, IInfixOperatorNode {
    SourceToken<GreaterThanOperatorToken> getGreaterThanOperator();

    SourceToken<GreaterThanOperatorToken> getGreaterThanOperator2();

    SourceToken<GreaterThanOperatorToken> getGreaterThanOperator3();
  }

  public static interface ISignedRightShiftNode extends INode, IInfixOperatorNode {
    SourceToken<GreaterThanOperatorToken> getGreaterThanOperator();

    SourceToken<GreaterThanOperatorToken> getGreaterThanOperator2();
  }

  public static interface IExpression3Node extends INode, IExpression2Node {
  }

  public static interface IPrefixExpressionNode extends INode, IExpression3Node {
    IPrefixOperatorNode getPrefixOperator();

    IExpression3Node getExpression3();
  }

  public static interface IPrefixOperatorNode extends INode {
  }

  public static interface IPossibleCastExpressionNode extends INode, IExpression3Node {
  }

  public static interface IPossibleCastExpression_TypeNode extends INode, IPossibleCastExpressionNode {
    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    ITypeNode getType();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    IExpression3Node getExpression3();
  }

  public static interface IPossibleCastExpression_ExpressionNode extends INode, IPossibleCastExpressionNode {
    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    IExpression3Node getExpression3();
  }

  public static interface IPrimaryExpressionNode extends INode, IExpression3Node {
    IValueExpressionNode getValueExpression();

    List<ISelectorNode> getSelectorList();

    IPostfixOperatorNode getOptionalPostfixOperator();
  }

  public static interface IPostfixOperatorNode extends INode {
  }

  public static interface IValueExpressionNode extends INode {
  }

  public static interface IClassAccessNode extends INode, IValueExpressionNode {
    ITypeNode getType();

    SourceToken<DotSeparatorToken> getDotSeparator();

    SourceToken<ClassKeywordToken> getClassKeyword();
  }

  public static interface ISelectorNode extends INode {
  }

  public static interface IDotSelectorNode extends INode, ISelectorNode {
    SourceToken<DotSeparatorToken> getDotSeparator();

    IValueExpressionNode getValueExpression();
  }

  public static interface IArraySelectorNode extends INode, ISelectorNode {
    SourceToken<LeftBracketSeparatorToken> getLeftBracketSeparator();

    IExpressionNode getExpression();

    SourceToken<RightBracketSeparatorToken> getRightBracketSeparator();
  }

  public static interface IParenthesizedExpressionNode extends INode, IValueExpressionNode {
    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();
  }

  public static interface IMethodInvocationNode extends INode, IValueExpressionNode {
    INonWildcardTypeArgumentsNode getOptionalNonWildcardTypeArguments();

    SourceToken<IdentifierToken> getIdentifier();

    IArgumentsNode getArguments();
  }

  public static interface IThisConstructorInvocationNode extends INode, IValueExpressionNode {
    SourceToken<ThisKeywordToken> getThisKeyword();

    IArgumentsNode getArguments();
  }

  public static interface ISuperConstructorInvocationNode extends INode, IValueExpressionNode {
    SourceToken<SuperKeywordToken> getSuperKeyword();

    IArgumentsNode getArguments();
  }

  public static interface ICreationExpressionNode extends INode, IValueExpressionNode {
  }

  public static interface IObjectCreationExpressionNode extends INode, ICreationExpressionNode {
    SourceToken<NewKeywordToken> getNewKeyword();

    INonWildcardTypeArgumentsNode getOptionalNonWildcardTypeArguments();

    IClassOrInterfaceTypeNode getClassOrInterfaceType();

    IArgumentsNode getArguments();

    IClassBodyNode getOptionalClassBody();
  }

  public static interface IArrayCreationExpressionNode extends INode, ICreationExpressionNode {
    SourceToken<NewKeywordToken> getNewKeyword();

    IArrayCreationTypeNode getArrayCreationType();

    List<IDimensionExpressionNode> getDimensionExpressionList();

    IArrayInitializerNode getOptionalArrayInitializer();
  }

  public static interface IArrayCreationTypeNode extends INode {
  }

  public static interface IDimensionExpressionNode extends INode {
    SourceToken<LeftBracketSeparatorToken> getLeftBracketSeparator();

    IExpressionNode getOptionalExpression();

    SourceToken<RightBracketSeparatorToken> getRightBracketSeparator();
  }

  public static interface IArrayInitializerNode
      extends INode, IVariableInitializerNode, IVariableDeclaratorAssignmentNode {
    SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator();

    DelimitedList<IVariableInitializerNode, SourceToken<CommaSeparatorToken>> getOptionalVariableInitializerList();

    SourceToken<RightCurlySeparatorToken> getRightCurlySeparator();
  }

  public static interface IVariableInitializerNode extends INode {
  }

  public static class CompilationUnitNode extends AbstractNode implements ICompilationUnitNode {
    private final IPackageDeclarationNode optionalPackageDeclaration;
    private final List<IImportDeclarationNode> importDeclarationList;
    private final List<ITypeDeclarationNode> typeDeclarationList;

    public CompilationUnitNode(
        IPackageDeclarationNode optionalPackageDeclaration,
        List<IImportDeclarationNode> importDeclarationList,
        List<ITypeDeclarationNode> typeDeclarationList) {
      this.optionalPackageDeclaration = optionalPackageDeclaration;
      this.importDeclarationList = importDeclarationList;
      this.typeDeclarationList = typeDeclarationList;
    }

    public IPackageDeclarationNode getOptionalPackageDeclaration() {
      return optionalPackageDeclaration;
    }

    public List<IImportDeclarationNode> getImportDeclarationList() {
      return importDeclarationList;
    }

    public List<ITypeDeclarationNode> getTypeDeclarationList() {
      return typeDeclarationList;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (optionalPackageDeclaration != null) {
        list.add(optionalPackageDeclaration);
      }
      if (importDeclarationList != null) {
        list.addAll(importDeclarationList);
      }
      if (typeDeclarationList != null) {
        list.addAll(typeDeclarationList);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ICompilationUnitNode)) { return false; }
      ICompilationUnitNode __node = (ICompilationUnitNode) __other;
      if (!equals(optionalPackageDeclaration, __node.getOptionalPackageDeclaration())) { return false; }
      if (!equals(importDeclarationList, __node.getImportDeclarationList())) { return false; }
      if (!equals(typeDeclarationList, __node.getTypeDeclarationList())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (optionalPackageDeclaration == null ? 0 : optionalPackageDeclaration.hashCode());
      hash = 31 * hash + (importDeclarationList == null ? 0 : importDeclarationList.hashCode());
      hash = 31 * hash + (typeDeclarationList == null ? 0 : typeDeclarationList.hashCode());
      return hash;
    }

    public String getName() {
      return "ICompilationUnitNode";
    }
  }

  public static class PackageDeclarationNode extends AbstractNode implements IPackageDeclarationNode {
    private final List<IAnnotationNode> annotationList;
    private final SourceToken<PackageKeywordToken> packageKeyword;
    private final IQualifiedIdentifierNode qualifiedIdentifier;
    private final SourceToken<SemicolonSeparatorToken> semicolonSeparator;

    public PackageDeclarationNode(
        List<IAnnotationNode> annotationList,
        SourceToken<PackageKeywordToken> packageKeyword,
        IQualifiedIdentifierNode qualifiedIdentifier,
        SourceToken<SemicolonSeparatorToken> semicolonSeparator) {
      this.annotationList = annotationList;
      this.packageKeyword = packageKeyword;
      this.qualifiedIdentifier = qualifiedIdentifier;
      this.semicolonSeparator = semicolonSeparator;
    }

    public List<IAnnotationNode> getAnnotationList() {
      return annotationList;
    }

    public SourceToken<PackageKeywordToken> getPackageKeyword() {
      return packageKeyword;
    }

    public IQualifiedIdentifierNode getQualifiedIdentifier() {
      return qualifiedIdentifier;
    }

    public SourceToken<SemicolonSeparatorToken> getSemicolonSeparator() {
      return semicolonSeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (annotationList != null) {
        list.addAll(annotationList);
      }
      if (packageKeyword != null) {
        list.add(packageKeyword);
      }
      if (qualifiedIdentifier != null) {
        list.add(qualifiedIdentifier);
      }
      if (semicolonSeparator != null) {
        list.add(semicolonSeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IPackageDeclarationNode)) { return false; }
      IPackageDeclarationNode __node = (IPackageDeclarationNode) __other;
      if (!equals(annotationList, __node.getAnnotationList())) { return false; }
      if (!equals(packageKeyword, __node.getPackageKeyword())) { return false; }
      if (!equals(qualifiedIdentifier, __node.getQualifiedIdentifier())) { return false; }
      if (!equals(semicolonSeparator, __node.getSemicolonSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (annotationList == null ? 0 : annotationList.hashCode());
      hash = 31 * hash + (packageKeyword == null ? 0 : packageKeyword.hashCode());
      hash = 31 * hash + (qualifiedIdentifier == null ? 0 : qualifiedIdentifier.hashCode());
      hash = 31 * hash + (semicolonSeparator == null ? 0 : semicolonSeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "IPackageDeclarationNode";
    }
  }

  public static class QualifiedIdentifierNode extends AbstractNode implements IQualifiedIdentifierNode {
    private final DelimitedList<SourceToken<IdentifierToken>, SourceToken<DotSeparatorToken>> identifierList;

    public QualifiedIdentifierNode(
        DelimitedList<SourceToken<IdentifierToken>, SourceToken<DotSeparatorToken>> identifierList) {
      this.identifierList = identifierList;
    }

    public DelimitedList<SourceToken<IdentifierToken>, SourceToken<DotSeparatorToken>> getIdentifierList() {
      return identifierList;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (identifierList != null) {
        identifierList.addTo(list);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IQualifiedIdentifierNode)) { return false; }
      IQualifiedIdentifierNode __node = (IQualifiedIdentifierNode) __other;
      if (!equals(identifierList, __node.getIdentifierList())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (identifierList == null ? 0 : identifierList.hashCode());
      return hash;
    }

    public String getName() {
      return "IQualifiedIdentifierNode";
    }
  }

  public static class SingleTypeImportDeclarationNode extends AbstractNode implements ISingleTypeImportDeclarationNode {
    private final SourceToken<ImportKeywordToken> importKeyword;
    private final IQualifiedIdentifierNode qualifiedIdentifier;
    private final SourceToken<SemicolonSeparatorToken> semicolonSeparator;

    public SingleTypeImportDeclarationNode(
        SourceToken<ImportKeywordToken> importKeyword,
        IQualifiedIdentifierNode qualifiedIdentifier,
        SourceToken<SemicolonSeparatorToken> semicolonSeparator) {
      this.importKeyword = importKeyword;
      this.qualifiedIdentifier = qualifiedIdentifier;
      this.semicolonSeparator = semicolonSeparator;
    }

    public SourceToken<ImportKeywordToken> getImportKeyword() {
      return importKeyword;
    }

    public IQualifiedIdentifierNode getQualifiedIdentifier() {
      return qualifiedIdentifier;
    }

    public SourceToken<SemicolonSeparatorToken> getSemicolonSeparator() {
      return semicolonSeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (importKeyword != null) {
        list.add(importKeyword);
      }
      if (qualifiedIdentifier != null) {
        list.add(qualifiedIdentifier);
      }
      if (semicolonSeparator != null) {
        list.add(semicolonSeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ISingleTypeImportDeclarationNode)) { return false; }
      ISingleTypeImportDeclarationNode __node = (ISingleTypeImportDeclarationNode) __other;
      if (!equals(importKeyword, __node.getImportKeyword())) { return false; }
      if (!equals(qualifiedIdentifier, __node.getQualifiedIdentifier())) { return false; }
      if (!equals(semicolonSeparator, __node.getSemicolonSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (importKeyword == null ? 0 : importKeyword.hashCode());
      hash = 31 * hash + (qualifiedIdentifier == null ? 0 : qualifiedIdentifier.hashCode());
      hash = 31 * hash + (semicolonSeparator == null ? 0 : semicolonSeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "ISingleTypeImportDeclarationNode";
    }
  }

  public static class TypeImportOnDemandDeclarationNode extends AbstractNode
      implements ITypeImportOnDemandDeclarationNode {
    private final SourceToken<ImportKeywordToken> importKeyword;
    private final IQualifiedIdentifierNode qualifiedIdentifier;
    private final SourceToken<DotSeparatorToken> dotSeparator;
    private final SourceToken<TimesOperatorToken> timesOperator;
    private final SourceToken<SemicolonSeparatorToken> semicolonSeparator;

    public TypeImportOnDemandDeclarationNode(
        SourceToken<ImportKeywordToken> importKeyword,
        IQualifiedIdentifierNode qualifiedIdentifier,
        SourceToken<DotSeparatorToken> dotSeparator,
        SourceToken<TimesOperatorToken> timesOperator,
        SourceToken<SemicolonSeparatorToken> semicolonSeparator) {
      this.importKeyword = importKeyword;
      this.qualifiedIdentifier = qualifiedIdentifier;
      this.dotSeparator = dotSeparator;
      this.timesOperator = timesOperator;
      this.semicolonSeparator = semicolonSeparator;
    }

    public SourceToken<ImportKeywordToken> getImportKeyword() {
      return importKeyword;
    }

    public IQualifiedIdentifierNode getQualifiedIdentifier() {
      return qualifiedIdentifier;
    }

    public SourceToken<DotSeparatorToken> getDotSeparator() {
      return dotSeparator;
    }

    public SourceToken<TimesOperatorToken> getTimesOperator() {
      return timesOperator;
    }

    public SourceToken<SemicolonSeparatorToken> getSemicolonSeparator() {
      return semicolonSeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (importKeyword != null) {
        list.add(importKeyword);
      }
      if (qualifiedIdentifier != null) {
        list.add(qualifiedIdentifier);
      }
      if (dotSeparator != null) {
        list.add(dotSeparator);
      }
      if (timesOperator != null) {
        list.add(timesOperator);
      }
      if (semicolonSeparator != null) {
        list.add(semicolonSeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ITypeImportOnDemandDeclarationNode)) { return false; }
      ITypeImportOnDemandDeclarationNode __node = (ITypeImportOnDemandDeclarationNode) __other;
      if (!equals(importKeyword, __node.getImportKeyword())) { return false; }
      if (!equals(qualifiedIdentifier, __node.getQualifiedIdentifier())) { return false; }
      if (!equals(dotSeparator, __node.getDotSeparator())) { return false; }
      if (!equals(timesOperator, __node.getTimesOperator())) { return false; }
      if (!equals(semicolonSeparator, __node.getSemicolonSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (importKeyword == null ? 0 : importKeyword.hashCode());
      hash = 31 * hash + (qualifiedIdentifier == null ? 0 : qualifiedIdentifier.hashCode());
      hash = 31 * hash + (dotSeparator == null ? 0 : dotSeparator.hashCode());
      hash = 31 * hash + (timesOperator == null ? 0 : timesOperator.hashCode());
      hash = 31 * hash + (semicolonSeparator == null ? 0 : semicolonSeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "ITypeImportOnDemandDeclarationNode";
    }
  }

  public static class SingleStaticImportDeclarationNode extends AbstractNode
      implements ISingleStaticImportDeclarationNode {
    private final SourceToken<ImportKeywordToken> importKeyword;
    private final SourceToken<StaticKeywordToken> staticKeyword;
    private final IQualifiedIdentifierNode qualifiedIdentifier;
    private final SourceToken<SemicolonSeparatorToken> semicolonSeparator;

    public SingleStaticImportDeclarationNode(
        SourceToken<ImportKeywordToken> importKeyword,
        SourceToken<StaticKeywordToken> staticKeyword,
        IQualifiedIdentifierNode qualifiedIdentifier,
        SourceToken<SemicolonSeparatorToken> semicolonSeparator) {
      this.importKeyword = importKeyword;
      this.staticKeyword = staticKeyword;
      this.qualifiedIdentifier = qualifiedIdentifier;
      this.semicolonSeparator = semicolonSeparator;
    }

    public SourceToken<ImportKeywordToken> getImportKeyword() {
      return importKeyword;
    }

    public SourceToken<StaticKeywordToken> getStaticKeyword() {
      return staticKeyword;
    }

    public IQualifiedIdentifierNode getQualifiedIdentifier() {
      return qualifiedIdentifier;
    }

    public SourceToken<SemicolonSeparatorToken> getSemicolonSeparator() {
      return semicolonSeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (importKeyword != null) {
        list.add(importKeyword);
      }
      if (staticKeyword != null) {
        list.add(staticKeyword);
      }
      if (qualifiedIdentifier != null) {
        list.add(qualifiedIdentifier);
      }
      if (semicolonSeparator != null) {
        list.add(semicolonSeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ISingleStaticImportDeclarationNode)) { return false; }
      ISingleStaticImportDeclarationNode __node = (ISingleStaticImportDeclarationNode) __other;
      if (!equals(importKeyword, __node.getImportKeyword())) { return false; }
      if (!equals(staticKeyword, __node.getStaticKeyword())) { return false; }
      if (!equals(qualifiedIdentifier, __node.getQualifiedIdentifier())) { return false; }
      if (!equals(semicolonSeparator, __node.getSemicolonSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (importKeyword == null ? 0 : importKeyword.hashCode());
      hash = 31 * hash + (staticKeyword == null ? 0 : staticKeyword.hashCode());
      hash = 31 * hash + (qualifiedIdentifier == null ? 0 : qualifiedIdentifier.hashCode());
      hash = 31 * hash + (semicolonSeparator == null ? 0 : semicolonSeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "ISingleStaticImportDeclarationNode";
    }
  }

  public static class StaticImportOnDemandDeclarationNode extends AbstractNode
      implements IStaticImportOnDemandDeclarationNode {
    private final SourceToken<ImportKeywordToken> importKeyword;
    private final SourceToken<StaticKeywordToken> staticKeyword;
    private final IQualifiedIdentifierNode qualifiedIdentifier;
    private final SourceToken<DotSeparatorToken> dotSeparator;
    private final SourceToken<TimesOperatorToken> timesOperator;
    private final SourceToken<SemicolonSeparatorToken> semicolonSeparator;

    public StaticImportOnDemandDeclarationNode(
        SourceToken<ImportKeywordToken> importKeyword,
        SourceToken<StaticKeywordToken> staticKeyword,
        IQualifiedIdentifierNode qualifiedIdentifier,
        SourceToken<DotSeparatorToken> dotSeparator,
        SourceToken<TimesOperatorToken> timesOperator,
        SourceToken<SemicolonSeparatorToken> semicolonSeparator) {
      this.importKeyword = importKeyword;
      this.staticKeyword = staticKeyword;
      this.qualifiedIdentifier = qualifiedIdentifier;
      this.dotSeparator = dotSeparator;
      this.timesOperator = timesOperator;
      this.semicolonSeparator = semicolonSeparator;
    }

    public SourceToken<ImportKeywordToken> getImportKeyword() {
      return importKeyword;
    }

    public SourceToken<StaticKeywordToken> getStaticKeyword() {
      return staticKeyword;
    }

    public IQualifiedIdentifierNode getQualifiedIdentifier() {
      return qualifiedIdentifier;
    }

    public SourceToken<DotSeparatorToken> getDotSeparator() {
      return dotSeparator;
    }

    public SourceToken<TimesOperatorToken> getTimesOperator() {
      return timesOperator;
    }

    public SourceToken<SemicolonSeparatorToken> getSemicolonSeparator() {
      return semicolonSeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (importKeyword != null) {
        list.add(importKeyword);
      }
      if (staticKeyword != null) {
        list.add(staticKeyword);
      }
      if (qualifiedIdentifier != null) {
        list.add(qualifiedIdentifier);
      }
      if (dotSeparator != null) {
        list.add(dotSeparator);
      }
      if (timesOperator != null) {
        list.add(timesOperator);
      }
      if (semicolonSeparator != null) {
        list.add(semicolonSeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IStaticImportOnDemandDeclarationNode)) { return false; }
      IStaticImportOnDemandDeclarationNode __node = (IStaticImportOnDemandDeclarationNode) __other;
      if (!equals(importKeyword, __node.getImportKeyword())) { return false; }
      if (!equals(staticKeyword, __node.getStaticKeyword())) { return false; }
      if (!equals(qualifiedIdentifier, __node.getQualifiedIdentifier())) { return false; }
      if (!equals(dotSeparator, __node.getDotSeparator())) { return false; }
      if (!equals(timesOperator, __node.getTimesOperator())) { return false; }
      if (!equals(semicolonSeparator, __node.getSemicolonSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (importKeyword == null ? 0 : importKeyword.hashCode());
      hash = 31 * hash + (staticKeyword == null ? 0 : staticKeyword.hashCode());
      hash = 31 * hash + (qualifiedIdentifier == null ? 0 : qualifiedIdentifier.hashCode());
      hash = 31 * hash + (dotSeparator == null ? 0 : dotSeparator.hashCode());
      hash = 31 * hash + (timesOperator == null ? 0 : timesOperator.hashCode());
      hash = 31 * hash + (semicolonSeparator == null ? 0 : semicolonSeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "IStaticImportOnDemandDeclarationNode";
    }
  }

  public static class NormalClassDeclarationNode extends AbstractNode implements INormalClassDeclarationNode {
    private final IModifiersNode modifiers;
    private final SourceToken<ClassKeywordToken> classKeyword;
    private final SourceToken<IdentifierToken> identifier;
    private final ITypeParametersNode optionalTypeParameters;
    private final ISuperNode optionalSuper;
    private final IInterfacesNode optionalInterfaces;
    private final IClassBodyNode classBody;

    public NormalClassDeclarationNode(
        IModifiersNode modifiers,
        SourceToken<ClassKeywordToken> classKeyword,
        SourceToken<IdentifierToken> identifier,
        ITypeParametersNode optionalTypeParameters,
        ISuperNode optionalSuper,
        IInterfacesNode optionalInterfaces,
        IClassBodyNode classBody) {
      this.modifiers = modifiers;
      this.classKeyword = classKeyword;
      this.identifier = identifier;
      this.optionalTypeParameters = optionalTypeParameters;
      this.optionalSuper = optionalSuper;
      this.optionalInterfaces = optionalInterfaces;
      this.classBody = classBody;
    }

    public IModifiersNode getModifiers() {
      return modifiers;
    }

    public SourceToken<ClassKeywordToken> getClassKeyword() {
      return classKeyword;
    }

    public SourceToken<IdentifierToken> getIdentifier() {
      return identifier;
    }

    public ITypeParametersNode getOptionalTypeParameters() {
      return optionalTypeParameters;
    }

    public ISuperNode getOptionalSuper() {
      return optionalSuper;
    }

    public IInterfacesNode getOptionalInterfaces() {
      return optionalInterfaces;
    }

    public IClassBodyNode getClassBody() {
      return classBody;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (modifiers != null) {
        list.add(modifiers);
      }
      if (classKeyword != null) {
        list.add(classKeyword);
      }
      if (identifier != null) {
        list.add(identifier);
      }
      if (optionalTypeParameters != null) {
        list.add(optionalTypeParameters);
      }
      if (optionalSuper != null) {
        list.add(optionalSuper);
      }
      if (optionalInterfaces != null) {
        list.add(optionalInterfaces);
      }
      if (classBody != null) {
        list.add(classBody);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof INormalClassDeclarationNode)) { return false; }
      INormalClassDeclarationNode __node = (INormalClassDeclarationNode) __other;
      if (!equals(modifiers, __node.getModifiers())) { return false; }
      if (!equals(classKeyword, __node.getClassKeyword())) { return false; }
      if (!equals(identifier, __node.getIdentifier())) { return false; }
      if (!equals(optionalTypeParameters, __node.getOptionalTypeParameters())) { return false; }
      if (!equals(optionalSuper, __node.getOptionalSuper())) { return false; }
      if (!equals(optionalInterfaces, __node.getOptionalInterfaces())) { return false; }
      if (!equals(classBody, __node.getClassBody())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (modifiers == null ? 0 : modifiers.hashCode());
      hash = 31 * hash + (classKeyword == null ? 0 : classKeyword.hashCode());
      hash = 31 * hash + (identifier == null ? 0 : identifier.hashCode());
      hash = 31 * hash + (optionalTypeParameters == null ? 0 : optionalTypeParameters.hashCode());
      hash = 31 * hash + (optionalSuper == null ? 0 : optionalSuper.hashCode());
      hash = 31 * hash + (optionalInterfaces == null ? 0 : optionalInterfaces.hashCode());
      hash = 31 * hash + (classBody == null ? 0 : classBody.hashCode());
      return hash;
    }

    public String getName() {
      return "INormalClassDeclarationNode";
    }
  }

  public static class ModifiersNode extends AbstractNode implements IModifiersNode {
    private final List<IModifierNode> modifierList;

    public ModifiersNode(
        List<IModifierNode> modifierList) {
      this.modifierList = modifierList;
    }

    public List<IModifierNode> getModifierList() {
      return modifierList;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (modifierList != null) {
        list.addAll(modifierList);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IModifiersNode)) { return false; }
      IModifiersNode __node = (IModifiersNode) __other;
      if (!equals(modifierList, __node.getModifierList())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (modifierList == null ? 0 : modifierList.hashCode());
      return hash;
    }

    public String getName() {
      return "IModifiersNode";
    }
  }

  public static class SuperNode extends AbstractNode implements ISuperNode {
    private final SourceToken<ExtendsKeywordToken> extendsKeyword;
    private final IClassOrInterfaceTypeNode classOrInterfaceType;

    public SuperNode(
        SourceToken<ExtendsKeywordToken> extendsKeyword,
        IClassOrInterfaceTypeNode classOrInterfaceType) {
      this.extendsKeyword = extendsKeyword;
      this.classOrInterfaceType = classOrInterfaceType;
    }

    public SourceToken<ExtendsKeywordToken> getExtendsKeyword() {
      return extendsKeyword;
    }

    public IClassOrInterfaceTypeNode getClassOrInterfaceType() {
      return classOrInterfaceType;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (extendsKeyword != null) {
        list.add(extendsKeyword);
      }
      if (classOrInterfaceType != null) {
        list.add(classOrInterfaceType);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ISuperNode)) { return false; }
      ISuperNode __node = (ISuperNode) __other;
      if (!equals(extendsKeyword, __node.getExtendsKeyword())) { return false; }
      if (!equals(classOrInterfaceType, __node.getClassOrInterfaceType())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (extendsKeyword == null ? 0 : extendsKeyword.hashCode());
      hash = 31 * hash + (classOrInterfaceType == null ? 0 : classOrInterfaceType.hashCode());
      return hash;
    }

    public String getName() {
      return "ISuperNode";
    }
  }

  public static class InterfacesNode extends AbstractNode implements IInterfacesNode {
    private final SourceToken<ImplementsKeywordToken> implementsKeyword;
    private final DelimitedList<IClassOrInterfaceTypeNode, SourceToken<CommaSeparatorToken>> classOrInterfaceTypeList;

    public InterfacesNode(
        SourceToken<ImplementsKeywordToken> implementsKeyword,
        DelimitedList<IClassOrInterfaceTypeNode, SourceToken<CommaSeparatorToken>> classOrInterfaceTypeList) {
      this.implementsKeyword = implementsKeyword;
      this.classOrInterfaceTypeList = classOrInterfaceTypeList;
    }

    public SourceToken<ImplementsKeywordToken> getImplementsKeyword() {
      return implementsKeyword;
    }

    public DelimitedList<IClassOrInterfaceTypeNode, SourceToken<CommaSeparatorToken>> getClassOrInterfaceTypeList() {
      return classOrInterfaceTypeList;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (implementsKeyword != null) {
        list.add(implementsKeyword);
      }
      if (classOrInterfaceTypeList != null) {
        classOrInterfaceTypeList.addTo(list);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IInterfacesNode)) { return false; }
      IInterfacesNode __node = (IInterfacesNode) __other;
      if (!equals(implementsKeyword, __node.getImplementsKeyword())) { return false; }
      if (!equals(classOrInterfaceTypeList, __node.getClassOrInterfaceTypeList())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (implementsKeyword == null ? 0 : implementsKeyword.hashCode());
      hash = 31 * hash + (classOrInterfaceTypeList == null ? 0 : classOrInterfaceTypeList.hashCode());
      return hash;
    }

    public String getName() {
      return "IInterfacesNode";
    }
  }

  public static class ClassBodyNode extends AbstractNode implements IClassBodyNode {
    private final SourceToken<LeftCurlySeparatorToken> leftCurlySeparator;
    private final List<IClassBodyDeclarationNode> classBodyDeclarationList;
    private final SourceToken<RightCurlySeparatorToken> rightCurlySeparator;

    public ClassBodyNode(
        SourceToken<LeftCurlySeparatorToken> leftCurlySeparator,
        List<IClassBodyDeclarationNode> classBodyDeclarationList,
        SourceToken<RightCurlySeparatorToken> rightCurlySeparator) {
      this.leftCurlySeparator = leftCurlySeparator;
      this.classBodyDeclarationList = classBodyDeclarationList;
      this.rightCurlySeparator = rightCurlySeparator;
    }

    public SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator() {
      return leftCurlySeparator;
    }

    public List<IClassBodyDeclarationNode> getClassBodyDeclarationList() {
      return classBodyDeclarationList;
    }

    public SourceToken<RightCurlySeparatorToken> getRightCurlySeparator() {
      return rightCurlySeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (leftCurlySeparator != null) {
        list.add(leftCurlySeparator);
      }
      if (classBodyDeclarationList != null) {
        list.addAll(classBodyDeclarationList);
      }
      if (rightCurlySeparator != null) {
        list.add(rightCurlySeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IClassBodyNode)) { return false; }
      IClassBodyNode __node = (IClassBodyNode) __other;
      if (!equals(leftCurlySeparator, __node.getLeftCurlySeparator())) { return false; }
      if (!equals(classBodyDeclarationList, __node.getClassBodyDeclarationList())) { return false; }
      if (!equals(rightCurlySeparator, __node.getRightCurlySeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (leftCurlySeparator == null ? 0 : leftCurlySeparator.hashCode());
      hash = 31 * hash + (classBodyDeclarationList == null ? 0 : classBodyDeclarationList.hashCode());
      hash = 31 * hash + (rightCurlySeparator == null ? 0 : rightCurlySeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "IClassBodyNode";
    }
  }

  public static class StaticInitializerNode extends AbstractNode implements IStaticInitializerNode {
    private final SourceToken<StaticKeywordToken> staticKeyword;
    private final IBlockNode block;

    public StaticInitializerNode(
        SourceToken<StaticKeywordToken> staticKeyword,
        IBlockNode block) {
      this.staticKeyword = staticKeyword;
      this.block = block;
    }

    public SourceToken<StaticKeywordToken> getStaticKeyword() {
      return staticKeyword;
    }

    public IBlockNode getBlock() {
      return block;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (staticKeyword != null) {
        list.add(staticKeyword);
      }
      if (block != null) {
        list.add(block);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IStaticInitializerNode)) { return false; }
      IStaticInitializerNode __node = (IStaticInitializerNode) __other;
      if (!equals(staticKeyword, __node.getStaticKeyword())) { return false; }
      if (!equals(block, __node.getBlock())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (staticKeyword == null ? 0 : staticKeyword.hashCode());
      hash = 31 * hash + (block == null ? 0 : block.hashCode());
      return hash;
    }

    public String getName() {
      return "IStaticInitializerNode";
    }
  }

  public static class NormalInterfaceDeclarationNode extends AbstractNode implements INormalInterfaceDeclarationNode {
    private final IModifiersNode modifiers;
    private final SourceToken<InterfaceKeywordToken> interfaceKeyword;
    private final SourceToken<IdentifierToken> identifier;
    private final ITypeParametersNode optionalTypeParameters;
    private final IExtendsInterfacesNode optionalExtendsInterfaces;
    private final IClassOrInterfaceBodyNode classOrInterfaceBody;

    public NormalInterfaceDeclarationNode(
        IModifiersNode modifiers,
        SourceToken<InterfaceKeywordToken> interfaceKeyword,
        SourceToken<IdentifierToken> identifier,
        ITypeParametersNode optionalTypeParameters,
        IExtendsInterfacesNode optionalExtendsInterfaces,
        IClassOrInterfaceBodyNode classOrInterfaceBody) {
      this.modifiers = modifiers;
      this.interfaceKeyword = interfaceKeyword;
      this.identifier = identifier;
      this.optionalTypeParameters = optionalTypeParameters;
      this.optionalExtendsInterfaces = optionalExtendsInterfaces;
      this.classOrInterfaceBody = classOrInterfaceBody;
    }

    public IModifiersNode getModifiers() {
      return modifiers;
    }

    public SourceToken<InterfaceKeywordToken> getInterfaceKeyword() {
      return interfaceKeyword;
    }

    public SourceToken<IdentifierToken> getIdentifier() {
      return identifier;
    }

    public ITypeParametersNode getOptionalTypeParameters() {
      return optionalTypeParameters;
    }

    public IExtendsInterfacesNode getOptionalExtendsInterfaces() {
      return optionalExtendsInterfaces;
    }

    public IClassOrInterfaceBodyNode getClassOrInterfaceBody() {
      return classOrInterfaceBody;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (modifiers != null) {
        list.add(modifiers);
      }
      if (interfaceKeyword != null) {
        list.add(interfaceKeyword);
      }
      if (identifier != null) {
        list.add(identifier);
      }
      if (optionalTypeParameters != null) {
        list.add(optionalTypeParameters);
      }
      if (optionalExtendsInterfaces != null) {
        list.add(optionalExtendsInterfaces);
      }
      if (classOrInterfaceBody != null) {
        list.add(classOrInterfaceBody);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof INormalInterfaceDeclarationNode)) { return false; }
      INormalInterfaceDeclarationNode __node = (INormalInterfaceDeclarationNode) __other;
      if (!equals(modifiers, __node.getModifiers())) { return false; }
      if (!equals(interfaceKeyword, __node.getInterfaceKeyword())) { return false; }
      if (!equals(identifier, __node.getIdentifier())) { return false; }
      if (!equals(optionalTypeParameters, __node.getOptionalTypeParameters())) { return false; }
      if (!equals(optionalExtendsInterfaces, __node.getOptionalExtendsInterfaces())) { return false; }
      if (!equals(classOrInterfaceBody, __node.getClassOrInterfaceBody())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (modifiers == null ? 0 : modifiers.hashCode());
      hash = 31 * hash + (interfaceKeyword == null ? 0 : interfaceKeyword.hashCode());
      hash = 31 * hash + (identifier == null ? 0 : identifier.hashCode());
      hash = 31 * hash + (optionalTypeParameters == null ? 0 : optionalTypeParameters.hashCode());
      hash = 31 * hash + (optionalExtendsInterfaces == null ? 0 : optionalExtendsInterfaces.hashCode());
      hash = 31 * hash + (classOrInterfaceBody == null ? 0 : classOrInterfaceBody.hashCode());
      return hash;
    }

    public String getName() {
      return "INormalInterfaceDeclarationNode";
    }
  }

  public static class ExtendsInterfacesNode extends AbstractNode implements IExtendsInterfacesNode {
    private final SourceToken<ExtendsKeywordToken> extendsKeyword;
    private final DelimitedList<IClassOrInterfaceTypeNode, SourceToken<CommaSeparatorToken>> classOrInterfaceTypeList;

    public ExtendsInterfacesNode(
        SourceToken<ExtendsKeywordToken> extendsKeyword,
        DelimitedList<IClassOrInterfaceTypeNode, SourceToken<CommaSeparatorToken>> classOrInterfaceTypeList) {
      this.extendsKeyword = extendsKeyword;
      this.classOrInterfaceTypeList = classOrInterfaceTypeList;
    }

    public SourceToken<ExtendsKeywordToken> getExtendsKeyword() {
      return extendsKeyword;
    }

    public DelimitedList<IClassOrInterfaceTypeNode, SourceToken<CommaSeparatorToken>> getClassOrInterfaceTypeList() {
      return classOrInterfaceTypeList;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (extendsKeyword != null) {
        list.add(extendsKeyword);
      }
      if (classOrInterfaceTypeList != null) {
        classOrInterfaceTypeList.addTo(list);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IExtendsInterfacesNode)) { return false; }
      IExtendsInterfacesNode __node = (IExtendsInterfacesNode) __other;
      if (!equals(extendsKeyword, __node.getExtendsKeyword())) { return false; }
      if (!equals(classOrInterfaceTypeList, __node.getClassOrInterfaceTypeList())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (extendsKeyword == null ? 0 : extendsKeyword.hashCode());
      hash = 31 * hash + (classOrInterfaceTypeList == null ? 0 : classOrInterfaceTypeList.hashCode());
      return hash;
    }

    public String getName() {
      return "IExtendsInterfacesNode";
    }
  }

  public static class ClassOrInterfaceBodyNode extends AbstractNode implements IClassOrInterfaceBodyNode {
    private final SourceToken<LeftCurlySeparatorToken> leftCurlySeparator;
    private final List<IClassOrInterfaceMemberDeclarationNode> classOrInterfaceMemberDeclarationList;
    private final SourceToken<RightCurlySeparatorToken> rightCurlySeparator;

    public ClassOrInterfaceBodyNode(
        SourceToken<LeftCurlySeparatorToken> leftCurlySeparator,
        List<IClassOrInterfaceMemberDeclarationNode> classOrInterfaceMemberDeclarationList,
        SourceToken<RightCurlySeparatorToken> rightCurlySeparator) {
      this.leftCurlySeparator = leftCurlySeparator;
      this.classOrInterfaceMemberDeclarationList = classOrInterfaceMemberDeclarationList;
      this.rightCurlySeparator = rightCurlySeparator;
    }

    public SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator() {
      return leftCurlySeparator;
    }

    public List<IClassOrInterfaceMemberDeclarationNode> getClassOrInterfaceMemberDeclarationList() {
      return classOrInterfaceMemberDeclarationList;
    }

    public SourceToken<RightCurlySeparatorToken> getRightCurlySeparator() {
      return rightCurlySeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (leftCurlySeparator != null) {
        list.add(leftCurlySeparator);
      }
      if (classOrInterfaceMemberDeclarationList != null) {
        list.addAll(classOrInterfaceMemberDeclarationList);
      }
      if (rightCurlySeparator != null) {
        list.add(rightCurlySeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IClassOrInterfaceBodyNode)) { return false; }
      IClassOrInterfaceBodyNode __node = (IClassOrInterfaceBodyNode) __other;
      if (!equals(leftCurlySeparator, __node.getLeftCurlySeparator())) { return false; }
      if (!equals(classOrInterfaceMemberDeclarationList, __node.getClassOrInterfaceMemberDeclarationList())) {
        return false;
      }
      if (!equals(rightCurlySeparator, __node.getRightCurlySeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (leftCurlySeparator == null ? 0 : leftCurlySeparator.hashCode());
      hash = 31 * hash +
             (classOrInterfaceMemberDeclarationList == null ? 0 : classOrInterfaceMemberDeclarationList.hashCode());
      hash = 31 * hash + (rightCurlySeparator == null ? 0 : rightCurlySeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "IClassOrInterfaceBodyNode";
    }
  }

  public static class EnumDeclarationNode extends AbstractNode implements IEnumDeclarationNode {
    private final IModifiersNode modifiers;
    private final SourceToken<EnumKeywordToken> enumKeyword;
    private final SourceToken<IdentifierToken> identifier;
    private final IInterfacesNode optionalInterfaces;
    private final IEnumBodyNode enumBody;

    public EnumDeclarationNode(
        IModifiersNode modifiers,
        SourceToken<EnumKeywordToken> enumKeyword,
        SourceToken<IdentifierToken> identifier,
        IInterfacesNode optionalInterfaces,
        IEnumBodyNode enumBody) {
      this.modifiers = modifiers;
      this.enumKeyword = enumKeyword;
      this.identifier = identifier;
      this.optionalInterfaces = optionalInterfaces;
      this.enumBody = enumBody;
    }

    public IModifiersNode getModifiers() {
      return modifiers;
    }

    public SourceToken<EnumKeywordToken> getEnumKeyword() {
      return enumKeyword;
    }

    public SourceToken<IdentifierToken> getIdentifier() {
      return identifier;
    }

    public IInterfacesNode getOptionalInterfaces() {
      return optionalInterfaces;
    }

    public IEnumBodyNode getEnumBody() {
      return enumBody;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (modifiers != null) {
        list.add(modifiers);
      }
      if (enumKeyword != null) {
        list.add(enumKeyword);
      }
      if (identifier != null) {
        list.add(identifier);
      }
      if (optionalInterfaces != null) {
        list.add(optionalInterfaces);
      }
      if (enumBody != null) {
        list.add(enumBody);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IEnumDeclarationNode)) { return false; }
      IEnumDeclarationNode __node = (IEnumDeclarationNode) __other;
      if (!equals(modifiers, __node.getModifiers())) { return false; }
      if (!equals(enumKeyword, __node.getEnumKeyword())) { return false; }
      if (!equals(identifier, __node.getIdentifier())) { return false; }
      if (!equals(optionalInterfaces, __node.getOptionalInterfaces())) { return false; }
      if (!equals(enumBody, __node.getEnumBody())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (modifiers == null ? 0 : modifiers.hashCode());
      hash = 31 * hash + (enumKeyword == null ? 0 : enumKeyword.hashCode());
      hash = 31 * hash + (identifier == null ? 0 : identifier.hashCode());
      hash = 31 * hash + (optionalInterfaces == null ? 0 : optionalInterfaces.hashCode());
      hash = 31 * hash + (enumBody == null ? 0 : enumBody.hashCode());
      return hash;
    }

    public String getName() {
      return "IEnumDeclarationNode";
    }
  }

  public static class EnumBodyNode extends AbstractNode implements IEnumBodyNode {
    private final SourceToken<LeftCurlySeparatorToken> leftCurlySeparator;
    private final DelimitedList<IEnumConstantNode, SourceToken<CommaSeparatorToken>> optionalEnumConstantList;
    private final SourceToken<SemicolonSeparatorToken> optionalSemicolonSeparator;
    private final List<IClassBodyDeclarationNode> classBodyDeclarationList;
    private final SourceToken<RightCurlySeparatorToken> rightCurlySeparator;

    public EnumBodyNode(
        SourceToken<LeftCurlySeparatorToken> leftCurlySeparator,
        DelimitedList<IEnumConstantNode, SourceToken<CommaSeparatorToken>> optionalEnumConstantList,
        SourceToken<SemicolonSeparatorToken> optionalSemicolonSeparator,
        List<IClassBodyDeclarationNode> classBodyDeclarationList,
        SourceToken<RightCurlySeparatorToken> rightCurlySeparator) {
      this.leftCurlySeparator = leftCurlySeparator;
      this.optionalEnumConstantList = optionalEnumConstantList;
      this.optionalSemicolonSeparator = optionalSemicolonSeparator;
      this.classBodyDeclarationList = classBodyDeclarationList;
      this.rightCurlySeparator = rightCurlySeparator;
    }

    public SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator() {
      return leftCurlySeparator;
    }

    public DelimitedList<IEnumConstantNode, SourceToken<CommaSeparatorToken>> getOptionalEnumConstantList() {
      return optionalEnumConstantList;
    }

    public SourceToken<SemicolonSeparatorToken> getOptionalSemicolonSeparator() {
      return optionalSemicolonSeparator;
    }

    public List<IClassBodyDeclarationNode> getClassBodyDeclarationList() {
      return classBodyDeclarationList;
    }

    public SourceToken<RightCurlySeparatorToken> getRightCurlySeparator() {
      return rightCurlySeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (leftCurlySeparator != null) {
        list.add(leftCurlySeparator);
      }
      if (optionalEnumConstantList != null) {
        optionalEnumConstantList.addTo(list);
      }
      if (optionalSemicolonSeparator != null) {
        list.add(optionalSemicolonSeparator);
      }
      if (classBodyDeclarationList != null) {
        list.addAll(classBodyDeclarationList);
      }
      if (rightCurlySeparator != null) {
        list.add(rightCurlySeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IEnumBodyNode)) { return false; }
      IEnumBodyNode __node = (IEnumBodyNode) __other;
      if (!equals(leftCurlySeparator, __node.getLeftCurlySeparator())) { return false; }
      if (!equals(optionalEnumConstantList, __node.getOptionalEnumConstantList())) { return false; }
      if (!equals(optionalSemicolonSeparator, __node.getOptionalSemicolonSeparator())) { return false; }
      if (!equals(classBodyDeclarationList, __node.getClassBodyDeclarationList())) { return false; }
      if (!equals(rightCurlySeparator, __node.getRightCurlySeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (leftCurlySeparator == null ? 0 : leftCurlySeparator.hashCode());
      hash = 31 * hash + (optionalEnumConstantList == null ? 0 : optionalEnumConstantList.hashCode());
      hash = 31 * hash + (optionalSemicolonSeparator == null ? 0 : optionalSemicolonSeparator.hashCode());
      hash = 31 * hash + (classBodyDeclarationList == null ? 0 : classBodyDeclarationList.hashCode());
      hash = 31 * hash + (rightCurlySeparator == null ? 0 : rightCurlySeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "IEnumBodyNode";
    }
  }

  public static class EnumConstantNode extends AbstractNode implements IEnumConstantNode {
    private final List<IAnnotationNode> annotationList;
    private final SourceToken<IdentifierToken> identifier;
    private final IArgumentsNode optionalArguments;
    private final IClassOrInterfaceBodyNode optionalClassOrInterfaceBody;

    public EnumConstantNode(
        List<IAnnotationNode> annotationList,
        SourceToken<IdentifierToken> identifier,
        IArgumentsNode optionalArguments,
        IClassOrInterfaceBodyNode optionalClassOrInterfaceBody) {
      this.annotationList = annotationList;
      this.identifier = identifier;
      this.optionalArguments = optionalArguments;
      this.optionalClassOrInterfaceBody = optionalClassOrInterfaceBody;
    }

    public List<IAnnotationNode> getAnnotationList() {
      return annotationList;
    }

    public SourceToken<IdentifierToken> getIdentifier() {
      return identifier;
    }

    public IArgumentsNode getOptionalArguments() {
      return optionalArguments;
    }

    public IClassOrInterfaceBodyNode getOptionalClassOrInterfaceBody() {
      return optionalClassOrInterfaceBody;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (annotationList != null) {
        list.addAll(annotationList);
      }
      if (identifier != null) {
        list.add(identifier);
      }
      if (optionalArguments != null) {
        list.add(optionalArguments);
      }
      if (optionalClassOrInterfaceBody != null) {
        list.add(optionalClassOrInterfaceBody);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IEnumConstantNode)) { return false; }
      IEnumConstantNode __node = (IEnumConstantNode) __other;
      if (!equals(annotationList, __node.getAnnotationList())) { return false; }
      if (!equals(identifier, __node.getIdentifier())) { return false; }
      if (!equals(optionalArguments, __node.getOptionalArguments())) { return false; }
      if (!equals(optionalClassOrInterfaceBody, __node.getOptionalClassOrInterfaceBody())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (annotationList == null ? 0 : annotationList.hashCode());
      hash = 31 * hash + (identifier == null ? 0 : identifier.hashCode());
      hash = 31 * hash + (optionalArguments == null ? 0 : optionalArguments.hashCode());
      hash = 31 * hash + (optionalClassOrInterfaceBody == null ? 0 : optionalClassOrInterfaceBody.hashCode());
      return hash;
    }

    public String getName() {
      return "IEnumConstantNode";
    }
  }

  public static class ArgumentsNode extends AbstractNode implements IArgumentsNode {
    private final SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator;
    private final IDelimitedExpressionListNode optionalDelimitedExpressionList;
    private final SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator;

    public ArgumentsNode(
        SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator,
        IDelimitedExpressionListNode optionalDelimitedExpressionList,
        SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator) {
      this.leftParenthesisSeparator = leftParenthesisSeparator;
      this.optionalDelimitedExpressionList = optionalDelimitedExpressionList;
      this.rightParenthesisSeparator = rightParenthesisSeparator;
    }

    public SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator() {
      return leftParenthesisSeparator;
    }

    public IDelimitedExpressionListNode getOptionalDelimitedExpressionList() {
      return optionalDelimitedExpressionList;
    }

    public SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator() {
      return rightParenthesisSeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (leftParenthesisSeparator != null) {
        list.add(leftParenthesisSeparator);
      }
      if (optionalDelimitedExpressionList != null) {
        list.add(optionalDelimitedExpressionList);
      }
      if (rightParenthesisSeparator != null) {
        list.add(rightParenthesisSeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IArgumentsNode)) { return false; }
      IArgumentsNode __node = (IArgumentsNode) __other;
      if (!equals(leftParenthesisSeparator, __node.getLeftParenthesisSeparator())) { return false; }
      if (!equals(optionalDelimitedExpressionList, __node.getOptionalDelimitedExpressionList())) { return false; }
      if (!equals(rightParenthesisSeparator, __node.getRightParenthesisSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (leftParenthesisSeparator == null ? 0 : leftParenthesisSeparator.hashCode());
      hash = 31 * hash + (optionalDelimitedExpressionList == null ? 0 : optionalDelimitedExpressionList.hashCode());
      hash = 31 * hash + (rightParenthesisSeparator == null ? 0 : rightParenthesisSeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "IArgumentsNode";
    }
  }

  public static class AnnotationDeclarationNode extends AbstractNode implements IAnnotationDeclarationNode {
    private final IModifiersNode modifiers;
    private final SourceToken<AtSeparatorToken> atSeparator;
    private final SourceToken<InterfaceKeywordToken> interfaceKeyword;
    private final SourceToken<IdentifierToken> identifier;
    private final IAnnotationBodyNode annotationBody;

    public AnnotationDeclarationNode(
        IModifiersNode modifiers,
        SourceToken<AtSeparatorToken> atSeparator,
        SourceToken<InterfaceKeywordToken> interfaceKeyword,
        SourceToken<IdentifierToken> identifier,
        IAnnotationBodyNode annotationBody) {
      this.modifiers = modifiers;
      this.atSeparator = atSeparator;
      this.interfaceKeyword = interfaceKeyword;
      this.identifier = identifier;
      this.annotationBody = annotationBody;
    }

    public IModifiersNode getModifiers() {
      return modifiers;
    }

    public SourceToken<AtSeparatorToken> getAtSeparator() {
      return atSeparator;
    }

    public SourceToken<InterfaceKeywordToken> getInterfaceKeyword() {
      return interfaceKeyword;
    }

    public SourceToken<IdentifierToken> getIdentifier() {
      return identifier;
    }

    public IAnnotationBodyNode getAnnotationBody() {
      return annotationBody;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (modifiers != null) {
        list.add(modifiers);
      }
      if (atSeparator != null) {
        list.add(atSeparator);
      }
      if (interfaceKeyword != null) {
        list.add(interfaceKeyword);
      }
      if (identifier != null) {
        list.add(identifier);
      }
      if (annotationBody != null) {
        list.add(annotationBody);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IAnnotationDeclarationNode)) { return false; }
      IAnnotationDeclarationNode __node = (IAnnotationDeclarationNode) __other;
      if (!equals(modifiers, __node.getModifiers())) { return false; }
      if (!equals(atSeparator, __node.getAtSeparator())) { return false; }
      if (!equals(interfaceKeyword, __node.getInterfaceKeyword())) { return false; }
      if (!equals(identifier, __node.getIdentifier())) { return false; }
      if (!equals(annotationBody, __node.getAnnotationBody())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (modifiers == null ? 0 : modifiers.hashCode());
      hash = 31 * hash + (atSeparator == null ? 0 : atSeparator.hashCode());
      hash = 31 * hash + (interfaceKeyword == null ? 0 : interfaceKeyword.hashCode());
      hash = 31 * hash + (identifier == null ? 0 : identifier.hashCode());
      hash = 31 * hash + (annotationBody == null ? 0 : annotationBody.hashCode());
      return hash;
    }

    public String getName() {
      return "IAnnotationDeclarationNode";
    }
  }

  public static class AnnotationBodyNode extends AbstractNode implements IAnnotationBodyNode {
    private final SourceToken<LeftCurlySeparatorToken> leftCurlySeparator;
    private final List<IAnnotationElementDeclarationNode> annotationElementDeclarationList;
    private final SourceToken<RightCurlySeparatorToken> rightCurlySeparator;

    public AnnotationBodyNode(
        SourceToken<LeftCurlySeparatorToken> leftCurlySeparator,
        List<IAnnotationElementDeclarationNode> annotationElementDeclarationList,
        SourceToken<RightCurlySeparatorToken> rightCurlySeparator) {
      this.leftCurlySeparator = leftCurlySeparator;
      this.annotationElementDeclarationList = annotationElementDeclarationList;
      this.rightCurlySeparator = rightCurlySeparator;
    }

    public SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator() {
      return leftCurlySeparator;
    }

    public List<IAnnotationElementDeclarationNode> getAnnotationElementDeclarationList() {
      return annotationElementDeclarationList;
    }

    public SourceToken<RightCurlySeparatorToken> getRightCurlySeparator() {
      return rightCurlySeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (leftCurlySeparator != null) {
        list.add(leftCurlySeparator);
      }
      if (annotationElementDeclarationList != null) {
        list.addAll(annotationElementDeclarationList);
      }
      if (rightCurlySeparator != null) {
        list.add(rightCurlySeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IAnnotationBodyNode)) { return false; }
      IAnnotationBodyNode __node = (IAnnotationBodyNode) __other;
      if (!equals(leftCurlySeparator, __node.getLeftCurlySeparator())) { return false; }
      if (!equals(annotationElementDeclarationList, __node.getAnnotationElementDeclarationList())) { return false; }
      if (!equals(rightCurlySeparator, __node.getRightCurlySeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (leftCurlySeparator == null ? 0 : leftCurlySeparator.hashCode());
      hash = 31 * hash + (annotationElementDeclarationList == null ? 0 : annotationElementDeclarationList.hashCode());
      hash = 31 * hash + (rightCurlySeparator == null ? 0 : rightCurlySeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "IAnnotationBodyNode";
    }
  }

  public static class AnnotationDefaultDeclarationNode extends AbstractNode
      implements IAnnotationDefaultDeclarationNode {
    private final IModifiersNode modifiers;
    private final ITypeNode type;
    private final SourceToken<IdentifierToken> identifier;
    private final SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator;
    private final SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator;
    private final SourceToken<DefaultKeywordToken> defaultKeyword;
    private final IElementValueNode elementValue;

    public AnnotationDefaultDeclarationNode(
        IModifiersNode modifiers,
        ITypeNode type,
        SourceToken<IdentifierToken> identifier,
        SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator,
        SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator,
        SourceToken<DefaultKeywordToken> defaultKeyword,
        IElementValueNode elementValue) {
      this.modifiers = modifiers;
      this.type = type;
      this.identifier = identifier;
      this.leftParenthesisSeparator = leftParenthesisSeparator;
      this.rightParenthesisSeparator = rightParenthesisSeparator;
      this.defaultKeyword = defaultKeyword;
      this.elementValue = elementValue;
    }

    public IModifiersNode getModifiers() {
      return modifiers;
    }

    public ITypeNode getType() {
      return type;
    }

    public SourceToken<IdentifierToken> getIdentifier() {
      return identifier;
    }

    public SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator() {
      return leftParenthesisSeparator;
    }

    public SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator() {
      return rightParenthesisSeparator;
    }

    public SourceToken<DefaultKeywordToken> getDefaultKeyword() {
      return defaultKeyword;
    }

    public IElementValueNode getElementValue() {
      return elementValue;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (modifiers != null) {
        list.add(modifiers);
      }
      if (type != null) {
        list.add(type);
      }
      if (identifier != null) {
        list.add(identifier);
      }
      if (leftParenthesisSeparator != null) {
        list.add(leftParenthesisSeparator);
      }
      if (rightParenthesisSeparator != null) {
        list.add(rightParenthesisSeparator);
      }
      if (defaultKeyword != null) {
        list.add(defaultKeyword);
      }
      if (elementValue != null) {
        list.add(elementValue);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IAnnotationDefaultDeclarationNode)) { return false; }
      IAnnotationDefaultDeclarationNode __node = (IAnnotationDefaultDeclarationNode) __other;
      if (!equals(modifiers, __node.getModifiers())) { return false; }
      if (!equals(type, __node.getType())) { return false; }
      if (!equals(identifier, __node.getIdentifier())) { return false; }
      if (!equals(leftParenthesisSeparator, __node.getLeftParenthesisSeparator())) { return false; }
      if (!equals(rightParenthesisSeparator, __node.getRightParenthesisSeparator())) { return false; }
      if (!equals(defaultKeyword, __node.getDefaultKeyword())) { return false; }
      if (!equals(elementValue, __node.getElementValue())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (modifiers == null ? 0 : modifiers.hashCode());
      hash = 31 * hash + (type == null ? 0 : type.hashCode());
      hash = 31 * hash + (identifier == null ? 0 : identifier.hashCode());
      hash = 31 * hash + (leftParenthesisSeparator == null ? 0 : leftParenthesisSeparator.hashCode());
      hash = 31 * hash + (rightParenthesisSeparator == null ? 0 : rightParenthesisSeparator.hashCode());
      hash = 31 * hash + (defaultKeyword == null ? 0 : defaultKeyword.hashCode());
      hash = 31 * hash + (elementValue == null ? 0 : elementValue.hashCode());
      return hash;
    }

    public String getName() {
      return "IAnnotationDefaultDeclarationNode";
    }
  }

  public static class ConstructorDeclarationNode extends AbstractNode implements IConstructorDeclarationNode {
    private final IModifiersNode modifiers;
    private final ITypeParametersNode optionalTypeParameters;
    private final SourceToken<IdentifierToken> identifier;
    private final SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator;
    private final DelimitedList<IFormalParameterNode, SourceToken<CommaSeparatorToken>> optionalFormalParameterList;
    private final SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator;
    private final IThrowsNode optionalThrows;
    private final IBlockNode block;

    public ConstructorDeclarationNode(
        IModifiersNode modifiers,
        ITypeParametersNode optionalTypeParameters,
        SourceToken<IdentifierToken> identifier,
        SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator,
        DelimitedList<IFormalParameterNode, SourceToken<CommaSeparatorToken>> optionalFormalParameterList,
        SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator,
        IThrowsNode optionalThrows,
        IBlockNode block) {
      this.modifiers = modifiers;
      this.optionalTypeParameters = optionalTypeParameters;
      this.identifier = identifier;
      this.leftParenthesisSeparator = leftParenthesisSeparator;
      this.optionalFormalParameterList = optionalFormalParameterList;
      this.rightParenthesisSeparator = rightParenthesisSeparator;
      this.optionalThrows = optionalThrows;
      this.block = block;
    }

    public IModifiersNode getModifiers() {
      return modifiers;
    }

    public ITypeParametersNode getOptionalTypeParameters() {
      return optionalTypeParameters;
    }

    public SourceToken<IdentifierToken> getIdentifier() {
      return identifier;
    }

    public SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator() {
      return leftParenthesisSeparator;
    }

    public DelimitedList<IFormalParameterNode, SourceToken<CommaSeparatorToken>> getOptionalFormalParameterList() {
      return optionalFormalParameterList;
    }

    public SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator() {
      return rightParenthesisSeparator;
    }

    public IThrowsNode getOptionalThrows() {
      return optionalThrows;
    }

    public IBlockNode getBlock() {
      return block;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (modifiers != null) {
        list.add(modifiers);
      }
      if (optionalTypeParameters != null) {
        list.add(optionalTypeParameters);
      }
      if (identifier != null) {
        list.add(identifier);
      }
      if (leftParenthesisSeparator != null) {
        list.add(leftParenthesisSeparator);
      }
      if (optionalFormalParameterList != null) {
        optionalFormalParameterList.addTo(list);
      }
      if (rightParenthesisSeparator != null) {
        list.add(rightParenthesisSeparator);
      }
      if (optionalThrows != null) {
        list.add(optionalThrows);
      }
      if (block != null) {
        list.add(block);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IConstructorDeclarationNode)) { return false; }
      IConstructorDeclarationNode __node = (IConstructorDeclarationNode) __other;
      if (!equals(modifiers, __node.getModifiers())) { return false; }
      if (!equals(optionalTypeParameters, __node.getOptionalTypeParameters())) { return false; }
      if (!equals(identifier, __node.getIdentifier())) { return false; }
      if (!equals(leftParenthesisSeparator, __node.getLeftParenthesisSeparator())) { return false; }
      if (!equals(optionalFormalParameterList, __node.getOptionalFormalParameterList())) { return false; }
      if (!equals(rightParenthesisSeparator, __node.getRightParenthesisSeparator())) { return false; }
      if (!equals(optionalThrows, __node.getOptionalThrows())) { return false; }
      if (!equals(block, __node.getBlock())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (modifiers == null ? 0 : modifiers.hashCode());
      hash = 31 * hash + (optionalTypeParameters == null ? 0 : optionalTypeParameters.hashCode());
      hash = 31 * hash + (identifier == null ? 0 : identifier.hashCode());
      hash = 31 * hash + (leftParenthesisSeparator == null ? 0 : leftParenthesisSeparator.hashCode());
      hash = 31 * hash + (optionalFormalParameterList == null ? 0 : optionalFormalParameterList.hashCode());
      hash = 31 * hash + (rightParenthesisSeparator == null ? 0 : rightParenthesisSeparator.hashCode());
      hash = 31 * hash + (optionalThrows == null ? 0 : optionalThrows.hashCode());
      hash = 31 * hash + (block == null ? 0 : block.hashCode());
      return hash;
    }

    public String getName() {
      return "IConstructorDeclarationNode";
    }
  }

  public static class FieldDeclarationNode extends AbstractNode implements IFieldDeclarationNode {
    private final IModifiersNode modifiers;
    private final ITypeNode type;
    private final DelimitedList<IVariableDeclaratorNode, SourceToken<CommaSeparatorToken>> variableDeclaratorList;
    private final SourceToken<SemicolonSeparatorToken> semicolonSeparator;

    public FieldDeclarationNode(
        IModifiersNode modifiers,
        ITypeNode type,
        DelimitedList<IVariableDeclaratorNode, SourceToken<CommaSeparatorToken>> variableDeclaratorList,
        SourceToken<SemicolonSeparatorToken> semicolonSeparator) {
      this.modifiers = modifiers;
      this.type = type;
      this.variableDeclaratorList = variableDeclaratorList;
      this.semicolonSeparator = semicolonSeparator;
    }

    public IModifiersNode getModifiers() {
      return modifiers;
    }

    public ITypeNode getType() {
      return type;
    }

    public DelimitedList<IVariableDeclaratorNode, SourceToken<CommaSeparatorToken>> getVariableDeclaratorList() {
      return variableDeclaratorList;
    }

    public SourceToken<SemicolonSeparatorToken> getSemicolonSeparator() {
      return semicolonSeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (modifiers != null) {
        list.add(modifiers);
      }
      if (type != null) {
        list.add(type);
      }
      if (variableDeclaratorList != null) {
        variableDeclaratorList.addTo(list);
      }
      if (semicolonSeparator != null) {
        list.add(semicolonSeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IFieldDeclarationNode)) { return false; }
      IFieldDeclarationNode __node = (IFieldDeclarationNode) __other;
      if (!equals(modifiers, __node.getModifiers())) { return false; }
      if (!equals(type, __node.getType())) { return false; }
      if (!equals(variableDeclaratorList, __node.getVariableDeclaratorList())) { return false; }
      if (!equals(semicolonSeparator, __node.getSemicolonSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (modifiers == null ? 0 : modifiers.hashCode());
      hash = 31 * hash + (type == null ? 0 : type.hashCode());
      hash = 31 * hash + (variableDeclaratorList == null ? 0 : variableDeclaratorList.hashCode());
      hash = 31 * hash + (semicolonSeparator == null ? 0 : semicolonSeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "IFieldDeclarationNode";
    }
  }

  public static class VariableDeclaratorIdAndAssignmentNode extends AbstractNode
      implements IVariableDeclaratorIdAndAssignmentNode {
    private final IVariableDeclaratorIdNode variableDeclaratorId;
    private final SourceToken<EqualsOperatorToken> equalsOperator;
    private final IVariableDeclaratorAssignmentNode variableDeclaratorAssignment;

    public VariableDeclaratorIdAndAssignmentNode(
        IVariableDeclaratorIdNode variableDeclaratorId,
        SourceToken<EqualsOperatorToken> equalsOperator,
        IVariableDeclaratorAssignmentNode variableDeclaratorAssignment) {
      this.variableDeclaratorId = variableDeclaratorId;
      this.equalsOperator = equalsOperator;
      this.variableDeclaratorAssignment = variableDeclaratorAssignment;
    }

    public IVariableDeclaratorIdNode getVariableDeclaratorId() {
      return variableDeclaratorId;
    }

    public SourceToken<EqualsOperatorToken> getEqualsOperator() {
      return equalsOperator;
    }

    public IVariableDeclaratorAssignmentNode getVariableDeclaratorAssignment() {
      return variableDeclaratorAssignment;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (variableDeclaratorId != null) {
        list.add(variableDeclaratorId);
      }
      if (equalsOperator != null) {
        list.add(equalsOperator);
      }
      if (variableDeclaratorAssignment != null) {
        list.add(variableDeclaratorAssignment);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IVariableDeclaratorIdAndAssignmentNode)) { return false; }
      IVariableDeclaratorIdAndAssignmentNode __node = (IVariableDeclaratorIdAndAssignmentNode) __other;
      if (!equals(variableDeclaratorId, __node.getVariableDeclaratorId())) { return false; }
      if (!equals(equalsOperator, __node.getEqualsOperator())) { return false; }
      if (!equals(variableDeclaratorAssignment, __node.getVariableDeclaratorAssignment())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (variableDeclaratorId == null ? 0 : variableDeclaratorId.hashCode());
      hash = 31 * hash + (equalsOperator == null ? 0 : equalsOperator.hashCode());
      hash = 31 * hash + (variableDeclaratorAssignment == null ? 0 : variableDeclaratorAssignment.hashCode());
      return hash;
    }

    public String getName() {
      return "IVariableDeclaratorIdAndAssignmentNode";
    }
  }

  public static class VariableDeclaratorIdNode extends AbstractNode implements IVariableDeclaratorIdNode {
    private final SourceToken<IdentifierToken> identifier;
    private final List<IBracketPairNode> bracketPairList;

    public VariableDeclaratorIdNode(
        SourceToken<IdentifierToken> identifier,
        List<IBracketPairNode> bracketPairList) {
      this.identifier = identifier;
      this.bracketPairList = bracketPairList;
    }

    public SourceToken<IdentifierToken> getIdentifier() {
      return identifier;
    }

    public List<IBracketPairNode> getBracketPairList() {
      return bracketPairList;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (identifier != null) {
        list.add(identifier);
      }
      if (bracketPairList != null) {
        list.addAll(bracketPairList);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IVariableDeclaratorIdNode)) { return false; }
      IVariableDeclaratorIdNode __node = (IVariableDeclaratorIdNode) __other;
      if (!equals(identifier, __node.getIdentifier())) { return false; }
      if (!equals(bracketPairList, __node.getBracketPairList())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (identifier == null ? 0 : identifier.hashCode());
      hash = 31 * hash + (bracketPairList == null ? 0 : bracketPairList.hashCode());
      return hash;
    }

    public String getName() {
      return "IVariableDeclaratorIdNode";
    }
  }

  public static class BracketPairNode extends AbstractNode implements IBracketPairNode {
    private final SourceToken<LeftBracketSeparatorToken> leftBracketSeparator;
    private final SourceToken<RightBracketSeparatorToken> rightBracketSeparator;

    public BracketPairNode(
        SourceToken<LeftBracketSeparatorToken> leftBracketSeparator,
        SourceToken<RightBracketSeparatorToken> rightBracketSeparator) {
      this.leftBracketSeparator = leftBracketSeparator;
      this.rightBracketSeparator = rightBracketSeparator;
    }

    public SourceToken<LeftBracketSeparatorToken> getLeftBracketSeparator() {
      return leftBracketSeparator;
    }

    public SourceToken<RightBracketSeparatorToken> getRightBracketSeparator() {
      return rightBracketSeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (leftBracketSeparator != null) {
        list.add(leftBracketSeparator);
      }
      if (rightBracketSeparator != null) {
        list.add(rightBracketSeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IBracketPairNode)) { return false; }
      IBracketPairNode __node = (IBracketPairNode) __other;
      if (!equals(leftBracketSeparator, __node.getLeftBracketSeparator())) { return false; }
      if (!equals(rightBracketSeparator, __node.getRightBracketSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (leftBracketSeparator == null ? 0 : leftBracketSeparator.hashCode());
      hash = 31 * hash + (rightBracketSeparator == null ? 0 : rightBracketSeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "IBracketPairNode";
    }
  }

  public static class MethodDeclarationNode extends AbstractNode implements IMethodDeclarationNode {
    private final IModifiersNode modifiers;
    private final ITypeParametersNode optionalTypeParameters;
    private final ITypeNode type;
    private final SourceToken<IdentifierToken> identifier;
    private final SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator;
    private final DelimitedList<IFormalParameterNode, SourceToken<CommaSeparatorToken>> optionalFormalParameterList;
    private final SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator;
    private final List<IBracketPairNode> bracketPairList;
    private final IThrowsNode optionalThrows;
    private final IMethodBodyNode methodBody;

    public MethodDeclarationNode(
        IModifiersNode modifiers,
        ITypeParametersNode optionalTypeParameters,
        ITypeNode type,
        SourceToken<IdentifierToken> identifier,
        SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator,
        DelimitedList<IFormalParameterNode, SourceToken<CommaSeparatorToken>> optionalFormalParameterList,
        SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator,
        List<IBracketPairNode> bracketPairList,
        IThrowsNode optionalThrows,
        IMethodBodyNode methodBody) {
      this.modifiers = modifiers;
      this.optionalTypeParameters = optionalTypeParameters;
      this.type = type;
      this.identifier = identifier;
      this.leftParenthesisSeparator = leftParenthesisSeparator;
      this.optionalFormalParameterList = optionalFormalParameterList;
      this.rightParenthesisSeparator = rightParenthesisSeparator;
      this.bracketPairList = bracketPairList;
      this.optionalThrows = optionalThrows;
      this.methodBody = methodBody;
    }

    public IModifiersNode getModifiers() {
      return modifiers;
    }

    public ITypeParametersNode getOptionalTypeParameters() {
      return optionalTypeParameters;
    }

    public ITypeNode getType() {
      return type;
    }

    public SourceToken<IdentifierToken> getIdentifier() {
      return identifier;
    }

    public SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator() {
      return leftParenthesisSeparator;
    }

    public DelimitedList<IFormalParameterNode, SourceToken<CommaSeparatorToken>> getOptionalFormalParameterList() {
      return optionalFormalParameterList;
    }

    public SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator() {
      return rightParenthesisSeparator;
    }

    public List<IBracketPairNode> getBracketPairList() {
      return bracketPairList;
    }

    public IThrowsNode getOptionalThrows() {
      return optionalThrows;
    }

    public IMethodBodyNode getMethodBody() {
      return methodBody;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (modifiers != null) {
        list.add(modifiers);
      }
      if (optionalTypeParameters != null) {
        list.add(optionalTypeParameters);
      }
      if (type != null) {
        list.add(type);
      }
      if (identifier != null) {
        list.add(identifier);
      }
      if (leftParenthesisSeparator != null) {
        list.add(leftParenthesisSeparator);
      }
      if (optionalFormalParameterList != null) {
        optionalFormalParameterList.addTo(list);
      }
      if (rightParenthesisSeparator != null) {
        list.add(rightParenthesisSeparator);
      }
      if (bracketPairList != null) {
        list.addAll(bracketPairList);
      }
      if (optionalThrows != null) {
        list.add(optionalThrows);
      }
      if (methodBody != null) {
        list.add(methodBody);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IMethodDeclarationNode)) { return false; }
      IMethodDeclarationNode __node = (IMethodDeclarationNode) __other;
      if (!equals(modifiers, __node.getModifiers())) { return false; }
      if (!equals(optionalTypeParameters, __node.getOptionalTypeParameters())) { return false; }
      if (!equals(type, __node.getType())) { return false; }
      if (!equals(identifier, __node.getIdentifier())) { return false; }
      if (!equals(leftParenthesisSeparator, __node.getLeftParenthesisSeparator())) { return false; }
      if (!equals(optionalFormalParameterList, __node.getOptionalFormalParameterList())) { return false; }
      if (!equals(rightParenthesisSeparator, __node.getRightParenthesisSeparator())) { return false; }
      if (!equals(bracketPairList, __node.getBracketPairList())) { return false; }
      if (!equals(optionalThrows, __node.getOptionalThrows())) { return false; }
      if (!equals(methodBody, __node.getMethodBody())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (modifiers == null ? 0 : modifiers.hashCode());
      hash = 31 * hash + (optionalTypeParameters == null ? 0 : optionalTypeParameters.hashCode());
      hash = 31 * hash + (type == null ? 0 : type.hashCode());
      hash = 31 * hash + (identifier == null ? 0 : identifier.hashCode());
      hash = 31 * hash + (leftParenthesisSeparator == null ? 0 : leftParenthesisSeparator.hashCode());
      hash = 31 * hash + (optionalFormalParameterList == null ? 0 : optionalFormalParameterList.hashCode());
      hash = 31 * hash + (rightParenthesisSeparator == null ? 0 : rightParenthesisSeparator.hashCode());
      hash = 31 * hash + (bracketPairList == null ? 0 : bracketPairList.hashCode());
      hash = 31 * hash + (optionalThrows == null ? 0 : optionalThrows.hashCode());
      hash = 31 * hash + (methodBody == null ? 0 : methodBody.hashCode());
      return hash;
    }

    public String getName() {
      return "IMethodDeclarationNode";
    }
  }

  public static class FormalParameterNode extends AbstractNode implements IFormalParameterNode {
    private final IModifiersNode modifiers;
    private final ITypeNode type;
    private final SourceToken<EllipsisSeparatorToken> optionalEllipsisSeparator;
    private final IVariableDeclaratorIdNode variableDeclaratorId;

    public FormalParameterNode(
        IModifiersNode modifiers,
        ITypeNode type,
        SourceToken<EllipsisSeparatorToken> optionalEllipsisSeparator,
        IVariableDeclaratorIdNode variableDeclaratorId) {
      this.modifiers = modifiers;
      this.type = type;
      this.optionalEllipsisSeparator = optionalEllipsisSeparator;
      this.variableDeclaratorId = variableDeclaratorId;
    }

    public IModifiersNode getModifiers() {
      return modifiers;
    }

    public ITypeNode getType() {
      return type;
    }

    public SourceToken<EllipsisSeparatorToken> getOptionalEllipsisSeparator() {
      return optionalEllipsisSeparator;
    }

    public IVariableDeclaratorIdNode getVariableDeclaratorId() {
      return variableDeclaratorId;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (modifiers != null) {
        list.add(modifiers);
      }
      if (type != null) {
        list.add(type);
      }
      if (optionalEllipsisSeparator != null) {
        list.add(optionalEllipsisSeparator);
      }
      if (variableDeclaratorId != null) {
        list.add(variableDeclaratorId);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IFormalParameterNode)) { return false; }
      IFormalParameterNode __node = (IFormalParameterNode) __other;
      if (!equals(modifiers, __node.getModifiers())) { return false; }
      if (!equals(type, __node.getType())) { return false; }
      if (!equals(optionalEllipsisSeparator, __node.getOptionalEllipsisSeparator())) { return false; }
      if (!equals(variableDeclaratorId, __node.getVariableDeclaratorId())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (modifiers == null ? 0 : modifiers.hashCode());
      hash = 31 * hash + (type == null ? 0 : type.hashCode());
      hash = 31 * hash + (optionalEllipsisSeparator == null ? 0 : optionalEllipsisSeparator.hashCode());
      hash = 31 * hash + (variableDeclaratorId == null ? 0 : variableDeclaratorId.hashCode());
      return hash;
    }

    public String getName() {
      return "IFormalParameterNode";
    }
  }

  public static class ThrowsNode extends AbstractNode implements IThrowsNode {
    private final SourceToken<ThrowsKeywordToken> throwsKeyword;
    private final DelimitedList<IClassOrInterfaceTypeNode, SourceToken<CommaSeparatorToken>> classOrInterfaceTypeList;

    public ThrowsNode(
        SourceToken<ThrowsKeywordToken> throwsKeyword,
        DelimitedList<IClassOrInterfaceTypeNode, SourceToken<CommaSeparatorToken>> classOrInterfaceTypeList) {
      this.throwsKeyword = throwsKeyword;
      this.classOrInterfaceTypeList = classOrInterfaceTypeList;
    }

    public SourceToken<ThrowsKeywordToken> getThrowsKeyword() {
      return throwsKeyword;
    }

    public DelimitedList<IClassOrInterfaceTypeNode, SourceToken<CommaSeparatorToken>> getClassOrInterfaceTypeList() {
      return classOrInterfaceTypeList;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (throwsKeyword != null) {
        list.add(throwsKeyword);
      }
      if (classOrInterfaceTypeList != null) {
        classOrInterfaceTypeList.addTo(list);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IThrowsNode)) { return false; }
      IThrowsNode __node = (IThrowsNode) __other;
      if (!equals(throwsKeyword, __node.getThrowsKeyword())) { return false; }
      if (!equals(classOrInterfaceTypeList, __node.getClassOrInterfaceTypeList())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (throwsKeyword == null ? 0 : throwsKeyword.hashCode());
      hash = 31 * hash + (classOrInterfaceTypeList == null ? 0 : classOrInterfaceTypeList.hashCode());
      return hash;
    }

    public String getName() {
      return "IThrowsNode";
    }
  }

  public static class TypeParametersNode extends AbstractNode implements ITypeParametersNode {
    private final SourceToken<LessThanOperatorToken> lessThanOperator;
    private final DelimitedList<ITypeParameterNode, SourceToken<CommaSeparatorToken>> typeParameterList;
    private final SourceToken<GreaterThanOperatorToken> greaterThanOperator;

    public TypeParametersNode(
        SourceToken<LessThanOperatorToken> lessThanOperator,
        DelimitedList<ITypeParameterNode, SourceToken<CommaSeparatorToken>> typeParameterList,
        SourceToken<GreaterThanOperatorToken> greaterThanOperator) {
      this.lessThanOperator = lessThanOperator;
      this.typeParameterList = typeParameterList;
      this.greaterThanOperator = greaterThanOperator;
    }

    public SourceToken<LessThanOperatorToken> getLessThanOperator() {
      return lessThanOperator;
    }

    public DelimitedList<ITypeParameterNode, SourceToken<CommaSeparatorToken>> getTypeParameterList() {
      return typeParameterList;
    }

    public SourceToken<GreaterThanOperatorToken> getGreaterThanOperator() {
      return greaterThanOperator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (lessThanOperator != null) {
        list.add(lessThanOperator);
      }
      if (typeParameterList != null) {
        typeParameterList.addTo(list);
      }
      if (greaterThanOperator != null) {
        list.add(greaterThanOperator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ITypeParametersNode)) { return false; }
      ITypeParametersNode __node = (ITypeParametersNode) __other;
      if (!equals(lessThanOperator, __node.getLessThanOperator())) { return false; }
      if (!equals(typeParameterList, __node.getTypeParameterList())) { return false; }
      if (!equals(greaterThanOperator, __node.getGreaterThanOperator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (lessThanOperator == null ? 0 : lessThanOperator.hashCode());
      hash = 31 * hash + (typeParameterList == null ? 0 : typeParameterList.hashCode());
      hash = 31 * hash + (greaterThanOperator == null ? 0 : greaterThanOperator.hashCode());
      return hash;
    }

    public String getName() {
      return "ITypeParametersNode";
    }
  }

  public static class TypeParameterNode extends AbstractNode implements ITypeParameterNode {
    private final SourceToken<IdentifierToken> identifier;
    private final ITypeBoundNode optionalTypeBound;

    public TypeParameterNode(
        SourceToken<IdentifierToken> identifier,
        ITypeBoundNode optionalTypeBound) {
      this.identifier = identifier;
      this.optionalTypeBound = optionalTypeBound;
    }

    public SourceToken<IdentifierToken> getIdentifier() {
      return identifier;
    }

    public ITypeBoundNode getOptionalTypeBound() {
      return optionalTypeBound;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (identifier != null) {
        list.add(identifier);
      }
      if (optionalTypeBound != null) {
        list.add(optionalTypeBound);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ITypeParameterNode)) { return false; }
      ITypeParameterNode __node = (ITypeParameterNode) __other;
      if (!equals(identifier, __node.getIdentifier())) { return false; }
      if (!equals(optionalTypeBound, __node.getOptionalTypeBound())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (identifier == null ? 0 : identifier.hashCode());
      hash = 31 * hash + (optionalTypeBound == null ? 0 : optionalTypeBound.hashCode());
      return hash;
    }

    public String getName() {
      return "ITypeParameterNode";
    }
  }

  public static class TypeBoundNode extends AbstractNode implements ITypeBoundNode {
    private final SourceToken<ExtendsKeywordToken> extendsKeyword;
    private final DelimitedList<IClassOrInterfaceTypeNode, SourceToken<BitwiseAndOperatorToken>> classOrInterfaceTypeList;

    public TypeBoundNode(
        SourceToken<ExtendsKeywordToken> extendsKeyword,
        DelimitedList<IClassOrInterfaceTypeNode, SourceToken<BitwiseAndOperatorToken>> classOrInterfaceTypeList) {
      this.extendsKeyword = extendsKeyword;
      this.classOrInterfaceTypeList = classOrInterfaceTypeList;
    }

    public SourceToken<ExtendsKeywordToken> getExtendsKeyword() {
      return extendsKeyword;
    }

    public DelimitedList<IClassOrInterfaceTypeNode, SourceToken<BitwiseAndOperatorToken>> getClassOrInterfaceTypeList() {
      return classOrInterfaceTypeList;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (extendsKeyword != null) {
        list.add(extendsKeyword);
      }
      if (classOrInterfaceTypeList != null) {
        classOrInterfaceTypeList.addTo(list);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ITypeBoundNode)) { return false; }
      ITypeBoundNode __node = (ITypeBoundNode) __other;
      if (!equals(extendsKeyword, __node.getExtendsKeyword())) { return false; }
      if (!equals(classOrInterfaceTypeList, __node.getClassOrInterfaceTypeList())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (extendsKeyword == null ? 0 : extendsKeyword.hashCode());
      hash = 31 * hash + (classOrInterfaceTypeList == null ? 0 : classOrInterfaceTypeList.hashCode());
      return hash;
    }

    public String getName() {
      return "ITypeBoundNode";
    }
  }

  public static class PrimitiveArrayReferenceTypeNode extends AbstractNode implements IPrimitiveArrayReferenceTypeNode {
    private final IPrimitiveTypeNode primitiveType;
    private final List<IBracketPairNode> bracketPairList;

    public PrimitiveArrayReferenceTypeNode(
        IPrimitiveTypeNode primitiveType,
        List<IBracketPairNode> bracketPairList) {
      this.primitiveType = primitiveType;
      this.bracketPairList = bracketPairList;
    }

    public IPrimitiveTypeNode getPrimitiveType() {
      return primitiveType;
    }

    public List<IBracketPairNode> getBracketPairList() {
      return bracketPairList;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (primitiveType != null) {
        list.add(primitiveType);
      }
      if (bracketPairList != null) {
        list.addAll(bracketPairList);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IPrimitiveArrayReferenceTypeNode)) { return false; }
      IPrimitiveArrayReferenceTypeNode __node = (IPrimitiveArrayReferenceTypeNode) __other;
      if (!equals(primitiveType, __node.getPrimitiveType())) { return false; }
      if (!equals(bracketPairList, __node.getBracketPairList())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (primitiveType == null ? 0 : primitiveType.hashCode());
      hash = 31 * hash + (bracketPairList == null ? 0 : bracketPairList.hashCode());
      return hash;
    }

    public String getName() {
      return "IPrimitiveArrayReferenceTypeNode";
    }
  }

  public static class ClassOrInterfaceReferenceTypeNode extends AbstractNode
      implements IClassOrInterfaceReferenceTypeNode {
    private final IClassOrInterfaceTypeNode classOrInterfaceType;
    private final List<IBracketPairNode> bracketPairList;

    public ClassOrInterfaceReferenceTypeNode(
        IClassOrInterfaceTypeNode classOrInterfaceType,
        List<IBracketPairNode> bracketPairList) {
      this.classOrInterfaceType = classOrInterfaceType;
      this.bracketPairList = bracketPairList;
    }

    public IClassOrInterfaceTypeNode getClassOrInterfaceType() {
      return classOrInterfaceType;
    }

    public List<IBracketPairNode> getBracketPairList() {
      return bracketPairList;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (classOrInterfaceType != null) {
        list.add(classOrInterfaceType);
      }
      if (bracketPairList != null) {
        list.addAll(bracketPairList);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IClassOrInterfaceReferenceTypeNode)) { return false; }
      IClassOrInterfaceReferenceTypeNode __node = (IClassOrInterfaceReferenceTypeNode) __other;
      if (!equals(classOrInterfaceType, __node.getClassOrInterfaceType())) { return false; }
      if (!equals(bracketPairList, __node.getBracketPairList())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (classOrInterfaceType == null ? 0 : classOrInterfaceType.hashCode());
      hash = 31 * hash + (bracketPairList == null ? 0 : bracketPairList.hashCode());
      return hash;
    }

    public String getName() {
      return "IClassOrInterfaceReferenceTypeNode";
    }
  }

  public static class ClassOrInterfaceTypeNode extends AbstractNode implements IClassOrInterfaceTypeNode {
    private final DelimitedList<ISingleClassOrInterfaceTypeNode, SourceToken<DotSeparatorToken>> singleClassOrInterfaceTypeList;

    public ClassOrInterfaceTypeNode(
        DelimitedList<ISingleClassOrInterfaceTypeNode, SourceToken<DotSeparatorToken>> singleClassOrInterfaceTypeList) {
      this.singleClassOrInterfaceTypeList = singleClassOrInterfaceTypeList;
    }

    public DelimitedList<ISingleClassOrInterfaceTypeNode, SourceToken<DotSeparatorToken>> getSingleClassOrInterfaceTypeList() {
      return singleClassOrInterfaceTypeList;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (singleClassOrInterfaceTypeList != null) {
        singleClassOrInterfaceTypeList.addTo(list);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IClassOrInterfaceTypeNode)) { return false; }
      IClassOrInterfaceTypeNode __node = (IClassOrInterfaceTypeNode) __other;
      if (!equals(singleClassOrInterfaceTypeList, __node.getSingleClassOrInterfaceTypeList())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (singleClassOrInterfaceTypeList == null ? 0 : singleClassOrInterfaceTypeList.hashCode());
      return hash;
    }

    public String getName() {
      return "IClassOrInterfaceTypeNode";
    }
  }

  public static class SingleClassOrInterfaceTypeNode extends AbstractNode implements ISingleClassOrInterfaceTypeNode {
    private final SourceToken<IdentifierToken> identifier;
    private final ITypeArgumentsNode optionalTypeArguments;

    public SingleClassOrInterfaceTypeNode(
        SourceToken<IdentifierToken> identifier,
        ITypeArgumentsNode optionalTypeArguments) {
      this.identifier = identifier;
      this.optionalTypeArguments = optionalTypeArguments;
    }

    public SourceToken<IdentifierToken> getIdentifier() {
      return identifier;
    }

    public ITypeArgumentsNode getOptionalTypeArguments() {
      return optionalTypeArguments;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (identifier != null) {
        list.add(identifier);
      }
      if (optionalTypeArguments != null) {
        list.add(optionalTypeArguments);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ISingleClassOrInterfaceTypeNode)) { return false; }
      ISingleClassOrInterfaceTypeNode __node = (ISingleClassOrInterfaceTypeNode) __other;
      if (!equals(identifier, __node.getIdentifier())) { return false; }
      if (!equals(optionalTypeArguments, __node.getOptionalTypeArguments())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (identifier == null ? 0 : identifier.hashCode());
      hash = 31 * hash + (optionalTypeArguments == null ? 0 : optionalTypeArguments.hashCode());
      return hash;
    }

    public String getName() {
      return "ISingleClassOrInterfaceTypeNode";
    }
  }

  public static class TypeArgumentsNode extends AbstractNode implements ITypeArgumentsNode {
    private final SourceToken<LessThanOperatorToken> lessThanOperator;
    private final DelimitedList<ITypeArgumentNode, SourceToken<CommaSeparatorToken>> typeArgumentList;
    private final SourceToken<GreaterThanOperatorToken> greaterThanOperator;

    public TypeArgumentsNode(
        SourceToken<LessThanOperatorToken> lessThanOperator,
        DelimitedList<ITypeArgumentNode, SourceToken<CommaSeparatorToken>> typeArgumentList,
        SourceToken<GreaterThanOperatorToken> greaterThanOperator) {
      this.lessThanOperator = lessThanOperator;
      this.typeArgumentList = typeArgumentList;
      this.greaterThanOperator = greaterThanOperator;
    }

    public SourceToken<LessThanOperatorToken> getLessThanOperator() {
      return lessThanOperator;
    }

    public DelimitedList<ITypeArgumentNode, SourceToken<CommaSeparatorToken>> getTypeArgumentList() {
      return typeArgumentList;
    }

    public SourceToken<GreaterThanOperatorToken> getGreaterThanOperator() {
      return greaterThanOperator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (lessThanOperator != null) {
        list.add(lessThanOperator);
      }
      if (typeArgumentList != null) {
        typeArgumentList.addTo(list);
      }
      if (greaterThanOperator != null) {
        list.add(greaterThanOperator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ITypeArgumentsNode)) { return false; }
      ITypeArgumentsNode __node = (ITypeArgumentsNode) __other;
      if (!equals(lessThanOperator, __node.getLessThanOperator())) { return false; }
      if (!equals(typeArgumentList, __node.getTypeArgumentList())) { return false; }
      if (!equals(greaterThanOperator, __node.getGreaterThanOperator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (lessThanOperator == null ? 0 : lessThanOperator.hashCode());
      hash = 31 * hash + (typeArgumentList == null ? 0 : typeArgumentList.hashCode());
      hash = 31 * hash + (greaterThanOperator == null ? 0 : greaterThanOperator.hashCode());
      return hash;
    }

    public String getName() {
      return "ITypeArgumentsNode";
    }
  }

  public static class ExtendsWildcardTypeArgumentNode extends AbstractNode implements IExtendsWildcardTypeArgumentNode {
    private final SourceToken<QuestionMarkOperatorToken> questionMarkOperator;
    private final SourceToken<ExtendsKeywordToken> extendsKeyword;
    private final IReferenceTypeNode referenceType;

    public ExtendsWildcardTypeArgumentNode(
        SourceToken<QuestionMarkOperatorToken> questionMarkOperator,
        SourceToken<ExtendsKeywordToken> extendsKeyword,
        IReferenceTypeNode referenceType) {
      this.questionMarkOperator = questionMarkOperator;
      this.extendsKeyword = extendsKeyword;
      this.referenceType = referenceType;
    }

    public SourceToken<QuestionMarkOperatorToken> getQuestionMarkOperator() {
      return questionMarkOperator;
    }

    public SourceToken<ExtendsKeywordToken> getExtendsKeyword() {
      return extendsKeyword;
    }

    public IReferenceTypeNode getReferenceType() {
      return referenceType;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (questionMarkOperator != null) {
        list.add(questionMarkOperator);
      }
      if (extendsKeyword != null) {
        list.add(extendsKeyword);
      }
      if (referenceType != null) {
        list.add(referenceType);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IExtendsWildcardTypeArgumentNode)) { return false; }
      IExtendsWildcardTypeArgumentNode __node = (IExtendsWildcardTypeArgumentNode) __other;
      if (!equals(questionMarkOperator, __node.getQuestionMarkOperator())) { return false; }
      if (!equals(extendsKeyword, __node.getExtendsKeyword())) { return false; }
      if (!equals(referenceType, __node.getReferenceType())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (questionMarkOperator == null ? 0 : questionMarkOperator.hashCode());
      hash = 31 * hash + (extendsKeyword == null ? 0 : extendsKeyword.hashCode());
      hash = 31 * hash + (referenceType == null ? 0 : referenceType.hashCode());
      return hash;
    }

    public String getName() {
      return "IExtendsWildcardTypeArgumentNode";
    }
  }

  public static class SuperWildcardTypeArgumentNode extends AbstractNode implements ISuperWildcardTypeArgumentNode {
    private final SourceToken<QuestionMarkOperatorToken> questionMarkOperator;
    private final SourceToken<SuperKeywordToken> superKeyword;
    private final IReferenceTypeNode referenceType;

    public SuperWildcardTypeArgumentNode(
        SourceToken<QuestionMarkOperatorToken> questionMarkOperator,
        SourceToken<SuperKeywordToken> superKeyword,
        IReferenceTypeNode referenceType) {
      this.questionMarkOperator = questionMarkOperator;
      this.superKeyword = superKeyword;
      this.referenceType = referenceType;
    }

    public SourceToken<QuestionMarkOperatorToken> getQuestionMarkOperator() {
      return questionMarkOperator;
    }

    public SourceToken<SuperKeywordToken> getSuperKeyword() {
      return superKeyword;
    }

    public IReferenceTypeNode getReferenceType() {
      return referenceType;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (questionMarkOperator != null) {
        list.add(questionMarkOperator);
      }
      if (superKeyword != null) {
        list.add(superKeyword);
      }
      if (referenceType != null) {
        list.add(referenceType);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ISuperWildcardTypeArgumentNode)) { return false; }
      ISuperWildcardTypeArgumentNode __node = (ISuperWildcardTypeArgumentNode) __other;
      if (!equals(questionMarkOperator, __node.getQuestionMarkOperator())) { return false; }
      if (!equals(superKeyword, __node.getSuperKeyword())) { return false; }
      if (!equals(referenceType, __node.getReferenceType())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (questionMarkOperator == null ? 0 : questionMarkOperator.hashCode());
      hash = 31 * hash + (superKeyword == null ? 0 : superKeyword.hashCode());
      hash = 31 * hash + (referenceType == null ? 0 : referenceType.hashCode());
      return hash;
    }

    public String getName() {
      return "ISuperWildcardTypeArgumentNode";
    }
  }

  public static class OpenWildcardTypeArgumentNode extends AbstractNode implements IOpenWildcardTypeArgumentNode {
    private final SourceToken<QuestionMarkOperatorToken> questionMarkOperator;

    public OpenWildcardTypeArgumentNode(
        SourceToken<QuestionMarkOperatorToken> questionMarkOperator) {
      this.questionMarkOperator = questionMarkOperator;
    }

    public SourceToken<QuestionMarkOperatorToken> getQuestionMarkOperator() {
      return questionMarkOperator;
    }

    protected List<Object> getChildrenWorker() {
      if (questionMarkOperator != null) {
        return Collections.<Object>singletonList(questionMarkOperator);
      }
      return Collections.emptyList();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IOpenWildcardTypeArgumentNode)) { return false; }
      IOpenWildcardTypeArgumentNode __node = (IOpenWildcardTypeArgumentNode) __other;
      if (!equals(questionMarkOperator, __node.getQuestionMarkOperator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (questionMarkOperator == null ? 0 : questionMarkOperator.hashCode());
      return hash;
    }

    public String getName() {
      return "IOpenWildcardTypeArgumentNode";
    }
  }

  public static class NonWildcardTypeArgumentsNode extends AbstractNode implements INonWildcardTypeArgumentsNode {
    private final SourceToken<LessThanOperatorToken> lessThanOperator;
    private final DelimitedList<IReferenceTypeNode, SourceToken<CommaSeparatorToken>> referenceTypeList;
    private final SourceToken<GreaterThanOperatorToken> greaterThanOperator;

    public NonWildcardTypeArgumentsNode(
        SourceToken<LessThanOperatorToken> lessThanOperator,
        DelimitedList<IReferenceTypeNode, SourceToken<CommaSeparatorToken>> referenceTypeList,
        SourceToken<GreaterThanOperatorToken> greaterThanOperator) {
      this.lessThanOperator = lessThanOperator;
      this.referenceTypeList = referenceTypeList;
      this.greaterThanOperator = greaterThanOperator;
    }

    public SourceToken<LessThanOperatorToken> getLessThanOperator() {
      return lessThanOperator;
    }

    public DelimitedList<IReferenceTypeNode, SourceToken<CommaSeparatorToken>> getReferenceTypeList() {
      return referenceTypeList;
    }

    public SourceToken<GreaterThanOperatorToken> getGreaterThanOperator() {
      return greaterThanOperator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (lessThanOperator != null) {
        list.add(lessThanOperator);
      }
      if (referenceTypeList != null) {
        referenceTypeList.addTo(list);
      }
      if (greaterThanOperator != null) {
        list.add(greaterThanOperator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof INonWildcardTypeArgumentsNode)) { return false; }
      INonWildcardTypeArgumentsNode __node = (INonWildcardTypeArgumentsNode) __other;
      if (!equals(lessThanOperator, __node.getLessThanOperator())) { return false; }
      if (!equals(referenceTypeList, __node.getReferenceTypeList())) { return false; }
      if (!equals(greaterThanOperator, __node.getGreaterThanOperator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (lessThanOperator == null ? 0 : lessThanOperator.hashCode());
      hash = 31 * hash + (referenceTypeList == null ? 0 : referenceTypeList.hashCode());
      hash = 31 * hash + (greaterThanOperator == null ? 0 : greaterThanOperator.hashCode());
      return hash;
    }

    public String getName() {
      return "INonWildcardTypeArgumentsNode";
    }
  }

  public static class NormalAnnotationNode extends AbstractNode implements INormalAnnotationNode {
    private final SourceToken<AtSeparatorToken> atSeparator;
    private final IQualifiedIdentifierNode qualifiedIdentifier;
    private final SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator;
    private final DelimitedList<IElementValuePairNode, SourceToken<CommaSeparatorToken>> optionalElementValuePairList;
    private final SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator;

    public NormalAnnotationNode(
        SourceToken<AtSeparatorToken> atSeparator,
        IQualifiedIdentifierNode qualifiedIdentifier,
        SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator,
        DelimitedList<IElementValuePairNode, SourceToken<CommaSeparatorToken>> optionalElementValuePairList,
        SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator) {
      this.atSeparator = atSeparator;
      this.qualifiedIdentifier = qualifiedIdentifier;
      this.leftParenthesisSeparator = leftParenthesisSeparator;
      this.optionalElementValuePairList = optionalElementValuePairList;
      this.rightParenthesisSeparator = rightParenthesisSeparator;
    }

    public SourceToken<AtSeparatorToken> getAtSeparator() {
      return atSeparator;
    }

    public IQualifiedIdentifierNode getQualifiedIdentifier() {
      return qualifiedIdentifier;
    }

    public SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator() {
      return leftParenthesisSeparator;
    }

    public DelimitedList<IElementValuePairNode, SourceToken<CommaSeparatorToken>> getOptionalElementValuePairList() {
      return optionalElementValuePairList;
    }

    public SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator() {
      return rightParenthesisSeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (atSeparator != null) {
        list.add(atSeparator);
      }
      if (qualifiedIdentifier != null) {
        list.add(qualifiedIdentifier);
      }
      if (leftParenthesisSeparator != null) {
        list.add(leftParenthesisSeparator);
      }
      if (optionalElementValuePairList != null) {
        optionalElementValuePairList.addTo(list);
      }
      if (rightParenthesisSeparator != null) {
        list.add(rightParenthesisSeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof INormalAnnotationNode)) { return false; }
      INormalAnnotationNode __node = (INormalAnnotationNode) __other;
      if (!equals(atSeparator, __node.getAtSeparator())) { return false; }
      if (!equals(qualifiedIdentifier, __node.getQualifiedIdentifier())) { return false; }
      if (!equals(leftParenthesisSeparator, __node.getLeftParenthesisSeparator())) { return false; }
      if (!equals(optionalElementValuePairList, __node.getOptionalElementValuePairList())) { return false; }
      if (!equals(rightParenthesisSeparator, __node.getRightParenthesisSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (atSeparator == null ? 0 : atSeparator.hashCode());
      hash = 31 * hash + (qualifiedIdentifier == null ? 0 : qualifiedIdentifier.hashCode());
      hash = 31 * hash + (leftParenthesisSeparator == null ? 0 : leftParenthesisSeparator.hashCode());
      hash = 31 * hash + (optionalElementValuePairList == null ? 0 : optionalElementValuePairList.hashCode());
      hash = 31 * hash + (rightParenthesisSeparator == null ? 0 : rightParenthesisSeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "INormalAnnotationNode";
    }
  }

  public static class ElementValuePairNode extends AbstractNode implements IElementValuePairNode {
    private final SourceToken<IdentifierToken> identifier;
    private final SourceToken<EqualsOperatorToken> equalsOperator;
    private final IElementValueNode elementValue;

    public ElementValuePairNode(
        SourceToken<IdentifierToken> identifier,
        SourceToken<EqualsOperatorToken> equalsOperator,
        IElementValueNode elementValue) {
      this.identifier = identifier;
      this.equalsOperator = equalsOperator;
      this.elementValue = elementValue;
    }

    public SourceToken<IdentifierToken> getIdentifier() {
      return identifier;
    }

    public SourceToken<EqualsOperatorToken> getEqualsOperator() {
      return equalsOperator;
    }

    public IElementValueNode getElementValue() {
      return elementValue;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (identifier != null) {
        list.add(identifier);
      }
      if (equalsOperator != null) {
        list.add(equalsOperator);
      }
      if (elementValue != null) {
        list.add(elementValue);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IElementValuePairNode)) { return false; }
      IElementValuePairNode __node = (IElementValuePairNode) __other;
      if (!equals(identifier, __node.getIdentifier())) { return false; }
      if (!equals(equalsOperator, __node.getEqualsOperator())) { return false; }
      if (!equals(elementValue, __node.getElementValue())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (identifier == null ? 0 : identifier.hashCode());
      hash = 31 * hash + (equalsOperator == null ? 0 : equalsOperator.hashCode());
      hash = 31 * hash + (elementValue == null ? 0 : elementValue.hashCode());
      return hash;
    }

    public String getName() {
      return "IElementValuePairNode";
    }
  }

  public static class SingleElementAnnotationNode extends AbstractNode implements ISingleElementAnnotationNode {
    private final SourceToken<AtSeparatorToken> atSeparator;
    private final IQualifiedIdentifierNode qualifiedIdentifier;
    private final SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator;
    private final IElementValueNode elementValue;
    private final SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator;

    public SingleElementAnnotationNode(
        SourceToken<AtSeparatorToken> atSeparator,
        IQualifiedIdentifierNode qualifiedIdentifier,
        SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator,
        IElementValueNode elementValue,
        SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator) {
      this.atSeparator = atSeparator;
      this.qualifiedIdentifier = qualifiedIdentifier;
      this.leftParenthesisSeparator = leftParenthesisSeparator;
      this.elementValue = elementValue;
      this.rightParenthesisSeparator = rightParenthesisSeparator;
    }

    public SourceToken<AtSeparatorToken> getAtSeparator() {
      return atSeparator;
    }

    public IQualifiedIdentifierNode getQualifiedIdentifier() {
      return qualifiedIdentifier;
    }

    public SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator() {
      return leftParenthesisSeparator;
    }

    public IElementValueNode getElementValue() {
      return elementValue;
    }

    public SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator() {
      return rightParenthesisSeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (atSeparator != null) {
        list.add(atSeparator);
      }
      if (qualifiedIdentifier != null) {
        list.add(qualifiedIdentifier);
      }
      if (leftParenthesisSeparator != null) {
        list.add(leftParenthesisSeparator);
      }
      if (elementValue != null) {
        list.add(elementValue);
      }
      if (rightParenthesisSeparator != null) {
        list.add(rightParenthesisSeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ISingleElementAnnotationNode)) { return false; }
      ISingleElementAnnotationNode __node = (ISingleElementAnnotationNode) __other;
      if (!equals(atSeparator, __node.getAtSeparator())) { return false; }
      if (!equals(qualifiedIdentifier, __node.getQualifiedIdentifier())) { return false; }
      if (!equals(leftParenthesisSeparator, __node.getLeftParenthesisSeparator())) { return false; }
      if (!equals(elementValue, __node.getElementValue())) { return false; }
      if (!equals(rightParenthesisSeparator, __node.getRightParenthesisSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (atSeparator == null ? 0 : atSeparator.hashCode());
      hash = 31 * hash + (qualifiedIdentifier == null ? 0 : qualifiedIdentifier.hashCode());
      hash = 31 * hash + (leftParenthesisSeparator == null ? 0 : leftParenthesisSeparator.hashCode());
      hash = 31 * hash + (elementValue == null ? 0 : elementValue.hashCode());
      hash = 31 * hash + (rightParenthesisSeparator == null ? 0 : rightParenthesisSeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "ISingleElementAnnotationNode";
    }
  }

  public static class MarkerAnnotationNode extends AbstractNode implements IMarkerAnnotationNode {
    private final SourceToken<AtSeparatorToken> atSeparator;
    private final IQualifiedIdentifierNode qualifiedIdentifier;

    public MarkerAnnotationNode(
        SourceToken<AtSeparatorToken> atSeparator,
        IQualifiedIdentifierNode qualifiedIdentifier) {
      this.atSeparator = atSeparator;
      this.qualifiedIdentifier = qualifiedIdentifier;
    }

    public SourceToken<AtSeparatorToken> getAtSeparator() {
      return atSeparator;
    }

    public IQualifiedIdentifierNode getQualifiedIdentifier() {
      return qualifiedIdentifier;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (atSeparator != null) {
        list.add(atSeparator);
      }
      if (qualifiedIdentifier != null) {
        list.add(qualifiedIdentifier);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IMarkerAnnotationNode)) { return false; }
      IMarkerAnnotationNode __node = (IMarkerAnnotationNode) __other;
      if (!equals(atSeparator, __node.getAtSeparator())) { return false; }
      if (!equals(qualifiedIdentifier, __node.getQualifiedIdentifier())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (atSeparator == null ? 0 : atSeparator.hashCode());
      hash = 31 * hash + (qualifiedIdentifier == null ? 0 : qualifiedIdentifier.hashCode());
      return hash;
    }

    public String getName() {
      return "IMarkerAnnotationNode";
    }
  }

  public static class ElementValueArrayInitializerNode extends AbstractNode
      implements IElementValueArrayInitializerNode {
    private final SourceToken<LeftCurlySeparatorToken> leftCurlySeparator;
    private final DelimitedList<IElementValueNode, SourceToken<CommaSeparatorToken>> optionalElementValueList;
    private final SourceToken<CommaSeparatorToken> optionalCommaSeparator;
    private final SourceToken<RightCurlySeparatorToken> rightCurlySeparator;

    public ElementValueArrayInitializerNode(
        SourceToken<LeftCurlySeparatorToken> leftCurlySeparator,
        DelimitedList<IElementValueNode, SourceToken<CommaSeparatorToken>> optionalElementValueList,
        SourceToken<CommaSeparatorToken> optionalCommaSeparator,
        SourceToken<RightCurlySeparatorToken> rightCurlySeparator) {
      this.leftCurlySeparator = leftCurlySeparator;
      this.optionalElementValueList = optionalElementValueList;
      this.optionalCommaSeparator = optionalCommaSeparator;
      this.rightCurlySeparator = rightCurlySeparator;
    }

    public SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator() {
      return leftCurlySeparator;
    }

    public DelimitedList<IElementValueNode, SourceToken<CommaSeparatorToken>> getOptionalElementValueList() {
      return optionalElementValueList;
    }

    public SourceToken<CommaSeparatorToken> getOptionalCommaSeparator() {
      return optionalCommaSeparator;
    }

    public SourceToken<RightCurlySeparatorToken> getRightCurlySeparator() {
      return rightCurlySeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (leftCurlySeparator != null) {
        list.add(leftCurlySeparator);
      }
      if (optionalElementValueList != null) {
        optionalElementValueList.addTo(list);
      }
      if (optionalCommaSeparator != null) {
        list.add(optionalCommaSeparator);
      }
      if (rightCurlySeparator != null) {
        list.add(rightCurlySeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IElementValueArrayInitializerNode)) { return false; }
      IElementValueArrayInitializerNode __node = (IElementValueArrayInitializerNode) __other;
      if (!equals(leftCurlySeparator, __node.getLeftCurlySeparator())) { return false; }
      if (!equals(optionalElementValueList, __node.getOptionalElementValueList())) { return false; }
      if (!equals(optionalCommaSeparator, __node.getOptionalCommaSeparator())) { return false; }
      if (!equals(rightCurlySeparator, __node.getRightCurlySeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (leftCurlySeparator == null ? 0 : leftCurlySeparator.hashCode());
      hash = 31 * hash + (optionalElementValueList == null ? 0 : optionalElementValueList.hashCode());
      hash = 31 * hash + (optionalCommaSeparator == null ? 0 : optionalCommaSeparator.hashCode());
      hash = 31 * hash + (rightCurlySeparator == null ? 0 : rightCurlySeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "IElementValueArrayInitializerNode";
    }
  }

  public static class BlockNode extends AbstractNode implements IBlockNode {
    private final SourceToken<LeftCurlySeparatorToken> leftCurlySeparator;
    private final List<IBlockStatementNode> blockStatementList;
    private final SourceToken<RightCurlySeparatorToken> rightCurlySeparator;

    public BlockNode(
        SourceToken<LeftCurlySeparatorToken> leftCurlySeparator,
        List<IBlockStatementNode> blockStatementList,
        SourceToken<RightCurlySeparatorToken> rightCurlySeparator) {
      this.leftCurlySeparator = leftCurlySeparator;
      this.blockStatementList = blockStatementList;
      this.rightCurlySeparator = rightCurlySeparator;
    }

    public SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator() {
      return leftCurlySeparator;
    }

    public List<IBlockStatementNode> getBlockStatementList() {
      return blockStatementList;
    }

    public SourceToken<RightCurlySeparatorToken> getRightCurlySeparator() {
      return rightCurlySeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (leftCurlySeparator != null) {
        list.add(leftCurlySeparator);
      }
      if (blockStatementList != null) {
        list.addAll(blockStatementList);
      }
      if (rightCurlySeparator != null) {
        list.add(rightCurlySeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IBlockNode)) { return false; }
      IBlockNode __node = (IBlockNode) __other;
      if (!equals(leftCurlySeparator, __node.getLeftCurlySeparator())) { return false; }
      if (!equals(blockStatementList, __node.getBlockStatementList())) { return false; }
      if (!equals(rightCurlySeparator, __node.getRightCurlySeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (leftCurlySeparator == null ? 0 : leftCurlySeparator.hashCode());
      hash = 31 * hash + (blockStatementList == null ? 0 : blockStatementList.hashCode());
      hash = 31 * hash + (rightCurlySeparator == null ? 0 : rightCurlySeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "IBlockNode";
    }
  }

  public static class LocalVariableDeclarationStatementNode extends AbstractNode
      implements ILocalVariableDeclarationStatementNode {
    private final ILocalVariableDeclarationNode localVariableDeclaration;
    private final SourceToken<SemicolonSeparatorToken> semicolonSeparator;

    public LocalVariableDeclarationStatementNode(
        ILocalVariableDeclarationNode localVariableDeclaration,
        SourceToken<SemicolonSeparatorToken> semicolonSeparator) {
      this.localVariableDeclaration = localVariableDeclaration;
      this.semicolonSeparator = semicolonSeparator;
    }

    public ILocalVariableDeclarationNode getLocalVariableDeclaration() {
      return localVariableDeclaration;
    }

    public SourceToken<SemicolonSeparatorToken> getSemicolonSeparator() {
      return semicolonSeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (localVariableDeclaration != null) {
        list.add(localVariableDeclaration);
      }
      if (semicolonSeparator != null) {
        list.add(semicolonSeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ILocalVariableDeclarationStatementNode)) { return false; }
      ILocalVariableDeclarationStatementNode __node = (ILocalVariableDeclarationStatementNode) __other;
      if (!equals(localVariableDeclaration, __node.getLocalVariableDeclaration())) { return false; }
      if (!equals(semicolonSeparator, __node.getSemicolonSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (localVariableDeclaration == null ? 0 : localVariableDeclaration.hashCode());
      hash = 31 * hash + (semicolonSeparator == null ? 0 : semicolonSeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "ILocalVariableDeclarationStatementNode";
    }
  }

  public static class LocalVariableDeclarationNode extends AbstractNode implements ILocalVariableDeclarationNode {
    private final IModifiersNode modifiers;
    private final ITypeNode type;
    private final DelimitedList<IVariableDeclaratorNode, SourceToken<CommaSeparatorToken>> variableDeclaratorList;

    public LocalVariableDeclarationNode(
        IModifiersNode modifiers,
        ITypeNode type,
        DelimitedList<IVariableDeclaratorNode, SourceToken<CommaSeparatorToken>> variableDeclaratorList) {
      this.modifiers = modifiers;
      this.type = type;
      this.variableDeclaratorList = variableDeclaratorList;
    }

    public IModifiersNode getModifiers() {
      return modifiers;
    }

    public ITypeNode getType() {
      return type;
    }

    public DelimitedList<IVariableDeclaratorNode, SourceToken<CommaSeparatorToken>> getVariableDeclaratorList() {
      return variableDeclaratorList;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (modifiers != null) {
        list.add(modifiers);
      }
      if (type != null) {
        list.add(type);
      }
      if (variableDeclaratorList != null) {
        variableDeclaratorList.addTo(list);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ILocalVariableDeclarationNode)) { return false; }
      ILocalVariableDeclarationNode __node = (ILocalVariableDeclarationNode) __other;
      if (!equals(modifiers, __node.getModifiers())) { return false; }
      if (!equals(type, __node.getType())) { return false; }
      if (!equals(variableDeclaratorList, __node.getVariableDeclaratorList())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (modifiers == null ? 0 : modifiers.hashCode());
      hash = 31 * hash + (type == null ? 0 : type.hashCode());
      hash = 31 * hash + (variableDeclaratorList == null ? 0 : variableDeclaratorList.hashCode());
      return hash;
    }

    public String getName() {
      return "ILocalVariableDeclarationNode";
    }
  }

  public static class EmptyStatementNode extends AbstractNode implements IEmptyStatementNode {
    private final SourceToken<SemicolonSeparatorToken> semicolonSeparator;

    public EmptyStatementNode(
        SourceToken<SemicolonSeparatorToken> semicolonSeparator) {
      this.semicolonSeparator = semicolonSeparator;
    }

    public SourceToken<SemicolonSeparatorToken> getSemicolonSeparator() {
      return semicolonSeparator;
    }

    protected List<Object> getChildrenWorker() {
      if (semicolonSeparator != null) {
        return Collections.<Object>singletonList(semicolonSeparator);
      }
      return Collections.emptyList();
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IEmptyStatementNode)) { return false; }
      IEmptyStatementNode __node = (IEmptyStatementNode) __other;
      if (!equals(semicolonSeparator, __node.getSemicolonSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (semicolonSeparator == null ? 0 : semicolonSeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "IEmptyStatementNode";
    }
  }

  public static class LabeledStatementNode extends AbstractNode implements ILabeledStatementNode {
    private final SourceToken<IdentifierToken> identifier;
    private final SourceToken<ColonOperatorToken> colonOperator;
    private final IStatementNode statement;

    public LabeledStatementNode(
        SourceToken<IdentifierToken> identifier,
        SourceToken<ColonOperatorToken> colonOperator,
        IStatementNode statement) {
      this.identifier = identifier;
      this.colonOperator = colonOperator;
      this.statement = statement;
    }

    public SourceToken<IdentifierToken> getIdentifier() {
      return identifier;
    }

    public SourceToken<ColonOperatorToken> getColonOperator() {
      return colonOperator;
    }

    public IStatementNode getStatement() {
      return statement;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (identifier != null) {
        list.add(identifier);
      }
      if (colonOperator != null) {
        list.add(colonOperator);
      }
      if (statement != null) {
        list.add(statement);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ILabeledStatementNode)) { return false; }
      ILabeledStatementNode __node = (ILabeledStatementNode) __other;
      if (!equals(identifier, __node.getIdentifier())) { return false; }
      if (!equals(colonOperator, __node.getColonOperator())) { return false; }
      if (!equals(statement, __node.getStatement())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (identifier == null ? 0 : identifier.hashCode());
      hash = 31 * hash + (colonOperator == null ? 0 : colonOperator.hashCode());
      hash = 31 * hash + (statement == null ? 0 : statement.hashCode());
      return hash;
    }

    public String getName() {
      return "ILabeledStatementNode";
    }
  }

  public static class ExpressionStatementNode extends AbstractNode implements IExpressionStatementNode {
    private final IExpressionNode expression;
    private final SourceToken<SemicolonSeparatorToken> semicolonSeparator;

    public ExpressionStatementNode(
        IExpressionNode expression,
        SourceToken<SemicolonSeparatorToken> semicolonSeparator) {
      this.expression = expression;
      this.semicolonSeparator = semicolonSeparator;
    }

    public IExpressionNode getExpression() {
      return expression;
    }

    public SourceToken<SemicolonSeparatorToken> getSemicolonSeparator() {
      return semicolonSeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (expression != null) {
        list.add(expression);
      }
      if (semicolonSeparator != null) {
        list.add(semicolonSeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IExpressionStatementNode)) { return false; }
      IExpressionStatementNode __node = (IExpressionStatementNode) __other;
      if (!equals(expression, __node.getExpression())) { return false; }
      if (!equals(semicolonSeparator, __node.getSemicolonSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (expression == null ? 0 : expression.hashCode());
      hash = 31 * hash + (semicolonSeparator == null ? 0 : semicolonSeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "IExpressionStatementNode";
    }
  }

  public static class IfStatementNode extends AbstractNode implements IIfStatementNode {
    private final SourceToken<IfKeywordToken> ifKeyword;
    private final SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator;
    private final IExpressionNode expression;
    private final SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator;
    private final IStatementNode statement;
    private final IElseStatementNode optionalElseStatement;

    public IfStatementNode(
        SourceToken<IfKeywordToken> ifKeyword,
        SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator,
        IExpressionNode expression,
        SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator,
        IStatementNode statement,
        IElseStatementNode optionalElseStatement) {
      this.ifKeyword = ifKeyword;
      this.leftParenthesisSeparator = leftParenthesisSeparator;
      this.expression = expression;
      this.rightParenthesisSeparator = rightParenthesisSeparator;
      this.statement = statement;
      this.optionalElseStatement = optionalElseStatement;
    }

    public SourceToken<IfKeywordToken> getIfKeyword() {
      return ifKeyword;
    }

    public SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator() {
      return leftParenthesisSeparator;
    }

    public IExpressionNode getExpression() {
      return expression;
    }

    public SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator() {
      return rightParenthesisSeparator;
    }

    public IStatementNode getStatement() {
      return statement;
    }

    public IElseStatementNode getOptionalElseStatement() {
      return optionalElseStatement;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (ifKeyword != null) {
        list.add(ifKeyword);
      }
      if (leftParenthesisSeparator != null) {
        list.add(leftParenthesisSeparator);
      }
      if (expression != null) {
        list.add(expression);
      }
      if (rightParenthesisSeparator != null) {
        list.add(rightParenthesisSeparator);
      }
      if (statement != null) {
        list.add(statement);
      }
      if (optionalElseStatement != null) {
        list.add(optionalElseStatement);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IIfStatementNode)) { return false; }
      IIfStatementNode __node = (IIfStatementNode) __other;
      if (!equals(ifKeyword, __node.getIfKeyword())) { return false; }
      if (!equals(leftParenthesisSeparator, __node.getLeftParenthesisSeparator())) { return false; }
      if (!equals(expression, __node.getExpression())) { return false; }
      if (!equals(rightParenthesisSeparator, __node.getRightParenthesisSeparator())) { return false; }
      if (!equals(statement, __node.getStatement())) { return false; }
      if (!equals(optionalElseStatement, __node.getOptionalElseStatement())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (ifKeyword == null ? 0 : ifKeyword.hashCode());
      hash = 31 * hash + (leftParenthesisSeparator == null ? 0 : leftParenthesisSeparator.hashCode());
      hash = 31 * hash + (expression == null ? 0 : expression.hashCode());
      hash = 31 * hash + (rightParenthesisSeparator == null ? 0 : rightParenthesisSeparator.hashCode());
      hash = 31 * hash + (statement == null ? 0 : statement.hashCode());
      hash = 31 * hash + (optionalElseStatement == null ? 0 : optionalElseStatement.hashCode());
      return hash;
    }

    public String getName() {
      return "IIfStatementNode";
    }
  }

  public static class ElseStatementNode extends AbstractNode implements IElseStatementNode {
    private final SourceToken<ElseKeywordToken> elseKeyword;
    private final IStatementNode statement;

    public ElseStatementNode(
        SourceToken<ElseKeywordToken> elseKeyword,
        IStatementNode statement) {
      this.elseKeyword = elseKeyword;
      this.statement = statement;
    }

    public SourceToken<ElseKeywordToken> getElseKeyword() {
      return elseKeyword;
    }

    public IStatementNode getStatement() {
      return statement;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (elseKeyword != null) {
        list.add(elseKeyword);
      }
      if (statement != null) {
        list.add(statement);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IElseStatementNode)) { return false; }
      IElseStatementNode __node = (IElseStatementNode) __other;
      if (!equals(elseKeyword, __node.getElseKeyword())) { return false; }
      if (!equals(statement, __node.getStatement())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (elseKeyword == null ? 0 : elseKeyword.hashCode());
      hash = 31 * hash + (statement == null ? 0 : statement.hashCode());
      return hash;
    }

    public String getName() {
      return "IElseStatementNode";
    }
  }

  public static class MessageAssertStatementNode extends AbstractNode implements IMessageAssertStatementNode {
    private final SourceToken<AssertKeywordToken> assertKeyword;
    private final IExpressionNode expression;
    private final SourceToken<ColonOperatorToken> colonOperator;
    private final IExpressionNode expression2;
    private final SourceToken<SemicolonSeparatorToken> semicolonSeparator;

    public MessageAssertStatementNode(
        SourceToken<AssertKeywordToken> assertKeyword,
        IExpressionNode expression,
        SourceToken<ColonOperatorToken> colonOperator,
        IExpressionNode expression2,
        SourceToken<SemicolonSeparatorToken> semicolonSeparator) {
      this.assertKeyword = assertKeyword;
      this.expression = expression;
      this.colonOperator = colonOperator;
      this.expression2 = expression2;
      this.semicolonSeparator = semicolonSeparator;
    }

    public SourceToken<AssertKeywordToken> getAssertKeyword() {
      return assertKeyword;
    }

    public IExpressionNode getExpression() {
      return expression;
    }

    public SourceToken<ColonOperatorToken> getColonOperator() {
      return colonOperator;
    }

    public IExpressionNode getExpression2() {
      return expression2;
    }

    public SourceToken<SemicolonSeparatorToken> getSemicolonSeparator() {
      return semicolonSeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (assertKeyword != null) {
        list.add(assertKeyword);
      }
      if (expression != null) {
        list.add(expression);
      }
      if (colonOperator != null) {
        list.add(colonOperator);
      }
      if (expression2 != null) {
        list.add(expression2);
      }
      if (semicolonSeparator != null) {
        list.add(semicolonSeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IMessageAssertStatementNode)) { return false; }
      IMessageAssertStatementNode __node = (IMessageAssertStatementNode) __other;
      if (!equals(assertKeyword, __node.getAssertKeyword())) { return false; }
      if (!equals(expression, __node.getExpression())) { return false; }
      if (!equals(colonOperator, __node.getColonOperator())) { return false; }
      if (!equals(expression2, __node.getExpression2())) { return false; }
      if (!equals(semicolonSeparator, __node.getSemicolonSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (assertKeyword == null ? 0 : assertKeyword.hashCode());
      hash = 31 * hash + (expression == null ? 0 : expression.hashCode());
      hash = 31 * hash + (colonOperator == null ? 0 : colonOperator.hashCode());
      hash = 31 * hash + (expression2 == null ? 0 : expression2.hashCode());
      hash = 31 * hash + (semicolonSeparator == null ? 0 : semicolonSeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "IMessageAssertStatementNode";
    }
  }

  public static class SimpleAssertStatementNode extends AbstractNode implements ISimpleAssertStatementNode {
    private final SourceToken<AssertKeywordToken> assertKeyword;
    private final IExpressionNode expression;
    private final SourceToken<SemicolonSeparatorToken> semicolonSeparator;

    public SimpleAssertStatementNode(
        SourceToken<AssertKeywordToken> assertKeyword,
        IExpressionNode expression,
        SourceToken<SemicolonSeparatorToken> semicolonSeparator) {
      this.assertKeyword = assertKeyword;
      this.expression = expression;
      this.semicolonSeparator = semicolonSeparator;
    }

    public SourceToken<AssertKeywordToken> getAssertKeyword() {
      return assertKeyword;
    }

    public IExpressionNode getExpression() {
      return expression;
    }

    public SourceToken<SemicolonSeparatorToken> getSemicolonSeparator() {
      return semicolonSeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (assertKeyword != null) {
        list.add(assertKeyword);
      }
      if (expression != null) {
        list.add(expression);
      }
      if (semicolonSeparator != null) {
        list.add(semicolonSeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ISimpleAssertStatementNode)) { return false; }
      ISimpleAssertStatementNode __node = (ISimpleAssertStatementNode) __other;
      if (!equals(assertKeyword, __node.getAssertKeyword())) { return false; }
      if (!equals(expression, __node.getExpression())) { return false; }
      if (!equals(semicolonSeparator, __node.getSemicolonSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (assertKeyword == null ? 0 : assertKeyword.hashCode());
      hash = 31 * hash + (expression == null ? 0 : expression.hashCode());
      hash = 31 * hash + (semicolonSeparator == null ? 0 : semicolonSeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "ISimpleAssertStatementNode";
    }
  }

  public static class SwitchStatementNode extends AbstractNode implements ISwitchStatementNode {
    private final SourceToken<SwitchKeywordToken> switchKeyword;
    private final SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator;
    private final IExpressionNode expression;
    private final SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator;
    private final SourceToken<LeftCurlySeparatorToken> leftCurlySeparator;
    private final List<ISwitchBlockStatementGroupNode> switchBlockStatementGroupList;
    private final List<ISwitchLabelNode> switchLabelList;
    private final SourceToken<RightCurlySeparatorToken> rightCurlySeparator;

    public SwitchStatementNode(
        SourceToken<SwitchKeywordToken> switchKeyword,
        SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator,
        IExpressionNode expression,
        SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator,
        SourceToken<LeftCurlySeparatorToken> leftCurlySeparator,
        List<ISwitchBlockStatementGroupNode> switchBlockStatementGroupList,
        List<ISwitchLabelNode> switchLabelList,
        SourceToken<RightCurlySeparatorToken> rightCurlySeparator) {
      this.switchKeyword = switchKeyword;
      this.leftParenthesisSeparator = leftParenthesisSeparator;
      this.expression = expression;
      this.rightParenthesisSeparator = rightParenthesisSeparator;
      this.leftCurlySeparator = leftCurlySeparator;
      this.switchBlockStatementGroupList = switchBlockStatementGroupList;
      this.switchLabelList = switchLabelList;
      this.rightCurlySeparator = rightCurlySeparator;
    }

    public SourceToken<SwitchKeywordToken> getSwitchKeyword() {
      return switchKeyword;
    }

    public SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator() {
      return leftParenthesisSeparator;
    }

    public IExpressionNode getExpression() {
      return expression;
    }

    public SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator() {
      return rightParenthesisSeparator;
    }

    public SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator() {
      return leftCurlySeparator;
    }

    public List<ISwitchBlockStatementGroupNode> getSwitchBlockStatementGroupList() {
      return switchBlockStatementGroupList;
    }

    public List<ISwitchLabelNode> getSwitchLabelList() {
      return switchLabelList;
    }

    public SourceToken<RightCurlySeparatorToken> getRightCurlySeparator() {
      return rightCurlySeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (switchKeyword != null) {
        list.add(switchKeyword);
      }
      if (leftParenthesisSeparator != null) {
        list.add(leftParenthesisSeparator);
      }
      if (expression != null) {
        list.add(expression);
      }
      if (rightParenthesisSeparator != null) {
        list.add(rightParenthesisSeparator);
      }
      if (leftCurlySeparator != null) {
        list.add(leftCurlySeparator);
      }
      if (switchBlockStatementGroupList != null) {
        list.addAll(switchBlockStatementGroupList);
      }
      if (switchLabelList != null) {
        list.addAll(switchLabelList);
      }
      if (rightCurlySeparator != null) {
        list.add(rightCurlySeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ISwitchStatementNode)) { return false; }
      ISwitchStatementNode __node = (ISwitchStatementNode) __other;
      if (!equals(switchKeyword, __node.getSwitchKeyword())) { return false; }
      if (!equals(leftParenthesisSeparator, __node.getLeftParenthesisSeparator())) { return false; }
      if (!equals(expression, __node.getExpression())) { return false; }
      if (!equals(rightParenthesisSeparator, __node.getRightParenthesisSeparator())) { return false; }
      if (!equals(leftCurlySeparator, __node.getLeftCurlySeparator())) { return false; }
      if (!equals(switchBlockStatementGroupList, __node.getSwitchBlockStatementGroupList())) { return false; }
      if (!equals(switchLabelList, __node.getSwitchLabelList())) { return false; }
      if (!equals(rightCurlySeparator, __node.getRightCurlySeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (switchKeyword == null ? 0 : switchKeyword.hashCode());
      hash = 31 * hash + (leftParenthesisSeparator == null ? 0 : leftParenthesisSeparator.hashCode());
      hash = 31 * hash + (expression == null ? 0 : expression.hashCode());
      hash = 31 * hash + (rightParenthesisSeparator == null ? 0 : rightParenthesisSeparator.hashCode());
      hash = 31 * hash + (leftCurlySeparator == null ? 0 : leftCurlySeparator.hashCode());
      hash = 31 * hash + (switchBlockStatementGroupList == null ? 0 : switchBlockStatementGroupList.hashCode());
      hash = 31 * hash + (switchLabelList == null ? 0 : switchLabelList.hashCode());
      hash = 31 * hash + (rightCurlySeparator == null ? 0 : rightCurlySeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "ISwitchStatementNode";
    }
  }

  public static class SwitchBlockStatementGroupNode extends AbstractNode implements ISwitchBlockStatementGroupNode {
    private final List<ISwitchLabelNode> switchLabelList;
    private final List<IBlockStatementNode> blockStatementList;

    public SwitchBlockStatementGroupNode(
        List<ISwitchLabelNode> switchLabelList,
        List<IBlockStatementNode> blockStatementList) {
      this.switchLabelList = switchLabelList;
      this.blockStatementList = blockStatementList;
    }

    public List<ISwitchLabelNode> getSwitchLabelList() {
      return switchLabelList;
    }

    public List<IBlockStatementNode> getBlockStatementList() {
      return blockStatementList;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (switchLabelList != null) {
        list.addAll(switchLabelList);
      }
      if (blockStatementList != null) {
        list.addAll(blockStatementList);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ISwitchBlockStatementGroupNode)) { return false; }
      ISwitchBlockStatementGroupNode __node = (ISwitchBlockStatementGroupNode) __other;
      if (!equals(switchLabelList, __node.getSwitchLabelList())) { return false; }
      if (!equals(blockStatementList, __node.getBlockStatementList())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (switchLabelList == null ? 0 : switchLabelList.hashCode());
      hash = 31 * hash + (blockStatementList == null ? 0 : blockStatementList.hashCode());
      return hash;
    }

    public String getName() {
      return "ISwitchBlockStatementGroupNode";
    }
  }

  public static class CaseSwitchLabelNode extends AbstractNode implements ICaseSwitchLabelNode {
    private final SourceToken<CaseKeywordToken> caseKeyword;
    private final IExpressionNode expression;
    private final SourceToken<ColonOperatorToken> colonOperator;

    public CaseSwitchLabelNode(
        SourceToken<CaseKeywordToken> caseKeyword,
        IExpressionNode expression,
        SourceToken<ColonOperatorToken> colonOperator) {
      this.caseKeyword = caseKeyword;
      this.expression = expression;
      this.colonOperator = colonOperator;
    }

    public SourceToken<CaseKeywordToken> getCaseKeyword() {
      return caseKeyword;
    }

    public IExpressionNode getExpression() {
      return expression;
    }

    public SourceToken<ColonOperatorToken> getColonOperator() {
      return colonOperator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (caseKeyword != null) {
        list.add(caseKeyword);
      }
      if (expression != null) {
        list.add(expression);
      }
      if (colonOperator != null) {
        list.add(colonOperator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ICaseSwitchLabelNode)) { return false; }
      ICaseSwitchLabelNode __node = (ICaseSwitchLabelNode) __other;
      if (!equals(caseKeyword, __node.getCaseKeyword())) { return false; }
      if (!equals(expression, __node.getExpression())) { return false; }
      if (!equals(colonOperator, __node.getColonOperator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (caseKeyword == null ? 0 : caseKeyword.hashCode());
      hash = 31 * hash + (expression == null ? 0 : expression.hashCode());
      hash = 31 * hash + (colonOperator == null ? 0 : colonOperator.hashCode());
      return hash;
    }

    public String getName() {
      return "ICaseSwitchLabelNode";
    }
  }

  public static class DefaultSwitchLabelNode extends AbstractNode implements IDefaultSwitchLabelNode {
    private final SourceToken<DefaultKeywordToken> defaultKeyword;
    private final SourceToken<ColonOperatorToken> colonOperator;

    public DefaultSwitchLabelNode(
        SourceToken<DefaultKeywordToken> defaultKeyword,
        SourceToken<ColonOperatorToken> colonOperator) {
      this.defaultKeyword = defaultKeyword;
      this.colonOperator = colonOperator;
    }

    public SourceToken<DefaultKeywordToken> getDefaultKeyword() {
      return defaultKeyword;
    }

    public SourceToken<ColonOperatorToken> getColonOperator() {
      return colonOperator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (defaultKeyword != null) {
        list.add(defaultKeyword);
      }
      if (colonOperator != null) {
        list.add(colonOperator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IDefaultSwitchLabelNode)) { return false; }
      IDefaultSwitchLabelNode __node = (IDefaultSwitchLabelNode) __other;
      if (!equals(defaultKeyword, __node.getDefaultKeyword())) { return false; }
      if (!equals(colonOperator, __node.getColonOperator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (defaultKeyword == null ? 0 : defaultKeyword.hashCode());
      hash = 31 * hash + (colonOperator == null ? 0 : colonOperator.hashCode());
      return hash;
    }

    public String getName() {
      return "IDefaultSwitchLabelNode";
    }
  }

  public static class WhileStatementNode extends AbstractNode implements IWhileStatementNode {
    private final SourceToken<WhileKeywordToken> whileKeyword;
    private final SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator;
    private final IExpressionNode expression;
    private final SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator;
    private final IStatementNode statement;

    public WhileStatementNode(
        SourceToken<WhileKeywordToken> whileKeyword,
        SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator,
        IExpressionNode expression,
        SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator,
        IStatementNode statement) {
      this.whileKeyword = whileKeyword;
      this.leftParenthesisSeparator = leftParenthesisSeparator;
      this.expression = expression;
      this.rightParenthesisSeparator = rightParenthesisSeparator;
      this.statement = statement;
    }

    public SourceToken<WhileKeywordToken> getWhileKeyword() {
      return whileKeyword;
    }

    public SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator() {
      return leftParenthesisSeparator;
    }

    public IExpressionNode getExpression() {
      return expression;
    }

    public SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator() {
      return rightParenthesisSeparator;
    }

    public IStatementNode getStatement() {
      return statement;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (whileKeyword != null) {
        list.add(whileKeyword);
      }
      if (leftParenthesisSeparator != null) {
        list.add(leftParenthesisSeparator);
      }
      if (expression != null) {
        list.add(expression);
      }
      if (rightParenthesisSeparator != null) {
        list.add(rightParenthesisSeparator);
      }
      if (statement != null) {
        list.add(statement);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IWhileStatementNode)) { return false; }
      IWhileStatementNode __node = (IWhileStatementNode) __other;
      if (!equals(whileKeyword, __node.getWhileKeyword())) { return false; }
      if (!equals(leftParenthesisSeparator, __node.getLeftParenthesisSeparator())) { return false; }
      if (!equals(expression, __node.getExpression())) { return false; }
      if (!equals(rightParenthesisSeparator, __node.getRightParenthesisSeparator())) { return false; }
      if (!equals(statement, __node.getStatement())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (whileKeyword == null ? 0 : whileKeyword.hashCode());
      hash = 31 * hash + (leftParenthesisSeparator == null ? 0 : leftParenthesisSeparator.hashCode());
      hash = 31 * hash + (expression == null ? 0 : expression.hashCode());
      hash = 31 * hash + (rightParenthesisSeparator == null ? 0 : rightParenthesisSeparator.hashCode());
      hash = 31 * hash + (statement == null ? 0 : statement.hashCode());
      return hash;
    }

    public String getName() {
      return "IWhileStatementNode";
    }
  }

  public static class DoStatementNode extends AbstractNode implements IDoStatementNode {
    private final SourceToken<DoKeywordToken> doKeyword;
    private final IStatementNode statement;
    private final SourceToken<WhileKeywordToken> whileKeyword;
    private final SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator;
    private final IExpressionNode expression;
    private final SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator;
    private final SourceToken<SemicolonSeparatorToken> semicolonSeparator;

    public DoStatementNode(
        SourceToken<DoKeywordToken> doKeyword,
        IStatementNode statement,
        SourceToken<WhileKeywordToken> whileKeyword,
        SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator,
        IExpressionNode expression,
        SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator,
        SourceToken<SemicolonSeparatorToken> semicolonSeparator) {
      this.doKeyword = doKeyword;
      this.statement = statement;
      this.whileKeyword = whileKeyword;
      this.leftParenthesisSeparator = leftParenthesisSeparator;
      this.expression = expression;
      this.rightParenthesisSeparator = rightParenthesisSeparator;
      this.semicolonSeparator = semicolonSeparator;
    }

    public SourceToken<DoKeywordToken> getDoKeyword() {
      return doKeyword;
    }

    public IStatementNode getStatement() {
      return statement;
    }

    public SourceToken<WhileKeywordToken> getWhileKeyword() {
      return whileKeyword;
    }

    public SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator() {
      return leftParenthesisSeparator;
    }

    public IExpressionNode getExpression() {
      return expression;
    }

    public SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator() {
      return rightParenthesisSeparator;
    }

    public SourceToken<SemicolonSeparatorToken> getSemicolonSeparator() {
      return semicolonSeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (doKeyword != null) {
        list.add(doKeyword);
      }
      if (statement != null) {
        list.add(statement);
      }
      if (whileKeyword != null) {
        list.add(whileKeyword);
      }
      if (leftParenthesisSeparator != null) {
        list.add(leftParenthesisSeparator);
      }
      if (expression != null) {
        list.add(expression);
      }
      if (rightParenthesisSeparator != null) {
        list.add(rightParenthesisSeparator);
      }
      if (semicolonSeparator != null) {
        list.add(semicolonSeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IDoStatementNode)) { return false; }
      IDoStatementNode __node = (IDoStatementNode) __other;
      if (!equals(doKeyword, __node.getDoKeyword())) { return false; }
      if (!equals(statement, __node.getStatement())) { return false; }
      if (!equals(whileKeyword, __node.getWhileKeyword())) { return false; }
      if (!equals(leftParenthesisSeparator, __node.getLeftParenthesisSeparator())) { return false; }
      if (!equals(expression, __node.getExpression())) { return false; }
      if (!equals(rightParenthesisSeparator, __node.getRightParenthesisSeparator())) { return false; }
      if (!equals(semicolonSeparator, __node.getSemicolonSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (doKeyword == null ? 0 : doKeyword.hashCode());
      hash = 31 * hash + (statement == null ? 0 : statement.hashCode());
      hash = 31 * hash + (whileKeyword == null ? 0 : whileKeyword.hashCode());
      hash = 31 * hash + (leftParenthesisSeparator == null ? 0 : leftParenthesisSeparator.hashCode());
      hash = 31 * hash + (expression == null ? 0 : expression.hashCode());
      hash = 31 * hash + (rightParenthesisSeparator == null ? 0 : rightParenthesisSeparator.hashCode());
      hash = 31 * hash + (semicolonSeparator == null ? 0 : semicolonSeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "IDoStatementNode";
    }
  }

  public static class BasicForStatementNode extends AbstractNode implements IBasicForStatementNode {
    private final SourceToken<ForKeywordToken> forKeyword;
    private final SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator;
    private final IForInitializerNode optionalForInitializer;
    private final SourceToken<SemicolonSeparatorToken> semicolonSeparator;
    private final IExpressionNode optionalExpression;
    private final SourceToken<SemicolonSeparatorToken> semicolonSeparator2;
    private final IDelimitedExpressionListNode optionalDelimitedExpressionList;
    private final SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator;
    private final IStatementNode statement;

    public BasicForStatementNode(
        SourceToken<ForKeywordToken> forKeyword,
        SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator,
        IForInitializerNode optionalForInitializer,
        SourceToken<SemicolonSeparatorToken> semicolonSeparator,
        IExpressionNode optionalExpression,
        SourceToken<SemicolonSeparatorToken> semicolonSeparator2,
        IDelimitedExpressionListNode optionalDelimitedExpressionList,
        SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator,
        IStatementNode statement) {
      this.forKeyword = forKeyword;
      this.leftParenthesisSeparator = leftParenthesisSeparator;
      this.optionalForInitializer = optionalForInitializer;
      this.semicolonSeparator = semicolonSeparator;
      this.optionalExpression = optionalExpression;
      this.semicolonSeparator2 = semicolonSeparator2;
      this.optionalDelimitedExpressionList = optionalDelimitedExpressionList;
      this.rightParenthesisSeparator = rightParenthesisSeparator;
      this.statement = statement;
    }

    public SourceToken<ForKeywordToken> getForKeyword() {
      return forKeyword;
    }

    public SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator() {
      return leftParenthesisSeparator;
    }

    public IForInitializerNode getOptionalForInitializer() {
      return optionalForInitializer;
    }

    public SourceToken<SemicolonSeparatorToken> getSemicolonSeparator() {
      return semicolonSeparator;
    }

    public IExpressionNode getOptionalExpression() {
      return optionalExpression;
    }

    public SourceToken<SemicolonSeparatorToken> getSemicolonSeparator2() {
      return semicolonSeparator2;
    }

    public IDelimitedExpressionListNode getOptionalDelimitedExpressionList() {
      return optionalDelimitedExpressionList;
    }

    public SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator() {
      return rightParenthesisSeparator;
    }

    public IStatementNode getStatement() {
      return statement;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (forKeyword != null) {
        list.add(forKeyword);
      }
      if (leftParenthesisSeparator != null) {
        list.add(leftParenthesisSeparator);
      }
      if (optionalForInitializer != null) {
        list.add(optionalForInitializer);
      }
      if (semicolonSeparator != null) {
        list.add(semicolonSeparator);
      }
      if (optionalExpression != null) {
        list.add(optionalExpression);
      }
      if (semicolonSeparator2 != null) {
        list.add(semicolonSeparator2);
      }
      if (optionalDelimitedExpressionList != null) {
        list.add(optionalDelimitedExpressionList);
      }
      if (rightParenthesisSeparator != null) {
        list.add(rightParenthesisSeparator);
      }
      if (statement != null) {
        list.add(statement);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IBasicForStatementNode)) { return false; }
      IBasicForStatementNode __node = (IBasicForStatementNode) __other;
      if (!equals(forKeyword, __node.getForKeyword())) { return false; }
      if (!equals(leftParenthesisSeparator, __node.getLeftParenthesisSeparator())) { return false; }
      if (!equals(optionalForInitializer, __node.getOptionalForInitializer())) { return false; }
      if (!equals(semicolonSeparator, __node.getSemicolonSeparator())) { return false; }
      if (!equals(optionalExpression, __node.getOptionalExpression())) { return false; }
      if (!equals(semicolonSeparator2, __node.getSemicolonSeparator2())) { return false; }
      if (!equals(optionalDelimitedExpressionList, __node.getOptionalDelimitedExpressionList())) { return false; }
      if (!equals(rightParenthesisSeparator, __node.getRightParenthesisSeparator())) { return false; }
      if (!equals(statement, __node.getStatement())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (forKeyword == null ? 0 : forKeyword.hashCode());
      hash = 31 * hash + (leftParenthesisSeparator == null ? 0 : leftParenthesisSeparator.hashCode());
      hash = 31 * hash + (optionalForInitializer == null ? 0 : optionalForInitializer.hashCode());
      hash = 31 * hash + (semicolonSeparator == null ? 0 : semicolonSeparator.hashCode());
      hash = 31 * hash + (optionalExpression == null ? 0 : optionalExpression.hashCode());
      hash = 31 * hash + (semicolonSeparator2 == null ? 0 : semicolonSeparator2.hashCode());
      hash = 31 * hash + (optionalDelimitedExpressionList == null ? 0 : optionalDelimitedExpressionList.hashCode());
      hash = 31 * hash + (rightParenthesisSeparator == null ? 0 : rightParenthesisSeparator.hashCode());
      hash = 31 * hash + (statement == null ? 0 : statement.hashCode());
      return hash;
    }

    public String getName() {
      return "IBasicForStatementNode";
    }
  }

  public static class DelimitedExpressionListNode extends AbstractNode implements IDelimitedExpressionListNode {
    private final DelimitedList<IExpressionNode, SourceToken<CommaSeparatorToken>> expressionList;

    public DelimitedExpressionListNode(
        DelimitedList<IExpressionNode, SourceToken<CommaSeparatorToken>> expressionList) {
      this.expressionList = expressionList;
    }

    public DelimitedList<IExpressionNode, SourceToken<CommaSeparatorToken>> getExpressionList() {
      return expressionList;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (expressionList != null) {
        expressionList.addTo(list);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IDelimitedExpressionListNode)) { return false; }
      IDelimitedExpressionListNode __node = (IDelimitedExpressionListNode) __other;
      if (!equals(expressionList, __node.getExpressionList())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (expressionList == null ? 0 : expressionList.hashCode());
      return hash;
    }

    public String getName() {
      return "IDelimitedExpressionListNode";
    }
  }

  public static class EnhancedForStatementNode extends AbstractNode implements IEnhancedForStatementNode {
    private final SourceToken<ForKeywordToken> forKeyword;
    private final SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator;
    private final IModifiersNode modifiers;
    private final ITypeNode type;
    private final SourceToken<IdentifierToken> identifier;
    private final SourceToken<ColonOperatorToken> colonOperator;
    private final IExpressionNode expression;
    private final SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator;
    private final IStatementNode statement;

    public EnhancedForStatementNode(
        SourceToken<ForKeywordToken> forKeyword,
        SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator,
        IModifiersNode modifiers,
        ITypeNode type,
        SourceToken<IdentifierToken> identifier,
        SourceToken<ColonOperatorToken> colonOperator,
        IExpressionNode expression,
        SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator,
        IStatementNode statement) {
      this.forKeyword = forKeyword;
      this.leftParenthesisSeparator = leftParenthesisSeparator;
      this.modifiers = modifiers;
      this.type = type;
      this.identifier = identifier;
      this.colonOperator = colonOperator;
      this.expression = expression;
      this.rightParenthesisSeparator = rightParenthesisSeparator;
      this.statement = statement;
    }

    public SourceToken<ForKeywordToken> getForKeyword() {
      return forKeyword;
    }

    public SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator() {
      return leftParenthesisSeparator;
    }

    public IModifiersNode getModifiers() {
      return modifiers;
    }

    public ITypeNode getType() {
      return type;
    }

    public SourceToken<IdentifierToken> getIdentifier() {
      return identifier;
    }

    public SourceToken<ColonOperatorToken> getColonOperator() {
      return colonOperator;
    }

    public IExpressionNode getExpression() {
      return expression;
    }

    public SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator() {
      return rightParenthesisSeparator;
    }

    public IStatementNode getStatement() {
      return statement;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (forKeyword != null) {
        list.add(forKeyword);
      }
      if (leftParenthesisSeparator != null) {
        list.add(leftParenthesisSeparator);
      }
      if (modifiers != null) {
        list.add(modifiers);
      }
      if (type != null) {
        list.add(type);
      }
      if (identifier != null) {
        list.add(identifier);
      }
      if (colonOperator != null) {
        list.add(colonOperator);
      }
      if (expression != null) {
        list.add(expression);
      }
      if (rightParenthesisSeparator != null) {
        list.add(rightParenthesisSeparator);
      }
      if (statement != null) {
        list.add(statement);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IEnhancedForStatementNode)) { return false; }
      IEnhancedForStatementNode __node = (IEnhancedForStatementNode) __other;
      if (!equals(forKeyword, __node.getForKeyword())) { return false; }
      if (!equals(leftParenthesisSeparator, __node.getLeftParenthesisSeparator())) { return false; }
      if (!equals(modifiers, __node.getModifiers())) { return false; }
      if (!equals(type, __node.getType())) { return false; }
      if (!equals(identifier, __node.getIdentifier())) { return false; }
      if (!equals(colonOperator, __node.getColonOperator())) { return false; }
      if (!equals(expression, __node.getExpression())) { return false; }
      if (!equals(rightParenthesisSeparator, __node.getRightParenthesisSeparator())) { return false; }
      if (!equals(statement, __node.getStatement())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (forKeyword == null ? 0 : forKeyword.hashCode());
      hash = 31 * hash + (leftParenthesisSeparator == null ? 0 : leftParenthesisSeparator.hashCode());
      hash = 31 * hash + (modifiers == null ? 0 : modifiers.hashCode());
      hash = 31 * hash + (type == null ? 0 : type.hashCode());
      hash = 31 * hash + (identifier == null ? 0 : identifier.hashCode());
      hash = 31 * hash + (colonOperator == null ? 0 : colonOperator.hashCode());
      hash = 31 * hash + (expression == null ? 0 : expression.hashCode());
      hash = 31 * hash + (rightParenthesisSeparator == null ? 0 : rightParenthesisSeparator.hashCode());
      hash = 31 * hash + (statement == null ? 0 : statement.hashCode());
      return hash;
    }

    public String getName() {
      return "IEnhancedForStatementNode";
    }
  }

  public static class BreakStatementNode extends AbstractNode implements IBreakStatementNode {
    private final SourceToken<BreakKeywordToken> breakKeyword;
    private final SourceToken<IdentifierToken> optionalIdentifier;
    private final SourceToken<SemicolonSeparatorToken> semicolonSeparator;

    public BreakStatementNode(
        SourceToken<BreakKeywordToken> breakKeyword,
        SourceToken<IdentifierToken> optionalIdentifier,
        SourceToken<SemicolonSeparatorToken> semicolonSeparator) {
      this.breakKeyword = breakKeyword;
      this.optionalIdentifier = optionalIdentifier;
      this.semicolonSeparator = semicolonSeparator;
    }

    public SourceToken<BreakKeywordToken> getBreakKeyword() {
      return breakKeyword;
    }

    public SourceToken<IdentifierToken> getOptionalIdentifier() {
      return optionalIdentifier;
    }

    public SourceToken<SemicolonSeparatorToken> getSemicolonSeparator() {
      return semicolonSeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (breakKeyword != null) {
        list.add(breakKeyword);
      }
      if (optionalIdentifier != null) {
        list.add(optionalIdentifier);
      }
      if (semicolonSeparator != null) {
        list.add(semicolonSeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IBreakStatementNode)) { return false; }
      IBreakStatementNode __node = (IBreakStatementNode) __other;
      if (!equals(breakKeyword, __node.getBreakKeyword())) { return false; }
      if (!equals(optionalIdentifier, __node.getOptionalIdentifier())) { return false; }
      if (!equals(semicolonSeparator, __node.getSemicolonSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (breakKeyword == null ? 0 : breakKeyword.hashCode());
      hash = 31 * hash + (optionalIdentifier == null ? 0 : optionalIdentifier.hashCode());
      hash = 31 * hash + (semicolonSeparator == null ? 0 : semicolonSeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "IBreakStatementNode";
    }
  }

  public static class ContinueStatementNode extends AbstractNode implements IContinueStatementNode {
    private final SourceToken<ContinueKeywordToken> continueKeyword;
    private final SourceToken<IdentifierToken> optionalIdentifier;
    private final SourceToken<SemicolonSeparatorToken> semicolonSeparator;

    public ContinueStatementNode(
        SourceToken<ContinueKeywordToken> continueKeyword,
        SourceToken<IdentifierToken> optionalIdentifier,
        SourceToken<SemicolonSeparatorToken> semicolonSeparator) {
      this.continueKeyword = continueKeyword;
      this.optionalIdentifier = optionalIdentifier;
      this.semicolonSeparator = semicolonSeparator;
    }

    public SourceToken<ContinueKeywordToken> getContinueKeyword() {
      return continueKeyword;
    }

    public SourceToken<IdentifierToken> getOptionalIdentifier() {
      return optionalIdentifier;
    }

    public SourceToken<SemicolonSeparatorToken> getSemicolonSeparator() {
      return semicolonSeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (continueKeyword != null) {
        list.add(continueKeyword);
      }
      if (optionalIdentifier != null) {
        list.add(optionalIdentifier);
      }
      if (semicolonSeparator != null) {
        list.add(semicolonSeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IContinueStatementNode)) { return false; }
      IContinueStatementNode __node = (IContinueStatementNode) __other;
      if (!equals(continueKeyword, __node.getContinueKeyword())) { return false; }
      if (!equals(optionalIdentifier, __node.getOptionalIdentifier())) { return false; }
      if (!equals(semicolonSeparator, __node.getSemicolonSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (continueKeyword == null ? 0 : continueKeyword.hashCode());
      hash = 31 * hash + (optionalIdentifier == null ? 0 : optionalIdentifier.hashCode());
      hash = 31 * hash + (semicolonSeparator == null ? 0 : semicolonSeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "IContinueStatementNode";
    }
  }

  public static class ReturnStatementNode extends AbstractNode implements IReturnStatementNode {
    private final SourceToken<ReturnKeywordToken> returnKeyword;
    private final IExpressionNode optionalExpression;
    private final SourceToken<SemicolonSeparatorToken> semicolonSeparator;

    public ReturnStatementNode(
        SourceToken<ReturnKeywordToken> returnKeyword,
        IExpressionNode optionalExpression,
        SourceToken<SemicolonSeparatorToken> semicolonSeparator) {
      this.returnKeyword = returnKeyword;
      this.optionalExpression = optionalExpression;
      this.semicolonSeparator = semicolonSeparator;
    }

    public SourceToken<ReturnKeywordToken> getReturnKeyword() {
      return returnKeyword;
    }

    public IExpressionNode getOptionalExpression() {
      return optionalExpression;
    }

    public SourceToken<SemicolonSeparatorToken> getSemicolonSeparator() {
      return semicolonSeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (returnKeyword != null) {
        list.add(returnKeyword);
      }
      if (optionalExpression != null) {
        list.add(optionalExpression);
      }
      if (semicolonSeparator != null) {
        list.add(semicolonSeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IReturnStatementNode)) { return false; }
      IReturnStatementNode __node = (IReturnStatementNode) __other;
      if (!equals(returnKeyword, __node.getReturnKeyword())) { return false; }
      if (!equals(optionalExpression, __node.getOptionalExpression())) { return false; }
      if (!equals(semicolonSeparator, __node.getSemicolonSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (returnKeyword == null ? 0 : returnKeyword.hashCode());
      hash = 31 * hash + (optionalExpression == null ? 0 : optionalExpression.hashCode());
      hash = 31 * hash + (semicolonSeparator == null ? 0 : semicolonSeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "IReturnStatementNode";
    }
  }

  public static class ThrowStatementNode extends AbstractNode implements IThrowStatementNode {
    private final SourceToken<ThrowKeywordToken> throwKeyword;
    private final IExpressionNode optionalExpression;
    private final SourceToken<SemicolonSeparatorToken> semicolonSeparator;

    public ThrowStatementNode(
        SourceToken<ThrowKeywordToken> throwKeyword,
        IExpressionNode optionalExpression,
        SourceToken<SemicolonSeparatorToken> semicolonSeparator) {
      this.throwKeyword = throwKeyword;
      this.optionalExpression = optionalExpression;
      this.semicolonSeparator = semicolonSeparator;
    }

    public SourceToken<ThrowKeywordToken> getThrowKeyword() {
      return throwKeyword;
    }

    public IExpressionNode getOptionalExpression() {
      return optionalExpression;
    }

    public SourceToken<SemicolonSeparatorToken> getSemicolonSeparator() {
      return semicolonSeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (throwKeyword != null) {
        list.add(throwKeyword);
      }
      if (optionalExpression != null) {
        list.add(optionalExpression);
      }
      if (semicolonSeparator != null) {
        list.add(semicolonSeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IThrowStatementNode)) { return false; }
      IThrowStatementNode __node = (IThrowStatementNode) __other;
      if (!equals(throwKeyword, __node.getThrowKeyword())) { return false; }
      if (!equals(optionalExpression, __node.getOptionalExpression())) { return false; }
      if (!equals(semicolonSeparator, __node.getSemicolonSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (throwKeyword == null ? 0 : throwKeyword.hashCode());
      hash = 31 * hash + (optionalExpression == null ? 0 : optionalExpression.hashCode());
      hash = 31 * hash + (semicolonSeparator == null ? 0 : semicolonSeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "IThrowStatementNode";
    }
  }

  public static class SynchronizedStatementNode extends AbstractNode implements ISynchronizedStatementNode {
    private final SourceToken<SynchronizedKeywordToken> synchronizedKeyword;
    private final SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator;
    private final IExpressionNode expression;
    private final SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator;
    private final IBlockNode block;

    public SynchronizedStatementNode(
        SourceToken<SynchronizedKeywordToken> synchronizedKeyword,
        SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator,
        IExpressionNode expression,
        SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator,
        IBlockNode block) {
      this.synchronizedKeyword = synchronizedKeyword;
      this.leftParenthesisSeparator = leftParenthesisSeparator;
      this.expression = expression;
      this.rightParenthesisSeparator = rightParenthesisSeparator;
      this.block = block;
    }

    public SourceToken<SynchronizedKeywordToken> getSynchronizedKeyword() {
      return synchronizedKeyword;
    }

    public SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator() {
      return leftParenthesisSeparator;
    }

    public IExpressionNode getExpression() {
      return expression;
    }

    public SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator() {
      return rightParenthesisSeparator;
    }

    public IBlockNode getBlock() {
      return block;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (synchronizedKeyword != null) {
        list.add(synchronizedKeyword);
      }
      if (leftParenthesisSeparator != null) {
        list.add(leftParenthesisSeparator);
      }
      if (expression != null) {
        list.add(expression);
      }
      if (rightParenthesisSeparator != null) {
        list.add(rightParenthesisSeparator);
      }
      if (block != null) {
        list.add(block);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ISynchronizedStatementNode)) { return false; }
      ISynchronizedStatementNode __node = (ISynchronizedStatementNode) __other;
      if (!equals(synchronizedKeyword, __node.getSynchronizedKeyword())) { return false; }
      if (!equals(leftParenthesisSeparator, __node.getLeftParenthesisSeparator())) { return false; }
      if (!equals(expression, __node.getExpression())) { return false; }
      if (!equals(rightParenthesisSeparator, __node.getRightParenthesisSeparator())) { return false; }
      if (!equals(block, __node.getBlock())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (synchronizedKeyword == null ? 0 : synchronizedKeyword.hashCode());
      hash = 31 * hash + (leftParenthesisSeparator == null ? 0 : leftParenthesisSeparator.hashCode());
      hash = 31 * hash + (expression == null ? 0 : expression.hashCode());
      hash = 31 * hash + (rightParenthesisSeparator == null ? 0 : rightParenthesisSeparator.hashCode());
      hash = 31 * hash + (block == null ? 0 : block.hashCode());
      return hash;
    }

    public String getName() {
      return "ISynchronizedStatementNode";
    }
  }

  public static class TryStatementWithFinallyNode extends AbstractNode implements ITryStatementWithFinallyNode {
    private final SourceToken<TryKeywordToken> tryKeyword;
    private final IBlockNode block;
    private final List<ICatchClauseNode> catchClauseList;
    private final SourceToken<FinallyKeywordToken> finallyKeyword;
    private final IBlockNode block2;

    public TryStatementWithFinallyNode(
        SourceToken<TryKeywordToken> tryKeyword,
        IBlockNode block,
        List<ICatchClauseNode> catchClauseList,
        SourceToken<FinallyKeywordToken> finallyKeyword,
        IBlockNode block2) {
      this.tryKeyword = tryKeyword;
      this.block = block;
      this.catchClauseList = catchClauseList;
      this.finallyKeyword = finallyKeyword;
      this.block2 = block2;
    }

    public SourceToken<TryKeywordToken> getTryKeyword() {
      return tryKeyword;
    }

    public IBlockNode getBlock() {
      return block;
    }

    public List<ICatchClauseNode> getCatchClauseList() {
      return catchClauseList;
    }

    public SourceToken<FinallyKeywordToken> getFinallyKeyword() {
      return finallyKeyword;
    }

    public IBlockNode getBlock2() {
      return block2;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (tryKeyword != null) {
        list.add(tryKeyword);
      }
      if (block != null) {
        list.add(block);
      }
      if (catchClauseList != null) {
        list.addAll(catchClauseList);
      }
      if (finallyKeyword != null) {
        list.add(finallyKeyword);
      }
      if (block2 != null) {
        list.add(block2);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ITryStatementWithFinallyNode)) { return false; }
      ITryStatementWithFinallyNode __node = (ITryStatementWithFinallyNode) __other;
      if (!equals(tryKeyword, __node.getTryKeyword())) { return false; }
      if (!equals(block, __node.getBlock())) { return false; }
      if (!equals(catchClauseList, __node.getCatchClauseList())) { return false; }
      if (!equals(finallyKeyword, __node.getFinallyKeyword())) { return false; }
      if (!equals(block2, __node.getBlock2())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (tryKeyword == null ? 0 : tryKeyword.hashCode());
      hash = 31 * hash + (block == null ? 0 : block.hashCode());
      hash = 31 * hash + (catchClauseList == null ? 0 : catchClauseList.hashCode());
      hash = 31 * hash + (finallyKeyword == null ? 0 : finallyKeyword.hashCode());
      hash = 31 * hash + (block2 == null ? 0 : block2.hashCode());
      return hash;
    }

    public String getName() {
      return "ITryStatementWithFinallyNode";
    }
  }

  public static class TryStatementWithoutFinallyNode extends AbstractNode implements ITryStatementWithoutFinallyNode {
    private final SourceToken<TryKeywordToken> tryKeyword;
    private final IBlockNode block;
    private final List<ICatchClauseNode> catchClauseList;

    public TryStatementWithoutFinallyNode(
        SourceToken<TryKeywordToken> tryKeyword,
        IBlockNode block,
        List<ICatchClauseNode> catchClauseList) {
      this.tryKeyword = tryKeyword;
      this.block = block;
      this.catchClauseList = catchClauseList;
    }

    public SourceToken<TryKeywordToken> getTryKeyword() {
      return tryKeyword;
    }

    public IBlockNode getBlock() {
      return block;
    }

    public List<ICatchClauseNode> getCatchClauseList() {
      return catchClauseList;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (tryKeyword != null) {
        list.add(tryKeyword);
      }
      if (block != null) {
        list.add(block);
      }
      if (catchClauseList != null) {
        list.addAll(catchClauseList);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ITryStatementWithoutFinallyNode)) { return false; }
      ITryStatementWithoutFinallyNode __node = (ITryStatementWithoutFinallyNode) __other;
      if (!equals(tryKeyword, __node.getTryKeyword())) { return false; }
      if (!equals(block, __node.getBlock())) { return false; }
      if (!equals(catchClauseList, __node.getCatchClauseList())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (tryKeyword == null ? 0 : tryKeyword.hashCode());
      hash = 31 * hash + (block == null ? 0 : block.hashCode());
      hash = 31 * hash + (catchClauseList == null ? 0 : catchClauseList.hashCode());
      return hash;
    }

    public String getName() {
      return "ITryStatementWithoutFinallyNode";
    }
  }

  public static class CatchClauseNode extends AbstractNode implements ICatchClauseNode {
    private final SourceToken<CatchKeywordToken> catchKeyword;
    private final SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator;
    private final IFormalParameterNode formalParameter;
    private final SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator;
    private final IBlockNode block;

    public CatchClauseNode(
        SourceToken<CatchKeywordToken> catchKeyword,
        SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator,
        IFormalParameterNode formalParameter,
        SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator,
        IBlockNode block) {
      this.catchKeyword = catchKeyword;
      this.leftParenthesisSeparator = leftParenthesisSeparator;
      this.formalParameter = formalParameter;
      this.rightParenthesisSeparator = rightParenthesisSeparator;
      this.block = block;
    }

    public SourceToken<CatchKeywordToken> getCatchKeyword() {
      return catchKeyword;
    }

    public SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator() {
      return leftParenthesisSeparator;
    }

    public IFormalParameterNode getFormalParameter() {
      return formalParameter;
    }

    public SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator() {
      return rightParenthesisSeparator;
    }

    public IBlockNode getBlock() {
      return block;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (catchKeyword != null) {
        list.add(catchKeyword);
      }
      if (leftParenthesisSeparator != null) {
        list.add(leftParenthesisSeparator);
      }
      if (formalParameter != null) {
        list.add(formalParameter);
      }
      if (rightParenthesisSeparator != null) {
        list.add(rightParenthesisSeparator);
      }
      if (block != null) {
        list.add(block);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ICatchClauseNode)) { return false; }
      ICatchClauseNode __node = (ICatchClauseNode) __other;
      if (!equals(catchKeyword, __node.getCatchKeyword())) { return false; }
      if (!equals(leftParenthesisSeparator, __node.getLeftParenthesisSeparator())) { return false; }
      if (!equals(formalParameter, __node.getFormalParameter())) { return false; }
      if (!equals(rightParenthesisSeparator, __node.getRightParenthesisSeparator())) { return false; }
      if (!equals(block, __node.getBlock())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (catchKeyword == null ? 0 : catchKeyword.hashCode());
      hash = 31 * hash + (leftParenthesisSeparator == null ? 0 : leftParenthesisSeparator.hashCode());
      hash = 31 * hash + (formalParameter == null ? 0 : formalParameter.hashCode());
      hash = 31 * hash + (rightParenthesisSeparator == null ? 0 : rightParenthesisSeparator.hashCode());
      hash = 31 * hash + (block == null ? 0 : block.hashCode());
      return hash;
    }

    public String getName() {
      return "ICatchClauseNode";
    }
  }

  public static class ExpressionNode extends AbstractNode implements IExpressionNode {
    private final DelimitedList<IExpression1Node, IAssignmentOperatorNode> expression1List;

    public ExpressionNode(
        DelimitedList<IExpression1Node, IAssignmentOperatorNode> expression1List) {
      this.expression1List = expression1List;
    }

    public DelimitedList<IExpression1Node, IAssignmentOperatorNode> getExpression1List() {
      return expression1List;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (expression1List != null) {
        expression1List.addTo(list);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IExpressionNode)) { return false; }
      IExpressionNode __node = (IExpressionNode) __other;
      if (!equals(expression1List, __node.getExpression1List())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (expression1List == null ? 0 : expression1List.hashCode());
      return hash;
    }

    public String getName() {
      return "IExpressionNode";
    }
  }

  public static class TernaryExpressionNode extends AbstractNode implements ITernaryExpressionNode {
    private final IExpression2Node expression2;
    private final SourceToken<QuestionMarkOperatorToken> questionMarkOperator;
    private final IExpressionNode expression;
    private final SourceToken<ColonOperatorToken> colonOperator;
    private final IExpression1Node expression1;

    public TernaryExpressionNode(
        IExpression2Node expression2,
        SourceToken<QuestionMarkOperatorToken> questionMarkOperator,
        IExpressionNode expression,
        SourceToken<ColonOperatorToken> colonOperator,
        IExpression1Node expression1) {
      this.expression2 = expression2;
      this.questionMarkOperator = questionMarkOperator;
      this.expression = expression;
      this.colonOperator = colonOperator;
      this.expression1 = expression1;
    }

    public IExpression2Node getExpression2() {
      return expression2;
    }

    public SourceToken<QuestionMarkOperatorToken> getQuestionMarkOperator() {
      return questionMarkOperator;
    }

    public IExpressionNode getExpression() {
      return expression;
    }

    public SourceToken<ColonOperatorToken> getColonOperator() {
      return colonOperator;
    }

    public IExpression1Node getExpression1() {
      return expression1;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (expression2 != null) {
        list.add(expression2);
      }
      if (questionMarkOperator != null) {
        list.add(questionMarkOperator);
      }
      if (expression != null) {
        list.add(expression);
      }
      if (colonOperator != null) {
        list.add(colonOperator);
      }
      if (expression1 != null) {
        list.add(expression1);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ITernaryExpressionNode)) { return false; }
      ITernaryExpressionNode __node = (ITernaryExpressionNode) __other;
      if (!equals(expression2, __node.getExpression2())) { return false; }
      if (!equals(questionMarkOperator, __node.getQuestionMarkOperator())) { return false; }
      if (!equals(expression, __node.getExpression())) { return false; }
      if (!equals(colonOperator, __node.getColonOperator())) { return false; }
      if (!equals(expression1, __node.getExpression1())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (expression2 == null ? 0 : expression2.hashCode());
      hash = 31 * hash + (questionMarkOperator == null ? 0 : questionMarkOperator.hashCode());
      hash = 31 * hash + (expression == null ? 0 : expression.hashCode());
      hash = 31 * hash + (colonOperator == null ? 0 : colonOperator.hashCode());
      hash = 31 * hash + (expression1 == null ? 0 : expression1.hashCode());
      return hash;
    }

    public String getName() {
      return "ITernaryExpressionNode";
    }
  }

  public static class BinaryExpressionNode extends AbstractNode implements IBinaryExpressionNode {
    private final IExpression3Node expression3;
    private final List<IBinaryExpressionRestNode> binaryExpressionRestList;

    public BinaryExpressionNode(
        IExpression3Node expression3,
        List<IBinaryExpressionRestNode> binaryExpressionRestList) {
      this.expression3 = expression3;
      this.binaryExpressionRestList = binaryExpressionRestList;
    }

    public IExpression3Node getExpression3() {
      return expression3;
    }

    public List<IBinaryExpressionRestNode> getBinaryExpressionRestList() {
      return binaryExpressionRestList;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (expression3 != null) {
        list.add(expression3);
      }
      if (binaryExpressionRestList != null) {
        list.addAll(binaryExpressionRestList);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IBinaryExpressionNode)) { return false; }
      IBinaryExpressionNode __node = (IBinaryExpressionNode) __other;
      if (!equals(expression3, __node.getExpression3())) { return false; }
      if (!equals(binaryExpressionRestList, __node.getBinaryExpressionRestList())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (expression3 == null ? 0 : expression3.hashCode());
      hash = 31 * hash + (binaryExpressionRestList == null ? 0 : binaryExpressionRestList.hashCode());
      return hash;
    }

    public String getName() {
      return "IBinaryExpressionNode";
    }
  }

  public static class InfixOperatorBinaryExpressionRestNode extends AbstractNode
      implements IInfixOperatorBinaryExpressionRestNode {
    private final IInfixOperatorNode infixOperator;
    private final IExpression3Node expression3;

    public InfixOperatorBinaryExpressionRestNode(
        IInfixOperatorNode infixOperator,
        IExpression3Node expression3) {
      this.infixOperator = infixOperator;
      this.expression3 = expression3;
    }

    public IInfixOperatorNode getInfixOperator() {
      return infixOperator;
    }

    public IExpression3Node getExpression3() {
      return expression3;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (infixOperator != null) {
        list.add(infixOperator);
      }
      if (expression3 != null) {
        list.add(expression3);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IInfixOperatorBinaryExpressionRestNode)) { return false; }
      IInfixOperatorBinaryExpressionRestNode __node = (IInfixOperatorBinaryExpressionRestNode) __other;
      if (!equals(infixOperator, __node.getInfixOperator())) { return false; }
      if (!equals(expression3, __node.getExpression3())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (infixOperator == null ? 0 : infixOperator.hashCode());
      hash = 31 * hash + (expression3 == null ? 0 : expression3.hashCode());
      return hash;
    }

    public String getName() {
      return "IInfixOperatorBinaryExpressionRestNode";
    }
  }

  public static class InstanceofOperatorBinaryExpressionRestNode extends AbstractNode
      implements IInstanceofOperatorBinaryExpressionRestNode {
    private final SourceToken<InstanceofKeywordToken> instanceofKeyword;
    private final ITypeNode type;

    public InstanceofOperatorBinaryExpressionRestNode(
        SourceToken<InstanceofKeywordToken> instanceofKeyword,
        ITypeNode type) {
      this.instanceofKeyword = instanceofKeyword;
      this.type = type;
    }

    public SourceToken<InstanceofKeywordToken> getInstanceofKeyword() {
      return instanceofKeyword;
    }

    public ITypeNode getType() {
      return type;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (instanceofKeyword != null) {
        list.add(instanceofKeyword);
      }
      if (type != null) {
        list.add(type);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IInstanceofOperatorBinaryExpressionRestNode)) { return false; }
      IInstanceofOperatorBinaryExpressionRestNode __node = (IInstanceofOperatorBinaryExpressionRestNode) __other;
      if (!equals(instanceofKeyword, __node.getInstanceofKeyword())) { return false; }
      if (!equals(type, __node.getType())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (instanceofKeyword == null ? 0 : instanceofKeyword.hashCode());
      hash = 31 * hash + (type == null ? 0 : type.hashCode());
      return hash;
    }

    public String getName() {
      return "IInstanceofOperatorBinaryExpressionRestNode";
    }
  }

  public static class UnsignedRightShiftNode extends AbstractNode implements IUnsignedRightShiftNode {
    private final SourceToken<GreaterThanOperatorToken> greaterThanOperator;
    private final SourceToken<GreaterThanOperatorToken> greaterThanOperator2;
    private final SourceToken<GreaterThanOperatorToken> greaterThanOperator3;

    public UnsignedRightShiftNode(
        SourceToken<GreaterThanOperatorToken> greaterThanOperator,
        SourceToken<GreaterThanOperatorToken> greaterThanOperator2,
        SourceToken<GreaterThanOperatorToken> greaterThanOperator3) {
      this.greaterThanOperator = greaterThanOperator;
      this.greaterThanOperator2 = greaterThanOperator2;
      this.greaterThanOperator3 = greaterThanOperator3;
    }

    public SourceToken<GreaterThanOperatorToken> getGreaterThanOperator() {
      return greaterThanOperator;
    }

    public SourceToken<GreaterThanOperatorToken> getGreaterThanOperator2() {
      return greaterThanOperator2;
    }

    public SourceToken<GreaterThanOperatorToken> getGreaterThanOperator3() {
      return greaterThanOperator3;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (greaterThanOperator != null) {
        list.add(greaterThanOperator);
      }
      if (greaterThanOperator2 != null) {
        list.add(greaterThanOperator2);
      }
      if (greaterThanOperator3 != null) {
        list.add(greaterThanOperator3);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IUnsignedRightShiftNode)) { return false; }
      IUnsignedRightShiftNode __node = (IUnsignedRightShiftNode) __other;
      if (!equals(greaterThanOperator, __node.getGreaterThanOperator())) { return false; }
      if (!equals(greaterThanOperator2, __node.getGreaterThanOperator2())) { return false; }
      if (!equals(greaterThanOperator3, __node.getGreaterThanOperator3())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (greaterThanOperator == null ? 0 : greaterThanOperator.hashCode());
      hash = 31 * hash + (greaterThanOperator2 == null ? 0 : greaterThanOperator2.hashCode());
      hash = 31 * hash + (greaterThanOperator3 == null ? 0 : greaterThanOperator3.hashCode());
      return hash;
    }

    public String getName() {
      return "IUnsignedRightShiftNode";
    }
  }

  public static class SignedRightShiftNode extends AbstractNode implements ISignedRightShiftNode {
    private final SourceToken<GreaterThanOperatorToken> greaterThanOperator;
    private final SourceToken<GreaterThanOperatorToken> greaterThanOperator2;

    public SignedRightShiftNode(
        SourceToken<GreaterThanOperatorToken> greaterThanOperator,
        SourceToken<GreaterThanOperatorToken> greaterThanOperator2) {
      this.greaterThanOperator = greaterThanOperator;
      this.greaterThanOperator2 = greaterThanOperator2;
    }

    public SourceToken<GreaterThanOperatorToken> getGreaterThanOperator() {
      return greaterThanOperator;
    }

    public SourceToken<GreaterThanOperatorToken> getGreaterThanOperator2() {
      return greaterThanOperator2;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (greaterThanOperator != null) {
        list.add(greaterThanOperator);
      }
      if (greaterThanOperator2 != null) {
        list.add(greaterThanOperator2);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ISignedRightShiftNode)) { return false; }
      ISignedRightShiftNode __node = (ISignedRightShiftNode) __other;
      if (!equals(greaterThanOperator, __node.getGreaterThanOperator())) { return false; }
      if (!equals(greaterThanOperator2, __node.getGreaterThanOperator2())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (greaterThanOperator == null ? 0 : greaterThanOperator.hashCode());
      hash = 31 * hash + (greaterThanOperator2 == null ? 0 : greaterThanOperator2.hashCode());
      return hash;
    }

    public String getName() {
      return "ISignedRightShiftNode";
    }
  }

  public static class PrefixExpressionNode extends AbstractNode implements IPrefixExpressionNode {
    private final IPrefixOperatorNode prefixOperator;
    private final IExpression3Node expression3;

    public PrefixExpressionNode(
        IPrefixOperatorNode prefixOperator,
        IExpression3Node expression3) {
      this.prefixOperator = prefixOperator;
      this.expression3 = expression3;
    }

    public IPrefixOperatorNode getPrefixOperator() {
      return prefixOperator;
    }

    public IExpression3Node getExpression3() {
      return expression3;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (prefixOperator != null) {
        list.add(prefixOperator);
      }
      if (expression3 != null) {
        list.add(expression3);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IPrefixExpressionNode)) { return false; }
      IPrefixExpressionNode __node = (IPrefixExpressionNode) __other;
      if (!equals(prefixOperator, __node.getPrefixOperator())) { return false; }
      if (!equals(expression3, __node.getExpression3())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (prefixOperator == null ? 0 : prefixOperator.hashCode());
      hash = 31 * hash + (expression3 == null ? 0 : expression3.hashCode());
      return hash;
    }

    public String getName() {
      return "IPrefixExpressionNode";
    }
  }

  public static class PossibleCastExpression_TypeNode extends AbstractNode implements IPossibleCastExpression_TypeNode {
    private final SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator;
    private final ITypeNode type;
    private final SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator;
    private final IExpression3Node expression3;

    public PossibleCastExpression_TypeNode(
        SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator,
        ITypeNode type,
        SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator,
        IExpression3Node expression3) {
      this.leftParenthesisSeparator = leftParenthesisSeparator;
      this.type = type;
      this.rightParenthesisSeparator = rightParenthesisSeparator;
      this.expression3 = expression3;
    }

    public SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator() {
      return leftParenthesisSeparator;
    }

    public ITypeNode getType() {
      return type;
    }

    public SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator() {
      return rightParenthesisSeparator;
    }

    public IExpression3Node getExpression3() {
      return expression3;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (leftParenthesisSeparator != null) {
        list.add(leftParenthesisSeparator);
      }
      if (type != null) {
        list.add(type);
      }
      if (rightParenthesisSeparator != null) {
        list.add(rightParenthesisSeparator);
      }
      if (expression3 != null) {
        list.add(expression3);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IPossibleCastExpression_TypeNode)) { return false; }
      IPossibleCastExpression_TypeNode __node = (IPossibleCastExpression_TypeNode) __other;
      if (!equals(leftParenthesisSeparator, __node.getLeftParenthesisSeparator())) { return false; }
      if (!equals(type, __node.getType())) { return false; }
      if (!equals(rightParenthesisSeparator, __node.getRightParenthesisSeparator())) { return false; }
      if (!equals(expression3, __node.getExpression3())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (leftParenthesisSeparator == null ? 0 : leftParenthesisSeparator.hashCode());
      hash = 31 * hash + (type == null ? 0 : type.hashCode());
      hash = 31 * hash + (rightParenthesisSeparator == null ? 0 : rightParenthesisSeparator.hashCode());
      hash = 31 * hash + (expression3 == null ? 0 : expression3.hashCode());
      return hash;
    }

    public String getName() {
      return "IPossibleCastExpression_TypeNode";
    }
  }

  public static class PossibleCastExpression_ExpressionNode extends AbstractNode
      implements IPossibleCastExpression_ExpressionNode {
    private final SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator;
    private final IExpressionNode expression;
    private final SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator;
    private final IExpression3Node expression3;

    public PossibleCastExpression_ExpressionNode(
        SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator,
        IExpressionNode expression,
        SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator,
        IExpression3Node expression3) {
      this.leftParenthesisSeparator = leftParenthesisSeparator;
      this.expression = expression;
      this.rightParenthesisSeparator = rightParenthesisSeparator;
      this.expression3 = expression3;
    }

    public SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator() {
      return leftParenthesisSeparator;
    }

    public IExpressionNode getExpression() {
      return expression;
    }

    public SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator() {
      return rightParenthesisSeparator;
    }

    public IExpression3Node getExpression3() {
      return expression3;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (leftParenthesisSeparator != null) {
        list.add(leftParenthesisSeparator);
      }
      if (expression != null) {
        list.add(expression);
      }
      if (rightParenthesisSeparator != null) {
        list.add(rightParenthesisSeparator);
      }
      if (expression3 != null) {
        list.add(expression3);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IPossibleCastExpression_ExpressionNode)) { return false; }
      IPossibleCastExpression_ExpressionNode __node = (IPossibleCastExpression_ExpressionNode) __other;
      if (!equals(leftParenthesisSeparator, __node.getLeftParenthesisSeparator())) { return false; }
      if (!equals(expression, __node.getExpression())) { return false; }
      if (!equals(rightParenthesisSeparator, __node.getRightParenthesisSeparator())) { return false; }
      if (!equals(expression3, __node.getExpression3())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (leftParenthesisSeparator == null ? 0 : leftParenthesisSeparator.hashCode());
      hash = 31 * hash + (expression == null ? 0 : expression.hashCode());
      hash = 31 * hash + (rightParenthesisSeparator == null ? 0 : rightParenthesisSeparator.hashCode());
      hash = 31 * hash + (expression3 == null ? 0 : expression3.hashCode());
      return hash;
    }

    public String getName() {
      return "IPossibleCastExpression_ExpressionNode";
    }
  }

  public static class PrimaryExpressionNode extends AbstractNode implements IPrimaryExpressionNode {
    private final IValueExpressionNode valueExpression;
    private final List<ISelectorNode> selectorList;
    private final IPostfixOperatorNode optionalPostfixOperator;

    public PrimaryExpressionNode(
        IValueExpressionNode valueExpression,
        List<ISelectorNode> selectorList,
        IPostfixOperatorNode optionalPostfixOperator) {
      this.valueExpression = valueExpression;
      this.selectorList = selectorList;
      this.optionalPostfixOperator = optionalPostfixOperator;
    }

    public IValueExpressionNode getValueExpression() {
      return valueExpression;
    }

    public List<ISelectorNode> getSelectorList() {
      return selectorList;
    }

    public IPostfixOperatorNode getOptionalPostfixOperator() {
      return optionalPostfixOperator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (valueExpression != null) {
        list.add(valueExpression);
      }
      if (selectorList != null) {
        list.addAll(selectorList);
      }
      if (optionalPostfixOperator != null) {
        list.add(optionalPostfixOperator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IPrimaryExpressionNode)) { return false; }
      IPrimaryExpressionNode __node = (IPrimaryExpressionNode) __other;
      if (!equals(valueExpression, __node.getValueExpression())) { return false; }
      if (!equals(selectorList, __node.getSelectorList())) { return false; }
      if (!equals(optionalPostfixOperator, __node.getOptionalPostfixOperator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (valueExpression == null ? 0 : valueExpression.hashCode());
      hash = 31 * hash + (selectorList == null ? 0 : selectorList.hashCode());
      hash = 31 * hash + (optionalPostfixOperator == null ? 0 : optionalPostfixOperator.hashCode());
      return hash;
    }

    public String getName() {
      return "IPrimaryExpressionNode";
    }
  }

  public static class ClassAccessNode extends AbstractNode implements IClassAccessNode {
    private final ITypeNode type;
    private final SourceToken<DotSeparatorToken> dotSeparator;
    private final SourceToken<ClassKeywordToken> classKeyword;

    public ClassAccessNode(
        ITypeNode type,
        SourceToken<DotSeparatorToken> dotSeparator,
        SourceToken<ClassKeywordToken> classKeyword) {
      this.type = type;
      this.dotSeparator = dotSeparator;
      this.classKeyword = classKeyword;
    }

    public ITypeNode getType() {
      return type;
    }

    public SourceToken<DotSeparatorToken> getDotSeparator() {
      return dotSeparator;
    }

    public SourceToken<ClassKeywordToken> getClassKeyword() {
      return classKeyword;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (type != null) {
        list.add(type);
      }
      if (dotSeparator != null) {
        list.add(dotSeparator);
      }
      if (classKeyword != null) {
        list.add(classKeyword);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IClassAccessNode)) { return false; }
      IClassAccessNode __node = (IClassAccessNode) __other;
      if (!equals(type, __node.getType())) { return false; }
      if (!equals(dotSeparator, __node.getDotSeparator())) { return false; }
      if (!equals(classKeyword, __node.getClassKeyword())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (type == null ? 0 : type.hashCode());
      hash = 31 * hash + (dotSeparator == null ? 0 : dotSeparator.hashCode());
      hash = 31 * hash + (classKeyword == null ? 0 : classKeyword.hashCode());
      return hash;
    }

    public String getName() {
      return "IClassAccessNode";
    }
  }

  public static class DotSelectorNode extends AbstractNode implements IDotSelectorNode {
    private final SourceToken<DotSeparatorToken> dotSeparator;
    private final IValueExpressionNode valueExpression;

    public DotSelectorNode(
        SourceToken<DotSeparatorToken> dotSeparator,
        IValueExpressionNode valueExpression) {
      this.dotSeparator = dotSeparator;
      this.valueExpression = valueExpression;
    }

    public SourceToken<DotSeparatorToken> getDotSeparator() {
      return dotSeparator;
    }

    public IValueExpressionNode getValueExpression() {
      return valueExpression;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (dotSeparator != null) {
        list.add(dotSeparator);
      }
      if (valueExpression != null) {
        list.add(valueExpression);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IDotSelectorNode)) { return false; }
      IDotSelectorNode __node = (IDotSelectorNode) __other;
      if (!equals(dotSeparator, __node.getDotSeparator())) { return false; }
      if (!equals(valueExpression, __node.getValueExpression())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (dotSeparator == null ? 0 : dotSeparator.hashCode());
      hash = 31 * hash + (valueExpression == null ? 0 : valueExpression.hashCode());
      return hash;
    }

    public String getName() {
      return "IDotSelectorNode";
    }
  }

  public static class ArraySelectorNode extends AbstractNode implements IArraySelectorNode {
    private final SourceToken<LeftBracketSeparatorToken> leftBracketSeparator;
    private final IExpressionNode expression;
    private final SourceToken<RightBracketSeparatorToken> rightBracketSeparator;

    public ArraySelectorNode(
        SourceToken<LeftBracketSeparatorToken> leftBracketSeparator,
        IExpressionNode expression,
        SourceToken<RightBracketSeparatorToken> rightBracketSeparator) {
      this.leftBracketSeparator = leftBracketSeparator;
      this.expression = expression;
      this.rightBracketSeparator = rightBracketSeparator;
    }

    public SourceToken<LeftBracketSeparatorToken> getLeftBracketSeparator() {
      return leftBracketSeparator;
    }

    public IExpressionNode getExpression() {
      return expression;
    }

    public SourceToken<RightBracketSeparatorToken> getRightBracketSeparator() {
      return rightBracketSeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (leftBracketSeparator != null) {
        list.add(leftBracketSeparator);
      }
      if (expression != null) {
        list.add(expression);
      }
      if (rightBracketSeparator != null) {
        list.add(rightBracketSeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IArraySelectorNode)) { return false; }
      IArraySelectorNode __node = (IArraySelectorNode) __other;
      if (!equals(leftBracketSeparator, __node.getLeftBracketSeparator())) { return false; }
      if (!equals(expression, __node.getExpression())) { return false; }
      if (!equals(rightBracketSeparator, __node.getRightBracketSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (leftBracketSeparator == null ? 0 : leftBracketSeparator.hashCode());
      hash = 31 * hash + (expression == null ? 0 : expression.hashCode());
      hash = 31 * hash + (rightBracketSeparator == null ? 0 : rightBracketSeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "IArraySelectorNode";
    }
  }

  public static class ParenthesizedExpressionNode extends AbstractNode implements IParenthesizedExpressionNode {
    private final SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator;
    private final IExpressionNode expression;
    private final SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator;

    public ParenthesizedExpressionNode(
        SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator,
        IExpressionNode expression,
        SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator) {
      this.leftParenthesisSeparator = leftParenthesisSeparator;
      this.expression = expression;
      this.rightParenthesisSeparator = rightParenthesisSeparator;
    }

    public SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator() {
      return leftParenthesisSeparator;
    }

    public IExpressionNode getExpression() {
      return expression;
    }

    public SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator() {
      return rightParenthesisSeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (leftParenthesisSeparator != null) {
        list.add(leftParenthesisSeparator);
      }
      if (expression != null) {
        list.add(expression);
      }
      if (rightParenthesisSeparator != null) {
        list.add(rightParenthesisSeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IParenthesizedExpressionNode)) { return false; }
      IParenthesizedExpressionNode __node = (IParenthesizedExpressionNode) __other;
      if (!equals(leftParenthesisSeparator, __node.getLeftParenthesisSeparator())) { return false; }
      if (!equals(expression, __node.getExpression())) { return false; }
      if (!equals(rightParenthesisSeparator, __node.getRightParenthesisSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (leftParenthesisSeparator == null ? 0 : leftParenthesisSeparator.hashCode());
      hash = 31 * hash + (expression == null ? 0 : expression.hashCode());
      hash = 31 * hash + (rightParenthesisSeparator == null ? 0 : rightParenthesisSeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "IParenthesizedExpressionNode";
    }
  }

  public static class MethodInvocationNode extends AbstractNode implements IMethodInvocationNode {
    private final INonWildcardTypeArgumentsNode optionalNonWildcardTypeArguments;
    private final SourceToken<IdentifierToken> identifier;
    private final IArgumentsNode arguments;

    public MethodInvocationNode(
        INonWildcardTypeArgumentsNode optionalNonWildcardTypeArguments,
        SourceToken<IdentifierToken> identifier,
        IArgumentsNode arguments) {
      this.optionalNonWildcardTypeArguments = optionalNonWildcardTypeArguments;
      this.identifier = identifier;
      this.arguments = arguments;
    }

    public INonWildcardTypeArgumentsNode getOptionalNonWildcardTypeArguments() {
      return optionalNonWildcardTypeArguments;
    }

    public SourceToken<IdentifierToken> getIdentifier() {
      return identifier;
    }

    public IArgumentsNode getArguments() {
      return arguments;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (optionalNonWildcardTypeArguments != null) {
        list.add(optionalNonWildcardTypeArguments);
      }
      if (identifier != null) {
        list.add(identifier);
      }
      if (arguments != null) {
        list.add(arguments);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IMethodInvocationNode)) { return false; }
      IMethodInvocationNode __node = (IMethodInvocationNode) __other;
      if (!equals(optionalNonWildcardTypeArguments, __node.getOptionalNonWildcardTypeArguments())) { return false; }
      if (!equals(identifier, __node.getIdentifier())) { return false; }
      if (!equals(arguments, __node.getArguments())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (optionalNonWildcardTypeArguments == null ? 0 : optionalNonWildcardTypeArguments.hashCode());
      hash = 31 * hash + (identifier == null ? 0 : identifier.hashCode());
      hash = 31 * hash + (arguments == null ? 0 : arguments.hashCode());
      return hash;
    }

    public String getName() {
      return "IMethodInvocationNode";
    }
  }

  public static class ThisConstructorInvocationNode extends AbstractNode implements IThisConstructorInvocationNode {
    private final SourceToken<ThisKeywordToken> thisKeyword;
    private final IArgumentsNode arguments;

    public ThisConstructorInvocationNode(
        SourceToken<ThisKeywordToken> thisKeyword,
        IArgumentsNode arguments) {
      this.thisKeyword = thisKeyword;
      this.arguments = arguments;
    }

    public SourceToken<ThisKeywordToken> getThisKeyword() {
      return thisKeyword;
    }

    public IArgumentsNode getArguments() {
      return arguments;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (thisKeyword != null) {
        list.add(thisKeyword);
      }
      if (arguments != null) {
        list.add(arguments);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IThisConstructorInvocationNode)) { return false; }
      IThisConstructorInvocationNode __node = (IThisConstructorInvocationNode) __other;
      if (!equals(thisKeyword, __node.getThisKeyword())) { return false; }
      if (!equals(arguments, __node.getArguments())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (thisKeyword == null ? 0 : thisKeyword.hashCode());
      hash = 31 * hash + (arguments == null ? 0 : arguments.hashCode());
      return hash;
    }

    public String getName() {
      return "IThisConstructorInvocationNode";
    }
  }

  public static class SuperConstructorInvocationNode extends AbstractNode implements ISuperConstructorInvocationNode {
    private final SourceToken<SuperKeywordToken> superKeyword;
    private final IArgumentsNode arguments;

    public SuperConstructorInvocationNode(
        SourceToken<SuperKeywordToken> superKeyword,
        IArgumentsNode arguments) {
      this.superKeyword = superKeyword;
      this.arguments = arguments;
    }

    public SourceToken<SuperKeywordToken> getSuperKeyword() {
      return superKeyword;
    }

    public IArgumentsNode getArguments() {
      return arguments;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (superKeyword != null) {
        list.add(superKeyword);
      }
      if (arguments != null) {
        list.add(arguments);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ISuperConstructorInvocationNode)) { return false; }
      ISuperConstructorInvocationNode __node = (ISuperConstructorInvocationNode) __other;
      if (!equals(superKeyword, __node.getSuperKeyword())) { return false; }
      if (!equals(arguments, __node.getArguments())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (superKeyword == null ? 0 : superKeyword.hashCode());
      hash = 31 * hash + (arguments == null ? 0 : arguments.hashCode());
      return hash;
    }

    public String getName() {
      return "ISuperConstructorInvocationNode";
    }
  }

  public static class ObjectCreationExpressionNode extends AbstractNode implements IObjectCreationExpressionNode {
    private final SourceToken<NewKeywordToken> newKeyword;
    private final INonWildcardTypeArgumentsNode optionalNonWildcardTypeArguments;
    private final IClassOrInterfaceTypeNode classOrInterfaceType;
    private final IArgumentsNode arguments;
    private final IClassBodyNode optionalClassBody;

    public ObjectCreationExpressionNode(
        SourceToken<NewKeywordToken> newKeyword,
        INonWildcardTypeArgumentsNode optionalNonWildcardTypeArguments,
        IClassOrInterfaceTypeNode classOrInterfaceType,
        IArgumentsNode arguments,
        IClassBodyNode optionalClassBody) {
      this.newKeyword = newKeyword;
      this.optionalNonWildcardTypeArguments = optionalNonWildcardTypeArguments;
      this.classOrInterfaceType = classOrInterfaceType;
      this.arguments = arguments;
      this.optionalClassBody = optionalClassBody;
    }

    public SourceToken<NewKeywordToken> getNewKeyword() {
      return newKeyword;
    }

    public INonWildcardTypeArgumentsNode getOptionalNonWildcardTypeArguments() {
      return optionalNonWildcardTypeArguments;
    }

    public IClassOrInterfaceTypeNode getClassOrInterfaceType() {
      return classOrInterfaceType;
    }

    public IArgumentsNode getArguments() {
      return arguments;
    }

    public IClassBodyNode getOptionalClassBody() {
      return optionalClassBody;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (newKeyword != null) {
        list.add(newKeyword);
      }
      if (optionalNonWildcardTypeArguments != null) {
        list.add(optionalNonWildcardTypeArguments);
      }
      if (classOrInterfaceType != null) {
        list.add(classOrInterfaceType);
      }
      if (arguments != null) {
        list.add(arguments);
      }
      if (optionalClassBody != null) {
        list.add(optionalClassBody);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IObjectCreationExpressionNode)) { return false; }
      IObjectCreationExpressionNode __node = (IObjectCreationExpressionNode) __other;
      if (!equals(newKeyword, __node.getNewKeyword())) { return false; }
      if (!equals(optionalNonWildcardTypeArguments, __node.getOptionalNonWildcardTypeArguments())) { return false; }
      if (!equals(classOrInterfaceType, __node.getClassOrInterfaceType())) { return false; }
      if (!equals(arguments, __node.getArguments())) { return false; }
      if (!equals(optionalClassBody, __node.getOptionalClassBody())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (newKeyword == null ? 0 : newKeyword.hashCode());
      hash = 31 * hash + (optionalNonWildcardTypeArguments == null ? 0 : optionalNonWildcardTypeArguments.hashCode());
      hash = 31 * hash + (classOrInterfaceType == null ? 0 : classOrInterfaceType.hashCode());
      hash = 31 * hash + (arguments == null ? 0 : arguments.hashCode());
      hash = 31 * hash + (optionalClassBody == null ? 0 : optionalClassBody.hashCode());
      return hash;
    }

    public String getName() {
      return "IObjectCreationExpressionNode";
    }
  }

  public static class ArrayCreationExpressionNode extends AbstractNode implements IArrayCreationExpressionNode {
    private final SourceToken<NewKeywordToken> newKeyword;
    private final IArrayCreationTypeNode arrayCreationType;
    private final List<IDimensionExpressionNode> dimensionExpressionList;
    private final IArrayInitializerNode optionalArrayInitializer;

    public ArrayCreationExpressionNode(
        SourceToken<NewKeywordToken> newKeyword,
        IArrayCreationTypeNode arrayCreationType,
        List<IDimensionExpressionNode> dimensionExpressionList,
        IArrayInitializerNode optionalArrayInitializer) {
      this.newKeyword = newKeyword;
      this.arrayCreationType = arrayCreationType;
      this.dimensionExpressionList = dimensionExpressionList;
      this.optionalArrayInitializer = optionalArrayInitializer;
    }

    public SourceToken<NewKeywordToken> getNewKeyword() {
      return newKeyword;
    }

    public IArrayCreationTypeNode getArrayCreationType() {
      return arrayCreationType;
    }

    public List<IDimensionExpressionNode> getDimensionExpressionList() {
      return dimensionExpressionList;
    }

    public IArrayInitializerNode getOptionalArrayInitializer() {
      return optionalArrayInitializer;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (newKeyword != null) {
        list.add(newKeyword);
      }
      if (arrayCreationType != null) {
        list.add(arrayCreationType);
      }
      if (dimensionExpressionList != null) {
        list.addAll(dimensionExpressionList);
      }
      if (optionalArrayInitializer != null) {
        list.add(optionalArrayInitializer);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IArrayCreationExpressionNode)) { return false; }
      IArrayCreationExpressionNode __node = (IArrayCreationExpressionNode) __other;
      if (!equals(newKeyword, __node.getNewKeyword())) { return false; }
      if (!equals(arrayCreationType, __node.getArrayCreationType())) { return false; }
      if (!equals(dimensionExpressionList, __node.getDimensionExpressionList())) { return false; }
      if (!equals(optionalArrayInitializer, __node.getOptionalArrayInitializer())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (newKeyword == null ? 0 : newKeyword.hashCode());
      hash = 31 * hash + (arrayCreationType == null ? 0 : arrayCreationType.hashCode());
      hash = 31 * hash + (dimensionExpressionList == null ? 0 : dimensionExpressionList.hashCode());
      hash = 31 * hash + (optionalArrayInitializer == null ? 0 : optionalArrayInitializer.hashCode());
      return hash;
    }

    public String getName() {
      return "IArrayCreationExpressionNode";
    }
  }

  public static class DimensionExpressionNode extends AbstractNode implements IDimensionExpressionNode {
    private final SourceToken<LeftBracketSeparatorToken> leftBracketSeparator;
    private final IExpressionNode optionalExpression;
    private final SourceToken<RightBracketSeparatorToken> rightBracketSeparator;

    public DimensionExpressionNode(
        SourceToken<LeftBracketSeparatorToken> leftBracketSeparator,
        IExpressionNode optionalExpression,
        SourceToken<RightBracketSeparatorToken> rightBracketSeparator) {
      this.leftBracketSeparator = leftBracketSeparator;
      this.optionalExpression = optionalExpression;
      this.rightBracketSeparator = rightBracketSeparator;
    }

    public SourceToken<LeftBracketSeparatorToken> getLeftBracketSeparator() {
      return leftBracketSeparator;
    }

    public IExpressionNode getOptionalExpression() {
      return optionalExpression;
    }

    public SourceToken<RightBracketSeparatorToken> getRightBracketSeparator() {
      return rightBracketSeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (leftBracketSeparator != null) {
        list.add(leftBracketSeparator);
      }
      if (optionalExpression != null) {
        list.add(optionalExpression);
      }
      if (rightBracketSeparator != null) {
        list.add(rightBracketSeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IDimensionExpressionNode)) { return false; }
      IDimensionExpressionNode __node = (IDimensionExpressionNode) __other;
      if (!equals(leftBracketSeparator, __node.getLeftBracketSeparator())) { return false; }
      if (!equals(optionalExpression, __node.getOptionalExpression())) { return false; }
      if (!equals(rightBracketSeparator, __node.getRightBracketSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (leftBracketSeparator == null ? 0 : leftBracketSeparator.hashCode());
      hash = 31 * hash + (optionalExpression == null ? 0 : optionalExpression.hashCode());
      hash = 31 * hash + (rightBracketSeparator == null ? 0 : rightBracketSeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "IDimensionExpressionNode";
    }
  }

  public static class ArrayInitializerNode extends AbstractNode implements IArrayInitializerNode {
    private final SourceToken<LeftCurlySeparatorToken> leftCurlySeparator;
    private final DelimitedList<IVariableInitializerNode, SourceToken<CommaSeparatorToken>> optionalVariableInitializerList;
    private final SourceToken<RightCurlySeparatorToken> rightCurlySeparator;

    public ArrayInitializerNode(
        SourceToken<LeftCurlySeparatorToken> leftCurlySeparator,
        DelimitedList<IVariableInitializerNode, SourceToken<CommaSeparatorToken>> optionalVariableInitializerList,
        SourceToken<RightCurlySeparatorToken> rightCurlySeparator) {
      this.leftCurlySeparator = leftCurlySeparator;
      this.optionalVariableInitializerList = optionalVariableInitializerList;
      this.rightCurlySeparator = rightCurlySeparator;
    }

    public SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator() {
      return leftCurlySeparator;
    }

    public DelimitedList<IVariableInitializerNode, SourceToken<CommaSeparatorToken>> getOptionalVariableInitializerList() {
      return optionalVariableInitializerList;
    }

    public SourceToken<RightCurlySeparatorToken> getRightCurlySeparator() {
      return rightCurlySeparator;
    }

    protected List<Object> getChildrenWorker() {
      List<Object> list = new ArrayList<Object>();
      if (leftCurlySeparator != null) {
        list.add(leftCurlySeparator);
      }
      if (optionalVariableInitializerList != null) {
        optionalVariableInitializerList.addTo(list);
      }
      if (rightCurlySeparator != null) {
        list.add(rightCurlySeparator);
      }
      return trimList(list);
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IArrayInitializerNode)) { return false; }
      IArrayInitializerNode __node = (IArrayInitializerNode) __other;
      if (!equals(leftCurlySeparator, __node.getLeftCurlySeparator())) { return false; }
      if (!equals(optionalVariableInitializerList, __node.getOptionalVariableInitializerList())) { return false; }
      if (!equals(rightCurlySeparator, __node.getRightCurlySeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (leftCurlySeparator == null ? 0 : leftCurlySeparator.hashCode());
      hash = 31 * hash + (optionalVariableInitializerList == null ? 0 : optionalVariableInitializerList.hashCode());
      hash = 31 * hash + (rightCurlySeparator == null ? 0 : rightCurlySeparator.hashCode());
      return hash;
    }

    public String getName() {
      return "IArrayInitializerNode";
    }
  }
}
