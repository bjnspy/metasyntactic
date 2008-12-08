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
import org.metasyntactic.automata.compiler.java.scanner.operators.*;
import org.metasyntactic.automata.compiler.java.scanner.separators.*;

import java.util.List;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class Nodes {
  public interface INode {
    void accept(INodeVisitor visitor);
  }

  public interface INodeVisitor {
    void visit(ICompilationUnitNode node);

    void visit(IPackageDeclarationNode node);

    void visit(IQualifiedIdentifierNode node);

    void visit(IImportDeclarationNode node);

    void visit(ISingleTypeImportDeclarationNode node);

    void visit(ITypeImportOnDemandDeclarationNode node);

    void visit(ISingleStaticImportDeclarationNode node);

    void visit(IStaticImportOnDemandDeclarationNode node);

    void visit(ITypeDeclarationNode node);

    void visit(IClassDeclarationNode node);

    void visit(INormalClassDeclarationNode node);

    void visit(IModifiersNode node);

    void visit(IModifierNode node);

    void visit(ISuperNode node);

    void visit(IInterfacesNode node);

    void visit(IClassBodyNode node);

    void visit(IClassBodyDeclarationNode node);

    void visit(IStaticInitializerNode node);

    void visit(IInterfaceDeclarationNode node);

    void visit(INormalInterfaceDeclarationNode node);

    void visit(IExtendsInterfacesNode node);

    void visit(IClassOrInterfaceBodyNode node);

    void visit(IEnumDeclarationNode node);

    void visit(IEnumBodyNode node);

    void visit(IEnumConstantNode node);

    void visit(IArgumentsNode node);

    void visit(IAnnotationDeclarationNode node);

    void visit(IAnnotationBodyNode node);

    void visit(IAnnotationElementDeclarationNode node);

    void visit(IAnnotationDefaultDeclarationNode node);

    void visit(IClassOrInterfaceMemberDeclarationNode node);

    void visit(IConstructorDeclarationNode node);

    void visit(IFieldDeclarationNode node);

    void visit(IVariableDeclaratorNode node);

    void visit(IVariableDeclaratorIdAndAssignmentNode node);

    void visit(IVariableDeclaratorAssignmentNode node);

    void visit(IVariableDeclaratorIdNode node);

    void visit(IBracketPairNode node);

    void visit(IMethodDeclarationNode node);

    void visit(IMethodBodyNode node);

    void visit(IFormalParameterNode node);

    void visit(IThrowsNode node);

    void visit(ITypeParametersNode node);

    void visit(ITypeParameterNode node);

    void visit(ITypeBoundNode node);

    void visit(ITypeNode node);

    void visit(IReferenceTypeNode node);

    void visit(IPrimitiveArrayReferenceTypeNode node);

    void visit(IClassOrInterfaceReferenceTypeNode node);

    void visit(IClassOrInterfaceTypeNode node);

    void visit(ISingleClassOrInterfaceTypeNode node);

    void visit(ITypeArgumentsNode node);

    void visit(ITypeArgumentNode node);

    void visit(IWildcardTypeArgumentNode node);

    void visit(IExtendsWildcardTypeArgumentNode node);

    void visit(ISuperWildcardTypeArgumentNode node);

    void visit(IOpenWildcardTypeArgumentNode node);

    void visit(INonWildcardTypeArgumentsNode node);

    void visit(IPrimitiveTypeNode node);

    void visit(IAnnotationNode node);

    void visit(INormalAnnotationNode node);

    void visit(IElementValuePairNode node);

    void visit(ISingleElementAnnotationNode node);

    void visit(IMarkerAnnotationNode node);

    void visit(IElementValueNode node);

    void visit(IElementValueArrayInitializerNode node);

    void visit(IBlockNode node);

    void visit(IBlockStatementNode node);

    void visit(ILocalVariableDeclarationStatementNode node);

    void visit(ILocalVariableDeclarationNode node);

    void visit(IStatementNode node);

    void visit(IEmptyStatementNode node);

    void visit(ILabeledStatementNode node);

    void visit(IExpressionStatementNode node);

    void visit(IIfStatementNode node);

    void visit(IElseStatementNode node);

    void visit(IAssertStatementNode node);

    void visit(IMessageAssertStatementNode node);

    void visit(ISimpleAssertStatementNode node);

    void visit(ISwitchStatementNode node);

    void visit(ISwitchBlockStatementGroupNode node);

    void visit(ISwitchLabelNode node);

    void visit(ICaseSwitchLabelNode node);

    void visit(IDefaultSwitchLabelNode node);

    void visit(IWhileStatementNode node);

    void visit(IDoStatementNode node);

    void visit(IForStatementNode node);

    void visit(IBasicForStatementNode node);

    void visit(IForInitializerNode node);

    void visit(IForUpdateNode node);

    void visit(IEnhancedForStatementNode node);

    void visit(IBreakStatementNode node);

    void visit(IContinueStatementNode node);

    void visit(IReturnStatementNode node);

    void visit(IThrowStatementNode node);

    void visit(ISynchronizedStatementNode node);

    void visit(ITryStatementNode node);

    void visit(ITryStatementWithFinallyNode node);

    void visit(ITryStatementWithoutFinallyNode node);

    void visit(ICatchClauseNode node);

    void visit(IExpressionNode node);

    void visit(IAssignmentOperatorNode node);

    void visit(IExpression1Node node);

    void visit(ITernaryExpressionNode node);

    void visit(IExpression2Node node);

    void visit(IBinaryExpressionNode node);

    void visit(IBinaryExpressionRestNode node);

    void visit(IInfixOperatorBinaryExpressionRestNode node);

    void visit(IInstanceofOperatorBinaryExpressionRestNode node);

    void visit(IInfixOperatorNode node);

    void visit(IExpression3Node node);

    void visit(IPrefixExpressionNode node);

    void visit(IPrefixOperatorNode node);

    void visit(IPossibleCastExpressionNode node);

    void visit(IPossibleCastExpression_TypeNode node);

    void visit(IPossibleCastExpression_ExpressionNode node);

    void visit(IPrimaryExpressionNode node);

    void visit(IPostfixOperatorNode node);

    void visit(IValueExpressionNode node);

    void visit(IClassAccessNode node);

    void visit(ISelectorNode node);

    void visit(IDotSelectorNode node);

    void visit(IArraySelectorNode node);

    void visit(IParenthesizedExpressionNode node);

    void visit(IMethodInvocationNode node);

    void visit(IThisConstructorInvocationNode node);

    void visit(ISuperConstructorInvocationNode node);

    void visit(ICreationExpressionNode node);

    void visit(IObjectCreationExpressionNode node);

    void visit(IArrayCreationExpressionNode node);

    void visit(IArrayCreationTypeNode node);

    void visit(IDimensionExpressionNode node);

    void visit(IArrayInitializerNode node);

    void visit(IVariableInitializerNode node);
  }

  public abstract class AbstractNode implements INode {
    private int hashCode;

    public int hashCode() {
      if (hashCode == 0) {
        hashCode = hashCodeWorker();
      }
      return hashCode;
    }

    protected abstract int hashCodeWorker();

    protected boolean equals(Object o1, Object o2) {
      return o1 == null ? o2 == null : o1.equals(o2);
    }
  }

  public interface ICompilationUnitNode extends INode {
    IPackageDeclarationNode getOptionalPackageDeclaration();

    List<IImportDeclarationNode> getImportDeclarationList();

    List<ITypeDeclarationNode> getTypeDeclarationList();
  }

  public class CompilationUnitNode extends AbstractNode implements ICompilationUnitNode {
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
  }

  public interface IPackageDeclarationNode extends INode {
    List<IAnnotationNode> getAnnotationList();

    SourceToken<PackageKeywordToken> getPackageKeyword();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class PackageDeclarationNode extends AbstractNode implements IPackageDeclarationNode {
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
  }

  public interface IQualifiedIdentifierNode extends INode {
    List<SourceToken<IdentifierToken>> getIdentifierList();
  }

  public class QualifiedIdentifierNode extends AbstractNode implements IQualifiedIdentifierNode {
    private final List<SourceToken<IdentifierToken>> identifierList;

    public QualifiedIdentifierNode(
        List<SourceToken<IdentifierToken>> identifierList) {
      this.identifierList = identifierList;
    }

    public List<SourceToken<IdentifierToken>> getIdentifierList() {
      return identifierList;
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
  }

  public interface IImportDeclarationNode extends INode {
  }

  public class ImportDeclarationNode extends AbstractNode implements IImportDeclarationNode {
    public ImportDeclarationNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IImportDeclarationNode)) { return false; }
      IImportDeclarationNode __node = (IImportDeclarationNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface ISingleTypeImportDeclarationNode extends INode, IImportDeclarationNode {
    SourceToken<ImportKeywordToken> getImportKeyword();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class SingleTypeImportDeclarationNode extends AbstractNode implements ISingleTypeImportDeclarationNode {
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
  }

  public interface ITypeImportOnDemandDeclarationNode extends INode, IImportDeclarationNode {
    SourceToken<ImportKeywordToken> getImportKeyword();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SourceToken<DotSeparatorToken> getDotSeparator();

    SourceToken<TimesOperatorToken> getTimesOperator();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class TypeImportOnDemandDeclarationNode extends AbstractNode implements ITypeImportOnDemandDeclarationNode {
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
  }

  public interface ISingleStaticImportDeclarationNode extends INode, IImportDeclarationNode {
    SourceToken<ImportKeywordToken> getImportKeyword();

    SourceToken<StaticKeywordToken> getStaticKeyword();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class SingleStaticImportDeclarationNode extends AbstractNode implements ISingleStaticImportDeclarationNode {
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
  }

  public interface IStaticImportOnDemandDeclarationNode extends INode, IImportDeclarationNode {
    SourceToken<ImportKeywordToken> getImportKeyword();

    SourceToken<StaticKeywordToken> getStaticKeyword();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SourceToken<DotSeparatorToken> getDotSeparator();

    SourceToken<TimesOperatorToken> getTimesOperator();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class StaticImportOnDemandDeclarationNode extends AbstractNode
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
  }

  public interface ITypeDeclarationNode extends INode, IClassOrInterfaceMemberDeclarationNode {
  }

  public class TypeDeclarationNode extends AbstractNode implements ITypeDeclarationNode {
    public TypeDeclarationNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ITypeDeclarationNode)) { return false; }
      ITypeDeclarationNode __node = (ITypeDeclarationNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IClassDeclarationNode extends INode, IBlockStatementNode, ITypeDeclarationNode {
  }

  public class ClassDeclarationNode extends AbstractNode implements IClassDeclarationNode {
    public ClassDeclarationNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IClassDeclarationNode)) { return false; }
      IClassDeclarationNode __node = (IClassDeclarationNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface INormalClassDeclarationNode extends INode, IClassDeclarationNode {
    IModifiersNode getModifiers();

    SourceToken<ClassKeywordToken> getClassKeyword();

    SourceToken<IdentifierToken> getIdentifier();

    ITypeParametersNode getOptionalTypeParameters();

    ISuperNode getOptionalSuper();

    IInterfacesNode getOptionalInterfaces();

    IClassBodyNode getClassBody();
  }

  public class NormalClassDeclarationNode extends AbstractNode implements INormalClassDeclarationNode {
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
  }

  public interface IModifiersNode extends INode {
    List<IModifierNode> getModifierList();
  }

  public class ModifiersNode extends AbstractNode implements IModifiersNode {
    private final List<IModifierNode> modifierList;

    public ModifiersNode(
        List<IModifierNode> modifierList) {
      this.modifierList = modifierList;
    }

    public List<IModifierNode> getModifierList() {
      return modifierList;
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
  }

  public interface IModifierNode extends INode {
  }

  public class ModifierNode extends AbstractNode implements IModifierNode {
    public ModifierNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IModifierNode)) { return false; }
      IModifierNode __node = (IModifierNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface ISuperNode extends INode {
    SourceToken<ExtendsKeywordToken> getExtendsKeyword();

    IClassOrInterfaceTypeNode getClassOrInterfaceType();
  }

  public class SuperNode extends AbstractNode implements ISuperNode {
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
  }

  public interface IInterfacesNode extends INode {
    SourceToken<ImplementsKeywordToken> getImplementsKeyword();

    List<IClassOrInterfaceTypeNode> getClassOrInterfaceTypeList();
  }

  public class InterfacesNode extends AbstractNode implements IInterfacesNode {
    private final SourceToken<ImplementsKeywordToken> implementsKeyword;
    private final List<IClassOrInterfaceTypeNode> classOrInterfaceTypeList;

    public InterfacesNode(
        SourceToken<ImplementsKeywordToken> implementsKeyword,
        List<IClassOrInterfaceTypeNode> classOrInterfaceTypeList) {
      this.implementsKeyword = implementsKeyword;
      this.classOrInterfaceTypeList = classOrInterfaceTypeList;
    }

    public SourceToken<ImplementsKeywordToken> getImplementsKeyword() {
      return implementsKeyword;
    }

    public List<IClassOrInterfaceTypeNode> getClassOrInterfaceTypeList() {
      return classOrInterfaceTypeList;
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
  }

  public interface IClassBodyNode extends INode {
    SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator();

    List<IClassBodyDeclarationNode> getClassBodyDeclarationList();

    SourceToken<RightCurlySeparatorToken> getRightCurlySeparator();
  }

  public class ClassBodyNode extends AbstractNode implements IClassBodyNode {
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
  }

  public interface IClassBodyDeclarationNode extends INode {
  }

  public class ClassBodyDeclarationNode extends AbstractNode implements IClassBodyDeclarationNode {
    public ClassBodyDeclarationNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IClassBodyDeclarationNode)) { return false; }
      IClassBodyDeclarationNode __node = (IClassBodyDeclarationNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IStaticInitializerNode extends INode, IClassBodyDeclarationNode {
    SourceToken<StaticKeywordToken> getStaticKeyword();

    IBlockNode getBlock();
  }

  public class StaticInitializerNode extends AbstractNode implements IStaticInitializerNode {
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
  }

  public interface IInterfaceDeclarationNode extends INode, ITypeDeclarationNode {
  }

  public class InterfaceDeclarationNode extends AbstractNode implements IInterfaceDeclarationNode {
    public InterfaceDeclarationNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IInterfaceDeclarationNode)) { return false; }
      IInterfaceDeclarationNode __node = (IInterfaceDeclarationNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface INormalInterfaceDeclarationNode extends INode, IInterfaceDeclarationNode {
    IModifiersNode getModifiers();

    SourceToken<InterfaceKeywordToken> getInterfaceKeyword();

    SourceToken<IdentifierToken> getIdentifier();

    ITypeParametersNode getOptionalTypeParameters();

    IExtendsInterfacesNode getOptionalExtendsInterfaces();

    IClassOrInterfaceBodyNode getClassOrInterfaceBody();
  }

  public class NormalInterfaceDeclarationNode extends AbstractNode implements INormalInterfaceDeclarationNode {
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
  }

  public interface IExtendsInterfacesNode extends INode {
    SourceToken<ExtendsKeywordToken> getExtendsKeyword();

    List<IClassOrInterfaceTypeNode> getClassOrInterfaceTypeList();
  }

  public class ExtendsInterfacesNode extends AbstractNode implements IExtendsInterfacesNode {
    private final SourceToken<ExtendsKeywordToken> extendsKeyword;
    private final List<IClassOrInterfaceTypeNode> classOrInterfaceTypeList;

    public ExtendsInterfacesNode(
        SourceToken<ExtendsKeywordToken> extendsKeyword,
        List<IClassOrInterfaceTypeNode> classOrInterfaceTypeList) {
      this.extendsKeyword = extendsKeyword;
      this.classOrInterfaceTypeList = classOrInterfaceTypeList;
    }

    public SourceToken<ExtendsKeywordToken> getExtendsKeyword() {
      return extendsKeyword;
    }

    public List<IClassOrInterfaceTypeNode> getClassOrInterfaceTypeList() {
      return classOrInterfaceTypeList;
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
  }

  public interface IClassOrInterfaceBodyNode extends INode {
    SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator();

    List<IClassOrInterfaceMemberDeclarationNode> getClassOrInterfaceMemberDeclarationList();

    SourceToken<RightCurlySeparatorToken> getRightCurlySeparator();
  }

  public class ClassOrInterfaceBodyNode extends AbstractNode implements IClassOrInterfaceBodyNode {
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
  }

  public interface IEnumDeclarationNode extends INode, IClassDeclarationNode {
    IModifiersNode getModifiers();

    SourceToken<EnumKeywordToken> getEnumKeyword();

    SourceToken<IdentifierToken> getIdentifier();

    IInterfacesNode getOptionalInterfaces();

    IEnumBodyNode getEnumBody();
  }

  public class EnumDeclarationNode extends AbstractNode implements IEnumDeclarationNode {
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
  }

  public interface IEnumBodyNode extends INode {
    SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator();

    List<IEnumConstantNode> getOptionalEnumConstantList();

    SourceToken<CommaSeparatorToken> getOptionalCommaSeparator();

    SourceToken<SemicolonSeparatorToken> getOptionalSemicolonSeparator();

    List<IClassBodyDeclarationNode> getClassBodyDeclarationList();

    SourceToken<RightCurlySeparatorToken> getRightCurlySeparator();
  }

  public class EnumBodyNode extends AbstractNode implements IEnumBodyNode {
    private final SourceToken<LeftCurlySeparatorToken> leftCurlySeparator;
    private final List<IEnumConstantNode> optionalEnumConstantList;
    private final SourceToken<CommaSeparatorToken> optionalCommaSeparator;
    private final SourceToken<SemicolonSeparatorToken> optionalSemicolonSeparator;
    private final List<IClassBodyDeclarationNode> classBodyDeclarationList;
    private final SourceToken<RightCurlySeparatorToken> rightCurlySeparator;

    public EnumBodyNode(
        SourceToken<LeftCurlySeparatorToken> leftCurlySeparator,
        List<IEnumConstantNode> optionalEnumConstantList,
        SourceToken<CommaSeparatorToken> optionalCommaSeparator,
        SourceToken<SemicolonSeparatorToken> optionalSemicolonSeparator,
        List<IClassBodyDeclarationNode> classBodyDeclarationList,
        SourceToken<RightCurlySeparatorToken> rightCurlySeparator) {
      this.leftCurlySeparator = leftCurlySeparator;
      this.optionalEnumConstantList = optionalEnumConstantList;
      this.optionalCommaSeparator = optionalCommaSeparator;
      this.optionalSemicolonSeparator = optionalSemicolonSeparator;
      this.classBodyDeclarationList = classBodyDeclarationList;
      this.rightCurlySeparator = rightCurlySeparator;
    }

    public SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator() {
      return leftCurlySeparator;
    }

    public List<IEnumConstantNode> getOptionalEnumConstantList() {
      return optionalEnumConstantList;
    }

    public SourceToken<CommaSeparatorToken> getOptionalCommaSeparator() {
      return optionalCommaSeparator;
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
      if (!equals(optionalCommaSeparator, __node.getOptionalCommaSeparator())) { return false; }
      if (!equals(optionalSemicolonSeparator, __node.getOptionalSemicolonSeparator())) { return false; }
      if (!equals(classBodyDeclarationList, __node.getClassBodyDeclarationList())) { return false; }
      if (!equals(rightCurlySeparator, __node.getRightCurlySeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (leftCurlySeparator == null ? 0 : leftCurlySeparator.hashCode());
      hash = 31 * hash + (optionalEnumConstantList == null ? 0 : optionalEnumConstantList.hashCode());
      hash = 31 * hash + (optionalCommaSeparator == null ? 0 : optionalCommaSeparator.hashCode());
      hash = 31 * hash + (optionalSemicolonSeparator == null ? 0 : optionalSemicolonSeparator.hashCode());
      hash = 31 * hash + (classBodyDeclarationList == null ? 0 : classBodyDeclarationList.hashCode());
      hash = 31 * hash + (rightCurlySeparator == null ? 0 : rightCurlySeparator.hashCode());
      return hash;
    }
  }

  public interface IEnumConstantNode extends INode {
    List<IAnnotationNode> getAnnotationList();

    SourceToken<IdentifierToken> getIdentifier();

    IArgumentsNode getOptionalArguments();

    IClassOrInterfaceBodyNode getOptionalClassOrInterfaceBody();
  }

  public class EnumConstantNode extends AbstractNode implements IEnumConstantNode {
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
  }

  public interface IArgumentsNode extends INode {
    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    List<IExpressionNode> getOptionalExpressionList();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();
  }

  public class ArgumentsNode extends AbstractNode implements IArgumentsNode {
    private final SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator;
    private final List<IExpressionNode> optionalExpressionList;
    private final SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator;

    public ArgumentsNode(
        SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator,
        List<IExpressionNode> optionalExpressionList,
        SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator) {
      this.leftParenthesisSeparator = leftParenthesisSeparator;
      this.optionalExpressionList = optionalExpressionList;
      this.rightParenthesisSeparator = rightParenthesisSeparator;
    }

    public SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator() {
      return leftParenthesisSeparator;
    }

    public List<IExpressionNode> getOptionalExpressionList() {
      return optionalExpressionList;
    }

    public SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator() {
      return rightParenthesisSeparator;
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
      if (!equals(optionalExpressionList, __node.getOptionalExpressionList())) { return false; }
      if (!equals(rightParenthesisSeparator, __node.getRightParenthesisSeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (leftParenthesisSeparator == null ? 0 : leftParenthesisSeparator.hashCode());
      hash = 31 * hash + (optionalExpressionList == null ? 0 : optionalExpressionList.hashCode());
      hash = 31 * hash + (rightParenthesisSeparator == null ? 0 : rightParenthesisSeparator.hashCode());
      return hash;
    }
  }

  public interface IAnnotationDeclarationNode extends INode, IInterfaceDeclarationNode {
    IModifiersNode getModifiers();

    SourceToken<AtSeparatorToken> getAtSeparator();

    SourceToken<InterfaceKeywordToken> getInterfaceKeyword();

    SourceToken<IdentifierToken> getIdentifier();

    IAnnotationBodyNode getAnnotationBody();
  }

  public class AnnotationDeclarationNode extends AbstractNode implements IAnnotationDeclarationNode {
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
  }

  public interface IAnnotationBodyNode extends INode {
    SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator();

    List<IAnnotationElementDeclarationNode> getAnnotationElementDeclarationList();

    SourceToken<RightCurlySeparatorToken> getRightCurlySeparator();
  }

  public class AnnotationBodyNode extends AbstractNode implements IAnnotationBodyNode {
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
  }

  public interface IAnnotationElementDeclarationNode extends INode {
  }

  public class AnnotationElementDeclarationNode extends AbstractNode implements IAnnotationElementDeclarationNode {
    public AnnotationElementDeclarationNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IAnnotationElementDeclarationNode)) { return false; }
      IAnnotationElementDeclarationNode __node = (IAnnotationElementDeclarationNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IAnnotationDefaultDeclarationNode extends INode, IAnnotationElementDeclarationNode {
    IModifiersNode getModifiers();

    ITypeNode getType();

    SourceToken<IdentifierToken> getIdentifier();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    SourceToken<DefaultKeywordToken> getDefaultKeyword();

    IElementValueNode getElementValue();
  }

  public class AnnotationDefaultDeclarationNode extends AbstractNode implements IAnnotationDefaultDeclarationNode {
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
  }

  public interface IClassOrInterfaceMemberDeclarationNode
      extends INode, IClassBodyDeclarationNode, IAnnotationElementDeclarationNode {
  }

  public class ClassOrInterfaceMemberDeclarationNode extends AbstractNode
      implements IClassOrInterfaceMemberDeclarationNode {
    public ClassOrInterfaceMemberDeclarationNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IClassOrInterfaceMemberDeclarationNode)) { return false; }
      IClassOrInterfaceMemberDeclarationNode __node = (IClassOrInterfaceMemberDeclarationNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IConstructorDeclarationNode extends INode, IClassBodyDeclarationNode {
    IModifiersNode getModifiers();

    ITypeParametersNode getOptionalTypeParameters();

    SourceToken<IdentifierToken> getIdentifier();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    List<IFormalParameterNode> getOptionalFormalParameterList();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    IThrowsNode getOptionalThrows();

    IBlockNode getBlock();
  }

  public class ConstructorDeclarationNode extends AbstractNode implements IConstructorDeclarationNode {
    private final IModifiersNode modifiers;
    private final ITypeParametersNode optionalTypeParameters;
    private final SourceToken<IdentifierToken> identifier;
    private final SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator;
    private final List<IFormalParameterNode> optionalFormalParameterList;
    private final SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator;
    private final IThrowsNode optionalThrows;
    private final IBlockNode block;

    public ConstructorDeclarationNode(
        IModifiersNode modifiers,
        ITypeParametersNode optionalTypeParameters,
        SourceToken<IdentifierToken> identifier,
        SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator,
        List<IFormalParameterNode> optionalFormalParameterList,
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

    public List<IFormalParameterNode> getOptionalFormalParameterList() {
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
  }

  public interface IFieldDeclarationNode extends INode, IClassOrInterfaceMemberDeclarationNode {
    IModifiersNode getModifiers();

    ITypeNode getType();

    List<IVariableDeclaratorNode> getVariableDeclaratorList();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class FieldDeclarationNode extends AbstractNode implements IFieldDeclarationNode {
    private final IModifiersNode modifiers;
    private final ITypeNode type;
    private final List<IVariableDeclaratorNode> variableDeclaratorList;
    private final SourceToken<SemicolonSeparatorToken> semicolonSeparator;

    public FieldDeclarationNode(
        IModifiersNode modifiers,
        ITypeNode type,
        List<IVariableDeclaratorNode> variableDeclaratorList,
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

    public List<IVariableDeclaratorNode> getVariableDeclaratorList() {
      return variableDeclaratorList;
    }

    public SourceToken<SemicolonSeparatorToken> getSemicolonSeparator() {
      return semicolonSeparator;
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
  }

  public interface IVariableDeclaratorNode extends INode {
  }

  public class VariableDeclaratorNode extends AbstractNode implements IVariableDeclaratorNode {
    public VariableDeclaratorNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IVariableDeclaratorNode)) { return false; }
      IVariableDeclaratorNode __node = (IVariableDeclaratorNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IVariableDeclaratorIdAndAssignmentNode extends INode, IVariableDeclaratorNode {
    IVariableDeclaratorIdNode getVariableDeclaratorId();

    SourceToken<EqualsOperatorToken> getEqualsOperator();

    IVariableDeclaratorAssignmentNode getVariableDeclaratorAssignment();
  }

  public class VariableDeclaratorIdAndAssignmentNode extends AbstractNode
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
  }

  public interface IVariableDeclaratorAssignmentNode extends INode {
  }

  public class VariableDeclaratorAssignmentNode extends AbstractNode implements IVariableDeclaratorAssignmentNode {
    public VariableDeclaratorAssignmentNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IVariableDeclaratorAssignmentNode)) { return false; }
      IVariableDeclaratorAssignmentNode __node = (IVariableDeclaratorAssignmentNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IVariableDeclaratorIdNode extends INode, IVariableDeclaratorNode {
    SourceToken<IdentifierToken> getIdentifier();

    List<IBracketPairNode> getBracketPairList();
  }

  public class VariableDeclaratorIdNode extends AbstractNode implements IVariableDeclaratorIdNode {
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
  }

  public interface IBracketPairNode extends INode {
    SourceToken<LeftBracketSeparatorToken> getLeftBracketSeparator();

    SourceToken<RightBracketSeparatorToken> getRightBracketSeparator();
  }

  public class BracketPairNode extends AbstractNode implements IBracketPairNode {
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
  }

  public interface IMethodDeclarationNode extends INode, IClassOrInterfaceMemberDeclarationNode {
    IModifiersNode getModifiers();

    ITypeParametersNode getOptionalTypeParameters();

    ITypeNode getType();

    SourceToken<IdentifierToken> getIdentifier();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    List<IFormalParameterNode> getOptionalFormalParameterList();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    List<IBracketPairNode> getBracketPairList();

    IThrowsNode getOptionalThrows();

    IMethodBodyNode getMethodBody();
  }

  public class MethodDeclarationNode extends AbstractNode implements IMethodDeclarationNode {
    private final IModifiersNode modifiers;
    private final ITypeParametersNode optionalTypeParameters;
    private final ITypeNode type;
    private final SourceToken<IdentifierToken> identifier;
    private final SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator;
    private final List<IFormalParameterNode> optionalFormalParameterList;
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
        List<IFormalParameterNode> optionalFormalParameterList,
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

    public List<IFormalParameterNode> getOptionalFormalParameterList() {
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
  }

  public interface IMethodBodyNode extends INode {
  }

  public class MethodBodyNode extends AbstractNode implements IMethodBodyNode {
    public MethodBodyNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IMethodBodyNode)) { return false; }
      IMethodBodyNode __node = (IMethodBodyNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IFormalParameterNode extends INode {
    IModifiersNode getModifiers();

    ITypeNode getType();

    SourceToken<EllipsisSeparatorToken> getOptionalEllipsisSeparator();

    IVariableDeclaratorIdNode getVariableDeclaratorId();
  }

  public class FormalParameterNode extends AbstractNode implements IFormalParameterNode {
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
  }

  public interface IThrowsNode extends INode {
    SourceToken<ThrowsKeywordToken> getThrowsKeyword();

    List<IClassOrInterfaceTypeNode> getClassOrInterfaceTypeList();
  }

  public class ThrowsNode extends AbstractNode implements IThrowsNode {
    private final SourceToken<ThrowsKeywordToken> throwsKeyword;
    private final List<IClassOrInterfaceTypeNode> classOrInterfaceTypeList;

    public ThrowsNode(
        SourceToken<ThrowsKeywordToken> throwsKeyword,
        List<IClassOrInterfaceTypeNode> classOrInterfaceTypeList) {
      this.throwsKeyword = throwsKeyword;
      this.classOrInterfaceTypeList = classOrInterfaceTypeList;
    }

    public SourceToken<ThrowsKeywordToken> getThrowsKeyword() {
      return throwsKeyword;
    }

    public List<IClassOrInterfaceTypeNode> getClassOrInterfaceTypeList() {
      return classOrInterfaceTypeList;
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
  }

  public interface ITypeParametersNode extends INode {
    SourceToken<LessThanOperatorToken> getLessThanOperator();

    List<ITypeParameterNode> getTypeParameterList();

    SourceToken<GreaterThanOperatorToken> getGreaterThanOperator();
  }

  public class TypeParametersNode extends AbstractNode implements ITypeParametersNode {
    private final SourceToken<LessThanOperatorToken> lessThanOperator;
    private final List<ITypeParameterNode> typeParameterList;
    private final SourceToken<GreaterThanOperatorToken> greaterThanOperator;

    public TypeParametersNode(
        SourceToken<LessThanOperatorToken> lessThanOperator,
        List<ITypeParameterNode> typeParameterList,
        SourceToken<GreaterThanOperatorToken> greaterThanOperator) {
      this.lessThanOperator = lessThanOperator;
      this.typeParameterList = typeParameterList;
      this.greaterThanOperator = greaterThanOperator;
    }

    public SourceToken<LessThanOperatorToken> getLessThanOperator() {
      return lessThanOperator;
    }

    public List<ITypeParameterNode> getTypeParameterList() {
      return typeParameterList;
    }

    public SourceToken<GreaterThanOperatorToken> getGreaterThanOperator() {
      return greaterThanOperator;
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
  }

  public interface ITypeParameterNode extends INode {
    SourceToken<IdentifierToken> getIdentifier();

    ITypeBoundNode getOptionalTypeBound();
  }

  public class TypeParameterNode extends AbstractNode implements ITypeParameterNode {
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
  }

  public interface ITypeBoundNode extends INode {
    SourceToken<ExtendsKeywordToken> getExtendsKeyword();

    List<IClassOrInterfaceTypeNode> getClassOrInterfaceTypeList();
  }

  public class TypeBoundNode extends AbstractNode implements ITypeBoundNode {
    private final SourceToken<ExtendsKeywordToken> extendsKeyword;
    private final List<IClassOrInterfaceTypeNode> classOrInterfaceTypeList;

    public TypeBoundNode(
        SourceToken<ExtendsKeywordToken> extendsKeyword,
        List<IClassOrInterfaceTypeNode> classOrInterfaceTypeList) {
      this.extendsKeyword = extendsKeyword;
      this.classOrInterfaceTypeList = classOrInterfaceTypeList;
    }

    public SourceToken<ExtendsKeywordToken> getExtendsKeyword() {
      return extendsKeyword;
    }

    public List<IClassOrInterfaceTypeNode> getClassOrInterfaceTypeList() {
      return classOrInterfaceTypeList;
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
  }

  public interface ITypeNode extends INode {
  }

  public class TypeNode extends AbstractNode implements ITypeNode {
    public TypeNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ITypeNode)) { return false; }
      ITypeNode __node = (ITypeNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IReferenceTypeNode extends INode, ITypeArgumentNode, ITypeNode {
  }

  public class ReferenceTypeNode extends AbstractNode implements IReferenceTypeNode {
    public ReferenceTypeNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IReferenceTypeNode)) { return false; }
      IReferenceTypeNode __node = (IReferenceTypeNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IPrimitiveArrayReferenceTypeNode extends INode, IReferenceTypeNode {
    IPrimitiveTypeNode getPrimitiveType();

    List<IBracketPairNode> getBracketPairList();
  }

  public class PrimitiveArrayReferenceTypeNode extends AbstractNode implements IPrimitiveArrayReferenceTypeNode {
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
  }

  public interface IClassOrInterfaceReferenceTypeNode extends INode, IReferenceTypeNode {
    IClassOrInterfaceTypeNode getClassOrInterfaceType();

    List<IBracketPairNode> getBracketPairList();
  }

  public class ClassOrInterfaceReferenceTypeNode extends AbstractNode implements IClassOrInterfaceReferenceTypeNode {
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
  }

  public interface IClassOrInterfaceTypeNode extends INode, IArrayCreationTypeNode {
    List<ISingleClassOrInterfaceTypeNode> getSingleClassOrInterfaceTypeList();
  }

  public class ClassOrInterfaceTypeNode extends AbstractNode implements IClassOrInterfaceTypeNode {
    private final List<ISingleClassOrInterfaceTypeNode> singleClassOrInterfaceTypeList;

    public ClassOrInterfaceTypeNode(
        List<ISingleClassOrInterfaceTypeNode> singleClassOrInterfaceTypeList) {
      this.singleClassOrInterfaceTypeList = singleClassOrInterfaceTypeList;
    }

    public List<ISingleClassOrInterfaceTypeNode> getSingleClassOrInterfaceTypeList() {
      return singleClassOrInterfaceTypeList;
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
  }

  public interface ISingleClassOrInterfaceTypeNode extends INode {
    SourceToken<IdentifierToken> getIdentifier();

    ITypeArgumentsNode getOptionalTypeArguments();
  }

  public class SingleClassOrInterfaceTypeNode extends AbstractNode implements ISingleClassOrInterfaceTypeNode {
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
  }

  public interface ITypeArgumentsNode extends INode {
    SourceToken<LessThanOperatorToken> getLessThanOperator();

    List<ITypeArgumentNode> getTypeArgumentList();

    SourceToken<GreaterThanOperatorToken> getGreaterThanOperator();
  }

  public class TypeArgumentsNode extends AbstractNode implements ITypeArgumentsNode {
    private final SourceToken<LessThanOperatorToken> lessThanOperator;
    private final List<ITypeArgumentNode> typeArgumentList;
    private final SourceToken<GreaterThanOperatorToken> greaterThanOperator;

    public TypeArgumentsNode(
        SourceToken<LessThanOperatorToken> lessThanOperator,
        List<ITypeArgumentNode> typeArgumentList,
        SourceToken<GreaterThanOperatorToken> greaterThanOperator) {
      this.lessThanOperator = lessThanOperator;
      this.typeArgumentList = typeArgumentList;
      this.greaterThanOperator = greaterThanOperator;
    }

    public SourceToken<LessThanOperatorToken> getLessThanOperator() {
      return lessThanOperator;
    }

    public List<ITypeArgumentNode> getTypeArgumentList() {
      return typeArgumentList;
    }

    public SourceToken<GreaterThanOperatorToken> getGreaterThanOperator() {
      return greaterThanOperator;
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
  }

  public interface ITypeArgumentNode extends INode {
  }

  public class TypeArgumentNode extends AbstractNode implements ITypeArgumentNode {
    public TypeArgumentNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ITypeArgumentNode)) { return false; }
      ITypeArgumentNode __node = (ITypeArgumentNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IWildcardTypeArgumentNode extends INode, ITypeArgumentNode {
  }

  public class WildcardTypeArgumentNode extends AbstractNode implements IWildcardTypeArgumentNode {
    public WildcardTypeArgumentNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IWildcardTypeArgumentNode)) { return false; }
      IWildcardTypeArgumentNode __node = (IWildcardTypeArgumentNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IExtendsWildcardTypeArgumentNode extends INode, IWildcardTypeArgumentNode {
    SourceToken<QuestionMarkOperatorToken> getQuestionMarkOperator();

    SourceToken<ExtendsKeywordToken> getExtendsKeyword();

    IReferenceTypeNode getReferenceType();
  }

  public class ExtendsWildcardTypeArgumentNode extends AbstractNode implements IExtendsWildcardTypeArgumentNode {
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
  }

  public interface ISuperWildcardTypeArgumentNode extends INode, IWildcardTypeArgumentNode {
    SourceToken<QuestionMarkOperatorToken> getQuestionMarkOperator();

    SourceToken<SuperKeywordToken> getSuperKeyword();

    IReferenceTypeNode getReferenceType();
  }

  public class SuperWildcardTypeArgumentNode extends AbstractNode implements ISuperWildcardTypeArgumentNode {
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
  }

  public interface IOpenWildcardTypeArgumentNode extends INode, IWildcardTypeArgumentNode {
    SourceToken<QuestionMarkOperatorToken> getQuestionMarkOperator();
  }

  public class OpenWildcardTypeArgumentNode extends AbstractNode implements IOpenWildcardTypeArgumentNode {
    private final SourceToken<QuestionMarkOperatorToken> questionMarkOperator;

    public OpenWildcardTypeArgumentNode(
        SourceToken<QuestionMarkOperatorToken> questionMarkOperator) {
      this.questionMarkOperator = questionMarkOperator;
    }

    public SourceToken<QuestionMarkOperatorToken> getQuestionMarkOperator() {
      return questionMarkOperator;
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
  }

  public interface INonWildcardTypeArgumentsNode extends INode {
    SourceToken<LessThanOperatorToken> getLessThanOperator();

    List<IReferenceTypeNode> getReferenceTypeList();

    SourceToken<GreaterThanOperatorToken> getGreaterThanOperator();
  }

  public class NonWildcardTypeArgumentsNode extends AbstractNode implements INonWildcardTypeArgumentsNode {
    private final SourceToken<LessThanOperatorToken> lessThanOperator;
    private final List<IReferenceTypeNode> referenceTypeList;
    private final SourceToken<GreaterThanOperatorToken> greaterThanOperator;

    public NonWildcardTypeArgumentsNode(
        SourceToken<LessThanOperatorToken> lessThanOperator,
        List<IReferenceTypeNode> referenceTypeList,
        SourceToken<GreaterThanOperatorToken> greaterThanOperator) {
      this.lessThanOperator = lessThanOperator;
      this.referenceTypeList = referenceTypeList;
      this.greaterThanOperator = greaterThanOperator;
    }

    public SourceToken<LessThanOperatorToken> getLessThanOperator() {
      return lessThanOperator;
    }

    public List<IReferenceTypeNode> getReferenceTypeList() {
      return referenceTypeList;
    }

    public SourceToken<GreaterThanOperatorToken> getGreaterThanOperator() {
      return greaterThanOperator;
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
  }

  public interface IPrimitiveTypeNode extends INode, IArrayCreationTypeNode, ITypeNode {
  }

  public class PrimitiveTypeNode extends AbstractNode implements IPrimitiveTypeNode {
    public PrimitiveTypeNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IPrimitiveTypeNode)) { return false; }
      IPrimitiveTypeNode __node = (IPrimitiveTypeNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IAnnotationNode extends INode, IElementValueNode, IModifierNode {
  }

  public class AnnotationNode extends AbstractNode implements IAnnotationNode {
    public AnnotationNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IAnnotationNode)) { return false; }
      IAnnotationNode __node = (IAnnotationNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface INormalAnnotationNode extends INode, IAnnotationNode {
    SourceToken<AtSeparatorToken> getAtSeparator();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    List<IElementValuePairNode> getOptionalElementValuePairList();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();
  }

  public class NormalAnnotationNode extends AbstractNode implements INormalAnnotationNode {
    private final SourceToken<AtSeparatorToken> atSeparator;
    private final IQualifiedIdentifierNode qualifiedIdentifier;
    private final SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator;
    private final List<IElementValuePairNode> optionalElementValuePairList;
    private final SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator;

    public NormalAnnotationNode(
        SourceToken<AtSeparatorToken> atSeparator,
        IQualifiedIdentifierNode qualifiedIdentifier,
        SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator,
        List<IElementValuePairNode> optionalElementValuePairList,
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

    public List<IElementValuePairNode> getOptionalElementValuePairList() {
      return optionalElementValuePairList;
    }

    public SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator() {
      return rightParenthesisSeparator;
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
  }

  public interface IElementValuePairNode extends INode {
    SourceToken<IdentifierToken> getIdentifier();

    SourceToken<EqualsOperatorToken> getEqualsOperator();

    IElementValueNode getElementValue();
  }

  public class ElementValuePairNode extends AbstractNode implements IElementValuePairNode {
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
  }

  public interface ISingleElementAnnotationNode extends INode, IAnnotationNode {
    SourceToken<AtSeparatorToken> getAtSeparator();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IElementValueNode getElementValue();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();
  }

  public class SingleElementAnnotationNode extends AbstractNode implements ISingleElementAnnotationNode {
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
  }

  public interface IMarkerAnnotationNode extends INode, IAnnotationNode {
    SourceToken<AtSeparatorToken> getAtSeparator();

    IQualifiedIdentifierNode getQualifiedIdentifier();
  }

  public class MarkerAnnotationNode extends AbstractNode implements IMarkerAnnotationNode {
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
  }

  public interface IElementValueNode extends INode {
  }

  public class ElementValueNode extends AbstractNode implements IElementValueNode {
    public ElementValueNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IElementValueNode)) { return false; }
      IElementValueNode __node = (IElementValueNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IElementValueArrayInitializerNode extends INode, IElementValueNode {
    SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator();

    List<IElementValueNode> getOptionalElementValueList();

    SourceToken<CommaSeparatorToken> getOptionalCommaSeparator();

    SourceToken<RightCurlySeparatorToken> getRightCurlySeparator();
  }

  public class ElementValueArrayInitializerNode extends AbstractNode implements IElementValueArrayInitializerNode {
    private final SourceToken<LeftCurlySeparatorToken> leftCurlySeparator;
    private final List<IElementValueNode> optionalElementValueList;
    private final SourceToken<CommaSeparatorToken> optionalCommaSeparator;
    private final SourceToken<RightCurlySeparatorToken> rightCurlySeparator;

    public ElementValueArrayInitializerNode(
        SourceToken<LeftCurlySeparatorToken> leftCurlySeparator,
        List<IElementValueNode> optionalElementValueList,
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

    public List<IElementValueNode> getOptionalElementValueList() {
      return optionalElementValueList;
    }

    public SourceToken<CommaSeparatorToken> getOptionalCommaSeparator() {
      return optionalCommaSeparator;
    }

    public SourceToken<RightCurlySeparatorToken> getRightCurlySeparator() {
      return rightCurlySeparator;
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
  }

  public interface IBlockNode extends INode, IClassBodyDeclarationNode, IStatementNode, IMethodBodyNode {
    SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator();

    List<IBlockStatementNode> getBlockStatementList();

    SourceToken<RightCurlySeparatorToken> getRightCurlySeparator();
  }

  public class BlockNode extends AbstractNode implements IBlockNode {
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
  }

  public interface IBlockStatementNode extends INode {
  }

  public class BlockStatementNode extends AbstractNode implements IBlockStatementNode {
    public BlockStatementNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IBlockStatementNode)) { return false; }
      IBlockStatementNode __node = (IBlockStatementNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface ILocalVariableDeclarationStatementNode extends INode, IBlockStatementNode {
    ILocalVariableDeclarationNode getLocalVariableDeclaration();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class LocalVariableDeclarationStatementNode extends AbstractNode
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
  }

  public interface ILocalVariableDeclarationNode extends INode, IForInitializerNode {
    IModifiersNode getModifiers();

    ITypeNode getType();

    List<IVariableDeclaratorNode> getVariableDeclaratorList();
  }

  public class LocalVariableDeclarationNode extends AbstractNode implements ILocalVariableDeclarationNode {
    private final IModifiersNode modifiers;
    private final ITypeNode type;
    private final List<IVariableDeclaratorNode> variableDeclaratorList;

    public LocalVariableDeclarationNode(
        IModifiersNode modifiers,
        ITypeNode type,
        List<IVariableDeclaratorNode> variableDeclaratorList) {
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

    public List<IVariableDeclaratorNode> getVariableDeclaratorList() {
      return variableDeclaratorList;
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
  }

  public interface IStatementNode extends INode, IBlockStatementNode {
  }

  public class StatementNode extends AbstractNode implements IStatementNode {
    public StatementNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IStatementNode)) { return false; }
      IStatementNode __node = (IStatementNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IEmptyStatementNode extends INode, IStatementNode {
    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class EmptyStatementNode extends AbstractNode implements IEmptyStatementNode {
    private final SourceToken<SemicolonSeparatorToken> semicolonSeparator;

    public EmptyStatementNode(
        SourceToken<SemicolonSeparatorToken> semicolonSeparator) {
      this.semicolonSeparator = semicolonSeparator;
    }

    public SourceToken<SemicolonSeparatorToken> getSemicolonSeparator() {
      return semicolonSeparator;
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
  }

  public interface ILabeledStatementNode extends INode, IStatementNode {
    SourceToken<IdentifierToken> getIdentifier();

    SourceToken<ColonOperatorToken> getColonOperator();

    IStatementNode getStatement();
  }

  public class LabeledStatementNode extends AbstractNode implements ILabeledStatementNode {
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
  }

  public interface IExpressionStatementNode extends INode, IStatementNode {
    IExpressionNode getExpression();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class ExpressionStatementNode extends AbstractNode implements IExpressionStatementNode {
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
  }

  public interface IIfStatementNode extends INode, IStatementNode {
    SourceToken<IfKeywordToken> getIfKeyword();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    IStatementNode getStatement();

    IElseStatementNode getOptionalElseStatement();
  }

  public class IfStatementNode extends AbstractNode implements IIfStatementNode {
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
  }

  public interface IElseStatementNode extends INode {
    SourceToken<ElseKeywordToken> getElseKeyword();

    IStatementNode getStatement();
  }

  public class ElseStatementNode extends AbstractNode implements IElseStatementNode {
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
  }

  public interface IAssertStatementNode extends INode, IStatementNode {
  }

  public class AssertStatementNode extends AbstractNode implements IAssertStatementNode {
    public AssertStatementNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IAssertStatementNode)) { return false; }
      IAssertStatementNode __node = (IAssertStatementNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IMessageAssertStatementNode extends INode, IAssertStatementNode {
    SourceToken<AssertKeywordToken> getAssertKeyword();

    IExpressionNode getExpression();

    SourceToken<ColonOperatorToken> getColonOperator();

    IExpressionNode getExpression2();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class MessageAssertStatementNode extends AbstractNode implements IMessageAssertStatementNode {
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
  }

  public interface ISimpleAssertStatementNode extends INode, IAssertStatementNode {
    SourceToken<AssertKeywordToken> getAssertKeyword();

    IExpressionNode getExpression();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class SimpleAssertStatementNode extends AbstractNode implements ISimpleAssertStatementNode {
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
  }

  public interface ISwitchStatementNode extends INode, IStatementNode {
    SourceToken<SwitchKeywordToken> getSwitchKeyword();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator();

    List<ISwitchBlockStatementGroupNode> getSwitchBlockStatementGroupList();

    List<ISwitchLabelNode> getSwitchLabelList();

    SourceToken<RightCurlySeparatorToken> getRightCurlySeparator();
  }

  public class SwitchStatementNode extends AbstractNode implements ISwitchStatementNode {
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
  }

  public interface ISwitchBlockStatementGroupNode extends INode {
    List<ISwitchLabelNode> getSwitchLabelList();

    List<IBlockStatementNode> getBlockStatementList();
  }

  public class SwitchBlockStatementGroupNode extends AbstractNode implements ISwitchBlockStatementGroupNode {
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
  }

  public interface ISwitchLabelNode extends INode {
  }

  public class SwitchLabelNode extends AbstractNode implements ISwitchLabelNode {
    public SwitchLabelNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ISwitchLabelNode)) { return false; }
      ISwitchLabelNode __node = (ISwitchLabelNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface ICaseSwitchLabelNode extends INode, ISwitchLabelNode {
    SourceToken<CaseKeywordToken> getCaseKeyword();

    IExpressionNode getExpression();

    SourceToken<ColonOperatorToken> getColonOperator();
  }

  public class CaseSwitchLabelNode extends AbstractNode implements ICaseSwitchLabelNode {
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
  }

  public interface IDefaultSwitchLabelNode extends INode, ISwitchLabelNode {
    SourceToken<DefaultKeywordToken> getDefaultKeyword();

    SourceToken<ColonOperatorToken> getColonOperator();
  }

  public class DefaultSwitchLabelNode extends AbstractNode implements IDefaultSwitchLabelNode {
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
  }

  public interface IWhileStatementNode extends INode, IStatementNode {
    SourceToken<WhileKeywordToken> getWhileKeyword();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    IStatementNode getStatement();
  }

  public class WhileStatementNode extends AbstractNode implements IWhileStatementNode {
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
  }

  public interface IDoStatementNode extends INode, IStatementNode {
    SourceToken<DoKeywordToken> getDoKeyword();

    IStatementNode getStatement();

    SourceToken<WhileKeywordToken> getWhileKeyword();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class DoStatementNode extends AbstractNode implements IDoStatementNode {
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
  }

  public interface IForStatementNode extends INode, IStatementNode {
  }

  public class ForStatementNode extends AbstractNode implements IForStatementNode {
    public ForStatementNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IForStatementNode)) { return false; }
      IForStatementNode __node = (IForStatementNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IBasicForStatementNode extends INode, IForStatementNode {
    SourceToken<ForKeywordToken> getForKeyword();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IForInitializerNode getOptionalForInitializer();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();

    IExpressionNode getOptionalExpression();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator2();

    IForUpdateNode getOptionalForUpdate();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    IStatementNode getStatement();
  }

  public class BasicForStatementNode extends AbstractNode implements IBasicForStatementNode {
    private final SourceToken<ForKeywordToken> forKeyword;
    private final SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator;
    private final IForInitializerNode optionalForInitializer;
    private final SourceToken<SemicolonSeparatorToken> semicolonSeparator;
    private final IExpressionNode optionalExpression;
    private final SourceToken<SemicolonSeparatorToken> semicolonSeparator2;
    private final IForUpdateNode optionalForUpdate;
    private final SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator;
    private final IStatementNode statement;

    public BasicForStatementNode(
        SourceToken<ForKeywordToken> forKeyword,
        SourceToken<LeftParenthesisSeparatorToken> leftParenthesisSeparator,
        IForInitializerNode optionalForInitializer,
        SourceToken<SemicolonSeparatorToken> semicolonSeparator,
        IExpressionNode optionalExpression,
        SourceToken<SemicolonSeparatorToken> semicolonSeparator2,
        IForUpdateNode optionalForUpdate,
        SourceToken<RightParenthesisSeparatorToken> rightParenthesisSeparator,
        IStatementNode statement) {
      this.forKeyword = forKeyword;
      this.leftParenthesisSeparator = leftParenthesisSeparator;
      this.optionalForInitializer = optionalForInitializer;
      this.semicolonSeparator = semicolonSeparator;
      this.optionalExpression = optionalExpression;
      this.semicolonSeparator2 = semicolonSeparator2;
      this.optionalForUpdate = optionalForUpdate;
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

    public IForUpdateNode getOptionalForUpdate() {
      return optionalForUpdate;
    }

    public SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator() {
      return rightParenthesisSeparator;
    }

    public IStatementNode getStatement() {
      return statement;
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
      if (!equals(optionalForUpdate, __node.getOptionalForUpdate())) { return false; }
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
      hash = 31 * hash + (optionalForUpdate == null ? 0 : optionalForUpdate.hashCode());
      hash = 31 * hash + (rightParenthesisSeparator == null ? 0 : rightParenthesisSeparator.hashCode());
      hash = 31 * hash + (statement == null ? 0 : statement.hashCode());
      return hash;
    }
  }

  public interface IForInitializerNode extends INode {
  }

  public class ForInitializerNode extends AbstractNode implements IForInitializerNode {
    public ForInitializerNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IForInitializerNode)) { return false; }
      IForInitializerNode __node = (IForInitializerNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IForUpdateNode extends INode {
    List<IExpressionNode> getExpressionList();
  }

  public class ForUpdateNode extends AbstractNode implements IForUpdateNode {
    private final List<IExpressionNode> expressionList;

    public ForUpdateNode(
        List<IExpressionNode> expressionList) {
      this.expressionList = expressionList;
    }

    public List<IExpressionNode> getExpressionList() {
      return expressionList;
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IForUpdateNode)) { return false; }
      IForUpdateNode __node = (IForUpdateNode) __other;
      if (!equals(expressionList, __node.getExpressionList())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (expressionList == null ? 0 : expressionList.hashCode());
      return hash;
    }
  }

  public interface IEnhancedForStatementNode extends INode, IForStatementNode {
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

  public class EnhancedForStatementNode extends AbstractNode implements IEnhancedForStatementNode {
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
  }

  public interface IBreakStatementNode extends INode, IStatementNode {
    SourceToken<BreakKeywordToken> getBreakKeyword();

    SourceToken<IdentifierToken> getOptionalIdentifier();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class BreakStatementNode extends AbstractNode implements IBreakStatementNode {
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
  }

  public interface IContinueStatementNode extends INode, IStatementNode {
    SourceToken<ContinueKeywordToken> getContinueKeyword();

    SourceToken<IdentifierToken> getOptionalIdentifier();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class ContinueStatementNode extends AbstractNode implements IContinueStatementNode {
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
  }

  public interface IReturnStatementNode extends INode, IStatementNode {
    SourceToken<ReturnKeywordToken> getReturnKeyword();

    IExpressionNode getOptionalExpression();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class ReturnStatementNode extends AbstractNode implements IReturnStatementNode {
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
  }

  public interface IThrowStatementNode extends INode, IStatementNode {
    SourceToken<ThrowKeywordToken> getThrowKeyword();

    IExpressionNode getOptionalExpression();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class ThrowStatementNode extends AbstractNode implements IThrowStatementNode {
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
  }

  public interface ISynchronizedStatementNode extends INode, IStatementNode {
    SourceToken<SynchronizedKeywordToken> getSynchronizedKeyword();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    IBlockNode getBlock();
  }

  public class SynchronizedStatementNode extends AbstractNode implements ISynchronizedStatementNode {
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
  }

  public interface ITryStatementNode extends INode, IStatementNode {
  }

  public class TryStatementNode extends AbstractNode implements ITryStatementNode {
    public TryStatementNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ITryStatementNode)) { return false; }
      ITryStatementNode __node = (ITryStatementNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface ITryStatementWithFinallyNode extends INode, ITryStatementNode {
    SourceToken<TryKeywordToken> getTryKeyword();

    IBlockNode getBlock();

    List<ICatchClauseNode> getCatchClauseList();

    SourceToken<FinallyKeywordToken> getFinallyKeyword();

    IBlockNode getBlock2();
  }

  public class TryStatementWithFinallyNode extends AbstractNode implements ITryStatementWithFinallyNode {
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
  }

  public interface ITryStatementWithoutFinallyNode extends INode, ITryStatementNode {
    SourceToken<TryKeywordToken> getTryKeyword();

    IBlockNode getBlock();

    List<ICatchClauseNode> getCatchClauseList();
  }

  public class TryStatementWithoutFinallyNode extends AbstractNode implements ITryStatementWithoutFinallyNode {
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
  }

  public interface ICatchClauseNode extends INode {
    SourceToken<CatchKeywordToken> getCatchKeyword();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IFormalParameterNode getFormalParameter();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    IBlockNode getBlock();
  }

  public class CatchClauseNode extends AbstractNode implements ICatchClauseNode {
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
  }

  public interface IExpressionNode
      extends INode, IElementValueNode, IVariableInitializerNode, IVariableDeclaratorAssignmentNode {
    List<IExpression1Node> getExpression1List();
  }

  public class ExpressionNode extends AbstractNode implements IExpressionNode {
    private final List<IExpression1Node> expression1List;

    public ExpressionNode(
        List<IExpression1Node> expression1List) {
      this.expression1List = expression1List;
    }

    public List<IExpression1Node> getExpression1List() {
      return expression1List;
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
  }

  public interface IAssignmentOperatorNode extends INode {
  }

  public class AssignmentOperatorNode extends AbstractNode implements IAssignmentOperatorNode {
    public AssignmentOperatorNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IAssignmentOperatorNode)) { return false; }
      IAssignmentOperatorNode __node = (IAssignmentOperatorNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IExpression1Node extends INode {
  }

  public class Expression1Node extends AbstractNode implements IExpression1Node {
    public Expression1Node() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IExpression1Node)) { return false; }
      IExpression1Node __node = (IExpression1Node) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface ITernaryExpressionNode extends INode, IExpression1Node {
    IExpression2Node getExpression2();

    SourceToken<QuestionMarkOperatorToken> getQuestionMarkOperator();

    IExpressionNode getExpression();

    SourceToken<ColonOperatorToken> getColonOperator();

    IExpression1Node getExpression1();
  }

  public class TernaryExpressionNode extends AbstractNode implements ITernaryExpressionNode {
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
  }

  public interface IExpression2Node extends INode, IExpression1Node {
  }

  public class Expression2Node extends AbstractNode implements IExpression2Node {
    public Expression2Node() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IExpression2Node)) { return false; }
      IExpression2Node __node = (IExpression2Node) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IBinaryExpressionNode extends INode, IExpression2Node {
    IExpression3Node getExpression3();

    List<IBinaryExpressionRestNode> getBinaryExpressionRestList();
  }

  public class BinaryExpressionNode extends AbstractNode implements IBinaryExpressionNode {
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
  }

  public interface IBinaryExpressionRestNode extends INode {
  }

  public class BinaryExpressionRestNode extends AbstractNode implements IBinaryExpressionRestNode {
    public BinaryExpressionRestNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IBinaryExpressionRestNode)) { return false; }
      IBinaryExpressionRestNode __node = (IBinaryExpressionRestNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IInfixOperatorBinaryExpressionRestNode extends INode, IBinaryExpressionRestNode {
    IInfixOperatorNode getInfixOperator();

    IExpression3Node getExpression3();
  }

  public class InfixOperatorBinaryExpressionRestNode extends AbstractNode
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
  }

  public interface IInstanceofOperatorBinaryExpressionRestNode extends INode, IBinaryExpressionRestNode {
    SourceToken<InstanceofKeywordToken> getInstanceofKeyword();

    ITypeNode getType();
  }

  public class InstanceofOperatorBinaryExpressionRestNode extends AbstractNode
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
  }

  public interface IInfixOperatorNode extends INode {
  }

  public class InfixOperatorNode extends AbstractNode implements IInfixOperatorNode {
    public InfixOperatorNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IInfixOperatorNode)) { return false; }
      IInfixOperatorNode __node = (IInfixOperatorNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IExpression3Node extends INode, IExpression2Node {
  }

  public class Expression3Node extends AbstractNode implements IExpression3Node {
    public Expression3Node() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IExpression3Node)) { return false; }
      IExpression3Node __node = (IExpression3Node) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IPrefixExpressionNode extends INode, IExpression3Node {
    IPrefixOperatorNode getPrefixOperator();

    IExpression3Node getExpression3();
  }

  public class PrefixExpressionNode extends AbstractNode implements IPrefixExpressionNode {
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
  }

  public interface IPrefixOperatorNode extends INode {
  }

  public class PrefixOperatorNode extends AbstractNode implements IPrefixOperatorNode {
    public PrefixOperatorNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IPrefixOperatorNode)) { return false; }
      IPrefixOperatorNode __node = (IPrefixOperatorNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IPossibleCastExpressionNode extends INode, IExpression3Node {
  }

  public class PossibleCastExpressionNode extends AbstractNode implements IPossibleCastExpressionNode {
    public PossibleCastExpressionNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IPossibleCastExpressionNode)) { return false; }
      IPossibleCastExpressionNode __node = (IPossibleCastExpressionNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IPossibleCastExpression_TypeNode extends INode, IPossibleCastExpressionNode {
    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    ITypeNode getType();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    IExpression3Node getExpression3();
  }

  public class PossibleCastExpression_TypeNode extends AbstractNode implements IPossibleCastExpression_TypeNode {
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
  }

  public interface IPossibleCastExpression_ExpressionNode extends INode, IPossibleCastExpressionNode {
    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    IExpression3Node getExpression3();
  }

  public class PossibleCastExpression_ExpressionNode extends AbstractNode
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
  }

  public interface IPrimaryExpressionNode extends INode, IExpression3Node {
    IValueExpressionNode getValueExpression();

    List<ISelectorNode> getSelectorList();

    IPostfixOperatorNode getOptionalPostfixOperator();
  }

  public class PrimaryExpressionNode extends AbstractNode implements IPrimaryExpressionNode {
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
  }

  public interface IPostfixOperatorNode extends INode {
  }

  public class PostfixOperatorNode extends AbstractNode implements IPostfixOperatorNode {
    public PostfixOperatorNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IPostfixOperatorNode)) { return false; }
      IPostfixOperatorNode __node = (IPostfixOperatorNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IValueExpressionNode extends INode {
  }

  public class ValueExpressionNode extends AbstractNode implements IValueExpressionNode {
    public ValueExpressionNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IValueExpressionNode)) { return false; }
      IValueExpressionNode __node = (IValueExpressionNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IClassAccessNode extends INode, IValueExpressionNode {
    ITypeNode getType();

    SourceToken<DotSeparatorToken> getDotSeparator();

    SourceToken<ClassKeywordToken> getClassKeyword();
  }

  public class ClassAccessNode extends AbstractNode implements IClassAccessNode {
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
  }

  public interface ISelectorNode extends INode {
  }

  public class SelectorNode extends AbstractNode implements ISelectorNode {
    public SelectorNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ISelectorNode)) { return false; }
      ISelectorNode __node = (ISelectorNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IDotSelectorNode extends INode, ISelectorNode {
    SourceToken<DotSeparatorToken> getDotSeparator();

    IValueExpressionNode getValueExpression();
  }

  public class DotSelectorNode extends AbstractNode implements IDotSelectorNode {
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
  }

  public interface IArraySelectorNode extends INode, ISelectorNode {
    SourceToken<LeftBracketSeparatorToken> getLeftBracketSeparator();

    IExpressionNode getExpression();

    SourceToken<RightBracketSeparatorToken> getRightBracketSeparator();
  }

  public class ArraySelectorNode extends AbstractNode implements IArraySelectorNode {
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
  }

  public interface IParenthesizedExpressionNode extends INode, IValueExpressionNode {
    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();
  }

  public class ParenthesizedExpressionNode extends AbstractNode implements IParenthesizedExpressionNode {
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
  }

  public interface IMethodInvocationNode extends INode, IValueExpressionNode {
    INonWildcardTypeArgumentsNode getOptionalNonWildcardTypeArguments();

    SourceToken<IdentifierToken> getIdentifier();

    IArgumentsNode getArguments();
  }

  public class MethodInvocationNode extends AbstractNode implements IMethodInvocationNode {
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
  }

  public interface IThisConstructorInvocationNode extends INode, IValueExpressionNode {
    SourceToken<ThisKeywordToken> getThisKeyword();

    IArgumentsNode getArguments();
  }

  public class ThisConstructorInvocationNode extends AbstractNode implements IThisConstructorInvocationNode {
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
  }

  public interface ISuperConstructorInvocationNode extends INode, IValueExpressionNode {
    SourceToken<SuperKeywordToken> getSuperKeyword();

    IArgumentsNode getArguments();
  }

  public class SuperConstructorInvocationNode extends AbstractNode implements ISuperConstructorInvocationNode {
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
  }

  public interface ICreationExpressionNode extends INode, IValueExpressionNode {
  }

  public class CreationExpressionNode extends AbstractNode implements ICreationExpressionNode {
    public CreationExpressionNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof ICreationExpressionNode)) { return false; }
      ICreationExpressionNode __node = (ICreationExpressionNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IObjectCreationExpressionNode extends INode, ICreationExpressionNode {
    SourceToken<NewKeywordToken> getNewKeyword();

    INonWildcardTypeArgumentsNode getOptionalNonWildcardTypeArguments();

    IClassOrInterfaceTypeNode getClassOrInterfaceType();

    IArgumentsNode getArguments();

    IClassBodyNode getOptionalClassBody();
  }

  public class ObjectCreationExpressionNode extends AbstractNode implements IObjectCreationExpressionNode {
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
  }

  public interface IArrayCreationExpressionNode extends INode, ICreationExpressionNode {
    SourceToken<NewKeywordToken> getNewKeyword();

    IArrayCreationTypeNode getArrayCreationType();

    List<IDimensionExpressionNode> getDimensionExpressionList();

    IArrayInitializerNode getOptionalArrayInitializer();
  }

  public class ArrayCreationExpressionNode extends AbstractNode implements IArrayCreationExpressionNode {
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
  }

  public interface IArrayCreationTypeNode extends INode {
  }

  public class ArrayCreationTypeNode extends AbstractNode implements IArrayCreationTypeNode {
    public ArrayCreationTypeNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IArrayCreationTypeNode)) { return false; }
      IArrayCreationTypeNode __node = (IArrayCreationTypeNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }

  public interface IDimensionExpressionNode extends INode {
    SourceToken<LeftBracketSeparatorToken> getLeftBracketSeparator();

    IExpressionNode getOptionalExpression();

    SourceToken<RightBracketSeparatorToken> getRightBracketSeparator();
  }

  public class DimensionExpressionNode extends AbstractNode implements IDimensionExpressionNode {
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
  }

  public interface IArrayInitializerNode extends INode, IVariableInitializerNode, IVariableDeclaratorAssignmentNode {
    SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator();

    List<IVariableInitializerNode> getOptionalVariableInitializerList();

    SourceToken<CommaSeparatorToken> getOptionalCommaSeparator();

    SourceToken<RightCurlySeparatorToken> getRightCurlySeparator();
  }

  public class ArrayInitializerNode extends AbstractNode implements IArrayInitializerNode {
    private final SourceToken<LeftCurlySeparatorToken> leftCurlySeparator;
    private final List<IVariableInitializerNode> optionalVariableInitializerList;
    private final SourceToken<CommaSeparatorToken> optionalCommaSeparator;
    private final SourceToken<RightCurlySeparatorToken> rightCurlySeparator;

    public ArrayInitializerNode(
        SourceToken<LeftCurlySeparatorToken> leftCurlySeparator,
        List<IVariableInitializerNode> optionalVariableInitializerList,
        SourceToken<CommaSeparatorToken> optionalCommaSeparator,
        SourceToken<RightCurlySeparatorToken> rightCurlySeparator) {
      this.leftCurlySeparator = leftCurlySeparator;
      this.optionalVariableInitializerList = optionalVariableInitializerList;
      this.optionalCommaSeparator = optionalCommaSeparator;
      this.rightCurlySeparator = rightCurlySeparator;
    }

    public SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator() {
      return leftCurlySeparator;
    }

    public List<IVariableInitializerNode> getOptionalVariableInitializerList() {
      return optionalVariableInitializerList;
    }

    public SourceToken<CommaSeparatorToken> getOptionalCommaSeparator() {
      return optionalCommaSeparator;
    }

    public SourceToken<RightCurlySeparatorToken> getRightCurlySeparator() {
      return rightCurlySeparator;
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
      if (!equals(optionalCommaSeparator, __node.getOptionalCommaSeparator())) { return false; }
      if (!equals(rightCurlySeparator, __node.getRightCurlySeparator())) { return false; }
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      hash = 31 * hash + (leftCurlySeparator == null ? 0 : leftCurlySeparator.hashCode());
      hash = 31 * hash + (optionalVariableInitializerList == null ? 0 : optionalVariableInitializerList.hashCode());
      hash = 31 * hash + (optionalCommaSeparator == null ? 0 : optionalCommaSeparator.hashCode());
      hash = 31 * hash + (rightCurlySeparator == null ? 0 : rightCurlySeparator.hashCode());
      return hash;
    }
  }

  public interface IVariableInitializerNode extends INode {
  }

  public class VariableInitializerNode extends AbstractNode implements IVariableInitializerNode {
    public VariableInitializerNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }

    public boolean equals(Object __other) {
      if (this == __other) { return true; }
      if (__other == null) { return false; }
      if (!(__other instanceof IVariableInitializerNode)) { return false; }
      IVariableInitializerNode __node = (IVariableInitializerNode) __other;
      return true;
    }

    protected int hashCodeWorker() {
      int hash = 0;
      return hash;
    }
  }
}
