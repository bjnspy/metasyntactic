package org.metasyntactic.automata.compiler.java.parser;

import org.metasyntactic.automata.compiler.framework.parsers.Source;
import org.metasyntactic.automata.compiler.framework.parsers.SourceToken;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.PackratGrammar;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.Rule;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions.Expression;
import static org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions.Expression.*;
import org.metasyntactic.automata.compiler.java.scanner.IdentifierToken;
import org.metasyntactic.automata.compiler.java.scanner.JavaScanner;
import org.metasyntactic.automata.compiler.java.scanner.JavaToken;
import org.metasyntactic.automata.compiler.java.scanner.keywords.*;
import org.metasyntactic.automata.compiler.java.scanner.literals.LiteralToken;
import org.metasyntactic.automata.compiler.java.scanner.operators.*;
import org.metasyntactic.automata.compiler.java.scanner.separators.*;

import java.io.*;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class JavaGrammar extends PackratGrammar<JavaToken.Type> {
  private final static Rule javaStartRule;
  private final static Set<Rule> javaRules;

  static {
    SeparatorToken.getSeparators();
    OperatorToken.getOperators();
    KeywordToken.getKeywords();

    javaStartRule = new Rule("CompilationUnit", sequence(optional(variable("PackageDeclaration")), repetition(variable(
        "ImportDeclaration")), repetition(variable("TypeDeclaration")), endOfTokens()));

    javaRules = new LinkedHashSet<Rule>();
    javaRules.add(javaStartRule);

    Set<Rule> rules = javaRules;

    addCompilationUnit(rules);

    addClassDeclaration(rules);
    addInterfaceDeclaration(rules);
    addEnumDeclaration(rules);
    addAnnotationDeclaration(rules);
    addMemberDeclarations(rules);

    addTypes(rules);
    addAnnotation(rules);
    addStatements(rules);
    addExpressions(rules);
    addArrays(rules);
  }

  private static void addArrays(Set<Rule> rules) {
    rules.add(new Rule("ArrayInitializer", sequence(token(LeftCurlySeparatorToken.instance), delimitedOptionalList(
        variable("VariableInitializer"), token(CommaSeparatorToken.instance)), optional(token(
        CommaSeparatorToken.instance)), token(RightCurlySeparatorToken.instance))));

    rules.add(new Rule("VariableInitializer", choice(variable("ArrayInitializer"), variable("Expression"))));
  }

  private static void addTypes(Set<Rule> rules) {
    rules.add(new Rule("TypeParameters", sequence(token(LessThanOperatorToken.instance), delimitedList(variable(
        "TypeParameter"), token(CommaSeparatorToken.instance)), token(GreaterThanOperatorToken.instance))));

    rules.add(new Rule("TypeParameter", sequence(identifier(), optional(variable("TypeBound")))));

    rules.add(new Rule("TypeBound", sequence(token(ExtendsKeywordToken.instance), delimitedList(variable(
        "ClassOrInterfaceType"), token(BitwiseAndOperatorToken.instance)))));

    rules.add(new Rule("Type", choice(variable("ReferenceType"), variable("PrimitiveType"))));

    rules.add(new Rule("ReferenceType", choice(sequence(variable("PrimitiveType"), oneOrMore(sequence(token(
        LeftBracketSeparatorToken.instance), token(RightBracketSeparatorToken.instance)))), sequence(variable(
        "ClassOrInterfaceType"), repetition(sequence(token(LeftBracketSeparatorToken.instance), token(
        RightBracketSeparatorToken.instance)))))));

    rules.add(new Rule("ClassOrInterfaceType",
                       // Identifier  [TypeArguments] { . Identifier [TypeArguments]}
                       delimitedList(sequence(identifier(), optional(variable("TypeArguments"))), token(
                           DotSeparatorToken.instance))));

    rules.add(new Rule("TypeArguments", sequence(token(LessThanOperatorToken.instance), delimitedList(variable(
        "TypeArgument"), token(CommaSeparatorToken.instance)), token(GreaterThanOperatorToken.instance))));

    rules.add(new Rule("TypeArgument", choice(variable("ReferenceType"), sequence(token(
        QuestionMarkOperatorToken.instance), optional(sequence(choice(token(ExtendsKeywordToken.instance), token(
        SuperKeywordToken.instance)), variable("ReferenceType")))))));

    rules.add(new Rule("NonWildcardTypeArguments", sequence(token(LessThanOperatorToken.instance), delimitedList(
        variable("ReferenceType"), token(CommaSeparatorToken.instance)), token(GreaterThanOperatorToken.instance))));

    rules.add(new Rule("PrimitiveType", choice(token(ByteKeywordToken.instance), token(ShortKeywordToken.instance),
                                               token(CharKeywordToken.instance), token(IntKeywordToken.instance), token(
        LongKeywordToken.instance), token(FloatKeywordToken.instance), token(DoubleKeywordToken.instance), token(
        BooleanKeywordToken.instance), token(VoidKeywordToken.instance))));
  }

  private static void addEnumDeclaration(Set<Rule> rules) {
    rules.add(new Rule("EnumDeclaration", sequence(variable("Modifiers"), token(EnumKeywordToken.instance),
                                                   identifier(), optional(variable("Interfaces")), variable(
        "EnumBody"))));

    rules.add(new Rule("EnumBody", sequence(token(LeftCurlySeparatorToken.instance), delimitedOptionalList(variable(
        "EnumConstant"), token(CommaSeparatorToken.instance)), optional(token(CommaSeparatorToken.instance)), optional(
        token(SemicolonSeparatorToken.instance)), repetition(variable("ClassBodyDeclaration")), token(
        RightCurlySeparatorToken.instance))));

    rules.add(new Rule("EnumConstant", sequence(repetition(variable("Annotation")), identifier(), optional(variable(
        "Arguments")), optional(variable("ClassOrInterfaceBody")))));

    rules.add(new Rule("Arguments", sequence(token(LeftParenthesisSeparatorToken.instance), delimitedOptionalList(
        variable("Expression"), token(CommaSeparatorToken.instance)), token(RightParenthesisSeparatorToken.instance))));
  }

  private static void addAnnotationDeclaration(Set<Rule> rules) {
    rules.add(new Rule("AnnotationDeclaration", sequence(variable("Modifiers"), token(AtSeparatorToken.instance), token(
        InterfaceKeywordToken.instance), identifier(), variable("AnnotationBody"))));

    rules.add(new Rule("AnnotationBody", sequence(token(LeftCurlySeparatorToken.instance), repetition(variable(
        "AnnotationElementDeclaration")), token(RightCurlySeparatorToken.instance))));

    rules.add(new Rule("AnnotationElementDeclaration", choice(variable("AnnotationDefaultDeclaration"), variable(
        "ClassOrInterfaceMemberDeclaration"))));

    rules.add(new Rule("AnnotationDefaultDeclaration", sequence(variable("Modifiers"), variable("Type"), identifier(),
                                                                token(LeftParenthesisSeparatorToken.instance), token(
        RightParenthesisSeparatorToken.instance), token(DefaultKeywordToken.instance), variable("ElementValue"))));
  }

  private static void addMemberDeclarations(Set<Rule> rules) {
    rules.add(new Rule("ClassOrInterfaceMemberDeclaration", choice(variable("FieldDeclaration"), variable(
        "MethodDeclaration"), variable("TypeDeclaration"))));

    rules.add(new Rule("ConstructorDeclaration", sequence(variable("Modifiers"), optional(variable("TypeParameters")),
                                                          identifier(), token(LeftParenthesisSeparatorToken.instance),
                                                          delimitedOptionalList(variable("FormalParameter"), token(
                                                              CommaSeparatorToken.instance)), token(
        RightParenthesisSeparatorToken.instance), optional(variable("Throws")), variable("Block"))));

    rules.add(new Rule("FieldDeclaration", sequence(variable("Modifiers"), variable("Type"), delimitedList(variable(
        "VariableDeclarator"), token(CommaSeparatorToken.instance)), token(SemicolonSeparatorToken.instance))));

    rules.add(new Rule("VariableDeclarator", choice(sequence(variable("VariableDeclaratorId"), token(
        EqualsOperatorToken.instance), choice(variable("Expression"), variable("ArrayInitializer"))), variable(
        "VariableDeclaratorId"))));

    rules.add(new Rule("VariableDeclaratorId", sequence(identifier(), repetition(sequence(token(
        LeftBracketSeparatorToken.instance), token(RightBracketSeparatorToken.instance))))));

    rules.add(new Rule("MethodDeclaration", sequence(variable("Modifiers"), optional(variable("TypeParameters")),
                                                     variable("Type"), identifier(), token(
        LeftParenthesisSeparatorToken.instance), delimitedOptionalList(variable("FormalParameter"), token(
        CommaSeparatorToken.instance)), token(RightParenthesisSeparatorToken.instance), repetition(sequence(token(
        LeftBracketSeparatorToken.instance), token(RightBracketSeparatorToken.instance))), optional(variable("Throws")),
                                                                                           choice(variable("Block"),
                                                                                                  token(
                                                                                                      SemicolonSeparatorToken.instance)))));

    rules.add(new Rule("FormalParameter", sequence(variable("Modifiers"), variable("Type"), optional(token(
        EllipsisSeparatorToken.instance)), variable("VariableDeclaratorId"))));

    rules.add(new Rule("Throws", sequence(token(ThrowsKeywordToken.instance), delimitedList(variable(
        "ClassOrInterfaceType"), token(CommaSeparatorToken.instance)))));
  }

  private static void addExpressions(Set<Rule> rules) {
    rules.add(new Rule("Expression", delimitedList(variable("Expression1"), variable("AssignmentOperator"))));
    /*
        choice(
            variable("AssignmentExpression"),
            variable("Expression1"))
    ));

    rules.add(new Rule("AssignmentExpression",
        sequence(
            variable("Expression1"),
            variable("AssignmentOperator"),
            variable("Expression1")
        )));
        */

    rules.add(new Rule("AssignmentOperator", choice(token(EqualsOperatorToken.instance), token(
        PlusEqualsOperatorToken.instance), token(MinusEqualsOperatorToken.instance), token(
        TimesEqualsOperatorToken.instance), token(DivideEqualsOperatorToken.instance), token(
        AndEqualsOperatorToken.instance), token(OrEqualsOperatorToken.instance), token(
        ExclusiveOrEqualsOperatorToken.instance), token(ModulusEqualsOperatorToken.instance), token(
        LeftShiftEqualsOperatorToken.instance), token(RightShiftEqualsOperatorToken.instance), token(
        BitwiseRightShiftEqualsOperatorToken.instance))));

    rules.add(new Rule("Expression1", choice(variable("TernaryExpression"), variable("Expression2"))));

    rules.add(new Rule("TernaryExpression", sequence(variable("Expression2"), token(QuestionMarkOperatorToken.instance),
                                                     variable("Expression"), token(ColonOperatorToken.instance),
                                                     variable("Expression1"))));

    rules.add(new Rule("Expression2", choice(variable("BinaryExpression"), variable("Expression3"))));

    rules.add(new Rule("BinaryExpression", sequence(variable("Expression3"), oneOrMore(choice(sequence(variable(
        "InfixOperator"), variable("Expression3")), sequence(token(InstanceofKeywordToken.instance), variable(
        "Type")))))));

    /*
        choice(
            sequence(
                variable("Expression3"),
                token(InstanceofKeywordToken.instance),
                variable("Type")
            ),
            delimitedList(variable("Expression3"), choice(variable("InfixOperator"), va)
        )));
        */

    rules.add(new Rule("InfixOperator", choice(token(LogicalOrOperatorToken.instance), token(
        LogicalAndOperatorToken.instance), token(BitwiseOrOperatorToken.instance), token(
        BitwiseExclusiveOrOperatorToken.instance), token(BitwiseAndOperatorToken.instance), token(
        EqualsEqualsOperatorToken.instance), token(NotEqualsOperatorToken.instance), token(
        LessThanOperatorToken.instance), token(LessThanOrEqualsOperatorToken.instance), token(
        GreaterThanOrEqualsOperatorToken.instance), token(LeftShiftOperatorToken.instance), sequence(token(
        GreaterThanOperatorToken.instance), token(GreaterThanOperatorToken.instance), token(
        GreaterThanOperatorToken.instance)), sequence(token(GreaterThanOperatorToken.instance), token(
        GreaterThanOperatorToken.instance)), token(GreaterThanOperatorToken.instance), token(
        PlusOperatorToken.instance), token(MinusOperatorToken.instance), token(TimesOperatorToken.instance), token(
        DivideOperatorToken.instance), token(ModulusOperatorToken.instance))));

    rules.add(new Rule("Expression3", choice(variable("PrefixExpression"), variable("PossibleCastExpression"), variable(
        "PrimaryExpression"))));

    rules.add(new Rule("PrefixExpression", sequence(variable("PrefixOperator"), variable("Expression3"))));

    rules.add(new Rule("PrefixOperator", choice(token(IncrementOperatorToken.instance), token(
        DecrementOperatorToken.instance), token(LogicalNotOperatorToken.instance), token(
        BitwiseNotOperatorToken.instance), token(PlusOperatorToken.instance), token(MinusOperatorToken.instance))));

    rules.add(new Rule("PossibleCastExpression", sequence(token(LeftParenthesisSeparatorToken.instance), choice(
        variable("Type"), variable("Expression")), token(RightParenthesisSeparatorToken.instance), variable(
        "Expression3"))));

    rules.add(new Rule("PrimaryExpression", sequence(variable("ValueExpression"), repetition(variable("Selector")),
                                                     optional(variable("PostfixOperator")))));

    rules.add(new Rule("PostfixOperator", choice(token(IncrementOperatorToken.instance), token(
        DecrementOperatorToken.instance))));

    rules.add(new Rule("ValueExpression", choice(variable("ParenthesizedExpression"), variable("MethodInvocation"),
                                                 variable("ThisConstructorInvocation"), variable(
        "SuperConstructorInvocation"), token(ThisKeywordToken.instance), token(SuperKeywordToken.instance), variable(
        "ClassAccess"), type(LiteralToken.class), identifier(), variable("CreationExpression"))));

    rules.add(new Rule("ClassAccess", sequence(variable("Type"), token(DotSeparatorToken.instance), token(
        ClassKeywordToken.instance))));

    rules.add(new Rule("Selector", choice(variable("DotSelector"), variable("ArraySelector"))));

    rules.add(new Rule("DotSelector", sequence(token(DotSeparatorToken.instance), variable("ValueExpression"))));

    rules.add(new Rule("ArraySelector", sequence(token(LeftBracketSeparatorToken.instance), variable("Expression"),
                                                 token(RightBracketSeparatorToken.instance))));

    rules.add(new Rule("ParenthesizedExpression", sequence(token(LeftParenthesisSeparatorToken.instance), variable(
        "Expression"), token(RightParenthesisSeparatorToken.instance))));

    rules.add(new Rule("MethodInvocation", sequence(optional(variable("NonWildcardTypeArguments")), identifier(),
                                                    variable("Arguments"))));

    rules.add(new Rule("ThisConstructorInvocation", sequence(token(ThisKeywordToken.instance), variable("Arguments"))));

    rules.add(new Rule("SuperConstructorInvocation", sequence(token(SuperKeywordToken.instance), variable(
        "Arguments"))));

    rules.add(new Rule("CreationExpression", choice(variable("ObjectCreationExpression"), variable(
        "ArrayCreationExpression"))));

    rules.add(new Rule("ObjectCreationExpression", sequence(token(NewKeywordToken.instance), optional(variable(
        "NonWildcardTypeArguments")), variable("ClassOrInterfaceType"), variable("Arguments"), optional(variable(
        "ClassBody")))));

    rules.add(new Rule("ArrayCreationExpression", sequence(token(NewKeywordToken.instance), optional(variable(
        "NonWildcardTypeArguments")), choice(variable("ClassOrInterfaceType"), variable("PrimitiveType")), oneOrMore(
        sequence(token(LeftBracketSeparatorToken.instance), optional(variable("Expression")), token(
            RightBracketSeparatorToken.instance))), optional(variable("ArrayInitializer")))));
  }

  private static void addStatements(Set<Rule> rules) {
    rules.add(new Rule("Block", sequence(token(LeftCurlySeparatorToken.instance), repetition(variable(
        "BlockStatement")), token(RightCurlySeparatorToken.instance))));

    rules.add(new Rule("BlockStatement", choice(variable("LocalVariableDeclarationStatement"), variable(
        "ClassDeclaration"), variable("Statement"))));

    rules.add(new Rule("LocalVariableDeclarationStatement", sequence(variable("LocalVariableDeclaration"), token(
        SemicolonSeparatorToken.instance))));

    rules.add(new Rule("LocalVariableDeclaration", sequence(variable("Modifiers"), variable("Type"), delimitedList(
        variable("VariableDeclarator"), token(CommaSeparatorToken.instance)))));

    rules.add(new Rule("Statement", choice(variable("Block"), variable("EmptyStatement"), variable(
        "ExpressionStatement"), variable("AssertStatement"), variable("SwitchStatement"), variable("DoStatement"),
                                variable("BreakStatement"), variable("ContinueStatement"), variable("ReturnStatement"),
                                variable("SynchronizedStatement"), variable("ThrowStatement"), variable("TryStatement"),
                                variable("LabeledStatement"), variable("IfStatement"), variable("WhileStatement"),
                                variable("ForStatement"))));

    rules.add(new Rule("EmptyStatement", token(SemicolonSeparatorToken.instance)));

    rules.add(new Rule("LabeledStatement", sequence(identifier(), token(ColonOperatorToken.instance), variable(
        "Statement"))));

    rules.add(new Rule("ExpressionStatement", sequence(variable("Expression"), token(
        SemicolonSeparatorToken.instance))));

    rules.add(new Rule("IfStatement", sequence(token(IfKeywordToken.instance), token(
        LeftParenthesisSeparatorToken.instance), variable("Expression"), token(RightParenthesisSeparatorToken.instance),
                                                 variable("Statement"), optional(sequence(token(
        ElseKeywordToken.instance), variable("Statement"))))));

    rules.add(new Rule("AssertStatement", sequence(token(AssertKeywordToken.instance), variable("Expression"), optional(
        sequence(token(ColonOperatorToken.instance), variable("Expression"))), token(
        SemicolonSeparatorToken.instance))));

    rules.add(new Rule("SwitchStatement", sequence(token(SwitchKeywordToken.instance), token(
        LeftParenthesisSeparatorToken.instance), variable("Expression"), token(RightParenthesisSeparatorToken.instance),
                                                 token(LeftCurlySeparatorToken.instance), repetition(variable(
        "SwitchBlockStatementGroup")), repetition(variable("SwitchLabel")), token(RightCurlySeparatorToken.instance))));

    rules.add(new Rule("SwitchBlockStatementGroup", sequence(oneOrMore(variable("SwitchLabel")), oneOrMore(variable(
        "BlockStatement")))));

    rules.add(new Rule("SwitchLabel", choice(variable("CaseSwitchLabel"), variable("DefaultSwitchLabel"))));

    rules.add(new Rule("CaseSwitchLabel", sequence(token(CaseKeywordToken.instance), variable("Expression"), token(
        ColonOperatorToken.instance))));

    rules.add(new Rule("DefaultSwitchLabel", sequence(token(DefaultKeywordToken.instance), token(
        ColonOperatorToken.instance))));

    rules.add(new Rule("WhileStatement", sequence(token(WhileKeywordToken.instance), token(
        LeftParenthesisSeparatorToken.instance), variable("Expression"), token(RightParenthesisSeparatorToken.instance),
                                                 variable("Statement"))));

    rules.add(new Rule("DoStatement", sequence(token(DoKeywordToken.instance), variable("Statement"), token(
        WhileKeywordToken.instance), token(LeftParenthesisSeparatorToken.instance), variable("Expression"), token(
        RightParenthesisSeparatorToken.instance), token(SemicolonSeparatorToken.instance))));

    rules.add(new Rule("ForStatement", choice(variable("BasicForStatement"), variable("EnhancedForStatement"))));

    rules.add(new Rule("BasicForStatement", sequence(token(ForKeywordToken.instance), token(
        LeftParenthesisSeparatorToken.instance), optional(variable("ForInitializer")), token(
        SemicolonSeparatorToken.instance), optional(variable("Expression")), token(SemicolonSeparatorToken.instance),
                                           optional(variable("ForUpdate")), token(
        RightParenthesisSeparatorToken.instance), variable("Statement"))));

    rules.add(new Rule("ForInitializer", choice(variable("LocalVariableDeclaration"), delimitedList(variable(
        "Expression"), token(CommaSeparatorToken.instance)))));

    rules.add(new Rule("ForUpdate", delimitedList(variable("Expression"), token(CommaSeparatorToken.instance))));

    rules.add(new Rule("EnhancedForStatement", sequence(token(ForKeywordToken.instance), token(
        LeftParenthesisSeparatorToken.instance), variable("Modifiers"), variable("Type"), identifier(), token(
        ColonOperatorToken.instance), variable("Expression"), token(RightParenthesisSeparatorToken.instance), variable(
        "Statement"))));

    rules.add(new Rule("BreakStatement", sequence(token(BreakKeywordToken.instance), optional(identifier()), token(
        SemicolonSeparatorToken.instance))));

    rules.add(new Rule("ContinueStatement", sequence(token(ContinueKeywordToken.instance), optional(identifier()),
                                                     token(SemicolonSeparatorToken.instance))));

    rules.add(new Rule("ReturnStatement", sequence(token(ReturnKeywordToken.instance), optional(variable("Expression")),
                                                   token(SemicolonSeparatorToken.instance))));

    rules.add(new Rule("ThrowStatement", sequence(token(ThrowKeywordToken.instance), optional(variable("Expression")),
                                                  token(SemicolonSeparatorToken.instance))));

    rules.add(new Rule("SynchronizedStatement", sequence(token(SynchronizedKeywordToken.instance), token(
        LeftParenthesisSeparatorToken.instance), variable("Expression"), token(RightParenthesisSeparatorToken.instance),
                                                 variable("Block"))));

    rules.add(new Rule("TryStatement", choice(variable("TryStatementWithFinally"), variable(
        "TryStatementWithoutFinally"))));

    rules.add(new Rule("TryStatementWithFinally", sequence(token(TryKeywordToken.instance), variable("Block"),
                                                           repetition(variable("CatchClause")), token(
        FinallyKeywordToken.instance), variable("Block"))));

    rules.add(new Rule("TryStatementWithoutFinally", sequence(token(TryKeywordToken.instance), variable("Block"),
                                                              oneOrMore(variable("CatchClause")))));

    rules.add(new Rule("CatchClause", sequence(token(CatchKeywordToken.instance), token(
        LeftParenthesisSeparatorToken.instance), variable("FormalParameter"), token(
        RightParenthesisSeparatorToken.instance), variable("Block"))));
  }

  private static Expression identifier() {
    return type(IdentifierToken.class);
  }

  private static void addInterfaceDeclaration(Set<Rule> rules) {
    rules.add(new Rule("InterfaceDeclaration", choice(variable("NormalInterfaceDeclaration"), variable(
        "AnnotationDeclaration"))));

    rules.add(new Rule("NormalInterfaceDeclaration", sequence(variable("Modifiers"), token(
        InterfaceKeywordToken.instance), identifier(), optional(variable("TypeParameters")), optional(variable(
        "ExtendsInterfaces")), variable("ClassOrInterfaceBody"))));

    rules.add(new Rule("ExtendsInterfaces", sequence(token(ExtendsKeywordToken.instance), delimitedList(variable(
        "ClassOrInterfaceType"), token(CommaSeparatorToken.instance)))));

    rules.add(new Rule("ClassOrInterfaceBody", sequence(token(LeftCurlySeparatorToken.instance), repetition(variable(
        "ClassOrInterfaceMemberDeclaration")), token(RightCurlySeparatorToken.instance))));
  }

  private static void addClassDeclaration(Set<Rule> rules) {
    rules.add(new Rule("ClassDeclaration", choice(variable("NormalClassDeclaration"), variable("EnumDeclaration"))));

    rules.add(new Rule("NormalClassDeclaration", sequence(variable("Modifiers"), token(ClassKeywordToken.instance),
                                                          identifier(), optional(variable("TypeParameters")), optional(
        variable("Super")), optional(variable("Interfaces")), variable("ClassBody"))));

    rules.add(new Rule("Modifiers", repetition(variable("Modifier"))));

    rules.add(new Rule("Modifier", choice(variable("Annotation"), token(PublicKeywordToken.instance), token(
        ProtectedKeywordToken.instance), token(PrivateKeywordToken.instance), token(StaticKeywordToken.instance), token(
        AbstractKeywordToken.instance), token(FinalKeywordToken.instance), token(NativeKeywordToken.instance), token(
        SynchronizedKeywordToken.instance), token(TransientKeywordToken.instance), token(VolatileKeywordToken.instance),
                                            token(StrictfpKeywordToken.instance))));

    rules.add(new Rule("Super", sequence(token(ExtendsKeywordToken.instance), variable("ClassOrInterfaceType"))));

    rules.add(new Rule("Interfaces", sequence(token(ImplementsKeywordToken.instance), delimitedList(variable(
        "ClassOrInterfaceType"), token(CommaSeparatorToken.instance)))));

    rules.add(new Rule("ClassBody", sequence(token(LeftCurlySeparatorToken.instance), repetition(variable(
        "ClassBodyDeclaration")), token(RightCurlySeparatorToken.instance))));

    rules.add(new Rule("ClassBodyDeclaration", choice(variable("ClassOrInterfaceMemberDeclaration"), variable("Block"),
                                                      variable("StaticInitializer"), variable(
        "ConstructorDeclaration"))));

    rules.add(new Rule("StaticInitializer", sequence(token(StaticKeywordToken.instance), variable("Block"))));
  }

  private static Expression delimitedOptionalList(Expression element, Expression delimiter) {
    return optional(delimitedList(element, delimiter));
  }

  /*
  private static Expression delimitedList(Expression element, Expression delimiter) {
    return delimite
    return sequence(
        element,
        repetition(sequence(
            delimiter,
            element
        ))
    );
  }
  */

  private static void addCompilationUnit(Set<Rule> rules) {
    rules.add(new Rule("PackageDeclaration", sequence(repetition(variable("Annotation")), token(
        PackageKeywordToken.instance), variable("QualifiedIdentifier"), token(SemicolonSeparatorToken.instance))));

    rules.add(new Rule("QualifiedIdentifier", delimitedList(identifier(), token(DotSeparatorToken.instance))));

    rules.add(new Rule("ImportDeclaration", choice(variable("SingleTypeImportDeclaration"), variable(
        "TypeImportOnDemandDeclaration"), variable("SingleStaticImportDeclaration"), variable(
        "StaticImportOnDemandDeclaration"))));

    rules.add(new Rule("SingleTypeImportDeclaration", sequence(token(ImportKeywordToken.instance), variable(
        "QualifiedIdentifier"), token(SemicolonSeparatorToken.instance))));

    rules.add(new Rule("TypeImportOnDemandDeclaration", sequence(token(ImportKeywordToken.instance), variable(
        "QualifiedIdentifier"), token(DotSeparatorToken.instance), token(TimesOperatorToken.instance), token(
        SemicolonSeparatorToken.instance))));

    rules.add(new Rule("SingleStaticImportDeclaration", sequence(token(ImportKeywordToken.instance), token(
        StaticKeywordToken.instance), variable("QualifiedIdentifier"), token(SemicolonSeparatorToken.instance))));

    rules.add(new Rule("StaticImportOnDemandDeclaration", sequence(token(ImportKeywordToken.instance), token(
        StaticKeywordToken.instance), variable("QualifiedIdentifier"), token(DotSeparatorToken.instance), token(
        TimesOperatorToken.instance), token(SemicolonSeparatorToken.instance))));

    rules.add(new Rule("TypeDeclaration", choice(variable("ClassDeclaration"), variable("InterfaceDeclaration"), token(
        SemicolonSeparatorToken.instance))));
  }

  private static void addAnnotation(Set<Rule> rules) {
    rules.add(new Rule("Annotation", choice(variable("NormalAnnotation"), variable("SingleElementAnnotation"), variable(
        "MarkerAnnotation"))));

    rules.add(new Rule("NormalAnnotation", sequence(token(AtSeparatorToken.instance), variable("QualifiedIdentifier"),
                                                    token(LeftParenthesisSeparatorToken.instance), delimitedList(
        variable("ElementValuePair"), token(CommaSeparatorToken.instance)), token(
        RightParenthesisSeparatorToken.instance))));

    rules.add(new Rule("ElementValuePair", sequence(identifier(), token(EqualsOperatorToken.instance), variable(
        "ElementValue"))));

    rules.add(new Rule("SingleElementAnnotation", sequence(token(AtSeparatorToken.instance), variable(
        "QualifiedIdentifier"), token(LeftParenthesisSeparatorToken.instance), variable("ElementValue"), token(
        RightParenthesisSeparatorToken.instance))));

    rules.add(new Rule("MarkerAnnotation", sequence(token(AtSeparatorToken.instance), variable(
        "QualifiedIdentifier"))));

    rules.add(new Rule("ElementValue", choice(variable("Annotation"), variable("Expression"), variable(
        "ElementValueArrayInitializer"))));

    rules.add(new Rule("ElementValueArrayInitializer", sequence(token(LeftCurlySeparatorToken.instance),
                                                                delimitedOptionalList(variable("ElementValue"), token(
                                                                    CommaSeparatorToken.instance)), optional(token(
        CommaSeparatorToken.instance)), token(RightCurlySeparatorToken.instance))));
  }

  public static final JavaGrammar instance = new JavaGrammar();

  private JavaGrammar() {
    super(javaStartRule, javaRules);
  }

  static long totalInterpreterTime;
  static long totalParserTime;
  static long totalLexTime;
  static long totalFiles;
  static long totalFileSize;

  public static void main(String... args) throws IOException {
    System.out.println(JavaGrammar.instance);

    if (true) {
      return;
    }

    if (false) {
    } else {
      //File start = new File("/home/cyrusn/Desktop/classes");
      File start = new File("/Users/cyrusn/Downloads/src/");
      Set<String> files = new LinkedHashSet<String>();
      collectFiles(start, files);

      for (String file : files) {
        processFile(new File(file));
      }

      System.out.println("Total ITime: " + totalInterpreterTime);
      System.out.println("Total PTime: " + totalParserTime);
      System.out.println("Total LTime: " + totalLexTime);
      System.out.println("Total Files: " + totalFiles);
      System.out.println("Total Size : " + totalFileSize);
    }
  }

  private static void collectFiles(File start, Set<String> files) {
    for (File file : start.listFiles()) {
      if (file.isDirectory()) {
        collectFiles(file, files);
      } else if (file.getName().endsWith(".java")) {
        files.add(file.getPath());
      }
    }
  }

  private static void processFile(File file) throws IOException {
    if (file.getName().contains("X-")) {
      return;
    }

    totalFiles++;
    totalFileSize += file.length();

    String input = readFile(file);

    List<SourceToken<JavaToken>> tokens;
    {
      long start = System.currentTimeMillis();
      tokens = new JavaScanner(new Source(input)).scan();
      long diff = System.currentTimeMillis() - start;

      totalLexTime += diff;

      if (tokens == null) {
        System.out.println("Couldn't lex: " + file);
      }
    }
/*
    List<SourceToken<JavaToken>> analyzedTokens = new JavaLexicalAnalyzer().analyze(tokens);

    {
      long start = System.currentTimeMillis();
      JavaParser parser = new JavaParser(analyzedTokens);
      Object result = parser.parse();
      long diff = System.currentTimeMillis() - start;

      totalInterpreterTime += diff;

      if (result == null) {
        System.out.println("Couldn't parse: " + file);
      }
    }
    */
/*
    {
      long start = System.currentTimeMillis();
      JavaGeneratedParser parser = new JavaGeneratedParser((List) analyzedTokens);
      Object result = parser.parse();
      long diff = System.currentTimeMillis() - start;

      totalParserTime += diff;

      if (result == null) {
        System.out.println("Couldn't parse: " + file);
      }
    }
*/
    System.out.println("Parsed: " + file);
  }

  public static String readFile(File file) throws IOException {
    Reader in = new BufferedReader(new FileReader(file));

    StringBuilder sb = new StringBuilder();
    char[] chars = new char[1 << 16];
    int length;

    while ((length = in.read(chars)) > 0) {
      sb.append(chars, 0, length);
    }

    in.close();
    return sb.toString();
  }

  /*
    private Map<Expression, Map<Class<? extends Token>, List<Token>>> prefixMap;

  public List<Token> shortestPrefix(String variable, Class<? extends Token> clazz) {
    computePrefixMap();

    Map<Class<? extends Token>, List<Token>> tempMap = prefixMap.get(getVariableToRuleMap().get(variable).getExpression());
    if (tempMap == null) {
      return null;
    }

    return tempMap.get(clazz);
  }


  private void computePrefixMap() {
    if (prefixMap != null) {
      return;
    }

    prefixMap = new LinkedHashMap<Expression, Map<Class<? extends Token>, List<Token>>>();

    boolean changed;
    do {
      changed = false;

      for (Rule rule : getRules()) {
        for (Class<? extends Token> clazz : JavaToken.getTokenClasses()) {

        }
      }
    } while (changed);
  }
  */

  protected JavaToken.Type getTokenFromType(int type) {
    return JavaToken.Type.values()[type];
  }
}