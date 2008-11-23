package org.metasyntactic.automata.compiler.python.parser;

import org.metasyntactic.automata.compiler.framework.parsers.packrat.PackratGrammar;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.Rule;
import static org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions.Expression.*;
import org.metasyntactic.automata.compiler.python.scanner.*;
import org.metasyntactic.automata.compiler.python.scanner.delimiters.*;
import org.metasyntactic.automata.compiler.python.scanner.keywords.*;
import org.metasyntactic.automata.compiler.python.scanner.literals.LiteralToken;
import org.metasyntactic.automata.compiler.python.scanner.operators.*;

import java.util.LinkedHashSet;
import java.util.Set;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class PythonGrammar extends PackratGrammar<PythonToken.Type> {
  private final static Rule pythonStartRule;
  private final static Set<Rule> pythonRules;

  static {
    DelimiterToken.getDelimiters();
    OperatorToken.getOperators();
    KeywordToken.getKeywords();

    pythonStartRule = new Rule("Input", repetition(choice(type(NewlineToken.class), variable("Statement"))));

    pythonRules = new LinkedHashSet<Rule>();
    pythonRules.add(pythonStartRule);

    pythonRules.add(new Rule("Statement", choice(sequence(variable("StatementList"), type(NewlineToken.class)),
                                                 variable("CompoundStatement"))));

    pythonRules.add(new Rule("StatementList", sequence(variable("SimpleStatement"), repetition(sequence(token(
        SemicolonDelimiterToken.instance), variable("SimpleStatement"))), optional(token(
        SemicolonDelimiterToken.instance)))));

    pythonRules.add(new Rule("SimpleStatement", choice(variable("ExpressionStatement"), variable("AssertStatement"),
                                                       variable("AssignmentStatement"), variable(
        "AugmentedAssignmentStatement"), variable("PassStatement"), variable("DeleteStatement"), variable(
        "PrintStatement"), variable("ReturnStatement"), variable("YieldStatement"), variable("RaiseStatement"),
                           variable("BreakStatement"), variable("ContinueStatement"), variable("ImportStatement"),
                           variable("GlobalStatement"), variable("ExecuteStatement"))));

    pythonRules.add(new Rule("CompoundStatement", choice(variable("IfStatement"), variable("WhileStatement"), variable(
        "ForStatement"), variable("TryStatement"), variable("WithStatement"), variable("FunctionDefinition"), variable(
        "ClassDefinition"))));

    pythonRules.add(new Rule("ExpressionStatement", variable("ExpressionList")));

    pythonRules.add(new Rule("AssertStatement", sequence(token(AssertKeywordToken.instance), variable("Expression"),
                                                         optional(sequence(token(CommaDelimiterToken.instance),
                                                                           variable("Expression"))))));

    pythonRules.add(new Rule("AssignmentStatement", sequence(oneOrMore(sequence(variable("TargetList"), token(
        EqualsDelimiterToken.instance))), choice(variable("ExpressionList"), variable("YieldExpression")))));

    pythonRules.add(new Rule("AugmentedAssignmentStatement", sequence(variable("Target"), variable("AugmentedOperator"),
                                                                      choice(variable("ExpressionList"), variable(
                                                                          "YieldExpression")))));

    pythonRules.add(new Rule("AugmentedOperator", choice(token(PlusEqualsDelimiterToken.instance), token(
        MinusEqualsDelimiterToken.instance), token(TimesEqualsDelimiterToken.instance), token(
        DivideEqualsDelimiterToken.instance), token(ModulusEqualsDelimiterToken.instance), token(
        ExponentEqualsDelimiterToken.instance), token(RightShiftEqualsDelimiterToken.instance), token(
        LeftShiftEqualsDelimiterToken.instance), token(AndEqualsDelimiterToken.instance), token(
        OrEqualsDelimiterToken.instance), token(ExclusiveOrEqualsDelimiterToken.instance))));

    pythonRules.add(new Rule("PassStatement", token(PassKeywordToken.instance)));

    pythonRules.add(new Rule("DeleteStatement", sequence(token(DelKeywordToken.instance), variable("TargetList"))));

    pythonRules.add(new Rule("PrintStatement", sequence(token(PrintKeywordToken.instance), choice(sequence(variable(
        "Expression"), repetition(sequence(token(CommaDelimiterToken.instance), variable("Expression"))), optional(
        token(CommaDelimiterToken.instance))), sequence(token(RightShiftOperatorToken.instance), variable("Expression"),
                                                        oneOrMore(sequence(token(CommaDelimiterToken.instance),
                                                                           variable("Expression"))), token(
        CommaDelimiterToken.instance))))));

    pythonRules.add(new Rule("ReturnStatement", sequence(token(ReturnKeywordToken.instance), optional(variable(
        "ExpressionList")))));

    pythonRules.add(new Rule("YieldStatement", variable("YieldExpression")));

    pythonRules.add(new Rule("RaiseStatement", sequence(token(RaiseKeywordToken.instance), optional(sequence(variable(
        "Expression"), optional(sequence(token(CommaDelimiterToken.instance), variable("Expression"), optional(sequence(
        token(CommaDelimiterToken.instance), variable("Expression"))))))))));

    pythonRules.add(new Rule("BreakStatement", token(BreakKeywordToken.instance)));
    pythonRules.add(new Rule("ContinueStatement", token(ContinueKeywordToken.instance)));

    pythonRules.add(new Rule("ImportStatement", choice(sequence(token(ImportKeywordToken.instance), variable("Module"),
                                                                optional(sequence(token(AsKeywordToken.instance), type(
                                                                    IdentifierToken.class))), repetition(sequence(token(
        CommaDelimiterToken.instance), variable("Module"), optional(sequence(token(AsKeywordToken.instance), type(
        IdentifierToken.class)))))), sequence(token(FromKeywordToken.instance), variable("RelativeModule"), token(
        ImportKeywordToken.instance), type(IdentifierToken.class), optional(sequence(token(AsKeywordToken.instance),
                                                                                     type(IdentifierToken.class))),
                                      repetition(sequence(token(CommaDelimiterToken.instance), type(
                                          IdentifierToken.class), optional(sequence(token(AsKeywordToken.instance),
                                                                                    type(IdentifierToken.class)))))),
                                     sequence(token(FromKeywordToken.instance), variable("RelativeModule"), token(
                                         ImportKeywordToken.instance), token(LeftParenthesisDelimiterToken.instance),
                                                                       type(IdentifierToken.class), optional(sequence(
                                         token(AsKeywordToken.instance), type(IdentifierToken.class))), repetition(
                                         sequence(token(CommaDelimiterToken.instance), type(IdentifierToken.class),
                                                  optional(sequence(token(AsKeywordToken.instance), type(
                                                      IdentifierToken.class))))), optional(token(
                                         CommaDelimiterToken.instance)), token(
                                         RightParenthesisDelimiterToken.instance)), sequence(token(
        FromKeywordToken.instance), variable("Module"), token(ImportKeywordToken.instance), token(
        TimesOperatorToken.instance)))));

    pythonRules.add(new Rule("GlobalStatement", sequence(token(GlobalKeywordToken.instance), type(
        IdentifierToken.class), repetition(sequence(token(CommaDelimiterToken.instance), type(
        IdentifierToken.class))))));

    pythonRules.add(new Rule("ExecuteStatement", sequence(token(ExecKeywordToken.instance), variable("OrExpression"),
                                                          optional(sequence(token(InKeywordToken.instance), variable(
                                                              "Expression"), optional(sequence(token(
                                                              CommaDelimiterToken.instance), variable(
                                                              "Expression"))))))));

    pythonRules.add(new Rule("IfStatement", sequence(token(IfKeywordToken.instance), variable("Expression"), token(
        ColonDelimiterToken.instance), variable("Suite"), repetition(sequence(token(ElifKeywordToken.instance),
                                                                              variable("Expression"), token(
        ColonDelimiterToken.instance), variable("Suite"))), optional(sequence(token(ElseKeywordToken.instance), token(
        ColonDelimiterToken.instance), variable("Suite"))))));

    pythonRules.add(new Rule("WhileStatement", sequence(token(WhileKeywordToken.instance), variable("Expression"),
                                                        token(ColonDelimiterToken.instance), variable("Expression"),
                                                        optional(sequence(token(ElseKeywordToken.instance), token(
                                                            ColonDelimiterToken.instance), variable("Suite"))))));

    pythonRules.add(new Rule("ForStatement", sequence(token(ForKeywordToken.instance), variable("TargetList"), token(
        InKeywordToken.instance), variable("ExpressionList"), token(ColonDelimiterToken.instance), variable("Suite"),
                                  optional(sequence(token(ElseKeywordToken.instance), token(
                                      ColonDelimiterToken.instance), variable("Suite"))))));

    pythonRules.add(new Rule("TryStatement", choice(variable("TryStatement1"), variable("TryStatement2"))));

    pythonRules.add(new Rule("TryStatement1", sequence(token(TryKeywordToken.instance), token(
        ColonDelimiterToken.instance), variable("Suite"), oneOrMore(sequence(token(ExceptKeywordToken.instance),
                                                                             optional(sequence(variable("Expression"),
                                                                                               optional(sequence(token(
                                                                                                   CommaDelimiterToken.instance),
                                                                                                                 variable(
                                                                                                                     "Target"))))),
                                                                             token(ColonDelimiterToken.instance),
                                                                             variable("Suite"))), optional(sequence(
        token(ElseKeywordToken.instance), token(ColonDelimiterToken.instance), variable("Suite"))), optional(sequence(
        token(FinallyKeywordToken.instance), token(ColonDelimiterToken.instance), variable("Suite"))))));

    pythonRules.add(new Rule("TryStatement2", sequence(token(TryKeywordToken.instance), token(
        ColonDelimiterToken.instance), variable("Suite"), token(FinallyKeywordToken.instance), token(
        ColonDelimiterToken.instance), variable("Suite"))));

    pythonRules.add(new Rule("WithStatement", sequence(token(WithKeywordToken.instance), variable("Expression"),
                                                       optional(sequence(token(AsKeywordToken.instance), variable(
                                                           "Target"))), token(ColonDelimiterToken.instance), variable(
        "Suite"))));

    pythonRules.add(new Rule("FunctionDefinition", sequence(optional(variable("Decorators")), token(
        DefKeywordToken.instance), type(IdentifierToken.class), token(LeftParenthesisDelimiterToken.instance), optional(
        variable("ParameterList")), token(RightParenthesisDelimiterToken.instance), token(ColonDelimiterToken.instance),
                                    variable("Suite"))));

    pythonRules.add(new Rule("ClassDefinition", sequence(token(ClassKeywordToken.instance), type(IdentifierToken.class),
                                                         optional(variable("Inheritance")), token(
        ColonDelimiterToken.instance), variable("Suite"))));

    pythonRules.add(new Rule("ExpressionList", sequence(variable("Expression"), repetition(sequence(token(
        CommaDelimiterToken.instance), variable("Expression"))), optional(token(CommaDelimiterToken.instance)))));

    pythonRules.add(new Rule("Expression", choice(variable("ConditionalExpression"), variable("LambdaForm"))));

    pythonRules.add(new Rule("TargetList", sequence(variable("Target"), repetition(sequence(token(
        CommaDelimiterToken.instance), variable("Target"))), optional(token(CommaDelimiterToken.instance)))));

    pythonRules.add(new Rule("YieldExpression", sequence(token(YieldKeywordToken.instance), optional(variable(
        "ExpressionList")))));

    pythonRules.add(new Rule("Target", choice(variable("Slicing"), variable("Subscription"), variable(
        "AttributeReference"), sequence(token(LeftParenthesisDelimiterToken.instance), variable("TargetList"), token(
        RightParenthesisDelimiterToken.instance)), sequence(token(LeftBracketDelimiterToken.instance), variable(
        "TargetList"), token(RightBracketDelimiterToken.instance)), type(IdentifierToken.class))));

    pythonRules.add(new Rule("Module", sequence(repetition(sequence(type(IdentifierToken.class), token(
        CommaDelimiterToken.instance))), type(IdentifierToken.class))));

    pythonRules.add(new Rule("RelativeModule", choice(sequence(repetition(token(DotDelimiterToken.instance)), variable(
        "Module")), oneOrMore(token(DotDelimiterToken.instance)))));

    pythonRules.add(new Rule("OrExpression", choice(variable("ExclusiveOrExpression"), sequence(variable(
        "OrExpression"), token(OrOperatorToken.instance), variable("ExclusiveOrExpression")))));

    pythonRules.add(new Rule("ExclusiveOrExpression", choice(variable("AndExpression"), sequence(variable(
        "ExclusiveOrExpression"), token(ExclusiveOrOperatorToken.instance), variable("AndExpression")))));

    pythonRules.add(new Rule("AndExpression", choice(variable("ShiftExpression"), sequence(variable("AndExpression"),
                                                                                           token(
                                                                                               AndOperatorToken.instance),
                                                                                           variable(
                                                                                               "ShiftExpression")))));

    pythonRules.add(new Rule("ShiftExpression", choice(variable("AdditiveExpression"), sequence(variable(
        "ShiftExpression"), choice(token(LeftShiftOperatorToken.instance), token(RightShiftOperatorToken.instance)),
                            variable("AdditiveExpression")))));

    pythonRules.add(new Rule("AdditiveExpression", choice(variable("MultiplicativeExpression"), sequence(variable(
        "AdditiveExpression"), choice(token(PlusOperatorToken.instance), token(MinusOperatorToken.instance)), variable(
        "MultiplicativeExpression")))));

    pythonRules.add(new Rule("MultiplicativeExpression", choice(variable("UnaryExpression"), sequence(variable(
        "MultiplicativeExpression"), choice(token(TimesOperatorToken.instance), token(DivideOperatorToken.instance),
                                            token(TruncatingDivideOperatorToken.instance), token(
        ModulusOperatorToken.instance)), variable("UnaryExpression")))));

    pythonRules.add(new Rule("UnaryExpression", choice(variable("Power"), sequence(choice(token(
        PlusOperatorToken.instance), token(MinusOperatorToken.instance), token(BitwiseNotOperatorToken.instance)),
                                                                                   variable("UnaryExpression")))));

    pythonRules.add(new Rule("Power", sequence(variable("Primary"), optional(sequence(token(
        ExponentOperatorToken.instance), variable("UnaryExpression"))))));

    pythonRules.add(new Rule("Primary", choice(variable("Atom"), variable("AttributeReference"), variable(
        "Subscription"), variable("Slicing"), variable("Call"))));

    pythonRules.add(new Rule("Atom", choice(variable("Enclosure"), type(LiteralToken.class), type(
        IdentifierToken.class))));

    pythonRules.add(new Rule("Call", sequence(variable("Primary"), token(LeftParenthesisDelimiterToken.instance),
                                              optional(choice(sequence(variable("ArgumentList"), token(
                                                  CommaDelimiterToken.instance)), sequence(variable("Expression"),
                                                                                           variable(
                                                                                               "GeneratorExpression_For")))),
                                              token(RightParenthesisDelimiterToken.instance))));

    pythonRules.add(new Rule("Enclosure", choice(variable("ParenthesizedForm"), variable("ListDisplay"), variable(
        "GeneratorExpression"), variable("DictionaryDisplay"), variable("StringConversion"), variable("YieldAtom"))));

    pythonRules.add(new Rule("DictionaryDisplay", sequence(token(LeftCurlyDelimiterToken.instance), optional(variable(
        "KeyDatumList")), token(RightCurlyDelimiterToken.instance))));

    pythonRules.add(new Rule("KeyDatumList", sequence(variable("KeyDatum"), repetition(sequence(token(
        CommaDelimiterToken.instance), variable("KeyDatum"))), optional(token(CommaDelimiterToken.instance)))));

    pythonRules.add(new Rule("KeyDatum", sequence(variable("Expression"), token(ColonDelimiterToken.instance), variable(
        "Expression"))));

    pythonRules.add(new Rule("StringConversion", sequence(token(BackQuoteDelimiterToken.instance), variable(
        "ExpressionList"), token(BackQuoteDelimiterToken.instance))));

    pythonRules.add(new Rule("YieldAtom", sequence(token(LeftParenthesisDelimiterToken.instance), variable(
        "YieldExpression"), token(RightParenthesisDelimiterToken.instance))));

    pythonRules.add(new Rule("ListComprehension", sequence(variable("Expression"), variable("List_For"))));

    pythonRules.add(new Rule("List_For", sequence(token(ForKeywordToken.instance), variable("TargetList"), token(
        InKeywordToken.instance), variable("OldExpressionList"), optional(variable("List_Iteration")))));

    pythonRules.add(new Rule("List_Iteration", choice(variable("List_For"), variable("List_If"))));

    pythonRules.add(new Rule("List_If", sequence(token(IfKeywordToken.instance), variable("OldExpression"), optional(
        variable("List_Iteration")))));

    pythonRules.add(new Rule("OldExpressionList", sequence(variable("OldExpression"), repetition(sequence(token(
        CommaDelimiterToken.instance), variable("OldExpression"))), optional(token(CommaDelimiterToken.instance)))));

    pythonRules.add(new Rule("OldExpression", choice(variable("OrTest"), variable("OldLambdaForm"))));

    pythonRules.add(new Rule("OrTest", choice(variable("AndTest"), sequence(variable("OrTest"), token(
        OrKeywordToken.instance), variable("AndTest")))));

    pythonRules.add(new Rule("AndTest", choice(variable("NotTest"), sequence(variable("AndTest"), token(
        AndKeywordToken.instance), variable("NotTest")))));

    pythonRules.add(new Rule("NotTest", choice(variable("Comparison"), sequence(token(NotKeywordToken.instance),
                                                                                variable("NotTest")))));

    pythonRules.add(new Rule("OldLambdaForm", sequence(token(LambdaKeywordToken.instance), optional(variable(
        "ParameterList")), token(ColonDelimiterToken.instance), variable("OldExpression"))));

    pythonRules.add(new Rule("Comparison", sequence(variable("OrExpression"), repetition(sequence(variable(
        "ComparisonOperator"), variable("OrExpression"))))));

    pythonRules.add(new Rule("ComparisonOperator", choice(token(LessThanOperatorToken.instance), token(
        GreaterThanOperatorToken.instance), token(EqualsEqualsOperatorToken.instance), token(
        LessThanOrEqualsOperatorToken.instance), token(GreaterThanOrEqualsOperatorToken.instance), token(
        LessThanGreaterThanOperatorToken.instance), token(NotEqualsOperatorToken.instance), sequence(token(
        IsKeywordToken.instance), token(NotKeywordToken.instance)), token(IsKeywordToken.instance), sequence(token(
        NotKeywordToken.instance), token(InKeywordToken.instance)), token(InKeywordToken.instance))));

    pythonRules.add(new Rule("ListDisplay", sequence(token(LeftBracketDelimiterToken.instance), choice(variable(
        "ExpressionList"), variable("ListComprehension")), token(RightBracketDelimiterToken.instance))));

    pythonRules.add(new Rule("ArgumentList", choice(sequence(variable("PositionalArguments"), optional(sequence(token(
        CommaDelimiterToken.instance), variable("KeywordArguments"))), optional(sequence(token(
        CommaDelimiterToken.instance), token(TimesOperatorToken.instance), variable("Expression"))), optional(sequence(
        token(CommaDelimiterToken.instance), token(ExponentOperatorToken.instance), variable("Expression")))), sequence(
        variable("KeywordArguments"), optional(sequence(token(CommaDelimiterToken.instance), token(
        TimesOperatorToken.instance), variable("Expression"))), optional(sequence(token(CommaDelimiterToken.instance),
                                                                                  token(ExponentOperatorToken.instance),
                                                                                  variable("Expression")))), sequence(
        token(TimesOperatorToken.instance), variable("Expression"), optional(sequence(token(
        CommaDelimiterToken.instance), token(ExponentOperatorToken.instance), variable("Expression")))), sequence(token(
        ExponentOperatorToken.instance), variable("Expression")))));

    pythonRules.add(new Rule("PositionalArguments", sequence(variable("Expression"), repetition(sequence(token(
        CommaDelimiterToken.instance), variable("Expression"))))));

    pythonRules.add(new Rule("KeywordArguments", sequence(variable("KeywordItem"), repetition(sequence(token(
        CommaDelimiterToken.instance), variable("KeywordItem"))))));

    pythonRules.add(new Rule("KeywordItem", sequence(type(IdentifierToken.class), token(EqualsDelimiterToken.instance),
                                                     variable("Expression"))));

    pythonRules.add(new Rule("GeneratorExpression", sequence(token(LeftParenthesisDelimiterToken.instance), variable(
        "Expression"), variable("GeneratorExpression_For"), token(RightParenthesisDelimiterToken.instance))));

    pythonRules.add(new Rule("GeneratorExpression_For", sequence(token(ForKeywordToken.instance), variable(
        "TargetList"), token(InKeywordToken.instance), variable("OrTest"), optional(variable(
        "GeneratorExpression_Iterator")))));

    pythonRules.add(new Rule("GeneratorExpression_Iterator", choice(variable("GeneratorExpression_For"), variable(
        "GeneratorExpression_If"))));

    pythonRules.add(new Rule("GeneratorExpression_If", sequence(token(IfKeywordToken.instance), variable(
        "OldExpression"), optional(variable("GeneratorExpression_Iterator")))));

    pythonRules.add(new Rule("ParenthesizedForm", sequence(token(LeftParenthesisDelimiterToken.instance), optional(
        variable("ExpressionList")), token(RightParenthesisDelimiterToken.instance))));

    pythonRules.add(new Rule("ConditionalExpression", sequence(variable("OrExpression"), optional(sequence(token(
        IfKeywordToken.instance), variable("OrTest"), token(ElseKeywordToken.instance), variable("Expression"))))));

    pythonRules.add(new Rule("LambdaForm", sequence(token(LambdaKeywordToken.instance), optional(variable(
        "ParameterList")), token(ColonDelimiterToken.instance), variable("Expression"))));

    pythonRules.add(new Rule("Slicing", choice(variable("SimpleSlicing"), variable("ExtendedSlicing"))));

    pythonRules.add(new Rule("SimpleSlicing", sequence(variable("Primary"), token(LeftBracketDelimiterToken.instance),
                                                       variable("ShortSlice"), token(
        RightBracketDelimiterToken.instance))));

    pythonRules.add(new Rule("ExtendedSlicing", sequence(variable("Primary"), token(LeftBracketDelimiterToken.instance),
                                                         variable("SliceList"), token(
        RightBracketDelimiterToken.instance))));

    pythonRules.add(new Rule("SliceList", sequence(variable("SliceItem"), repetition(sequence(token(
        CommaDelimiterToken.instance), variable("SliceItem"))), optional(token(CommaDelimiterToken.instance)))));

    pythonRules.add(new Rule("SliceItem", choice(token(EllipsisDelimiterToken.instance), variable("ProperSlice"),
                                                 variable("Expression"))));

    pythonRules.add(new Rule("ProperSlice", choice(variable("ShortSlice"), variable("LongSlice"))));

    pythonRules.add(new Rule("ShortSlice", sequence(optional(variable("Expression")), token(
        ColonDelimiterToken.instance), optional(variable("Expression")))));

    pythonRules.add(new Rule("LongSlice", sequence(variable("ShortSlice"), token(ColonDelimiterToken.instance),
                                                   optional(variable("Expression")))));

    pythonRules.add(new Rule("ParameterList", sequence(choice(sequence(variable("ParameterDefinition"), repetition(
        sequence(token(CommaDelimiterToken.instance), variable("ParameterDefinition"))), optional(sequence(token(
        CommaDelimiterToken.instance), token(TimesOperatorToken.instance), type(IdentifierToken.class))), optional(
        sequence(token(CommaDelimiterToken.instance), token(ExponentOperatorToken.instance), type(
            IdentifierToken.class)))), sequence(token(TimesOperatorToken.instance), type(IdentifierToken.class),
                                                optional(sequence(token(CommaDelimiterToken.instance), token(
                                                    ExponentOperatorToken.instance), type(IdentifierToken.class)))),
                                       sequence(token(ExponentOperatorToken.instance), type(IdentifierToken.class))),
                                                       optional(token(CommaDelimiterToken.instance)))));

    pythonRules.add(new Rule("ParameterDefinition", choice(sequence(variable("Parameter"), token(
        EqualsDelimiterToken.instance), variable("Expression")), variable("Parameter"))));

    pythonRules.add(new Rule("Parameter", choice(type(IdentifierToken.class), sequence(token(
        LeftParenthesisDelimiterToken.instance), variable("Sublist"), token(
        RightParenthesisDelimiterToken.instance)))));

    pythonRules.add(new Rule("Sublist", sequence(variable("Parameter"), repetition(sequence(token(
        CommaDelimiterToken.instance), variable("Parameter"))), optional(token(CommaDelimiterToken.instance)))));

    pythonRules.add(new Rule("DottedName", sequence(type(IdentifierToken.class), repetition(sequence(token(
        DotDelimiterToken.instance), type(IdentifierToken.class))))));

    pythonRules.add(new Rule("Inheritance", sequence(token(LeftParenthesisDelimiterToken.instance), optional(variable(
        "ExpressionList")), token(RightParenthesisDelimiterToken.instance))));

    pythonRules.add(new Rule("Decorators", oneOrMore(variable("Decorator"))));

    pythonRules.add(new Rule("Decorator", sequence(token(AtDelimiterToken.instance), variable("DottedName"), optional(
        sequence(token(LeftParenthesisDelimiterToken.instance), optional(sequence(variable("ArgumentList"), optional(
            token(CommaDelimiterToken.instance)))), token(RightParenthesisDelimiterToken.instance))), type(
        NewlineToken.class))));

    pythonRules.add(new Rule("Subscription", sequence(variable("Primary"), token(LeftBracketDelimiterToken.instance),
                                                      variable("ExpressionList"), token(
        RightBracketDelimiterToken.instance))));

    pythonRules.add(new Rule("AttributeReference", sequence(variable("Primary"), token(DotDelimiterToken.instance),
                                                            type(IdentifierToken.class))));

    pythonRules.add(new Rule("Suite", choice(sequence(variable("StatementList"), type(NewlineToken.class)), sequence(
        type(NewlineToken.class), token(IndentToken.instance), oneOrMore(variable("Statement")), token(
        DedentToken.instance)))));
  }

  public static final PythonGrammar instance = new PythonGrammar();

  private PythonGrammar() {
    super(pythonStartRule, pythonRules);
  }

  public static void main(String... args) {
  }

  protected PythonToken.Type getTokenFromType(int type) {
    return PythonToken.Type.values()[type];
  }
}
