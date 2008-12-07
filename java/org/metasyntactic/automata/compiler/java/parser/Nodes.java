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

import org.metasyntactic.automata.compiler.java.scanner.*;
import org.metasyntactic.automata.compiler.java.scanner.keywords.*;
import org.metasyntactic.automata.compiler.java.scanner.operators.*;
import org.metasyntactic.automata.compiler.java.scanner.separators.*;

import java.util.List;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class Nodes {
  public interface ICompilationUnitNode {
    IPackageDeclarationNode getOptionalPackageDeclaration();

    List<IImportDeclarationNode> getImportDeclarationList();

    List<ITypeDeclarationNode> getTypeDeclarationList();
  }

  public interface IPackageDeclarationNode {
    List<IAnnotationNode> getAnnotationList();

    PackageKeywordToken getPackageKeyword();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SemicolonSeparatorToken getSemicolonSeparator();
  }

  public interface IQualifiedIdentifierNode {
    List<IdentifierToken> getIdentifierList();
  }

  public interface IImportDeclarationNode {
  }

  public interface ISingleTypeImportDeclarationNode extends IImportDeclarationNode {
    ImportKeywordToken getImportKeyword();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SemicolonSeparatorToken getSemicolonSeparator();
  }

  public interface ITypeImportOnDemandDeclarationNode extends IImportDeclarationNode {
    ImportKeywordToken getImportKeyword();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    DotSeparatorToken getDotSeparator();

    TimesOperatorToken getTimesOperator();

    SemicolonSeparatorToken getSemicolonSeparator();
  }

  public interface ISingleStaticImportDeclarationNode extends IImportDeclarationNode {
    ImportKeywordToken getImportKeyword();

    StaticKeywordToken getStaticKeyword();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    SemicolonSeparatorToken getSemicolonSeparator();
  }

  public interface IStaticImportOnDemandDeclarationNode extends IImportDeclarationNode {
    ImportKeywordToken getImportKeyword();

    StaticKeywordToken getStaticKeyword();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    DotSeparatorToken getDotSeparator();

    TimesOperatorToken getTimesOperator();

    SemicolonSeparatorToken getSemicolonSeparator();
  }

  public interface ITypeDeclarationNode extends IClassOrInterfaceMemberDeclarationNode {
  }

  public interface IClassDeclarationNode extends IBlockStatementNode, ITypeDeclarationNode {
  }

  public interface INormalClassDeclarationNode extends IClassDeclarationNode {
    IModifiersNode getModifiers();

    ClassKeywordToken getClassKeyword();

    IdentifierToken getIdentifier();

    ITypeParametersNode getOptionalTypeParameters();

    ISuperNode getOptionalSuper();

    IInterfacesNode getOptionalInterfaces();

    IClassBodyNode getClassBody();
  }

  public interface IModifiersNode {
    List<IModifierNode> getModifierList();
  }

  public interface IModifierNode {
  }

  public interface ISuperNode {
    ExtendsKeywordToken getExtendsKeyword();

    IClassOrInterfaceTypeNode getClassOrInterfaceType();
  }

  public interface IInterfacesNode {
    ImplementsKeywordToken getImplementsKeyword();

    List<IClassOrInterfaceTypeNode> getClassOrInterfaceTypeList();
  }

  public interface IClassBodyNode {
    LeftCurlySeparatorToken getLeftCurlySeparator();

    List<IClassBodyDeclarationNode> getClassBodyDeclarationList();

    RightCurlySeparatorToken getRightCurlySeparator();
  }

  public interface IClassBodyDeclarationNode {
  }

  public interface IStaticInitializerNode extends IClassBodyDeclarationNode {
    StaticKeywordToken getStaticKeyword();

    IBlockNode getBlock();
  }

  public interface IInterfaceDeclarationNode extends ITypeDeclarationNode {
  }

  public interface INormalInterfaceDeclarationNode extends IInterfaceDeclarationNode {
    IModifiersNode getModifiers();

    InterfaceKeywordToken getInterfaceKeyword();

    IdentifierToken getIdentifier();

    ITypeParametersNode getOptionalTypeParameters();

    IExtendsInterfacesNode getOptionalExtendsInterfaces();

    IClassOrInterfaceBodyNode getClassOrInterfaceBody();
  }

  public interface IExtendsInterfacesNode {
    ExtendsKeywordToken getExtendsKeyword();

    List<IClassOrInterfaceTypeNode> getClassOrInterfaceTypeList();
  }

  public interface IClassOrInterfaceBodyNode {
    LeftCurlySeparatorToken getLeftCurlySeparator();

    List<IClassOrInterfaceMemberDeclarationNode> getClassOrInterfaceMemberDeclarationList();

    RightCurlySeparatorToken getRightCurlySeparator();
  }

  public interface IEnumDeclarationNode extends IClassDeclarationNode {
    IModifiersNode getModifiers();

    EnumKeywordToken getEnumKeyword();

    IdentifierToken getIdentifier();

    IInterfacesNode getOptionalInterfaces();

    IEnumBodyNode getEnumBody();
  }

  public interface IEnumBodyNode {
    LeftCurlySeparatorToken getLeftCurlySeparator();

    List<IEnumConstantNode> getOptionalEnumConstantList();

    CommaSeparatorToken getOptionalCommaSeparator();

    SemicolonSeparatorToken getOptionalSemicolonSeparator();

    List<IClassBodyDeclarationNode> getClassBodyDeclarationList();

    RightCurlySeparatorToken getRightCurlySeparator();
  }

  public interface IEnumConstantNode {
    List<IAnnotationNode> getAnnotationList();

    IdentifierToken getIdentifier();

    IArgumentsNode getOptionalArguments();

    IClassOrInterfaceBodyNode getOptionalClassOrInterfaceBody();
  }

  public interface IArgumentsNode {
    LeftParenthesisSeparatorToken getLeftParenthesisSeparator();

    List<IExpressionNode> getOptionalExpressionList();

    RightParenthesisSeparatorToken getRightParenthesisSeparator();
  }

  public interface IAnnotationDeclarationNode extends IInterfaceDeclarationNode {
    IModifiersNode getModifiers();

    AtSeparatorToken getAtSeparator();

    InterfaceKeywordToken getInterfaceKeyword();

    IdentifierToken getIdentifier();

    IAnnotationBodyNode getAnnotationBody();
  }

  public interface IAnnotationBodyNode {
    LeftCurlySeparatorToken getLeftCurlySeparator();

    List<IAnnotationElementDeclarationNode> getAnnotationElementDeclarationList();

    RightCurlySeparatorToken getRightCurlySeparator();
  }

  public interface IAnnotationElementDeclarationNode {
  }

  public interface IAnnotationDefaultDeclarationNode extends IAnnotationElementDeclarationNode {
    IModifiersNode getModifiers();

    ITypeNode getType();

    IdentifierToken getIdentifier();

    LeftParenthesisSeparatorToken getLeftParenthesisSeparator();

    RightParenthesisSeparatorToken getRightParenthesisSeparator();

    DefaultKeywordToken getDefaultKeyword();

    IElementValueNode getElementValue();
  }

  public interface IClassOrInterfaceMemberDeclarationNode
      extends IClassBodyDeclarationNode, IAnnotationElementDeclarationNode {
  }

  public interface IConstructorDeclarationNode extends IClassBodyDeclarationNode {
    IModifiersNode getModifiers();

    ITypeParametersNode getOptionalTypeParameters();

    IdentifierToken getIdentifier();

    LeftParenthesisSeparatorToken getLeftParenthesisSeparator();

    List<IFormalParameterNode> getOptionalFormalParameterList();

    RightParenthesisSeparatorToken getRightParenthesisSeparator();

    IThrowsNode getOptionalThrows();

    IBlockNode getBlock();
  }

  public interface IFieldDeclarationNode extends IClassOrInterfaceMemberDeclarationNode {
    IModifiersNode getModifiers();

    ITypeNode getType();

    List<IVariableDeclaratorNode> getVariableDeclaratorList();

    SemicolonSeparatorToken getSemicolonSeparator();
  }

  public interface IVariableDeclaratorNode {
  }

  public interface IVariableDeclaratorIdAndAssignmentNode extends IVariableDeclaratorNode {
    IVariableDeclaratorIdNode getVariableDeclaratorId();

    EqualsOperatorToken getEqualsOperator();

    IVariableDeclaratorAssignmentNode getVariableDeclaratorAssignment();
  }

  public interface IVariableDeclaratorAssignmentNode {
  }

  public interface IVariableDeclaratorIdNode extends IVariableDeclaratorNode {
    IdentifierToken getIdentifier();

    List<IBracketPairNode> getBracketPairList();
  }

  public interface IBracketPairNode {
    LeftBracketSeparatorToken getLeftBracketSeparator();

    RightBracketSeparatorToken getRightBracketSeparator();
  }

  public interface IMethodDeclarationNode extends IClassOrInterfaceMemberDeclarationNode {
    IModifiersNode getModifiers();

    ITypeParametersNode getOptionalTypeParameters();

    ITypeNode getType();

    IdentifierToken getIdentifier();

    LeftParenthesisSeparatorToken getLeftParenthesisSeparator();

    List<IFormalParameterNode> getOptionalFormalParameterList();

    RightParenthesisSeparatorToken getRightParenthesisSeparator();

    List<IBracketPairNode> getBracketPairList();

    IThrowsNode getOptionalThrows();

    IMethodBodyNode getMethodBody();
  }

  public interface IMethodBodyNode {
  }

  public interface IFormalParameterNode {
    IModifiersNode getModifiers();

    ITypeNode getType();

    EllipsisSeparatorToken getOptionalEllipsisSeparator();

    IVariableDeclaratorIdNode getVariableDeclaratorId();
  }

  public interface IThrowsNode {
    ThrowsKeywordToken getThrowsKeyword();

    List<IClassOrInterfaceTypeNode> getClassOrInterfaceTypeList();
  }

  public interface ITypeParametersNode {
    LessThanOperatorToken getLessThanOperator();

    List<ITypeParameterNode> getTypeParameterList();

    GreaterThanOperatorToken getGreaterThanOperator();
  }

  public interface ITypeParameterNode {
    IdentifierToken getIdentifier();

    ITypeBoundNode getOptionalTypeBound();
  }

  public interface ITypeBoundNode {
    ExtendsKeywordToken getExtendsKeyword();

    List<IClassOrInterfaceTypeNode> getClassOrInterfaceTypeList();
  }

  public interface ITypeNode {
  }

  public interface IReferenceTypeNode extends ITypeArgumentNode, ITypeNode {
  }

  public interface IPrimitiveArrayReferenceTypeNode extends IReferenceTypeNode {
    IPrimitiveTypeNode getPrimitiveType();

    List<IBracketPairNode> getBracketPairList();
  }

  public interface IClassOrInterfaceReferenceTypeNode extends IReferenceTypeNode {
    IClassOrInterfaceTypeNode getClassOrInterfaceType();

    List<IBracketPairNode> getBracketPairList();
  }

  public interface IClassOrInterfaceTypeNode extends IArrayCreationTypeNode {
    List<ISingleClassOrInterfaceTypeNode> getSingleClassOrInterfaceTypeList();
  }

  public interface ISingleClassOrInterfaceTypeNode {
    IdentifierToken getIdentifier();

    ITypeArgumentsNode getOptionalTypeArguments();
  }

  public interface ITypeArgumentsNode {
    LessThanOperatorToken getLessThanOperator();

    List<ITypeArgumentNode> getTypeArgumentList();

    GreaterThanOperatorToken getGreaterThanOperator();
  }

  public interface ITypeArgumentNode {
  }

  public interface IWildcardTypeArgumentNode extends ITypeArgumentNode {
  }

  public interface IExtendsWildcardTypeArgumentNode extends IWildcardTypeArgumentNode {
    QuestionMarkOperatorToken getQuestionMarkOperator();

    ExtendsKeywordToken getExtendsKeyword();

    IReferenceTypeNode getReferenceType();
  }

  public interface ISuperWildcardTypeArgumentNode extends IWildcardTypeArgumentNode {
    QuestionMarkOperatorToken getQuestionMarkOperator();

    SuperKeywordToken getSuperKeyword();

    IReferenceTypeNode getReferenceType();
  }

  public interface IOpenWildcardTypeArgumentNode extends IWildcardTypeArgumentNode {
    QuestionMarkOperatorToken getQuestionMarkOperator();
  }

  public interface INonWildcardTypeArgumentsNode {
    LessThanOperatorToken getLessThanOperator();

    List<IReferenceTypeNode> getReferenceTypeList();

    GreaterThanOperatorToken getGreaterThanOperator();
  }

  public interface IPrimitiveTypeNode extends IArrayCreationTypeNode, ITypeNode {
  }

  public interface IAnnotationNode extends IElementValueNode, IModifierNode {
  }

  public interface INormalAnnotationNode extends IAnnotationNode {
    AtSeparatorToken getAtSeparator();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    LeftParenthesisSeparatorToken getLeftParenthesisSeparator();

    List<IElementValuePairNode> getOptionalElementValuePairList();

    RightParenthesisSeparatorToken getRightParenthesisSeparator();
  }

  public interface IElementValuePairNode {
    IdentifierToken getIdentifier();

    EqualsOperatorToken getEqualsOperator();

    IElementValueNode getElementValue();
  }

  public interface ISingleElementAnnotationNode extends IAnnotationNode {
    AtSeparatorToken getAtSeparator();

    IQualifiedIdentifierNode getQualifiedIdentifier();

    LeftParenthesisSeparatorToken getLeftParenthesisSeparator();

    IElementValueNode getElementValue();

    RightParenthesisSeparatorToken getRightParenthesisSeparator();
  }

  public interface IMarkerAnnotationNode extends IAnnotationNode {
    AtSeparatorToken getAtSeparator();

    IQualifiedIdentifierNode getQualifiedIdentifier();
  }

  public interface IElementValueNode {
  }

  public interface IElementValueArrayInitializerNode extends IElementValueNode {
    LeftCurlySeparatorToken getLeftCurlySeparator();

    List<IElementValueNode> getOptionalElementValueList();

    CommaSeparatorToken getOptionalCommaSeparator();

    RightCurlySeparatorToken getRightCurlySeparator();
  }

  public interface IBlockNode extends IClassBodyDeclarationNode, IStatementNode, IMethodBodyNode {
    LeftCurlySeparatorToken getLeftCurlySeparator();

    List<IBlockStatementNode> getBlockStatementList();

    RightCurlySeparatorToken getRightCurlySeparator();
  }

  public interface IBlockStatementNode {
  }

  public interface ILocalVariableDeclarationStatementNode extends IBlockStatementNode {
    ILocalVariableDeclarationNode getLocalVariableDeclaration();

    SemicolonSeparatorToken getSemicolonSeparator();
  }

  public interface ILocalVariableDeclarationNode extends IForInitializerNode {
    IModifiersNode getModifiers();

    ITypeNode getType();

    List<IVariableDeclaratorNode> getVariableDeclaratorList();
  }

  public interface IStatementNode extends IBlockStatementNode {
  }

  public interface IEmptyStatementNode extends IStatementNode {
    SemicolonSeparatorToken getSemicolonSeparator();
  }

  public interface ILabeledStatementNode extends IStatementNode {
    IdentifierToken getIdentifier();

    ColonOperatorToken getColonOperator();

    IStatementNode getStatement();
  }

  public interface IExpressionStatementNode extends IStatementNode {
    IExpressionNode getExpression();

    SemicolonSeparatorToken getSemicolonSeparator();
  }

  public interface IIfStatementNode extends IStatementNode {
    IfKeywordToken getIfKeyword();

    LeftParenthesisSeparatorToken getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    RightParenthesisSeparatorToken getRightParenthesisSeparator();

    IStatementNode getStatement();

    IElseStatementNode getOptionalElseStatement();
  }

  public interface IElseStatementNode {
    ElseKeywordToken getElseKeyword();

    IStatementNode getStatement();
  }

  public interface IAssertStatementNode extends IStatementNode {
  }

  public interface IMessageAssertStatementNode extends IAssertStatementNode {
    AssertKeywordToken getAssertKeyword();

    IExpressionNode getExpression();

    ColonOperatorToken getColonOperator();

    IExpressionNode getExpression2();

    SemicolonSeparatorToken getSemicolonSeparator();
  }

  public interface ISimpleAssertStatementNode extends IAssertStatementNode {
    AssertKeywordToken getAssertKeyword();

    IExpressionNode getExpression();

    SemicolonSeparatorToken getSemicolonSeparator();
  }

  public interface ISwitchStatementNode extends IStatementNode {
    SwitchKeywordToken getSwitchKeyword();

    LeftParenthesisSeparatorToken getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    RightParenthesisSeparatorToken getRightParenthesisSeparator();

    LeftCurlySeparatorToken getLeftCurlySeparator();

    List<ISwitchBlockStatementGroupNode> getSwitchBlockStatementGroupList();

    List<ISwitchLabelNode> getSwitchLabelList();

    RightCurlySeparatorToken getRightCurlySeparator();
  }

  public interface ISwitchBlockStatementGroupNode {
    List<ISwitchLabelNode> getSwitchLabelList();

    List<IBlockStatementNode> getBlockStatementList();
  }

  public interface ISwitchLabelNode {
  }

  public interface ICaseSwitchLabelNode extends ISwitchLabelNode {
    CaseKeywordToken getCaseKeyword();

    IExpressionNode getExpression();

    ColonOperatorToken getColonOperator();
  }

  public interface IDefaultSwitchLabelNode extends ISwitchLabelNode {
    DefaultKeywordToken getDefaultKeyword();

    ColonOperatorToken getColonOperator();
  }

  public interface IWhileStatementNode extends IStatementNode {
    WhileKeywordToken getWhileKeyword();

    LeftParenthesisSeparatorToken getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    RightParenthesisSeparatorToken getRightParenthesisSeparator();

    IStatementNode getStatement();
  }

  public interface IDoStatementNode extends IStatementNode {
    DoKeywordToken getDoKeyword();

    IStatementNode getStatement();

    WhileKeywordToken getWhileKeyword();

    LeftParenthesisSeparatorToken getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    RightParenthesisSeparatorToken getRightParenthesisSeparator();

    SemicolonSeparatorToken getSemicolonSeparator();
  }

  public interface IForStatementNode extends IStatementNode {
  }

  public interface IBasicForStatementNode extends IForStatementNode {
    ForKeywordToken getForKeyword();

    LeftParenthesisSeparatorToken getLeftParenthesisSeparator();

    IForInitializerNode getOptionalForInitializer();

    SemicolonSeparatorToken getSemicolonSeparator();

    IExpressionNode getOptionalExpression();

    SemicolonSeparatorToken getSemicolonSeparator2();

    IForUpdateNode getOptionalForUpdate();

    RightParenthesisSeparatorToken getRightParenthesisSeparator();

    IStatementNode getStatement();
  }

  public interface IForInitializerNode {
  }

  public interface IForUpdateNode {
    List<IExpressionNode> getExpressionList();
  }

  public interface IEnhancedForStatementNode extends IForStatementNode {
    ForKeywordToken getForKeyword();

    LeftParenthesisSeparatorToken getLeftParenthesisSeparator();

    IModifiersNode getModifiers();

    ITypeNode getType();

    IdentifierToken getIdentifier();

    ColonOperatorToken getColonOperator();

    IExpressionNode getExpression();

    RightParenthesisSeparatorToken getRightParenthesisSeparator();

    IStatementNode getStatement();
  }

  public interface IBreakStatementNode extends IStatementNode {
    BreakKeywordToken getBreakKeyword();

    IdentifierToken getOptionalIdentifier();

    SemicolonSeparatorToken getSemicolonSeparator();
  }

  public interface IContinueStatementNode extends IStatementNode {
    ContinueKeywordToken getContinueKeyword();

    IdentifierToken getOptionalIdentifier();

    SemicolonSeparatorToken getSemicolonSeparator();
  }

  public interface IReturnStatementNode extends IStatementNode {
    ReturnKeywordToken getReturnKeyword();

    IExpressionNode getOptionalExpression();

    SemicolonSeparatorToken getSemicolonSeparator();
  }

  public interface IThrowStatementNode extends IStatementNode {
    ThrowKeywordToken getThrowKeyword();

    IExpressionNode getOptionalExpression();

    SemicolonSeparatorToken getSemicolonSeparator();
  }

  public interface ISynchronizedStatementNode extends IStatementNode {
    SynchronizedKeywordToken getSynchronizedKeyword();

    LeftParenthesisSeparatorToken getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    RightParenthesisSeparatorToken getRightParenthesisSeparator();

    IBlockNode getBlock();
  }

  public interface ITryStatementNode extends IStatementNode {
  }

  public interface ITryStatementWithFinallyNode extends ITryStatementNode {
    TryKeywordToken getTryKeyword();

    IBlockNode getBlock();

    List<ICatchClauseNode> getCatchClauseList();

    FinallyKeywordToken getFinallyKeyword();

    IBlockNode getBlock2();
  }

  public interface ITryStatementWithoutFinallyNode extends ITryStatementNode {
    TryKeywordToken getTryKeyword();

    IBlockNode getBlock();

    List<ICatchClauseNode> getCatchClauseList();
  }

  public interface ICatchClauseNode {
    CatchKeywordToken getCatchKeyword();

    LeftParenthesisSeparatorToken getLeftParenthesisSeparator();

    IFormalParameterNode getFormalParameter();

    RightParenthesisSeparatorToken getRightParenthesisSeparator();

    IBlockNode getBlock();
  }

  public interface IExpressionNode
      extends IElementValueNode, IVariableInitializerNode, IVariableDeclaratorAssignmentNode {
    List<IExpression1Node> getExpression1List();
  }

  public interface IAssignmentOperatorNode {
  }

  public interface IExpression1Node {
  }

  public interface ITernaryExpressionNode extends IExpression1Node {
    IExpression2Node getExpression2();

    QuestionMarkOperatorToken getQuestionMarkOperator();

    IExpressionNode getExpression();

    ColonOperatorToken getColonOperator();

    IExpression1Node getExpression1();
  }

  public interface IExpression2Node extends IExpression1Node {
  }

  public interface IBinaryExpressionNode extends IExpression2Node {
    IExpression3Node getExpression3();

    List<IBinaryExpressionRestNode> getBinaryExpressionRestList();
  }

  public interface IBinaryExpressionRestNode {
  }

  public interface IInfixOperatorBinaryExpressionRestNode extends IBinaryExpressionRestNode {
    IInfixOperatorNode getInfixOperator();

    IExpression3Node getExpression3();
  }

  public interface IInstanceofOperatorBinaryExpressionRestNode extends IBinaryExpressionRestNode {
    InstanceofKeywordToken getInstanceofKeyword();

    ITypeNode getType();
  }

  public interface IInfixOperatorNode {
  }

  public interface IExpression3Node extends IExpression2Node {
  }

  public interface IPrefixExpressionNode extends IExpression3Node {
    IPrefixOperatorNode getPrefixOperator();

    IExpression3Node getExpression3();
  }

  public interface IPrefixOperatorNode {
  }

  public interface IPossibleCastExpressionNode extends IExpression3Node {
  }

  public interface IPossibleCastExpression_TypeNode extends IPossibleCastExpressionNode {
    LeftParenthesisSeparatorToken getLeftParenthesisSeparator();

    ITypeNode getType();

    RightParenthesisSeparatorToken getRightParenthesisSeparator();

    IExpression3Node getExpression3();
  }

  public interface IPossibleCastExpression_ExpressionNode extends IPossibleCastExpressionNode {
    LeftParenthesisSeparatorToken getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    RightParenthesisSeparatorToken getRightParenthesisSeparator();

    IExpression3Node getExpression3();
  }

  public interface IPrimaryExpressionNode extends IExpression3Node {
    IValueExpressionNode getValueExpression();

    List<ISelectorNode> getSelectorList();

    IPostfixOperatorNode getOptionalPostfixOperator();
  }

  public interface IPostfixOperatorNode {
  }

  public interface IValueExpressionNode {
  }

  public interface IClassAccessNode extends IValueExpressionNode {
    ITypeNode getType();

    DotSeparatorToken getDotSeparator();

    ClassKeywordToken getClassKeyword();
  }

  public interface ISelectorNode {
  }

  public interface IDotSelectorNode extends ISelectorNode {
    DotSeparatorToken getDotSeparator();

    IValueExpressionNode getValueExpression();
  }

  public interface IArraySelectorNode extends ISelectorNode {
    LeftBracketSeparatorToken getLeftBracketSeparator();

    IExpressionNode getExpression();

    RightBracketSeparatorToken getRightBracketSeparator();
  }

  public interface IParenthesizedExpressionNode extends IValueExpressionNode {
    LeftParenthesisSeparatorToken getLeftParenthesisSeparator();

    IExpressionNode getExpression();

    RightParenthesisSeparatorToken getRightParenthesisSeparator();
  }

  public interface IMethodInvocationNode extends IValueExpressionNode {
    INonWildcardTypeArgumentsNode getOptionalNonWildcardTypeArguments();

    IdentifierToken getIdentifier();

    IArgumentsNode getArguments();
  }

  public interface IThisConstructorInvocationNode extends IValueExpressionNode {
    ThisKeywordToken getThisKeyword();

    IArgumentsNode getArguments();
  }

  public interface ISuperConstructorInvocationNode extends IValueExpressionNode {
    SuperKeywordToken getSuperKeyword();

    IArgumentsNode getArguments();
  }

  public interface ICreationExpressionNode extends IValueExpressionNode {
  }

  public interface IObjectCreationExpressionNode extends ICreationExpressionNode {
    NewKeywordToken getNewKeyword();

    INonWildcardTypeArgumentsNode getOptionalNonWildcardTypeArguments();

    IClassOrInterfaceTypeNode getClassOrInterfaceType();

    IArgumentsNode getArguments();

    IClassBodyNode getOptionalClassBody();
  }

  public interface IArrayCreationExpressionNode extends ICreationExpressionNode {
    NewKeywordToken getNewKeyword();

    IArrayCreationTypeNode getArrayCreationType();

    List<IDimensionExpressionNode> getDimensionExpressionList();

    IArrayInitializerNode getOptionalArrayInitializer();
  }

  public interface IArrayCreationTypeNode {
  }

  public interface IDimensionExpressionNode {
    LeftBracketSeparatorToken getLeftBracketSeparator();

    IExpressionNode getOptionalExpression();

    RightBracketSeparatorToken getRightBracketSeparator();
  }

  public interface IArrayInitializerNode extends IVariableInitializerNode, IVariableDeclaratorAssignmentNode {
    LeftCurlySeparatorToken getLeftCurlySeparator();

    List<IVariableInitializerNode> getOptionalVariableInitializerList();

    CommaSeparatorToken getOptionalCommaSeparator();

    RightCurlySeparatorToken getRightCurlySeparator();
  }

  public interface IVariableInitializerNode {
  }
}
