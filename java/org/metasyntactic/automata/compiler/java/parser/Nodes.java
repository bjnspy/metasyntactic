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

  public interface ICompilationUnitNode extends INode {
    IPackageDeclarationNode getOptionalPackageDeclaration();

    List<IImportDeclarationNode> getImportDeclarationList();

    List<ITypeDeclarationNode> getTypeDeclarationList();
  }

  public class CompilationUnitNode implements ICompilationUnitNode {
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
  }

  public interface IPackageDeclarationNode extends INode {
    List<IAnnotationNode> getAnnotationList();

    SourceToken<PackageKeywordToken> getPackageKeyword();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class PackageDeclarationNode implements IPackageDeclarationNode {
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
  }

  public interface IQualifiedIdentifierNode extends INode {
    List<SourceToken<IdentifierToken>> getIdentifierList();
  }

  public class QualifiedIdentifierNode implements IQualifiedIdentifierNode {
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
  }

  public interface IImportDeclarationNode extends INode {
  }

  public class ImportDeclarationNode implements IImportDeclarationNode {
    public ImportDeclarationNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface ISingleTypeImportDeclarationNode extends INode, IImportDeclarationNode {
    SourceToken<ImportKeywordToken> getImportKeyword();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class SingleTypeImportDeclarationNode implements ISingleTypeImportDeclarationNode {
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
  }

  public interface ITypeImportOnDemandDeclarationNode extends INode, IImportDeclarationNode {
    SourceToken<ImportKeywordToken> getImportKeyword();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SourceToken<DotSeparatorToken> getDotSeparator();

    SourceToken<TimesOperatorToken> getTimesOperator();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class TypeImportOnDemandDeclarationNode implements ITypeImportOnDemandDeclarationNode {
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
  }

  public interface ISingleStaticImportDeclarationNode extends INode, IImportDeclarationNode {
    SourceToken<ImportKeywordToken> getImportKeyword();

    SourceToken<StaticKeywordToken> getStaticKeyword();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class SingleStaticImportDeclarationNode implements ISingleStaticImportDeclarationNode {
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
  }

  public interface IStaticImportOnDemandDeclarationNode extends INode, IImportDeclarationNode {
    SourceToken<ImportKeywordToken> getImportKeyword();

    SourceToken<StaticKeywordToken> getStaticKeyword();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SourceToken<DotSeparatorToken> getDotSeparator();

    SourceToken<TimesOperatorToken> getTimesOperator();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class StaticImportOnDemandDeclarationNode implements IStaticImportOnDemandDeclarationNode {
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
  }

  public interface ITypeDeclarationNode extends INode, IClassOrInterfaceMemberDeclarationNode {
  }

  public class TypeDeclarationNode implements ITypeDeclarationNode {
    public TypeDeclarationNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IClassDeclarationNode extends INode, IBlockStatementNode, ITypeDeclarationNode {
  }

  public class ClassDeclarationNode implements IClassDeclarationNode {
    public ClassDeclarationNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
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

  public class NormalClassDeclarationNode implements INormalClassDeclarationNode {
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
  }

  public interface IModifiersNode extends INode {
    List<IModifierNode> getModifierList();
  }

  public class ModifiersNode implements IModifiersNode {
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
  }

  public interface IModifierNode extends INode {
  }

  public class ModifierNode implements IModifierNode {
    public ModifierNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface ISuperNode extends INode {
    SourceToken<ExtendsKeywordToken> getExtendsKeyword();

    IClassOrInterfaceTypeNode getClassOrInterfaceType();
  }

  public class SuperNode implements ISuperNode {
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
  }

  public interface IInterfacesNode extends INode {
    SourceToken<ImplementsKeywordToken> getImplementsKeyword();

    List<IClassOrInterfaceTypeNode> getClassOrInterfaceTypeList();
  }

  public class InterfacesNode implements IInterfacesNode {
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
  }

  public interface IClassBodyNode extends INode {
    SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator();

    List<IClassBodyDeclarationNode> getClassBodyDeclarationList();

    SourceToken<RightCurlySeparatorToken> getRightCurlySeparator();
  }

  public class ClassBodyNode implements IClassBodyNode {
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
  }

  public interface IClassBodyDeclarationNode extends INode {
  }

  public class ClassBodyDeclarationNode implements IClassBodyDeclarationNode {
    public ClassBodyDeclarationNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IStaticInitializerNode extends INode, IClassBodyDeclarationNode {
    SourceToken<StaticKeywordToken> getStaticKeyword();

    IBlockNode getBlock();
  }

  public class StaticInitializerNode implements IStaticInitializerNode {
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
  }

  public interface IInterfaceDeclarationNode extends INode, ITypeDeclarationNode {
  }

  public class InterfaceDeclarationNode implements IInterfaceDeclarationNode {
    public InterfaceDeclarationNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
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

  public class NormalInterfaceDeclarationNode implements INormalInterfaceDeclarationNode {
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
  }

  public interface IExtendsInterfacesNode extends INode {
    SourceToken<ExtendsKeywordToken> getExtendsKeyword();

    List<IClassOrInterfaceTypeNode> getClassOrInterfaceTypeList();
  }

  public class ExtendsInterfacesNode implements IExtendsInterfacesNode {
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
  }

  public interface IClassOrInterfaceBodyNode extends INode {
    SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator();

    List<IClassOrInterfaceMemberDeclarationNode> getClassOrInterfaceMemberDeclarationList();

    SourceToken<RightCurlySeparatorToken> getRightCurlySeparator();
  }

  public class ClassOrInterfaceBodyNode implements IClassOrInterfaceBodyNode {
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
  }

  public interface IEnumDeclarationNode extends INode, IClassDeclarationNode {
    IModifiersNode getModifiers();

    SourceToken<EnumKeywordToken> getEnumKeyword();

    SourceToken<IdentifierToken> getIdentifier();

    IInterfacesNode getOptionalInterfaces();

    IEnumBodyNode getEnumBody();
  }

  public class EnumDeclarationNode implements IEnumDeclarationNode {
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
  }

  public interface IEnumBodyNode extends INode {
    SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator();

    List<IEnumConstantNode> getOptionalEnumConstantList();

    SourceToken<CommaSeparatorToken> getOptionalCommaSeparator();

    SourceToken<SemicolonSeparatorToken> getOptionalSemicolonSeparator();

    List<IClassBodyDeclarationNode> getClassBodyDeclarationList();

    SourceToken<RightCurlySeparatorToken> getRightCurlySeparator();
  }

  public class EnumBodyNode implements IEnumBodyNode {
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
  }

  public interface IEnumConstantNode extends INode {
    List<IAnnotationNode> getAnnotationList();

    SourceToken<IdentifierToken> getIdentifier();

    IArgumentsNode getOptionalArguments();

    IClassOrInterfaceBodyNode getOptionalClassOrInterfaceBody();
  }

  public class EnumConstantNode implements IEnumConstantNode {
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
  }

  public interface IArgumentsNode extends INode {
    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    List<IExpressionNode> getOptionalExpressionList();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();
  }

  public class ArgumentsNode implements IArgumentsNode {
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
  }

  public interface IAnnotationDeclarationNode extends INode, IInterfaceDeclarationNode {
    IModifiersNode getModifiers();

    SourceToken<AtSeparatorToken> getAtSeparator();

    SourceToken<InterfaceKeywordToken> getInterfaceKeyword();

    SourceToken<IdentifierToken> getIdentifier();

    IAnnotationBodyNode getAnnotationBody();
  }

  public class AnnotationDeclarationNode implements IAnnotationDeclarationNode {
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
  }

  public interface IAnnotationBodyNode extends INode {
    SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator();

    List<IAnnotationElementDeclarationNode> getAnnotationElementDeclarationList();

    SourceToken<RightCurlySeparatorToken> getRightCurlySeparator();
  }

  public class AnnotationBodyNode implements IAnnotationBodyNode {
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
  }

  public interface IAnnotationElementDeclarationNode extends INode {
  }

  public class AnnotationElementDeclarationNode implements IAnnotationElementDeclarationNode {
    public AnnotationElementDeclarationNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
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

  public class AnnotationDefaultDeclarationNode implements IAnnotationDefaultDeclarationNode {
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
  }

  public interface IClassOrInterfaceMemberDeclarationNode
      extends INode, IClassBodyDeclarationNode, IAnnotationElementDeclarationNode {
  }

  public class ClassOrInterfaceMemberDeclarationNode implements IClassOrInterfaceMemberDeclarationNode {
    public ClassOrInterfaceMemberDeclarationNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
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

  public class ConstructorDeclarationNode implements IConstructorDeclarationNode {
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
  }

  public interface IFieldDeclarationNode extends INode, IClassOrInterfaceMemberDeclarationNode {
    IModifiersNode getModifiers();

    ITypeNode getType();

    List<IVariableDeclaratorNode> getVariableDeclaratorList();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class FieldDeclarationNode implements IFieldDeclarationNode {
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
  }

  public interface IVariableDeclaratorNode extends INode {
  }

  public class VariableDeclaratorNode implements IVariableDeclaratorNode {
    public VariableDeclaratorNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IVariableDeclaratorIdAndAssignmentNode extends INode, IVariableDeclaratorNode {
    IVariableDeclaratorIdNode getVariableDeclaratorId();

    SourceToken<EqualsOperatorToken> getEqualsOperator();

    IVariableDeclaratorAssignmentNode getVariableDeclaratorAssignment();
  }

  public class VariableDeclaratorIdAndAssignmentNode implements IVariableDeclaratorIdAndAssignmentNode {
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
  }

  public interface IVariableDeclaratorAssignmentNode extends INode {
  }

  public class VariableDeclaratorAssignmentNode implements IVariableDeclaratorAssignmentNode {
    public VariableDeclaratorAssignmentNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IVariableDeclaratorIdNode extends INode, IVariableDeclaratorNode {
    SourceToken<IdentifierToken> getIdentifier();

    List<IBracketPairNode> getBracketPairList();
  }

  public class VariableDeclaratorIdNode implements IVariableDeclaratorIdNode {
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
  }

  public interface IBracketPairNode extends INode {
    SourceToken<LeftBracketSeparatorToken> getLeftBracketSeparator();

    SourceToken<RightBracketSeparatorToken> getRightBracketSeparator();
  }

  public class BracketPairNode implements IBracketPairNode {
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

  public class MethodDeclarationNode implements IMethodDeclarationNode {
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
  }

  public interface IMethodBodyNode extends INode {
  }

  public class MethodBodyNode implements IMethodBodyNode {
    public MethodBodyNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IFormalParameterNode extends INode {
    IModifiersNode getModifiers();

    ITypeNode getType();

    SourceToken<EllipsisSeparatorToken> getOptionalEllipsisSeparator();

    IVariableDeclaratorIdNode getVariableDeclaratorId();
  }

  public class FormalParameterNode implements IFormalParameterNode {
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
  }

  public interface IThrowsNode extends INode {
    SourceToken<ThrowsKeywordToken> getThrowsKeyword();

    List<IClassOrInterfaceTypeNode> getClassOrInterfaceTypeList();
  }

  public class ThrowsNode implements IThrowsNode {
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
  }

  public interface ITypeParametersNode extends INode {
    SourceToken<LessThanOperatorToken> getLessThanOperator();

    List<ITypeParameterNode> getTypeParameterList();

    SourceToken<GreaterThanOperatorToken> getGreaterThanOperator();
  }

  public class TypeParametersNode implements ITypeParametersNode {
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
  }

  public interface ITypeParameterNode extends INode {
    SourceToken<IdentifierToken> getIdentifier();

    ITypeBoundNode getOptionalTypeBound();
  }

  public class TypeParameterNode implements ITypeParameterNode {
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
  }

  public interface ITypeBoundNode extends INode {
    SourceToken<ExtendsKeywordToken> getExtendsKeyword();

    List<IClassOrInterfaceTypeNode> getClassOrInterfaceTypeList();
  }

  public class TypeBoundNode implements ITypeBoundNode {
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
  }

  public interface ITypeNode extends INode {
  }

  public class TypeNode implements ITypeNode {
    public TypeNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IReferenceTypeNode extends INode, ITypeArgumentNode, ITypeNode {
  }

  public class ReferenceTypeNode implements IReferenceTypeNode {
    public ReferenceTypeNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IPrimitiveArrayReferenceTypeNode extends INode, IReferenceTypeNode {
    IPrimitiveTypeNode getPrimitiveType();

    List<IBracketPairNode> getBracketPairList();
  }

  public class PrimitiveArrayReferenceTypeNode implements IPrimitiveArrayReferenceTypeNode {
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
  }

  public interface IClassOrInterfaceReferenceTypeNode extends INode, IReferenceTypeNode {
    IClassOrInterfaceTypeNode getClassOrInterfaceType();

    List<IBracketPairNode> getBracketPairList();
  }

  public class ClassOrInterfaceReferenceTypeNode implements IClassOrInterfaceReferenceTypeNode {
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
  }

  public interface IClassOrInterfaceTypeNode extends INode, IArrayCreationTypeNode {
    List<ISingleClassOrInterfaceTypeNode> getSingleClassOrInterfaceTypeList();
  }

  public class ClassOrInterfaceTypeNode implements IClassOrInterfaceTypeNode {
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
  }

  public interface ISingleClassOrInterfaceTypeNode extends INode {
    SourceToken<IdentifierToken> getIdentifier();

    ITypeArgumentsNode getOptionalTypeArguments();
  }

  public class SingleClassOrInterfaceTypeNode implements ISingleClassOrInterfaceTypeNode {
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
  }

  public interface ITypeArgumentsNode extends INode {
    SourceToken<LessThanOperatorToken> getLessThanOperator();

    List<ITypeArgumentNode> getTypeArgumentList();

    SourceToken<GreaterThanOperatorToken> getGreaterThanOperator();
  }

  public class TypeArgumentsNode implements ITypeArgumentsNode {
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
  }

  public interface ITypeArgumentNode extends INode {
  }

  public class TypeArgumentNode implements ITypeArgumentNode {
    public TypeArgumentNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IWildcardTypeArgumentNode extends INode, ITypeArgumentNode {
  }

  public class WildcardTypeArgumentNode implements IWildcardTypeArgumentNode {
    public WildcardTypeArgumentNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IExtendsWildcardTypeArgumentNode extends INode, IWildcardTypeArgumentNode {
    SourceToken<QuestionMarkOperatorToken> getQuestionMarkOperator();

    SourceToken<ExtendsKeywordToken> getExtendsKeyword();

    IReferenceTypeNode getReferenceType();
  }

  public class ExtendsWildcardTypeArgumentNode implements IExtendsWildcardTypeArgumentNode {
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
  }

  public interface ISuperWildcardTypeArgumentNode extends INode, IWildcardTypeArgumentNode {
    SourceToken<QuestionMarkOperatorToken> getQuestionMarkOperator();

    SourceToken<SuperKeywordToken> getSuperKeyword();

    IReferenceTypeNode getReferenceType();
  }

  public class SuperWildcardTypeArgumentNode implements ISuperWildcardTypeArgumentNode {
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
  }

  public interface IOpenWildcardTypeArgumentNode extends INode, IWildcardTypeArgumentNode {
    SourceToken<QuestionMarkOperatorToken> getQuestionMarkOperator();
  }

  public class OpenWildcardTypeArgumentNode implements IOpenWildcardTypeArgumentNode {
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
  }

  public interface INonWildcardTypeArgumentsNode extends INode {
    SourceToken<LessThanOperatorToken> getLessThanOperator();

    List<IReferenceTypeNode> getReferenceTypeList();

    SourceToken<GreaterThanOperatorToken> getGreaterThanOperator();
  }

  public class NonWildcardTypeArgumentsNode implements INonWildcardTypeArgumentsNode {
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
  }

  public interface IPrimitiveTypeNode extends INode, IArrayCreationTypeNode, ITypeNode {
  }

  public class PrimitiveTypeNode implements IPrimitiveTypeNode {
    public PrimitiveTypeNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IAnnotationNode extends INode, IElementValueNode, IModifierNode {
  }

  public class AnnotationNode implements IAnnotationNode {
    public AnnotationNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface INormalAnnotationNode extends INode, IAnnotationNode {
    SourceToken<AtSeparatorToken> getAtSeparator();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    List<IElementValuePairNode> getOptionalElementValuePairList();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();
  }

  public class NormalAnnotationNode implements INormalAnnotationNode {
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
  }

  public interface IElementValuePairNode extends INode {
    SourceToken<IdentifierToken> getIdentifier();

    SourceToken<EqualsOperatorToken> getEqualsOperator();

    IElementValueNode getElementValue();
  }

  public class ElementValuePairNode implements IElementValuePairNode {
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
  }

  public interface ISingleElementAnnotationNode extends INode, IAnnotationNode {
    SourceToken<AtSeparatorToken> getAtSeparator();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IElementValueNode getElementValue();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();
  }

  public class SingleElementAnnotationNode implements ISingleElementAnnotationNode {
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
  }

  public interface IMarkerAnnotationNode extends INode, IAnnotationNode {
    SourceToken<AtSeparatorToken> getAtSeparator();

    IQualifiedIdentifierNode getQualifiedIdentifier();
  }

  public class MarkerAnnotationNode implements IMarkerAnnotationNode {
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
  }

  public interface IElementValueNode extends INode {
  }

  public class ElementValueNode implements IElementValueNode {
    public ElementValueNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IElementValueArrayInitializerNode extends INode, IElementValueNode {
    SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator();

    List<IElementValueNode> getOptionalElementValueList();

    SourceToken<CommaSeparatorToken> getOptionalCommaSeparator();

    SourceToken<RightCurlySeparatorToken> getRightCurlySeparator();
  }

  public class ElementValueArrayInitializerNode implements IElementValueArrayInitializerNode {
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
  }

  public interface IBlockNode extends INode, IClassBodyDeclarationNode, IStatementNode, IMethodBodyNode {
    SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator();

    List<IBlockStatementNode> getBlockStatementList();

    SourceToken<RightCurlySeparatorToken> getRightCurlySeparator();
  }

  public class BlockNode implements IBlockNode {
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
  }

  public interface IBlockStatementNode extends INode {
  }

  public class BlockStatementNode implements IBlockStatementNode {
    public BlockStatementNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface ILocalVariableDeclarationStatementNode extends INode, IBlockStatementNode {
    ILocalVariableDeclarationNode getLocalVariableDeclaration();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class LocalVariableDeclarationStatementNode implements ILocalVariableDeclarationStatementNode {
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
  }

  public interface ILocalVariableDeclarationNode extends INode, IForInitializerNode {
    IModifiersNode getModifiers();

    ITypeNode getType();

    List<IVariableDeclaratorNode> getVariableDeclaratorList();
  }

  public class LocalVariableDeclarationNode implements ILocalVariableDeclarationNode {
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
  }

  public interface IStatementNode extends INode, IBlockStatementNode {
  }

  public class StatementNode implements IStatementNode {
    public StatementNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IEmptyStatementNode extends INode, IStatementNode {
    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class EmptyStatementNode implements IEmptyStatementNode {
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
  }

  public interface ILabeledStatementNode extends INode, IStatementNode {
    SourceToken<IdentifierToken> getIdentifier();

    SourceToken<ColonOperatorToken> getColonOperator();

    IStatementNode getStatement();
  }

  public class LabeledStatementNode implements ILabeledStatementNode {
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
  }

  public interface IExpressionStatementNode extends INode, IStatementNode {
    IExpressionNode getExpression();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class ExpressionStatementNode implements IExpressionStatementNode {
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
  }

  public interface IIfStatementNode extends INode, IStatementNode {
    SourceToken<IfKeywordToken> getIfKeyword();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    IStatementNode getStatement();

    IElseStatementNode getOptionalElseStatement();
  }

  public class IfStatementNode implements IIfStatementNode {
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
  }

  public interface IElseStatementNode extends INode {
    SourceToken<ElseKeywordToken> getElseKeyword();

    IStatementNode getStatement();
  }

  public class ElseStatementNode implements IElseStatementNode {
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
  }

  public interface IAssertStatementNode extends INode, IStatementNode {
  }

  public class AssertStatementNode implements IAssertStatementNode {
    public AssertStatementNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IMessageAssertStatementNode extends INode, IAssertStatementNode {
    SourceToken<AssertKeywordToken> getAssertKeyword();

    IExpressionNode getExpression();

    SourceToken<ColonOperatorToken> getColonOperator();

    IExpressionNode getExpression2();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class MessageAssertStatementNode implements IMessageAssertStatementNode {
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
  }

  public interface ISimpleAssertStatementNode extends INode, IAssertStatementNode {
    SourceToken<AssertKeywordToken> getAssertKeyword();

    IExpressionNode getExpression();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class SimpleAssertStatementNode implements ISimpleAssertStatementNode {
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

  public class SwitchStatementNode implements ISwitchStatementNode {
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
  }

  public interface ISwitchBlockStatementGroupNode extends INode {
    List<ISwitchLabelNode> getSwitchLabelList();

    List<IBlockStatementNode> getBlockStatementList();
  }

  public class SwitchBlockStatementGroupNode implements ISwitchBlockStatementGroupNode {
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
  }

  public interface ISwitchLabelNode extends INode {
  }

  public class SwitchLabelNode implements ISwitchLabelNode {
    public SwitchLabelNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface ICaseSwitchLabelNode extends INode, ISwitchLabelNode {
    SourceToken<CaseKeywordToken> getCaseKeyword();

    IExpressionNode getExpression();

    SourceToken<ColonOperatorToken> getColonOperator();
  }

  public class CaseSwitchLabelNode implements ICaseSwitchLabelNode {
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
  }

  public interface IDefaultSwitchLabelNode extends INode, ISwitchLabelNode {
    SourceToken<DefaultKeywordToken> getDefaultKeyword();

    SourceToken<ColonOperatorToken> getColonOperator();
  }

  public class DefaultSwitchLabelNode implements IDefaultSwitchLabelNode {
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
  }

  public interface IWhileStatementNode extends INode, IStatementNode {
    SourceToken<WhileKeywordToken> getWhileKeyword();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    IStatementNode getStatement();
  }

  public class WhileStatementNode implements IWhileStatementNode {
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

  public class DoStatementNode implements IDoStatementNode {
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
  }

  public interface IForStatementNode extends INode, IStatementNode {
  }

  public class ForStatementNode implements IForStatementNode {
    public ForStatementNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
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

  public class BasicForStatementNode implements IBasicForStatementNode {
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
  }

  public interface IForInitializerNode extends INode {
  }

  public class ForInitializerNode implements IForInitializerNode {
    public ForInitializerNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IForUpdateNode extends INode {
    List<IExpressionNode> getExpressionList();
  }

  public class ForUpdateNode implements IForUpdateNode {
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

  public class EnhancedForStatementNode implements IEnhancedForStatementNode {
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
  }

  public interface IBreakStatementNode extends INode, IStatementNode {
    SourceToken<BreakKeywordToken> getBreakKeyword();

    SourceToken<IdentifierToken> getOptionalIdentifier();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class BreakStatementNode implements IBreakStatementNode {
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
  }

  public interface IContinueStatementNode extends INode, IStatementNode {
    SourceToken<ContinueKeywordToken> getContinueKeyword();

    SourceToken<IdentifierToken> getOptionalIdentifier();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class ContinueStatementNode implements IContinueStatementNode {
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
  }

  public interface IReturnStatementNode extends INode, IStatementNode {
    SourceToken<ReturnKeywordToken> getReturnKeyword();

    IExpressionNode getOptionalExpression();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class ReturnStatementNode implements IReturnStatementNode {
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
  }

  public interface IThrowStatementNode extends INode, IStatementNode {
    SourceToken<ThrowKeywordToken> getThrowKeyword();

    IExpressionNode getOptionalExpression();

    SourceToken<SemicolonSeparatorToken> getSemicolonSeparator();
  }

  public class ThrowStatementNode implements IThrowStatementNode {
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
  }

  public interface ISynchronizedStatementNode extends INode, IStatementNode {
    SourceToken<SynchronizedKeywordToken> getSynchronizedKeyword();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    IBlockNode getBlock();
  }

  public class SynchronizedStatementNode implements ISynchronizedStatementNode {
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
  }

  public interface ITryStatementNode extends INode, IStatementNode {
  }

  public class TryStatementNode implements ITryStatementNode {
    public TryStatementNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface ITryStatementWithFinallyNode extends INode, ITryStatementNode {
    SourceToken<TryKeywordToken> getTryKeyword();

    IBlockNode getBlock();

    List<ICatchClauseNode> getCatchClauseList();

    SourceToken<FinallyKeywordToken> getFinallyKeyword();

    IBlockNode getBlock2();
  }

  public class TryStatementWithFinallyNode implements ITryStatementWithFinallyNode {
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
  }

  public interface ITryStatementWithoutFinallyNode extends INode, ITryStatementNode {
    SourceToken<TryKeywordToken> getTryKeyword();

    IBlockNode getBlock();

    List<ICatchClauseNode> getCatchClauseList();
  }

  public class TryStatementWithoutFinallyNode implements ITryStatementWithoutFinallyNode {
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
  }

  public interface ICatchClauseNode extends INode {
    SourceToken<CatchKeywordToken> getCatchKeyword();

    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IFormalParameterNode getFormalParameter();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    IBlockNode getBlock();
  }

  public class CatchClauseNode implements ICatchClauseNode {
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
  }

  public interface IExpressionNode
      extends INode, IElementValueNode, IVariableInitializerNode, IVariableDeclaratorAssignmentNode {
    List<IExpression1Node> getExpression1List();
  }

  public class ExpressionNode implements IExpressionNode {
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
  }

  public interface IAssignmentOperatorNode extends INode {
  }

  public class AssignmentOperatorNode implements IAssignmentOperatorNode {
    public AssignmentOperatorNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IExpression1Node extends INode {
  }

  public class Expression1Node implements IExpression1Node {
    public Expression1Node() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface ITernaryExpressionNode extends INode, IExpression1Node {
    IExpression2Node getExpression2();

    SourceToken<QuestionMarkOperatorToken> getQuestionMarkOperator();

    IExpressionNode getExpression();

    SourceToken<ColonOperatorToken> getColonOperator();

    IExpression1Node getExpression1();
  }

  public class TernaryExpressionNode implements ITernaryExpressionNode {
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
  }

  public interface IExpression2Node extends INode, IExpression1Node {
  }

  public class Expression2Node implements IExpression2Node {
    public Expression2Node() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IBinaryExpressionNode extends INode, IExpression2Node {
    IExpression3Node getExpression3();

    List<IBinaryExpressionRestNode> getBinaryExpressionRestList();
  }

  public class BinaryExpressionNode implements IBinaryExpressionNode {
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
  }

  public interface IBinaryExpressionRestNode extends INode {
  }

  public class BinaryExpressionRestNode implements IBinaryExpressionRestNode {
    public BinaryExpressionRestNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IInfixOperatorBinaryExpressionRestNode extends INode, IBinaryExpressionRestNode {
    IInfixOperatorNode getInfixOperator();

    IExpression3Node getExpression3();
  }

  public class InfixOperatorBinaryExpressionRestNode implements IInfixOperatorBinaryExpressionRestNode {
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
  }

  public interface IInstanceofOperatorBinaryExpressionRestNode extends INode, IBinaryExpressionRestNode {
    SourceToken<InstanceofKeywordToken> getInstanceofKeyword();

    ITypeNode getType();
  }

  public class InstanceofOperatorBinaryExpressionRestNode implements IInstanceofOperatorBinaryExpressionRestNode {
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
  }

  public interface IInfixOperatorNode extends INode {
  }

  public class InfixOperatorNode implements IInfixOperatorNode {
    public InfixOperatorNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IExpression3Node extends INode, IExpression2Node {
  }

  public class Expression3Node implements IExpression3Node {
    public Expression3Node() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IPrefixExpressionNode extends INode, IExpression3Node {
    IPrefixOperatorNode getPrefixOperator();

    IExpression3Node getExpression3();
  }

  public class PrefixExpressionNode implements IPrefixExpressionNode {
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
  }

  public interface IPrefixOperatorNode extends INode {
  }

  public class PrefixOperatorNode implements IPrefixOperatorNode {
    public PrefixOperatorNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IPossibleCastExpressionNode extends INode, IExpression3Node {
  }

  public class PossibleCastExpressionNode implements IPossibleCastExpressionNode {
    public PossibleCastExpressionNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IPossibleCastExpression_TypeNode extends INode, IPossibleCastExpressionNode {
    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    ITypeNode getType();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    IExpression3Node getExpression3();
  }

  public class PossibleCastExpression_TypeNode implements IPossibleCastExpression_TypeNode {
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
  }

  public interface IPossibleCastExpression_ExpressionNode extends INode, IPossibleCastExpressionNode {
    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();

    IExpression3Node getExpression3();
  }

  public class PossibleCastExpression_ExpressionNode implements IPossibleCastExpression_ExpressionNode {
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
  }

  public interface IPrimaryExpressionNode extends INode, IExpression3Node {
    IValueExpressionNode getValueExpression();

    List<ISelectorNode> getSelectorList();

    IPostfixOperatorNode getOptionalPostfixOperator();
  }

  public class PrimaryExpressionNode implements IPrimaryExpressionNode {
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
  }

  public interface IPostfixOperatorNode extends INode {
  }

  public class PostfixOperatorNode implements IPostfixOperatorNode {
    public PostfixOperatorNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IValueExpressionNode extends INode {
  }

  public class ValueExpressionNode implements IValueExpressionNode {
    public ValueExpressionNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IClassAccessNode extends INode, IValueExpressionNode {
    ITypeNode getType();

    SourceToken<DotSeparatorToken> getDotSeparator();

    SourceToken<ClassKeywordToken> getClassKeyword();
  }

  public class ClassAccessNode implements IClassAccessNode {
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
  }

  public interface ISelectorNode extends INode {
  }

  public class SelectorNode implements ISelectorNode {
    public SelectorNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IDotSelectorNode extends INode, ISelectorNode {
    SourceToken<DotSeparatorToken> getDotSeparator();

    IValueExpressionNode getValueExpression();
  }

  public class DotSelectorNode implements IDotSelectorNode {
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
  }

  public interface IArraySelectorNode extends INode, ISelectorNode {
    SourceToken<LeftBracketSeparatorToken> getLeftBracketSeparator();

    IExpressionNode getExpression();

    SourceToken<RightBracketSeparatorToken> getRightBracketSeparator();
  }

  public class ArraySelectorNode implements IArraySelectorNode {
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
  }

  public interface IParenthesizedExpressionNode extends INode, IValueExpressionNode {
    SourceToken<LeftParenthesisSeparatorToken> getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    SourceToken<RightParenthesisSeparatorToken> getRightParenthesisSeparator();
  }

  public class ParenthesizedExpressionNode implements IParenthesizedExpressionNode {
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
  }

  public interface IMethodInvocationNode extends INode, IValueExpressionNode {
    INonWildcardTypeArgumentsNode getOptionalNonWildcardTypeArguments();

    SourceToken<IdentifierToken> getIdentifier();

    IArgumentsNode getArguments();
  }

  public class MethodInvocationNode implements IMethodInvocationNode {
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
  }

  public interface IThisConstructorInvocationNode extends INode, IValueExpressionNode {
    SourceToken<ThisKeywordToken> getThisKeyword();

    IArgumentsNode getArguments();
  }

  public class ThisConstructorInvocationNode implements IThisConstructorInvocationNode {
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
  }

  public interface ISuperConstructorInvocationNode extends INode, IValueExpressionNode {
    SourceToken<SuperKeywordToken> getSuperKeyword();

    IArgumentsNode getArguments();
  }

  public class SuperConstructorInvocationNode implements ISuperConstructorInvocationNode {
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
  }

  public interface ICreationExpressionNode extends INode, IValueExpressionNode {
  }

  public class CreationExpressionNode implements ICreationExpressionNode {
    public CreationExpressionNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IObjectCreationExpressionNode extends INode, ICreationExpressionNode {
    SourceToken<NewKeywordToken> getNewKeyword();

    INonWildcardTypeArgumentsNode getOptionalNonWildcardTypeArguments();

    IClassOrInterfaceTypeNode getClassOrInterfaceType();

    IArgumentsNode getArguments();

    IClassBodyNode getOptionalClassBody();
  }

  public class ObjectCreationExpressionNode implements IObjectCreationExpressionNode {
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
  }

  public interface IArrayCreationExpressionNode extends INode, ICreationExpressionNode {
    SourceToken<NewKeywordToken> getNewKeyword();

    IArrayCreationTypeNode getArrayCreationType();

    List<IDimensionExpressionNode> getDimensionExpressionList();

    IArrayInitializerNode getOptionalArrayInitializer();
  }

  public class ArrayCreationExpressionNode implements IArrayCreationExpressionNode {
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
  }

  public interface IArrayCreationTypeNode extends INode {
  }

  public class ArrayCreationTypeNode implements IArrayCreationTypeNode {
    public ArrayCreationTypeNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }

  public interface IDimensionExpressionNode extends INode {
    SourceToken<LeftBracketSeparatorToken> getLeftBracketSeparator();

    IExpressionNode getOptionalExpression();

    SourceToken<RightBracketSeparatorToken> getRightBracketSeparator();
  }

  public class DimensionExpressionNode implements IDimensionExpressionNode {
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
  }

  public interface IArrayInitializerNode extends INode, IVariableInitializerNode, IVariableDeclaratorAssignmentNode {
    SourceToken<LeftCurlySeparatorToken> getLeftCurlySeparator();

    List<IVariableInitializerNode> getOptionalVariableInitializerList();

    SourceToken<CommaSeparatorToken> getOptionalCommaSeparator();

    SourceToken<RightCurlySeparatorToken> getRightCurlySeparator();
  }

  public class ArrayInitializerNode implements IArrayInitializerNode {
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
  }

  public interface IVariableInitializerNode extends INode {
  }

  public class VariableInitializerNode implements IVariableInitializerNode {
    public VariableInitializerNode() {
    }

    public void accept(INodeVisitor visitor) {
      visitor.visit(this);
    }
  }
}
