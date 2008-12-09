package org.metasyntactic.automata.compiler.java.parser;

import org.metasyntactic.automata.compiler.framework.parsers.SourceToken;
import org.metasyntactic.automata.compiler.framework.parsers.Token;
import org.metasyntactic.automata.compiler.java.scanner.IdentifierToken;
import org.metasyntactic.automata.compiler.java.scanner.keywords.*;
import org.metasyntactic.automata.compiler.java.scanner.literals.LiteralToken;
import org.metasyntactic.automata.compiler.java.scanner.operators.*;
import org.metasyntactic.automata.compiler.java.scanner.separators.*;

import java.util.*;

public abstract class AbstractJavaGeneratedParser {
  protected static class EvaluationResult {
    public static final EvaluationResult failure = new EvaluationResult(false, 0);

    public final boolean succeeded;
    private final int position;
    private final Object value;

    public EvaluationResult(boolean succeeded, int position, Object value) {
      this.succeeded = succeeded;
      this.position = position;
      this.value = value;
    }

    public EvaluationResult(boolean succeeded, int position) {
      this(succeeded, position, null);
    }

    public int getPosition() {
      return position;
    }

    public Object getValue() {
      return value;
    }

    @Override public String toString() {
      if (succeeded) {
        return "(Result succeeded " + position + (value == null ? ")" : value + ")");
      } else {
        return "(Result failed)";
      }
    }
  }

  private static Map<Integer, EvaluationResult> initializeMap(Map<Integer, EvaluationResult> map) {
    if (map == null) {
      map = new HashMap<Integer, EvaluationResult>();
    }

    return map;
  }

  protected final List<SourceToken<Token>> tokens;

  protected AbstractJavaGeneratedParser(List<SourceToken<Token>> tokens) {
    this.tokens = new ArrayList<SourceToken<Token>>(tokens);
  }

  private static List<Object> trimList(ArrayList<Object> values) {
    if (values == null || values.isEmpty()) {
      return Collections.emptyList();
    } else if (values.size() == 1) {
      return Collections.singletonList(values.get(0));
    } else {
      values.trimToSize();
      return values;
    }
  }

  private ArrayList<Object> addValue(ArrayList<Object> values, EvaluationResult result) {
    Object value = result.getValue();

    if (value != null) {
      if (values == null) {
        values = new ArrayList<Object>();
      }

      values.add(value);
    }

    return values;
  }

  private EvaluationResult evaluateToken(int position, Token expected) {
    if (position < tokens.size()) {
      SourceToken<Token> token = tokens.get(position);
      if (expected.equals(token.getToken())) {
        return new EvaluationResult(true, position + 1, token);
      }
    }
    return EvaluationResult.failure;
  }

  public Object parse() {
    EvaluationResult result = parseCompilationUnit(0);
    if (result.succeeded) {
      return result.getValue();
    } else {
      return null;
    }
  }

  private boolean checkToken_PackageDeclaration(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 96: // AtSeparator
        case 12: // PackageKeyword
      }
    }
    return true;
  }

  private boolean checkToken_QualifiedIdentifier(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
      }
    }
    return true;
  }

  private boolean checkToken_ImportDeclaration(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 26: // ImportKeyword
      }
    }
    return true;
  }

  private boolean checkToken_SingleTypeImportDeclaration(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 26: // ImportKeyword
      }
    }
    return true;
  }

  private boolean checkToken_TypeImportOnDemandDeclaration(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 26: // ImportKeyword
      }
    }
    return true;
  }

  private boolean checkToken_SingleStaticImportDeclaration(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 26: // ImportKeyword
      }
    }
    return true;
  }

  private boolean checkToken_StaticImportOnDemandDeclaration(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 26: // ImportKeyword
      }
    }
    return true;
  }

  private boolean checkToken_TypeDeclaration(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 103: // SemicolonSeparator
        case 33: // TransientKeyword
        case 4: // AbstractKeyword
        case 96: // AtSeparator
        case 42: // StaticKeyword
        case 40: // FinalKeyword
        case 41: // InterfaceKeyword
        case 13: // SynchronizedKeyword
        case 47: // StrictfpKeyword
        case 44: // ClassKeyword
        case 17: // PrivateKeyword
        case 51: // NativeKeyword
        case 48: // VolatileKeyword
        case 22: // ProtectedKeyword
        case 27: // PublicKeyword
        case 30: // EnumKeyword
      }
    }
    return true;
  }

  private boolean checkToken_ClassDeclaration(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 33: // TransientKeyword
        case 4: // AbstractKeyword
        case 96: // AtSeparator
        case 42: // StaticKeyword
        case 40: // FinalKeyword
        case 13: // SynchronizedKeyword
        case 47: // StrictfpKeyword
        case 44: // ClassKeyword
        case 17: // PrivateKeyword
        case 51: // NativeKeyword
        case 48: // VolatileKeyword
        case 22: // ProtectedKeyword
        case 27: // PublicKeyword
        case 30: // EnumKeyword
      }
    }
    return true;
  }

  private boolean checkToken_NormalClassDeclaration(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 33: // TransientKeyword
        case 4: // AbstractKeyword
        case 96: // AtSeparator
        case 42: // StaticKeyword
        case 40: // FinalKeyword
        case 13: // SynchronizedKeyword
        case 47: // StrictfpKeyword
        case 44: // ClassKeyword
        case 17: // PrivateKeyword
        case 51: // NativeKeyword
        case 48: // VolatileKeyword
        case 22: // ProtectedKeyword
        case 27: // PublicKeyword
      }
    }
    return true;
  }

  private boolean checkToken_Modifier(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 17: // PrivateKeyword
        case 51: // NativeKeyword
        case 33: // TransientKeyword
        case 48: // VolatileKeyword
        case 4: // AbstractKeyword
        case 96: // AtSeparator
        case 22: // ProtectedKeyword
        case 42: // StaticKeyword
        case 27: // PublicKeyword
        case 40: // FinalKeyword
        case 13: // SynchronizedKeyword
        case 47: // StrictfpKeyword
      }
    }
    return true;
  }

  private boolean checkToken_Super(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 35: // ExtendsKeyword
      }
    }
    return true;
  }

  private boolean checkToken_Interfaces(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 21: // ImplementsKeyword
      }
    }
    return true;
  }

  private boolean checkToken_ClassBody(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 101: // LeftCurlySeparator
      }
    }
    return true;
  }

  private boolean checkToken_ClassBodyDeclaration(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 4: // AbstractKeyword
        case 13: // SynchronizedKeyword
        case 14: // BooleanKeyword
        case 17: // PrivateKeyword
        case 20: // DoubleKeyword
        case 22: // ProtectedKeyword
        case 24: // ByteKeyword
        case 27: // PublicKeyword
        case 30: // EnumKeyword
        case 103: // SemicolonSeparator
        case 101: // LeftCurlySeparator
        case 33: // TransientKeyword
        case 39: // CharKeyword
        case 96: // AtSeparator
        case 36: // IntKeyword
        case 37: // ShortKeyword
        case 42: // StaticKeyword
        case 43: // VoidKeyword
        case 40: // FinalKeyword
        case 41: // InterfaceKeyword
        case 46: // LongKeyword
        case 47: // StrictfpKeyword
        case 44: // ClassKeyword
        case 51: // NativeKeyword
        case 50: // FloatKeyword
        case 48: // VolatileKeyword
        case 63: // LessThanOperator
      }
    }
    return true;
  }

  private boolean checkToken_StaticInitializer(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 42: // StaticKeyword
      }
    }
    return true;
  }

  private boolean checkToken_InterfaceDeclaration(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 33: // TransientKeyword
        case 4: // AbstractKeyword
        case 96: // AtSeparator
        case 42: // StaticKeyword
        case 40: // FinalKeyword
        case 41: // InterfaceKeyword
        case 13: // SynchronizedKeyword
        case 47: // StrictfpKeyword
        case 17: // PrivateKeyword
        case 51: // NativeKeyword
        case 48: // VolatileKeyword
        case 22: // ProtectedKeyword
        case 27: // PublicKeyword
      }
    }
    return true;
  }

  private boolean checkToken_NormalInterfaceDeclaration(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 33: // TransientKeyword
        case 4: // AbstractKeyword
        case 96: // AtSeparator
        case 42: // StaticKeyword
        case 40: // FinalKeyword
        case 41: // InterfaceKeyword
        case 13: // SynchronizedKeyword
        case 47: // StrictfpKeyword
        case 17: // PrivateKeyword
        case 51: // NativeKeyword
        case 48: // VolatileKeyword
        case 22: // ProtectedKeyword
        case 27: // PublicKeyword
      }
    }
    return true;
  }

  private boolean checkToken_ExtendsInterfaces(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 35: // ExtendsKeyword
      }
    }
    return true;
  }

  private boolean checkToken_ClassOrInterfaceBody(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 101: // LeftCurlySeparator
      }
    }
    return true;
  }

  private boolean checkToken_EnumDeclaration(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 33: // TransientKeyword
        case 4: // AbstractKeyword
        case 96: // AtSeparator
        case 42: // StaticKeyword
        case 40: // FinalKeyword
        case 13: // SynchronizedKeyword
        case 47: // StrictfpKeyword
        case 17: // PrivateKeyword
        case 51: // NativeKeyword
        case 48: // VolatileKeyword
        case 22: // ProtectedKeyword
        case 27: // PublicKeyword
        case 30: // EnumKeyword
      }
    }
    return true;
  }

  private boolean checkToken_EnumBody(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 101: // LeftCurlySeparator
      }
    }
    return true;
  }

  private boolean checkToken_EnumConstant(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 96: // AtSeparator
      }
    }
    return true;
  }

  private boolean checkToken_Arguments(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 97: // LeftParenthesisSeparator
      }
    }
    return true;
  }

  private boolean checkToken_AnnotationDeclaration(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 17: // PrivateKeyword
        case 51: // NativeKeyword
        case 33: // TransientKeyword
        case 48: // VolatileKeyword
        case 4: // AbstractKeyword
        case 96: // AtSeparator
        case 22: // ProtectedKeyword
        case 42: // StaticKeyword
        case 27: // PublicKeyword
        case 40: // FinalKeyword
        case 13: // SynchronizedKeyword
        case 47: // StrictfpKeyword
      }
    }
    return true;
  }

  private boolean checkToken_AnnotationBody(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 101: // LeftCurlySeparator
      }
    }
    return true;
  }

  private boolean checkToken_AnnotationElementDeclaration(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 4: // AbstractKeyword
        case 13: // SynchronizedKeyword
        case 14: // BooleanKeyword
        case 17: // PrivateKeyword
        case 20: // DoubleKeyword
        case 22: // ProtectedKeyword
        case 24: // ByteKeyword
        case 27: // PublicKeyword
        case 30: // EnumKeyword
        case 103: // SemicolonSeparator
        case 33: // TransientKeyword
        case 39: // CharKeyword
        case 36: // IntKeyword
        case 96: // AtSeparator
        case 37: // ShortKeyword
        case 42: // StaticKeyword
        case 43: // VoidKeyword
        case 40: // FinalKeyword
        case 41: // InterfaceKeyword
        case 46: // LongKeyword
        case 47: // StrictfpKeyword
        case 44: // ClassKeyword
        case 51: // NativeKeyword
        case 50: // FloatKeyword
        case 48: // VolatileKeyword
        case 63: // LessThanOperator
      }
    }
    return true;
  }

  private boolean checkToken_AnnotationDefaultDeclaration(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 33: // TransientKeyword
        case 4: // AbstractKeyword
        case 39: // CharKeyword
        case 96: // AtSeparator
        case 36: // IntKeyword
        case 37: // ShortKeyword
        case 42: // StaticKeyword
        case 43: // VoidKeyword
        case 40: // FinalKeyword
        case 46: // LongKeyword
        case 13: // SynchronizedKeyword
        case 47: // StrictfpKeyword
        case 14: // BooleanKeyword
        case 51: // NativeKeyword
        case 17: // PrivateKeyword
        case 50: // FloatKeyword
        case 48: // VolatileKeyword
        case 20: // DoubleKeyword
        case 22: // ProtectedKeyword
        case 24: // ByteKeyword
        case 27: // PublicKeyword
      }
    }
    return true;
  }

  private boolean checkToken_ClassOrInterfaceMemberDeclaration(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 4: // AbstractKeyword
        case 13: // SynchronizedKeyword
        case 14: // BooleanKeyword
        case 17: // PrivateKeyword
        case 20: // DoubleKeyword
        case 22: // ProtectedKeyword
        case 24: // ByteKeyword
        case 27: // PublicKeyword
        case 30: // EnumKeyword
        case 103: // SemicolonSeparator
        case 33: // TransientKeyword
        case 39: // CharKeyword
        case 96: // AtSeparator
        case 36: // IntKeyword
        case 37: // ShortKeyword
        case 42: // StaticKeyword
        case 43: // VoidKeyword
        case 40: // FinalKeyword
        case 41: // InterfaceKeyword
        case 46: // LongKeyword
        case 47: // StrictfpKeyword
        case 44: // ClassKeyword
        case 51: // NativeKeyword
        case 50: // FloatKeyword
        case 48: // VolatileKeyword
        case 63: // LessThanOperator
      }
    }
    return true;
  }

  private boolean checkToken_ConstructorDeclaration(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 33: // TransientKeyword
        case 4: // AbstractKeyword
        case 96: // AtSeparator
        case 42: // StaticKeyword
        case 40: // FinalKeyword
        case 13: // SynchronizedKeyword
        case 47: // StrictfpKeyword
        case 17: // PrivateKeyword
        case 51: // NativeKeyword
        case 48: // VolatileKeyword
        case 22: // ProtectedKeyword
        case 27: // PublicKeyword
        case 63: // LessThanOperator
      }
    }
    return true;
  }

  private boolean checkToken_FieldDeclaration(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 33: // TransientKeyword
        case 4: // AbstractKeyword
        case 39: // CharKeyword
        case 96: // AtSeparator
        case 36: // IntKeyword
        case 37: // ShortKeyword
        case 42: // StaticKeyword
        case 43: // VoidKeyword
        case 40: // FinalKeyword
        case 46: // LongKeyword
        case 13: // SynchronizedKeyword
        case 47: // StrictfpKeyword
        case 14: // BooleanKeyword
        case 51: // NativeKeyword
        case 17: // PrivateKeyword
        case 50: // FloatKeyword
        case 48: // VolatileKeyword
        case 20: // DoubleKeyword
        case 22: // ProtectedKeyword
        case 24: // ByteKeyword
        case 27: // PublicKeyword
      }
    }
    return true;
  }

  private boolean checkToken_VariableDeclarator(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
      }
    }
    return true;
  }

  private boolean checkToken_VariableDeclaratorIdAndAssignment(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
      }
    }
    return true;
  }

  private boolean checkToken_VariableDeclaratorAssignment(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 64: // LogicalNotOperator
        case 65: // BitwiseNotOperator
        case 7: // NewKeyword
        case 76: // PlusOperator
        case 77: // MinusOperator
        case 14: // BooleanKeyword
        case 74: // IncrementOperator
        case 75: // DecrementOperator
        case 18: // ThisKeyword
        case 20: // DoubleKeyword
        case 24: // ByteKeyword
        case 101: // LeftCurlySeparator
        case 39: // CharKeyword
        case 36: // IntKeyword
        case 37: // ShortKeyword
        case 97: // LeftParenthesisSeparator
        case 43: // VoidKeyword
        case 46: // LongKeyword
        case 50: // FloatKeyword
        case 55: // FalseBooleanLiteral
        case 54: // CharacterLiteral
        case 52: // SuperKeyword
        case 59: // StringLiteral
        case 58: // NullLiteral
        case 57: // IntegerLiteral
        case 56: // FloatingPointLiteral
        case 63: // LessThanOperator
        case 60: // TrueBooleanLiteral
      }
    }
    return true;
  }

  private boolean checkToken_VariableDeclaratorId(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
      }
    }
    return true;
  }

  private boolean checkToken_BracketPair(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 99: // LeftBracketSeparator
      }
    }
    return true;
  }

  private boolean checkToken_MethodDeclaration(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 33: // TransientKeyword
        case 4: // AbstractKeyword
        case 39: // CharKeyword
        case 96: // AtSeparator
        case 36: // IntKeyword
        case 37: // ShortKeyword
        case 42: // StaticKeyword
        case 43: // VoidKeyword
        case 40: // FinalKeyword
        case 46: // LongKeyword
        case 13: // SynchronizedKeyword
        case 47: // StrictfpKeyword
        case 14: // BooleanKeyword
        case 51: // NativeKeyword
        case 17: // PrivateKeyword
        case 50: // FloatKeyword
        case 48: // VolatileKeyword
        case 20: // DoubleKeyword
        case 22: // ProtectedKeyword
        case 24: // ByteKeyword
        case 27: // PublicKeyword
        case 63: // LessThanOperator
      }
    }
    return true;
  }

  private boolean checkToken_MethodBody(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 103: // SemicolonSeparator
        case 101: // LeftCurlySeparator
      }
    }
    return true;
  }

  private boolean checkToken_FormalParameter(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 33: // TransientKeyword
        case 4: // AbstractKeyword
        case 39: // CharKeyword
        case 96: // AtSeparator
        case 36: // IntKeyword
        case 37: // ShortKeyword
        case 42: // StaticKeyword
        case 43: // VoidKeyword
        case 40: // FinalKeyword
        case 46: // LongKeyword
        case 13: // SynchronizedKeyword
        case 47: // StrictfpKeyword
        case 14: // BooleanKeyword
        case 51: // NativeKeyword
        case 17: // PrivateKeyword
        case 50: // FloatKeyword
        case 48: // VolatileKeyword
        case 20: // DoubleKeyword
        case 22: // ProtectedKeyword
        case 24: // ByteKeyword
        case 27: // PublicKeyword
      }
    }
    return true;
  }

  private boolean checkToken_Throws(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 28: // ThrowsKeyword
      }
    }
    return true;
  }

  private boolean checkToken_TypeParameters(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 63: // LessThanOperator
      }
    }
    return true;
  }

  private boolean checkToken_TypeParameter(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
      }
    }
    return true;
  }

  private boolean checkToken_TypeBound(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 35: // ExtendsKeyword
      }
    }
    return true;
  }

  private boolean checkToken_Type(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 50: // FloatKeyword
        case 39: // CharKeyword
        case 20: // DoubleKeyword
        case 36: // IntKeyword
        case 37: // ShortKeyword
        case 24: // ByteKeyword
        case 43: // VoidKeyword
        case 46: // LongKeyword
        case 14: // BooleanKeyword
      }
    }
    return true;
  }

  private boolean checkToken_ReferenceType(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 50: // FloatKeyword
        case 39: // CharKeyword
        case 20: // DoubleKeyword
        case 36: // IntKeyword
        case 37: // ShortKeyword
        case 24: // ByteKeyword
        case 43: // VoidKeyword
        case 46: // LongKeyword
        case 14: // BooleanKeyword
      }
    }
    return true;
  }

  private boolean checkToken_PrimitiveArrayReferenceType(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 50: // FloatKeyword
        case 39: // CharKeyword
        case 20: // DoubleKeyword
        case 36: // IntKeyword
        case 37: // ShortKeyword
        case 24: // ByteKeyword
        case 43: // VoidKeyword
        case 46: // LongKeyword
        case 14: // BooleanKeyword
      }
    }
    return true;
  }

  private boolean checkToken_ClassOrInterfaceReferenceType(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
      }
    }
    return true;
  }

  private boolean checkToken_ClassOrInterfaceType(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
      }
    }
    return true;
  }

  private boolean checkToken_SingleClassOrInterfaceType(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
      }
    }
    return true;
  }

  private boolean checkToken_TypeArguments(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 63: // LessThanOperator
      }
    }
    return true;
  }

  private boolean checkToken_TypeArgument(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 50: // FloatKeyword
        case 39: // CharKeyword
        case 20: // DoubleKeyword
        case 36: // IntKeyword
        case 66: // QuestionMarkOperator
        case 37: // ShortKeyword
        case 24: // ByteKeyword
        case 43: // VoidKeyword
        case 46: // LongKeyword
        case 14: // BooleanKeyword
      }
    }
    return true;
  }

  private boolean checkToken_WildcardTypeArgument(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 66: // QuestionMarkOperator
      }
    }
    return true;
  }

  private boolean checkToken_ExtendsWildcardTypeArgument(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 66: // QuestionMarkOperator
      }
    }
    return true;
  }

  private boolean checkToken_SuperWildcardTypeArgument(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 66: // QuestionMarkOperator
      }
    }
    return true;
  }

  private boolean checkToken_OpenWildcardTypeArgument(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 66: // QuestionMarkOperator
      }
    }
    return true;
  }

  private boolean checkToken_NonWildcardTypeArguments(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 63: // LessThanOperator
      }
    }
    return true;
  }

  private boolean checkToken_PrimitiveType(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 50: // FloatKeyword
        case 39: // CharKeyword
        case 20: // DoubleKeyword
        case 36: // IntKeyword
        case 37: // ShortKeyword
        case 24: // ByteKeyword
        case 43: // VoidKeyword
        case 46: // LongKeyword
        case 14: // BooleanKeyword
      }
    }
    return true;
  }

  private boolean checkToken_Annotation(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 96: // AtSeparator
      }
    }
    return true;
  }

  private boolean checkToken_NormalAnnotation(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 96: // AtSeparator
      }
    }
    return true;
  }

  private boolean checkToken_ElementValuePair(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
      }
    }
    return true;
  }

  private boolean checkToken_SingleElementAnnotation(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 96: // AtSeparator
      }
    }
    return true;
  }

  private boolean checkToken_MarkerAnnotation(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 96: // AtSeparator
      }
    }
    return true;
  }

  private boolean checkToken_ElementValue(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 64: // LogicalNotOperator
        case 65: // BitwiseNotOperator
        case 7: // NewKeyword
        case 76: // PlusOperator
        case 77: // MinusOperator
        case 14: // BooleanKeyword
        case 74: // IncrementOperator
        case 75: // DecrementOperator
        case 18: // ThisKeyword
        case 20: // DoubleKeyword
        case 24: // ByteKeyword
        case 101: // LeftCurlySeparator
        case 39: // CharKeyword
        case 36: // IntKeyword
        case 96: // AtSeparator
        case 37: // ShortKeyword
        case 97: // LeftParenthesisSeparator
        case 43: // VoidKeyword
        case 46: // LongKeyword
        case 50: // FloatKeyword
        case 55: // FalseBooleanLiteral
        case 54: // CharacterLiteral
        case 52: // SuperKeyword
        case 59: // StringLiteral
        case 58: // NullLiteral
        case 57: // IntegerLiteral
        case 56: // FloatingPointLiteral
        case 63: // LessThanOperator
        case 60: // TrueBooleanLiteral
      }
    }
    return true;
  }

  private boolean checkToken_ElementValueArrayInitializer(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 101: // LeftCurlySeparator
      }
    }
    return true;
  }

  private boolean checkToken_Block(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 101: // LeftCurlySeparator
      }
    }
    return true;
  }

  private boolean checkToken_BlockStatement(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 4: // AbstractKeyword
        case 5: // ContinueKeyword
        case 6: // ForKeyword
        case 7: // NewKeyword
        case 8: // SwitchKeyword
        case 9: // AssertKeyword
        case 11: // IfKeyword
        case 13: // SynchronizedKeyword
        case 14: // BooleanKeyword
        case 15: // DoKeyword
        case 17: // PrivateKeyword
        case 19: // BreakKeyword
        case 18: // ThisKeyword
        case 20: // DoubleKeyword
        case 23: // ThrowKeyword
        case 22: // ProtectedKeyword
        case 24: // ByteKeyword
        case 27: // PublicKeyword
        case 30: // EnumKeyword
        case 32: // ReturnKeyword
        case 33: // TransientKeyword
        case 38: // TryKeyword
        case 39: // CharKeyword
        case 36: // IntKeyword
        case 37: // ShortKeyword
        case 42: // StaticKeyword
        case 43: // VoidKeyword
        case 40: // FinalKeyword
        case 46: // LongKeyword
        case 47: // StrictfpKeyword
        case 44: // ClassKeyword
        case 51: // NativeKeyword
        case 50: // FloatKeyword
        case 48: // VolatileKeyword
        case 55: // FalseBooleanLiteral
        case 54: // CharacterLiteral
        case 53: // WhileKeyword
        case 52: // SuperKeyword
        case 59: // StringLiteral
        case 58: // NullLiteral
        case 57: // IntegerLiteral
        case 56: // FloatingPointLiteral
        case 63: // LessThanOperator
        case 60: // TrueBooleanLiteral
        case 64: // LogicalNotOperator
        case 65: // BitwiseNotOperator
        case 76: // PlusOperator
        case 77: // MinusOperator
        case 74: // IncrementOperator
        case 75: // DecrementOperator
        case 103: // SemicolonSeparator
        case 101: // LeftCurlySeparator
        case 96: // AtSeparator
        case 97: // LeftParenthesisSeparator
      }
    }
    return true;
  }

  private boolean checkToken_LocalVariableDeclarationStatement(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 33: // TransientKeyword
        case 4: // AbstractKeyword
        case 39: // CharKeyword
        case 96: // AtSeparator
        case 36: // IntKeyword
        case 37: // ShortKeyword
        case 42: // StaticKeyword
        case 43: // VoidKeyword
        case 40: // FinalKeyword
        case 46: // LongKeyword
        case 13: // SynchronizedKeyword
        case 47: // StrictfpKeyword
        case 14: // BooleanKeyword
        case 51: // NativeKeyword
        case 17: // PrivateKeyword
        case 50: // FloatKeyword
        case 48: // VolatileKeyword
        case 20: // DoubleKeyword
        case 22: // ProtectedKeyword
        case 24: // ByteKeyword
        case 27: // PublicKeyword
      }
    }
    return true;
  }

  private boolean checkToken_LocalVariableDeclaration(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 33: // TransientKeyword
        case 4: // AbstractKeyword
        case 39: // CharKeyword
        case 96: // AtSeparator
        case 36: // IntKeyword
        case 37: // ShortKeyword
        case 42: // StaticKeyword
        case 43: // VoidKeyword
        case 40: // FinalKeyword
        case 46: // LongKeyword
        case 13: // SynchronizedKeyword
        case 47: // StrictfpKeyword
        case 14: // BooleanKeyword
        case 51: // NativeKeyword
        case 17: // PrivateKeyword
        case 50: // FloatKeyword
        case 48: // VolatileKeyword
        case 20: // DoubleKeyword
        case 22: // ProtectedKeyword
        case 24: // ByteKeyword
        case 27: // PublicKeyword
      }
    }
    return true;
  }

  private boolean checkToken_Statement(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 64: // LogicalNotOperator
        case 65: // BitwiseNotOperator
        case 5: // ContinueKeyword
        case 6: // ForKeyword
        case 7: // NewKeyword
        case 76: // PlusOperator
        case 8: // SwitchKeyword
        case 77: // MinusOperator
        case 9: // AssertKeyword
        case 11: // IfKeyword
        case 13: // SynchronizedKeyword
        case 14: // BooleanKeyword
        case 74: // IncrementOperator
        case 15: // DoKeyword
        case 75: // DecrementOperator
        case 19: // BreakKeyword
        case 18: // ThisKeyword
        case 20: // DoubleKeyword
        case 23: // ThrowKeyword
        case 24: // ByteKeyword
        case 103: // SemicolonSeparator
        case 32: // ReturnKeyword
        case 101: // LeftCurlySeparator
        case 38: // TryKeyword
        case 39: // CharKeyword
        case 36: // IntKeyword
        case 97: // LeftParenthesisSeparator
        case 37: // ShortKeyword
        case 43: // VoidKeyword
        case 46: // LongKeyword
        case 50: // FloatKeyword
        case 55: // FalseBooleanLiteral
        case 54: // CharacterLiteral
        case 53: // WhileKeyword
        case 52: // SuperKeyword
        case 59: // StringLiteral
        case 58: // NullLiteral
        case 57: // IntegerLiteral
        case 56: // FloatingPointLiteral
        case 63: // LessThanOperator
        case 60: // TrueBooleanLiteral
      }
    }
    return true;
  }

  private boolean checkToken_EmptyStatement(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 103: // SemicolonSeparator
      }
    }
    return true;
  }

  private boolean checkToken_LabeledStatement(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
      }
    }
    return true;
  }

  private boolean checkToken_ExpressionStatement(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 64: // LogicalNotOperator
        case 65: // BitwiseNotOperator
        case 7: // NewKeyword
        case 76: // PlusOperator
        case 77: // MinusOperator
        case 14: // BooleanKeyword
        case 74: // IncrementOperator
        case 75: // DecrementOperator
        case 18: // ThisKeyword
        case 20: // DoubleKeyword
        case 24: // ByteKeyword
        case 39: // CharKeyword
        case 36: // IntKeyword
        case 97: // LeftParenthesisSeparator
        case 37: // ShortKeyword
        case 43: // VoidKeyword
        case 46: // LongKeyword
        case 50: // FloatKeyword
        case 55: // FalseBooleanLiteral
        case 54: // CharacterLiteral
        case 52: // SuperKeyword
        case 59: // StringLiteral
        case 58: // NullLiteral
        case 57: // IntegerLiteral
        case 56: // FloatingPointLiteral
        case 63: // LessThanOperator
        case 60: // TrueBooleanLiteral
      }
    }
    return true;
  }

  private boolean checkToken_IfStatement(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 11: // IfKeyword
      }
    }
    return true;
  }

  private boolean checkToken_ElseStatement(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 25: // ElseKeyword
      }
    }
    return true;
  }

  private boolean checkToken_AssertStatement(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 9: // AssertKeyword
      }
    }
    return true;
  }

  private boolean checkToken_MessageAssertStatement(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 9: // AssertKeyword
      }
    }
    return true;
  }

  private boolean checkToken_SimpleAssertStatement(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 9: // AssertKeyword
      }
    }
    return true;
  }

  private boolean checkToken_SwitchStatement(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 8: // SwitchKeyword
      }
    }
    return true;
  }

  private boolean checkToken_SwitchBlockStatementGroup(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 10: // DefaultKeyword
        case 29: // CaseKeyword
      }
    }
    return true;
  }

  private boolean checkToken_SwitchLabel(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 10: // DefaultKeyword
        case 29: // CaseKeyword
      }
    }
    return true;
  }

  private boolean checkToken_CaseSwitchLabel(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 29: // CaseKeyword
      }
    }
    return true;
  }

  private boolean checkToken_DefaultSwitchLabel(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 10: // DefaultKeyword
      }
    }
    return true;
  }

  private boolean checkToken_WhileStatement(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 53: // WhileKeyword
      }
    }
    return true;
  }

  private boolean checkToken_DoStatement(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 15: // DoKeyword
      }
    }
    return true;
  }

  private boolean checkToken_ForStatement(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 6: // ForKeyword
      }
    }
    return true;
  }

  private boolean checkToken_BasicForStatement(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 6: // ForKeyword
      }
    }
    return true;
  }

  private boolean checkToken_ForInitializer(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 64: // LogicalNotOperator
        case 4: // AbstractKeyword
        case 65: // BitwiseNotOperator
        case 7: // NewKeyword
        case 76: // PlusOperator
        case 77: // MinusOperator
        case 13: // SynchronizedKeyword
        case 14: // BooleanKeyword
        case 74: // IncrementOperator
        case 75: // DecrementOperator
        case 17: // PrivateKeyword
        case 18: // ThisKeyword
        case 20: // DoubleKeyword
        case 22: // ProtectedKeyword
        case 24: // ByteKeyword
        case 27: // PublicKeyword
        case 33: // TransientKeyword
        case 39: // CharKeyword
        case 36: // IntKeyword
        case 96: // AtSeparator
        case 37: // ShortKeyword
        case 97: // LeftParenthesisSeparator
        case 42: // StaticKeyword
        case 43: // VoidKeyword
        case 40: // FinalKeyword
        case 46: // LongKeyword
        case 47: // StrictfpKeyword
        case 51: // NativeKeyword
        case 50: // FloatKeyword
        case 48: // VolatileKeyword
        case 55: // FalseBooleanLiteral
        case 54: // CharacterLiteral
        case 52: // SuperKeyword
        case 59: // StringLiteral
        case 58: // NullLiteral
        case 57: // IntegerLiteral
        case 56: // FloatingPointLiteral
        case 63: // LessThanOperator
        case 60: // TrueBooleanLiteral
      }
    }
    return true;
  }

  private boolean checkToken_DelimitedExpressionList(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 64: // LogicalNotOperator
        case 65: // BitwiseNotOperator
        case 7: // NewKeyword
        case 76: // PlusOperator
        case 77: // MinusOperator
        case 14: // BooleanKeyword
        case 74: // IncrementOperator
        case 75: // DecrementOperator
        case 18: // ThisKeyword
        case 20: // DoubleKeyword
        case 24: // ByteKeyword
        case 39: // CharKeyword
        case 36: // IntKeyword
        case 97: // LeftParenthesisSeparator
        case 37: // ShortKeyword
        case 43: // VoidKeyword
        case 46: // LongKeyword
        case 50: // FloatKeyword
        case 55: // FalseBooleanLiteral
        case 54: // CharacterLiteral
        case 52: // SuperKeyword
        case 59: // StringLiteral
        case 58: // NullLiteral
        case 57: // IntegerLiteral
        case 56: // FloatingPointLiteral
        case 63: // LessThanOperator
        case 60: // TrueBooleanLiteral
      }
    }
    return true;
  }

  private boolean checkToken_ForUpdate(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 64: // LogicalNotOperator
        case 65: // BitwiseNotOperator
        case 7: // NewKeyword
        case 76: // PlusOperator
        case 77: // MinusOperator
        case 14: // BooleanKeyword
        case 74: // IncrementOperator
        case 75: // DecrementOperator
        case 18: // ThisKeyword
        case 20: // DoubleKeyword
        case 24: // ByteKeyword
        case 39: // CharKeyword
        case 36: // IntKeyword
        case 97: // LeftParenthesisSeparator
        case 37: // ShortKeyword
        case 43: // VoidKeyword
        case 46: // LongKeyword
        case 50: // FloatKeyword
        case 55: // FalseBooleanLiteral
        case 54: // CharacterLiteral
        case 52: // SuperKeyword
        case 59: // StringLiteral
        case 58: // NullLiteral
        case 57: // IntegerLiteral
        case 56: // FloatingPointLiteral
        case 63: // LessThanOperator
        case 60: // TrueBooleanLiteral
      }
    }
    return true;
  }

  private boolean checkToken_EnhancedForStatement(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 6: // ForKeyword
      }
    }
    return true;
  }

  private boolean checkToken_BreakStatement(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 19: // BreakKeyword
      }
    }
    return true;
  }

  private boolean checkToken_ContinueStatement(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 5: // ContinueKeyword
      }
    }
    return true;
  }

  private boolean checkToken_ReturnStatement(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 32: // ReturnKeyword
      }
    }
    return true;
  }

  private boolean checkToken_ThrowStatement(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 23: // ThrowKeyword
      }
    }
    return true;
  }

  private boolean checkToken_SynchronizedStatement(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 13: // SynchronizedKeyword
      }
    }
    return true;
  }

  private boolean checkToken_TryStatement(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 38: // TryKeyword
      }
    }
    return true;
  }

  private boolean checkToken_TryStatementWithFinally(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 38: // TryKeyword
      }
    }
    return true;
  }

  private boolean checkToken_TryStatementWithoutFinally(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 38: // TryKeyword
      }
    }
    return true;
  }

  private boolean checkToken_CatchClause(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 34: // CatchKeyword
      }
    }
    return true;
  }

  private boolean checkToken_Expression(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 64: // LogicalNotOperator
        case 65: // BitwiseNotOperator
        case 7: // NewKeyword
        case 76: // PlusOperator
        case 77: // MinusOperator
        case 14: // BooleanKeyword
        case 74: // IncrementOperator
        case 75: // DecrementOperator
        case 18: // ThisKeyword
        case 20: // DoubleKeyword
        case 24: // ByteKeyword
        case 39: // CharKeyword
        case 36: // IntKeyword
        case 97: // LeftParenthesisSeparator
        case 37: // ShortKeyword
        case 43: // VoidKeyword
        case 46: // LongKeyword
        case 50: // FloatKeyword
        case 55: // FalseBooleanLiteral
        case 54: // CharacterLiteral
        case 52: // SuperKeyword
        case 59: // StringLiteral
        case 58: // NullLiteral
        case 57: // IntegerLiteral
        case 56: // FloatingPointLiteral
        case 63: // LessThanOperator
        case 60: // TrueBooleanLiteral
      }
    }
    return true;
  }

  private boolean checkToken_AssignmentOperator(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 85: // PlusEqualsOperator
        case 87: // TimesEqualsOperator
        case 86: // MinusEqualsOperator
        case 93: // LeftShiftEqualsOperator
        case 92: // ModulusEqualsOperator
        case 95: // BitwiseRightShiftEqualsOperator
        case 94: // RightShiftEqualsOperator
        case 89: // AndEqualsOperator
        case 88: // DivideEqualsOperator
        case 61: // EqualsOperator
        case 91: // ExclusiveOrEqualsOperator
        case 90: // OrEqualsOperator
      }
    }
    return true;
  }

  private boolean checkToken_Expression1(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 64: // LogicalNotOperator
        case 65: // BitwiseNotOperator
        case 7: // NewKeyword
        case 76: // PlusOperator
        case 77: // MinusOperator
        case 14: // BooleanKeyword
        case 74: // IncrementOperator
        case 75: // DecrementOperator
        case 18: // ThisKeyword
        case 20: // DoubleKeyword
        case 24: // ByteKeyword
        case 39: // CharKeyword
        case 36: // IntKeyword
        case 97: // LeftParenthesisSeparator
        case 37: // ShortKeyword
        case 43: // VoidKeyword
        case 46: // LongKeyword
        case 50: // FloatKeyword
        case 55: // FalseBooleanLiteral
        case 54: // CharacterLiteral
        case 52: // SuperKeyword
        case 59: // StringLiteral
        case 58: // NullLiteral
        case 57: // IntegerLiteral
        case 56: // FloatingPointLiteral
        case 63: // LessThanOperator
        case 60: // TrueBooleanLiteral
      }
    }
    return true;
  }

  private boolean checkToken_TernaryExpression(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 64: // LogicalNotOperator
        case 65: // BitwiseNotOperator
        case 7: // NewKeyword
        case 76: // PlusOperator
        case 77: // MinusOperator
        case 14: // BooleanKeyword
        case 74: // IncrementOperator
        case 75: // DecrementOperator
        case 18: // ThisKeyword
        case 20: // DoubleKeyword
        case 24: // ByteKeyword
        case 39: // CharKeyword
        case 36: // IntKeyword
        case 97: // LeftParenthesisSeparator
        case 37: // ShortKeyword
        case 43: // VoidKeyword
        case 46: // LongKeyword
        case 50: // FloatKeyword
        case 55: // FalseBooleanLiteral
        case 54: // CharacterLiteral
        case 52: // SuperKeyword
        case 59: // StringLiteral
        case 58: // NullLiteral
        case 57: // IntegerLiteral
        case 56: // FloatingPointLiteral
        case 63: // LessThanOperator
        case 60: // TrueBooleanLiteral
      }
    }
    return true;
  }

  private boolean checkToken_Expression2(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 64: // LogicalNotOperator
        case 65: // BitwiseNotOperator
        case 7: // NewKeyword
        case 76: // PlusOperator
        case 77: // MinusOperator
        case 14: // BooleanKeyword
        case 74: // IncrementOperator
        case 75: // DecrementOperator
        case 18: // ThisKeyword
        case 20: // DoubleKeyword
        case 24: // ByteKeyword
        case 39: // CharKeyword
        case 36: // IntKeyword
        case 97: // LeftParenthesisSeparator
        case 37: // ShortKeyword
        case 43: // VoidKeyword
        case 46: // LongKeyword
        case 50: // FloatKeyword
        case 55: // FalseBooleanLiteral
        case 54: // CharacterLiteral
        case 52: // SuperKeyword
        case 59: // StringLiteral
        case 58: // NullLiteral
        case 57: // IntegerLiteral
        case 56: // FloatingPointLiteral
        case 63: // LessThanOperator
        case 60: // TrueBooleanLiteral
      }
    }
    return true;
  }

  private boolean checkToken_BinaryExpression(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 64: // LogicalNotOperator
        case 65: // BitwiseNotOperator
        case 7: // NewKeyword
        case 76: // PlusOperator
        case 77: // MinusOperator
        case 14: // BooleanKeyword
        case 74: // IncrementOperator
        case 75: // DecrementOperator
        case 18: // ThisKeyword
        case 20: // DoubleKeyword
        case 24: // ByteKeyword
        case 39: // CharKeyword
        case 36: // IntKeyword
        case 97: // LeftParenthesisSeparator
        case 37: // ShortKeyword
        case 43: // VoidKeyword
        case 46: // LongKeyword
        case 50: // FloatKeyword
        case 55: // FalseBooleanLiteral
        case 54: // CharacterLiteral
        case 52: // SuperKeyword
        case 59: // StringLiteral
        case 58: // NullLiteral
        case 57: // IntegerLiteral
        case 56: // FloatingPointLiteral
        case 63: // LessThanOperator
        case 60: // TrueBooleanLiteral
      }
    }
    return true;
  }

  private boolean checkToken_BinaryExpressionRest(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 68: // EqualsEqualsOperator
        case 69: // LessThanOrEqualsOperator
        case 70: // GreaterThanOrEqualsOperator
        case 71: // NotEqualsOperator
        case 76: // PlusOperator
        case 77: // MinusOperator
        case 78: // TimesOperator
        case 79: // DivideOperator
        case 72: // LogicalAndOperator
        case 73: // LogicalOrOperator
        case 84: // LeftShiftOperator
        case 81: // BitwiseOrOperator
        case 80: // BitwiseAndOperator
        case 83: // ModulusOperator
        case 82: // BitwiseExclusiveOrOperator
        case 63: // LessThanOperator
        case 62: // GreaterThanOperator
        case 31: // InstanceofKeyword
      }
    }
    return true;
  }

  private boolean checkToken_InfixOperatorBinaryExpressionRest(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 68: // EqualsEqualsOperator
        case 69: // LessThanOrEqualsOperator
        case 70: // GreaterThanOrEqualsOperator
        case 71: // NotEqualsOperator
        case 76: // PlusOperator
        case 77: // MinusOperator
        case 78: // TimesOperator
        case 79: // DivideOperator
        case 72: // LogicalAndOperator
        case 73: // LogicalOrOperator
        case 84: // LeftShiftOperator
        case 81: // BitwiseOrOperator
        case 80: // BitwiseAndOperator
        case 83: // ModulusOperator
        case 82: // BitwiseExclusiveOrOperator
        case 63: // LessThanOperator
        case 62: // GreaterThanOperator
      }
    }
    return true;
  }

  private boolean checkToken_InstanceofOperatorBinaryExpressionRest(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 31: // InstanceofKeyword
      }
    }
    return true;
  }

  private boolean checkToken_InfixOperator(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 68: // EqualsEqualsOperator
        case 69: // LessThanOrEqualsOperator
        case 70: // GreaterThanOrEqualsOperator
        case 71: // NotEqualsOperator
        case 76: // PlusOperator
        case 77: // MinusOperator
        case 78: // TimesOperator
        case 79: // DivideOperator
        case 72: // LogicalAndOperator
        case 73: // LogicalOrOperator
        case 84: // LeftShiftOperator
        case 81: // BitwiseOrOperator
        case 80: // BitwiseAndOperator
        case 83: // ModulusOperator
        case 82: // BitwiseExclusiveOrOperator
        case 63: // LessThanOperator
        case 62: // GreaterThanOperator
      }
    }
    return true;
  }

  private boolean checkToken_UnsignedRightShift(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 62: // GreaterThanOperator
      }
    }
    return true;
  }

  private boolean checkToken_SignedRightShift(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 62: // GreaterThanOperator
      }
    }
    return true;
  }

  private boolean checkToken_Expression3(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 64: // LogicalNotOperator
        case 65: // BitwiseNotOperator
        case 7: // NewKeyword
        case 76: // PlusOperator
        case 77: // MinusOperator
        case 14: // BooleanKeyword
        case 74: // IncrementOperator
        case 75: // DecrementOperator
        case 18: // ThisKeyword
        case 20: // DoubleKeyword
        case 24: // ByteKeyword
        case 39: // CharKeyword
        case 36: // IntKeyword
        case 97: // LeftParenthesisSeparator
        case 37: // ShortKeyword
        case 43: // VoidKeyword
        case 46: // LongKeyword
        case 50: // FloatKeyword
        case 55: // FalseBooleanLiteral
        case 54: // CharacterLiteral
        case 52: // SuperKeyword
        case 59: // StringLiteral
        case 58: // NullLiteral
        case 57: // IntegerLiteral
        case 56: // FloatingPointLiteral
        case 63: // LessThanOperator
        case 60: // TrueBooleanLiteral
      }
    }
    return true;
  }

  private boolean checkToken_PrefixExpression(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 64: // LogicalNotOperator
        case 65: // BitwiseNotOperator
        case 76: // PlusOperator
        case 77: // MinusOperator
        case 74: // IncrementOperator
        case 75: // DecrementOperator
      }
    }
    return true;
  }

  private boolean checkToken_PrefixOperator(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 64: // LogicalNotOperator
        case 65: // BitwiseNotOperator
        case 76: // PlusOperator
        case 77: // MinusOperator
        case 74: // IncrementOperator
        case 75: // DecrementOperator
      }
    }
    return true;
  }

  private boolean checkToken_PossibleCastExpression(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 97: // LeftParenthesisSeparator
      }
    }
    return true;
  }

  private boolean checkToken_PossibleCastExpression_Type(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 97: // LeftParenthesisSeparator
      }
    }
    return true;
  }

  private boolean checkToken_PossibleCastExpression_Expression(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 97: // LeftParenthesisSeparator
      }
    }
    return true;
  }

  private boolean checkToken_PrimaryExpression(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 39: // CharKeyword
        case 36: // IntKeyword
        case 7: // NewKeyword
        case 37: // ShortKeyword
        case 97: // LeftParenthesisSeparator
        case 43: // VoidKeyword
        case 46: // LongKeyword
        case 14: // BooleanKeyword
        case 50: // FloatKeyword
        case 18: // ThisKeyword
        case 55: // FalseBooleanLiteral
        case 54: // CharacterLiteral
        case 20: // DoubleKeyword
        case 52: // SuperKeyword
        case 59: // StringLiteral
        case 58: // NullLiteral
        case 24: // ByteKeyword
        case 57: // IntegerLiteral
        case 56: // FloatingPointLiteral
        case 63: // LessThanOperator
        case 60: // TrueBooleanLiteral
      }
    }
    return true;
  }

  private boolean checkToken_PostfixOperator(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 74: // IncrementOperator
        case 75: // DecrementOperator
      }
    }
    return true;
  }

  private boolean checkToken_ValueExpression(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 39: // CharKeyword
        case 36: // IntKeyword
        case 7: // NewKeyword
        case 37: // ShortKeyword
        case 97: // LeftParenthesisSeparator
        case 43: // VoidKeyword
        case 46: // LongKeyword
        case 14: // BooleanKeyword
        case 50: // FloatKeyword
        case 18: // ThisKeyword
        case 55: // FalseBooleanLiteral
        case 54: // CharacterLiteral
        case 20: // DoubleKeyword
        case 52: // SuperKeyword
        case 59: // StringLiteral
        case 58: // NullLiteral
        case 24: // ByteKeyword
        case 57: // IntegerLiteral
        case 56: // FloatingPointLiteral
        case 63: // LessThanOperator
        case 60: // TrueBooleanLiteral
      }
    }
    return true;
  }

  private boolean checkToken_ClassAccess(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 50: // FloatKeyword
        case 39: // CharKeyword
        case 20: // DoubleKeyword
        case 36: // IntKeyword
        case 37: // ShortKeyword
        case 24: // ByteKeyword
        case 43: // VoidKeyword
        case 46: // LongKeyword
        case 14: // BooleanKeyword
      }
    }
    return true;
  }

  private boolean checkToken_Selector(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 99: // LeftBracketSeparator
        case 105: // DotSeparator
      }
    }
    return true;
  }

  private boolean checkToken_DotSelector(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 105: // DotSeparator
      }
    }
    return true;
  }

  private boolean checkToken_ArraySelector(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 99: // LeftBracketSeparator
      }
    }
    return true;
  }

  private boolean checkToken_ParenthesizedExpression(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 97: // LeftParenthesisSeparator
      }
    }
    return true;
  }

  private boolean checkToken_MethodInvocation(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 63: // LessThanOperator
      }
    }
    return true;
  }

  private boolean checkToken_ThisConstructorInvocation(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 18: // ThisKeyword
      }
    }
    return true;
  }

  private boolean checkToken_SuperConstructorInvocation(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 52: // SuperKeyword
      }
    }
    return true;
  }

  private boolean checkToken_CreationExpression(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 7: // NewKeyword
      }
    }
    return true;
  }

  private boolean checkToken_ObjectCreationExpression(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 7: // NewKeyword
      }
    }
    return true;
  }

  private boolean checkToken_ArrayCreationExpression(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 7: // NewKeyword
      }
    }
    return true;
  }

  private boolean checkToken_ArrayCreationType(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 50: // FloatKeyword
        case 39: // CharKeyword
        case 20: // DoubleKeyword
        case 36: // IntKeyword
        case 37: // ShortKeyword
        case 24: // ByteKeyword
        case 43: // VoidKeyword
        case 46: // LongKeyword
        case 14: // BooleanKeyword
      }
    }
    return true;
  }

  private boolean checkToken_DimensionExpression(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 99: // LeftBracketSeparator
      }
    }
    return true;
  }

  private boolean checkToken_ArrayInitializer(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 101: // LeftCurlySeparator
      }
    }
    return true;
  }

  private boolean checkToken_VariableInitializer(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default:
          return false;
        case 0: // Identifier
        case 64: // LogicalNotOperator
        case 65: // BitwiseNotOperator
        case 7: // NewKeyword
        case 76: // PlusOperator
        case 77: // MinusOperator
        case 14: // BooleanKeyword
        case 74: // IncrementOperator
        case 75: // DecrementOperator
        case 18: // ThisKeyword
        case 20: // DoubleKeyword
        case 24: // ByteKeyword
        case 101: // LeftCurlySeparator
        case 39: // CharKeyword
        case 36: // IntKeyword
        case 37: // ShortKeyword
        case 97: // LeftParenthesisSeparator
        case 43: // VoidKeyword
        case 46: // LongKeyword
        case 50: // FloatKeyword
        case 55: // FalseBooleanLiteral
        case 54: // CharacterLiteral
        case 52: // SuperKeyword
        case 59: // StringLiteral
        case 58: // NullLiteral
        case 57: // IntegerLiteral
        case 56: // FloatingPointLiteral
        case 63: // LessThanOperator
        case 60: // TrueBooleanLiteral
      }
    }
    return true;
  }

  private EvaluationResult evaluateCompilationUnitExpression_0(int position) {
    EvaluationResult result;
    if ((result = parsePackageDeclaration(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateCompilationUnitExpression_1(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = parseImportDeclaration(currentPosition);
      if (result.succeeded) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateCompilationUnitExpression_2(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = parseTypeDeclaration(currentPosition);
      if (result.succeeded) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateCompilationUnitExpression_3(int position) {
    EvaluationResult result = anyToken(position);
    return new EvaluationResult(!result.succeeded, position);
  }

  private EvaluationResult evaluateCompilationUnitExpression_4(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateCompilationUnitExpression_0(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateCompilationUnitExpression_1(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateCompilationUnitExpression_2(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateCompilationUnitExpression_3(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluatePackageDeclarationExpression_0(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = parseAnnotation(currentPosition);
      if (result.succeeded) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluatePackageDeclarationExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluatePackageDeclarationExpression_0(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), PackageKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseQualifiedIdentifier(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateQualifiedIdentifierExpression_0(int position) {
    if (position < tokens.size()) {
      SourceToken<Token> token = tokens.get(position);
      Class<? extends Token> actualType = token.getToken().getClass();
      if (IdentifierToken.class.isAssignableFrom(actualType)) {
        return new EvaluationResult(true, position + 1, token);
      }
    }
    return EvaluationResult.failure;
  }

  private EvaluationResult evaluateQualifiedIdentifierExpression_1(int position) {
    ArrayList<Object> elements = null;
    ArrayList<Object> delimiters = null;
    EvaluationResult result = evaluateQualifiedIdentifierExpression_0(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    elements = addValue(elements, result);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult delimiterResult = evaluateToken(currentPosition, DotSeparatorToken.instance);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }

      result = evaluateQualifiedIdentifierExpression_0(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result);
    }
  }

  private EvaluationResult evaluateImportDeclarationExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseSingleTypeImportDeclaration(position)).succeeded) { return result; }
    if ((result = parseTypeImportOnDemandDeclaration(position)).succeeded) { return result; }
    if ((result = parseSingleStaticImportDeclaration(position)).succeeded) { return result; }
    return parseStaticImportOnDemandDeclaration(position);
  }

  private EvaluationResult evaluateSingleTypeImportDeclarationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ImportKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseQualifiedIdentifier(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeImportOnDemandDeclarationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ImportKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseQualifiedIdentifier(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), DotSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), TimesOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateSingleStaticImportDeclarationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ImportKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), StaticKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseQualifiedIdentifier(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateStaticImportOnDemandDeclarationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ImportKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), StaticKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseQualifiedIdentifier(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), DotSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), TimesOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeDeclarationExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseClassDeclaration(position)).succeeded) { return result; }
    if ((result = parseInterfaceDeclaration(position)).succeeded) { return result; }
    return evaluateToken(position, SemicolonSeparatorToken.instance);
  }

  private EvaluationResult evaluateClassDeclarationExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseNormalClassDeclaration(position)).succeeded) { return result; }
    return parseEnumDeclaration(position);
  }

  private EvaluationResult evaluateNormalClassDeclarationExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseTypeParameters(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateNormalClassDeclarationExpression_1(int position) {
    EvaluationResult result;
    if ((result = parseSuper(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateNormalClassDeclarationExpression_2(int position) {
    EvaluationResult result;
    if ((result = parseInterfaces(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateNormalClassDeclarationExpression_3(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseModifiers(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), ClassKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateQualifiedIdentifierExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateNormalClassDeclarationExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateNormalClassDeclarationExpression_1(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateNormalClassDeclarationExpression_2(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseClassBody(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateModifiersExpression_0(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = parseModifier(currentPosition);
      if (result.succeeded) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateModifierExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseAnnotation(position)).succeeded) { return result; }
    if ((result = evaluateToken(position, PublicKeywordToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, ProtectedKeywordToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, PrivateKeywordToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, StaticKeywordToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, AbstractKeywordToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, FinalKeywordToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, NativeKeywordToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, SynchronizedKeywordToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, TransientKeywordToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, VolatileKeywordToken.instance)).succeeded) { return result; }
    return evaluateToken(position, StrictfpKeywordToken.instance);
  }

  private EvaluationResult evaluateSuperExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ExtendsKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseClassOrInterfaceType(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateInterfacesExpression_0(int position) {
    ArrayList<Object> elements = null;
    ArrayList<Object> delimiters = null;
    EvaluationResult result = parseClassOrInterfaceType(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    elements = addValue(elements, result);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult delimiterResult = evaluateToken(currentPosition, CommaSeparatorToken.instance);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }

      result = parseClassOrInterfaceType(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result);
    }
  }

  private EvaluationResult evaluateInterfacesExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ImplementsKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateInterfacesExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateClassBodyExpression_0(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = parseClassBodyDeclaration(currentPosition);
      if (result.succeeded) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateClassBodyExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LeftCurlySeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateClassBodyExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightCurlySeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateClassBodyDeclarationExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseClassOrInterfaceMemberDeclaration(position)).succeeded) { return result; }
    if ((result = parseBlock(position)).succeeded) { return result; }
    if ((result = parseStaticInitializer(position)).succeeded) { return result; }
    return parseConstructorDeclaration(position);
  }

  private EvaluationResult evaluateStaticInitializerExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, StaticKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseBlock(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateInterfaceDeclarationExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseNormalInterfaceDeclaration(position)).succeeded) { return result; }
    return parseAnnotationDeclaration(position);
  }

  private EvaluationResult evaluateNormalInterfaceDeclarationExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseExtendsInterfaces(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateNormalInterfaceDeclarationExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseModifiers(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), InterfaceKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateQualifiedIdentifierExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateNormalClassDeclarationExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateNormalInterfaceDeclarationExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseClassOrInterfaceBody(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateExtendsInterfacesExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ExtendsKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateInterfacesExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateClassOrInterfaceBodyExpression_0(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = parseClassOrInterfaceMemberDeclaration(currentPosition);
      if (result.succeeded) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateClassOrInterfaceBodyExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LeftCurlySeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateClassOrInterfaceBodyExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightCurlySeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateEnumDeclarationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseModifiers(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), EnumKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateQualifiedIdentifierExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateNormalClassDeclarationExpression_2(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseEnumBody(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateEnumBodyExpression_0(int position) {
    ArrayList<Object> elements = null;
    ArrayList<Object> delimiters = null;
    EvaluationResult result = parseEnumConstant(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    elements = addValue(elements, result);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult delimiterResult = evaluateToken(currentPosition, CommaSeparatorToken.instance);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }

      result = parseEnumConstant(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result);
    }
  }

  private EvaluationResult evaluateEnumBodyExpression_1(int position) {
    EvaluationResult result;
    if ((result = evaluateEnumBodyExpression_0(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateEnumBodyExpression_2(int position) {
    EvaluationResult result;
    if ((result = evaluateToken(position, CommaSeparatorToken.instance)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateEnumBodyExpression_3(int position) {
    EvaluationResult result;
    if ((result = evaluateToken(position, SemicolonSeparatorToken.instance)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateEnumBodyExpression_4(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LeftCurlySeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateEnumBodyExpression_1(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateEnumBodyExpression_2(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateEnumBodyExpression_3(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateClassBodyExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightCurlySeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateEnumConstantExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseArguments(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateEnumConstantExpression_1(int position) {
    EvaluationResult result;
    if ((result = parseClassOrInterfaceBody(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateEnumConstantExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluatePackageDeclarationExpression_0(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateQualifiedIdentifierExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateEnumConstantExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateEnumConstantExpression_1(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateArgumentsExpression_0(int position) {
    ArrayList<Object> elements = null;
    ArrayList<Object> delimiters = null;
    EvaluationResult result = parseExpression(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    elements = addValue(elements, result);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult delimiterResult = evaluateToken(currentPosition, CommaSeparatorToken.instance);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }

      result = parseExpression(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result);
    }
  }

  private EvaluationResult evaluateArgumentsExpression_1(int position) {
    EvaluationResult result;
    if ((result = evaluateArgumentsExpression_0(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateArgumentsExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LeftParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateArgumentsExpression_1(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateAnnotationDeclarationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseModifiers(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), AtSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), InterfaceKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateQualifiedIdentifierExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseAnnotationBody(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateAnnotationBodyExpression_0(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = parseAnnotationElementDeclaration(currentPosition);
      if (result.succeeded) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateAnnotationBodyExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LeftCurlySeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateAnnotationBodyExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightCurlySeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateAnnotationElementDeclarationExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseAnnotationDefaultDeclaration(position)).succeeded) { return result; }
    return parseClassOrInterfaceMemberDeclaration(position);
  }

  private EvaluationResult evaluateAnnotationDefaultDeclarationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseModifiers(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseType(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateQualifiedIdentifierExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), DefaultKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseElementValue(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateClassOrInterfaceMemberDeclarationExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseFieldDeclaration(position)).succeeded) { return result; }
    if ((result = parseMethodDeclaration(position)).succeeded) { return result; }
    return parseTypeDeclaration(position);
  }

  private EvaluationResult evaluateConstructorDeclarationExpression_0(int position) {
    ArrayList<Object> elements = null;
    ArrayList<Object> delimiters = null;
    EvaluationResult result = parseFormalParameter(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    elements = addValue(elements, result);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult delimiterResult = evaluateToken(currentPosition, CommaSeparatorToken.instance);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }

      result = parseFormalParameter(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result);
    }
  }

  private EvaluationResult evaluateConstructorDeclarationExpression_1(int position) {
    EvaluationResult result;
    if ((result = evaluateConstructorDeclarationExpression_0(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateConstructorDeclarationExpression_2(int position) {
    EvaluationResult result;
    if ((result = parseThrows(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateConstructorDeclarationExpression_3(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseModifiers(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateNormalClassDeclarationExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateQualifiedIdentifierExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateConstructorDeclarationExpression_1(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateConstructorDeclarationExpression_2(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseBlock(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateFieldDeclarationExpression_0(int position) {
    ArrayList<Object> elements = null;
    ArrayList<Object> delimiters = null;
    EvaluationResult result = parseVariableDeclarator(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    elements = addValue(elements, result);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult delimiterResult = evaluateToken(currentPosition, CommaSeparatorToken.instance);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }

      result = parseVariableDeclarator(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result);
    }
  }

  private EvaluationResult evaluateFieldDeclarationExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseModifiers(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseType(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateFieldDeclarationExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateVariableDeclaratorExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseVariableDeclaratorIdAndAssignment(position)).succeeded) { return result; }
    return parseVariableDeclaratorId(position);
  }

  private EvaluationResult evaluateVariableDeclaratorIdAndAssignmentExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseVariableDeclaratorId(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), EqualsOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseVariableDeclaratorAssignment(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateVariableDeclaratorAssignmentExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseExpression(position)).succeeded) { return result; }
    return parseArrayInitializer(position);
  }

  private EvaluationResult evaluateVariableDeclaratorIdExpression_0(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = parseBracketPair(currentPosition);
      if (result.succeeded) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateVariableDeclaratorIdExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateQualifiedIdentifierExpression_0(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateVariableDeclaratorIdExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateBracketPairExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LeftBracketSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightBracketSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateMethodDeclarationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseModifiers(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateNormalClassDeclarationExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseType(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateQualifiedIdentifierExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateConstructorDeclarationExpression_1(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateVariableDeclaratorIdExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateConstructorDeclarationExpression_2(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseMethodBody(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateMethodBodyExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseBlock(position)).succeeded) { return result; }
    return evaluateToken(position, SemicolonSeparatorToken.instance);
  }

  private EvaluationResult evaluateFormalParameterExpression_0(int position) {
    EvaluationResult result;
    if ((result = evaluateToken(position, EllipsisSeparatorToken.instance)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateFormalParameterExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseModifiers(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseType(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateFormalParameterExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseVariableDeclaratorId(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateThrowsExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ThrowsKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateInterfacesExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeParametersExpression_0(int position) {
    ArrayList<Object> elements = null;
    ArrayList<Object> delimiters = null;
    EvaluationResult result = parseTypeParameter(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    elements = addValue(elements, result);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult delimiterResult = evaluateToken(currentPosition, CommaSeparatorToken.instance);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }

      result = parseTypeParameter(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result);
    }
  }

  private EvaluationResult evaluateTypeParametersExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LessThanOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateTypeParametersExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), GreaterThanOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeParameterExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseTypeBound(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateTypeParameterExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateQualifiedIdentifierExpression_0(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateTypeParameterExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeBoundExpression_0(int position) {
    ArrayList<Object> elements = null;
    ArrayList<Object> delimiters = null;
    EvaluationResult result = parseClassOrInterfaceType(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    elements = addValue(elements, result);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult delimiterResult = evaluateToken(currentPosition, BitwiseAndOperatorToken.instance);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }

      result = parseClassOrInterfaceType(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result);
    }
  }

  private EvaluationResult evaluateTypeBoundExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ExtendsKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateTypeBoundExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseReferenceType(position)).succeeded) { return result; }
    return parsePrimitiveType(position);
  }

  private EvaluationResult evaluateReferenceTypeExpression_0(int position) {
    EvaluationResult result;
    if ((result = parsePrimitiveArrayReferenceType(position)).succeeded) { return result; }
    return parseClassOrInterfaceReferenceType(position);
  }

  private EvaluationResult evaluatePrimitiveArrayReferenceTypeExpression_0(int position) {
    ArrayList<Object> values = null;
    EvaluationResult result = parseBracketPair(position);
    if (!result.succeeded) {
      return EvaluationResult.failure;
    }
    while (true) {
      int currentPosition = result.getPosition();
      values = addValue(values, result);
      result = parseBracketPair(currentPosition);
      if (!result.succeeded) {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluatePrimitiveArrayReferenceTypeExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parsePrimitiveType(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluatePrimitiveArrayReferenceTypeExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateClassOrInterfaceReferenceTypeExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseClassOrInterfaceType(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateVariableDeclaratorIdExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateClassOrInterfaceTypeExpression_0(int position) {
    ArrayList<Object> elements = null;
    ArrayList<Object> delimiters = null;
    EvaluationResult result = parseSingleClassOrInterfaceType(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    elements = addValue(elements, result);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult delimiterResult = evaluateToken(currentPosition, DotSeparatorToken.instance);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }

      result = parseSingleClassOrInterfaceType(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result);
    }
  }

  private EvaluationResult evaluateSingleClassOrInterfaceTypeExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseTypeArguments(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateSingleClassOrInterfaceTypeExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateQualifiedIdentifierExpression_0(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateSingleClassOrInterfaceTypeExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeArgumentsExpression_0(int position) {
    ArrayList<Object> elements = null;
    ArrayList<Object> delimiters = null;
    EvaluationResult result = parseTypeArgument(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    elements = addValue(elements, result);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult delimiterResult = evaluateToken(currentPosition, CommaSeparatorToken.instance);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }

      result = parseTypeArgument(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result);
    }
  }

  private EvaluationResult evaluateTypeArgumentsExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LessThanOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateTypeArgumentsExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), GreaterThanOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeArgumentExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseReferenceType(position)).succeeded) { return result; }
    return parseWildcardTypeArgument(position);
  }

  private EvaluationResult evaluateWildcardTypeArgumentExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseExtendsWildcardTypeArgument(position)).succeeded) { return result; }
    if ((result = parseSuperWildcardTypeArgument(position)).succeeded) { return result; }
    return parseOpenWildcardTypeArgument(position);
  }

  private EvaluationResult evaluateExtendsWildcardTypeArgumentExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, QuestionMarkOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), ExtendsKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseReferenceType(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateSuperWildcardTypeArgumentExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, QuestionMarkOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SuperKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseReferenceType(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateNonWildcardTypeArgumentsExpression_0(int position) {
    ArrayList<Object> elements = null;
    ArrayList<Object> delimiters = null;
    EvaluationResult result = parseReferenceType(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    elements = addValue(elements, result);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult delimiterResult = evaluateToken(currentPosition, CommaSeparatorToken.instance);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }

      result = parseReferenceType(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result);
    }
  }

  private EvaluationResult evaluateNonWildcardTypeArgumentsExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LessThanOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateNonWildcardTypeArgumentsExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), GreaterThanOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluatePrimitiveTypeExpression_0(int position) {
    EvaluationResult result;
    if ((result = evaluateToken(position, ByteKeywordToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, ShortKeywordToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, CharKeywordToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, IntKeywordToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, LongKeywordToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, FloatKeywordToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, DoubleKeywordToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, BooleanKeywordToken.instance)).succeeded) { return result; }
    return evaluateToken(position, VoidKeywordToken.instance);
  }

  private EvaluationResult evaluateAnnotationExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseNormalAnnotation(position)).succeeded) { return result; }
    if ((result = parseSingleElementAnnotation(position)).succeeded) { return result; }
    return parseMarkerAnnotation(position);
  }

  private EvaluationResult evaluateNormalAnnotationExpression_0(int position) {
    ArrayList<Object> elements = null;
    ArrayList<Object> delimiters = null;
    EvaluationResult result = parseElementValuePair(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    elements = addValue(elements, result);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult delimiterResult = evaluateToken(currentPosition, CommaSeparatorToken.instance);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }

      result = parseElementValuePair(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result);
    }
  }

  private EvaluationResult evaluateNormalAnnotationExpression_1(int position) {
    EvaluationResult result;
    if ((result = evaluateNormalAnnotationExpression_0(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateNormalAnnotationExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, AtSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseQualifiedIdentifier(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateNormalAnnotationExpression_1(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateElementValuePairExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateQualifiedIdentifierExpression_0(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), EqualsOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseElementValue(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateSingleElementAnnotationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, AtSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseQualifiedIdentifier(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseElementValue(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateMarkerAnnotationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, AtSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseQualifiedIdentifier(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateElementValueExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseAnnotation(position)).succeeded) { return result; }
    if ((result = parseExpression(position)).succeeded) { return result; }
    return parseElementValueArrayInitializer(position);
  }

  private EvaluationResult evaluateElementValueArrayInitializerExpression_0(int position) {
    ArrayList<Object> elements = null;
    ArrayList<Object> delimiters = null;
    EvaluationResult result = parseElementValue(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    elements = addValue(elements, result);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult delimiterResult = evaluateToken(currentPosition, CommaSeparatorToken.instance);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }

      result = parseElementValue(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result);
    }
  }

  private EvaluationResult evaluateElementValueArrayInitializerExpression_1(int position) {
    EvaluationResult result;
    if ((result = evaluateElementValueArrayInitializerExpression_0(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateElementValueArrayInitializerExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LeftCurlySeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateElementValueArrayInitializerExpression_1(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateEnumBodyExpression_2(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightCurlySeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateBlockExpression_0(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = parseBlockStatement(currentPosition);
      if (result.succeeded) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateBlockExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LeftCurlySeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateBlockExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightCurlySeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateBlockStatementExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseLocalVariableDeclarationStatement(position)).succeeded) { return result; }
    if ((result = parseClassDeclaration(position)).succeeded) { return result; }
    return parseStatement(position);
  }

  private EvaluationResult evaluateLocalVariableDeclarationStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseLocalVariableDeclaration(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateLocalVariableDeclarationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseModifiers(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseType(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateFieldDeclarationExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateStatementExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseBlock(position)).succeeded) { return result; }
    if ((result = parseEmptyStatement(position)).succeeded) { return result; }
    if ((result = parseExpressionStatement(position)).succeeded) { return result; }
    if ((result = parseAssertStatement(position)).succeeded) { return result; }
    if ((result = parseSwitchStatement(position)).succeeded) { return result; }
    if ((result = parseDoStatement(position)).succeeded) { return result; }
    if ((result = parseBreakStatement(position)).succeeded) { return result; }
    if ((result = parseContinueStatement(position)).succeeded) { return result; }
    if ((result = parseReturnStatement(position)).succeeded) { return result; }
    if ((result = parseSynchronizedStatement(position)).succeeded) { return result; }
    if ((result = parseThrowStatement(position)).succeeded) { return result; }
    if ((result = parseTryStatement(position)).succeeded) { return result; }
    if ((result = parseLabeledStatement(position)).succeeded) { return result; }
    if ((result = parseIfStatement(position)).succeeded) { return result; }
    if ((result = parseWhileStatement(position)).succeeded) { return result; }
    return parseForStatement(position);
  }

  private EvaluationResult evaluateLabeledStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateQualifiedIdentifierExpression_0(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), ColonOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseStatement(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateExpressionStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseExpression(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateIfStatementExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseElseStatement(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateIfStatementExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, IfKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseStatement(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateIfStatementExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateElseStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ElseKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseStatement(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateAssertStatementExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseMessageAssertStatement(position)).succeeded) { return result; }
    return parseSimpleAssertStatement(position);
  }

  private EvaluationResult evaluateMessageAssertStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, AssertKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), ColonOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateSimpleAssertStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, AssertKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateSwitchStatementExpression_0(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = parseSwitchBlockStatementGroup(currentPosition);
      if (result.succeeded) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateSwitchStatementExpression_1(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = parseSwitchLabel(currentPosition);
      if (result.succeeded) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateSwitchStatementExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, SwitchKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftCurlySeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateSwitchStatementExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateSwitchStatementExpression_1(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightCurlySeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateSwitchBlockStatementGroupExpression_0(int position) {
    ArrayList<Object> values = null;
    EvaluationResult result = parseSwitchLabel(position);
    if (!result.succeeded) {
      return EvaluationResult.failure;
    }
    while (true) {
      int currentPosition = result.getPosition();
      values = addValue(values, result);
      result = parseSwitchLabel(currentPosition);
      if (!result.succeeded) {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateSwitchBlockStatementGroupExpression_1(int position) {
    ArrayList<Object> values = null;
    EvaluationResult result = parseBlockStatement(position);
    if (!result.succeeded) {
      return EvaluationResult.failure;
    }
    while (true) {
      int currentPosition = result.getPosition();
      values = addValue(values, result);
      result = parseBlockStatement(currentPosition);
      if (!result.succeeded) {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateSwitchBlockStatementGroupExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateSwitchBlockStatementGroupExpression_0(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateSwitchBlockStatementGroupExpression_1(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateSwitchLabelExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseCaseSwitchLabel(position)).succeeded) { return result; }
    return parseDefaultSwitchLabel(position);
  }

  private EvaluationResult evaluateCaseSwitchLabelExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, CaseKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), ColonOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateDefaultSwitchLabelExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, DefaultKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), ColonOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateWhileStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, WhileKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseStatement(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateDoStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, DoKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseStatement(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), WhileKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateForStatementExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseBasicForStatement(position)).succeeded) { return result; }
    return parseEnhancedForStatement(position);
  }

  private EvaluationResult evaluateBasicForStatementExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseForInitializer(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateBasicForStatementExpression_1(int position) {
    EvaluationResult result;
    if ((result = parseExpression(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateBasicForStatementExpression_2(int position) {
    EvaluationResult result;
    if ((result = parseForUpdate(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateBasicForStatementExpression_3(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ForKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateBasicForStatementExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateBasicForStatementExpression_1(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateBasicForStatementExpression_2(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseStatement(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateForInitializerExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseLocalVariableDeclaration(position)).succeeded) { return result; }
    return parseDelimitedExpressionList(position);
  }

  private EvaluationResult evaluateEnhancedForStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ForKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseModifiers(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseType(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateQualifiedIdentifierExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), ColonOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseStatement(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateBreakStatementExpression_0(int position) {
    EvaluationResult result;
    if ((result = evaluateQualifiedIdentifierExpression_0(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateBreakStatementExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, BreakKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateBreakStatementExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateContinueStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ContinueKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateBreakStatementExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateReturnStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ReturnKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateBasicForStatementExpression_1(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateThrowStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ThrowKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateBasicForStatementExpression_1(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateSynchronizedStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, SynchronizedKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseBlock(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTryStatementExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseTryStatementWithFinally(position)).succeeded) { return result; }
    return parseTryStatementWithoutFinally(position);
  }

  private EvaluationResult evaluateTryStatementWithFinallyExpression_0(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = parseCatchClause(currentPosition);
      if (result.succeeded) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateTryStatementWithFinallyExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, TryKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseBlock(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateTryStatementWithFinallyExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), FinallyKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseBlock(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTryStatementWithoutFinallyExpression_0(int position) {
    ArrayList<Object> values = null;
    EvaluationResult result = parseCatchClause(position);
    if (!result.succeeded) {
      return EvaluationResult.failure;
    }
    while (true) {
      int currentPosition = result.getPosition();
      values = addValue(values, result);
      result = parseCatchClause(currentPosition);
      if (!result.succeeded) {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateTryStatementWithoutFinallyExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, TryKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseBlock(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateTryStatementWithoutFinallyExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateCatchClauseExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, CatchKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseFormalParameter(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseBlock(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateExpressionExpression_0(int position) {
    ArrayList<Object> elements = null;
    ArrayList<Object> delimiters = null;
    EvaluationResult result = parseExpression1(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    elements = addValue(elements, result);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult delimiterResult = parseAssignmentOperator(currentPosition);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }

      result = parseExpression1(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result);
    }
  }

  private EvaluationResult evaluateAssignmentOperatorExpression_0(int position) {
    EvaluationResult result;
    if ((result = evaluateToken(position, EqualsOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, PlusEqualsOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, MinusEqualsOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, TimesEqualsOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, DivideEqualsOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, AndEqualsOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, OrEqualsOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, ExclusiveOrEqualsOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, ModulusEqualsOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, LeftShiftEqualsOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, RightShiftEqualsOperatorToken.instance)).succeeded) { return result; }
    return evaluateToken(position, BitwiseRightShiftEqualsOperatorToken.instance);
  }

  private EvaluationResult evaluateExpression1Expression_0(int position) {
    EvaluationResult result;
    if ((result = parseTernaryExpression(position)).succeeded) { return result; }
    return parseExpression2(position);
  }

  private EvaluationResult evaluateTernaryExpressionExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseExpression2(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), QuestionMarkOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), ColonOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression1(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateExpression2Expression_0(int position) {
    EvaluationResult result;
    if ((result = parseBinaryExpression(position)).succeeded) { return result; }
    return parseExpression3(position);
  }

  private EvaluationResult evaluateBinaryExpressionExpression_0(int position) {
    ArrayList<Object> values = null;
    EvaluationResult result = parseBinaryExpressionRest(position);
    if (!result.succeeded) {
      return EvaluationResult.failure;
    }
    while (true) {
      int currentPosition = result.getPosition();
      values = addValue(values, result);
      result = parseBinaryExpressionRest(currentPosition);
      if (!result.succeeded) {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateBinaryExpressionExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseExpression3(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateBinaryExpressionExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateBinaryExpressionRestExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseInfixOperatorBinaryExpressionRest(position)).succeeded) { return result; }
    return parseInstanceofOperatorBinaryExpressionRest(position);
  }

  private EvaluationResult evaluateInfixOperatorBinaryExpressionRestExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseInfixOperator(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression3(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateInstanceofOperatorBinaryExpressionRestExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, InstanceofKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseType(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateInfixOperatorExpression_0(int position) {
    EvaluationResult result;
    if ((result = evaluateToken(position, LogicalOrOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, LogicalAndOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, BitwiseOrOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, BitwiseExclusiveOrOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, BitwiseAndOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, EqualsEqualsOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, NotEqualsOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, LessThanOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, LessThanOrEqualsOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, GreaterThanOrEqualsOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, LeftShiftOperatorToken.instance)).succeeded) { return result; }
    if ((result = parseUnsignedRightShift(position)).succeeded) { return result; }
    if ((result = parseSignedRightShift(position)).succeeded) { return result; }
    if ((result = evaluateToken(position, GreaterThanOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, PlusOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, MinusOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, TimesOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, DivideOperatorToken.instance)).succeeded) { return result; }
    return evaluateToken(position, ModulusOperatorToken.instance);
  }

  private EvaluationResult evaluateUnsignedRightShiftExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, GreaterThanOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), GreaterThanOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), GreaterThanOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateSignedRightShiftExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, GreaterThanOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), GreaterThanOperatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateExpression3Expression_0(int position) {
    EvaluationResult result;
    if ((result = parsePrefixExpression(position)).succeeded) { return result; }
    if ((result = parsePossibleCastExpression(position)).succeeded) { return result; }
    return parsePrimaryExpression(position);
  }

  private EvaluationResult evaluatePrefixExpressionExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parsePrefixOperator(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression3(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluatePrefixOperatorExpression_0(int position) {
    EvaluationResult result;
    if ((result = evaluateToken(position, IncrementOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, DecrementOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, LogicalNotOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, BitwiseNotOperatorToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, PlusOperatorToken.instance)).succeeded) { return result; }
    return evaluateToken(position, MinusOperatorToken.instance);
  }

  private EvaluationResult evaluatePossibleCastExpressionExpression_0(int position) {
    EvaluationResult result;
    if ((result = parsePossibleCastExpression_Type(position)).succeeded) { return result; }
    return parsePossibleCastExpression_Expression(position);
  }

  private EvaluationResult evaluatePossibleCastExpression_TypeExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LeftParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseType(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression3(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluatePossibleCastExpression_ExpressionExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LeftParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression3(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluatePrimaryExpressionExpression_0(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = parseSelector(currentPosition);
      if (result.succeeded) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluatePrimaryExpressionExpression_1(int position) {
    EvaluationResult result;
    if ((result = parsePostfixOperator(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluatePrimaryExpressionExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseValueExpression(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluatePrimaryExpressionExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluatePrimaryExpressionExpression_1(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluatePostfixOperatorExpression_0(int position) {
    EvaluationResult result;
    if ((result = evaluateToken(position, IncrementOperatorToken.instance)).succeeded) { return result; }
    return evaluateToken(position, DecrementOperatorToken.instance);
  }

  private EvaluationResult evaluateValueExpressionExpression_0(int position) {
    if (position < tokens.size()) {
      SourceToken<Token> token = tokens.get(position);
      Class<? extends Token> actualType = token.getToken().getClass();
      if (LiteralToken.class.isAssignableFrom(actualType)) {
        return new EvaluationResult(true, position + 1, token);
      }
    }
    return EvaluationResult.failure;
  }

  private EvaluationResult evaluateValueExpressionExpression_1(int position) {
    EvaluationResult result;
    if ((result = parseParenthesizedExpression(position)).succeeded) { return result; }
    if ((result = parseMethodInvocation(position)).succeeded) { return result; }
    if ((result = parseThisConstructorInvocation(position)).succeeded) { return result; }
    if ((result = parseSuperConstructorInvocation(position)).succeeded) { return result; }
    if ((result = evaluateToken(position, ThisKeywordToken.instance)).succeeded) { return result; }
    if ((result = evaluateToken(position, SuperKeywordToken.instance)).succeeded) { return result; }
    if ((result = parseClassAccess(position)).succeeded) { return result; }
    if ((result = evaluateValueExpressionExpression_0(position)).succeeded) { return result; }
    if ((result = evaluateQualifiedIdentifierExpression_0(position)).succeeded) { return result; }
    return parseCreationExpression(position);
  }

  private EvaluationResult evaluateClassAccessExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseType(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), DotSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), ClassKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateSelectorExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseDotSelector(position)).succeeded) { return result; }
    return parseArraySelector(position);
  }

  private EvaluationResult evaluateDotSelectorExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, DotSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseValueExpression(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateArraySelectorExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LeftBracketSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightBracketSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateParenthesizedExpressionExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LeftParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateMethodInvocationExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseNonWildcardTypeArguments(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateMethodInvocationExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateMethodInvocationExpression_0(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateQualifiedIdentifierExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseArguments(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateThisConstructorInvocationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ThisKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseArguments(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateSuperConstructorInvocationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, SuperKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseArguments(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateCreationExpressionExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseObjectCreationExpression(position)).succeeded) { return result; }
    return parseArrayCreationExpression(position);
  }

  private EvaluationResult evaluateObjectCreationExpressionExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseClassBody(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateObjectCreationExpressionExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, NewKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateMethodInvocationExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseClassOrInterfaceType(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseArguments(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateObjectCreationExpressionExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateArrayCreationExpressionExpression_0(int position) {
    ArrayList<Object> values = null;
    EvaluationResult result = parseDimensionExpression(position);
    if (!result.succeeded) {
      return EvaluationResult.failure;
    }
    while (true) {
      int currentPosition = result.getPosition();
      values = addValue(values, result);
      result = parseDimensionExpression(currentPosition);
      if (!result.succeeded) {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateArrayCreationExpressionExpression_1(int position) {
    EvaluationResult result;
    if ((result = parseArrayInitializer(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateArrayCreationExpressionExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, NewKeywordToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseArrayCreationType(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateArrayCreationExpressionExpression_0(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateArrayCreationExpressionExpression_1(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateArrayCreationTypeExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseClassOrInterfaceType(position)).succeeded) { return result; }
    return parsePrimitiveType(position);
  }

  private EvaluationResult evaluateDimensionExpressionExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LeftBracketSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateBasicForStatementExpression_1(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightBracketSeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateArrayInitializerExpression_0(int position) {
    ArrayList<Object> elements = null;
    ArrayList<Object> delimiters = null;
    EvaluationResult result = parseVariableInitializer(position);
    if (!result.succeeded) { return EvaluationResult.failure; }
    elements = addValue(elements, result);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult delimiterResult = evaluateToken(currentPosition, CommaSeparatorToken.instance);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }

      result = parseVariableInitializer(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult(true, currentPosition, Arrays.asList(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result);
    }
  }

  private EvaluationResult evaluateArrayInitializerExpression_1(int position) {
    EvaluationResult result;
    if ((result = evaluateArrayInitializerExpression_0(position)).succeeded) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateArrayInitializerExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LeftCurlySeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateArrayInitializerExpression_1(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateEnumBodyExpression_2(result.getPosition());
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightCurlySeparatorToken.instance);
    if (!result.succeeded) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateVariableInitializerExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseArrayInitializer(position)).succeeded) { return result; }
    return parseExpression(position);
  }

  private Map<Integer, EvaluationResult> CompilationUnitMap;

  private EvaluationResult parseCompilationUnit(int position) {
    EvaluationResult result = (CompilationUnitMap == null ? null : CompilationUnitMap.get(position));
    if (result == null) {
      result = evaluateCompilationUnitExpression_4(position);
      CompilationUnitMap = initializeMap(CompilationUnitMap);
      CompilationUnitMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> PackageDeclarationMap;

  private EvaluationResult parsePackageDeclaration(int position) {
    EvaluationResult result = (PackageDeclarationMap == null ? null : PackageDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_PackageDeclaration(position)) {
        result = evaluatePackageDeclarationExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      PackageDeclarationMap = initializeMap(PackageDeclarationMap);
      PackageDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> QualifiedIdentifierMap;

  private EvaluationResult parseQualifiedIdentifier(int position) {
    EvaluationResult result = (QualifiedIdentifierMap == null ? null : QualifiedIdentifierMap.get(position));
    if (result == null) {
      if (checkToken_QualifiedIdentifier(position)) {
        result = evaluateQualifiedIdentifierExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      QualifiedIdentifierMap = initializeMap(QualifiedIdentifierMap);
      QualifiedIdentifierMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ImportDeclarationMap;

  private EvaluationResult parseImportDeclaration(int position) {
    EvaluationResult result = (ImportDeclarationMap == null ? null : ImportDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_ImportDeclaration(position)) {
        result = evaluateImportDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ImportDeclarationMap = initializeMap(ImportDeclarationMap);
      ImportDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SingleTypeImportDeclarationMap;

  private EvaluationResult parseSingleTypeImportDeclaration(int position) {
    EvaluationResult result = (SingleTypeImportDeclarationMap == null
                               ? null
                               : SingleTypeImportDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_SingleTypeImportDeclaration(position)) {
        result = evaluateSingleTypeImportDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      SingleTypeImportDeclarationMap = initializeMap(SingleTypeImportDeclarationMap);
      SingleTypeImportDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TypeImportOnDemandDeclarationMap;

  private EvaluationResult parseTypeImportOnDemandDeclaration(int position) {
    EvaluationResult result = (TypeImportOnDemandDeclarationMap == null
                               ? null
                               : TypeImportOnDemandDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_TypeImportOnDemandDeclaration(position)) {
        result = evaluateTypeImportOnDemandDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      TypeImportOnDemandDeclarationMap = initializeMap(TypeImportOnDemandDeclarationMap);
      TypeImportOnDemandDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SingleStaticImportDeclarationMap;

  private EvaluationResult parseSingleStaticImportDeclaration(int position) {
    EvaluationResult result = (SingleStaticImportDeclarationMap == null
                               ? null
                               : SingleStaticImportDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_SingleStaticImportDeclaration(position)) {
        result = evaluateSingleStaticImportDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      SingleStaticImportDeclarationMap = initializeMap(SingleStaticImportDeclarationMap);
      SingleStaticImportDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> StaticImportOnDemandDeclarationMap;

  private EvaluationResult parseStaticImportOnDemandDeclaration(int position) {
    EvaluationResult result = (StaticImportOnDemandDeclarationMap == null
                               ? null
                               : StaticImportOnDemandDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_StaticImportOnDemandDeclaration(position)) {
        result = evaluateStaticImportOnDemandDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      StaticImportOnDemandDeclarationMap = initializeMap(StaticImportOnDemandDeclarationMap);
      StaticImportOnDemandDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TypeDeclarationMap;

  private EvaluationResult parseTypeDeclaration(int position) {
    EvaluationResult result = (TypeDeclarationMap == null ? null : TypeDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_TypeDeclaration(position)) {
        result = evaluateTypeDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      TypeDeclarationMap = initializeMap(TypeDeclarationMap);
      TypeDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ClassDeclarationMap;

  private EvaluationResult parseClassDeclaration(int position) {
    EvaluationResult result = (ClassDeclarationMap == null ? null : ClassDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_ClassDeclaration(position)) {
        result = evaluateClassDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ClassDeclarationMap = initializeMap(ClassDeclarationMap);
      ClassDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> NormalClassDeclarationMap;

  private EvaluationResult parseNormalClassDeclaration(int position) {
    EvaluationResult result = (NormalClassDeclarationMap == null ? null : NormalClassDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_NormalClassDeclaration(position)) {
        result = evaluateNormalClassDeclarationExpression_3(position);
      } else {
        result = EvaluationResult.failure;
      }
      NormalClassDeclarationMap = initializeMap(NormalClassDeclarationMap);
      NormalClassDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ModifiersMap;

  private EvaluationResult parseModifiers(int position) {
    EvaluationResult result = (ModifiersMap == null ? null : ModifiersMap.get(position));
    if (result == null) {
      result = evaluateModifiersExpression_0(position);
      ModifiersMap = initializeMap(ModifiersMap);
      ModifiersMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ModifierMap;

  private EvaluationResult parseModifier(int position) {
    EvaluationResult result = (ModifierMap == null ? null : ModifierMap.get(position));
    if (result == null) {
      if (checkToken_Modifier(position)) {
        result = evaluateModifierExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ModifierMap = initializeMap(ModifierMap);
      ModifierMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SuperMap;

  private EvaluationResult parseSuper(int position) {
    EvaluationResult result = (SuperMap == null ? null : SuperMap.get(position));
    if (result == null) {
      if (checkToken_Super(position)) {
        result = evaluateSuperExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      SuperMap = initializeMap(SuperMap);
      SuperMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> InterfacesMap;

  private EvaluationResult parseInterfaces(int position) {
    EvaluationResult result = (InterfacesMap == null ? null : InterfacesMap.get(position));
    if (result == null) {
      if (checkToken_Interfaces(position)) {
        result = evaluateInterfacesExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      InterfacesMap = initializeMap(InterfacesMap);
      InterfacesMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ClassBodyMap;

  private EvaluationResult parseClassBody(int position) {
    EvaluationResult result = (ClassBodyMap == null ? null : ClassBodyMap.get(position));
    if (result == null) {
      if (checkToken_ClassBody(position)) {
        result = evaluateClassBodyExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      ClassBodyMap = initializeMap(ClassBodyMap);
      ClassBodyMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ClassBodyDeclarationMap;

  private EvaluationResult parseClassBodyDeclaration(int position) {
    EvaluationResult result = (ClassBodyDeclarationMap == null ? null : ClassBodyDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_ClassBodyDeclaration(position)) {
        result = evaluateClassBodyDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ClassBodyDeclarationMap = initializeMap(ClassBodyDeclarationMap);
      ClassBodyDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> StaticInitializerMap;

  private EvaluationResult parseStaticInitializer(int position) {
    EvaluationResult result = (StaticInitializerMap == null ? null : StaticInitializerMap.get(position));
    if (result == null) {
      if (checkToken_StaticInitializer(position)) {
        result = evaluateStaticInitializerExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      StaticInitializerMap = initializeMap(StaticInitializerMap);
      StaticInitializerMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> InterfaceDeclarationMap;

  private EvaluationResult parseInterfaceDeclaration(int position) {
    EvaluationResult result = (InterfaceDeclarationMap == null ? null : InterfaceDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_InterfaceDeclaration(position)) {
        result = evaluateInterfaceDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      InterfaceDeclarationMap = initializeMap(InterfaceDeclarationMap);
      InterfaceDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> NormalInterfaceDeclarationMap;

  private EvaluationResult parseNormalInterfaceDeclaration(int position) {
    EvaluationResult result = (NormalInterfaceDeclarationMap == null
                               ? null
                               : NormalInterfaceDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_NormalInterfaceDeclaration(position)) {
        result = evaluateNormalInterfaceDeclarationExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      NormalInterfaceDeclarationMap = initializeMap(NormalInterfaceDeclarationMap);
      NormalInterfaceDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ExtendsInterfacesMap;

  private EvaluationResult parseExtendsInterfaces(int position) {
    EvaluationResult result = (ExtendsInterfacesMap == null ? null : ExtendsInterfacesMap.get(position));
    if (result == null) {
      if (checkToken_ExtendsInterfaces(position)) {
        result = evaluateExtendsInterfacesExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ExtendsInterfacesMap = initializeMap(ExtendsInterfacesMap);
      ExtendsInterfacesMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ClassOrInterfaceBodyMap;

  private EvaluationResult parseClassOrInterfaceBody(int position) {
    EvaluationResult result = (ClassOrInterfaceBodyMap == null ? null : ClassOrInterfaceBodyMap.get(position));
    if (result == null) {
      if (checkToken_ClassOrInterfaceBody(position)) {
        result = evaluateClassOrInterfaceBodyExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      ClassOrInterfaceBodyMap = initializeMap(ClassOrInterfaceBodyMap);
      ClassOrInterfaceBodyMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> EnumDeclarationMap;

  private EvaluationResult parseEnumDeclaration(int position) {
    EvaluationResult result = (EnumDeclarationMap == null ? null : EnumDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_EnumDeclaration(position)) {
        result = evaluateEnumDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      EnumDeclarationMap = initializeMap(EnumDeclarationMap);
      EnumDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> EnumBodyMap;

  private EvaluationResult parseEnumBody(int position) {
    EvaluationResult result = (EnumBodyMap == null ? null : EnumBodyMap.get(position));
    if (result == null) {
      if (checkToken_EnumBody(position)) {
        result = evaluateEnumBodyExpression_4(position);
      } else {
        result = EvaluationResult.failure;
      }
      EnumBodyMap = initializeMap(EnumBodyMap);
      EnumBodyMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> EnumConstantMap;

  private EvaluationResult parseEnumConstant(int position) {
    EvaluationResult result = (EnumConstantMap == null ? null : EnumConstantMap.get(position));
    if (result == null) {
      if (checkToken_EnumConstant(position)) {
        result = evaluateEnumConstantExpression_2(position);
      } else {
        result = EvaluationResult.failure;
      }
      EnumConstantMap = initializeMap(EnumConstantMap);
      EnumConstantMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ArgumentsMap;

  private EvaluationResult parseArguments(int position) {
    EvaluationResult result = (ArgumentsMap == null ? null : ArgumentsMap.get(position));
    if (result == null) {
      if (checkToken_Arguments(position)) {
        result = evaluateArgumentsExpression_2(position);
      } else {
        result = EvaluationResult.failure;
      }
      ArgumentsMap = initializeMap(ArgumentsMap);
      ArgumentsMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> AnnotationDeclarationMap;

  private EvaluationResult parseAnnotationDeclaration(int position) {
    EvaluationResult result = (AnnotationDeclarationMap == null ? null : AnnotationDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_AnnotationDeclaration(position)) {
        result = evaluateAnnotationDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      AnnotationDeclarationMap = initializeMap(AnnotationDeclarationMap);
      AnnotationDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> AnnotationBodyMap;

  private EvaluationResult parseAnnotationBody(int position) {
    EvaluationResult result = (AnnotationBodyMap == null ? null : AnnotationBodyMap.get(position));
    if (result == null) {
      if (checkToken_AnnotationBody(position)) {
        result = evaluateAnnotationBodyExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      AnnotationBodyMap = initializeMap(AnnotationBodyMap);
      AnnotationBodyMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> AnnotationElementDeclarationMap;

  private EvaluationResult parseAnnotationElementDeclaration(int position) {
    EvaluationResult result = (AnnotationElementDeclarationMap == null
                               ? null
                               : AnnotationElementDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_AnnotationElementDeclaration(position)) {
        result = evaluateAnnotationElementDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      AnnotationElementDeclarationMap = initializeMap(AnnotationElementDeclarationMap);
      AnnotationElementDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> AnnotationDefaultDeclarationMap;

  private EvaluationResult parseAnnotationDefaultDeclaration(int position) {
    EvaluationResult result = (AnnotationDefaultDeclarationMap == null
                               ? null
                               : AnnotationDefaultDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_AnnotationDefaultDeclaration(position)) {
        result = evaluateAnnotationDefaultDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      AnnotationDefaultDeclarationMap = initializeMap(AnnotationDefaultDeclarationMap);
      AnnotationDefaultDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ClassOrInterfaceMemberDeclarationMap;

  private EvaluationResult parseClassOrInterfaceMemberDeclaration(int position) {
    EvaluationResult result = (ClassOrInterfaceMemberDeclarationMap == null
                               ? null
                               : ClassOrInterfaceMemberDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_ClassOrInterfaceMemberDeclaration(position)) {
        result = evaluateClassOrInterfaceMemberDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ClassOrInterfaceMemberDeclarationMap = initializeMap(ClassOrInterfaceMemberDeclarationMap);
      ClassOrInterfaceMemberDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ConstructorDeclarationMap;

  private EvaluationResult parseConstructorDeclaration(int position) {
    EvaluationResult result = (ConstructorDeclarationMap == null ? null : ConstructorDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_ConstructorDeclaration(position)) {
        result = evaluateConstructorDeclarationExpression_3(position);
      } else {
        result = EvaluationResult.failure;
      }
      ConstructorDeclarationMap = initializeMap(ConstructorDeclarationMap);
      ConstructorDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> FieldDeclarationMap;

  private EvaluationResult parseFieldDeclaration(int position) {
    EvaluationResult result = (FieldDeclarationMap == null ? null : FieldDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_FieldDeclaration(position)) {
        result = evaluateFieldDeclarationExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      FieldDeclarationMap = initializeMap(FieldDeclarationMap);
      FieldDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> VariableDeclaratorMap;

  private EvaluationResult parseVariableDeclarator(int position) {
    EvaluationResult result = (VariableDeclaratorMap == null ? null : VariableDeclaratorMap.get(position));
    if (result == null) {
      if (checkToken_VariableDeclarator(position)) {
        result = evaluateVariableDeclaratorExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      VariableDeclaratorMap = initializeMap(VariableDeclaratorMap);
      VariableDeclaratorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> VariableDeclaratorIdAndAssignmentMap;

  private EvaluationResult parseVariableDeclaratorIdAndAssignment(int position) {
    EvaluationResult result = (VariableDeclaratorIdAndAssignmentMap == null
                               ? null
                               : VariableDeclaratorIdAndAssignmentMap.get(position));
    if (result == null) {
      if (checkToken_VariableDeclaratorIdAndAssignment(position)) {
        result = evaluateVariableDeclaratorIdAndAssignmentExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      VariableDeclaratorIdAndAssignmentMap = initializeMap(VariableDeclaratorIdAndAssignmentMap);
      VariableDeclaratorIdAndAssignmentMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> VariableDeclaratorAssignmentMap;

  private EvaluationResult parseVariableDeclaratorAssignment(int position) {
    EvaluationResult result = (VariableDeclaratorAssignmentMap == null
                               ? null
                               : VariableDeclaratorAssignmentMap.get(position));
    if (result == null) {
      if (checkToken_VariableDeclaratorAssignment(position)) {
        result = evaluateVariableDeclaratorAssignmentExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      VariableDeclaratorAssignmentMap = initializeMap(VariableDeclaratorAssignmentMap);
      VariableDeclaratorAssignmentMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> VariableDeclaratorIdMap;

  private EvaluationResult parseVariableDeclaratorId(int position) {
    EvaluationResult result = (VariableDeclaratorIdMap == null ? null : VariableDeclaratorIdMap.get(position));
    if (result == null) {
      if (checkToken_VariableDeclaratorId(position)) {
        result = evaluateVariableDeclaratorIdExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      VariableDeclaratorIdMap = initializeMap(VariableDeclaratorIdMap);
      VariableDeclaratorIdMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> BracketPairMap;

  private EvaluationResult parseBracketPair(int position) {
    EvaluationResult result = (BracketPairMap == null ? null : BracketPairMap.get(position));
    if (result == null) {
      if (checkToken_BracketPair(position)) {
        result = evaluateBracketPairExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      BracketPairMap = initializeMap(BracketPairMap);
      BracketPairMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> MethodDeclarationMap;

  private EvaluationResult parseMethodDeclaration(int position) {
    EvaluationResult result = (MethodDeclarationMap == null ? null : MethodDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_MethodDeclaration(position)) {
        result = evaluateMethodDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      MethodDeclarationMap = initializeMap(MethodDeclarationMap);
      MethodDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> MethodBodyMap;

  private EvaluationResult parseMethodBody(int position) {
    EvaluationResult result = (MethodBodyMap == null ? null : MethodBodyMap.get(position));
    if (result == null) {
      if (checkToken_MethodBody(position)) {
        result = evaluateMethodBodyExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      MethodBodyMap = initializeMap(MethodBodyMap);
      MethodBodyMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> FormalParameterMap;

  private EvaluationResult parseFormalParameter(int position) {
    EvaluationResult result = (FormalParameterMap == null ? null : FormalParameterMap.get(position));
    if (result == null) {
      if (checkToken_FormalParameter(position)) {
        result = evaluateFormalParameterExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      FormalParameterMap = initializeMap(FormalParameterMap);
      FormalParameterMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ThrowsMap;

  private EvaluationResult parseThrows(int position) {
    EvaluationResult result = (ThrowsMap == null ? null : ThrowsMap.get(position));
    if (result == null) {
      if (checkToken_Throws(position)) {
        result = evaluateThrowsExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ThrowsMap = initializeMap(ThrowsMap);
      ThrowsMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TypeParametersMap;

  private EvaluationResult parseTypeParameters(int position) {
    EvaluationResult result = (TypeParametersMap == null ? null : TypeParametersMap.get(position));
    if (result == null) {
      if (checkToken_TypeParameters(position)) {
        result = evaluateTypeParametersExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      TypeParametersMap = initializeMap(TypeParametersMap);
      TypeParametersMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TypeParameterMap;

  private EvaluationResult parseTypeParameter(int position) {
    EvaluationResult result = (TypeParameterMap == null ? null : TypeParameterMap.get(position));
    if (result == null) {
      if (checkToken_TypeParameter(position)) {
        result = evaluateTypeParameterExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      TypeParameterMap = initializeMap(TypeParameterMap);
      TypeParameterMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TypeBoundMap;

  private EvaluationResult parseTypeBound(int position) {
    EvaluationResult result = (TypeBoundMap == null ? null : TypeBoundMap.get(position));
    if (result == null) {
      if (checkToken_TypeBound(position)) {
        result = evaluateTypeBoundExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      TypeBoundMap = initializeMap(TypeBoundMap);
      TypeBoundMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TypeMap;

  private EvaluationResult parseType(int position) {
    EvaluationResult result = (TypeMap == null ? null : TypeMap.get(position));
    if (result == null) {
      if (checkToken_Type(position)) {
        result = evaluateTypeExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      TypeMap = initializeMap(TypeMap);
      TypeMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ReferenceTypeMap;

  private EvaluationResult parseReferenceType(int position) {
    EvaluationResult result = (ReferenceTypeMap == null ? null : ReferenceTypeMap.get(position));
    if (result == null) {
      if (checkToken_ReferenceType(position)) {
        result = evaluateReferenceTypeExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ReferenceTypeMap = initializeMap(ReferenceTypeMap);
      ReferenceTypeMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> PrimitiveArrayReferenceTypeMap;

  private EvaluationResult parsePrimitiveArrayReferenceType(int position) {
    EvaluationResult result = (PrimitiveArrayReferenceTypeMap == null
                               ? null
                               : PrimitiveArrayReferenceTypeMap.get(position));
    if (result == null) {
      if (checkToken_PrimitiveArrayReferenceType(position)) {
        result = evaluatePrimitiveArrayReferenceTypeExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      PrimitiveArrayReferenceTypeMap = initializeMap(PrimitiveArrayReferenceTypeMap);
      PrimitiveArrayReferenceTypeMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ClassOrInterfaceReferenceTypeMap;

  private EvaluationResult parseClassOrInterfaceReferenceType(int position) {
    EvaluationResult result = (ClassOrInterfaceReferenceTypeMap == null
                               ? null
                               : ClassOrInterfaceReferenceTypeMap.get(position));
    if (result == null) {
      if (checkToken_ClassOrInterfaceReferenceType(position)) {
        result = evaluateClassOrInterfaceReferenceTypeExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ClassOrInterfaceReferenceTypeMap = initializeMap(ClassOrInterfaceReferenceTypeMap);
      ClassOrInterfaceReferenceTypeMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ClassOrInterfaceTypeMap;

  private EvaluationResult parseClassOrInterfaceType(int position) {
    EvaluationResult result = (ClassOrInterfaceTypeMap == null ? null : ClassOrInterfaceTypeMap.get(position));
    if (result == null) {
      if (checkToken_ClassOrInterfaceType(position)) {
        result = evaluateClassOrInterfaceTypeExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ClassOrInterfaceTypeMap = initializeMap(ClassOrInterfaceTypeMap);
      ClassOrInterfaceTypeMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SingleClassOrInterfaceTypeMap;

  private EvaluationResult parseSingleClassOrInterfaceType(int position) {
    EvaluationResult result = (SingleClassOrInterfaceTypeMap == null
                               ? null
                               : SingleClassOrInterfaceTypeMap.get(position));
    if (result == null) {
      if (checkToken_SingleClassOrInterfaceType(position)) {
        result = evaluateSingleClassOrInterfaceTypeExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      SingleClassOrInterfaceTypeMap = initializeMap(SingleClassOrInterfaceTypeMap);
      SingleClassOrInterfaceTypeMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TypeArgumentsMap;

  private EvaluationResult parseTypeArguments(int position) {
    EvaluationResult result = (TypeArgumentsMap == null ? null : TypeArgumentsMap.get(position));
    if (result == null) {
      if (checkToken_TypeArguments(position)) {
        result = evaluateTypeArgumentsExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      TypeArgumentsMap = initializeMap(TypeArgumentsMap);
      TypeArgumentsMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TypeArgumentMap;

  private EvaluationResult parseTypeArgument(int position) {
    EvaluationResult result = (TypeArgumentMap == null ? null : TypeArgumentMap.get(position));
    if (result == null) {
      if (checkToken_TypeArgument(position)) {
        result = evaluateTypeArgumentExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      TypeArgumentMap = initializeMap(TypeArgumentMap);
      TypeArgumentMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> WildcardTypeArgumentMap;

  private EvaluationResult parseWildcardTypeArgument(int position) {
    EvaluationResult result = (WildcardTypeArgumentMap == null ? null : WildcardTypeArgumentMap.get(position));
    if (result == null) {
      if (checkToken_WildcardTypeArgument(position)) {
        result = evaluateWildcardTypeArgumentExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      WildcardTypeArgumentMap = initializeMap(WildcardTypeArgumentMap);
      WildcardTypeArgumentMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ExtendsWildcardTypeArgumentMap;

  private EvaluationResult parseExtendsWildcardTypeArgument(int position) {
    EvaluationResult result = (ExtendsWildcardTypeArgumentMap == null
                               ? null
                               : ExtendsWildcardTypeArgumentMap.get(position));
    if (result == null) {
      if (checkToken_ExtendsWildcardTypeArgument(position)) {
        result = evaluateExtendsWildcardTypeArgumentExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ExtendsWildcardTypeArgumentMap = initializeMap(ExtendsWildcardTypeArgumentMap);
      ExtendsWildcardTypeArgumentMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SuperWildcardTypeArgumentMap;

  private EvaluationResult parseSuperWildcardTypeArgument(int position) {
    EvaluationResult result = (SuperWildcardTypeArgumentMap == null
                               ? null
                               : SuperWildcardTypeArgumentMap.get(position));
    if (result == null) {
      if (checkToken_SuperWildcardTypeArgument(position)) {
        result = evaluateSuperWildcardTypeArgumentExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      SuperWildcardTypeArgumentMap = initializeMap(SuperWildcardTypeArgumentMap);
      SuperWildcardTypeArgumentMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> OpenWildcardTypeArgumentMap;

  private EvaluationResult parseOpenWildcardTypeArgument(int position) {
    EvaluationResult result = (OpenWildcardTypeArgumentMap == null ? null : OpenWildcardTypeArgumentMap.get(position));
    if (result == null) {
      if (checkToken_OpenWildcardTypeArgument(position)) {
        result = evaluateToken(position, QuestionMarkOperatorToken.instance);
      } else {
        result = EvaluationResult.failure;
      }
      OpenWildcardTypeArgumentMap = initializeMap(OpenWildcardTypeArgumentMap);
      OpenWildcardTypeArgumentMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> NonWildcardTypeArgumentsMap;

  private EvaluationResult parseNonWildcardTypeArguments(int position) {
    EvaluationResult result = (NonWildcardTypeArgumentsMap == null ? null : NonWildcardTypeArgumentsMap.get(position));
    if (result == null) {
      if (checkToken_NonWildcardTypeArguments(position)) {
        result = evaluateNonWildcardTypeArgumentsExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      NonWildcardTypeArgumentsMap = initializeMap(NonWildcardTypeArgumentsMap);
      NonWildcardTypeArgumentsMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> PrimitiveTypeMap;

  private EvaluationResult parsePrimitiveType(int position) {
    EvaluationResult result = (PrimitiveTypeMap == null ? null : PrimitiveTypeMap.get(position));
    if (result == null) {
      if (checkToken_PrimitiveType(position)) {
        result = evaluatePrimitiveTypeExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      PrimitiveTypeMap = initializeMap(PrimitiveTypeMap);
      PrimitiveTypeMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> AnnotationMap;

  private EvaluationResult parseAnnotation(int position) {
    EvaluationResult result = (AnnotationMap == null ? null : AnnotationMap.get(position));
    if (result == null) {
      if (checkToken_Annotation(position)) {
        result = evaluateAnnotationExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      AnnotationMap = initializeMap(AnnotationMap);
      AnnotationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> NormalAnnotationMap;

  private EvaluationResult parseNormalAnnotation(int position) {
    EvaluationResult result = (NormalAnnotationMap == null ? null : NormalAnnotationMap.get(position));
    if (result == null) {
      if (checkToken_NormalAnnotation(position)) {
        result = evaluateNormalAnnotationExpression_2(position);
      } else {
        result = EvaluationResult.failure;
      }
      NormalAnnotationMap = initializeMap(NormalAnnotationMap);
      NormalAnnotationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ElementValuePairMap;

  private EvaluationResult parseElementValuePair(int position) {
    EvaluationResult result = (ElementValuePairMap == null ? null : ElementValuePairMap.get(position));
    if (result == null) {
      if (checkToken_ElementValuePair(position)) {
        result = evaluateElementValuePairExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ElementValuePairMap = initializeMap(ElementValuePairMap);
      ElementValuePairMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SingleElementAnnotationMap;

  private EvaluationResult parseSingleElementAnnotation(int position) {
    EvaluationResult result = (SingleElementAnnotationMap == null ? null : SingleElementAnnotationMap.get(position));
    if (result == null) {
      if (checkToken_SingleElementAnnotation(position)) {
        result = evaluateSingleElementAnnotationExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      SingleElementAnnotationMap = initializeMap(SingleElementAnnotationMap);
      SingleElementAnnotationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> MarkerAnnotationMap;

  private EvaluationResult parseMarkerAnnotation(int position) {
    EvaluationResult result = (MarkerAnnotationMap == null ? null : MarkerAnnotationMap.get(position));
    if (result == null) {
      if (checkToken_MarkerAnnotation(position)) {
        result = evaluateMarkerAnnotationExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      MarkerAnnotationMap = initializeMap(MarkerAnnotationMap);
      MarkerAnnotationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ElementValueMap;

  private EvaluationResult parseElementValue(int position) {
    EvaluationResult result = (ElementValueMap == null ? null : ElementValueMap.get(position));
    if (result == null) {
      if (checkToken_ElementValue(position)) {
        result = evaluateElementValueExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ElementValueMap = initializeMap(ElementValueMap);
      ElementValueMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ElementValueArrayInitializerMap;

  private EvaluationResult parseElementValueArrayInitializer(int position) {
    EvaluationResult result = (ElementValueArrayInitializerMap == null
                               ? null
                               : ElementValueArrayInitializerMap.get(position));
    if (result == null) {
      if (checkToken_ElementValueArrayInitializer(position)) {
        result = evaluateElementValueArrayInitializerExpression_2(position);
      } else {
        result = EvaluationResult.failure;
      }
      ElementValueArrayInitializerMap = initializeMap(ElementValueArrayInitializerMap);
      ElementValueArrayInitializerMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> BlockMap;

  private EvaluationResult parseBlock(int position) {
    EvaluationResult result = (BlockMap == null ? null : BlockMap.get(position));
    if (result == null) {
      if (checkToken_Block(position)) {
        result = evaluateBlockExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      BlockMap = initializeMap(BlockMap);
      BlockMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> BlockStatementMap;

  private EvaluationResult parseBlockStatement(int position) {
    EvaluationResult result = (BlockStatementMap == null ? null : BlockStatementMap.get(position));
    if (result == null) {
      if (checkToken_BlockStatement(position)) {
        result = evaluateBlockStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      BlockStatementMap = initializeMap(BlockStatementMap);
      BlockStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> LocalVariableDeclarationStatementMap;

  private EvaluationResult parseLocalVariableDeclarationStatement(int position) {
    EvaluationResult result = (LocalVariableDeclarationStatementMap == null
                               ? null
                               : LocalVariableDeclarationStatementMap.get(position));
    if (result == null) {
      if (checkToken_LocalVariableDeclarationStatement(position)) {
        result = evaluateLocalVariableDeclarationStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      LocalVariableDeclarationStatementMap = initializeMap(LocalVariableDeclarationStatementMap);
      LocalVariableDeclarationStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> LocalVariableDeclarationMap;

  private EvaluationResult parseLocalVariableDeclaration(int position) {
    EvaluationResult result = (LocalVariableDeclarationMap == null ? null : LocalVariableDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_LocalVariableDeclaration(position)) {
        result = evaluateLocalVariableDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      LocalVariableDeclarationMap = initializeMap(LocalVariableDeclarationMap);
      LocalVariableDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> StatementMap;

  private EvaluationResult parseStatement(int position) {
    EvaluationResult result = (StatementMap == null ? null : StatementMap.get(position));
    if (result == null) {
      if (checkToken_Statement(position)) {
        result = evaluateStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      StatementMap = initializeMap(StatementMap);
      StatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> EmptyStatementMap;

  private EvaluationResult parseEmptyStatement(int position) {
    EvaluationResult result = (EmptyStatementMap == null ? null : EmptyStatementMap.get(position));
    if (result == null) {
      if (checkToken_EmptyStatement(position)) {
        result = evaluateToken(position, SemicolonSeparatorToken.instance);
      } else {
        result = EvaluationResult.failure;
      }
      EmptyStatementMap = initializeMap(EmptyStatementMap);
      EmptyStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> LabeledStatementMap;

  private EvaluationResult parseLabeledStatement(int position) {
    EvaluationResult result = (LabeledStatementMap == null ? null : LabeledStatementMap.get(position));
    if (result == null) {
      if (checkToken_LabeledStatement(position)) {
        result = evaluateLabeledStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      LabeledStatementMap = initializeMap(LabeledStatementMap);
      LabeledStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ExpressionStatementMap;

  private EvaluationResult parseExpressionStatement(int position) {
    EvaluationResult result = (ExpressionStatementMap == null ? null : ExpressionStatementMap.get(position));
    if (result == null) {
      if (checkToken_ExpressionStatement(position)) {
        result = evaluateExpressionStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ExpressionStatementMap = initializeMap(ExpressionStatementMap);
      ExpressionStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> IfStatementMap;

  private EvaluationResult parseIfStatement(int position) {
    EvaluationResult result = (IfStatementMap == null ? null : IfStatementMap.get(position));
    if (result == null) {
      if (checkToken_IfStatement(position)) {
        result = evaluateIfStatementExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      IfStatementMap = initializeMap(IfStatementMap);
      IfStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ElseStatementMap;

  private EvaluationResult parseElseStatement(int position) {
    EvaluationResult result = (ElseStatementMap == null ? null : ElseStatementMap.get(position));
    if (result == null) {
      if (checkToken_ElseStatement(position)) {
        result = evaluateElseStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ElseStatementMap = initializeMap(ElseStatementMap);
      ElseStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> AssertStatementMap;

  private EvaluationResult parseAssertStatement(int position) {
    EvaluationResult result = (AssertStatementMap == null ? null : AssertStatementMap.get(position));
    if (result == null) {
      if (checkToken_AssertStatement(position)) {
        result = evaluateAssertStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      AssertStatementMap = initializeMap(AssertStatementMap);
      AssertStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> MessageAssertStatementMap;

  private EvaluationResult parseMessageAssertStatement(int position) {
    EvaluationResult result = (MessageAssertStatementMap == null ? null : MessageAssertStatementMap.get(position));
    if (result == null) {
      if (checkToken_MessageAssertStatement(position)) {
        result = evaluateMessageAssertStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      MessageAssertStatementMap = initializeMap(MessageAssertStatementMap);
      MessageAssertStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SimpleAssertStatementMap;

  private EvaluationResult parseSimpleAssertStatement(int position) {
    EvaluationResult result = (SimpleAssertStatementMap == null ? null : SimpleAssertStatementMap.get(position));
    if (result == null) {
      if (checkToken_SimpleAssertStatement(position)) {
        result = evaluateSimpleAssertStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      SimpleAssertStatementMap = initializeMap(SimpleAssertStatementMap);
      SimpleAssertStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SwitchStatementMap;

  private EvaluationResult parseSwitchStatement(int position) {
    EvaluationResult result = (SwitchStatementMap == null ? null : SwitchStatementMap.get(position));
    if (result == null) {
      if (checkToken_SwitchStatement(position)) {
        result = evaluateSwitchStatementExpression_2(position);
      } else {
        result = EvaluationResult.failure;
      }
      SwitchStatementMap = initializeMap(SwitchStatementMap);
      SwitchStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SwitchBlockStatementGroupMap;

  private EvaluationResult parseSwitchBlockStatementGroup(int position) {
    EvaluationResult result = (SwitchBlockStatementGroupMap == null
                               ? null
                               : SwitchBlockStatementGroupMap.get(position));
    if (result == null) {
      if (checkToken_SwitchBlockStatementGroup(position)) {
        result = evaluateSwitchBlockStatementGroupExpression_2(position);
      } else {
        result = EvaluationResult.failure;
      }
      SwitchBlockStatementGroupMap = initializeMap(SwitchBlockStatementGroupMap);
      SwitchBlockStatementGroupMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SwitchLabelMap;

  private EvaluationResult parseSwitchLabel(int position) {
    EvaluationResult result = (SwitchLabelMap == null ? null : SwitchLabelMap.get(position));
    if (result == null) {
      if (checkToken_SwitchLabel(position)) {
        result = evaluateSwitchLabelExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      SwitchLabelMap = initializeMap(SwitchLabelMap);
      SwitchLabelMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> CaseSwitchLabelMap;

  private EvaluationResult parseCaseSwitchLabel(int position) {
    EvaluationResult result = (CaseSwitchLabelMap == null ? null : CaseSwitchLabelMap.get(position));
    if (result == null) {
      if (checkToken_CaseSwitchLabel(position)) {
        result = evaluateCaseSwitchLabelExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      CaseSwitchLabelMap = initializeMap(CaseSwitchLabelMap);
      CaseSwitchLabelMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> DefaultSwitchLabelMap;

  private EvaluationResult parseDefaultSwitchLabel(int position) {
    EvaluationResult result = (DefaultSwitchLabelMap == null ? null : DefaultSwitchLabelMap.get(position));
    if (result == null) {
      if (checkToken_DefaultSwitchLabel(position)) {
        result = evaluateDefaultSwitchLabelExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      DefaultSwitchLabelMap = initializeMap(DefaultSwitchLabelMap);
      DefaultSwitchLabelMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> WhileStatementMap;

  private EvaluationResult parseWhileStatement(int position) {
    EvaluationResult result = (WhileStatementMap == null ? null : WhileStatementMap.get(position));
    if (result == null) {
      if (checkToken_WhileStatement(position)) {
        result = evaluateWhileStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      WhileStatementMap = initializeMap(WhileStatementMap);
      WhileStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> DoStatementMap;

  private EvaluationResult parseDoStatement(int position) {
    EvaluationResult result = (DoStatementMap == null ? null : DoStatementMap.get(position));
    if (result == null) {
      if (checkToken_DoStatement(position)) {
        result = evaluateDoStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      DoStatementMap = initializeMap(DoStatementMap);
      DoStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ForStatementMap;

  private EvaluationResult parseForStatement(int position) {
    EvaluationResult result = (ForStatementMap == null ? null : ForStatementMap.get(position));
    if (result == null) {
      if (checkToken_ForStatement(position)) {
        result = evaluateForStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ForStatementMap = initializeMap(ForStatementMap);
      ForStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> BasicForStatementMap;

  private EvaluationResult parseBasicForStatement(int position) {
    EvaluationResult result = (BasicForStatementMap == null ? null : BasicForStatementMap.get(position));
    if (result == null) {
      if (checkToken_BasicForStatement(position)) {
        result = evaluateBasicForStatementExpression_3(position);
      } else {
        result = EvaluationResult.failure;
      }
      BasicForStatementMap = initializeMap(BasicForStatementMap);
      BasicForStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ForInitializerMap;

  private EvaluationResult parseForInitializer(int position) {
    EvaluationResult result = (ForInitializerMap == null ? null : ForInitializerMap.get(position));
    if (result == null) {
      if (checkToken_ForInitializer(position)) {
        result = evaluateForInitializerExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ForInitializerMap = initializeMap(ForInitializerMap);
      ForInitializerMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> DelimitedExpressionListMap;

  private EvaluationResult parseDelimitedExpressionList(int position) {
    EvaluationResult result = (DelimitedExpressionListMap == null ? null : DelimitedExpressionListMap.get(position));
    if (result == null) {
      if (checkToken_DelimitedExpressionList(position)) {
        result = evaluateArgumentsExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      DelimitedExpressionListMap = initializeMap(DelimitedExpressionListMap);
      DelimitedExpressionListMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ForUpdateMap;

  private EvaluationResult parseForUpdate(int position) {
    EvaluationResult result = (ForUpdateMap == null ? null : ForUpdateMap.get(position));
    if (result == null) {
      if (checkToken_ForUpdate(position)) {
        result = evaluateArgumentsExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ForUpdateMap = initializeMap(ForUpdateMap);
      ForUpdateMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> EnhancedForStatementMap;

  private EvaluationResult parseEnhancedForStatement(int position) {
    EvaluationResult result = (EnhancedForStatementMap == null ? null : EnhancedForStatementMap.get(position));
    if (result == null) {
      if (checkToken_EnhancedForStatement(position)) {
        result = evaluateEnhancedForStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      EnhancedForStatementMap = initializeMap(EnhancedForStatementMap);
      EnhancedForStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> BreakStatementMap;

  private EvaluationResult parseBreakStatement(int position) {
    EvaluationResult result = (BreakStatementMap == null ? null : BreakStatementMap.get(position));
    if (result == null) {
      if (checkToken_BreakStatement(position)) {
        result = evaluateBreakStatementExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      BreakStatementMap = initializeMap(BreakStatementMap);
      BreakStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ContinueStatementMap;

  private EvaluationResult parseContinueStatement(int position) {
    EvaluationResult result = (ContinueStatementMap == null ? null : ContinueStatementMap.get(position));
    if (result == null) {
      if (checkToken_ContinueStatement(position)) {
        result = evaluateContinueStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ContinueStatementMap = initializeMap(ContinueStatementMap);
      ContinueStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ReturnStatementMap;

  private EvaluationResult parseReturnStatement(int position) {
    EvaluationResult result = (ReturnStatementMap == null ? null : ReturnStatementMap.get(position));
    if (result == null) {
      if (checkToken_ReturnStatement(position)) {
        result = evaluateReturnStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ReturnStatementMap = initializeMap(ReturnStatementMap);
      ReturnStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ThrowStatementMap;

  private EvaluationResult parseThrowStatement(int position) {
    EvaluationResult result = (ThrowStatementMap == null ? null : ThrowStatementMap.get(position));
    if (result == null) {
      if (checkToken_ThrowStatement(position)) {
        result = evaluateThrowStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ThrowStatementMap = initializeMap(ThrowStatementMap);
      ThrowStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SynchronizedStatementMap;

  private EvaluationResult parseSynchronizedStatement(int position) {
    EvaluationResult result = (SynchronizedStatementMap == null ? null : SynchronizedStatementMap.get(position));
    if (result == null) {
      if (checkToken_SynchronizedStatement(position)) {
        result = evaluateSynchronizedStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      SynchronizedStatementMap = initializeMap(SynchronizedStatementMap);
      SynchronizedStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TryStatementMap;

  private EvaluationResult parseTryStatement(int position) {
    EvaluationResult result = (TryStatementMap == null ? null : TryStatementMap.get(position));
    if (result == null) {
      if (checkToken_TryStatement(position)) {
        result = evaluateTryStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      TryStatementMap = initializeMap(TryStatementMap);
      TryStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TryStatementWithFinallyMap;

  private EvaluationResult parseTryStatementWithFinally(int position) {
    EvaluationResult result = (TryStatementWithFinallyMap == null ? null : TryStatementWithFinallyMap.get(position));
    if (result == null) {
      if (checkToken_TryStatementWithFinally(position)) {
        result = evaluateTryStatementWithFinallyExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      TryStatementWithFinallyMap = initializeMap(TryStatementWithFinallyMap);
      TryStatementWithFinallyMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TryStatementWithoutFinallyMap;

  private EvaluationResult parseTryStatementWithoutFinally(int position) {
    EvaluationResult result = (TryStatementWithoutFinallyMap == null
                               ? null
                               : TryStatementWithoutFinallyMap.get(position));
    if (result == null) {
      if (checkToken_TryStatementWithoutFinally(position)) {
        result = evaluateTryStatementWithoutFinallyExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      TryStatementWithoutFinallyMap = initializeMap(TryStatementWithoutFinallyMap);
      TryStatementWithoutFinallyMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> CatchClauseMap;

  private EvaluationResult parseCatchClause(int position) {
    EvaluationResult result = (CatchClauseMap == null ? null : CatchClauseMap.get(position));
    if (result == null) {
      if (checkToken_CatchClause(position)) {
        result = evaluateCatchClauseExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      CatchClauseMap = initializeMap(CatchClauseMap);
      CatchClauseMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ExpressionMap;

  private EvaluationResult parseExpression(int position) {
    EvaluationResult result = (ExpressionMap == null ? null : ExpressionMap.get(position));
    if (result == null) {
      if (checkToken_Expression(position)) {
        result = evaluateExpressionExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ExpressionMap = initializeMap(ExpressionMap);
      ExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> AssignmentOperatorMap;

  private EvaluationResult parseAssignmentOperator(int position) {
    EvaluationResult result = (AssignmentOperatorMap == null ? null : AssignmentOperatorMap.get(position));
    if (result == null) {
      if (checkToken_AssignmentOperator(position)) {
        result = evaluateAssignmentOperatorExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      AssignmentOperatorMap = initializeMap(AssignmentOperatorMap);
      AssignmentOperatorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> Expression1Map;

  private EvaluationResult parseExpression1(int position) {
    EvaluationResult result = (Expression1Map == null ? null : Expression1Map.get(position));
    if (result == null) {
      if (checkToken_Expression1(position)) {
        result = evaluateExpression1Expression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      Expression1Map = initializeMap(Expression1Map);
      Expression1Map.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TernaryExpressionMap;

  private EvaluationResult parseTernaryExpression(int position) {
    EvaluationResult result = (TernaryExpressionMap == null ? null : TernaryExpressionMap.get(position));
    if (result == null) {
      if (checkToken_TernaryExpression(position)) {
        result = evaluateTernaryExpressionExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      TernaryExpressionMap = initializeMap(TernaryExpressionMap);
      TernaryExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> Expression2Map;

  private EvaluationResult parseExpression2(int position) {
    EvaluationResult result = (Expression2Map == null ? null : Expression2Map.get(position));
    if (result == null) {
      if (checkToken_Expression2(position)) {
        result = evaluateExpression2Expression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      Expression2Map = initializeMap(Expression2Map);
      Expression2Map.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> BinaryExpressionMap;

  private EvaluationResult parseBinaryExpression(int position) {
    EvaluationResult result = (BinaryExpressionMap == null ? null : BinaryExpressionMap.get(position));
    if (result == null) {
      if (checkToken_BinaryExpression(position)) {
        result = evaluateBinaryExpressionExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      BinaryExpressionMap = initializeMap(BinaryExpressionMap);
      BinaryExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> BinaryExpressionRestMap;

  private EvaluationResult parseBinaryExpressionRest(int position) {
    EvaluationResult result = (BinaryExpressionRestMap == null ? null : BinaryExpressionRestMap.get(position));
    if (result == null) {
      if (checkToken_BinaryExpressionRest(position)) {
        result = evaluateBinaryExpressionRestExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      BinaryExpressionRestMap = initializeMap(BinaryExpressionRestMap);
      BinaryExpressionRestMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> InfixOperatorBinaryExpressionRestMap;

  private EvaluationResult parseInfixOperatorBinaryExpressionRest(int position) {
    EvaluationResult result = (InfixOperatorBinaryExpressionRestMap == null
                               ? null
                               : InfixOperatorBinaryExpressionRestMap.get(position));
    if (result == null) {
      if (checkToken_InfixOperatorBinaryExpressionRest(position)) {
        result = evaluateInfixOperatorBinaryExpressionRestExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      InfixOperatorBinaryExpressionRestMap = initializeMap(InfixOperatorBinaryExpressionRestMap);
      InfixOperatorBinaryExpressionRestMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> InstanceofOperatorBinaryExpressionRestMap;

  private EvaluationResult parseInstanceofOperatorBinaryExpressionRest(int position) {
    EvaluationResult result = (InstanceofOperatorBinaryExpressionRestMap == null
                               ? null
                               : InstanceofOperatorBinaryExpressionRestMap.get(position));
    if (result == null) {
      if (checkToken_InstanceofOperatorBinaryExpressionRest(position)) {
        result = evaluateInstanceofOperatorBinaryExpressionRestExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      InstanceofOperatorBinaryExpressionRestMap = initializeMap(InstanceofOperatorBinaryExpressionRestMap);
      InstanceofOperatorBinaryExpressionRestMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> InfixOperatorMap;

  private EvaluationResult parseInfixOperator(int position) {
    EvaluationResult result = (InfixOperatorMap == null ? null : InfixOperatorMap.get(position));
    if (result == null) {
      if (checkToken_InfixOperator(position)) {
        result = evaluateInfixOperatorExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      InfixOperatorMap = initializeMap(InfixOperatorMap);
      InfixOperatorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> UnsignedRightShiftMap;

  private EvaluationResult parseUnsignedRightShift(int position) {
    EvaluationResult result = (UnsignedRightShiftMap == null ? null : UnsignedRightShiftMap.get(position));
    if (result == null) {
      if (checkToken_UnsignedRightShift(position)) {
        result = evaluateUnsignedRightShiftExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      UnsignedRightShiftMap = initializeMap(UnsignedRightShiftMap);
      UnsignedRightShiftMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SignedRightShiftMap;

  private EvaluationResult parseSignedRightShift(int position) {
    EvaluationResult result = (SignedRightShiftMap == null ? null : SignedRightShiftMap.get(position));
    if (result == null) {
      if (checkToken_SignedRightShift(position)) {
        result = evaluateSignedRightShiftExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      SignedRightShiftMap = initializeMap(SignedRightShiftMap);
      SignedRightShiftMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> Expression3Map;

  private EvaluationResult parseExpression3(int position) {
    EvaluationResult result = (Expression3Map == null ? null : Expression3Map.get(position));
    if (result == null) {
      if (checkToken_Expression3(position)) {
        result = evaluateExpression3Expression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      Expression3Map = initializeMap(Expression3Map);
      Expression3Map.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> PrefixExpressionMap;

  private EvaluationResult parsePrefixExpression(int position) {
    EvaluationResult result = (PrefixExpressionMap == null ? null : PrefixExpressionMap.get(position));
    if (result == null) {
      if (checkToken_PrefixExpression(position)) {
        result = evaluatePrefixExpressionExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      PrefixExpressionMap = initializeMap(PrefixExpressionMap);
      PrefixExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> PrefixOperatorMap;

  private EvaluationResult parsePrefixOperator(int position) {
    EvaluationResult result = (PrefixOperatorMap == null ? null : PrefixOperatorMap.get(position));
    if (result == null) {
      if (checkToken_PrefixOperator(position)) {
        result = evaluatePrefixOperatorExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      PrefixOperatorMap = initializeMap(PrefixOperatorMap);
      PrefixOperatorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> PossibleCastExpressionMap;

  private EvaluationResult parsePossibleCastExpression(int position) {
    EvaluationResult result = (PossibleCastExpressionMap == null ? null : PossibleCastExpressionMap.get(position));
    if (result == null) {
      if (checkToken_PossibleCastExpression(position)) {
        result = evaluatePossibleCastExpressionExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      PossibleCastExpressionMap = initializeMap(PossibleCastExpressionMap);
      PossibleCastExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> PossibleCastExpression_TypeMap;

  private EvaluationResult parsePossibleCastExpression_Type(int position) {
    EvaluationResult result = (PossibleCastExpression_TypeMap == null
                               ? null
                               : PossibleCastExpression_TypeMap.get(position));
    if (result == null) {
      if (checkToken_PossibleCastExpression_Type(position)) {
        result = evaluatePossibleCastExpression_TypeExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      PossibleCastExpression_TypeMap = initializeMap(PossibleCastExpression_TypeMap);
      PossibleCastExpression_TypeMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> PossibleCastExpression_ExpressionMap;

  private EvaluationResult parsePossibleCastExpression_Expression(int position) {
    EvaluationResult result = (PossibleCastExpression_ExpressionMap == null
                               ? null
                               : PossibleCastExpression_ExpressionMap.get(position));
    if (result == null) {
      if (checkToken_PossibleCastExpression_Expression(position)) {
        result = evaluatePossibleCastExpression_ExpressionExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      PossibleCastExpression_ExpressionMap = initializeMap(PossibleCastExpression_ExpressionMap);
      PossibleCastExpression_ExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> PrimaryExpressionMap;

  private EvaluationResult parsePrimaryExpression(int position) {
    EvaluationResult result = (PrimaryExpressionMap == null ? null : PrimaryExpressionMap.get(position));
    if (result == null) {
      if (checkToken_PrimaryExpression(position)) {
        result = evaluatePrimaryExpressionExpression_2(position);
      } else {
        result = EvaluationResult.failure;
      }
      PrimaryExpressionMap = initializeMap(PrimaryExpressionMap);
      PrimaryExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> PostfixOperatorMap;

  private EvaluationResult parsePostfixOperator(int position) {
    EvaluationResult result = (PostfixOperatorMap == null ? null : PostfixOperatorMap.get(position));
    if (result == null) {
      if (checkToken_PostfixOperator(position)) {
        result = evaluatePostfixOperatorExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      PostfixOperatorMap = initializeMap(PostfixOperatorMap);
      PostfixOperatorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ValueExpressionMap;

  private EvaluationResult parseValueExpression(int position) {
    EvaluationResult result = (ValueExpressionMap == null ? null : ValueExpressionMap.get(position));
    if (result == null) {
      if (checkToken_ValueExpression(position)) {
        result = evaluateValueExpressionExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      ValueExpressionMap = initializeMap(ValueExpressionMap);
      ValueExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ClassAccessMap;

  private EvaluationResult parseClassAccess(int position) {
    EvaluationResult result = (ClassAccessMap == null ? null : ClassAccessMap.get(position));
    if (result == null) {
      if (checkToken_ClassAccess(position)) {
        result = evaluateClassAccessExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ClassAccessMap = initializeMap(ClassAccessMap);
      ClassAccessMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SelectorMap;

  private EvaluationResult parseSelector(int position) {
    EvaluationResult result = (SelectorMap == null ? null : SelectorMap.get(position));
    if (result == null) {
      if (checkToken_Selector(position)) {
        result = evaluateSelectorExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      SelectorMap = initializeMap(SelectorMap);
      SelectorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> DotSelectorMap;

  private EvaluationResult parseDotSelector(int position) {
    EvaluationResult result = (DotSelectorMap == null ? null : DotSelectorMap.get(position));
    if (result == null) {
      if (checkToken_DotSelector(position)) {
        result = evaluateDotSelectorExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      DotSelectorMap = initializeMap(DotSelectorMap);
      DotSelectorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ArraySelectorMap;

  private EvaluationResult parseArraySelector(int position) {
    EvaluationResult result = (ArraySelectorMap == null ? null : ArraySelectorMap.get(position));
    if (result == null) {
      if (checkToken_ArraySelector(position)) {
        result = evaluateArraySelectorExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ArraySelectorMap = initializeMap(ArraySelectorMap);
      ArraySelectorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ParenthesizedExpressionMap;

  private EvaluationResult parseParenthesizedExpression(int position) {
    EvaluationResult result = (ParenthesizedExpressionMap == null ? null : ParenthesizedExpressionMap.get(position));
    if (result == null) {
      if (checkToken_ParenthesizedExpression(position)) {
        result = evaluateParenthesizedExpressionExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ParenthesizedExpressionMap = initializeMap(ParenthesizedExpressionMap);
      ParenthesizedExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> MethodInvocationMap;

  private EvaluationResult parseMethodInvocation(int position) {
    EvaluationResult result = (MethodInvocationMap == null ? null : MethodInvocationMap.get(position));
    if (result == null) {
      if (checkToken_MethodInvocation(position)) {
        result = evaluateMethodInvocationExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      MethodInvocationMap = initializeMap(MethodInvocationMap);
      MethodInvocationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ThisConstructorInvocationMap;

  private EvaluationResult parseThisConstructorInvocation(int position) {
    EvaluationResult result = (ThisConstructorInvocationMap == null
                               ? null
                               : ThisConstructorInvocationMap.get(position));
    if (result == null) {
      if (checkToken_ThisConstructorInvocation(position)) {
        result = evaluateThisConstructorInvocationExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ThisConstructorInvocationMap = initializeMap(ThisConstructorInvocationMap);
      ThisConstructorInvocationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SuperConstructorInvocationMap;

  private EvaluationResult parseSuperConstructorInvocation(int position) {
    EvaluationResult result = (SuperConstructorInvocationMap == null
                               ? null
                               : SuperConstructorInvocationMap.get(position));
    if (result == null) {
      if (checkToken_SuperConstructorInvocation(position)) {
        result = evaluateSuperConstructorInvocationExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      SuperConstructorInvocationMap = initializeMap(SuperConstructorInvocationMap);
      SuperConstructorInvocationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> CreationExpressionMap;

  private EvaluationResult parseCreationExpression(int position) {
    EvaluationResult result = (CreationExpressionMap == null ? null : CreationExpressionMap.get(position));
    if (result == null) {
      if (checkToken_CreationExpression(position)) {
        result = evaluateCreationExpressionExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      CreationExpressionMap = initializeMap(CreationExpressionMap);
      CreationExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ObjectCreationExpressionMap;

  private EvaluationResult parseObjectCreationExpression(int position) {
    EvaluationResult result = (ObjectCreationExpressionMap == null ? null : ObjectCreationExpressionMap.get(position));
    if (result == null) {
      if (checkToken_ObjectCreationExpression(position)) {
        result = evaluateObjectCreationExpressionExpression_1(position);
      } else {
        result = EvaluationResult.failure;
      }
      ObjectCreationExpressionMap = initializeMap(ObjectCreationExpressionMap);
      ObjectCreationExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ArrayCreationExpressionMap;

  private EvaluationResult parseArrayCreationExpression(int position) {
    EvaluationResult result = (ArrayCreationExpressionMap == null ? null : ArrayCreationExpressionMap.get(position));
    if (result == null) {
      if (checkToken_ArrayCreationExpression(position)) {
        result = evaluateArrayCreationExpressionExpression_2(position);
      } else {
        result = EvaluationResult.failure;
      }
      ArrayCreationExpressionMap = initializeMap(ArrayCreationExpressionMap);
      ArrayCreationExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ArrayCreationTypeMap;

  private EvaluationResult parseArrayCreationType(int position) {
    EvaluationResult result = (ArrayCreationTypeMap == null ? null : ArrayCreationTypeMap.get(position));
    if (result == null) {
      if (checkToken_ArrayCreationType(position)) {
        result = evaluateArrayCreationTypeExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      ArrayCreationTypeMap = initializeMap(ArrayCreationTypeMap);
      ArrayCreationTypeMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> DimensionExpressionMap;

  private EvaluationResult parseDimensionExpression(int position) {
    EvaluationResult result = (DimensionExpressionMap == null ? null : DimensionExpressionMap.get(position));
    if (result == null) {
      if (checkToken_DimensionExpression(position)) {
        result = evaluateDimensionExpressionExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      DimensionExpressionMap = initializeMap(DimensionExpressionMap);
      DimensionExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ArrayInitializerMap;

  private EvaluationResult parseArrayInitializer(int position) {
    EvaluationResult result = (ArrayInitializerMap == null ? null : ArrayInitializerMap.get(position));
    if (result == null) {
      if (checkToken_ArrayInitializer(position)) {
        result = evaluateArrayInitializerExpression_2(position);
      } else {
        result = EvaluationResult.failure;
      }
      ArrayInitializerMap = initializeMap(ArrayInitializerMap);
      ArrayInitializerMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> VariableInitializerMap;

  private EvaluationResult parseVariableInitializer(int position) {
    EvaluationResult result = (VariableInitializerMap == null ? null : VariableInitializerMap.get(position));
    if (result == null) {
      if (checkToken_VariableInitializer(position)) {
        result = evaluateVariableInitializerExpression_0(position);
      } else {
        result = EvaluationResult.failure;
      }
      VariableInitializerMap = initializeMap(VariableInitializerMap);
      VariableInitializerMap.put(position, result);
    }
    return result;
  }

  protected abstract EvaluationResult anyToken(int position);
}