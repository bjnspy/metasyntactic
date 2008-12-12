package org.metasyntactic.automata.compiler.java.parser;

import java.util.*;
import org.metasyntactic.automata.compiler.framework.parsers.*;
import org.metasyntactic.automata.compiler.java.scanner.*;
import org.metasyntactic.automata.compiler.java.scanner.keywords.*;
import org.metasyntactic.automata.compiler.java.scanner.literals.*;
import org.metasyntactic.automata.compiler.java.scanner.operators.*;
import org.metasyntactic.automata.compiler.java.scanner.separators.*;
import static org.metasyntactic.automata.compiler.java.parser.Nodes.*;
import org.metasyntactic.automata.compiler.util.ArrayDelimitedList;
import org.metasyntactic.automata.compiler.util.DelimitedList;

public abstract class AbstractJavaGeneratedParser {
  protected static class EvaluationResult<T> {
    public static final EvaluationResult failure = new EvaluationResult(false, 0);

    public static <T> EvaluationResult<T> failure() { return failure; }
    public final boolean succeeded;
    public final int position;
    public final T value;

    public EvaluationResult(boolean succeeded, int position, T value) {
      this.succeeded = succeeded;
      this.position = position;
      this.value = value;
    }

    public EvaluationResult(boolean succeeded, int position) {
      this(succeeded, position, null);
    }

     public String toString() {
      if (succeeded) {
        return "(Result succeeded " + position + (value == null ? ")" : value + ")");
      } else {
        return "(Result failed)";
      }
    }
  }

  private static <T> Map<Integer, EvaluationResult<? extends T>> initializeMap(Map<Integer,EvaluationResult<? extends T>> map) {
    if (map == null) {
      map = new HashMap<Integer,EvaluationResult<? extends T>>();
    }

    return map;
  }
  protected final List<SourceToken<Token>> tokens;

  protected AbstractJavaGeneratedParser(List<SourceToken<Token>> tokens) {
    this.tokens = new ArrayList<SourceToken<Token>>(tokens);
  }

  private static <T> List<T> trimList(ArrayList<T> values) {
    if (values == null || values.isEmpty()) {
      return Collections.emptyList();
    } else if (values.size() == 1) {
      return Collections.singletonList(values.get(0));
    } else {
      values.trimToSize();
      return values;
    }
  }

  private <T> ArrayList<T> addValue(ArrayList<T> values, T value) {
    if (value != null) {
      if (values == null) {
        values = new ArrayList<T>();
      }

      values.add(value);
    }

    return values;
  }



  public ICompilationUnitNode parse() {
    EvaluationResult<? extends ICompilationUnitNode> result = parseCompilationUnit(0);
    if (result.succeeded) {
      return result.value;
    } else {
      return null;
    }
  }
  private boolean checkToken_PackageDeclaration(int position) {
    if (position < tokens.size()) {
      Token token = tokens.get(position).getToken();
      // Fall through any matching cases
      switch (token.getType()) {
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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
        default: return false;
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

  private EvaluationResult<IAbstractKeywordTokenNode> boxAbstractKeywordToken(EvaluationResult<? extends SourceToken<AbstractKeywordToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IAbstractKeywordTokenNode>(true, result.position, new AbstractKeywordTokenNode(result.value));
  }
  private EvaluationResult<IAndEqualsOperatorTokenNode> boxAndEqualsOperatorToken(EvaluationResult<? extends SourceToken<AndEqualsOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IAndEqualsOperatorTokenNode>(true, result.position, new AndEqualsOperatorTokenNode(result.value));
  }
  private EvaluationResult<IBitwiseAndOperatorTokenNode> boxBitwiseAndOperatorToken(EvaluationResult<? extends SourceToken<BitwiseAndOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IBitwiseAndOperatorTokenNode>(true, result.position, new BitwiseAndOperatorTokenNode(result.value));
  }
  private EvaluationResult<IBitwiseExclusiveOrOperatorTokenNode> boxBitwiseExclusiveOrOperatorToken(EvaluationResult<? extends SourceToken<BitwiseExclusiveOrOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IBitwiseExclusiveOrOperatorTokenNode>(true, result.position, new BitwiseExclusiveOrOperatorTokenNode(result.value));
  }
  private EvaluationResult<IBitwiseNotOperatorTokenNode> boxBitwiseNotOperatorToken(EvaluationResult<? extends SourceToken<BitwiseNotOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IBitwiseNotOperatorTokenNode>(true, result.position, new BitwiseNotOperatorTokenNode(result.value));
  }
  private EvaluationResult<IBitwiseOrOperatorTokenNode> boxBitwiseOrOperatorToken(EvaluationResult<? extends SourceToken<BitwiseOrOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IBitwiseOrOperatorTokenNode>(true, result.position, new BitwiseOrOperatorTokenNode(result.value));
  }
  private EvaluationResult<IBitwiseRightShiftEqualsOperatorTokenNode> boxBitwiseRightShiftEqualsOperatorToken(EvaluationResult<? extends SourceToken<BitwiseRightShiftEqualsOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IBitwiseRightShiftEqualsOperatorTokenNode>(true, result.position, new BitwiseRightShiftEqualsOperatorTokenNode(result.value));
  }
  private EvaluationResult<IBooleanKeywordTokenNode> boxBooleanKeywordToken(EvaluationResult<? extends SourceToken<BooleanKeywordToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IBooleanKeywordTokenNode>(true, result.position, new BooleanKeywordTokenNode(result.value));
  }
  private EvaluationResult<IByteKeywordTokenNode> boxByteKeywordToken(EvaluationResult<? extends SourceToken<ByteKeywordToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IByteKeywordTokenNode>(true, result.position, new ByteKeywordTokenNode(result.value));
  }
  private EvaluationResult<ICharKeywordTokenNode> boxCharKeywordToken(EvaluationResult<? extends SourceToken<CharKeywordToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<ICharKeywordTokenNode>(true, result.position, new CharKeywordTokenNode(result.value));
  }
  private EvaluationResult<IDecrementOperatorTokenNode> boxDecrementOperatorToken(EvaluationResult<? extends SourceToken<DecrementOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IDecrementOperatorTokenNode>(true, result.position, new DecrementOperatorTokenNode(result.value));
  }
  private EvaluationResult<IDivideEqualsOperatorTokenNode> boxDivideEqualsOperatorToken(EvaluationResult<? extends SourceToken<DivideEqualsOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IDivideEqualsOperatorTokenNode>(true, result.position, new DivideEqualsOperatorTokenNode(result.value));
  }
  private EvaluationResult<IDivideOperatorTokenNode> boxDivideOperatorToken(EvaluationResult<? extends SourceToken<DivideOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IDivideOperatorTokenNode>(true, result.position, new DivideOperatorTokenNode(result.value));
  }
  private EvaluationResult<IDoubleKeywordTokenNode> boxDoubleKeywordToken(EvaluationResult<? extends SourceToken<DoubleKeywordToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IDoubleKeywordTokenNode>(true, result.position, new DoubleKeywordTokenNode(result.value));
  }
  private EvaluationResult<IEqualsEqualsOperatorTokenNode> boxEqualsEqualsOperatorToken(EvaluationResult<? extends SourceToken<EqualsEqualsOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IEqualsEqualsOperatorTokenNode>(true, result.position, new EqualsEqualsOperatorTokenNode(result.value));
  }
  private EvaluationResult<IEqualsOperatorTokenNode> boxEqualsOperatorToken(EvaluationResult<? extends SourceToken<EqualsOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IEqualsOperatorTokenNode>(true, result.position, new EqualsOperatorTokenNode(result.value));
  }
  private EvaluationResult<IExclusiveOrEqualsOperatorTokenNode> boxExclusiveOrEqualsOperatorToken(EvaluationResult<? extends SourceToken<ExclusiveOrEqualsOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IExclusiveOrEqualsOperatorTokenNode>(true, result.position, new ExclusiveOrEqualsOperatorTokenNode(result.value));
  }
  private EvaluationResult<IFinalKeywordTokenNode> boxFinalKeywordToken(EvaluationResult<? extends SourceToken<FinalKeywordToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IFinalKeywordTokenNode>(true, result.position, new FinalKeywordTokenNode(result.value));
  }
  private EvaluationResult<IFloatKeywordTokenNode> boxFloatKeywordToken(EvaluationResult<? extends SourceToken<FloatKeywordToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IFloatKeywordTokenNode>(true, result.position, new FloatKeywordTokenNode(result.value));
  }
  private EvaluationResult<IGreaterThanOperatorTokenNode> boxGreaterThanOperatorToken(EvaluationResult<? extends SourceToken<GreaterThanOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IGreaterThanOperatorTokenNode>(true, result.position, new GreaterThanOperatorTokenNode(result.value));
  }
  private EvaluationResult<IGreaterThanOrEqualsOperatorTokenNode> boxGreaterThanOrEqualsOperatorToken(EvaluationResult<? extends SourceToken<GreaterThanOrEqualsOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IGreaterThanOrEqualsOperatorTokenNode>(true, result.position, new GreaterThanOrEqualsOperatorTokenNode(result.value));
  }
  private EvaluationResult<IIdentifierTokenNode> boxIdentifierToken(EvaluationResult<? extends SourceToken<IdentifierToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IIdentifierTokenNode>(true, result.position, new IdentifierTokenNode(result.value));
  }
  private EvaluationResult<IIncrementOperatorTokenNode> boxIncrementOperatorToken(EvaluationResult<? extends SourceToken<IncrementOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IIncrementOperatorTokenNode>(true, result.position, new IncrementOperatorTokenNode(result.value));
  }
  private EvaluationResult<IIntKeywordTokenNode> boxIntKeywordToken(EvaluationResult<? extends SourceToken<IntKeywordToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IIntKeywordTokenNode>(true, result.position, new IntKeywordTokenNode(result.value));
  }
  private EvaluationResult<ILeftShiftEqualsOperatorTokenNode> boxLeftShiftEqualsOperatorToken(EvaluationResult<? extends SourceToken<LeftShiftEqualsOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<ILeftShiftEqualsOperatorTokenNode>(true, result.position, new LeftShiftEqualsOperatorTokenNode(result.value));
  }
  private EvaluationResult<ILeftShiftOperatorTokenNode> boxLeftShiftOperatorToken(EvaluationResult<? extends SourceToken<LeftShiftOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<ILeftShiftOperatorTokenNode>(true, result.position, new LeftShiftOperatorTokenNode(result.value));
  }
  private EvaluationResult<ILessThanOperatorTokenNode> boxLessThanOperatorToken(EvaluationResult<? extends SourceToken<LessThanOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<ILessThanOperatorTokenNode>(true, result.position, new LessThanOperatorTokenNode(result.value));
  }
  private EvaluationResult<ILessThanOrEqualsOperatorTokenNode> boxLessThanOrEqualsOperatorToken(EvaluationResult<? extends SourceToken<LessThanOrEqualsOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<ILessThanOrEqualsOperatorTokenNode>(true, result.position, new LessThanOrEqualsOperatorTokenNode(result.value));
  }
  private EvaluationResult<ILiteralTokenNode> boxLiteralToken(EvaluationResult<? extends SourceToken<LiteralToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<ILiteralTokenNode>(true, result.position, new LiteralTokenNode(result.value));
  }
  private EvaluationResult<ILogicalAndOperatorTokenNode> boxLogicalAndOperatorToken(EvaluationResult<? extends SourceToken<LogicalAndOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<ILogicalAndOperatorTokenNode>(true, result.position, new LogicalAndOperatorTokenNode(result.value));
  }
  private EvaluationResult<ILogicalNotOperatorTokenNode> boxLogicalNotOperatorToken(EvaluationResult<? extends SourceToken<LogicalNotOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<ILogicalNotOperatorTokenNode>(true, result.position, new LogicalNotOperatorTokenNode(result.value));
  }
  private EvaluationResult<ILogicalOrOperatorTokenNode> boxLogicalOrOperatorToken(EvaluationResult<? extends SourceToken<LogicalOrOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<ILogicalOrOperatorTokenNode>(true, result.position, new LogicalOrOperatorTokenNode(result.value));
  }
  private EvaluationResult<ILongKeywordTokenNode> boxLongKeywordToken(EvaluationResult<? extends SourceToken<LongKeywordToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<ILongKeywordTokenNode>(true, result.position, new LongKeywordTokenNode(result.value));
  }
  private EvaluationResult<IMinusEqualsOperatorTokenNode> boxMinusEqualsOperatorToken(EvaluationResult<? extends SourceToken<MinusEqualsOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IMinusEqualsOperatorTokenNode>(true, result.position, new MinusEqualsOperatorTokenNode(result.value));
  }
  private EvaluationResult<IMinusOperatorTokenNode> boxMinusOperatorToken(EvaluationResult<? extends SourceToken<MinusOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IMinusOperatorTokenNode>(true, result.position, new MinusOperatorTokenNode(result.value));
  }
  private EvaluationResult<IModulusEqualsOperatorTokenNode> boxModulusEqualsOperatorToken(EvaluationResult<? extends SourceToken<ModulusEqualsOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IModulusEqualsOperatorTokenNode>(true, result.position, new ModulusEqualsOperatorTokenNode(result.value));
  }
  private EvaluationResult<IModulusOperatorTokenNode> boxModulusOperatorToken(EvaluationResult<? extends SourceToken<ModulusOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IModulusOperatorTokenNode>(true, result.position, new ModulusOperatorTokenNode(result.value));
  }
  private EvaluationResult<INativeKeywordTokenNode> boxNativeKeywordToken(EvaluationResult<? extends SourceToken<NativeKeywordToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<INativeKeywordTokenNode>(true, result.position, new NativeKeywordTokenNode(result.value));
  }
  private EvaluationResult<INotEqualsOperatorTokenNode> boxNotEqualsOperatorToken(EvaluationResult<? extends SourceToken<NotEqualsOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<INotEqualsOperatorTokenNode>(true, result.position, new NotEqualsOperatorTokenNode(result.value));
  }
  private EvaluationResult<IOrEqualsOperatorTokenNode> boxOrEqualsOperatorToken(EvaluationResult<? extends SourceToken<OrEqualsOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IOrEqualsOperatorTokenNode>(true, result.position, new OrEqualsOperatorTokenNode(result.value));
  }
  private EvaluationResult<IPlusEqualsOperatorTokenNode> boxPlusEqualsOperatorToken(EvaluationResult<? extends SourceToken<PlusEqualsOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IPlusEqualsOperatorTokenNode>(true, result.position, new PlusEqualsOperatorTokenNode(result.value));
  }
  private EvaluationResult<IPlusOperatorTokenNode> boxPlusOperatorToken(EvaluationResult<? extends SourceToken<PlusOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IPlusOperatorTokenNode>(true, result.position, new PlusOperatorTokenNode(result.value));
  }
  private EvaluationResult<IPrivateKeywordTokenNode> boxPrivateKeywordToken(EvaluationResult<? extends SourceToken<PrivateKeywordToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IPrivateKeywordTokenNode>(true, result.position, new PrivateKeywordTokenNode(result.value));
  }
  private EvaluationResult<IProtectedKeywordTokenNode> boxProtectedKeywordToken(EvaluationResult<? extends SourceToken<ProtectedKeywordToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IProtectedKeywordTokenNode>(true, result.position, new ProtectedKeywordTokenNode(result.value));
  }
  private EvaluationResult<IPublicKeywordTokenNode> boxPublicKeywordToken(EvaluationResult<? extends SourceToken<PublicKeywordToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IPublicKeywordTokenNode>(true, result.position, new PublicKeywordTokenNode(result.value));
  }
  private EvaluationResult<IQuestionMarkOperatorTokenNode> boxQuestionMarkOperatorToken(EvaluationResult<? extends SourceToken<QuestionMarkOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IQuestionMarkOperatorTokenNode>(true, result.position, new QuestionMarkOperatorTokenNode(result.value));
  }
  private EvaluationResult<IRightShiftEqualsOperatorTokenNode> boxRightShiftEqualsOperatorToken(EvaluationResult<? extends SourceToken<RightShiftEqualsOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IRightShiftEqualsOperatorTokenNode>(true, result.position, new RightShiftEqualsOperatorTokenNode(result.value));
  }
  private EvaluationResult<ISemicolonSeparatorTokenNode> boxSemicolonSeparatorToken(EvaluationResult<? extends SourceToken<SemicolonSeparatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<ISemicolonSeparatorTokenNode>(true, result.position, new SemicolonSeparatorTokenNode(result.value));
  }
  private EvaluationResult<IShortKeywordTokenNode> boxShortKeywordToken(EvaluationResult<? extends SourceToken<ShortKeywordToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IShortKeywordTokenNode>(true, result.position, new ShortKeywordTokenNode(result.value));
  }
  private EvaluationResult<IStaticKeywordTokenNode> boxStaticKeywordToken(EvaluationResult<? extends SourceToken<StaticKeywordToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IStaticKeywordTokenNode>(true, result.position, new StaticKeywordTokenNode(result.value));
  }
  private EvaluationResult<IStrictfpKeywordTokenNode> boxStrictfpKeywordToken(EvaluationResult<? extends SourceToken<StrictfpKeywordToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IStrictfpKeywordTokenNode>(true, result.position, new StrictfpKeywordTokenNode(result.value));
  }
  private EvaluationResult<ISuperKeywordTokenNode> boxSuperKeywordToken(EvaluationResult<? extends SourceToken<SuperKeywordToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<ISuperKeywordTokenNode>(true, result.position, new SuperKeywordTokenNode(result.value));
  }
  private EvaluationResult<ISynchronizedKeywordTokenNode> boxSynchronizedKeywordToken(EvaluationResult<? extends SourceToken<SynchronizedKeywordToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<ISynchronizedKeywordTokenNode>(true, result.position, new SynchronizedKeywordTokenNode(result.value));
  }
  private EvaluationResult<IThisKeywordTokenNode> boxThisKeywordToken(EvaluationResult<? extends SourceToken<ThisKeywordToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IThisKeywordTokenNode>(true, result.position, new ThisKeywordTokenNode(result.value));
  }
  private EvaluationResult<ITimesEqualsOperatorTokenNode> boxTimesEqualsOperatorToken(EvaluationResult<? extends SourceToken<TimesEqualsOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<ITimesEqualsOperatorTokenNode>(true, result.position, new TimesEqualsOperatorTokenNode(result.value));
  }
  private EvaluationResult<ITimesOperatorTokenNode> boxTimesOperatorToken(EvaluationResult<? extends SourceToken<TimesOperatorToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<ITimesOperatorTokenNode>(true, result.position, new TimesOperatorTokenNode(result.value));
  }
  private EvaluationResult<ITransientKeywordTokenNode> boxTransientKeywordToken(EvaluationResult<? extends SourceToken<TransientKeywordToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<ITransientKeywordTokenNode>(true, result.position, new TransientKeywordTokenNode(result.value));
  }
  private EvaluationResult<IVoidKeywordTokenNode> boxVoidKeywordToken(EvaluationResult<? extends SourceToken<VoidKeywordToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IVoidKeywordTokenNode>(true, result.position, new VoidKeywordTokenNode(result.value));
  }
  private EvaluationResult<IVolatileKeywordTokenNode> boxVolatileKeywordToken(EvaluationResult<? extends SourceToken<VolatileKeywordToken>> result) {
    if (!result.succeeded) { return EvaluationResult.failure(); }
    return new EvaluationResult<IVolatileKeywordTokenNode>(true, result.position, new VolatileKeywordTokenNode(result.value));
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IPackageDeclarationNode> evaluateCompilationUnitExpression_0(int position) {
    EvaluationResult<? extends IPackageDeclarationNode> result;
    if ((result = parsePackageDeclaration(position)).succeeded) { return result; }
    return new EvaluationResult<IPackageDeclarationNode>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends List<IImportDeclarationNode>> evaluateCompilationUnitExpression_1(int position) {
    int currentPosition = position;
    ArrayList<IImportDeclarationNode> values = null;
    while (true) {
      EvaluationResult<? extends IImportDeclarationNode> result = parseImportDeclaration(currentPosition);
      if (result.succeeded) {
        currentPosition = result.position;
        values = addValue(values, result.value);
      } else {
        return new EvaluationResult<List<IImportDeclarationNode>>(true, currentPosition, trimList(values));
      }
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends List<ITypeDeclarationNode>> evaluateCompilationUnitExpression_2(int position) {
    int currentPosition = position;
    ArrayList<ITypeDeclarationNode> values = null;
    while (true) {
      EvaluationResult<? extends ITypeDeclarationNode> result = parseTypeDeclaration(currentPosition);
      if (result.succeeded) {
        currentPosition = result.position;
        values = addValue(values, result.value);
      } else {
        return new EvaluationResult<List<ITypeDeclarationNode>>(true, currentPosition, trimList(values));
      }
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends Object> evaluateCompilationUnitExpression_3(int position) {
    EvaluationResult<? extends Object> result = anyToken(position);
    return new EvaluationResult<Object>(!result.succeeded, position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ICompilationUnitNode> evaluateCompilationUnitExpression_4(int position) {
    EvaluationResult<? extends IPackageDeclarationNode> result_0 = evaluateCompilationUnitExpression_0(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends List<IImportDeclarationNode>> result_1 = evaluateCompilationUnitExpression_1(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends List<ITypeDeclarationNode>> result_2 = evaluateCompilationUnitExpression_2(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends Object> result_3 = evaluateCompilationUnitExpression_3(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    ICompilationUnitNode node = new CompilationUnitNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<ICompilationUnitNode>(true, result_3.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends List<IAnnotationNode>> evaluatePackageDeclarationExpression_0(int position) {
    int currentPosition = position;
    ArrayList<IAnnotationNode> values = null;
    while (true) {
      EvaluationResult<? extends IAnnotationNode> result = parseAnnotation(currentPosition);
      if (result.succeeded) {
        currentPosition = result.position;
        values = addValue(values, result.value);
      } else {
        return new EvaluationResult<List<IAnnotationNode>>(true, currentPosition, trimList(values));
      }
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<PackageKeywordToken>> evaluatePackageKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (PackageKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<PackageKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<SemicolonSeparatorToken>> evaluateSemicolonSeparatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (SemicolonSeparatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<SemicolonSeparatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IPackageDeclarationNode> evaluatePackageDeclarationExpression_1(int position) {
    EvaluationResult<? extends List<IAnnotationNode>> result_0 = evaluatePackageDeclarationExpression_0(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<PackageKeywordToken>> result_1 = evaluatePackageKeywordToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IQualifiedIdentifierNode> result_2 = parseQualifiedIdentifier(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<SemicolonSeparatorToken>> result_3 = evaluateSemicolonSeparatorToken(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    IPackageDeclarationNode node = new PackageDeclarationNode(result_0.value, result_1.value, result_2.value, result_3.value);
    return new EvaluationResult<IPackageDeclarationNode>(true, result_3.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<IdentifierToken>> evaluateIdentifierToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      switch (token.getToken().getType()) {
        case 0:
          return new EvaluationResult<SourceToken<IdentifierToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<DotSeparatorToken>> evaluateDotSeparatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (DotSeparatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<DotSeparatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IQualifiedIdentifierNode> evaluateQualifiedIdentifierExpression_0(int position) {
    ArrayList<SourceToken<IdentifierToken>> elements = null;
    ArrayList<SourceToken<DotSeparatorToken> > delimiters = null;
    EvaluationResult<? extends SourceToken<IdentifierToken>> result = evaluateIdentifierToken(position);
    if (!result.succeeded) { return EvaluationResult.failure(); }
    elements = addValue(elements, result.value);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult<? extends SourceToken<DotSeparatorToken>> delimiterResult = evaluateDotSeparatorToken(currentPosition);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult<IQualifiedIdentifierNode>(true, currentPosition, new QualifiedIdentifierNode(new ArrayDelimitedList<SourceToken<IdentifierToken>, SourceToken<DotSeparatorToken>>(trimList(elements), trimList(delimiters))));
      }

      result = evaluateIdentifierToken(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult<IQualifiedIdentifierNode>(true, currentPosition, new QualifiedIdentifierNode(new ArrayDelimitedList<SourceToken<IdentifierToken>, SourceToken<DotSeparatorToken>>(trimList(elements), trimList(delimiters))));
      }
      elements = addValue(elements, result.value);
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IImportDeclarationNode> evaluateImportDeclarationExpression_0(int position) {
    EvaluationResult<? extends IImportDeclarationNode> result;
    if ((result = parseSingleTypeImportDeclaration(position)).succeeded) { return result; }
    if ((result = parseTypeImportOnDemandDeclaration(position)).succeeded) { return result; }
    if ((result = parseSingleStaticImportDeclaration(position)).succeeded) { return result; }
    return parseStaticImportOnDemandDeclaration(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<ImportKeywordToken>> evaluateImportKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (ImportKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<ImportKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ISingleTypeImportDeclarationNode> evaluateSingleTypeImportDeclarationExpression_0(int position) {
    EvaluationResult<? extends SourceToken<ImportKeywordToken>> result_0 = evaluateImportKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IQualifiedIdentifierNode> result_1 = parseQualifiedIdentifier(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<SemicolonSeparatorToken>> result_2 = evaluateSemicolonSeparatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    ISingleTypeImportDeclarationNode node = new SingleTypeImportDeclarationNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<ISingleTypeImportDeclarationNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<TimesOperatorToken>> evaluateTimesOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (TimesOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<TimesOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ITypeImportOnDemandDeclarationNode> evaluateTypeImportOnDemandDeclarationExpression_0(int position) {
    EvaluationResult<? extends SourceToken<ImportKeywordToken>> result_0 = evaluateImportKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IQualifiedIdentifierNode> result_1 = parseQualifiedIdentifier(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<DotSeparatorToken>> result_2 = evaluateDotSeparatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<TimesOperatorToken>> result_3 = evaluateTimesOperatorToken(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<SemicolonSeparatorToken>> result_4 = evaluateSemicolonSeparatorToken(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    ITypeImportOnDemandDeclarationNode node = new TypeImportOnDemandDeclarationNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value);
    return new EvaluationResult<ITypeImportOnDemandDeclarationNode>(true, result_4.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<StaticKeywordToken>> evaluateStaticKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (StaticKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<StaticKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ISingleStaticImportDeclarationNode> evaluateSingleStaticImportDeclarationExpression_0(int position) {
    EvaluationResult<? extends SourceToken<ImportKeywordToken>> result_0 = evaluateImportKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<StaticKeywordToken>> result_1 = evaluateStaticKeywordToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IQualifiedIdentifierNode> result_2 = parseQualifiedIdentifier(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<SemicolonSeparatorToken>> result_3 = evaluateSemicolonSeparatorToken(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    ISingleStaticImportDeclarationNode node = new SingleStaticImportDeclarationNode(result_0.value, result_1.value, result_2.value, result_3.value);
    return new EvaluationResult<ISingleStaticImportDeclarationNode>(true, result_3.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IStaticImportOnDemandDeclarationNode> evaluateStaticImportOnDemandDeclarationExpression_0(int position) {
    EvaluationResult<? extends SourceToken<ImportKeywordToken>> result_0 = evaluateImportKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<StaticKeywordToken>> result_1 = evaluateStaticKeywordToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IQualifiedIdentifierNode> result_2 = parseQualifiedIdentifier(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<DotSeparatorToken>> result_3 = evaluateDotSeparatorToken(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<TimesOperatorToken>> result_4 = evaluateTimesOperatorToken(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<SemicolonSeparatorToken>> result_5 = evaluateSemicolonSeparatorToken(result_4.position);
    if (!result_5.succeeded) { return EvaluationResult.failure(); }

    IStaticImportOnDemandDeclarationNode node = new StaticImportOnDemandDeclarationNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value, result_5.value);
    return new EvaluationResult<IStaticImportOnDemandDeclarationNode>(true, result_5.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ITypeDeclarationNode> evaluateTypeDeclarationExpression_0(int position) {
    EvaluationResult<? extends ITypeDeclarationNode> result;
    if ((result = parseClassDeclaration(position)).succeeded) { return result; }
    if ((result = parseInterfaceDeclaration(position)).succeeded) { return result; }
    return boxSemicolonSeparatorToken(evaluateSemicolonSeparatorToken(position));
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IClassDeclarationNode> evaluateClassDeclarationExpression_0(int position) {
    EvaluationResult<? extends IClassDeclarationNode> result;
    if ((result = parseNormalClassDeclaration(position)).succeeded) { return result; }
    return parseEnumDeclaration(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<ClassKeywordToken>> evaluateClassKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (ClassKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<ClassKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ITypeParametersNode> evaluateNormalClassDeclarationExpression_0(int position) {
    EvaluationResult<? extends ITypeParametersNode> result;
    if ((result = parseTypeParameters(position)).succeeded) { return result; }
    return new EvaluationResult<ITypeParametersNode>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ISuperNode> evaluateNormalClassDeclarationExpression_1(int position) {
    EvaluationResult<? extends ISuperNode> result;
    if ((result = parseSuper(position)).succeeded) { return result; }
    return new EvaluationResult<ISuperNode>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IInterfacesNode> evaluateNormalClassDeclarationExpression_2(int position) {
    EvaluationResult<? extends IInterfacesNode> result;
    if ((result = parseInterfaces(position)).succeeded) { return result; }
    return new EvaluationResult<IInterfacesNode>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends INormalClassDeclarationNode> evaluateNormalClassDeclarationExpression_3(int position) {
    EvaluationResult<? extends IModifiersNode> result_0 = parseModifiers(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<ClassKeywordToken>> result_1 = evaluateClassKeywordToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<IdentifierToken>> result_2 = evaluateIdentifierToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends ITypeParametersNode> result_3 = evaluateNormalClassDeclarationExpression_0(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends ISuperNode> result_4 = evaluateNormalClassDeclarationExpression_1(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IInterfacesNode> result_5 = evaluateNormalClassDeclarationExpression_2(result_4.position);
    if (!result_5.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IClassBodyNode> result_6 = parseClassBody(result_5.position);
    if (!result_6.succeeded) { return EvaluationResult.failure(); }

    INormalClassDeclarationNode node = new NormalClassDeclarationNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value, result_5.value, result_6.value);
    return new EvaluationResult<INormalClassDeclarationNode>(true, result_6.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IModifiersNode> evaluateModifiersExpression_0(int position) {
    int currentPosition = position;
    ArrayList<IModifierNode> values = null;
    while (true) {
      EvaluationResult<? extends IModifierNode> result = parseModifier(currentPosition);
      if (result.succeeded) {
        currentPosition = result.position;
        values = addValue(values, result.value);
      } else {
        return new EvaluationResult<IModifiersNode>(true, currentPosition, new ModifiersNode(trimList(values)));
      }
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<PublicKeywordToken>> evaluatePublicKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (PublicKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<PublicKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<ProtectedKeywordToken>> evaluateProtectedKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (ProtectedKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<ProtectedKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<PrivateKeywordToken>> evaluatePrivateKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (PrivateKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<PrivateKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<AbstractKeywordToken>> evaluateAbstractKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (AbstractKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<AbstractKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<FinalKeywordToken>> evaluateFinalKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (FinalKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<FinalKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<NativeKeywordToken>> evaluateNativeKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (NativeKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<NativeKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<SynchronizedKeywordToken>> evaluateSynchronizedKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (SynchronizedKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<SynchronizedKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<TransientKeywordToken>> evaluateTransientKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (TransientKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<TransientKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<VolatileKeywordToken>> evaluateVolatileKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (VolatileKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<VolatileKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<StrictfpKeywordToken>> evaluateStrictfpKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (StrictfpKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<StrictfpKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IModifierNode> evaluateModifierExpression_0(int position) {
    EvaluationResult<? extends IModifierNode> result;
    if ((result = parseAnnotation(position)).succeeded) { return result; }
    if ((result = boxPublicKeywordToken(evaluatePublicKeywordToken(position))).succeeded) { return result; }
    if ((result = boxProtectedKeywordToken(evaluateProtectedKeywordToken(position))).succeeded) { return result; }
    if ((result = boxPrivateKeywordToken(evaluatePrivateKeywordToken(position))).succeeded) { return result; }
    if ((result = boxStaticKeywordToken(evaluateStaticKeywordToken(position))).succeeded) { return result; }
    if ((result = boxAbstractKeywordToken(evaluateAbstractKeywordToken(position))).succeeded) { return result; }
    if ((result = boxFinalKeywordToken(evaluateFinalKeywordToken(position))).succeeded) { return result; }
    if ((result = boxNativeKeywordToken(evaluateNativeKeywordToken(position))).succeeded) { return result; }
    if ((result = boxSynchronizedKeywordToken(evaluateSynchronizedKeywordToken(position))).succeeded) { return result; }
    if ((result = boxTransientKeywordToken(evaluateTransientKeywordToken(position))).succeeded) { return result; }
    if ((result = boxVolatileKeywordToken(evaluateVolatileKeywordToken(position))).succeeded) { return result; }
    return boxStrictfpKeywordToken(evaluateStrictfpKeywordToken(position));
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<ExtendsKeywordToken>> evaluateExtendsKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (ExtendsKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<ExtendsKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ISuperNode> evaluateSuperExpression_0(int position) {
    EvaluationResult<? extends SourceToken<ExtendsKeywordToken>> result_0 = evaluateExtendsKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IClassOrInterfaceTypeNode> result_1 = parseClassOrInterfaceType(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    ISuperNode node = new SuperNode(result_0.value, result_1.value);
    return new EvaluationResult<ISuperNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<ImplementsKeywordToken>> evaluateImplementsKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (ImplementsKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<ImplementsKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<CommaSeparatorToken>> evaluateCommaSeparatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (CommaSeparatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<CommaSeparatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends DelimitedList<IClassOrInterfaceTypeNode, SourceToken<CommaSeparatorToken>>> evaluateInterfacesExpression_0(int position) {
    ArrayList<IClassOrInterfaceTypeNode> elements = null;
    ArrayList<SourceToken<CommaSeparatorToken> > delimiters = null;
    EvaluationResult<? extends IClassOrInterfaceTypeNode> result = parseClassOrInterfaceType(position);
    if (!result.succeeded) { return EvaluationResult.failure(); }
    elements = addValue(elements, result.value);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult<? extends SourceToken<CommaSeparatorToken>> delimiterResult = evaluateCommaSeparatorToken(currentPosition);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult<DelimitedList<IClassOrInterfaceTypeNode, SourceToken<CommaSeparatorToken>>>(true, currentPosition, new ArrayDelimitedList<IClassOrInterfaceTypeNode, SourceToken<CommaSeparatorToken>>(trimList(elements), trimList(delimiters)));
      }

      result = parseClassOrInterfaceType(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult<DelimitedList<IClassOrInterfaceTypeNode, SourceToken<CommaSeparatorToken>>>(true, currentPosition, new ArrayDelimitedList<IClassOrInterfaceTypeNode, SourceToken<CommaSeparatorToken>>(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result.value);
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IInterfacesNode> evaluateInterfacesExpression_1(int position) {
    EvaluationResult<? extends SourceToken<ImplementsKeywordToken>> result_0 = evaluateImplementsKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends DelimitedList<IClassOrInterfaceTypeNode, SourceToken<CommaSeparatorToken>>> result_1 = evaluateInterfacesExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    IInterfacesNode node = new InterfacesNode(result_0.value, result_1.value);
    return new EvaluationResult<IInterfacesNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<LeftCurlySeparatorToken>> evaluateLeftCurlySeparatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (LeftCurlySeparatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<LeftCurlySeparatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends List<IClassBodyDeclarationNode>> evaluateClassBodyExpression_0(int position) {
    int currentPosition = position;
    ArrayList<IClassBodyDeclarationNode> values = null;
    while (true) {
      EvaluationResult<? extends IClassBodyDeclarationNode> result = parseClassBodyDeclaration(currentPosition);
      if (result.succeeded) {
        currentPosition = result.position;
        values = addValue(values, result.value);
      } else {
        return new EvaluationResult<List<IClassBodyDeclarationNode>>(true, currentPosition, trimList(values));
      }
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<RightCurlySeparatorToken>> evaluateRightCurlySeparatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (RightCurlySeparatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<RightCurlySeparatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IClassBodyNode> evaluateClassBodyExpression_1(int position) {
    EvaluationResult<? extends SourceToken<LeftCurlySeparatorToken>> result_0 = evaluateLeftCurlySeparatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends List<IClassBodyDeclarationNode>> result_1 = evaluateClassBodyExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightCurlySeparatorToken>> result_2 = evaluateRightCurlySeparatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    IClassBodyNode node = new ClassBodyNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<IClassBodyNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IClassBodyDeclarationNode> evaluateClassBodyDeclarationExpression_0(int position) {
    EvaluationResult<? extends IClassBodyDeclarationNode> result;
    if ((result = parseClassOrInterfaceMemberDeclaration(position)).succeeded) { return result; }
    if ((result = parseBlock(position)).succeeded) { return result; }
    if ((result = parseStaticInitializer(position)).succeeded) { return result; }
    return parseConstructorDeclaration(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IStaticInitializerNode> evaluateStaticInitializerExpression_0(int position) {
    EvaluationResult<? extends SourceToken<StaticKeywordToken>> result_0 = evaluateStaticKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IBlockNode> result_1 = parseBlock(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    IStaticInitializerNode node = new StaticInitializerNode(result_0.value, result_1.value);
    return new EvaluationResult<IStaticInitializerNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IInterfaceDeclarationNode> evaluateInterfaceDeclarationExpression_0(int position) {
    EvaluationResult<? extends IInterfaceDeclarationNode> result;
    if ((result = parseNormalInterfaceDeclaration(position)).succeeded) { return result; }
    return parseAnnotationDeclaration(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<InterfaceKeywordToken>> evaluateInterfaceKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (InterfaceKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<InterfaceKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IExtendsInterfacesNode> evaluateNormalInterfaceDeclarationExpression_0(int position) {
    EvaluationResult<? extends IExtendsInterfacesNode> result;
    if ((result = parseExtendsInterfaces(position)).succeeded) { return result; }
    return new EvaluationResult<IExtendsInterfacesNode>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends INormalInterfaceDeclarationNode> evaluateNormalInterfaceDeclarationExpression_1(int position) {
    EvaluationResult<? extends IModifiersNode> result_0 = parseModifiers(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<InterfaceKeywordToken>> result_1 = evaluateInterfaceKeywordToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<IdentifierToken>> result_2 = evaluateIdentifierToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends ITypeParametersNode> result_3 = evaluateNormalClassDeclarationExpression_0(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExtendsInterfacesNode> result_4 = evaluateNormalInterfaceDeclarationExpression_0(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IClassOrInterfaceBodyNode> result_5 = parseClassOrInterfaceBody(result_4.position);
    if (!result_5.succeeded) { return EvaluationResult.failure(); }

    INormalInterfaceDeclarationNode node = new NormalInterfaceDeclarationNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value, result_5.value);
    return new EvaluationResult<INormalInterfaceDeclarationNode>(true, result_5.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IExtendsInterfacesNode> evaluateExtendsInterfacesExpression_0(int position) {
    EvaluationResult<? extends SourceToken<ExtendsKeywordToken>> result_0 = evaluateExtendsKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends DelimitedList<IClassOrInterfaceTypeNode, SourceToken<CommaSeparatorToken>>> result_1 = evaluateInterfacesExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    IExtendsInterfacesNode node = new ExtendsInterfacesNode(result_0.value, result_1.value);
    return new EvaluationResult<IExtendsInterfacesNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends List<IClassOrInterfaceMemberDeclarationNode>> evaluateClassOrInterfaceBodyExpression_0(int position) {
    int currentPosition = position;
    ArrayList<IClassOrInterfaceMemberDeclarationNode> values = null;
    while (true) {
      EvaluationResult<? extends IClassOrInterfaceMemberDeclarationNode> result = parseClassOrInterfaceMemberDeclaration(currentPosition);
      if (result.succeeded) {
        currentPosition = result.position;
        values = addValue(values, result.value);
      } else {
        return new EvaluationResult<List<IClassOrInterfaceMemberDeclarationNode>>(true, currentPosition, trimList(values));
      }
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IClassOrInterfaceBodyNode> evaluateClassOrInterfaceBodyExpression_1(int position) {
    EvaluationResult<? extends SourceToken<LeftCurlySeparatorToken>> result_0 = evaluateLeftCurlySeparatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends List<IClassOrInterfaceMemberDeclarationNode>> result_1 = evaluateClassOrInterfaceBodyExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightCurlySeparatorToken>> result_2 = evaluateRightCurlySeparatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    IClassOrInterfaceBodyNode node = new ClassOrInterfaceBodyNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<IClassOrInterfaceBodyNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<EnumKeywordToken>> evaluateEnumKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (EnumKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<EnumKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IEnumDeclarationNode> evaluateEnumDeclarationExpression_0(int position) {
    EvaluationResult<? extends IModifiersNode> result_0 = parseModifiers(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<EnumKeywordToken>> result_1 = evaluateEnumKeywordToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<IdentifierToken>> result_2 = evaluateIdentifierToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IInterfacesNode> result_3 = evaluateNormalClassDeclarationExpression_2(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IEnumBodyNode> result_4 = parseEnumBody(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    IEnumDeclarationNode node = new EnumDeclarationNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value);
    return new EvaluationResult<IEnumDeclarationNode>(true, result_4.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends DelimitedList<IEnumConstantNode, SourceToken<CommaSeparatorToken>>> evaluateEnumBodyExpression_0(int position) {
    ArrayList<IEnumConstantNode> elements = null;
    ArrayList<SourceToken<CommaSeparatorToken> > delimiters = null;
    EvaluationResult<? extends IEnumConstantNode> result = parseEnumConstant(position);
    if (!result.succeeded) { return EvaluationResult.failure(); }
    elements = addValue(elements, result.value);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult<? extends SourceToken<CommaSeparatorToken>> delimiterResult = evaluateCommaSeparatorToken(currentPosition);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult<DelimitedList<IEnumConstantNode, SourceToken<CommaSeparatorToken>>>(true, currentPosition, new ArrayDelimitedList<IEnumConstantNode, SourceToken<CommaSeparatorToken>>(trimList(elements), trimList(delimiters)));
      }

      result = parseEnumConstant(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult<DelimitedList<IEnumConstantNode, SourceToken<CommaSeparatorToken>>>(true, currentPosition, new ArrayDelimitedList<IEnumConstantNode, SourceToken<CommaSeparatorToken>>(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result.value);
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends DelimitedList<IEnumConstantNode, SourceToken<CommaSeparatorToken>>> evaluateEnumBodyExpression_1(int position) {
    EvaluationResult<? extends DelimitedList<IEnumConstantNode, SourceToken<CommaSeparatorToken>>> result;
    if ((result = evaluateEnumBodyExpression_0(position)).succeeded) { return result; }
    return new EvaluationResult<DelimitedList<IEnumConstantNode, SourceToken<CommaSeparatorToken>>>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<CommaSeparatorToken>> evaluateEnumBodyExpression_2(int position) {
    EvaluationResult<? extends SourceToken<CommaSeparatorToken>> result;
    if ((result = evaluateCommaSeparatorToken(position)).succeeded) { return result; }
    return new EvaluationResult<SourceToken<CommaSeparatorToken>>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<SemicolonSeparatorToken>> evaluateEnumBodyExpression_3(int position) {
    EvaluationResult<? extends SourceToken<SemicolonSeparatorToken>> result;
    if ((result = evaluateSemicolonSeparatorToken(position)).succeeded) { return result; }
    return new EvaluationResult<SourceToken<SemicolonSeparatorToken>>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IEnumBodyNode> evaluateEnumBodyExpression_4(int position) {
    EvaluationResult<? extends SourceToken<LeftCurlySeparatorToken>> result_0 = evaluateLeftCurlySeparatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends DelimitedList<IEnumConstantNode, SourceToken<CommaSeparatorToken>>> result_1 = evaluateEnumBodyExpression_1(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<CommaSeparatorToken>> result_2 = evaluateEnumBodyExpression_2(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<SemicolonSeparatorToken>> result_3 = evaluateEnumBodyExpression_3(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends List<IClassBodyDeclarationNode>> result_4 = evaluateClassBodyExpression_0(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightCurlySeparatorToken>> result_5 = evaluateRightCurlySeparatorToken(result_4.position);
    if (!result_5.succeeded) { return EvaluationResult.failure(); }

    IEnumBodyNode node = new EnumBodyNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value, result_5.value);
    return new EvaluationResult<IEnumBodyNode>(true, result_5.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IArgumentsNode> evaluateEnumConstantExpression_0(int position) {
    EvaluationResult<? extends IArgumentsNode> result;
    if ((result = parseArguments(position)).succeeded) { return result; }
    return new EvaluationResult<IArgumentsNode>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IClassOrInterfaceBodyNode> evaluateEnumConstantExpression_1(int position) {
    EvaluationResult<? extends IClassOrInterfaceBodyNode> result;
    if ((result = parseClassOrInterfaceBody(position)).succeeded) { return result; }
    return new EvaluationResult<IClassOrInterfaceBodyNode>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IEnumConstantNode> evaluateEnumConstantExpression_2(int position) {
    EvaluationResult<? extends List<IAnnotationNode>> result_0 = evaluatePackageDeclarationExpression_0(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<IdentifierToken>> result_1 = evaluateIdentifierToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IArgumentsNode> result_2 = evaluateEnumConstantExpression_0(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IClassOrInterfaceBodyNode> result_3 = evaluateEnumConstantExpression_1(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    IEnumConstantNode node = new EnumConstantNode(result_0.value, result_1.value, result_2.value, result_3.value);
    return new EvaluationResult<IEnumConstantNode>(true, result_3.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<LeftParenthesisSeparatorToken>> evaluateLeftParenthesisSeparatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (LeftParenthesisSeparatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<LeftParenthesisSeparatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IDelimitedExpressionListNode> evaluateArgumentsExpression_0(int position) {
    EvaluationResult<? extends IDelimitedExpressionListNode> result;
    if ((result = parseDelimitedExpressionList(position)).succeeded) { return result; }
    return new EvaluationResult<IDelimitedExpressionListNode>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<RightParenthesisSeparatorToken>> evaluateRightParenthesisSeparatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (RightParenthesisSeparatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<RightParenthesisSeparatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IArgumentsNode> evaluateArgumentsExpression_1(int position) {
    EvaluationResult<? extends SourceToken<LeftParenthesisSeparatorToken>> result_0 = evaluateLeftParenthesisSeparatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IDelimitedExpressionListNode> result_1 = evaluateArgumentsExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightParenthesisSeparatorToken>> result_2 = evaluateRightParenthesisSeparatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    IArgumentsNode node = new ArgumentsNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<IArgumentsNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<AtSeparatorToken>> evaluateAtSeparatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (AtSeparatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<AtSeparatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IAnnotationDeclarationNode> evaluateAnnotationDeclarationExpression_0(int position) {
    EvaluationResult<? extends IModifiersNode> result_0 = parseModifiers(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<AtSeparatorToken>> result_1 = evaluateAtSeparatorToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<InterfaceKeywordToken>> result_2 = evaluateInterfaceKeywordToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<IdentifierToken>> result_3 = evaluateIdentifierToken(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IAnnotationBodyNode> result_4 = parseAnnotationBody(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    IAnnotationDeclarationNode node = new AnnotationDeclarationNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value);
    return new EvaluationResult<IAnnotationDeclarationNode>(true, result_4.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends List<IAnnotationElementDeclarationNode>> evaluateAnnotationBodyExpression_0(int position) {
    int currentPosition = position;
    ArrayList<IAnnotationElementDeclarationNode> values = null;
    while (true) {
      EvaluationResult<? extends IAnnotationElementDeclarationNode> result = parseAnnotationElementDeclaration(currentPosition);
      if (result.succeeded) {
        currentPosition = result.position;
        values = addValue(values, result.value);
      } else {
        return new EvaluationResult<List<IAnnotationElementDeclarationNode>>(true, currentPosition, trimList(values));
      }
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IAnnotationBodyNode> evaluateAnnotationBodyExpression_1(int position) {
    EvaluationResult<? extends SourceToken<LeftCurlySeparatorToken>> result_0 = evaluateLeftCurlySeparatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends List<IAnnotationElementDeclarationNode>> result_1 = evaluateAnnotationBodyExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightCurlySeparatorToken>> result_2 = evaluateRightCurlySeparatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    IAnnotationBodyNode node = new AnnotationBodyNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<IAnnotationBodyNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IAnnotationElementDeclarationNode> evaluateAnnotationElementDeclarationExpression_0(int position) {
    EvaluationResult<? extends IAnnotationElementDeclarationNode> result;
    if ((result = parseAnnotationDefaultDeclaration(position)).succeeded) { return result; }
    return parseClassOrInterfaceMemberDeclaration(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<DefaultKeywordToken>> evaluateDefaultKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (DefaultKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<DefaultKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IAnnotationDefaultDeclarationNode> evaluateAnnotationDefaultDeclarationExpression_0(int position) {
    EvaluationResult<? extends IModifiersNode> result_0 = parseModifiers(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends ITypeNode> result_1 = parseType(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<IdentifierToken>> result_2 = evaluateIdentifierToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<LeftParenthesisSeparatorToken>> result_3 = evaluateLeftParenthesisSeparatorToken(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightParenthesisSeparatorToken>> result_4 = evaluateRightParenthesisSeparatorToken(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<DefaultKeywordToken>> result_5 = evaluateDefaultKeywordToken(result_4.position);
    if (!result_5.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IElementValueNode> result_6 = parseElementValue(result_5.position);
    if (!result_6.succeeded) { return EvaluationResult.failure(); }

    IAnnotationDefaultDeclarationNode node = new AnnotationDefaultDeclarationNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value, result_5.value, result_6.value);
    return new EvaluationResult<IAnnotationDefaultDeclarationNode>(true, result_6.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IClassOrInterfaceMemberDeclarationNode> evaluateClassOrInterfaceMemberDeclarationExpression_0(int position) {
    EvaluationResult<? extends IClassOrInterfaceMemberDeclarationNode> result;
    if ((result = parseFieldDeclaration(position)).succeeded) { return result; }
    if ((result = parseMethodDeclaration(position)).succeeded) { return result; }
    return parseTypeDeclaration(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends DelimitedList<IFormalParameterNode, SourceToken<CommaSeparatorToken>>> evaluateConstructorDeclarationExpression_0(int position) {
    ArrayList<IFormalParameterNode> elements = null;
    ArrayList<SourceToken<CommaSeparatorToken> > delimiters = null;
    EvaluationResult<? extends IFormalParameterNode> result = parseFormalParameter(position);
    if (!result.succeeded) { return EvaluationResult.failure(); }
    elements = addValue(elements, result.value);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult<? extends SourceToken<CommaSeparatorToken>> delimiterResult = evaluateCommaSeparatorToken(currentPosition);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult<DelimitedList<IFormalParameterNode, SourceToken<CommaSeparatorToken>>>(true, currentPosition, new ArrayDelimitedList<IFormalParameterNode, SourceToken<CommaSeparatorToken>>(trimList(elements), trimList(delimiters)));
      }

      result = parseFormalParameter(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult<DelimitedList<IFormalParameterNode, SourceToken<CommaSeparatorToken>>>(true, currentPosition, new ArrayDelimitedList<IFormalParameterNode, SourceToken<CommaSeparatorToken>>(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result.value);
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends DelimitedList<IFormalParameterNode, SourceToken<CommaSeparatorToken>>> evaluateConstructorDeclarationExpression_1(int position) {
    EvaluationResult<? extends DelimitedList<IFormalParameterNode, SourceToken<CommaSeparatorToken>>> result;
    if ((result = evaluateConstructorDeclarationExpression_0(position)).succeeded) { return result; }
    return new EvaluationResult<DelimitedList<IFormalParameterNode, SourceToken<CommaSeparatorToken>>>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IThrowsNode> evaluateConstructorDeclarationExpression_2(int position) {
    EvaluationResult<? extends IThrowsNode> result;
    if ((result = parseThrows(position)).succeeded) { return result; }
    return new EvaluationResult<IThrowsNode>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IConstructorDeclarationNode> evaluateConstructorDeclarationExpression_3(int position) {
    EvaluationResult<? extends IModifiersNode> result_0 = parseModifiers(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends ITypeParametersNode> result_1 = evaluateNormalClassDeclarationExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<IdentifierToken>> result_2 = evaluateIdentifierToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<LeftParenthesisSeparatorToken>> result_3 = evaluateLeftParenthesisSeparatorToken(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends DelimitedList<IFormalParameterNode, SourceToken<CommaSeparatorToken>>> result_4 = evaluateConstructorDeclarationExpression_1(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightParenthesisSeparatorToken>> result_5 = evaluateRightParenthesisSeparatorToken(result_4.position);
    if (!result_5.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IThrowsNode> result_6 = evaluateConstructorDeclarationExpression_2(result_5.position);
    if (!result_6.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IBlockNode> result_7 = parseBlock(result_6.position);
    if (!result_7.succeeded) { return EvaluationResult.failure(); }

    IConstructorDeclarationNode node = new ConstructorDeclarationNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value, result_5.value, result_6.value, result_7.value);
    return new EvaluationResult<IConstructorDeclarationNode>(true, result_7.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends DelimitedList<IVariableDeclaratorNode, SourceToken<CommaSeparatorToken>>> evaluateFieldDeclarationExpression_0(int position) {
    ArrayList<IVariableDeclaratorNode> elements = null;
    ArrayList<SourceToken<CommaSeparatorToken> > delimiters = null;
    EvaluationResult<? extends IVariableDeclaratorNode> result = parseVariableDeclarator(position);
    if (!result.succeeded) { return EvaluationResult.failure(); }
    elements = addValue(elements, result.value);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult<? extends SourceToken<CommaSeparatorToken>> delimiterResult = evaluateCommaSeparatorToken(currentPosition);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult<DelimitedList<IVariableDeclaratorNode, SourceToken<CommaSeparatorToken>>>(true, currentPosition, new ArrayDelimitedList<IVariableDeclaratorNode, SourceToken<CommaSeparatorToken>>(trimList(elements), trimList(delimiters)));
      }

      result = parseVariableDeclarator(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult<DelimitedList<IVariableDeclaratorNode, SourceToken<CommaSeparatorToken>>>(true, currentPosition, new ArrayDelimitedList<IVariableDeclaratorNode, SourceToken<CommaSeparatorToken>>(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result.value);
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IFieldDeclarationNode> evaluateFieldDeclarationExpression_1(int position) {
    EvaluationResult<? extends IModifiersNode> result_0 = parseModifiers(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends ITypeNode> result_1 = parseType(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends DelimitedList<IVariableDeclaratorNode, SourceToken<CommaSeparatorToken>>> result_2 = evaluateFieldDeclarationExpression_0(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<SemicolonSeparatorToken>> result_3 = evaluateSemicolonSeparatorToken(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    IFieldDeclarationNode node = new FieldDeclarationNode(result_0.value, result_1.value, result_2.value, result_3.value);
    return new EvaluationResult<IFieldDeclarationNode>(true, result_3.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IVariableDeclaratorNode> evaluateVariableDeclaratorExpression_0(int position) {
    EvaluationResult<? extends IVariableDeclaratorNode> result;
    if ((result = parseVariableDeclaratorIdAndAssignment(position)).succeeded) { return result; }
    return parseVariableDeclaratorId(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<EqualsOperatorToken>> evaluateEqualsOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (EqualsOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<EqualsOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IVariableDeclaratorIdAndAssignmentNode> evaluateVariableDeclaratorIdAndAssignmentExpression_0(int position) {
    EvaluationResult<? extends IVariableDeclaratorIdNode> result_0 = parseVariableDeclaratorId(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<EqualsOperatorToken>> result_1 = evaluateEqualsOperatorToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IVariableDeclaratorAssignmentNode> result_2 = parseVariableDeclaratorAssignment(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    IVariableDeclaratorIdAndAssignmentNode node = new VariableDeclaratorIdAndAssignmentNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<IVariableDeclaratorIdAndAssignmentNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IVariableDeclaratorAssignmentNode> evaluateVariableDeclaratorAssignmentExpression_0(int position) {
    EvaluationResult<? extends IVariableDeclaratorAssignmentNode> result;
    if ((result = parseExpression(position)).succeeded) { return result; }
    return parseArrayInitializer(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends List<IBracketPairNode>> evaluateVariableDeclaratorIdExpression_0(int position) {
    int currentPosition = position;
    ArrayList<IBracketPairNode> values = null;
    while (true) {
      EvaluationResult<? extends IBracketPairNode> result = parseBracketPair(currentPosition);
      if (result.succeeded) {
        currentPosition = result.position;
        values = addValue(values, result.value);
      } else {
        return new EvaluationResult<List<IBracketPairNode>>(true, currentPosition, trimList(values));
      }
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IVariableDeclaratorIdNode> evaluateVariableDeclaratorIdExpression_1(int position) {
    EvaluationResult<? extends SourceToken<IdentifierToken>> result_0 = evaluateIdentifierToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends List<IBracketPairNode>> result_1 = evaluateVariableDeclaratorIdExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    IVariableDeclaratorIdNode node = new VariableDeclaratorIdNode(result_0.value, result_1.value);
    return new EvaluationResult<IVariableDeclaratorIdNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<LeftBracketSeparatorToken>> evaluateLeftBracketSeparatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (LeftBracketSeparatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<LeftBracketSeparatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<RightBracketSeparatorToken>> evaluateRightBracketSeparatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (RightBracketSeparatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<RightBracketSeparatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IBracketPairNode> evaluateBracketPairExpression_0(int position) {
    EvaluationResult<? extends SourceToken<LeftBracketSeparatorToken>> result_0 = evaluateLeftBracketSeparatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightBracketSeparatorToken>> result_1 = evaluateRightBracketSeparatorToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    IBracketPairNode node = new BracketPairNode(result_0.value, result_1.value);
    return new EvaluationResult<IBracketPairNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IMethodDeclarationNode> evaluateMethodDeclarationExpression_0(int position) {
    EvaluationResult<? extends IModifiersNode> result_0 = parseModifiers(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends ITypeParametersNode> result_1 = evaluateNormalClassDeclarationExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends ITypeNode> result_2 = parseType(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<IdentifierToken>> result_3 = evaluateIdentifierToken(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<LeftParenthesisSeparatorToken>> result_4 = evaluateLeftParenthesisSeparatorToken(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends DelimitedList<IFormalParameterNode, SourceToken<CommaSeparatorToken>>> result_5 = evaluateConstructorDeclarationExpression_1(result_4.position);
    if (!result_5.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightParenthesisSeparatorToken>> result_6 = evaluateRightParenthesisSeparatorToken(result_5.position);
    if (!result_6.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends List<IBracketPairNode>> result_7 = evaluateVariableDeclaratorIdExpression_0(result_6.position);
    if (!result_7.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IThrowsNode> result_8 = evaluateConstructorDeclarationExpression_2(result_7.position);
    if (!result_8.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IMethodBodyNode> result_9 = parseMethodBody(result_8.position);
    if (!result_9.succeeded) { return EvaluationResult.failure(); }

    IMethodDeclarationNode node = new MethodDeclarationNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value, result_5.value, result_6.value, result_7.value, result_8.value, result_9.value);
    return new EvaluationResult<IMethodDeclarationNode>(true, result_9.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IMethodBodyNode> evaluateMethodBodyExpression_0(int position) {
    EvaluationResult<? extends IMethodBodyNode> result;
    if ((result = parseBlock(position)).succeeded) { return result; }
    return boxSemicolonSeparatorToken(evaluateSemicolonSeparatorToken(position));
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<EllipsisSeparatorToken>> evaluateEllipsisSeparatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (EllipsisSeparatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<EllipsisSeparatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<EllipsisSeparatorToken>> evaluateFormalParameterExpression_0(int position) {
    EvaluationResult<? extends SourceToken<EllipsisSeparatorToken>> result;
    if ((result = evaluateEllipsisSeparatorToken(position)).succeeded) { return result; }
    return new EvaluationResult<SourceToken<EllipsisSeparatorToken>>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IFormalParameterNode> evaluateFormalParameterExpression_1(int position) {
    EvaluationResult<? extends IModifiersNode> result_0 = parseModifiers(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends ITypeNode> result_1 = parseType(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<EllipsisSeparatorToken>> result_2 = evaluateFormalParameterExpression_0(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IVariableDeclaratorIdNode> result_3 = parseVariableDeclaratorId(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    IFormalParameterNode node = new FormalParameterNode(result_0.value, result_1.value, result_2.value, result_3.value);
    return new EvaluationResult<IFormalParameterNode>(true, result_3.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<ThrowsKeywordToken>> evaluateThrowsKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (ThrowsKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<ThrowsKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IThrowsNode> evaluateThrowsExpression_0(int position) {
    EvaluationResult<? extends SourceToken<ThrowsKeywordToken>> result_0 = evaluateThrowsKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends DelimitedList<IClassOrInterfaceTypeNode, SourceToken<CommaSeparatorToken>>> result_1 = evaluateInterfacesExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    IThrowsNode node = new ThrowsNode(result_0.value, result_1.value);
    return new EvaluationResult<IThrowsNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<LessThanOperatorToken>> evaluateLessThanOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (LessThanOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<LessThanOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends DelimitedList<ITypeParameterNode, SourceToken<CommaSeparatorToken>>> evaluateTypeParametersExpression_0(int position) {
    ArrayList<ITypeParameterNode> elements = null;
    ArrayList<SourceToken<CommaSeparatorToken> > delimiters = null;
    EvaluationResult<? extends ITypeParameterNode> result = parseTypeParameter(position);
    if (!result.succeeded) { return EvaluationResult.failure(); }
    elements = addValue(elements, result.value);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult<? extends SourceToken<CommaSeparatorToken>> delimiterResult = evaluateCommaSeparatorToken(currentPosition);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult<DelimitedList<ITypeParameterNode, SourceToken<CommaSeparatorToken>>>(true, currentPosition, new ArrayDelimitedList<ITypeParameterNode, SourceToken<CommaSeparatorToken>>(trimList(elements), trimList(delimiters)));
      }

      result = parseTypeParameter(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult<DelimitedList<ITypeParameterNode, SourceToken<CommaSeparatorToken>>>(true, currentPosition, new ArrayDelimitedList<ITypeParameterNode, SourceToken<CommaSeparatorToken>>(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result.value);
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<GreaterThanOperatorToken>> evaluateGreaterThanOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (GreaterThanOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<GreaterThanOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ITypeParametersNode> evaluateTypeParametersExpression_1(int position) {
    EvaluationResult<? extends SourceToken<LessThanOperatorToken>> result_0 = evaluateLessThanOperatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends DelimitedList<ITypeParameterNode, SourceToken<CommaSeparatorToken>>> result_1 = evaluateTypeParametersExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<GreaterThanOperatorToken>> result_2 = evaluateGreaterThanOperatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    ITypeParametersNode node = new TypeParametersNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<ITypeParametersNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ITypeBoundNode> evaluateTypeParameterExpression_0(int position) {
    EvaluationResult<? extends ITypeBoundNode> result;
    if ((result = parseTypeBound(position)).succeeded) { return result; }
    return new EvaluationResult<ITypeBoundNode>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ITypeParameterNode> evaluateTypeParameterExpression_1(int position) {
    EvaluationResult<? extends SourceToken<IdentifierToken>> result_0 = evaluateIdentifierToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends ITypeBoundNode> result_1 = evaluateTypeParameterExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    ITypeParameterNode node = new TypeParameterNode(result_0.value, result_1.value);
    return new EvaluationResult<ITypeParameterNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<BitwiseAndOperatorToken>> evaluateBitwiseAndOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (BitwiseAndOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<BitwiseAndOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends DelimitedList<IClassOrInterfaceTypeNode, SourceToken<BitwiseAndOperatorToken>>> evaluateTypeBoundExpression_0(int position) {
    ArrayList<IClassOrInterfaceTypeNode> elements = null;
    ArrayList<SourceToken<BitwiseAndOperatorToken> > delimiters = null;
    EvaluationResult<? extends IClassOrInterfaceTypeNode> result = parseClassOrInterfaceType(position);
    if (!result.succeeded) { return EvaluationResult.failure(); }
    elements = addValue(elements, result.value);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult<? extends SourceToken<BitwiseAndOperatorToken>> delimiterResult = evaluateBitwiseAndOperatorToken(currentPosition);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult<DelimitedList<IClassOrInterfaceTypeNode, SourceToken<BitwiseAndOperatorToken>>>(true, currentPosition, new ArrayDelimitedList<IClassOrInterfaceTypeNode, SourceToken<BitwiseAndOperatorToken>>(trimList(elements), trimList(delimiters)));
      }

      result = parseClassOrInterfaceType(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult<DelimitedList<IClassOrInterfaceTypeNode, SourceToken<BitwiseAndOperatorToken>>>(true, currentPosition, new ArrayDelimitedList<IClassOrInterfaceTypeNode, SourceToken<BitwiseAndOperatorToken>>(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result.value);
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ITypeBoundNode> evaluateTypeBoundExpression_1(int position) {
    EvaluationResult<? extends SourceToken<ExtendsKeywordToken>> result_0 = evaluateExtendsKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends DelimitedList<IClassOrInterfaceTypeNode, SourceToken<BitwiseAndOperatorToken>>> result_1 = evaluateTypeBoundExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    ITypeBoundNode node = new TypeBoundNode(result_0.value, result_1.value);
    return new EvaluationResult<ITypeBoundNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ITypeNode> evaluateTypeExpression_0(int position) {
    EvaluationResult<? extends ITypeNode> result;
    if ((result = parseReferenceType(position)).succeeded) { return result; }
    return parsePrimitiveType(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IReferenceTypeNode> evaluateReferenceTypeExpression_0(int position) {
    EvaluationResult<? extends IReferenceTypeNode> result;
    if ((result = parsePrimitiveArrayReferenceType(position)).succeeded) { return result; }
    return parseClassOrInterfaceReferenceType(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends List<IBracketPairNode>> evaluatePrimitiveArrayReferenceTypeExpression_0(int position) {
    ArrayList<IBracketPairNode> values = null;
    EvaluationResult<? extends IBracketPairNode> result = parseBracketPair(position);
    if (!result.succeeded) {
      return EvaluationResult.failure();
    }
    while (true) {
      int currentPosition = result.position;
      values = addValue(values, result.value);
      result = parseBracketPair(currentPosition);
      if (!result.succeeded) {
        return new EvaluationResult<List<IBracketPairNode>>(true, currentPosition, trimList(values));
      }
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IPrimitiveArrayReferenceTypeNode> evaluatePrimitiveArrayReferenceTypeExpression_1(int position) {
    EvaluationResult<? extends IPrimitiveTypeNode> result_0 = parsePrimitiveType(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends List<IBracketPairNode>> result_1 = evaluatePrimitiveArrayReferenceTypeExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    IPrimitiveArrayReferenceTypeNode node = new PrimitiveArrayReferenceTypeNode(result_0.value, result_1.value);
    return new EvaluationResult<IPrimitiveArrayReferenceTypeNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IClassOrInterfaceReferenceTypeNode> evaluateClassOrInterfaceReferenceTypeExpression_0(int position) {
    EvaluationResult<? extends IClassOrInterfaceTypeNode> result_0 = parseClassOrInterfaceType(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends List<IBracketPairNode>> result_1 = evaluateVariableDeclaratorIdExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    IClassOrInterfaceReferenceTypeNode node = new ClassOrInterfaceReferenceTypeNode(result_0.value, result_1.value);
    return new EvaluationResult<IClassOrInterfaceReferenceTypeNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IClassOrInterfaceTypeNode> evaluateClassOrInterfaceTypeExpression_0(int position) {
    ArrayList<ISingleClassOrInterfaceTypeNode> elements = null;
    ArrayList<SourceToken<DotSeparatorToken> > delimiters = null;
    EvaluationResult<? extends ISingleClassOrInterfaceTypeNode> result = parseSingleClassOrInterfaceType(position);
    if (!result.succeeded) { return EvaluationResult.failure(); }
    elements = addValue(elements, result.value);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult<? extends SourceToken<DotSeparatorToken>> delimiterResult = evaluateDotSeparatorToken(currentPosition);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult<IClassOrInterfaceTypeNode>(true, currentPosition, new ClassOrInterfaceTypeNode(new ArrayDelimitedList<ISingleClassOrInterfaceTypeNode, SourceToken<DotSeparatorToken>>(trimList(elements), trimList(delimiters))));
      }

      result = parseSingleClassOrInterfaceType(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult<IClassOrInterfaceTypeNode>(true, currentPosition, new ClassOrInterfaceTypeNode(new ArrayDelimitedList<ISingleClassOrInterfaceTypeNode, SourceToken<DotSeparatorToken>>(trimList(elements), trimList(delimiters))));
      }
      elements = addValue(elements, result.value);
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ITypeArgumentsNode> evaluateSingleClassOrInterfaceTypeExpression_0(int position) {
    EvaluationResult<? extends ITypeArgumentsNode> result;
    if ((result = parseTypeArguments(position)).succeeded) { return result; }
    return new EvaluationResult<ITypeArgumentsNode>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ISingleClassOrInterfaceTypeNode> evaluateSingleClassOrInterfaceTypeExpression_1(int position) {
    EvaluationResult<? extends SourceToken<IdentifierToken>> result_0 = evaluateIdentifierToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends ITypeArgumentsNode> result_1 = evaluateSingleClassOrInterfaceTypeExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    ISingleClassOrInterfaceTypeNode node = new SingleClassOrInterfaceTypeNode(result_0.value, result_1.value);
    return new EvaluationResult<ISingleClassOrInterfaceTypeNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends DelimitedList<ITypeArgumentNode, SourceToken<CommaSeparatorToken>>> evaluateTypeArgumentsExpression_0(int position) {
    ArrayList<ITypeArgumentNode> elements = null;
    ArrayList<SourceToken<CommaSeparatorToken> > delimiters = null;
    EvaluationResult<? extends ITypeArgumentNode> result = parseTypeArgument(position);
    if (!result.succeeded) { return EvaluationResult.failure(); }
    elements = addValue(elements, result.value);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult<? extends SourceToken<CommaSeparatorToken>> delimiterResult = evaluateCommaSeparatorToken(currentPosition);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult<DelimitedList<ITypeArgumentNode, SourceToken<CommaSeparatorToken>>>(true, currentPosition, new ArrayDelimitedList<ITypeArgumentNode, SourceToken<CommaSeparatorToken>>(trimList(elements), trimList(delimiters)));
      }

      result = parseTypeArgument(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult<DelimitedList<ITypeArgumentNode, SourceToken<CommaSeparatorToken>>>(true, currentPosition, new ArrayDelimitedList<ITypeArgumentNode, SourceToken<CommaSeparatorToken>>(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result.value);
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ITypeArgumentsNode> evaluateTypeArgumentsExpression_1(int position) {
    EvaluationResult<? extends SourceToken<LessThanOperatorToken>> result_0 = evaluateLessThanOperatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends DelimitedList<ITypeArgumentNode, SourceToken<CommaSeparatorToken>>> result_1 = evaluateTypeArgumentsExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<GreaterThanOperatorToken>> result_2 = evaluateGreaterThanOperatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    ITypeArgumentsNode node = new TypeArgumentsNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<ITypeArgumentsNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ITypeArgumentNode> evaluateTypeArgumentExpression_0(int position) {
    EvaluationResult<? extends ITypeArgumentNode> result;
    if ((result = parseReferenceType(position)).succeeded) { return result; }
    return parseWildcardTypeArgument(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IWildcardTypeArgumentNode> evaluateWildcardTypeArgumentExpression_0(int position) {
    EvaluationResult<? extends IWildcardTypeArgumentNode> result;
    if ((result = parseExtendsWildcardTypeArgument(position)).succeeded) { return result; }
    if ((result = parseSuperWildcardTypeArgument(position)).succeeded) { return result; }
    return parseOpenWildcardTypeArgument(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<QuestionMarkOperatorToken>> evaluateQuestionMarkOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (QuestionMarkOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<QuestionMarkOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IExtendsWildcardTypeArgumentNode> evaluateExtendsWildcardTypeArgumentExpression_0(int position) {
    EvaluationResult<? extends SourceToken<QuestionMarkOperatorToken>> result_0 = evaluateQuestionMarkOperatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<ExtendsKeywordToken>> result_1 = evaluateExtendsKeywordToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IReferenceTypeNode> result_2 = parseReferenceType(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    IExtendsWildcardTypeArgumentNode node = new ExtendsWildcardTypeArgumentNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<IExtendsWildcardTypeArgumentNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<SuperKeywordToken>> evaluateSuperKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (SuperKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<SuperKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ISuperWildcardTypeArgumentNode> evaluateSuperWildcardTypeArgumentExpression_0(int position) {
    EvaluationResult<? extends SourceToken<QuestionMarkOperatorToken>> result_0 = evaluateQuestionMarkOperatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<SuperKeywordToken>> result_1 = evaluateSuperKeywordToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IReferenceTypeNode> result_2 = parseReferenceType(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    ISuperWildcardTypeArgumentNode node = new SuperWildcardTypeArgumentNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<ISuperWildcardTypeArgumentNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends DelimitedList<IReferenceTypeNode, SourceToken<CommaSeparatorToken>>> evaluateNonWildcardTypeArgumentsExpression_0(int position) {
    ArrayList<IReferenceTypeNode> elements = null;
    ArrayList<SourceToken<CommaSeparatorToken> > delimiters = null;
    EvaluationResult<? extends IReferenceTypeNode> result = parseReferenceType(position);
    if (!result.succeeded) { return EvaluationResult.failure(); }
    elements = addValue(elements, result.value);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult<? extends SourceToken<CommaSeparatorToken>> delimiterResult = evaluateCommaSeparatorToken(currentPosition);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult<DelimitedList<IReferenceTypeNode, SourceToken<CommaSeparatorToken>>>(true, currentPosition, new ArrayDelimitedList<IReferenceTypeNode, SourceToken<CommaSeparatorToken>>(trimList(elements), trimList(delimiters)));
      }

      result = parseReferenceType(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult<DelimitedList<IReferenceTypeNode, SourceToken<CommaSeparatorToken>>>(true, currentPosition, new ArrayDelimitedList<IReferenceTypeNode, SourceToken<CommaSeparatorToken>>(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result.value);
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends INonWildcardTypeArgumentsNode> evaluateNonWildcardTypeArgumentsExpression_1(int position) {
    EvaluationResult<? extends SourceToken<LessThanOperatorToken>> result_0 = evaluateLessThanOperatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends DelimitedList<IReferenceTypeNode, SourceToken<CommaSeparatorToken>>> result_1 = evaluateNonWildcardTypeArgumentsExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<GreaterThanOperatorToken>> result_2 = evaluateGreaterThanOperatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    INonWildcardTypeArgumentsNode node = new NonWildcardTypeArgumentsNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<INonWildcardTypeArgumentsNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<ByteKeywordToken>> evaluateByteKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (ByteKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<ByteKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<ShortKeywordToken>> evaluateShortKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (ShortKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<ShortKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<CharKeywordToken>> evaluateCharKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (CharKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<CharKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<IntKeywordToken>> evaluateIntKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (IntKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<IntKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<LongKeywordToken>> evaluateLongKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (LongKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<LongKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<FloatKeywordToken>> evaluateFloatKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (FloatKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<FloatKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<DoubleKeywordToken>> evaluateDoubleKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (DoubleKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<DoubleKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<BooleanKeywordToken>> evaluateBooleanKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (BooleanKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<BooleanKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<VoidKeywordToken>> evaluateVoidKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (VoidKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<VoidKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IPrimitiveTypeNode> evaluatePrimitiveTypeExpression_0(int position) {
    EvaluationResult<? extends IPrimitiveTypeNode> result;
    if ((result = boxByteKeywordToken(evaluateByteKeywordToken(position))).succeeded) { return result; }
    if ((result = boxShortKeywordToken(evaluateShortKeywordToken(position))).succeeded) { return result; }
    if ((result = boxCharKeywordToken(evaluateCharKeywordToken(position))).succeeded) { return result; }
    if ((result = boxIntKeywordToken(evaluateIntKeywordToken(position))).succeeded) { return result; }
    if ((result = boxLongKeywordToken(evaluateLongKeywordToken(position))).succeeded) { return result; }
    if ((result = boxFloatKeywordToken(evaluateFloatKeywordToken(position))).succeeded) { return result; }
    if ((result = boxDoubleKeywordToken(evaluateDoubleKeywordToken(position))).succeeded) { return result; }
    if ((result = boxBooleanKeywordToken(evaluateBooleanKeywordToken(position))).succeeded) { return result; }
    return boxVoidKeywordToken(evaluateVoidKeywordToken(position));
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IAnnotationNode> evaluateAnnotationExpression_0(int position) {
    EvaluationResult<? extends IAnnotationNode> result;
    if ((result = parseNormalAnnotation(position)).succeeded) { return result; }
    if ((result = parseSingleElementAnnotation(position)).succeeded) { return result; }
    return parseMarkerAnnotation(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends DelimitedList<IElementValuePairNode, SourceToken<CommaSeparatorToken>>> evaluateNormalAnnotationExpression_0(int position) {
    ArrayList<IElementValuePairNode> elements = null;
    ArrayList<SourceToken<CommaSeparatorToken> > delimiters = null;
    EvaluationResult<? extends IElementValuePairNode> result = parseElementValuePair(position);
    if (!result.succeeded) { return EvaluationResult.failure(); }
    elements = addValue(elements, result.value);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult<? extends SourceToken<CommaSeparatorToken>> delimiterResult = evaluateCommaSeparatorToken(currentPosition);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult<DelimitedList<IElementValuePairNode, SourceToken<CommaSeparatorToken>>>(true, currentPosition, new ArrayDelimitedList<IElementValuePairNode, SourceToken<CommaSeparatorToken>>(trimList(elements), trimList(delimiters)));
      }

      result = parseElementValuePair(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult<DelimitedList<IElementValuePairNode, SourceToken<CommaSeparatorToken>>>(true, currentPosition, new ArrayDelimitedList<IElementValuePairNode, SourceToken<CommaSeparatorToken>>(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result.value);
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends DelimitedList<IElementValuePairNode, SourceToken<CommaSeparatorToken>>> evaluateNormalAnnotationExpression_1(int position) {
    EvaluationResult<? extends DelimitedList<IElementValuePairNode, SourceToken<CommaSeparatorToken>>> result;
    if ((result = evaluateNormalAnnotationExpression_0(position)).succeeded) { return result; }
    return new EvaluationResult<DelimitedList<IElementValuePairNode, SourceToken<CommaSeparatorToken>>>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends INormalAnnotationNode> evaluateNormalAnnotationExpression_2(int position) {
    EvaluationResult<? extends SourceToken<AtSeparatorToken>> result_0 = evaluateAtSeparatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IQualifiedIdentifierNode> result_1 = parseQualifiedIdentifier(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<LeftParenthesisSeparatorToken>> result_2 = evaluateLeftParenthesisSeparatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends DelimitedList<IElementValuePairNode, SourceToken<CommaSeparatorToken>>> result_3 = evaluateNormalAnnotationExpression_1(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightParenthesisSeparatorToken>> result_4 = evaluateRightParenthesisSeparatorToken(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    INormalAnnotationNode node = new NormalAnnotationNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value);
    return new EvaluationResult<INormalAnnotationNode>(true, result_4.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IElementValuePairNode> evaluateElementValuePairExpression_0(int position) {
    EvaluationResult<? extends SourceToken<IdentifierToken>> result_0 = evaluateIdentifierToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<EqualsOperatorToken>> result_1 = evaluateEqualsOperatorToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IElementValueNode> result_2 = parseElementValue(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    IElementValuePairNode node = new ElementValuePairNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<IElementValuePairNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ISingleElementAnnotationNode> evaluateSingleElementAnnotationExpression_0(int position) {
    EvaluationResult<? extends SourceToken<AtSeparatorToken>> result_0 = evaluateAtSeparatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IQualifiedIdentifierNode> result_1 = parseQualifiedIdentifier(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<LeftParenthesisSeparatorToken>> result_2 = evaluateLeftParenthesisSeparatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IElementValueNode> result_3 = parseElementValue(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightParenthesisSeparatorToken>> result_4 = evaluateRightParenthesisSeparatorToken(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    ISingleElementAnnotationNode node = new SingleElementAnnotationNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value);
    return new EvaluationResult<ISingleElementAnnotationNode>(true, result_4.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IMarkerAnnotationNode> evaluateMarkerAnnotationExpression_0(int position) {
    EvaluationResult<? extends SourceToken<AtSeparatorToken>> result_0 = evaluateAtSeparatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IQualifiedIdentifierNode> result_1 = parseQualifiedIdentifier(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    IMarkerAnnotationNode node = new MarkerAnnotationNode(result_0.value, result_1.value);
    return new EvaluationResult<IMarkerAnnotationNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IElementValueNode> evaluateElementValueExpression_0(int position) {
    EvaluationResult<? extends IElementValueNode> result;
    if ((result = parseAnnotation(position)).succeeded) { return result; }
    if ((result = parseExpression(position)).succeeded) { return result; }
    return parseElementValueArrayInitializer(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends DelimitedList<IElementValueNode, SourceToken<CommaSeparatorToken>>> evaluateElementValueArrayInitializerExpression_0(int position) {
    ArrayList<IElementValueNode> elements = null;
    ArrayList<SourceToken<CommaSeparatorToken> > delimiters = null;
    EvaluationResult<? extends IElementValueNode> result = parseElementValue(position);
    if (!result.succeeded) { return EvaluationResult.failure(); }
    elements = addValue(elements, result.value);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult<? extends SourceToken<CommaSeparatorToken>> delimiterResult = evaluateCommaSeparatorToken(currentPosition);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult<DelimitedList<IElementValueNode, SourceToken<CommaSeparatorToken>>>(true, currentPosition, new ArrayDelimitedList<IElementValueNode, SourceToken<CommaSeparatorToken>>(trimList(elements), trimList(delimiters)));
      }

      result = parseElementValue(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult<DelimitedList<IElementValueNode, SourceToken<CommaSeparatorToken>>>(true, currentPosition, new ArrayDelimitedList<IElementValueNode, SourceToken<CommaSeparatorToken>>(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result.value);
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends DelimitedList<IElementValueNode, SourceToken<CommaSeparatorToken>>> evaluateElementValueArrayInitializerExpression_1(int position) {
    EvaluationResult<? extends DelimitedList<IElementValueNode, SourceToken<CommaSeparatorToken>>> result;
    if ((result = evaluateElementValueArrayInitializerExpression_0(position)).succeeded) { return result; }
    return new EvaluationResult<DelimitedList<IElementValueNode, SourceToken<CommaSeparatorToken>>>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IElementValueArrayInitializerNode> evaluateElementValueArrayInitializerExpression_2(int position) {
    EvaluationResult<? extends SourceToken<LeftCurlySeparatorToken>> result_0 = evaluateLeftCurlySeparatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends DelimitedList<IElementValueNode, SourceToken<CommaSeparatorToken>>> result_1 = evaluateElementValueArrayInitializerExpression_1(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<CommaSeparatorToken>> result_2 = evaluateEnumBodyExpression_2(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightCurlySeparatorToken>> result_3 = evaluateRightCurlySeparatorToken(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    IElementValueArrayInitializerNode node = new ElementValueArrayInitializerNode(result_0.value, result_1.value, result_2.value, result_3.value);
    return new EvaluationResult<IElementValueArrayInitializerNode>(true, result_3.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends List<IBlockStatementNode>> evaluateBlockExpression_0(int position) {
    int currentPosition = position;
    ArrayList<IBlockStatementNode> values = null;
    while (true) {
      EvaluationResult<? extends IBlockStatementNode> result = parseBlockStatement(currentPosition);
      if (result.succeeded) {
        currentPosition = result.position;
        values = addValue(values, result.value);
      } else {
        return new EvaluationResult<List<IBlockStatementNode>>(true, currentPosition, trimList(values));
      }
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IBlockNode> evaluateBlockExpression_1(int position) {
    EvaluationResult<? extends SourceToken<LeftCurlySeparatorToken>> result_0 = evaluateLeftCurlySeparatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends List<IBlockStatementNode>> result_1 = evaluateBlockExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightCurlySeparatorToken>> result_2 = evaluateRightCurlySeparatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    IBlockNode node = new BlockNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<IBlockNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IBlockStatementNode> evaluateBlockStatementExpression_0(int position) {
    EvaluationResult<? extends IBlockStatementNode> result;
    if ((result = parseLocalVariableDeclarationStatement(position)).succeeded) { return result; }
    if ((result = parseClassDeclaration(position)).succeeded) { return result; }
    return parseStatement(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ILocalVariableDeclarationStatementNode> evaluateLocalVariableDeclarationStatementExpression_0(int position) {
    EvaluationResult<? extends ILocalVariableDeclarationNode> result_0 = parseLocalVariableDeclaration(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<SemicolonSeparatorToken>> result_1 = evaluateSemicolonSeparatorToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    ILocalVariableDeclarationStatementNode node = new LocalVariableDeclarationStatementNode(result_0.value, result_1.value);
    return new EvaluationResult<ILocalVariableDeclarationStatementNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ILocalVariableDeclarationNode> evaluateLocalVariableDeclarationExpression_0(int position) {
    EvaluationResult<? extends IModifiersNode> result_0 = parseModifiers(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends ITypeNode> result_1 = parseType(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends DelimitedList<IVariableDeclaratorNode, SourceToken<CommaSeparatorToken>>> result_2 = evaluateFieldDeclarationExpression_0(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    ILocalVariableDeclarationNode node = new LocalVariableDeclarationNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<ILocalVariableDeclarationNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IStatementNode> evaluateStatementExpression_0(int position) {
    EvaluationResult<? extends IStatementNode> result;
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
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<ColonOperatorToken>> evaluateColonOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (ColonOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<ColonOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ILabeledStatementNode> evaluateLabeledStatementExpression_0(int position) {
    EvaluationResult<? extends SourceToken<IdentifierToken>> result_0 = evaluateIdentifierToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<ColonOperatorToken>> result_1 = evaluateColonOperatorToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IStatementNode> result_2 = parseStatement(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    ILabeledStatementNode node = new LabeledStatementNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<ILabeledStatementNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IExpressionStatementNode> evaluateExpressionStatementExpression_0(int position) {
    EvaluationResult<? extends IExpressionNode> result_0 = parseExpression(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<SemicolonSeparatorToken>> result_1 = evaluateSemicolonSeparatorToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    IExpressionStatementNode node = new ExpressionStatementNode(result_0.value, result_1.value);
    return new EvaluationResult<IExpressionStatementNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<IfKeywordToken>> evaluateIfKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (IfKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<IfKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IElseStatementNode> evaluateIfStatementExpression_0(int position) {
    EvaluationResult<? extends IElseStatementNode> result;
    if ((result = parseElseStatement(position)).succeeded) { return result; }
    return new EvaluationResult<IElseStatementNode>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IIfStatementNode> evaluateIfStatementExpression_1(int position) {
    EvaluationResult<? extends SourceToken<IfKeywordToken>> result_0 = evaluateIfKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<LeftParenthesisSeparatorToken>> result_1 = evaluateLeftParenthesisSeparatorToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExpressionNode> result_2 = parseExpression(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightParenthesisSeparatorToken>> result_3 = evaluateRightParenthesisSeparatorToken(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IStatementNode> result_4 = parseStatement(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IElseStatementNode> result_5 = evaluateIfStatementExpression_0(result_4.position);
    if (!result_5.succeeded) { return EvaluationResult.failure(); }

    IIfStatementNode node = new IfStatementNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value, result_5.value);
    return new EvaluationResult<IIfStatementNode>(true, result_5.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<ElseKeywordToken>> evaluateElseKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (ElseKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<ElseKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IElseStatementNode> evaluateElseStatementExpression_0(int position) {
    EvaluationResult<? extends SourceToken<ElseKeywordToken>> result_0 = evaluateElseKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IStatementNode> result_1 = parseStatement(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    IElseStatementNode node = new ElseStatementNode(result_0.value, result_1.value);
    return new EvaluationResult<IElseStatementNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IAssertStatementNode> evaluateAssertStatementExpression_0(int position) {
    EvaluationResult<? extends IAssertStatementNode> result;
    if ((result = parseMessageAssertStatement(position)).succeeded) { return result; }
    return parseSimpleAssertStatement(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<AssertKeywordToken>> evaluateAssertKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (AssertKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<AssertKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IMessageAssertStatementNode> evaluateMessageAssertStatementExpression_0(int position) {
    EvaluationResult<? extends SourceToken<AssertKeywordToken>> result_0 = evaluateAssertKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExpressionNode> result_1 = parseExpression(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<ColonOperatorToken>> result_2 = evaluateColonOperatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExpressionNode> result_3 = parseExpression(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<SemicolonSeparatorToken>> result_4 = evaluateSemicolonSeparatorToken(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    IMessageAssertStatementNode node = new MessageAssertStatementNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value);
    return new EvaluationResult<IMessageAssertStatementNode>(true, result_4.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ISimpleAssertStatementNode> evaluateSimpleAssertStatementExpression_0(int position) {
    EvaluationResult<? extends SourceToken<AssertKeywordToken>> result_0 = evaluateAssertKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExpressionNode> result_1 = parseExpression(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<SemicolonSeparatorToken>> result_2 = evaluateSemicolonSeparatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    ISimpleAssertStatementNode node = new SimpleAssertStatementNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<ISimpleAssertStatementNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<SwitchKeywordToken>> evaluateSwitchKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (SwitchKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<SwitchKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends List<ISwitchBlockStatementGroupNode>> evaluateSwitchStatementExpression_0(int position) {
    int currentPosition = position;
    ArrayList<ISwitchBlockStatementGroupNode> values = null;
    while (true) {
      EvaluationResult<? extends ISwitchBlockStatementGroupNode> result = parseSwitchBlockStatementGroup(currentPosition);
      if (result.succeeded) {
        currentPosition = result.position;
        values = addValue(values, result.value);
      } else {
        return new EvaluationResult<List<ISwitchBlockStatementGroupNode>>(true, currentPosition, trimList(values));
      }
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends List<ISwitchLabelNode>> evaluateSwitchStatementExpression_1(int position) {
    int currentPosition = position;
    ArrayList<ISwitchLabelNode> values = null;
    while (true) {
      EvaluationResult<? extends ISwitchLabelNode> result = parseSwitchLabel(currentPosition);
      if (result.succeeded) {
        currentPosition = result.position;
        values = addValue(values, result.value);
      } else {
        return new EvaluationResult<List<ISwitchLabelNode>>(true, currentPosition, trimList(values));
      }
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ISwitchStatementNode> evaluateSwitchStatementExpression_2(int position) {
    EvaluationResult<? extends SourceToken<SwitchKeywordToken>> result_0 = evaluateSwitchKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<LeftParenthesisSeparatorToken>> result_1 = evaluateLeftParenthesisSeparatorToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExpressionNode> result_2 = parseExpression(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightParenthesisSeparatorToken>> result_3 = evaluateRightParenthesisSeparatorToken(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<LeftCurlySeparatorToken>> result_4 = evaluateLeftCurlySeparatorToken(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends List<ISwitchBlockStatementGroupNode>> result_5 = evaluateSwitchStatementExpression_0(result_4.position);
    if (!result_5.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends List<ISwitchLabelNode>> result_6 = evaluateSwitchStatementExpression_1(result_5.position);
    if (!result_6.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightCurlySeparatorToken>> result_7 = evaluateRightCurlySeparatorToken(result_6.position);
    if (!result_7.succeeded) { return EvaluationResult.failure(); }

    ISwitchStatementNode node = new SwitchStatementNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value, result_5.value, result_6.value, result_7.value);
    return new EvaluationResult<ISwitchStatementNode>(true, result_7.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends List<ISwitchLabelNode>> evaluateSwitchBlockStatementGroupExpression_0(int position) {
    ArrayList<ISwitchLabelNode> values = null;
    EvaluationResult<? extends ISwitchLabelNode> result = parseSwitchLabel(position);
    if (!result.succeeded) {
      return EvaluationResult.failure();
    }
    while (true) {
      int currentPosition = result.position;
      values = addValue(values, result.value);
      result = parseSwitchLabel(currentPosition);
      if (!result.succeeded) {
        return new EvaluationResult<List<ISwitchLabelNode>>(true, currentPosition, trimList(values));
      }
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends List<IBlockStatementNode>> evaluateSwitchBlockStatementGroupExpression_1(int position) {
    ArrayList<IBlockStatementNode> values = null;
    EvaluationResult<? extends IBlockStatementNode> result = parseBlockStatement(position);
    if (!result.succeeded) {
      return EvaluationResult.failure();
    }
    while (true) {
      int currentPosition = result.position;
      values = addValue(values, result.value);
      result = parseBlockStatement(currentPosition);
      if (!result.succeeded) {
        return new EvaluationResult<List<IBlockStatementNode>>(true, currentPosition, trimList(values));
      }
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ISwitchBlockStatementGroupNode> evaluateSwitchBlockStatementGroupExpression_2(int position) {
    EvaluationResult<? extends List<ISwitchLabelNode>> result_0 = evaluateSwitchBlockStatementGroupExpression_0(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends List<IBlockStatementNode>> result_1 = evaluateSwitchBlockStatementGroupExpression_1(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    ISwitchBlockStatementGroupNode node = new SwitchBlockStatementGroupNode(result_0.value, result_1.value);
    return new EvaluationResult<ISwitchBlockStatementGroupNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ISwitchLabelNode> evaluateSwitchLabelExpression_0(int position) {
    EvaluationResult<? extends ISwitchLabelNode> result;
    if ((result = parseCaseSwitchLabel(position)).succeeded) { return result; }
    return parseDefaultSwitchLabel(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<CaseKeywordToken>> evaluateCaseKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (CaseKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<CaseKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ICaseSwitchLabelNode> evaluateCaseSwitchLabelExpression_0(int position) {
    EvaluationResult<? extends SourceToken<CaseKeywordToken>> result_0 = evaluateCaseKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExpressionNode> result_1 = parseExpression(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<ColonOperatorToken>> result_2 = evaluateColonOperatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    ICaseSwitchLabelNode node = new CaseSwitchLabelNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<ICaseSwitchLabelNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IDefaultSwitchLabelNode> evaluateDefaultSwitchLabelExpression_0(int position) {
    EvaluationResult<? extends SourceToken<DefaultKeywordToken>> result_0 = evaluateDefaultKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<ColonOperatorToken>> result_1 = evaluateColonOperatorToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    IDefaultSwitchLabelNode node = new DefaultSwitchLabelNode(result_0.value, result_1.value);
    return new EvaluationResult<IDefaultSwitchLabelNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<WhileKeywordToken>> evaluateWhileKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (WhileKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<WhileKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IWhileStatementNode> evaluateWhileStatementExpression_0(int position) {
    EvaluationResult<? extends SourceToken<WhileKeywordToken>> result_0 = evaluateWhileKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<LeftParenthesisSeparatorToken>> result_1 = evaluateLeftParenthesisSeparatorToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExpressionNode> result_2 = parseExpression(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightParenthesisSeparatorToken>> result_3 = evaluateRightParenthesisSeparatorToken(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IStatementNode> result_4 = parseStatement(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    IWhileStatementNode node = new WhileStatementNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value);
    return new EvaluationResult<IWhileStatementNode>(true, result_4.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<DoKeywordToken>> evaluateDoKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (DoKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<DoKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IDoStatementNode> evaluateDoStatementExpression_0(int position) {
    EvaluationResult<? extends SourceToken<DoKeywordToken>> result_0 = evaluateDoKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IStatementNode> result_1 = parseStatement(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<WhileKeywordToken>> result_2 = evaluateWhileKeywordToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<LeftParenthesisSeparatorToken>> result_3 = evaluateLeftParenthesisSeparatorToken(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExpressionNode> result_4 = parseExpression(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightParenthesisSeparatorToken>> result_5 = evaluateRightParenthesisSeparatorToken(result_4.position);
    if (!result_5.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<SemicolonSeparatorToken>> result_6 = evaluateSemicolonSeparatorToken(result_5.position);
    if (!result_6.succeeded) { return EvaluationResult.failure(); }

    IDoStatementNode node = new DoStatementNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value, result_5.value, result_6.value);
    return new EvaluationResult<IDoStatementNode>(true, result_6.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IForStatementNode> evaluateForStatementExpression_0(int position) {
    EvaluationResult<? extends IForStatementNode> result;
    if ((result = parseBasicForStatement(position)).succeeded) { return result; }
    return parseEnhancedForStatement(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<ForKeywordToken>> evaluateForKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (ForKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<ForKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IForInitializerNode> evaluateBasicForStatementExpression_0(int position) {
    EvaluationResult<? extends IForInitializerNode> result;
    if ((result = parseForInitializer(position)).succeeded) { return result; }
    return new EvaluationResult<IForInitializerNode>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IExpressionNode> evaluateBasicForStatementExpression_1(int position) {
    EvaluationResult<? extends IExpressionNode> result;
    if ((result = parseExpression(position)).succeeded) { return result; }
    return new EvaluationResult<IExpressionNode>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IBasicForStatementNode> evaluateBasicForStatementExpression_2(int position) {
    EvaluationResult<? extends SourceToken<ForKeywordToken>> result_0 = evaluateForKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<LeftParenthesisSeparatorToken>> result_1 = evaluateLeftParenthesisSeparatorToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IForInitializerNode> result_2 = evaluateBasicForStatementExpression_0(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<SemicolonSeparatorToken>> result_3 = evaluateSemicolonSeparatorToken(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExpressionNode> result_4 = evaluateBasicForStatementExpression_1(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<SemicolonSeparatorToken>> result_5 = evaluateSemicolonSeparatorToken(result_4.position);
    if (!result_5.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IDelimitedExpressionListNode> result_6 = evaluateArgumentsExpression_0(result_5.position);
    if (!result_6.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightParenthesisSeparatorToken>> result_7 = evaluateRightParenthesisSeparatorToken(result_6.position);
    if (!result_7.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IStatementNode> result_8 = parseStatement(result_7.position);
    if (!result_8.succeeded) { return EvaluationResult.failure(); }

    IBasicForStatementNode node = new BasicForStatementNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value, result_5.value, result_6.value, result_7.value, result_8.value);
    return new EvaluationResult<IBasicForStatementNode>(true, result_8.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IForInitializerNode> evaluateForInitializerExpression_0(int position) {
    EvaluationResult<? extends IForInitializerNode> result;
    if ((result = parseLocalVariableDeclaration(position)).succeeded) { return result; }
    return parseDelimitedExpressionList(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IDelimitedExpressionListNode> evaluateDelimitedExpressionListExpression_0(int position) {
    ArrayList<IExpressionNode> elements = null;
    ArrayList<SourceToken<CommaSeparatorToken> > delimiters = null;
    EvaluationResult<? extends IExpressionNode> result = parseExpression(position);
    if (!result.succeeded) { return EvaluationResult.failure(); }
    elements = addValue(elements, result.value);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult<? extends SourceToken<CommaSeparatorToken>> delimiterResult = evaluateCommaSeparatorToken(currentPosition);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult<IDelimitedExpressionListNode>(true, currentPosition, new DelimitedExpressionListNode(new ArrayDelimitedList<IExpressionNode, SourceToken<CommaSeparatorToken>>(trimList(elements), trimList(delimiters))));
      }

      result = parseExpression(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult<IDelimitedExpressionListNode>(true, currentPosition, new DelimitedExpressionListNode(new ArrayDelimitedList<IExpressionNode, SourceToken<CommaSeparatorToken>>(trimList(elements), trimList(delimiters))));
      }
      elements = addValue(elements, result.value);
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IEnhancedForStatementNode> evaluateEnhancedForStatementExpression_0(int position) {
    EvaluationResult<? extends SourceToken<ForKeywordToken>> result_0 = evaluateForKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<LeftParenthesisSeparatorToken>> result_1 = evaluateLeftParenthesisSeparatorToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IModifiersNode> result_2 = parseModifiers(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends ITypeNode> result_3 = parseType(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<IdentifierToken>> result_4 = evaluateIdentifierToken(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<ColonOperatorToken>> result_5 = evaluateColonOperatorToken(result_4.position);
    if (!result_5.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExpressionNode> result_6 = parseExpression(result_5.position);
    if (!result_6.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightParenthesisSeparatorToken>> result_7 = evaluateRightParenthesisSeparatorToken(result_6.position);
    if (!result_7.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IStatementNode> result_8 = parseStatement(result_7.position);
    if (!result_8.succeeded) { return EvaluationResult.failure(); }

    IEnhancedForStatementNode node = new EnhancedForStatementNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value, result_5.value, result_6.value, result_7.value, result_8.value);
    return new EvaluationResult<IEnhancedForStatementNode>(true, result_8.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<BreakKeywordToken>> evaluateBreakKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (BreakKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<BreakKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<IdentifierToken>> evaluateBreakStatementExpression_0(int position) {
    EvaluationResult<? extends SourceToken<IdentifierToken>> result;
    if ((result = evaluateIdentifierToken(position)).succeeded) { return result; }
    return new EvaluationResult<SourceToken<IdentifierToken>>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IBreakStatementNode> evaluateBreakStatementExpression_1(int position) {
    EvaluationResult<? extends SourceToken<BreakKeywordToken>> result_0 = evaluateBreakKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<IdentifierToken>> result_1 = evaluateBreakStatementExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<SemicolonSeparatorToken>> result_2 = evaluateSemicolonSeparatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    IBreakStatementNode node = new BreakStatementNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<IBreakStatementNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<ContinueKeywordToken>> evaluateContinueKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (ContinueKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<ContinueKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IContinueStatementNode> evaluateContinueStatementExpression_0(int position) {
    EvaluationResult<? extends SourceToken<ContinueKeywordToken>> result_0 = evaluateContinueKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<IdentifierToken>> result_1 = evaluateBreakStatementExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<SemicolonSeparatorToken>> result_2 = evaluateSemicolonSeparatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    IContinueStatementNode node = new ContinueStatementNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<IContinueStatementNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<ReturnKeywordToken>> evaluateReturnKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (ReturnKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<ReturnKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IReturnStatementNode> evaluateReturnStatementExpression_0(int position) {
    EvaluationResult<? extends SourceToken<ReturnKeywordToken>> result_0 = evaluateReturnKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExpressionNode> result_1 = evaluateBasicForStatementExpression_1(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<SemicolonSeparatorToken>> result_2 = evaluateSemicolonSeparatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    IReturnStatementNode node = new ReturnStatementNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<IReturnStatementNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<ThrowKeywordToken>> evaluateThrowKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (ThrowKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<ThrowKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IThrowStatementNode> evaluateThrowStatementExpression_0(int position) {
    EvaluationResult<? extends SourceToken<ThrowKeywordToken>> result_0 = evaluateThrowKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExpressionNode> result_1 = evaluateBasicForStatementExpression_1(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<SemicolonSeparatorToken>> result_2 = evaluateSemicolonSeparatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    IThrowStatementNode node = new ThrowStatementNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<IThrowStatementNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ISynchronizedStatementNode> evaluateSynchronizedStatementExpression_0(int position) {
    EvaluationResult<? extends SourceToken<SynchronizedKeywordToken>> result_0 = evaluateSynchronizedKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<LeftParenthesisSeparatorToken>> result_1 = evaluateLeftParenthesisSeparatorToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExpressionNode> result_2 = parseExpression(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightParenthesisSeparatorToken>> result_3 = evaluateRightParenthesisSeparatorToken(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IBlockNode> result_4 = parseBlock(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    ISynchronizedStatementNode node = new SynchronizedStatementNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value);
    return new EvaluationResult<ISynchronizedStatementNode>(true, result_4.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ITryStatementNode> evaluateTryStatementExpression_0(int position) {
    EvaluationResult<? extends ITryStatementNode> result;
    if ((result = parseTryStatementWithFinally(position)).succeeded) { return result; }
    return parseTryStatementWithoutFinally(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<TryKeywordToken>> evaluateTryKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (TryKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<TryKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends List<ICatchClauseNode>> evaluateTryStatementWithFinallyExpression_0(int position) {
    int currentPosition = position;
    ArrayList<ICatchClauseNode> values = null;
    while (true) {
      EvaluationResult<? extends ICatchClauseNode> result = parseCatchClause(currentPosition);
      if (result.succeeded) {
        currentPosition = result.position;
        values = addValue(values, result.value);
      } else {
        return new EvaluationResult<List<ICatchClauseNode>>(true, currentPosition, trimList(values));
      }
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<FinallyKeywordToken>> evaluateFinallyKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (FinallyKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<FinallyKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ITryStatementWithFinallyNode> evaluateTryStatementWithFinallyExpression_1(int position) {
    EvaluationResult<? extends SourceToken<TryKeywordToken>> result_0 = evaluateTryKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IBlockNode> result_1 = parseBlock(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends List<ICatchClauseNode>> result_2 = evaluateTryStatementWithFinallyExpression_0(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<FinallyKeywordToken>> result_3 = evaluateFinallyKeywordToken(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IBlockNode> result_4 = parseBlock(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    ITryStatementWithFinallyNode node = new TryStatementWithFinallyNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value);
    return new EvaluationResult<ITryStatementWithFinallyNode>(true, result_4.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends List<ICatchClauseNode>> evaluateTryStatementWithoutFinallyExpression_0(int position) {
    ArrayList<ICatchClauseNode> values = null;
    EvaluationResult<? extends ICatchClauseNode> result = parseCatchClause(position);
    if (!result.succeeded) {
      return EvaluationResult.failure();
    }
    while (true) {
      int currentPosition = result.position;
      values = addValue(values, result.value);
      result = parseCatchClause(currentPosition);
      if (!result.succeeded) {
        return new EvaluationResult<List<ICatchClauseNode>>(true, currentPosition, trimList(values));
      }
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ITryStatementWithoutFinallyNode> evaluateTryStatementWithoutFinallyExpression_1(int position) {
    EvaluationResult<? extends SourceToken<TryKeywordToken>> result_0 = evaluateTryKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IBlockNode> result_1 = parseBlock(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends List<ICatchClauseNode>> result_2 = evaluateTryStatementWithoutFinallyExpression_0(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    ITryStatementWithoutFinallyNode node = new TryStatementWithoutFinallyNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<ITryStatementWithoutFinallyNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<CatchKeywordToken>> evaluateCatchKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (CatchKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<CatchKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ICatchClauseNode> evaluateCatchClauseExpression_0(int position) {
    EvaluationResult<? extends SourceToken<CatchKeywordToken>> result_0 = evaluateCatchKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<LeftParenthesisSeparatorToken>> result_1 = evaluateLeftParenthesisSeparatorToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IFormalParameterNode> result_2 = parseFormalParameter(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightParenthesisSeparatorToken>> result_3 = evaluateRightParenthesisSeparatorToken(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IBlockNode> result_4 = parseBlock(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    ICatchClauseNode node = new CatchClauseNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value);
    return new EvaluationResult<ICatchClauseNode>(true, result_4.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IExpressionNode> evaluateExpressionExpression_0(int position) {
    ArrayList<IExpression1Node> elements = null;
    ArrayList<IAssignmentOperatorNode > delimiters = null;
    EvaluationResult<? extends IExpression1Node> result = parseExpression1(position);
    if (!result.succeeded) { return EvaluationResult.failure(); }
    elements = addValue(elements, result.value);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult<? extends IAssignmentOperatorNode> delimiterResult = parseAssignmentOperator(currentPosition);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult<IExpressionNode>(true, currentPosition, new ExpressionNode(new ArrayDelimitedList<IExpression1Node, IAssignmentOperatorNode>(trimList(elements), trimList(delimiters))));
      }

      result = parseExpression1(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult<IExpressionNode>(true, currentPosition, new ExpressionNode(new ArrayDelimitedList<IExpression1Node, IAssignmentOperatorNode>(trimList(elements), trimList(delimiters))));
      }
      elements = addValue(elements, result.value);
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<PlusEqualsOperatorToken>> evaluatePlusEqualsOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (PlusEqualsOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<PlusEqualsOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<MinusEqualsOperatorToken>> evaluateMinusEqualsOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (MinusEqualsOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<MinusEqualsOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<TimesEqualsOperatorToken>> evaluateTimesEqualsOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (TimesEqualsOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<TimesEqualsOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<DivideEqualsOperatorToken>> evaluateDivideEqualsOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (DivideEqualsOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<DivideEqualsOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<AndEqualsOperatorToken>> evaluateAndEqualsOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (AndEqualsOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<AndEqualsOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<OrEqualsOperatorToken>> evaluateOrEqualsOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (OrEqualsOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<OrEqualsOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<ExclusiveOrEqualsOperatorToken>> evaluateExclusiveOrEqualsOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (ExclusiveOrEqualsOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<ExclusiveOrEqualsOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<ModulusEqualsOperatorToken>> evaluateModulusEqualsOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (ModulusEqualsOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<ModulusEqualsOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<LeftShiftEqualsOperatorToken>> evaluateLeftShiftEqualsOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (LeftShiftEqualsOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<LeftShiftEqualsOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<RightShiftEqualsOperatorToken>> evaluateRightShiftEqualsOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (RightShiftEqualsOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<RightShiftEqualsOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<BitwiseRightShiftEqualsOperatorToken>> evaluateBitwiseRightShiftEqualsOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (BitwiseRightShiftEqualsOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<BitwiseRightShiftEqualsOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IAssignmentOperatorNode> evaluateAssignmentOperatorExpression_0(int position) {
    EvaluationResult<? extends IAssignmentOperatorNode> result;
    if ((result = boxEqualsOperatorToken(evaluateEqualsOperatorToken(position))).succeeded) { return result; }
    if ((result = boxPlusEqualsOperatorToken(evaluatePlusEqualsOperatorToken(position))).succeeded) { return result; }
    if ((result = boxMinusEqualsOperatorToken(evaluateMinusEqualsOperatorToken(position))).succeeded) { return result; }
    if ((result = boxTimesEqualsOperatorToken(evaluateTimesEqualsOperatorToken(position))).succeeded) { return result; }
    if ((result = boxDivideEqualsOperatorToken(evaluateDivideEqualsOperatorToken(position))).succeeded) { return result; }
    if ((result = boxAndEqualsOperatorToken(evaluateAndEqualsOperatorToken(position))).succeeded) { return result; }
    if ((result = boxOrEqualsOperatorToken(evaluateOrEqualsOperatorToken(position))).succeeded) { return result; }
    if ((result = boxExclusiveOrEqualsOperatorToken(evaluateExclusiveOrEqualsOperatorToken(position))).succeeded) { return result; }
    if ((result = boxModulusEqualsOperatorToken(evaluateModulusEqualsOperatorToken(position))).succeeded) { return result; }
    if ((result = boxLeftShiftEqualsOperatorToken(evaluateLeftShiftEqualsOperatorToken(position))).succeeded) { return result; }
    if ((result = boxRightShiftEqualsOperatorToken(evaluateRightShiftEqualsOperatorToken(position))).succeeded) { return result; }
    return boxBitwiseRightShiftEqualsOperatorToken(evaluateBitwiseRightShiftEqualsOperatorToken(position));
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IExpression1Node> evaluateExpression1Expression_0(int position) {
    EvaluationResult<? extends IExpression1Node> result;
    if ((result = parseTernaryExpression(position)).succeeded) { return result; }
    return parseExpression2(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ITernaryExpressionNode> evaluateTernaryExpressionExpression_0(int position) {
    EvaluationResult<? extends IExpression2Node> result_0 = parseExpression2(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<QuestionMarkOperatorToken>> result_1 = evaluateQuestionMarkOperatorToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExpressionNode> result_2 = parseExpression(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<ColonOperatorToken>> result_3 = evaluateColonOperatorToken(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExpression1Node> result_4 = parseExpression1(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    ITernaryExpressionNode node = new TernaryExpressionNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value);
    return new EvaluationResult<ITernaryExpressionNode>(true, result_4.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IExpression2Node> evaluateExpression2Expression_0(int position) {
    EvaluationResult<? extends IExpression2Node> result;
    if ((result = parseBinaryExpression(position)).succeeded) { return result; }
    return parseExpression3(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends List<IBinaryExpressionRestNode>> evaluateBinaryExpressionExpression_0(int position) {
    ArrayList<IBinaryExpressionRestNode> values = null;
    EvaluationResult<? extends IBinaryExpressionRestNode> result = parseBinaryExpressionRest(position);
    if (!result.succeeded) {
      return EvaluationResult.failure();
    }
    while (true) {
      int currentPosition = result.position;
      values = addValue(values, result.value);
      result = parseBinaryExpressionRest(currentPosition);
      if (!result.succeeded) {
        return new EvaluationResult<List<IBinaryExpressionRestNode>>(true, currentPosition, trimList(values));
      }
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IBinaryExpressionNode> evaluateBinaryExpressionExpression_1(int position) {
    EvaluationResult<? extends IExpression3Node> result_0 = parseExpression3(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends List<IBinaryExpressionRestNode>> result_1 = evaluateBinaryExpressionExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    IBinaryExpressionNode node = new BinaryExpressionNode(result_0.value, result_1.value);
    return new EvaluationResult<IBinaryExpressionNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IBinaryExpressionRestNode> evaluateBinaryExpressionRestExpression_0(int position) {
    EvaluationResult<? extends IBinaryExpressionRestNode> result;
    if ((result = parseInfixOperatorBinaryExpressionRest(position)).succeeded) { return result; }
    return parseInstanceofOperatorBinaryExpressionRest(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IInfixOperatorBinaryExpressionRestNode> evaluateInfixOperatorBinaryExpressionRestExpression_0(int position) {
    EvaluationResult<? extends IInfixOperatorNode> result_0 = parseInfixOperator(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExpression3Node> result_1 = parseExpression3(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    IInfixOperatorBinaryExpressionRestNode node = new InfixOperatorBinaryExpressionRestNode(result_0.value, result_1.value);
    return new EvaluationResult<IInfixOperatorBinaryExpressionRestNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<InstanceofKeywordToken>> evaluateInstanceofKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (InstanceofKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<InstanceofKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IInstanceofOperatorBinaryExpressionRestNode> evaluateInstanceofOperatorBinaryExpressionRestExpression_0(int position) {
    EvaluationResult<? extends SourceToken<InstanceofKeywordToken>> result_0 = evaluateInstanceofKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends ITypeNode> result_1 = parseType(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    IInstanceofOperatorBinaryExpressionRestNode node = new InstanceofOperatorBinaryExpressionRestNode(result_0.value, result_1.value);
    return new EvaluationResult<IInstanceofOperatorBinaryExpressionRestNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<LogicalOrOperatorToken>> evaluateLogicalOrOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (LogicalOrOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<LogicalOrOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<LogicalAndOperatorToken>> evaluateLogicalAndOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (LogicalAndOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<LogicalAndOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<BitwiseOrOperatorToken>> evaluateBitwiseOrOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (BitwiseOrOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<BitwiseOrOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<BitwiseExclusiveOrOperatorToken>> evaluateBitwiseExclusiveOrOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (BitwiseExclusiveOrOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<BitwiseExclusiveOrOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<EqualsEqualsOperatorToken>> evaluateEqualsEqualsOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (EqualsEqualsOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<EqualsEqualsOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<NotEqualsOperatorToken>> evaluateNotEqualsOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (NotEqualsOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<NotEqualsOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<LessThanOrEqualsOperatorToken>> evaluateLessThanOrEqualsOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (LessThanOrEqualsOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<LessThanOrEqualsOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<GreaterThanOrEqualsOperatorToken>> evaluateGreaterThanOrEqualsOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (GreaterThanOrEqualsOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<GreaterThanOrEqualsOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<LeftShiftOperatorToken>> evaluateLeftShiftOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (LeftShiftOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<LeftShiftOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<PlusOperatorToken>> evaluatePlusOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (PlusOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<PlusOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<MinusOperatorToken>> evaluateMinusOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (MinusOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<MinusOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<DivideOperatorToken>> evaluateDivideOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (DivideOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<DivideOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<ModulusOperatorToken>> evaluateModulusOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (ModulusOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<ModulusOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IInfixOperatorNode> evaluateInfixOperatorExpression_0(int position) {
    EvaluationResult<? extends IInfixOperatorNode> result;
    if ((result = boxLogicalOrOperatorToken(evaluateLogicalOrOperatorToken(position))).succeeded) { return result; }
    if ((result = boxLogicalAndOperatorToken(evaluateLogicalAndOperatorToken(position))).succeeded) { return result; }
    if ((result = boxBitwiseOrOperatorToken(evaluateBitwiseOrOperatorToken(position))).succeeded) { return result; }
    if ((result = boxBitwiseExclusiveOrOperatorToken(evaluateBitwiseExclusiveOrOperatorToken(position))).succeeded) { return result; }
    if ((result = boxBitwiseAndOperatorToken(evaluateBitwiseAndOperatorToken(position))).succeeded) { return result; }
    if ((result = boxEqualsEqualsOperatorToken(evaluateEqualsEqualsOperatorToken(position))).succeeded) { return result; }
    if ((result = boxNotEqualsOperatorToken(evaluateNotEqualsOperatorToken(position))).succeeded) { return result; }
    if ((result = boxLessThanOperatorToken(evaluateLessThanOperatorToken(position))).succeeded) { return result; }
    if ((result = boxLessThanOrEqualsOperatorToken(evaluateLessThanOrEqualsOperatorToken(position))).succeeded) { return result; }
    if ((result = boxGreaterThanOrEqualsOperatorToken(evaluateGreaterThanOrEqualsOperatorToken(position))).succeeded) { return result; }
    if ((result = boxLeftShiftOperatorToken(evaluateLeftShiftOperatorToken(position))).succeeded) { return result; }
    if ((result = parseUnsignedRightShift(position)).succeeded) { return result; }
    if ((result = parseSignedRightShift(position)).succeeded) { return result; }
    if ((result = boxGreaterThanOperatorToken(evaluateGreaterThanOperatorToken(position))).succeeded) { return result; }
    if ((result = boxPlusOperatorToken(evaluatePlusOperatorToken(position))).succeeded) { return result; }
    if ((result = boxMinusOperatorToken(evaluateMinusOperatorToken(position))).succeeded) { return result; }
    if ((result = boxTimesOperatorToken(evaluateTimesOperatorToken(position))).succeeded) { return result; }
    if ((result = boxDivideOperatorToken(evaluateDivideOperatorToken(position))).succeeded) { return result; }
    return boxModulusOperatorToken(evaluateModulusOperatorToken(position));
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IUnsignedRightShiftNode> evaluateUnsignedRightShiftExpression_0(int position) {
    EvaluationResult<? extends SourceToken<GreaterThanOperatorToken>> result_0 = evaluateGreaterThanOperatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<GreaterThanOperatorToken>> result_1 = evaluateGreaterThanOperatorToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<GreaterThanOperatorToken>> result_2 = evaluateGreaterThanOperatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    IUnsignedRightShiftNode node = new UnsignedRightShiftNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<IUnsignedRightShiftNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ISignedRightShiftNode> evaluateSignedRightShiftExpression_0(int position) {
    EvaluationResult<? extends SourceToken<GreaterThanOperatorToken>> result_0 = evaluateGreaterThanOperatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<GreaterThanOperatorToken>> result_1 = evaluateGreaterThanOperatorToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    ISignedRightShiftNode node = new SignedRightShiftNode(result_0.value, result_1.value);
    return new EvaluationResult<ISignedRightShiftNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IExpression3Node> evaluateExpression3Expression_0(int position) {
    EvaluationResult<? extends IExpression3Node> result;
    if ((result = parsePrefixExpression(position)).succeeded) { return result; }
    if ((result = parsePossibleCastExpression(position)).succeeded) { return result; }
    return parsePrimaryExpression(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IPrefixExpressionNode> evaluatePrefixExpressionExpression_0(int position) {
    EvaluationResult<? extends IPrefixOperatorNode> result_0 = parsePrefixOperator(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExpression3Node> result_1 = parseExpression3(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    IPrefixExpressionNode node = new PrefixExpressionNode(result_0.value, result_1.value);
    return new EvaluationResult<IPrefixExpressionNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<IncrementOperatorToken>> evaluateIncrementOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (IncrementOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<IncrementOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<DecrementOperatorToken>> evaluateDecrementOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (DecrementOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<DecrementOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<LogicalNotOperatorToken>> evaluateLogicalNotOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (LogicalNotOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<LogicalNotOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<BitwiseNotOperatorToken>> evaluateBitwiseNotOperatorToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (BitwiseNotOperatorToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<BitwiseNotOperatorToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IPrefixOperatorNode> evaluatePrefixOperatorExpression_0(int position) {
    EvaluationResult<? extends IPrefixOperatorNode> result;
    if ((result = boxIncrementOperatorToken(evaluateIncrementOperatorToken(position))).succeeded) { return result; }
    if ((result = boxDecrementOperatorToken(evaluateDecrementOperatorToken(position))).succeeded) { return result; }
    if ((result = boxLogicalNotOperatorToken(evaluateLogicalNotOperatorToken(position))).succeeded) { return result; }
    if ((result = boxBitwiseNotOperatorToken(evaluateBitwiseNotOperatorToken(position))).succeeded) { return result; }
    if ((result = boxPlusOperatorToken(evaluatePlusOperatorToken(position))).succeeded) { return result; }
    return boxMinusOperatorToken(evaluateMinusOperatorToken(position));
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IPossibleCastExpressionNode> evaluatePossibleCastExpressionExpression_0(int position) {
    EvaluationResult<? extends IPossibleCastExpressionNode> result;
    if ((result = parsePossibleCastExpression_Type(position)).succeeded) { return result; }
    return parsePossibleCastExpression_Expression(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IPossibleCastExpression_TypeNode> evaluatePossibleCastExpression_TypeExpression_0(int position) {
    EvaluationResult<? extends SourceToken<LeftParenthesisSeparatorToken>> result_0 = evaluateLeftParenthesisSeparatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends ITypeNode> result_1 = parseType(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightParenthesisSeparatorToken>> result_2 = evaluateRightParenthesisSeparatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExpression3Node> result_3 = parseExpression3(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    IPossibleCastExpression_TypeNode node = new PossibleCastExpression_TypeNode(result_0.value, result_1.value, result_2.value, result_3.value);
    return new EvaluationResult<IPossibleCastExpression_TypeNode>(true, result_3.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IPossibleCastExpression_ExpressionNode> evaluatePossibleCastExpression_ExpressionExpression_0(int position) {
    EvaluationResult<? extends SourceToken<LeftParenthesisSeparatorToken>> result_0 = evaluateLeftParenthesisSeparatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExpressionNode> result_1 = parseExpression(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightParenthesisSeparatorToken>> result_2 = evaluateRightParenthesisSeparatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExpression3Node> result_3 = parseExpression3(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    IPossibleCastExpression_ExpressionNode node = new PossibleCastExpression_ExpressionNode(result_0.value, result_1.value, result_2.value, result_3.value);
    return new EvaluationResult<IPossibleCastExpression_ExpressionNode>(true, result_3.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends List<ISelectorNode>> evaluatePrimaryExpressionExpression_0(int position) {
    int currentPosition = position;
    ArrayList<ISelectorNode> values = null;
    while (true) {
      EvaluationResult<? extends ISelectorNode> result = parseSelector(currentPosition);
      if (result.succeeded) {
        currentPosition = result.position;
        values = addValue(values, result.value);
      } else {
        return new EvaluationResult<List<ISelectorNode>>(true, currentPosition, trimList(values));
      }
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IPostfixOperatorNode> evaluatePrimaryExpressionExpression_1(int position) {
    EvaluationResult<? extends IPostfixOperatorNode> result;
    if ((result = parsePostfixOperator(position)).succeeded) { return result; }
    return new EvaluationResult<IPostfixOperatorNode>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IPrimaryExpressionNode> evaluatePrimaryExpressionExpression_2(int position) {
    EvaluationResult<? extends IValueExpressionNode> result_0 = parseValueExpression(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends List<ISelectorNode>> result_1 = evaluatePrimaryExpressionExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IPostfixOperatorNode> result_2 = evaluatePrimaryExpressionExpression_1(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    IPrimaryExpressionNode node = new PrimaryExpressionNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<IPrimaryExpressionNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IPostfixOperatorNode> evaluatePostfixOperatorExpression_0(int position) {
    EvaluationResult<? extends IPostfixOperatorNode> result;
    if ((result = boxIncrementOperatorToken(evaluateIncrementOperatorToken(position))).succeeded) { return result; }
    return boxDecrementOperatorToken(evaluateDecrementOperatorToken(position));
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<ThisKeywordToken>> evaluateThisKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (ThisKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<ThisKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }

  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<LiteralToken>> evaluateLiteralToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      switch (token.getToken().getType()) {
        case 54:
        case 55:
        case 56:
        case 57:
        case 58:
        case 59:
        case 60:
          return new EvaluationResult<SourceToken<LiteralToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IValueExpressionNode> evaluateValueExpressionExpression_0(int position) {
    EvaluationResult<? extends IValueExpressionNode> result;
    if ((result = parseParenthesizedExpression(position)).succeeded) { return result; }
    if ((result = parseMethodInvocation(position)).succeeded) { return result; }
    if ((result = parseThisConstructorInvocation(position)).succeeded) { return result; }
    if ((result = parseSuperConstructorInvocation(position)).succeeded) { return result; }
    if ((result = boxThisKeywordToken(evaluateThisKeywordToken(position))).succeeded) { return result; }
    if ((result = boxSuperKeywordToken(evaluateSuperKeywordToken(position))).succeeded) { return result; }
    if ((result = parseClassAccess(position)).succeeded) { return result; }
    if ((result = boxLiteralToken(evaluateLiteralToken(position))).succeeded) { return result; }
    if ((result = boxIdentifierToken(evaluateIdentifierToken(position))).succeeded) { return result; }
    return parseCreationExpression(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IClassAccessNode> evaluateClassAccessExpression_0(int position) {
    EvaluationResult<? extends ITypeNode> result_0 = parseType(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<DotSeparatorToken>> result_1 = evaluateDotSeparatorToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<ClassKeywordToken>> result_2 = evaluateClassKeywordToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    IClassAccessNode node = new ClassAccessNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<IClassAccessNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ISelectorNode> evaluateSelectorExpression_0(int position) {
    EvaluationResult<? extends ISelectorNode> result;
    if ((result = parseDotSelector(position)).succeeded) { return result; }
    return parseArraySelector(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IDotSelectorNode> evaluateDotSelectorExpression_0(int position) {
    EvaluationResult<? extends SourceToken<DotSeparatorToken>> result_0 = evaluateDotSeparatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IValueExpressionNode> result_1 = parseValueExpression(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    IDotSelectorNode node = new DotSelectorNode(result_0.value, result_1.value);
    return new EvaluationResult<IDotSelectorNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IArraySelectorNode> evaluateArraySelectorExpression_0(int position) {
    EvaluationResult<? extends SourceToken<LeftBracketSeparatorToken>> result_0 = evaluateLeftBracketSeparatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExpressionNode> result_1 = parseExpression(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightBracketSeparatorToken>> result_2 = evaluateRightBracketSeparatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    IArraySelectorNode node = new ArraySelectorNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<IArraySelectorNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IParenthesizedExpressionNode> evaluateParenthesizedExpressionExpression_0(int position) {
    EvaluationResult<? extends SourceToken<LeftParenthesisSeparatorToken>> result_0 = evaluateLeftParenthesisSeparatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExpressionNode> result_1 = parseExpression(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightParenthesisSeparatorToken>> result_2 = evaluateRightParenthesisSeparatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    IParenthesizedExpressionNode node = new ParenthesizedExpressionNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<IParenthesizedExpressionNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends INonWildcardTypeArgumentsNode> evaluateMethodInvocationExpression_0(int position) {
    EvaluationResult<? extends INonWildcardTypeArgumentsNode> result;
    if ((result = parseNonWildcardTypeArguments(position)).succeeded) { return result; }
    return new EvaluationResult<INonWildcardTypeArgumentsNode>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IMethodInvocationNode> evaluateMethodInvocationExpression_1(int position) {
    EvaluationResult<? extends INonWildcardTypeArgumentsNode> result_0 = evaluateMethodInvocationExpression_0(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<IdentifierToken>> result_1 = evaluateIdentifierToken(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IArgumentsNode> result_2 = parseArguments(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    IMethodInvocationNode node = new MethodInvocationNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<IMethodInvocationNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IThisConstructorInvocationNode> evaluateThisConstructorInvocationExpression_0(int position) {
    EvaluationResult<? extends SourceToken<ThisKeywordToken>> result_0 = evaluateThisKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IArgumentsNode> result_1 = parseArguments(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    IThisConstructorInvocationNode node = new ThisConstructorInvocationNode(result_0.value, result_1.value);
    return new EvaluationResult<IThisConstructorInvocationNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ISuperConstructorInvocationNode> evaluateSuperConstructorInvocationExpression_0(int position) {
    EvaluationResult<? extends SourceToken<SuperKeywordToken>> result_0 = evaluateSuperKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IArgumentsNode> result_1 = parseArguments(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    ISuperConstructorInvocationNode node = new SuperConstructorInvocationNode(result_0.value, result_1.value);
    return new EvaluationResult<ISuperConstructorInvocationNode>(true, result_1.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends ICreationExpressionNode> evaluateCreationExpressionExpression_0(int position) {
    EvaluationResult<? extends ICreationExpressionNode> result;
    if ((result = parseObjectCreationExpression(position)).succeeded) { return result; }
    return parseArrayCreationExpression(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends SourceToken<NewKeywordToken>> evaluateNewKeywordToken(int position) {
    if (position < tokens.size()) {
      SourceToken token = tokens.get(position);
      if (NewKeywordToken.instance.equals(token.getToken())) {
        return new EvaluationResult<SourceToken<NewKeywordToken>>(true, position + 1, token);
      }
    }
    return EvaluationResult.failure();
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IClassBodyNode> evaluateObjectCreationExpressionExpression_0(int position) {
    EvaluationResult<? extends IClassBodyNode> result;
    if ((result = parseClassBody(position)).succeeded) { return result; }
    return new EvaluationResult<IClassBodyNode>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IObjectCreationExpressionNode> evaluateObjectCreationExpressionExpression_1(int position) {
    EvaluationResult<? extends SourceToken<NewKeywordToken>> result_0 = evaluateNewKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends INonWildcardTypeArgumentsNode> result_1 = evaluateMethodInvocationExpression_0(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IClassOrInterfaceTypeNode> result_2 = parseClassOrInterfaceType(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IArgumentsNode> result_3 = parseArguments(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IClassBodyNode> result_4 = evaluateObjectCreationExpressionExpression_0(result_3.position);
    if (!result_4.succeeded) { return EvaluationResult.failure(); }

    IObjectCreationExpressionNode node = new ObjectCreationExpressionNode(result_0.value, result_1.value, result_2.value, result_3.value, result_4.value);
    return new EvaluationResult<IObjectCreationExpressionNode>(true, result_4.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends List<IDimensionExpressionNode>> evaluateArrayCreationExpressionExpression_0(int position) {
    ArrayList<IDimensionExpressionNode> values = null;
    EvaluationResult<? extends IDimensionExpressionNode> result = parseDimensionExpression(position);
    if (!result.succeeded) {
      return EvaluationResult.failure();
    }
    while (true) {
      int currentPosition = result.position;
      values = addValue(values, result.value);
      result = parseDimensionExpression(currentPosition);
      if (!result.succeeded) {
        return new EvaluationResult<List<IDimensionExpressionNode>>(true, currentPosition, trimList(values));
      }
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IArrayInitializerNode> evaluateArrayCreationExpressionExpression_1(int position) {
    EvaluationResult<? extends IArrayInitializerNode> result;
    if ((result = parseArrayInitializer(position)).succeeded) { return result; }
    return new EvaluationResult<IArrayInitializerNode>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IArrayCreationExpressionNode> evaluateArrayCreationExpressionExpression_2(int position) {
    EvaluationResult<? extends SourceToken<NewKeywordToken>> result_0 = evaluateNewKeywordToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IArrayCreationTypeNode> result_1 = parseArrayCreationType(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends List<IDimensionExpressionNode>> result_2 = evaluateArrayCreationExpressionExpression_0(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IArrayInitializerNode> result_3 = evaluateArrayCreationExpressionExpression_1(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    IArrayCreationExpressionNode node = new ArrayCreationExpressionNode(result_0.value, result_1.value, result_2.value, result_3.value);
    return new EvaluationResult<IArrayCreationExpressionNode>(true, result_3.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IArrayCreationTypeNode> evaluateArrayCreationTypeExpression_0(int position) {
    EvaluationResult<? extends IArrayCreationTypeNode> result;
    if ((result = parseClassOrInterfaceType(position)).succeeded) { return result; }
    return parsePrimitiveType(position);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IDimensionExpressionNode> evaluateDimensionExpressionExpression_0(int position) {
    EvaluationResult<? extends SourceToken<LeftBracketSeparatorToken>> result_0 = evaluateLeftBracketSeparatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends IExpressionNode> result_1 = evaluateBasicForStatementExpression_1(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightBracketSeparatorToken>> result_2 = evaluateRightBracketSeparatorToken(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    IDimensionExpressionNode node = new DimensionExpressionNode(result_0.value, result_1.value, result_2.value);
    return new EvaluationResult<IDimensionExpressionNode>(true, result_2.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends DelimitedList<IVariableInitializerNode, SourceToken<CommaSeparatorToken>>> evaluateArrayInitializerExpression_0(int position) {
    ArrayList<IVariableInitializerNode> elements = null;
    ArrayList<SourceToken<CommaSeparatorToken> > delimiters = null;
    EvaluationResult<? extends IVariableInitializerNode> result = parseVariableInitializer(position);
    if (!result.succeeded) { return EvaluationResult.failure(); }
    elements = addValue(elements, result.value);
    while (true) {
      int currentPosition = result.position;

      EvaluationResult<? extends SourceToken<CommaSeparatorToken>> delimiterResult = evaluateCommaSeparatorToken(currentPosition);
      if (!delimiterResult.succeeded) {
        return new EvaluationResult<DelimitedList<IVariableInitializerNode, SourceToken<CommaSeparatorToken>>>(true, currentPosition, new ArrayDelimitedList<IVariableInitializerNode, SourceToken<CommaSeparatorToken>>(trimList(elements), trimList(delimiters)));
      }

      result = parseVariableInitializer(delimiterResult.position);
      if (!result.succeeded) {
        return new EvaluationResult<DelimitedList<IVariableInitializerNode, SourceToken<CommaSeparatorToken>>>(true, currentPosition, new ArrayDelimitedList<IVariableInitializerNode, SourceToken<CommaSeparatorToken>>(trimList(elements), trimList(delimiters)));
      }
      elements = addValue(elements, result.value);
    }
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends DelimitedList<IVariableInitializerNode, SourceToken<CommaSeparatorToken>>> evaluateArrayInitializerExpression_1(int position) {
    EvaluationResult<? extends DelimitedList<IVariableInitializerNode, SourceToken<CommaSeparatorToken>>> result;
    if ((result = evaluateArrayInitializerExpression_0(position)).succeeded) { return result; }
    return new EvaluationResult<DelimitedList<IVariableInitializerNode, SourceToken<CommaSeparatorToken>>>(true, position, null);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IArrayInitializerNode> evaluateArrayInitializerExpression_2(int position) {
    EvaluationResult<? extends SourceToken<LeftCurlySeparatorToken>> result_0 = evaluateLeftCurlySeparatorToken(position);
    if (!result_0.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends DelimitedList<IVariableInitializerNode, SourceToken<CommaSeparatorToken>>> result_1 = evaluateArrayInitializerExpression_1(result_0.position);
    if (!result_1.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<CommaSeparatorToken>> result_2 = evaluateEnumBodyExpression_2(result_1.position);
    if (!result_2.succeeded) { return EvaluationResult.failure(); }

    EvaluationResult<? extends SourceToken<RightCurlySeparatorToken>> result_3 = evaluateRightCurlySeparatorToken(result_2.position);
    if (!result_3.succeeded) { return EvaluationResult.failure(); }

    IArrayInitializerNode node = new ArrayInitializerNode(result_0.value, result_1.value, result_2.value, result_3.value);
    return new EvaluationResult<IArrayInitializerNode>(true, result_3.position, node);
  }
  @SuppressWarnings("unchecked")
  private EvaluationResult<? extends IVariableInitializerNode> evaluateVariableInitializerExpression_0(int position) {
    EvaluationResult<? extends IVariableInitializerNode> result;
    if ((result = parseArrayInitializer(position)).succeeded) { return result; }
    return parseExpression(position);
  }

  private Map<Integer,EvaluationResult<? extends ICompilationUnitNode>> CompilationUnitMap;
  private EvaluationResult<? extends ICompilationUnitNode> parseCompilationUnit(int position) {
    EvaluationResult<? extends ICompilationUnitNode> result = (CompilationUnitMap == null ? null : CompilationUnitMap.get(position));
    if (result == null) {
      result = evaluateCompilationUnitExpression_4(position);
      CompilationUnitMap = initializeMap(CompilationUnitMap);
      CompilationUnitMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IPackageDeclarationNode>> PackageDeclarationMap;
  private EvaluationResult<? extends IPackageDeclarationNode> parsePackageDeclaration(int position) {
    EvaluationResult<? extends IPackageDeclarationNode> result = (PackageDeclarationMap == null ? null : PackageDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_PackageDeclaration(position)) {
        result = evaluatePackageDeclarationExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      PackageDeclarationMap = initializeMap(PackageDeclarationMap);
      PackageDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IQualifiedIdentifierNode>> QualifiedIdentifierMap;
  private EvaluationResult<? extends IQualifiedIdentifierNode> parseQualifiedIdentifier(int position) {
    EvaluationResult<? extends IQualifiedIdentifierNode> result = (QualifiedIdentifierMap == null ? null : QualifiedIdentifierMap.get(position));
    if (result == null) {
      if (checkToken_QualifiedIdentifier(position)) {
        result = evaluateQualifiedIdentifierExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      QualifiedIdentifierMap = initializeMap(QualifiedIdentifierMap);
      QualifiedIdentifierMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IImportDeclarationNode>> ImportDeclarationMap;
  private EvaluationResult<? extends IImportDeclarationNode> parseImportDeclaration(int position) {
    EvaluationResult<? extends IImportDeclarationNode> result = (ImportDeclarationMap == null ? null : ImportDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_ImportDeclaration(position)) {
        result = evaluateImportDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ImportDeclarationMap = initializeMap(ImportDeclarationMap);
      ImportDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ISingleTypeImportDeclarationNode>> SingleTypeImportDeclarationMap;
  private EvaluationResult<? extends ISingleTypeImportDeclarationNode> parseSingleTypeImportDeclaration(int position) {
    EvaluationResult<? extends ISingleTypeImportDeclarationNode> result = (SingleTypeImportDeclarationMap == null ? null : SingleTypeImportDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_SingleTypeImportDeclaration(position)) {
        result = evaluateSingleTypeImportDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      SingleTypeImportDeclarationMap = initializeMap(SingleTypeImportDeclarationMap);
      SingleTypeImportDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ITypeImportOnDemandDeclarationNode>> TypeImportOnDemandDeclarationMap;
  private EvaluationResult<? extends ITypeImportOnDemandDeclarationNode> parseTypeImportOnDemandDeclaration(int position) {
    EvaluationResult<? extends ITypeImportOnDemandDeclarationNode> result = (TypeImportOnDemandDeclarationMap == null ? null : TypeImportOnDemandDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_TypeImportOnDemandDeclaration(position)) {
        result = evaluateTypeImportOnDemandDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      TypeImportOnDemandDeclarationMap = initializeMap(TypeImportOnDemandDeclarationMap);
      TypeImportOnDemandDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ISingleStaticImportDeclarationNode>> SingleStaticImportDeclarationMap;
  private EvaluationResult<? extends ISingleStaticImportDeclarationNode> parseSingleStaticImportDeclaration(int position) {
    EvaluationResult<? extends ISingleStaticImportDeclarationNode> result = (SingleStaticImportDeclarationMap == null ? null : SingleStaticImportDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_SingleStaticImportDeclaration(position)) {
        result = evaluateSingleStaticImportDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      SingleStaticImportDeclarationMap = initializeMap(SingleStaticImportDeclarationMap);
      SingleStaticImportDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IStaticImportOnDemandDeclarationNode>> StaticImportOnDemandDeclarationMap;
  private EvaluationResult<? extends IStaticImportOnDemandDeclarationNode> parseStaticImportOnDemandDeclaration(int position) {
    EvaluationResult<? extends IStaticImportOnDemandDeclarationNode> result = (StaticImportOnDemandDeclarationMap == null ? null : StaticImportOnDemandDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_StaticImportOnDemandDeclaration(position)) {
        result = evaluateStaticImportOnDemandDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      StaticImportOnDemandDeclarationMap = initializeMap(StaticImportOnDemandDeclarationMap);
      StaticImportOnDemandDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ITypeDeclarationNode>> TypeDeclarationMap;
  private EvaluationResult<? extends ITypeDeclarationNode> parseTypeDeclaration(int position) {
    EvaluationResult<? extends ITypeDeclarationNode> result = (TypeDeclarationMap == null ? null : TypeDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_TypeDeclaration(position)) {
        result = evaluateTypeDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      TypeDeclarationMap = initializeMap(TypeDeclarationMap);
      TypeDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IClassDeclarationNode>> ClassDeclarationMap;
  private EvaluationResult<? extends IClassDeclarationNode> parseClassDeclaration(int position) {
    EvaluationResult<? extends IClassDeclarationNode> result = (ClassDeclarationMap == null ? null : ClassDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_ClassDeclaration(position)) {
        result = evaluateClassDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ClassDeclarationMap = initializeMap(ClassDeclarationMap);
      ClassDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends INormalClassDeclarationNode>> NormalClassDeclarationMap;
  private EvaluationResult<? extends INormalClassDeclarationNode> parseNormalClassDeclaration(int position) {
    EvaluationResult<? extends INormalClassDeclarationNode> result = (NormalClassDeclarationMap == null ? null : NormalClassDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_NormalClassDeclaration(position)) {
        result = evaluateNormalClassDeclarationExpression_3(position);
      } else {
        result = EvaluationResult.failure();
      }
      NormalClassDeclarationMap = initializeMap(NormalClassDeclarationMap);
      NormalClassDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IModifiersNode>> ModifiersMap;
  private EvaluationResult<? extends IModifiersNode> parseModifiers(int position) {
    EvaluationResult<? extends IModifiersNode> result = (ModifiersMap == null ? null : ModifiersMap.get(position));
    if (result == null) {
      result = evaluateModifiersExpression_0(position);
      ModifiersMap = initializeMap(ModifiersMap);
      ModifiersMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IModifierNode>> ModifierMap;
  private EvaluationResult<? extends IModifierNode> parseModifier(int position) {
    EvaluationResult<? extends IModifierNode> result = (ModifierMap == null ? null : ModifierMap.get(position));
    if (result == null) {
      if (checkToken_Modifier(position)) {
        result = evaluateModifierExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ModifierMap = initializeMap(ModifierMap);
      ModifierMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ISuperNode>> SuperMap;
  private EvaluationResult<? extends ISuperNode> parseSuper(int position) {
    EvaluationResult<? extends ISuperNode> result = (SuperMap == null ? null : SuperMap.get(position));
    if (result == null) {
      if (checkToken_Super(position)) {
        result = evaluateSuperExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      SuperMap = initializeMap(SuperMap);
      SuperMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IInterfacesNode>> InterfacesMap;
  private EvaluationResult<? extends IInterfacesNode> parseInterfaces(int position) {
    EvaluationResult<? extends IInterfacesNode> result = (InterfacesMap == null ? null : InterfacesMap.get(position));
    if (result == null) {
      if (checkToken_Interfaces(position)) {
        result = evaluateInterfacesExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      InterfacesMap = initializeMap(InterfacesMap);
      InterfacesMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IClassBodyNode>> ClassBodyMap;
  private EvaluationResult<? extends IClassBodyNode> parseClassBody(int position) {
    EvaluationResult<? extends IClassBodyNode> result = (ClassBodyMap == null ? null : ClassBodyMap.get(position));
    if (result == null) {
      if (checkToken_ClassBody(position)) {
        result = evaluateClassBodyExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      ClassBodyMap = initializeMap(ClassBodyMap);
      ClassBodyMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IClassBodyDeclarationNode>> ClassBodyDeclarationMap;
  private EvaluationResult<? extends IClassBodyDeclarationNode> parseClassBodyDeclaration(int position) {
    EvaluationResult<? extends IClassBodyDeclarationNode> result = (ClassBodyDeclarationMap == null ? null : ClassBodyDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_ClassBodyDeclaration(position)) {
        result = evaluateClassBodyDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ClassBodyDeclarationMap = initializeMap(ClassBodyDeclarationMap);
      ClassBodyDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IStaticInitializerNode>> StaticInitializerMap;
  private EvaluationResult<? extends IStaticInitializerNode> parseStaticInitializer(int position) {
    EvaluationResult<? extends IStaticInitializerNode> result = (StaticInitializerMap == null ? null : StaticInitializerMap.get(position));
    if (result == null) {
      if (checkToken_StaticInitializer(position)) {
        result = evaluateStaticInitializerExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      StaticInitializerMap = initializeMap(StaticInitializerMap);
      StaticInitializerMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IInterfaceDeclarationNode>> InterfaceDeclarationMap;
  private EvaluationResult<? extends IInterfaceDeclarationNode> parseInterfaceDeclaration(int position) {
    EvaluationResult<? extends IInterfaceDeclarationNode> result = (InterfaceDeclarationMap == null ? null : InterfaceDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_InterfaceDeclaration(position)) {
        result = evaluateInterfaceDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      InterfaceDeclarationMap = initializeMap(InterfaceDeclarationMap);
      InterfaceDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends INormalInterfaceDeclarationNode>> NormalInterfaceDeclarationMap;
  private EvaluationResult<? extends INormalInterfaceDeclarationNode> parseNormalInterfaceDeclaration(int position) {
    EvaluationResult<? extends INormalInterfaceDeclarationNode> result = (NormalInterfaceDeclarationMap == null ? null : NormalInterfaceDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_NormalInterfaceDeclaration(position)) {
        result = evaluateNormalInterfaceDeclarationExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      NormalInterfaceDeclarationMap = initializeMap(NormalInterfaceDeclarationMap);
      NormalInterfaceDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IExtendsInterfacesNode>> ExtendsInterfacesMap;
  private EvaluationResult<? extends IExtendsInterfacesNode> parseExtendsInterfaces(int position) {
    EvaluationResult<? extends IExtendsInterfacesNode> result = (ExtendsInterfacesMap == null ? null : ExtendsInterfacesMap.get(position));
    if (result == null) {
      if (checkToken_ExtendsInterfaces(position)) {
        result = evaluateExtendsInterfacesExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ExtendsInterfacesMap = initializeMap(ExtendsInterfacesMap);
      ExtendsInterfacesMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IClassOrInterfaceBodyNode>> ClassOrInterfaceBodyMap;
  private EvaluationResult<? extends IClassOrInterfaceBodyNode> parseClassOrInterfaceBody(int position) {
    EvaluationResult<? extends IClassOrInterfaceBodyNode> result = (ClassOrInterfaceBodyMap == null ? null : ClassOrInterfaceBodyMap.get(position));
    if (result == null) {
      if (checkToken_ClassOrInterfaceBody(position)) {
        result = evaluateClassOrInterfaceBodyExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      ClassOrInterfaceBodyMap = initializeMap(ClassOrInterfaceBodyMap);
      ClassOrInterfaceBodyMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IEnumDeclarationNode>> EnumDeclarationMap;
  private EvaluationResult<? extends IEnumDeclarationNode> parseEnumDeclaration(int position) {
    EvaluationResult<? extends IEnumDeclarationNode> result = (EnumDeclarationMap == null ? null : EnumDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_EnumDeclaration(position)) {
        result = evaluateEnumDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      EnumDeclarationMap = initializeMap(EnumDeclarationMap);
      EnumDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IEnumBodyNode>> EnumBodyMap;
  private EvaluationResult<? extends IEnumBodyNode> parseEnumBody(int position) {
    EvaluationResult<? extends IEnumBodyNode> result = (EnumBodyMap == null ? null : EnumBodyMap.get(position));
    if (result == null) {
      if (checkToken_EnumBody(position)) {
        result = evaluateEnumBodyExpression_4(position);
      } else {
        result = EvaluationResult.failure();
      }
      EnumBodyMap = initializeMap(EnumBodyMap);
      EnumBodyMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IEnumConstantNode>> EnumConstantMap;
  private EvaluationResult<? extends IEnumConstantNode> parseEnumConstant(int position) {
    EvaluationResult<? extends IEnumConstantNode> result = (EnumConstantMap == null ? null : EnumConstantMap.get(position));
    if (result == null) {
      if (checkToken_EnumConstant(position)) {
        result = evaluateEnumConstantExpression_2(position);
      } else {
        result = EvaluationResult.failure();
      }
      EnumConstantMap = initializeMap(EnumConstantMap);
      EnumConstantMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IArgumentsNode>> ArgumentsMap;
  private EvaluationResult<? extends IArgumentsNode> parseArguments(int position) {
    EvaluationResult<? extends IArgumentsNode> result = (ArgumentsMap == null ? null : ArgumentsMap.get(position));
    if (result == null) {
      if (checkToken_Arguments(position)) {
        result = evaluateArgumentsExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      ArgumentsMap = initializeMap(ArgumentsMap);
      ArgumentsMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IAnnotationDeclarationNode>> AnnotationDeclarationMap;
  private EvaluationResult<? extends IAnnotationDeclarationNode> parseAnnotationDeclaration(int position) {
    EvaluationResult<? extends IAnnotationDeclarationNode> result = (AnnotationDeclarationMap == null ? null : AnnotationDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_AnnotationDeclaration(position)) {
        result = evaluateAnnotationDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      AnnotationDeclarationMap = initializeMap(AnnotationDeclarationMap);
      AnnotationDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IAnnotationBodyNode>> AnnotationBodyMap;
  private EvaluationResult<? extends IAnnotationBodyNode> parseAnnotationBody(int position) {
    EvaluationResult<? extends IAnnotationBodyNode> result = (AnnotationBodyMap == null ? null : AnnotationBodyMap.get(position));
    if (result == null) {
      if (checkToken_AnnotationBody(position)) {
        result = evaluateAnnotationBodyExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      AnnotationBodyMap = initializeMap(AnnotationBodyMap);
      AnnotationBodyMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IAnnotationElementDeclarationNode>> AnnotationElementDeclarationMap;
  private EvaluationResult<? extends IAnnotationElementDeclarationNode> parseAnnotationElementDeclaration(int position) {
    EvaluationResult<? extends IAnnotationElementDeclarationNode> result = (AnnotationElementDeclarationMap == null ? null : AnnotationElementDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_AnnotationElementDeclaration(position)) {
        result = evaluateAnnotationElementDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      AnnotationElementDeclarationMap = initializeMap(AnnotationElementDeclarationMap);
      AnnotationElementDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IAnnotationDefaultDeclarationNode>> AnnotationDefaultDeclarationMap;
  private EvaluationResult<? extends IAnnotationDefaultDeclarationNode> parseAnnotationDefaultDeclaration(int position) {
    EvaluationResult<? extends IAnnotationDefaultDeclarationNode> result = (AnnotationDefaultDeclarationMap == null ? null : AnnotationDefaultDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_AnnotationDefaultDeclaration(position)) {
        result = evaluateAnnotationDefaultDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      AnnotationDefaultDeclarationMap = initializeMap(AnnotationDefaultDeclarationMap);
      AnnotationDefaultDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IClassOrInterfaceMemberDeclarationNode>> ClassOrInterfaceMemberDeclarationMap;
  private EvaluationResult<? extends IClassOrInterfaceMemberDeclarationNode> parseClassOrInterfaceMemberDeclaration(int position) {
    EvaluationResult<? extends IClassOrInterfaceMemberDeclarationNode> result = (ClassOrInterfaceMemberDeclarationMap == null ? null : ClassOrInterfaceMemberDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_ClassOrInterfaceMemberDeclaration(position)) {
        result = evaluateClassOrInterfaceMemberDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ClassOrInterfaceMemberDeclarationMap = initializeMap(ClassOrInterfaceMemberDeclarationMap);
      ClassOrInterfaceMemberDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IConstructorDeclarationNode>> ConstructorDeclarationMap;
  private EvaluationResult<? extends IConstructorDeclarationNode> parseConstructorDeclaration(int position) {
    EvaluationResult<? extends IConstructorDeclarationNode> result = (ConstructorDeclarationMap == null ? null : ConstructorDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_ConstructorDeclaration(position)) {
        result = evaluateConstructorDeclarationExpression_3(position);
      } else {
        result = EvaluationResult.failure();
      }
      ConstructorDeclarationMap = initializeMap(ConstructorDeclarationMap);
      ConstructorDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IFieldDeclarationNode>> FieldDeclarationMap;
  private EvaluationResult<? extends IFieldDeclarationNode> parseFieldDeclaration(int position) {
    EvaluationResult<? extends IFieldDeclarationNode> result = (FieldDeclarationMap == null ? null : FieldDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_FieldDeclaration(position)) {
        result = evaluateFieldDeclarationExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      FieldDeclarationMap = initializeMap(FieldDeclarationMap);
      FieldDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IVariableDeclaratorNode>> VariableDeclaratorMap;
  private EvaluationResult<? extends IVariableDeclaratorNode> parseVariableDeclarator(int position) {
    EvaluationResult<? extends IVariableDeclaratorNode> result = (VariableDeclaratorMap == null ? null : VariableDeclaratorMap.get(position));
    if (result == null) {
      if (checkToken_VariableDeclarator(position)) {
        result = evaluateVariableDeclaratorExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      VariableDeclaratorMap = initializeMap(VariableDeclaratorMap);
      VariableDeclaratorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IVariableDeclaratorIdAndAssignmentNode>> VariableDeclaratorIdAndAssignmentMap;
  private EvaluationResult<? extends IVariableDeclaratorIdAndAssignmentNode> parseVariableDeclaratorIdAndAssignment(int position) {
    EvaluationResult<? extends IVariableDeclaratorIdAndAssignmentNode> result = (VariableDeclaratorIdAndAssignmentMap == null ? null : VariableDeclaratorIdAndAssignmentMap.get(position));
    if (result == null) {
      if (checkToken_VariableDeclaratorIdAndAssignment(position)) {
        result = evaluateVariableDeclaratorIdAndAssignmentExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      VariableDeclaratorIdAndAssignmentMap = initializeMap(VariableDeclaratorIdAndAssignmentMap);
      VariableDeclaratorIdAndAssignmentMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IVariableDeclaratorAssignmentNode>> VariableDeclaratorAssignmentMap;
  private EvaluationResult<? extends IVariableDeclaratorAssignmentNode> parseVariableDeclaratorAssignment(int position) {
    EvaluationResult<? extends IVariableDeclaratorAssignmentNode> result = (VariableDeclaratorAssignmentMap == null ? null : VariableDeclaratorAssignmentMap.get(position));
    if (result == null) {
      if (checkToken_VariableDeclaratorAssignment(position)) {
        result = evaluateVariableDeclaratorAssignmentExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      VariableDeclaratorAssignmentMap = initializeMap(VariableDeclaratorAssignmentMap);
      VariableDeclaratorAssignmentMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IVariableDeclaratorIdNode>> VariableDeclaratorIdMap;
  private EvaluationResult<? extends IVariableDeclaratorIdNode> parseVariableDeclaratorId(int position) {
    EvaluationResult<? extends IVariableDeclaratorIdNode> result = (VariableDeclaratorIdMap == null ? null : VariableDeclaratorIdMap.get(position));
    if (result == null) {
      if (checkToken_VariableDeclaratorId(position)) {
        result = evaluateVariableDeclaratorIdExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      VariableDeclaratorIdMap = initializeMap(VariableDeclaratorIdMap);
      VariableDeclaratorIdMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IBracketPairNode>> BracketPairMap;
  private EvaluationResult<? extends IBracketPairNode> parseBracketPair(int position) {
    EvaluationResult<? extends IBracketPairNode> result = (BracketPairMap == null ? null : BracketPairMap.get(position));
    if (result == null) {
      if (checkToken_BracketPair(position)) {
        result = evaluateBracketPairExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      BracketPairMap = initializeMap(BracketPairMap);
      BracketPairMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IMethodDeclarationNode>> MethodDeclarationMap;
  private EvaluationResult<? extends IMethodDeclarationNode> parseMethodDeclaration(int position) {
    EvaluationResult<? extends IMethodDeclarationNode> result = (MethodDeclarationMap == null ? null : MethodDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_MethodDeclaration(position)) {
        result = evaluateMethodDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      MethodDeclarationMap = initializeMap(MethodDeclarationMap);
      MethodDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IMethodBodyNode>> MethodBodyMap;
  private EvaluationResult<? extends IMethodBodyNode> parseMethodBody(int position) {
    EvaluationResult<? extends IMethodBodyNode> result = (MethodBodyMap == null ? null : MethodBodyMap.get(position));
    if (result == null) {
      if (checkToken_MethodBody(position)) {
        result = evaluateMethodBodyExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      MethodBodyMap = initializeMap(MethodBodyMap);
      MethodBodyMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IFormalParameterNode>> FormalParameterMap;
  private EvaluationResult<? extends IFormalParameterNode> parseFormalParameter(int position) {
    EvaluationResult<? extends IFormalParameterNode> result = (FormalParameterMap == null ? null : FormalParameterMap.get(position));
    if (result == null) {
      if (checkToken_FormalParameter(position)) {
        result = evaluateFormalParameterExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      FormalParameterMap = initializeMap(FormalParameterMap);
      FormalParameterMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IThrowsNode>> ThrowsMap;
  private EvaluationResult<? extends IThrowsNode> parseThrows(int position) {
    EvaluationResult<? extends IThrowsNode> result = (ThrowsMap == null ? null : ThrowsMap.get(position));
    if (result == null) {
      if (checkToken_Throws(position)) {
        result = evaluateThrowsExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ThrowsMap = initializeMap(ThrowsMap);
      ThrowsMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ITypeParametersNode>> TypeParametersMap;
  private EvaluationResult<? extends ITypeParametersNode> parseTypeParameters(int position) {
    EvaluationResult<? extends ITypeParametersNode> result = (TypeParametersMap == null ? null : TypeParametersMap.get(position));
    if (result == null) {
      if (checkToken_TypeParameters(position)) {
        result = evaluateTypeParametersExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      TypeParametersMap = initializeMap(TypeParametersMap);
      TypeParametersMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ITypeParameterNode>> TypeParameterMap;
  private EvaluationResult<? extends ITypeParameterNode> parseTypeParameter(int position) {
    EvaluationResult<? extends ITypeParameterNode> result = (TypeParameterMap == null ? null : TypeParameterMap.get(position));
    if (result == null) {
      if (checkToken_TypeParameter(position)) {
        result = evaluateTypeParameterExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      TypeParameterMap = initializeMap(TypeParameterMap);
      TypeParameterMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ITypeBoundNode>> TypeBoundMap;
  private EvaluationResult<? extends ITypeBoundNode> parseTypeBound(int position) {
    EvaluationResult<? extends ITypeBoundNode> result = (TypeBoundMap == null ? null : TypeBoundMap.get(position));
    if (result == null) {
      if (checkToken_TypeBound(position)) {
        result = evaluateTypeBoundExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      TypeBoundMap = initializeMap(TypeBoundMap);
      TypeBoundMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ITypeNode>> TypeMap;
  private EvaluationResult<? extends ITypeNode> parseType(int position) {
    EvaluationResult<? extends ITypeNode> result = (TypeMap == null ? null : TypeMap.get(position));
    if (result == null) {
      if (checkToken_Type(position)) {
        result = evaluateTypeExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      TypeMap = initializeMap(TypeMap);
      TypeMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IReferenceTypeNode>> ReferenceTypeMap;
  private EvaluationResult<? extends IReferenceTypeNode> parseReferenceType(int position) {
    EvaluationResult<? extends IReferenceTypeNode> result = (ReferenceTypeMap == null ? null : ReferenceTypeMap.get(position));
    if (result == null) {
      if (checkToken_ReferenceType(position)) {
        result = evaluateReferenceTypeExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ReferenceTypeMap = initializeMap(ReferenceTypeMap);
      ReferenceTypeMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IPrimitiveArrayReferenceTypeNode>> PrimitiveArrayReferenceTypeMap;
  private EvaluationResult<? extends IPrimitiveArrayReferenceTypeNode> parsePrimitiveArrayReferenceType(int position) {
    EvaluationResult<? extends IPrimitiveArrayReferenceTypeNode> result = (PrimitiveArrayReferenceTypeMap == null ? null : PrimitiveArrayReferenceTypeMap.get(position));
    if (result == null) {
      if (checkToken_PrimitiveArrayReferenceType(position)) {
        result = evaluatePrimitiveArrayReferenceTypeExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      PrimitiveArrayReferenceTypeMap = initializeMap(PrimitiveArrayReferenceTypeMap);
      PrimitiveArrayReferenceTypeMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IClassOrInterfaceReferenceTypeNode>> ClassOrInterfaceReferenceTypeMap;
  private EvaluationResult<? extends IClassOrInterfaceReferenceTypeNode> parseClassOrInterfaceReferenceType(int position) {
    EvaluationResult<? extends IClassOrInterfaceReferenceTypeNode> result = (ClassOrInterfaceReferenceTypeMap == null ? null : ClassOrInterfaceReferenceTypeMap.get(position));
    if (result == null) {
      if (checkToken_ClassOrInterfaceReferenceType(position)) {
        result = evaluateClassOrInterfaceReferenceTypeExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ClassOrInterfaceReferenceTypeMap = initializeMap(ClassOrInterfaceReferenceTypeMap);
      ClassOrInterfaceReferenceTypeMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IClassOrInterfaceTypeNode>> ClassOrInterfaceTypeMap;
  private EvaluationResult<? extends IClassOrInterfaceTypeNode> parseClassOrInterfaceType(int position) {
    EvaluationResult<? extends IClassOrInterfaceTypeNode> result = (ClassOrInterfaceTypeMap == null ? null : ClassOrInterfaceTypeMap.get(position));
    if (result == null) {
      if (checkToken_ClassOrInterfaceType(position)) {
        result = evaluateClassOrInterfaceTypeExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ClassOrInterfaceTypeMap = initializeMap(ClassOrInterfaceTypeMap);
      ClassOrInterfaceTypeMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ISingleClassOrInterfaceTypeNode>> SingleClassOrInterfaceTypeMap;
  private EvaluationResult<? extends ISingleClassOrInterfaceTypeNode> parseSingleClassOrInterfaceType(int position) {
    EvaluationResult<? extends ISingleClassOrInterfaceTypeNode> result = (SingleClassOrInterfaceTypeMap == null ? null : SingleClassOrInterfaceTypeMap.get(position));
    if (result == null) {
      if (checkToken_SingleClassOrInterfaceType(position)) {
        result = evaluateSingleClassOrInterfaceTypeExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      SingleClassOrInterfaceTypeMap = initializeMap(SingleClassOrInterfaceTypeMap);
      SingleClassOrInterfaceTypeMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ITypeArgumentsNode>> TypeArgumentsMap;
  private EvaluationResult<? extends ITypeArgumentsNode> parseTypeArguments(int position) {
    EvaluationResult<? extends ITypeArgumentsNode> result = (TypeArgumentsMap == null ? null : TypeArgumentsMap.get(position));
    if (result == null) {
      if (checkToken_TypeArguments(position)) {
        result = evaluateTypeArgumentsExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      TypeArgumentsMap = initializeMap(TypeArgumentsMap);
      TypeArgumentsMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ITypeArgumentNode>> TypeArgumentMap;
  private EvaluationResult<? extends ITypeArgumentNode> parseTypeArgument(int position) {
    EvaluationResult<? extends ITypeArgumentNode> result = (TypeArgumentMap == null ? null : TypeArgumentMap.get(position));
    if (result == null) {
      if (checkToken_TypeArgument(position)) {
        result = evaluateTypeArgumentExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      TypeArgumentMap = initializeMap(TypeArgumentMap);
      TypeArgumentMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IWildcardTypeArgumentNode>> WildcardTypeArgumentMap;
  private EvaluationResult<? extends IWildcardTypeArgumentNode> parseWildcardTypeArgument(int position) {
    EvaluationResult<? extends IWildcardTypeArgumentNode> result = (WildcardTypeArgumentMap == null ? null : WildcardTypeArgumentMap.get(position));
    if (result == null) {
      if (checkToken_WildcardTypeArgument(position)) {
        result = evaluateWildcardTypeArgumentExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      WildcardTypeArgumentMap = initializeMap(WildcardTypeArgumentMap);
      WildcardTypeArgumentMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IExtendsWildcardTypeArgumentNode>> ExtendsWildcardTypeArgumentMap;
  private EvaluationResult<? extends IExtendsWildcardTypeArgumentNode> parseExtendsWildcardTypeArgument(int position) {
    EvaluationResult<? extends IExtendsWildcardTypeArgumentNode> result = (ExtendsWildcardTypeArgumentMap == null ? null : ExtendsWildcardTypeArgumentMap.get(position));
    if (result == null) {
      if (checkToken_ExtendsWildcardTypeArgument(position)) {
        result = evaluateExtendsWildcardTypeArgumentExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ExtendsWildcardTypeArgumentMap = initializeMap(ExtendsWildcardTypeArgumentMap);
      ExtendsWildcardTypeArgumentMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ISuperWildcardTypeArgumentNode>> SuperWildcardTypeArgumentMap;
  private EvaluationResult<? extends ISuperWildcardTypeArgumentNode> parseSuperWildcardTypeArgument(int position) {
    EvaluationResult<? extends ISuperWildcardTypeArgumentNode> result = (SuperWildcardTypeArgumentMap == null ? null : SuperWildcardTypeArgumentMap.get(position));
    if (result == null) {
      if (checkToken_SuperWildcardTypeArgument(position)) {
        result = evaluateSuperWildcardTypeArgumentExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      SuperWildcardTypeArgumentMap = initializeMap(SuperWildcardTypeArgumentMap);
      SuperWildcardTypeArgumentMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IOpenWildcardTypeArgumentNode>> OpenWildcardTypeArgumentMap;
  private EvaluationResult<? extends IOpenWildcardTypeArgumentNode> parseOpenWildcardTypeArgument(int position) {
    EvaluationResult<? extends IOpenWildcardTypeArgumentNode> result = (OpenWildcardTypeArgumentMap == null ? null : OpenWildcardTypeArgumentMap.get(position));
    if (result == null) {
      EvaluationResult<? extends SourceToken<QuestionMarkOperatorToken>> subresult = EvaluationResult.failure();
      subresult = evaluateQuestionMarkOperatorToken(position);
      if (subresult.succeeded) {
        result = new EvaluationResult<IOpenWildcardTypeArgumentNode>(true, subresult.position, new OpenWildcardTypeArgumentNode(subresult.value));
      } else {
        result = EvaluationResult.failure();
      }
      OpenWildcardTypeArgumentMap = initializeMap(OpenWildcardTypeArgumentMap);
      OpenWildcardTypeArgumentMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends INonWildcardTypeArgumentsNode>> NonWildcardTypeArgumentsMap;
  private EvaluationResult<? extends INonWildcardTypeArgumentsNode> parseNonWildcardTypeArguments(int position) {
    EvaluationResult<? extends INonWildcardTypeArgumentsNode> result = (NonWildcardTypeArgumentsMap == null ? null : NonWildcardTypeArgumentsMap.get(position));
    if (result == null) {
      if (checkToken_NonWildcardTypeArguments(position)) {
        result = evaluateNonWildcardTypeArgumentsExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      NonWildcardTypeArgumentsMap = initializeMap(NonWildcardTypeArgumentsMap);
      NonWildcardTypeArgumentsMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IPrimitiveTypeNode>> PrimitiveTypeMap;
  private EvaluationResult<? extends IPrimitiveTypeNode> parsePrimitiveType(int position) {
    EvaluationResult<? extends IPrimitiveTypeNode> result = (PrimitiveTypeMap == null ? null : PrimitiveTypeMap.get(position));
    if (result == null) {
      if (checkToken_PrimitiveType(position)) {
        result = evaluatePrimitiveTypeExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      PrimitiveTypeMap = initializeMap(PrimitiveTypeMap);
      PrimitiveTypeMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IAnnotationNode>> AnnotationMap;
  private EvaluationResult<? extends IAnnotationNode> parseAnnotation(int position) {
    EvaluationResult<? extends IAnnotationNode> result = (AnnotationMap == null ? null : AnnotationMap.get(position));
    if (result == null) {
      if (checkToken_Annotation(position)) {
        result = evaluateAnnotationExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      AnnotationMap = initializeMap(AnnotationMap);
      AnnotationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends INormalAnnotationNode>> NormalAnnotationMap;
  private EvaluationResult<? extends INormalAnnotationNode> parseNormalAnnotation(int position) {
    EvaluationResult<? extends INormalAnnotationNode> result = (NormalAnnotationMap == null ? null : NormalAnnotationMap.get(position));
    if (result == null) {
      if (checkToken_NormalAnnotation(position)) {
        result = evaluateNormalAnnotationExpression_2(position);
      } else {
        result = EvaluationResult.failure();
      }
      NormalAnnotationMap = initializeMap(NormalAnnotationMap);
      NormalAnnotationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IElementValuePairNode>> ElementValuePairMap;
  private EvaluationResult<? extends IElementValuePairNode> parseElementValuePair(int position) {
    EvaluationResult<? extends IElementValuePairNode> result = (ElementValuePairMap == null ? null : ElementValuePairMap.get(position));
    if (result == null) {
      if (checkToken_ElementValuePair(position)) {
        result = evaluateElementValuePairExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ElementValuePairMap = initializeMap(ElementValuePairMap);
      ElementValuePairMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ISingleElementAnnotationNode>> SingleElementAnnotationMap;
  private EvaluationResult<? extends ISingleElementAnnotationNode> parseSingleElementAnnotation(int position) {
    EvaluationResult<? extends ISingleElementAnnotationNode> result = (SingleElementAnnotationMap == null ? null : SingleElementAnnotationMap.get(position));
    if (result == null) {
      if (checkToken_SingleElementAnnotation(position)) {
        result = evaluateSingleElementAnnotationExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      SingleElementAnnotationMap = initializeMap(SingleElementAnnotationMap);
      SingleElementAnnotationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IMarkerAnnotationNode>> MarkerAnnotationMap;
  private EvaluationResult<? extends IMarkerAnnotationNode> parseMarkerAnnotation(int position) {
    EvaluationResult<? extends IMarkerAnnotationNode> result = (MarkerAnnotationMap == null ? null : MarkerAnnotationMap.get(position));
    if (result == null) {
      if (checkToken_MarkerAnnotation(position)) {
        result = evaluateMarkerAnnotationExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      MarkerAnnotationMap = initializeMap(MarkerAnnotationMap);
      MarkerAnnotationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IElementValueNode>> ElementValueMap;
  private EvaluationResult<? extends IElementValueNode> parseElementValue(int position) {
    EvaluationResult<? extends IElementValueNode> result = (ElementValueMap == null ? null : ElementValueMap.get(position));
    if (result == null) {
      if (checkToken_ElementValue(position)) {
        result = evaluateElementValueExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ElementValueMap = initializeMap(ElementValueMap);
      ElementValueMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IElementValueArrayInitializerNode>> ElementValueArrayInitializerMap;
  private EvaluationResult<? extends IElementValueArrayInitializerNode> parseElementValueArrayInitializer(int position) {
    EvaluationResult<? extends IElementValueArrayInitializerNode> result = (ElementValueArrayInitializerMap == null ? null : ElementValueArrayInitializerMap.get(position));
    if (result == null) {
      if (checkToken_ElementValueArrayInitializer(position)) {
        result = evaluateElementValueArrayInitializerExpression_2(position);
      } else {
        result = EvaluationResult.failure();
      }
      ElementValueArrayInitializerMap = initializeMap(ElementValueArrayInitializerMap);
      ElementValueArrayInitializerMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IBlockNode>> BlockMap;
  private EvaluationResult<? extends IBlockNode> parseBlock(int position) {
    EvaluationResult<? extends IBlockNode> result = (BlockMap == null ? null : BlockMap.get(position));
    if (result == null) {
      if (checkToken_Block(position)) {
        result = evaluateBlockExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      BlockMap = initializeMap(BlockMap);
      BlockMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IBlockStatementNode>> BlockStatementMap;
  private EvaluationResult<? extends IBlockStatementNode> parseBlockStatement(int position) {
    EvaluationResult<? extends IBlockStatementNode> result = (BlockStatementMap == null ? null : BlockStatementMap.get(position));
    if (result == null) {
      if (checkToken_BlockStatement(position)) {
        result = evaluateBlockStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      BlockStatementMap = initializeMap(BlockStatementMap);
      BlockStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ILocalVariableDeclarationStatementNode>> LocalVariableDeclarationStatementMap;
  private EvaluationResult<? extends ILocalVariableDeclarationStatementNode> parseLocalVariableDeclarationStatement(int position) {
    EvaluationResult<? extends ILocalVariableDeclarationStatementNode> result = (LocalVariableDeclarationStatementMap == null ? null : LocalVariableDeclarationStatementMap.get(position));
    if (result == null) {
      if (checkToken_LocalVariableDeclarationStatement(position)) {
        result = evaluateLocalVariableDeclarationStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      LocalVariableDeclarationStatementMap = initializeMap(LocalVariableDeclarationStatementMap);
      LocalVariableDeclarationStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ILocalVariableDeclarationNode>> LocalVariableDeclarationMap;
  private EvaluationResult<? extends ILocalVariableDeclarationNode> parseLocalVariableDeclaration(int position) {
    EvaluationResult<? extends ILocalVariableDeclarationNode> result = (LocalVariableDeclarationMap == null ? null : LocalVariableDeclarationMap.get(position));
    if (result == null) {
      if (checkToken_LocalVariableDeclaration(position)) {
        result = evaluateLocalVariableDeclarationExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      LocalVariableDeclarationMap = initializeMap(LocalVariableDeclarationMap);
      LocalVariableDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IStatementNode>> StatementMap;
  private EvaluationResult<? extends IStatementNode> parseStatement(int position) {
    EvaluationResult<? extends IStatementNode> result = (StatementMap == null ? null : StatementMap.get(position));
    if (result == null) {
      if (checkToken_Statement(position)) {
        result = evaluateStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      StatementMap = initializeMap(StatementMap);
      StatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IEmptyStatementNode>> EmptyStatementMap;
  private EvaluationResult<? extends IEmptyStatementNode> parseEmptyStatement(int position) {
    EvaluationResult<? extends IEmptyStatementNode> result = (EmptyStatementMap == null ? null : EmptyStatementMap.get(position));
    if (result == null) {
      EvaluationResult<? extends SourceToken<SemicolonSeparatorToken>> subresult = EvaluationResult.failure();
      subresult = evaluateSemicolonSeparatorToken(position);
      if (subresult.succeeded) {
        result = new EvaluationResult<IEmptyStatementNode>(true, subresult.position, new EmptyStatementNode(subresult.value));
      } else {
        result = EvaluationResult.failure();
      }
      EmptyStatementMap = initializeMap(EmptyStatementMap);
      EmptyStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ILabeledStatementNode>> LabeledStatementMap;
  private EvaluationResult<? extends ILabeledStatementNode> parseLabeledStatement(int position) {
    EvaluationResult<? extends ILabeledStatementNode> result = (LabeledStatementMap == null ? null : LabeledStatementMap.get(position));
    if (result == null) {
      if (checkToken_LabeledStatement(position)) {
        result = evaluateLabeledStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      LabeledStatementMap = initializeMap(LabeledStatementMap);
      LabeledStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IExpressionStatementNode>> ExpressionStatementMap;
  private EvaluationResult<? extends IExpressionStatementNode> parseExpressionStatement(int position) {
    EvaluationResult<? extends IExpressionStatementNode> result = (ExpressionStatementMap == null ? null : ExpressionStatementMap.get(position));
    if (result == null) {
      if (checkToken_ExpressionStatement(position)) {
        result = evaluateExpressionStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ExpressionStatementMap = initializeMap(ExpressionStatementMap);
      ExpressionStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IIfStatementNode>> IfStatementMap;
  private EvaluationResult<? extends IIfStatementNode> parseIfStatement(int position) {
    EvaluationResult<? extends IIfStatementNode> result = (IfStatementMap == null ? null : IfStatementMap.get(position));
    if (result == null) {
      if (checkToken_IfStatement(position)) {
        result = evaluateIfStatementExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      IfStatementMap = initializeMap(IfStatementMap);
      IfStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IElseStatementNode>> ElseStatementMap;
  private EvaluationResult<? extends IElseStatementNode> parseElseStatement(int position) {
    EvaluationResult<? extends IElseStatementNode> result = (ElseStatementMap == null ? null : ElseStatementMap.get(position));
    if (result == null) {
      if (checkToken_ElseStatement(position)) {
        result = evaluateElseStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ElseStatementMap = initializeMap(ElseStatementMap);
      ElseStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IAssertStatementNode>> AssertStatementMap;
  private EvaluationResult<? extends IAssertStatementNode> parseAssertStatement(int position) {
    EvaluationResult<? extends IAssertStatementNode> result = (AssertStatementMap == null ? null : AssertStatementMap.get(position));
    if (result == null) {
      if (checkToken_AssertStatement(position)) {
        result = evaluateAssertStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      AssertStatementMap = initializeMap(AssertStatementMap);
      AssertStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IMessageAssertStatementNode>> MessageAssertStatementMap;
  private EvaluationResult<? extends IMessageAssertStatementNode> parseMessageAssertStatement(int position) {
    EvaluationResult<? extends IMessageAssertStatementNode> result = (MessageAssertStatementMap == null ? null : MessageAssertStatementMap.get(position));
    if (result == null) {
      if (checkToken_MessageAssertStatement(position)) {
        result = evaluateMessageAssertStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      MessageAssertStatementMap = initializeMap(MessageAssertStatementMap);
      MessageAssertStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ISimpleAssertStatementNode>> SimpleAssertStatementMap;
  private EvaluationResult<? extends ISimpleAssertStatementNode> parseSimpleAssertStatement(int position) {
    EvaluationResult<? extends ISimpleAssertStatementNode> result = (SimpleAssertStatementMap == null ? null : SimpleAssertStatementMap.get(position));
    if (result == null) {
      if (checkToken_SimpleAssertStatement(position)) {
        result = evaluateSimpleAssertStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      SimpleAssertStatementMap = initializeMap(SimpleAssertStatementMap);
      SimpleAssertStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ISwitchStatementNode>> SwitchStatementMap;
  private EvaluationResult<? extends ISwitchStatementNode> parseSwitchStatement(int position) {
    EvaluationResult<? extends ISwitchStatementNode> result = (SwitchStatementMap == null ? null : SwitchStatementMap.get(position));
    if (result == null) {
      if (checkToken_SwitchStatement(position)) {
        result = evaluateSwitchStatementExpression_2(position);
      } else {
        result = EvaluationResult.failure();
      }
      SwitchStatementMap = initializeMap(SwitchStatementMap);
      SwitchStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ISwitchBlockStatementGroupNode>> SwitchBlockStatementGroupMap;
  private EvaluationResult<? extends ISwitchBlockStatementGroupNode> parseSwitchBlockStatementGroup(int position) {
    EvaluationResult<? extends ISwitchBlockStatementGroupNode> result = (SwitchBlockStatementGroupMap == null ? null : SwitchBlockStatementGroupMap.get(position));
    if (result == null) {
      if (checkToken_SwitchBlockStatementGroup(position)) {
        result = evaluateSwitchBlockStatementGroupExpression_2(position);
      } else {
        result = EvaluationResult.failure();
      }
      SwitchBlockStatementGroupMap = initializeMap(SwitchBlockStatementGroupMap);
      SwitchBlockStatementGroupMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ISwitchLabelNode>> SwitchLabelMap;
  private EvaluationResult<? extends ISwitchLabelNode> parseSwitchLabel(int position) {
    EvaluationResult<? extends ISwitchLabelNode> result = (SwitchLabelMap == null ? null : SwitchLabelMap.get(position));
    if (result == null) {
      if (checkToken_SwitchLabel(position)) {
        result = evaluateSwitchLabelExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      SwitchLabelMap = initializeMap(SwitchLabelMap);
      SwitchLabelMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ICaseSwitchLabelNode>> CaseSwitchLabelMap;
  private EvaluationResult<? extends ICaseSwitchLabelNode> parseCaseSwitchLabel(int position) {
    EvaluationResult<? extends ICaseSwitchLabelNode> result = (CaseSwitchLabelMap == null ? null : CaseSwitchLabelMap.get(position));
    if (result == null) {
      if (checkToken_CaseSwitchLabel(position)) {
        result = evaluateCaseSwitchLabelExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      CaseSwitchLabelMap = initializeMap(CaseSwitchLabelMap);
      CaseSwitchLabelMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IDefaultSwitchLabelNode>> DefaultSwitchLabelMap;
  private EvaluationResult<? extends IDefaultSwitchLabelNode> parseDefaultSwitchLabel(int position) {
    EvaluationResult<? extends IDefaultSwitchLabelNode> result = (DefaultSwitchLabelMap == null ? null : DefaultSwitchLabelMap.get(position));
    if (result == null) {
      if (checkToken_DefaultSwitchLabel(position)) {
        result = evaluateDefaultSwitchLabelExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      DefaultSwitchLabelMap = initializeMap(DefaultSwitchLabelMap);
      DefaultSwitchLabelMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IWhileStatementNode>> WhileStatementMap;
  private EvaluationResult<? extends IWhileStatementNode> parseWhileStatement(int position) {
    EvaluationResult<? extends IWhileStatementNode> result = (WhileStatementMap == null ? null : WhileStatementMap.get(position));
    if (result == null) {
      if (checkToken_WhileStatement(position)) {
        result = evaluateWhileStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      WhileStatementMap = initializeMap(WhileStatementMap);
      WhileStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IDoStatementNode>> DoStatementMap;
  private EvaluationResult<? extends IDoStatementNode> parseDoStatement(int position) {
    EvaluationResult<? extends IDoStatementNode> result = (DoStatementMap == null ? null : DoStatementMap.get(position));
    if (result == null) {
      if (checkToken_DoStatement(position)) {
        result = evaluateDoStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      DoStatementMap = initializeMap(DoStatementMap);
      DoStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IForStatementNode>> ForStatementMap;
  private EvaluationResult<? extends IForStatementNode> parseForStatement(int position) {
    EvaluationResult<? extends IForStatementNode> result = (ForStatementMap == null ? null : ForStatementMap.get(position));
    if (result == null) {
      if (checkToken_ForStatement(position)) {
        result = evaluateForStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ForStatementMap = initializeMap(ForStatementMap);
      ForStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IBasicForStatementNode>> BasicForStatementMap;
  private EvaluationResult<? extends IBasicForStatementNode> parseBasicForStatement(int position) {
    EvaluationResult<? extends IBasicForStatementNode> result = (BasicForStatementMap == null ? null : BasicForStatementMap.get(position));
    if (result == null) {
      if (checkToken_BasicForStatement(position)) {
        result = evaluateBasicForStatementExpression_2(position);
      } else {
        result = EvaluationResult.failure();
      }
      BasicForStatementMap = initializeMap(BasicForStatementMap);
      BasicForStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IForInitializerNode>> ForInitializerMap;
  private EvaluationResult<? extends IForInitializerNode> parseForInitializer(int position) {
    EvaluationResult<? extends IForInitializerNode> result = (ForInitializerMap == null ? null : ForInitializerMap.get(position));
    if (result == null) {
      if (checkToken_ForInitializer(position)) {
        result = evaluateForInitializerExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ForInitializerMap = initializeMap(ForInitializerMap);
      ForInitializerMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IDelimitedExpressionListNode>> DelimitedExpressionListMap;
  private EvaluationResult<? extends IDelimitedExpressionListNode> parseDelimitedExpressionList(int position) {
    EvaluationResult<? extends IDelimitedExpressionListNode> result = (DelimitedExpressionListMap == null ? null : DelimitedExpressionListMap.get(position));
    if (result == null) {
      if (checkToken_DelimitedExpressionList(position)) {
        result = evaluateDelimitedExpressionListExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      DelimitedExpressionListMap = initializeMap(DelimitedExpressionListMap);
      DelimitedExpressionListMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IEnhancedForStatementNode>> EnhancedForStatementMap;
  private EvaluationResult<? extends IEnhancedForStatementNode> parseEnhancedForStatement(int position) {
    EvaluationResult<? extends IEnhancedForStatementNode> result = (EnhancedForStatementMap == null ? null : EnhancedForStatementMap.get(position));
    if (result == null) {
      if (checkToken_EnhancedForStatement(position)) {
        result = evaluateEnhancedForStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      EnhancedForStatementMap = initializeMap(EnhancedForStatementMap);
      EnhancedForStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IBreakStatementNode>> BreakStatementMap;
  private EvaluationResult<? extends IBreakStatementNode> parseBreakStatement(int position) {
    EvaluationResult<? extends IBreakStatementNode> result = (BreakStatementMap == null ? null : BreakStatementMap.get(position));
    if (result == null) {
      if (checkToken_BreakStatement(position)) {
        result = evaluateBreakStatementExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      BreakStatementMap = initializeMap(BreakStatementMap);
      BreakStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IContinueStatementNode>> ContinueStatementMap;
  private EvaluationResult<? extends IContinueStatementNode> parseContinueStatement(int position) {
    EvaluationResult<? extends IContinueStatementNode> result = (ContinueStatementMap == null ? null : ContinueStatementMap.get(position));
    if (result == null) {
      if (checkToken_ContinueStatement(position)) {
        result = evaluateContinueStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ContinueStatementMap = initializeMap(ContinueStatementMap);
      ContinueStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IReturnStatementNode>> ReturnStatementMap;
  private EvaluationResult<? extends IReturnStatementNode> parseReturnStatement(int position) {
    EvaluationResult<? extends IReturnStatementNode> result = (ReturnStatementMap == null ? null : ReturnStatementMap.get(position));
    if (result == null) {
      if (checkToken_ReturnStatement(position)) {
        result = evaluateReturnStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ReturnStatementMap = initializeMap(ReturnStatementMap);
      ReturnStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IThrowStatementNode>> ThrowStatementMap;
  private EvaluationResult<? extends IThrowStatementNode> parseThrowStatement(int position) {
    EvaluationResult<? extends IThrowStatementNode> result = (ThrowStatementMap == null ? null : ThrowStatementMap.get(position));
    if (result == null) {
      if (checkToken_ThrowStatement(position)) {
        result = evaluateThrowStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ThrowStatementMap = initializeMap(ThrowStatementMap);
      ThrowStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ISynchronizedStatementNode>> SynchronizedStatementMap;
  private EvaluationResult<? extends ISynchronizedStatementNode> parseSynchronizedStatement(int position) {
    EvaluationResult<? extends ISynchronizedStatementNode> result = (SynchronizedStatementMap == null ? null : SynchronizedStatementMap.get(position));
    if (result == null) {
      if (checkToken_SynchronizedStatement(position)) {
        result = evaluateSynchronizedStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      SynchronizedStatementMap = initializeMap(SynchronizedStatementMap);
      SynchronizedStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ITryStatementNode>> TryStatementMap;
  private EvaluationResult<? extends ITryStatementNode> parseTryStatement(int position) {
    EvaluationResult<? extends ITryStatementNode> result = (TryStatementMap == null ? null : TryStatementMap.get(position));
    if (result == null) {
      if (checkToken_TryStatement(position)) {
        result = evaluateTryStatementExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      TryStatementMap = initializeMap(TryStatementMap);
      TryStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ITryStatementWithFinallyNode>> TryStatementWithFinallyMap;
  private EvaluationResult<? extends ITryStatementWithFinallyNode> parseTryStatementWithFinally(int position) {
    EvaluationResult<? extends ITryStatementWithFinallyNode> result = (TryStatementWithFinallyMap == null ? null : TryStatementWithFinallyMap.get(position));
    if (result == null) {
      if (checkToken_TryStatementWithFinally(position)) {
        result = evaluateTryStatementWithFinallyExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      TryStatementWithFinallyMap = initializeMap(TryStatementWithFinallyMap);
      TryStatementWithFinallyMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ITryStatementWithoutFinallyNode>> TryStatementWithoutFinallyMap;
  private EvaluationResult<? extends ITryStatementWithoutFinallyNode> parseTryStatementWithoutFinally(int position) {
    EvaluationResult<? extends ITryStatementWithoutFinallyNode> result = (TryStatementWithoutFinallyMap == null ? null : TryStatementWithoutFinallyMap.get(position));
    if (result == null) {
      if (checkToken_TryStatementWithoutFinally(position)) {
        result = evaluateTryStatementWithoutFinallyExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      TryStatementWithoutFinallyMap = initializeMap(TryStatementWithoutFinallyMap);
      TryStatementWithoutFinallyMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ICatchClauseNode>> CatchClauseMap;
  private EvaluationResult<? extends ICatchClauseNode> parseCatchClause(int position) {
    EvaluationResult<? extends ICatchClauseNode> result = (CatchClauseMap == null ? null : CatchClauseMap.get(position));
    if (result == null) {
      if (checkToken_CatchClause(position)) {
        result = evaluateCatchClauseExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      CatchClauseMap = initializeMap(CatchClauseMap);
      CatchClauseMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IExpressionNode>> ExpressionMap;
  private EvaluationResult<? extends IExpressionNode> parseExpression(int position) {
    EvaluationResult<? extends IExpressionNode> result = (ExpressionMap == null ? null : ExpressionMap.get(position));
    if (result == null) {
      if (checkToken_Expression(position)) {
        result = evaluateExpressionExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ExpressionMap = initializeMap(ExpressionMap);
      ExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IAssignmentOperatorNode>> AssignmentOperatorMap;
  private EvaluationResult<? extends IAssignmentOperatorNode> parseAssignmentOperator(int position) {
    EvaluationResult<? extends IAssignmentOperatorNode> result = (AssignmentOperatorMap == null ? null : AssignmentOperatorMap.get(position));
    if (result == null) {
      if (checkToken_AssignmentOperator(position)) {
        result = evaluateAssignmentOperatorExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      AssignmentOperatorMap = initializeMap(AssignmentOperatorMap);
      AssignmentOperatorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IExpression1Node>> Expression1Map;
  private EvaluationResult<? extends IExpression1Node> parseExpression1(int position) {
    EvaluationResult<? extends IExpression1Node> result = (Expression1Map == null ? null : Expression1Map.get(position));
    if (result == null) {
      if (checkToken_Expression1(position)) {
        result = evaluateExpression1Expression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      Expression1Map = initializeMap(Expression1Map);
      Expression1Map.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ITernaryExpressionNode>> TernaryExpressionMap;
  private EvaluationResult<? extends ITernaryExpressionNode> parseTernaryExpression(int position) {
    EvaluationResult<? extends ITernaryExpressionNode> result = (TernaryExpressionMap == null ? null : TernaryExpressionMap.get(position));
    if (result == null) {
      if (checkToken_TernaryExpression(position)) {
        result = evaluateTernaryExpressionExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      TernaryExpressionMap = initializeMap(TernaryExpressionMap);
      TernaryExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IExpression2Node>> Expression2Map;
  private EvaluationResult<? extends IExpression2Node> parseExpression2(int position) {
    EvaluationResult<? extends IExpression2Node> result = (Expression2Map == null ? null : Expression2Map.get(position));
    if (result == null) {
      if (checkToken_Expression2(position)) {
        result = evaluateExpression2Expression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      Expression2Map = initializeMap(Expression2Map);
      Expression2Map.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IBinaryExpressionNode>> BinaryExpressionMap;
  private EvaluationResult<? extends IBinaryExpressionNode> parseBinaryExpression(int position) {
    EvaluationResult<? extends IBinaryExpressionNode> result = (BinaryExpressionMap == null ? null : BinaryExpressionMap.get(position));
    if (result == null) {
      if (checkToken_BinaryExpression(position)) {
        result = evaluateBinaryExpressionExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      BinaryExpressionMap = initializeMap(BinaryExpressionMap);
      BinaryExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IBinaryExpressionRestNode>> BinaryExpressionRestMap;
  private EvaluationResult<? extends IBinaryExpressionRestNode> parseBinaryExpressionRest(int position) {
    EvaluationResult<? extends IBinaryExpressionRestNode> result = (BinaryExpressionRestMap == null ? null : BinaryExpressionRestMap.get(position));
    if (result == null) {
      if (checkToken_BinaryExpressionRest(position)) {
        result = evaluateBinaryExpressionRestExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      BinaryExpressionRestMap = initializeMap(BinaryExpressionRestMap);
      BinaryExpressionRestMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IInfixOperatorBinaryExpressionRestNode>> InfixOperatorBinaryExpressionRestMap;
  private EvaluationResult<? extends IInfixOperatorBinaryExpressionRestNode> parseInfixOperatorBinaryExpressionRest(int position) {
    EvaluationResult<? extends IInfixOperatorBinaryExpressionRestNode> result = (InfixOperatorBinaryExpressionRestMap == null ? null : InfixOperatorBinaryExpressionRestMap.get(position));
    if (result == null) {
      if (checkToken_InfixOperatorBinaryExpressionRest(position)) {
        result = evaluateInfixOperatorBinaryExpressionRestExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      InfixOperatorBinaryExpressionRestMap = initializeMap(InfixOperatorBinaryExpressionRestMap);
      InfixOperatorBinaryExpressionRestMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IInstanceofOperatorBinaryExpressionRestNode>> InstanceofOperatorBinaryExpressionRestMap;
  private EvaluationResult<? extends IInstanceofOperatorBinaryExpressionRestNode> parseInstanceofOperatorBinaryExpressionRest(int position) {
    EvaluationResult<? extends IInstanceofOperatorBinaryExpressionRestNode> result = (InstanceofOperatorBinaryExpressionRestMap == null ? null : InstanceofOperatorBinaryExpressionRestMap.get(position));
    if (result == null) {
      if (checkToken_InstanceofOperatorBinaryExpressionRest(position)) {
        result = evaluateInstanceofOperatorBinaryExpressionRestExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      InstanceofOperatorBinaryExpressionRestMap = initializeMap(InstanceofOperatorBinaryExpressionRestMap);
      InstanceofOperatorBinaryExpressionRestMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IInfixOperatorNode>> InfixOperatorMap;
  private EvaluationResult<? extends IInfixOperatorNode> parseInfixOperator(int position) {
    EvaluationResult<? extends IInfixOperatorNode> result = (InfixOperatorMap == null ? null : InfixOperatorMap.get(position));
    if (result == null) {
      if (checkToken_InfixOperator(position)) {
        result = evaluateInfixOperatorExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      InfixOperatorMap = initializeMap(InfixOperatorMap);
      InfixOperatorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IUnsignedRightShiftNode>> UnsignedRightShiftMap;
  private EvaluationResult<? extends IUnsignedRightShiftNode> parseUnsignedRightShift(int position) {
    EvaluationResult<? extends IUnsignedRightShiftNode> result = (UnsignedRightShiftMap == null ? null : UnsignedRightShiftMap.get(position));
    if (result == null) {
      if (checkToken_UnsignedRightShift(position)) {
        result = evaluateUnsignedRightShiftExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      UnsignedRightShiftMap = initializeMap(UnsignedRightShiftMap);
      UnsignedRightShiftMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ISignedRightShiftNode>> SignedRightShiftMap;
  private EvaluationResult<? extends ISignedRightShiftNode> parseSignedRightShift(int position) {
    EvaluationResult<? extends ISignedRightShiftNode> result = (SignedRightShiftMap == null ? null : SignedRightShiftMap.get(position));
    if (result == null) {
      if (checkToken_SignedRightShift(position)) {
        result = evaluateSignedRightShiftExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      SignedRightShiftMap = initializeMap(SignedRightShiftMap);
      SignedRightShiftMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IExpression3Node>> Expression3Map;
  private EvaluationResult<? extends IExpression3Node> parseExpression3(int position) {
    EvaluationResult<? extends IExpression3Node> result = (Expression3Map == null ? null : Expression3Map.get(position));
    if (result == null) {
      if (checkToken_Expression3(position)) {
        result = evaluateExpression3Expression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      Expression3Map = initializeMap(Expression3Map);
      Expression3Map.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IPrefixExpressionNode>> PrefixExpressionMap;
  private EvaluationResult<? extends IPrefixExpressionNode> parsePrefixExpression(int position) {
    EvaluationResult<? extends IPrefixExpressionNode> result = (PrefixExpressionMap == null ? null : PrefixExpressionMap.get(position));
    if (result == null) {
      if (checkToken_PrefixExpression(position)) {
        result = evaluatePrefixExpressionExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      PrefixExpressionMap = initializeMap(PrefixExpressionMap);
      PrefixExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IPrefixOperatorNode>> PrefixOperatorMap;
  private EvaluationResult<? extends IPrefixOperatorNode> parsePrefixOperator(int position) {
    EvaluationResult<? extends IPrefixOperatorNode> result = (PrefixOperatorMap == null ? null : PrefixOperatorMap.get(position));
    if (result == null) {
      if (checkToken_PrefixOperator(position)) {
        result = evaluatePrefixOperatorExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      PrefixOperatorMap = initializeMap(PrefixOperatorMap);
      PrefixOperatorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IPossibleCastExpressionNode>> PossibleCastExpressionMap;
  private EvaluationResult<? extends IPossibleCastExpressionNode> parsePossibleCastExpression(int position) {
    EvaluationResult<? extends IPossibleCastExpressionNode> result = (PossibleCastExpressionMap == null ? null : PossibleCastExpressionMap.get(position));
    if (result == null) {
      if (checkToken_PossibleCastExpression(position)) {
        result = evaluatePossibleCastExpressionExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      PossibleCastExpressionMap = initializeMap(PossibleCastExpressionMap);
      PossibleCastExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IPossibleCastExpression_TypeNode>> PossibleCastExpression_TypeMap;
  private EvaluationResult<? extends IPossibleCastExpression_TypeNode> parsePossibleCastExpression_Type(int position) {
    EvaluationResult<? extends IPossibleCastExpression_TypeNode> result = (PossibleCastExpression_TypeMap == null ? null : PossibleCastExpression_TypeMap.get(position));
    if (result == null) {
      if (checkToken_PossibleCastExpression_Type(position)) {
        result = evaluatePossibleCastExpression_TypeExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      PossibleCastExpression_TypeMap = initializeMap(PossibleCastExpression_TypeMap);
      PossibleCastExpression_TypeMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IPossibleCastExpression_ExpressionNode>> PossibleCastExpression_ExpressionMap;
  private EvaluationResult<? extends IPossibleCastExpression_ExpressionNode> parsePossibleCastExpression_Expression(int position) {
    EvaluationResult<? extends IPossibleCastExpression_ExpressionNode> result = (PossibleCastExpression_ExpressionMap == null ? null : PossibleCastExpression_ExpressionMap.get(position));
    if (result == null) {
      if (checkToken_PossibleCastExpression_Expression(position)) {
        result = evaluatePossibleCastExpression_ExpressionExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      PossibleCastExpression_ExpressionMap = initializeMap(PossibleCastExpression_ExpressionMap);
      PossibleCastExpression_ExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IPrimaryExpressionNode>> PrimaryExpressionMap;
  private EvaluationResult<? extends IPrimaryExpressionNode> parsePrimaryExpression(int position) {
    EvaluationResult<? extends IPrimaryExpressionNode> result = (PrimaryExpressionMap == null ? null : PrimaryExpressionMap.get(position));
    if (result == null) {
      if (checkToken_PrimaryExpression(position)) {
        result = evaluatePrimaryExpressionExpression_2(position);
      } else {
        result = EvaluationResult.failure();
      }
      PrimaryExpressionMap = initializeMap(PrimaryExpressionMap);
      PrimaryExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IPostfixOperatorNode>> PostfixOperatorMap;
  private EvaluationResult<? extends IPostfixOperatorNode> parsePostfixOperator(int position) {
    EvaluationResult<? extends IPostfixOperatorNode> result = (PostfixOperatorMap == null ? null : PostfixOperatorMap.get(position));
    if (result == null) {
      if (checkToken_PostfixOperator(position)) {
        result = evaluatePostfixOperatorExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      PostfixOperatorMap = initializeMap(PostfixOperatorMap);
      PostfixOperatorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IValueExpressionNode>> ValueExpressionMap;
  private EvaluationResult<? extends IValueExpressionNode> parseValueExpression(int position) {
    EvaluationResult<? extends IValueExpressionNode> result = (ValueExpressionMap == null ? null : ValueExpressionMap.get(position));
    if (result == null) {
      if (checkToken_ValueExpression(position)) {
        result = evaluateValueExpressionExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ValueExpressionMap = initializeMap(ValueExpressionMap);
      ValueExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IClassAccessNode>> ClassAccessMap;
  private EvaluationResult<? extends IClassAccessNode> parseClassAccess(int position) {
    EvaluationResult<? extends IClassAccessNode> result = (ClassAccessMap == null ? null : ClassAccessMap.get(position));
    if (result == null) {
      if (checkToken_ClassAccess(position)) {
        result = evaluateClassAccessExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ClassAccessMap = initializeMap(ClassAccessMap);
      ClassAccessMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ISelectorNode>> SelectorMap;
  private EvaluationResult<? extends ISelectorNode> parseSelector(int position) {
    EvaluationResult<? extends ISelectorNode> result = (SelectorMap == null ? null : SelectorMap.get(position));
    if (result == null) {
      if (checkToken_Selector(position)) {
        result = evaluateSelectorExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      SelectorMap = initializeMap(SelectorMap);
      SelectorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IDotSelectorNode>> DotSelectorMap;
  private EvaluationResult<? extends IDotSelectorNode> parseDotSelector(int position) {
    EvaluationResult<? extends IDotSelectorNode> result = (DotSelectorMap == null ? null : DotSelectorMap.get(position));
    if (result == null) {
      if (checkToken_DotSelector(position)) {
        result = evaluateDotSelectorExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      DotSelectorMap = initializeMap(DotSelectorMap);
      DotSelectorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IArraySelectorNode>> ArraySelectorMap;
  private EvaluationResult<? extends IArraySelectorNode> parseArraySelector(int position) {
    EvaluationResult<? extends IArraySelectorNode> result = (ArraySelectorMap == null ? null : ArraySelectorMap.get(position));
    if (result == null) {
      if (checkToken_ArraySelector(position)) {
        result = evaluateArraySelectorExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ArraySelectorMap = initializeMap(ArraySelectorMap);
      ArraySelectorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IParenthesizedExpressionNode>> ParenthesizedExpressionMap;
  private EvaluationResult<? extends IParenthesizedExpressionNode> parseParenthesizedExpression(int position) {
    EvaluationResult<? extends IParenthesizedExpressionNode> result = (ParenthesizedExpressionMap == null ? null : ParenthesizedExpressionMap.get(position));
    if (result == null) {
      if (checkToken_ParenthesizedExpression(position)) {
        result = evaluateParenthesizedExpressionExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ParenthesizedExpressionMap = initializeMap(ParenthesizedExpressionMap);
      ParenthesizedExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IMethodInvocationNode>> MethodInvocationMap;
  private EvaluationResult<? extends IMethodInvocationNode> parseMethodInvocation(int position) {
    EvaluationResult<? extends IMethodInvocationNode> result = (MethodInvocationMap == null ? null : MethodInvocationMap.get(position));
    if (result == null) {
      if (checkToken_MethodInvocation(position)) {
        result = evaluateMethodInvocationExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      MethodInvocationMap = initializeMap(MethodInvocationMap);
      MethodInvocationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IThisConstructorInvocationNode>> ThisConstructorInvocationMap;
  private EvaluationResult<? extends IThisConstructorInvocationNode> parseThisConstructorInvocation(int position) {
    EvaluationResult<? extends IThisConstructorInvocationNode> result = (ThisConstructorInvocationMap == null ? null : ThisConstructorInvocationMap.get(position));
    if (result == null) {
      if (checkToken_ThisConstructorInvocation(position)) {
        result = evaluateThisConstructorInvocationExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ThisConstructorInvocationMap = initializeMap(ThisConstructorInvocationMap);
      ThisConstructorInvocationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ISuperConstructorInvocationNode>> SuperConstructorInvocationMap;
  private EvaluationResult<? extends ISuperConstructorInvocationNode> parseSuperConstructorInvocation(int position) {
    EvaluationResult<? extends ISuperConstructorInvocationNode> result = (SuperConstructorInvocationMap == null ? null : SuperConstructorInvocationMap.get(position));
    if (result == null) {
      if (checkToken_SuperConstructorInvocation(position)) {
        result = evaluateSuperConstructorInvocationExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      SuperConstructorInvocationMap = initializeMap(SuperConstructorInvocationMap);
      SuperConstructorInvocationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends ICreationExpressionNode>> CreationExpressionMap;
  private EvaluationResult<? extends ICreationExpressionNode> parseCreationExpression(int position) {
    EvaluationResult<? extends ICreationExpressionNode> result = (CreationExpressionMap == null ? null : CreationExpressionMap.get(position));
    if (result == null) {
      if (checkToken_CreationExpression(position)) {
        result = evaluateCreationExpressionExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      CreationExpressionMap = initializeMap(CreationExpressionMap);
      CreationExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IObjectCreationExpressionNode>> ObjectCreationExpressionMap;
  private EvaluationResult<? extends IObjectCreationExpressionNode> parseObjectCreationExpression(int position) {
    EvaluationResult<? extends IObjectCreationExpressionNode> result = (ObjectCreationExpressionMap == null ? null : ObjectCreationExpressionMap.get(position));
    if (result == null) {
      if (checkToken_ObjectCreationExpression(position)) {
        result = evaluateObjectCreationExpressionExpression_1(position);
      } else {
        result = EvaluationResult.failure();
      }
      ObjectCreationExpressionMap = initializeMap(ObjectCreationExpressionMap);
      ObjectCreationExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IArrayCreationExpressionNode>> ArrayCreationExpressionMap;
  private EvaluationResult<? extends IArrayCreationExpressionNode> parseArrayCreationExpression(int position) {
    EvaluationResult<? extends IArrayCreationExpressionNode> result = (ArrayCreationExpressionMap == null ? null : ArrayCreationExpressionMap.get(position));
    if (result == null) {
      if (checkToken_ArrayCreationExpression(position)) {
        result = evaluateArrayCreationExpressionExpression_2(position);
      } else {
        result = EvaluationResult.failure();
      }
      ArrayCreationExpressionMap = initializeMap(ArrayCreationExpressionMap);
      ArrayCreationExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IArrayCreationTypeNode>> ArrayCreationTypeMap;
  private EvaluationResult<? extends IArrayCreationTypeNode> parseArrayCreationType(int position) {
    EvaluationResult<? extends IArrayCreationTypeNode> result = (ArrayCreationTypeMap == null ? null : ArrayCreationTypeMap.get(position));
    if (result == null) {
      if (checkToken_ArrayCreationType(position)) {
        result = evaluateArrayCreationTypeExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      ArrayCreationTypeMap = initializeMap(ArrayCreationTypeMap);
      ArrayCreationTypeMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IDimensionExpressionNode>> DimensionExpressionMap;
  private EvaluationResult<? extends IDimensionExpressionNode> parseDimensionExpression(int position) {
    EvaluationResult<? extends IDimensionExpressionNode> result = (DimensionExpressionMap == null ? null : DimensionExpressionMap.get(position));
    if (result == null) {
      if (checkToken_DimensionExpression(position)) {
        result = evaluateDimensionExpressionExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      DimensionExpressionMap = initializeMap(DimensionExpressionMap);
      DimensionExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IArrayInitializerNode>> ArrayInitializerMap;
  private EvaluationResult<? extends IArrayInitializerNode> parseArrayInitializer(int position) {
    EvaluationResult<? extends IArrayInitializerNode> result = (ArrayInitializerMap == null ? null : ArrayInitializerMap.get(position));
    if (result == null) {
      if (checkToken_ArrayInitializer(position)) {
        result = evaluateArrayInitializerExpression_2(position);
      } else {
        result = EvaluationResult.failure();
      }
      ArrayInitializerMap = initializeMap(ArrayInitializerMap);
      ArrayInitializerMap.put(position, result);
    }
    return result;
  }

  private Map<Integer,EvaluationResult<? extends IVariableInitializerNode>> VariableInitializerMap;
  private EvaluationResult<? extends IVariableInitializerNode> parseVariableInitializer(int position) {
    EvaluationResult<? extends IVariableInitializerNode> result = (VariableInitializerMap == null ? null : VariableInitializerMap.get(position));
    if (result == null) {
      if (checkToken_VariableInitializer(position)) {
        result = evaluateVariableInitializerExpression_0(position);
      } else {
        result = EvaluationResult.failure();
      }
      VariableInitializerMap = initializeMap(VariableInitializerMap);
      VariableInitializerMap.put(position, result);
    }
    return result;
  }

  protected abstract EvaluationResult anyToken(int position);
}