package org.metasyntactic.automata.compiler.java.scanner;

import org.metasyntactic.automata.compiler.framework.parsers.Token;
import org.metasyntactic.common.base.Preconditions;

import java.util.LinkedHashSet;
import java.util.Set;

public abstract class JavaToken implements Token {
  private final String text;

  /*
  private static Set<Class<? extends Token>> tokenClasses;

  public static Set<Class<? extends Token>> getTokenClasses() {
    if (tokenClasses == null) {
      tokenClasses = new LinkedHashSet<Class<? extends Token>>();

      tokenClasses.addAll(KeywordToken.getTokenClasses());
      tokenClasses.addAll(OperatorToken.getTokenClasses());
      tokenClasses.addAll(SeparatorToken.getTokenClasses());
      tokenClasses.addAll(LiteralToken.getTokenClasses());
      tokenClasses.add(CommentToken.class);
      tokenClasses.add(IdentifierToken.class);
      tokenClasses.add(WhitespaceToken.class);
    }

    return tokenClasses;
  }
  */

  protected JavaToken(String text) {
    Preconditions.checkNotNull(text);
    this.text = text;
  }

   public String getText() {
    return text;
  }

   public String toString() {
    return getText();
  }

   public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }

    JavaToken javaToken = (JavaToken) o;

    if (!text.equals(javaToken.text)) {
      return false;
    }

    return true;
  }

   public int hashCode() {
    return text.hashCode();
  }

   public int getType() {
    return getTokenType().ordinal();
  }

  protected abstract Type getTokenType();

  private static Set<Integer> values;

  public static Set<Integer> getValues() {
    if (values == null) {
      Set<Integer> result = new LinkedHashSet<Integer>();
      for (JavaToken.Type type : JavaToken.Type.values()) {
        result.add(type.ordinal());
      }
      values = result;
    }

    return values;
  }

  private static Set<Integer> keywordValues;

  public static Set<Integer> getKeywordValues() {
    if (keywordValues == null) {
      Set<Integer> result = new LinkedHashSet<Integer>();
      for (JavaToken.Type type : JavaToken.Type.values()) {
        if (type.ordinal() >= Type.AbstractKeyword.ordinal() &&
            type.ordinal() <= Type.WhileKeyword.ordinal()) {
            result.add(type.ordinal());
        }
      }
      keywordValues = result;
    }

    return keywordValues;
  }

  public static enum Type {
    Identifier,
    Comment,
    Error,
    Whitespace,
    // keywords
    AbstractKeyword,
    ContinueKeyword,
    ForKeyword,
    NewKeyword,
    SwitchKeyword,
    AssertKeyword,
    DefaultKeyword,
    IfKeyword,
    PackageKeyword,
    SynchronizedKeyword,
    BooleanKeyword,
    DoKeyword,
    GotoKeyword,
    PrivateKeyword,
    ThisKeyword,
    BreakKeyword,
    DoubleKeyword,
    ImplementsKeyword,
    ProtectedKeyword,
    ThrowKeyword,
    ByteKeyword,
    ElseKeyword,
    ImportKeyword,
    PublicKeyword,
    ThrowsKeyword,
    CaseKeyword,
    EnumKeyword,
    InstanceofKeyword,
    ReturnKeyword,
    TransientKeyword,
    CatchKeyword,
    ExtendsKeyword,
    IntKeyword,
    ShortKeyword,
    TryKeyword,
    CharKeyword,
    FinalKeyword,
    InterfaceKeyword,
    StaticKeyword,
    VoidKeyword,
    ClassKeyword,
    FinallyKeyword,
    LongKeyword,
    StrictfpKeyword,
    VolatileKeyword,
    ConstKeyword,
    FloatKeyword,
    NativeKeyword,
    SuperKeyword,
    WhileKeyword,
    // Literal
    CharacterLiteral,
    FalseBooleanLiteral,
    FloatingPointLiteral,
    IntegerLiteral,
    NullLiteral,
    StringLiteral,
    TrueBooleanLiteral,
    // Operators
    EqualsOperator,
    GreaterThanOperator,
    LessThanOperator,
    LogicalNotOperator,
    BitwiseNotOperator,
    QuestionMarkOperator,
    ColonOperator,
    EqualsEqualsOperator,
    LessThanOrEqualsOperator,
    GreaterThanOrEqualsOperator,
    NotEqualsOperator,
    LogicalAndOperator,
    LogicalOrOperator,
    IncrementOperator,
    DecrementOperator,
    PlusOperator,
    MinusOperator,
    TimesOperator,
    DivideOperator,
    BitwiseAndOperator,
    BitwiseOrOperator,
    BitwiseExclusiveOrOperator,
    ModulusOperator,
    LeftShiftOperator,
    PlusEqualsOperator,
    MinusEqualsOperator,
    TimesEqualsOperator,
    DivideEqualsOperator,
    AndEqualsOperator,
    OrEqualsOperator,
    ExclusiveOrEqualsOperator,
    ModulusEqualsOperator,
    LeftShiftEqualsOperator,
    RightShiftEqualsOperator,
    BitwiseRightShiftEqualsOperator,
    // Separator
    AtSeparator,
    LeftParenthesisSeparator,
    RightParenthesisSeparator,
    LeftBracketSeparator,
    RightBracketSeparator,
    LeftCurlySeparator,
    RightCurlySeparator,
    SemicolonSeparator,
    CommaSeparator,
    DotSeparator,
    EllipsisSeparator
  }

  public int compareTo(Token token) {
    int value = getType() - token.getType();
    if (value != 0) {
      return value;
    }

    String text1 = getText();
    String text2 = token.getText();

    value = text1.length() - text2.length();
    if (value != 0) {
      return value;
    }

    return text1.compareTo(text2);
  }
}
