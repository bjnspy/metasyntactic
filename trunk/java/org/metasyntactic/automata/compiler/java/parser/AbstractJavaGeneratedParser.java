package com.google.automata.compiler.java.parser;

import com.google.automata.compiler.framework.parsers.SourceToken;
import com.google.automata.compiler.framework.parsers.Token;
import com.google.automata.compiler.java.scanner.IdentifierToken;
import com.google.automata.compiler.java.scanner.keywords.*;
import com.google.automata.compiler.java.scanner.literals.LiteralToken;
import com.google.automata.compiler.java.scanner.operators.*;
import com.google.automata.compiler.java.scanner.separators.*;

import java.util.*;

public abstract class AbstractJavaGeneratedParser {
  protected static class EvaluationResult {
    public static final EvaluationResult failure = new EvaluationResult(false, 0);

    private final boolean succeeded;
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

    public boolean isSucceeded() {
      return succeeded;
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

  public AbstractJavaGeneratedParser(List<SourceToken<Token>> tokens) {
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
    if (result.isSucceeded()) {
      return result.getValue();
    } else {
      return null;
    }
  }

  private EvaluationResult evaluateCompilationUnitExpression_0(int position) {
    EvaluationResult result;
    if ((result = parsePackageDeclaration(position)).isSucceeded()) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateCompilationUnitExpression_1(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = parseImportDeclaration(currentPosition);
      if (result.isSucceeded()) {
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
      if (result.isSucceeded()) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateCompilationUnitExpression_3(int position) {
    EvaluationResult result = anyToken(position);
    return new EvaluationResult(!result.isSucceeded(), position);
  }

  private EvaluationResult evaluateCompilationUnitExpression_4(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateCompilationUnitExpression_0(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateCompilationUnitExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateCompilationUnitExpression_2(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateCompilationUnitExpression_3(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluatePackageDeclarationExpression_0(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = parseAnnotation(currentPosition);
      if (result.isSucceeded()) {
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
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), PackageKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseQualifiedIdentifier(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
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
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, DotSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateQualifiedIdentifierExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateQualifiedIdentifierExpression_2(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = evaluateQualifiedIdentifierExpression_1(currentPosition);
      if (result.isSucceeded()) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateQualifiedIdentifierExpression_3(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateQualifiedIdentifierExpression_0(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateQualifiedIdentifierExpression_2(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateImportDeclarationExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseSingleTypeImportDeclaration(position)).isSucceeded()) { return result; }
    if ((result = parseTypeImportOnDemandDeclaration(position)).isSucceeded()) { return result; }
    if ((result = parseSingleStaticImportDeclaration(position)).isSucceeded()) { return result; }
    return parseStaticImportOnDemandDeclaration(position);
  }

  private EvaluationResult evaluateSingleTypeImportDeclarationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ImportKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseQualifiedIdentifier(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeImportOnDemandDeclarationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ImportKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseQualifiedIdentifier(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), DotSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), TimesOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateSingleStaticImportDeclarationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ImportKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), StaticKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseQualifiedIdentifier(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateStaticImportOnDemandDeclarationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ImportKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), StaticKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseQualifiedIdentifier(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), DotSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), TimesOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeDeclarationExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseClassDeclaration(position)).isSucceeded()) { return result; }
    if ((result = parseInterfaceDeclaration(position)).isSucceeded()) { return result; }
    return evaluateToken(position, SemicolonSeparatorToken.instance);
  }

  private EvaluationResult evaluateClassDeclarationExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseNormalClassDeclaration(position)).isSucceeded()) { return result; }
    return parseEnumDeclaration(position);
  }

  private EvaluationResult evaluateNormalClassDeclarationExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseTypeParameters(position)).isSucceeded()) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateNormalClassDeclarationExpression_1(int position) {
    EvaluationResult result;
    if ((result = parseSuper(position)).isSucceeded()) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateNormalClassDeclarationExpression_2(int position) {
    EvaluationResult result;
    if ((result = parseInterfaces(position)).isSucceeded()) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateNormalClassDeclarationExpression_3(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseModifiers(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), ClassKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateQualifiedIdentifierExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateNormalClassDeclarationExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateNormalClassDeclarationExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateNormalClassDeclarationExpression_2(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseClassBody(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateModifiersExpression_0(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = parseModifier(currentPosition);
      if (result.isSucceeded()) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateModifierExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseAnnotation(position)).isSucceeded()) { return result; }
    if ((result = evaluateToken(position, PublicKeywordToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, ProtectedKeywordToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, PrivateKeywordToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, StaticKeywordToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, AbstractKeywordToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, FinalKeywordToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, NativeKeywordToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, SynchronizedKeywordToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, TransientKeywordToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, VolatileKeywordToken.instance)).isSucceeded()) {
      return result;
    }
    return evaluateToken(position, StrictfpKeywordToken.instance);
  }

  private EvaluationResult evaluateSuperExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ExtendsKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseType(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateInterfacesExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, CommaSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseType(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateInterfacesExpression_1(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = evaluateInterfacesExpression_0(currentPosition);
      if (result.isSucceeded()) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateInterfacesExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseType(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateInterfacesExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateInterfacesExpression_3(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ImplementsKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateInterfacesExpression_2(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateClassBodyExpression_0(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = parseClassBodyDeclaration(currentPosition);
      if (result.isSucceeded()) {
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
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateClassBodyExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightCurlySeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateClassBodyDeclarationExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseClassOrInterfaceMemberDeclaration(position)).isSucceeded()) {
      return result;
    }
    if ((result = parseBlock(position)).isSucceeded()) { return result; }
    if ((result = parseStaticInitializer(position)).isSucceeded()) { return result; }
    return parseConstructorDeclaration(position);
  }

  private EvaluationResult evaluateStaticInitializerExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, StaticKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseBlock(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateInterfaceDeclarationExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseNormalInterfaceDeclaration(position)).isSucceeded()) { return result; }
    return parseAnnotationDeclaration(position);
  }

  private EvaluationResult evaluateNormalInterfaceDeclarationExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseExtendsInterfaces(position)).isSucceeded()) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateNormalInterfaceDeclarationExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseModifiers(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), InterfaceKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateQualifiedIdentifierExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateNormalClassDeclarationExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateNormalInterfaceDeclarationExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseClassOrInterfaceBody(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateExtendsInterfacesExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ExtendsKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateInterfacesExpression_2(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateClassOrInterfaceBodyExpression_0(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = parseClassOrInterfaceMemberDeclaration(currentPosition);
      if (result.isSucceeded()) {
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
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateClassOrInterfaceBodyExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightCurlySeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateEnumDeclarationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseModifiers(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), EnumKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateQualifiedIdentifierExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateNormalClassDeclarationExpression_2(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseEnumBody(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateEnumBodyExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, CommaSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseEnumConstant(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateEnumBodyExpression_1(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = evaluateEnumBodyExpression_0(currentPosition);
      if (result.isSucceeded()) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateEnumBodyExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseEnumConstant(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateEnumBodyExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateEnumBodyExpression_3(int position) {
    EvaluationResult result;
    if ((result = evaluateEnumBodyExpression_2(position)).isSucceeded()) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateEnumBodyExpression_4(int position) {
    EvaluationResult result;
    if ((result = evaluateToken(position, CommaSeparatorToken.instance)).isSucceeded()) {
      return result;
    }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateEnumBodyExpression_5(int position) {
    EvaluationResult result;
    if ((result = evaluateToken(position, SemicolonSeparatorToken.instance)).isSucceeded()) {
      return result;
    }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateEnumBodyExpression_6(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LeftCurlySeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateEnumBodyExpression_3(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateEnumBodyExpression_4(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateEnumBodyExpression_5(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateClassBodyExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightCurlySeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateEnumConstantExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseArguments(position)).isSucceeded()) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateEnumConstantExpression_1(int position) {
    EvaluationResult result;
    if ((result = parseClassOrInterfaceBody(position)).isSucceeded()) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateEnumConstantExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluatePackageDeclarationExpression_0(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateQualifiedIdentifierExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateEnumConstantExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateEnumConstantExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateArgumentsExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, CommaSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateArgumentsExpression_1(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = evaluateArgumentsExpression_0(currentPosition);
      if (result.isSucceeded()) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateArgumentsExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseExpression(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateArgumentsExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateArgumentsExpression_3(int position) {
    EvaluationResult result;
    if ((result = evaluateArgumentsExpression_2(position)).isSucceeded()) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateArgumentsExpression_4(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LeftParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateArgumentsExpression_3(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateAnnotationDeclarationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseModifiers(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), AtSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), InterfaceKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateQualifiedIdentifierExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseAnnotationBody(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateAnnotationBodyExpression_0(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = parseAnnotationElementDeclaration(currentPosition);
      if (result.isSucceeded()) {
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
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateAnnotationBodyExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightCurlySeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateAnnotationElementDeclarationExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseAnnotationDefaultDeclaration(position)).isSucceeded()) { return result; }
    return parseClassOrInterfaceMemberDeclaration(position);
  }

  private EvaluationResult evaluateAnnotationDefaultDeclarationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseModifiers(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseType(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateQualifiedIdentifierExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), DefaultKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseElementValue(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateClassOrInterfaceMemberDeclarationExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseFieldDeclaration(position)).isSucceeded()) { return result; }
    if ((result = parseMethodDeclaration(position)).isSucceeded()) { return result; }
    return parseTypeDeclaration(position);
  }

  private EvaluationResult evaluateConstructorDeclarationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, CommaSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseFormalParameter(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateConstructorDeclarationExpression_1(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = evaluateConstructorDeclarationExpression_0(currentPosition);
      if (result.isSucceeded()) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateConstructorDeclarationExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseFormalParameter(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateConstructorDeclarationExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateConstructorDeclarationExpression_3(int position) {
    EvaluationResult result;
    if ((result = evaluateConstructorDeclarationExpression_2(position)).isSucceeded()) {
      return result;
    }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateConstructorDeclarationExpression_4(int position) {
    EvaluationResult result;
    if ((result = parseThrows(position)).isSucceeded()) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateConstructorDeclarationExpression_5(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseModifiers(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateNormalClassDeclarationExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateQualifiedIdentifierExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateConstructorDeclarationExpression_3(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateConstructorDeclarationExpression_4(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseBlock(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateFieldDeclarationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, CommaSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseVariableDeclarator(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateFieldDeclarationExpression_1(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = evaluateFieldDeclarationExpression_0(currentPosition);
      if (result.isSucceeded()) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateFieldDeclarationExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseVariableDeclarator(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateFieldDeclarationExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateFieldDeclarationExpression_3(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseModifiers(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseType(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateFieldDeclarationExpression_2(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateVariableDeclaratorExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseExpression(position)).isSucceeded()) { return result; }
    return parseArrayInitializer(position);
  }

  private EvaluationResult evaluateVariableDeclaratorExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseVariableDeclaratorId(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), EqualsOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateVariableDeclaratorExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateVariableDeclaratorExpression_2(int position) {
    EvaluationResult result;
    if ((result = evaluateVariableDeclaratorExpression_1(position)).isSucceeded()) {
      return result;
    }
    return parseVariableDeclaratorId(position);
  }

  private EvaluationResult evaluateVariableDeclaratorIdExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LeftBracketSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightBracketSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateVariableDeclaratorIdExpression_1(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = evaluateVariableDeclaratorIdExpression_0(currentPosition);
      if (result.isSucceeded()) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateVariableDeclaratorIdExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateQualifiedIdentifierExpression_0(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateVariableDeclaratorIdExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateMethodDeclarationExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseBlock(position)).isSucceeded()) { return result; }
    return evaluateToken(position, SemicolonSeparatorToken.instance);
  }

  private EvaluationResult evaluateMethodDeclarationExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseModifiers(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateNormalClassDeclarationExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseType(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateQualifiedIdentifierExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateConstructorDeclarationExpression_3(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateVariableDeclaratorIdExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateConstructorDeclarationExpression_4(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateMethodDeclarationExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateFormalParameterExpression_0(int position) {
    EvaluationResult result;
    if ((result = evaluateToken(position, EllipsisSeparatorToken.instance)).isSucceeded()) {
      return result;
    }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateFormalParameterExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseModifiers(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseType(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateFormalParameterExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseVariableDeclaratorId(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateThrowsExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ThrowsKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateInterfacesExpression_2(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeParametersExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, CommaSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseTypeParameter(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeParametersExpression_1(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = evaluateTypeParametersExpression_0(currentPosition);
      if (result.isSucceeded()) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateTypeParametersExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseTypeParameter(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateTypeParametersExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeParametersExpression_3(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LessThanOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateTypeParametersExpression_2(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), GreaterThanOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeParameterExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseTypeBound(position)).isSucceeded()) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateTypeParameterExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateQualifiedIdentifierExpression_0(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateTypeParameterExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeBoundExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, BitwiseAndOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseClassOrInterfaceType(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeBoundExpression_1(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = evaluateTypeBoundExpression_0(currentPosition);
      if (result.isSucceeded()) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateTypeBoundExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseClassOrInterfaceType(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateTypeBoundExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeBoundExpression_3(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ExtendsKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateTypeBoundExpression_2(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseReferenceType(position)).isSucceeded()) { return result; }
    return parsePrimitiveType(position);
  }

  private EvaluationResult evaluateReferenceTypeExpression_0(int position) {
    ArrayList<Object> values = null;
    EvaluationResult result = evaluateVariableDeclaratorIdExpression_0(position);
    if (!result.isSucceeded()) {
      return EvaluationResult.failure;
    }
    while (true) {
      int currentPosition = result.getPosition();
      values = addValue(values, result);
      result = evaluateVariableDeclaratorIdExpression_0(currentPosition);
      if (!result.isSucceeded()) {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateReferenceTypeExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parsePrimitiveType(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateReferenceTypeExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateReferenceTypeExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseClassOrInterfaceType(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateVariableDeclaratorIdExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateReferenceTypeExpression_3(int position) {
    EvaluationResult result;
    if ((result = evaluateReferenceTypeExpression_1(position)).isSucceeded()) { return result; }
    return evaluateReferenceTypeExpression_2(position);
  }

  private EvaluationResult evaluateClassOrInterfaceTypeExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseTypeArguments(position)).isSucceeded()) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateClassOrInterfaceTypeExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateQualifiedIdentifierExpression_0(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateClassOrInterfaceTypeExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateClassOrInterfaceTypeExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, DotSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateClassOrInterfaceTypeExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateClassOrInterfaceTypeExpression_3(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = evaluateClassOrInterfaceTypeExpression_2(currentPosition);
      if (result.isSucceeded()) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateClassOrInterfaceTypeExpression_4(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateClassOrInterfaceTypeExpression_1(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateClassOrInterfaceTypeExpression_3(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeArgumentsExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, CommaSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseTypeArgument(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeArgumentsExpression_1(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = evaluateTypeArgumentsExpression_0(currentPosition);
      if (result.isSucceeded()) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateTypeArgumentsExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseTypeArgument(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateTypeArgumentsExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeArgumentsExpression_3(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LessThanOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateTypeArgumentsExpression_2(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), GreaterThanOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeArgumentExpression_0(int position) {
    EvaluationResult result;
    if ((result = evaluateToken(position, ExtendsKeywordToken.instance)).isSucceeded()) {
      return result;
    }
    return evaluateToken(position, SuperKeywordToken.instance);
  }

  private EvaluationResult evaluateTypeArgumentExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateTypeArgumentExpression_0(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseReferenceType(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeArgumentExpression_2(int position) {
    EvaluationResult result;
    if ((result = evaluateTypeArgumentExpression_1(position)).isSucceeded()) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateTypeArgumentExpression_3(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, QuestionMarkOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateTypeArgumentExpression_2(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTypeArgumentExpression_4(int position) {
    EvaluationResult result;
    if ((result = parseReferenceType(position)).isSucceeded()) { return result; }
    return evaluateTypeArgumentExpression_3(position);
  }

  private EvaluationResult evaluateNonWildcardTypeArgumentsExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, CommaSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseReferenceType(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateNonWildcardTypeArgumentsExpression_1(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = evaluateNonWildcardTypeArgumentsExpression_0(currentPosition);
      if (result.isSucceeded()) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateNonWildcardTypeArgumentsExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseReferenceType(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateNonWildcardTypeArgumentsExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateNonWildcardTypeArgumentsExpression_3(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LessThanOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateNonWildcardTypeArgumentsExpression_2(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), GreaterThanOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluatePrimitiveTypeExpression_0(int position) {
    EvaluationResult result;
    if ((result = evaluateToken(position, ByteKeywordToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, ShortKeywordToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, CharKeywordToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, IntKeywordToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, LongKeywordToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, FloatKeywordToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, DoubleKeywordToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, BooleanKeywordToken.instance)).isSucceeded()) {
      return result;
    }
    return evaluateToken(position, VoidKeywordToken.instance);
  }

  private EvaluationResult evaluateAnnotationExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseNormalAnnotation(position)).isSucceeded()) { return result; }
    if ((result = parseSingleElementAnnotation(position)).isSucceeded()) { return result; }
    return parseMarkerAnnotation(position);
  }

  private EvaluationResult evaluateNormalAnnotationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, CommaSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseElementValuePair(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateNormalAnnotationExpression_1(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = evaluateNormalAnnotationExpression_0(currentPosition);
      if (result.isSucceeded()) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateNormalAnnotationExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseElementValuePair(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateNormalAnnotationExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateNormalAnnotationExpression_3(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, AtSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseQualifiedIdentifier(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateNormalAnnotationExpression_2(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateElementValuePairExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateQualifiedIdentifierExpression_0(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), EqualsOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseElementValue(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateSingleElementAnnotationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, AtSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseQualifiedIdentifier(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseElementValue(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateMarkerAnnotationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, AtSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseQualifiedIdentifier(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateElementValueExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseAnnotation(position)).isSucceeded()) { return result; }
    if ((result = parseExpression(position)).isSucceeded()) { return result; }
    return parseElementValueArrayInitializer(position);
  }

  private EvaluationResult evaluateElementValueArrayInitializerExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, CommaSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseElementValue(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateElementValueArrayInitializerExpression_1(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = evaluateElementValueArrayInitializerExpression_0(currentPosition);
      if (result.isSucceeded()) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateElementValueArrayInitializerExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseElementValue(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateElementValueArrayInitializerExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateElementValueArrayInitializerExpression_3(int position) {
    EvaluationResult result;
    if ((result = evaluateElementValueArrayInitializerExpression_2(position)).isSucceeded()) {
      return result;
    }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateElementValueArrayInitializerExpression_4(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LeftCurlySeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateElementValueArrayInitializerExpression_3(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateEnumBodyExpression_4(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightCurlySeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateBlockExpression_0(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = parseBlockStatement(currentPosition);
      if (result.isSucceeded()) {
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
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateBlockExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightCurlySeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateBlockStatementExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseLocalVariableDeclarationStatement(position)).isSucceeded()) {
      return result;
    }
    if ((result = parseClassDeclaration(position)).isSucceeded()) { return result; }
    return parseStatement(position);
  }

  private EvaluationResult evaluateLocalVariableDeclarationStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseLocalVariableDeclaration(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateLocalVariableDeclarationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseModifiers(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseType(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateFieldDeclarationExpression_2(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateStatementExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseBlock(position)).isSucceeded()) { return result; }
    if ((result = parseEmptyStatement(position)).isSucceeded()) { return result; }
    if ((result = parseExpressionStatement(position)).isSucceeded()) { return result; }
    if ((result = parseAssertStatement(position)).isSucceeded()) { return result; }
    if ((result = parseSwitchStatement(position)).isSucceeded()) { return result; }
    if ((result = parseDoStatement(position)).isSucceeded()) { return result; }
    if ((result = parseBreakStatement(position)).isSucceeded()) { return result; }
    if ((result = parseContinueStatement(position)).isSucceeded()) { return result; }
    if ((result = parseReturnStatement(position)).isSucceeded()) { return result; }
    if ((result = parseSynchronizedStatement(position)).isSucceeded()) { return result; }
    if ((result = parseThrowStatement(position)).isSucceeded()) { return result; }
    if ((result = parseTryStatement(position)).isSucceeded()) { return result; }
    if ((result = parseLabeledStatement(position)).isSucceeded()) { return result; }
    if ((result = parseIfStatement(position)).isSucceeded()) { return result; }
    if ((result = parseWhileStatement(position)).isSucceeded()) { return result; }
    return parseForStatement(position);
  }

  private EvaluationResult evaluateLabeledStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateQualifiedIdentifierExpression_0(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), ColonOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseStatement(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateExpressionStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseExpression(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateIfStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ElseKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseStatement(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateIfStatementExpression_1(int position) {
    EvaluationResult result;
    if ((result = evaluateIfStatementExpression_0(position)).isSucceeded()) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateIfStatementExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, IfKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseStatement(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateIfStatementExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateAssertStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ColonOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateAssertStatementExpression_1(int position) {
    EvaluationResult result;
    if ((result = evaluateAssertStatementExpression_0(position)).isSucceeded()) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateAssertStatementExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, AssertKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateAssertStatementExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateSwitchStatementExpression_0(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = parseSwitchBlockStatementGroup(currentPosition);
      if (result.isSucceeded()) {
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
      if (result.isSucceeded()) {
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
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftCurlySeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateSwitchStatementExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateSwitchStatementExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightCurlySeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateSwitchBlockStatementGroupExpression_0(int position) {
    ArrayList<Object> values = null;
    EvaluationResult result = parseSwitchLabel(position);
    if (!result.isSucceeded()) {
      return EvaluationResult.failure;
    }
    while (true) {
      int currentPosition = result.getPosition();
      values = addValue(values, result);
      result = parseSwitchLabel(currentPosition);
      if (!result.isSucceeded()) {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateSwitchBlockStatementGroupExpression_1(int position) {
    ArrayList<Object> values = null;
    EvaluationResult result = parseBlockStatement(position);
    if (!result.isSucceeded()) {
      return EvaluationResult.failure;
    }
    while (true) {
      int currentPosition = result.getPosition();
      values = addValue(values, result);
      result = parseBlockStatement(currentPosition);
      if (!result.isSucceeded()) {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateSwitchBlockStatementGroupExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateSwitchBlockStatementGroupExpression_0(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateSwitchBlockStatementGroupExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateSwitchLabelExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseCaseSwitchLabel(position)).isSucceeded()) { return result; }
    return parseDefaultSwitchLabel(position);
  }

  private EvaluationResult evaluateCaseSwitchLabelExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, CaseKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), ColonOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateDefaultSwitchLabelExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, DefaultKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), ColonOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateWhileStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, WhileKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseStatement(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateDoStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, DoKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseStatement(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), WhileKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateForStatementExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseBasicForStatement(position)).isSucceeded()) { return result; }
    return parseEnhancedForStatement(position);
  }

  private EvaluationResult evaluateBasicForStatementExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseForInitializer(position)).isSucceeded()) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateBasicForStatementExpression_1(int position) {
    EvaluationResult result;
    if ((result = parseExpression(position)).isSucceeded()) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateBasicForStatementExpression_2(int position) {
    EvaluationResult result;
    if ((result = parseForUpdate(position)).isSucceeded()) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateBasicForStatementExpression_3(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ForKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateBasicForStatementExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateBasicForStatementExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateBasicForStatementExpression_2(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseStatement(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateForInitializerExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseLocalVariableDeclaration(position)).isSucceeded()) { return result; }
    return evaluateArgumentsExpression_2(position);
  }

  private EvaluationResult evaluateEnhancedForStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ForKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseModifiers(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseType(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateQualifiedIdentifierExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), ColonOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseStatement(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateBreakStatementExpression_0(int position) {
    EvaluationResult result;
    if ((result = evaluateQualifiedIdentifierExpression_0(position)).isSucceeded()) {
      return result;
    }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateBreakStatementExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, BreakKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateBreakStatementExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateContinueStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ContinueKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateBreakStatementExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateReturnStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ReturnKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateBasicForStatementExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateThrowStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ThrowKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateBasicForStatementExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), SemicolonSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateSynchronizedStatementExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, SynchronizedKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseBlock(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTryStatementExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseTryStatementWithFinally(position)).isSucceeded()) { return result; }
    return parseTryStatementWithoutFinally(position);
  }

  private EvaluationResult evaluateTryStatementWithFinallyExpression_0(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = parseCatchClause(currentPosition);
      if (result.isSucceeded()) {
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
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseBlock(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateTryStatementWithFinallyExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), FinallyKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseBlock(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateTryStatementWithoutFinallyExpression_0(int position) {
    ArrayList<Object> values = null;
    EvaluationResult result = parseCatchClause(position);
    if (!result.isSucceeded()) {
      return EvaluationResult.failure;
    }
    while (true) {
      int currentPosition = result.getPosition();
      values = addValue(values, result);
      result = parseCatchClause(currentPosition);
      if (!result.isSucceeded()) {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateTryStatementWithoutFinallyExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, TryKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseBlock(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateTryStatementWithoutFinallyExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateCatchClauseExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, CatchKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), LeftParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseFormalParameter(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseBlock(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateExpressionExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseAssignmentOperator(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateExpressionExpression_1(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = evaluateExpressionExpression_0(currentPosition);
      if (result.isSucceeded()) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateExpressionExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseExpression1(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateExpressionExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateAssignmentOperatorExpression_0(int position) {
    EvaluationResult result;
    if ((result = evaluateToken(position, EqualsOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, PlusEqualsOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, MinusEqualsOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, TimesEqualsOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, DivideEqualsOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, AndEqualsOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, OrEqualsOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, ExclusiveOrEqualsOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, ModulusEqualsOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, LeftShiftEqualsOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, RightShiftEqualsOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    return evaluateToken(position, BitwiseRightShiftEqualsOperatorToken.instance);
  }

  private EvaluationResult evaluateExpression1Expression_0(int position) {
    EvaluationResult result;
    if ((result = parseTernaryExpression(position)).isSucceeded()) { return result; }
    return parseExpression2(position);
  }

  private EvaluationResult evaluateTernaryExpressionExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseExpression2(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), QuestionMarkOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), ColonOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateExpression2Expression_0(int position) {
    EvaluationResult result;
    if ((result = parseBinaryExpression(position)).isSucceeded()) { return result; }
    return parseExpression3(position);
  }

  private EvaluationResult evaluateBinaryExpressionExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseInfixOperator(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression3(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateBinaryExpressionExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, InstanceofKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseType(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateBinaryExpressionExpression_2(int position) {
    EvaluationResult result;
    if ((result = evaluateBinaryExpressionExpression_0(position)).isSucceeded()) { return result; }
    return evaluateBinaryExpressionExpression_1(position);
  }

  private EvaluationResult evaluateBinaryExpressionExpression_3(int position) {
    ArrayList<Object> values = null;
    EvaluationResult result = evaluateBinaryExpressionExpression_2(position);
    if (!result.isSucceeded()) {
      return EvaluationResult.failure;
    }
    while (true) {
      int currentPosition = result.getPosition();
      values = addValue(values, result);
      result = evaluateBinaryExpressionExpression_2(currentPosition);
      if (!result.isSucceeded()) {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateBinaryExpressionExpression_4(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseExpression3(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateBinaryExpressionExpression_3(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateInfixOperatorExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, GreaterThanOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), GreaterThanOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), GreaterThanOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateInfixOperatorExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, GreaterThanOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), GreaterThanOperatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateInfixOperatorExpression_2(int position) {
    EvaluationResult result;
    if ((result = evaluateToken(position, LogicalOrOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, LogicalAndOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, BitwiseOrOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, BitwiseExclusiveOrOperatorToken.instance))
        .isSucceeded()) { return result; }
    if ((result = evaluateToken(position, BitwiseAndOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, EqualsEqualsOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, NotEqualsOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, LessThanOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, LessThanOrEqualsOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, GreaterThanOrEqualsOperatorToken.instance))
        .isSucceeded()) { return result; }
    if ((result = evaluateToken(position, LeftShiftOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateInfixOperatorExpression_0(position)).isSucceeded()) { return result; }
    if ((result = evaluateInfixOperatorExpression_1(position)).isSucceeded()) { return result; }
    if ((result = evaluateToken(position, GreaterThanOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, PlusOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, MinusOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, TimesOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, DivideOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    return evaluateToken(position, ModulusOperatorToken.instance);
  }

  private EvaluationResult evaluateExpression3Expression_0(int position) {
    EvaluationResult result;
    if ((result = parsePrefixExpression(position)).isSucceeded()) { return result; }
    if ((result = parsePossibleCastExpression(position)).isSucceeded()) { return result; }
    return parsePrimaryExpression(position);
  }

  private EvaluationResult evaluatePrefixExpressionExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parsePrefixOperator(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression3(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluatePrefixOperatorExpression_0(int position) {
    EvaluationResult result;
    if ((result = evaluateToken(position, IncrementOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, DecrementOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, LogicalNotOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, BitwiseNotOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, PlusOperatorToken.instance)).isSucceeded()) {
      return result;
    }
    return evaluateToken(position, MinusOperatorToken.instance);
  }

  private EvaluationResult evaluatePossibleCastExpressionExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseType(position)).isSucceeded()) { return result; }
    return parseExpression(position);
  }

  private EvaluationResult evaluatePossibleCastExpressionExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LeftParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluatePossibleCastExpressionExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression3(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluatePrimaryExpressionExpression_0(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = parseSelector(currentPosition);
      if (result.isSucceeded()) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluatePrimaryExpressionExpression_1(int position) {
    EvaluationResult result;
    if ((result = parsePostfixOperator(position)).isSucceeded()) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluatePrimaryExpressionExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseValueExpression(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluatePrimaryExpressionExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluatePrimaryExpressionExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluatePostfixOperatorExpression_0(int position) {
    EvaluationResult result;
    if ((result = evaluateToken(position, IncrementOperatorToken.instance)).isSucceeded()) {
      return result;
    }
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
    if ((result = parseParenthesizedExpression(position)).isSucceeded()) { return result; }
    if ((result = parseMethodInvocation(position)).isSucceeded()) { return result; }
    if ((result = parseThisConstructorInvocation(position)).isSucceeded()) { return result; }
    if ((result = parseSuperConstructorInvocation(position)).isSucceeded()) { return result; }
    if ((result = evaluateToken(position, ThisKeywordToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = evaluateToken(position, SuperKeywordToken.instance)).isSucceeded()) {
      return result;
    }
    if ((result = parseClassAccess(position)).isSucceeded()) { return result; }
    if ((result = evaluateValueExpressionExpression_0(position)).isSucceeded()) { return result; }
    if ((result = evaluateQualifiedIdentifierExpression_0(position)).isSucceeded()) {
      return result;
    }
    return parseCreationExpression(position);
  }

  private EvaluationResult evaluateClassAccessExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseType(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), DotSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), ClassKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateSelectorExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseDotSelector(position)).isSucceeded()) { return result; }
    return parseArraySelector(position);
  }

  private EvaluationResult evaluateDotSelectorExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, DotSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseValueExpression(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateArraySelectorExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LeftBracketSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightBracketSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateParenthesizedExpressionExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LeftParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseExpression(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightParenthesisSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateMethodInvocationExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseNonWildcardTypeArguments(position)).isSucceeded()) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateMethodInvocationExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateMethodInvocationExpression_0(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateQualifiedIdentifierExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseArguments(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateThisConstructorInvocationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, ThisKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseArguments(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateSuperConstructorInvocationExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, SuperKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseArguments(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateCreationExpressionExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseObjectCreationExpression(position)).isSucceeded()) { return result; }
    return parseArrayCreationExpression(position);
  }

  private EvaluationResult evaluateObjectCreationExpressionExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseClassBody(position)).isSucceeded()) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateObjectCreationExpressionExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, NewKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateMethodInvocationExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseClassOrInterfaceType(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseArguments(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateObjectCreationExpressionExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateArrayCreationExpressionExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseClassOrInterfaceType(position)).isSucceeded()) { return result; }
    return parsePrimitiveType(position);
  }

  private EvaluationResult evaluateArrayCreationExpressionExpression_1(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LeftBracketSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateBasicForStatementExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightBracketSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateArrayCreationExpressionExpression_2(int position) {
    ArrayList<Object> values = null;
    EvaluationResult result = evaluateArrayCreationExpressionExpression_1(position);
    if (!result.isSucceeded()) {
      return EvaluationResult.failure;
    }
    while (true) {
      int currentPosition = result.getPosition();
      values = addValue(values, result);
      result = evaluateArrayCreationExpressionExpression_1(currentPosition);
      if (!result.isSucceeded()) {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateArrayCreationExpressionExpression_3(int position) {
    EvaluationResult result;
    if ((result = parseArrayInitializer(position)).isSucceeded()) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateArrayCreationExpressionExpression_4(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, NewKeywordToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateMethodInvocationExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateArrayCreationExpressionExpression_0(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateArrayCreationExpressionExpression_2(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateArrayCreationExpressionExpression_3(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateArrayInitializerExpression_0(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, CommaSeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = parseVariableInitializer(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateArrayInitializerExpression_1(int position) {
    int currentPosition = position;
    ArrayList<Object> values = null;
    while (true) {
      EvaluationResult result = evaluateArrayInitializerExpression_0(currentPosition);
      if (result.isSucceeded()) {
        currentPosition = result.getPosition();
        values = addValue(values, result);
      } else {
        return new EvaluationResult(true, currentPosition, trimList(values));
      }
    }
  }

  private EvaluationResult evaluateArrayInitializerExpression_2(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = parseVariableInitializer(position);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateArrayInitializerExpression_1(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateArrayInitializerExpression_3(int position) {
    EvaluationResult result;
    if ((result = evaluateArrayInitializerExpression_2(position)).isSucceeded()) { return result; }
    return new EvaluationResult(true, position);
  }

  private EvaluationResult evaluateArrayInitializerExpression_4(int position) {
    ArrayList<Object> values = null;

    EvaluationResult result = evaluateToken(position, LeftCurlySeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateArrayInitializerExpression_3(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateEnumBodyExpression_4(result.getPosition());
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    result = evaluateToken(result.getPosition(), RightCurlySeparatorToken.instance);
    if (!result.isSucceeded()) { return EvaluationResult.failure; }
    values = addValue(values, result);

    return new EvaluationResult(true, result.getPosition(), trimList(values));
  }

  private EvaluationResult evaluateVariableInitializerExpression_0(int position) {
    EvaluationResult result;
    if ((result = parseArrayInitializer(position)).isSucceeded()) { return result; }
    return parseExpression(position);
  }

  private Map<Integer, EvaluationResult> CompilationUnitMap;

  private EvaluationResult parseCompilationUnit(int position) {
    EvaluationResult result = (CompilationUnitMap == null ? null : CompilationUnitMap.get(
        position));
    if (result == null) {
      result = evaluateCompilationUnitExpression_4(position);
      CompilationUnitMap = initializeMap(CompilationUnitMap);
      CompilationUnitMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> PackageDeclarationMap;

  private EvaluationResult parsePackageDeclaration(int position) {
    EvaluationResult result = (PackageDeclarationMap == null ? null : PackageDeclarationMap.get(
        position));
    if (result == null) {
      result = evaluatePackageDeclarationExpression_1(position);
      PackageDeclarationMap = initializeMap(PackageDeclarationMap);
      PackageDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> QualifiedIdentifierMap;

  private EvaluationResult parseQualifiedIdentifier(int position) {
    EvaluationResult result = (QualifiedIdentifierMap == null ? null : QualifiedIdentifierMap.get(
        position));
    if (result == null) {
      result = evaluateQualifiedIdentifierExpression_3(position);
      QualifiedIdentifierMap = initializeMap(QualifiedIdentifierMap);
      QualifiedIdentifierMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ImportDeclarationMap;

  private EvaluationResult parseImportDeclaration(int position) {
    EvaluationResult result = (ImportDeclarationMap == null ? null : ImportDeclarationMap.get(
        position));
    if (result == null) {
      result = evaluateImportDeclarationExpression_0(position);
      ImportDeclarationMap = initializeMap(ImportDeclarationMap);
      ImportDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SingleTypeImportDeclarationMap;

  private EvaluationResult parseSingleTypeImportDeclaration(int position) {
    EvaluationResult result =
        (SingleTypeImportDeclarationMap == null ? null : SingleTypeImportDeclarationMap.get(
            position));
    if (result == null) {
      result = evaluateSingleTypeImportDeclarationExpression_0(position);
      SingleTypeImportDeclarationMap = initializeMap(SingleTypeImportDeclarationMap);
      SingleTypeImportDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TypeImportOnDemandDeclarationMap;

  private EvaluationResult parseTypeImportOnDemandDeclaration(int position) {
    EvaluationResult result =
        (TypeImportOnDemandDeclarationMap == null ? null : TypeImportOnDemandDeclarationMap.get(
            position));
    if (result == null) {
      result = evaluateTypeImportOnDemandDeclarationExpression_0(position);
      TypeImportOnDemandDeclarationMap = initializeMap(TypeImportOnDemandDeclarationMap);
      TypeImportOnDemandDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SingleStaticImportDeclarationMap;

  private EvaluationResult parseSingleStaticImportDeclaration(int position) {
    EvaluationResult result =
        (SingleStaticImportDeclarationMap == null ? null : SingleStaticImportDeclarationMap.get(
            position));
    if (result == null) {
      result = evaluateSingleStaticImportDeclarationExpression_0(position);
      SingleStaticImportDeclarationMap = initializeMap(SingleStaticImportDeclarationMap);
      SingleStaticImportDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> StaticImportOnDemandDeclarationMap;

  private EvaluationResult parseStaticImportOnDemandDeclaration(int position) {
    EvaluationResult result =
        (StaticImportOnDemandDeclarationMap == null ? null : StaticImportOnDemandDeclarationMap.get(
            position));
    if (result == null) {
      result = evaluateStaticImportOnDemandDeclarationExpression_0(position);
      StaticImportOnDemandDeclarationMap = initializeMap(StaticImportOnDemandDeclarationMap);
      StaticImportOnDemandDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TypeDeclarationMap;

  private EvaluationResult parseTypeDeclaration(int position) {
    EvaluationResult result = (TypeDeclarationMap == null ? null : TypeDeclarationMap.get(
        position));
    if (result == null) {
      result = evaluateTypeDeclarationExpression_0(position);
      TypeDeclarationMap = initializeMap(TypeDeclarationMap);
      TypeDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ClassDeclarationMap;

  private EvaluationResult parseClassDeclaration(int position) {
    EvaluationResult result = (ClassDeclarationMap == null ? null : ClassDeclarationMap.get(
        position));
    if (result == null) {
      result = evaluateClassDeclarationExpression_0(position);
      ClassDeclarationMap = initializeMap(ClassDeclarationMap);
      ClassDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> NormalClassDeclarationMap;

  private EvaluationResult parseNormalClassDeclaration(int position) {
    EvaluationResult result =
        (NormalClassDeclarationMap == null ? null : NormalClassDeclarationMap.get(position));
    if (result == null) {
      result = evaluateNormalClassDeclarationExpression_3(position);
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
      result = evaluateModifierExpression_0(position);
      ModifierMap = initializeMap(ModifierMap);
      ModifierMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SuperMap;

  private EvaluationResult parseSuper(int position) {
    EvaluationResult result = (SuperMap == null ? null : SuperMap.get(position));
    if (result == null) {
      result = evaluateSuperExpression_0(position);
      SuperMap = initializeMap(SuperMap);
      SuperMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> InterfacesMap;

  private EvaluationResult parseInterfaces(int position) {
    EvaluationResult result = (InterfacesMap == null ? null : InterfacesMap.get(position));
    if (result == null) {
      result = evaluateInterfacesExpression_3(position);
      InterfacesMap = initializeMap(InterfacesMap);
      InterfacesMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ClassBodyMap;

  private EvaluationResult parseClassBody(int position) {
    EvaluationResult result = (ClassBodyMap == null ? null : ClassBodyMap.get(position));
    if (result == null) {
      result = evaluateClassBodyExpression_1(position);
      ClassBodyMap = initializeMap(ClassBodyMap);
      ClassBodyMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ClassBodyDeclarationMap;

  private EvaluationResult parseClassBodyDeclaration(int position) {
    EvaluationResult result = (ClassBodyDeclarationMap == null ? null : ClassBodyDeclarationMap.get(
        position));
    if (result == null) {
      result = evaluateClassBodyDeclarationExpression_0(position);
      ClassBodyDeclarationMap = initializeMap(ClassBodyDeclarationMap);
      ClassBodyDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> StaticInitializerMap;

  private EvaluationResult parseStaticInitializer(int position) {
    EvaluationResult result = (StaticInitializerMap == null ? null : StaticInitializerMap.get(
        position));
    if (result == null) {
      result = evaluateStaticInitializerExpression_0(position);
      StaticInitializerMap = initializeMap(StaticInitializerMap);
      StaticInitializerMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> InterfaceDeclarationMap;

  private EvaluationResult parseInterfaceDeclaration(int position) {
    EvaluationResult result = (InterfaceDeclarationMap == null ? null : InterfaceDeclarationMap.get(
        position));
    if (result == null) {
      result = evaluateInterfaceDeclarationExpression_0(position);
      InterfaceDeclarationMap = initializeMap(InterfaceDeclarationMap);
      InterfaceDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> NormalInterfaceDeclarationMap;

  private EvaluationResult parseNormalInterfaceDeclaration(int position) {
    EvaluationResult result =
        (NormalInterfaceDeclarationMap == null ? null : NormalInterfaceDeclarationMap.get(
            position));
    if (result == null) {
      result = evaluateNormalInterfaceDeclarationExpression_1(position);
      NormalInterfaceDeclarationMap = initializeMap(NormalInterfaceDeclarationMap);
      NormalInterfaceDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ExtendsInterfacesMap;

  private EvaluationResult parseExtendsInterfaces(int position) {
    EvaluationResult result = (ExtendsInterfacesMap == null ? null : ExtendsInterfacesMap.get(
        position));
    if (result == null) {
      result = evaluateExtendsInterfacesExpression_0(position);
      ExtendsInterfacesMap = initializeMap(ExtendsInterfacesMap);
      ExtendsInterfacesMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ClassOrInterfaceBodyMap;

  private EvaluationResult parseClassOrInterfaceBody(int position) {
    EvaluationResult result = (ClassOrInterfaceBodyMap == null ? null : ClassOrInterfaceBodyMap.get(
        position));
    if (result == null) {
      result = evaluateClassOrInterfaceBodyExpression_1(position);
      ClassOrInterfaceBodyMap = initializeMap(ClassOrInterfaceBodyMap);
      ClassOrInterfaceBodyMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> EnumDeclarationMap;

  private EvaluationResult parseEnumDeclaration(int position) {
    EvaluationResult result = (EnumDeclarationMap == null ? null : EnumDeclarationMap.get(
        position));
    if (result == null) {
      result = evaluateEnumDeclarationExpression_0(position);
      EnumDeclarationMap = initializeMap(EnumDeclarationMap);
      EnumDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> EnumBodyMap;

  private EvaluationResult parseEnumBody(int position) {
    EvaluationResult result = (EnumBodyMap == null ? null : EnumBodyMap.get(position));
    if (result == null) {
      result = evaluateEnumBodyExpression_6(position);
      EnumBodyMap = initializeMap(EnumBodyMap);
      EnumBodyMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> EnumConstantMap;

  private EvaluationResult parseEnumConstant(int position) {
    EvaluationResult result = (EnumConstantMap == null ? null : EnumConstantMap.get(position));
    if (result == null) {
      result = evaluateEnumConstantExpression_2(position);
      EnumConstantMap = initializeMap(EnumConstantMap);
      EnumConstantMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ArgumentsMap;

  private EvaluationResult parseArguments(int position) {
    EvaluationResult result = (ArgumentsMap == null ? null : ArgumentsMap.get(position));
    if (result == null) {
      result = evaluateArgumentsExpression_4(position);
      ArgumentsMap = initializeMap(ArgumentsMap);
      ArgumentsMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> AnnotationDeclarationMap;

  private EvaluationResult parseAnnotationDeclaration(int position) {
    EvaluationResult result =
        (AnnotationDeclarationMap == null ? null : AnnotationDeclarationMap.get(position));
    if (result == null) {
      result = evaluateAnnotationDeclarationExpression_0(position);
      AnnotationDeclarationMap = initializeMap(AnnotationDeclarationMap);
      AnnotationDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> AnnotationBodyMap;

  private EvaluationResult parseAnnotationBody(int position) {
    EvaluationResult result = (AnnotationBodyMap == null ? null : AnnotationBodyMap.get(position));
    if (result == null) {
      result = evaluateAnnotationBodyExpression_1(position);
      AnnotationBodyMap = initializeMap(AnnotationBodyMap);
      AnnotationBodyMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> AnnotationElementDeclarationMap;

  private EvaluationResult parseAnnotationElementDeclaration(int position) {
    EvaluationResult result =
        (AnnotationElementDeclarationMap == null ? null : AnnotationElementDeclarationMap.get(
            position));
    if (result == null) {
      result = evaluateAnnotationElementDeclarationExpression_0(position);
      AnnotationElementDeclarationMap = initializeMap(AnnotationElementDeclarationMap);
      AnnotationElementDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> AnnotationDefaultDeclarationMap;

  private EvaluationResult parseAnnotationDefaultDeclaration(int position) {
    EvaluationResult result =
        (AnnotationDefaultDeclarationMap == null ? null : AnnotationDefaultDeclarationMap.get(
            position));
    if (result == null) {
      result = evaluateAnnotationDefaultDeclarationExpression_0(position);
      AnnotationDefaultDeclarationMap = initializeMap(AnnotationDefaultDeclarationMap);
      AnnotationDefaultDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ClassOrInterfaceMemberDeclarationMap;

  private EvaluationResult parseClassOrInterfaceMemberDeclaration(int position) {
    EvaluationResult result =
        (ClassOrInterfaceMemberDeclarationMap == null ? null : ClassOrInterfaceMemberDeclarationMap
            .get(position));
    if (result == null) {
      result = evaluateClassOrInterfaceMemberDeclarationExpression_0(position);
      ClassOrInterfaceMemberDeclarationMap = initializeMap(ClassOrInterfaceMemberDeclarationMap);
      ClassOrInterfaceMemberDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ConstructorDeclarationMap;

  private EvaluationResult parseConstructorDeclaration(int position) {
    EvaluationResult result =
        (ConstructorDeclarationMap == null ? null : ConstructorDeclarationMap.get(position));
    if (result == null) {
      result = evaluateConstructorDeclarationExpression_5(position);
      ConstructorDeclarationMap = initializeMap(ConstructorDeclarationMap);
      ConstructorDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> FieldDeclarationMap;

  private EvaluationResult parseFieldDeclaration(int position) {
    EvaluationResult result = (FieldDeclarationMap == null ? null : FieldDeclarationMap.get(
        position));
    if (result == null) {
      result = evaluateFieldDeclarationExpression_3(position);
      FieldDeclarationMap = initializeMap(FieldDeclarationMap);
      FieldDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> VariableDeclaratorMap;

  private EvaluationResult parseVariableDeclarator(int position) {
    EvaluationResult result = (VariableDeclaratorMap == null ? null : VariableDeclaratorMap.get(
        position));
    if (result == null) {
      result = evaluateVariableDeclaratorExpression_2(position);
      VariableDeclaratorMap = initializeMap(VariableDeclaratorMap);
      VariableDeclaratorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> VariableDeclaratorIdMap;

  private EvaluationResult parseVariableDeclaratorId(int position) {
    EvaluationResult result = (VariableDeclaratorIdMap == null ? null : VariableDeclaratorIdMap.get(
        position));
    if (result == null) {
      result = evaluateVariableDeclaratorIdExpression_2(position);
      VariableDeclaratorIdMap = initializeMap(VariableDeclaratorIdMap);
      VariableDeclaratorIdMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> MethodDeclarationMap;

  private EvaluationResult parseMethodDeclaration(int position) {
    EvaluationResult result = (MethodDeclarationMap == null ? null : MethodDeclarationMap.get(
        position));
    if (result == null) {
      result = evaluateMethodDeclarationExpression_1(position);
      MethodDeclarationMap = initializeMap(MethodDeclarationMap);
      MethodDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> FormalParameterMap;

  private EvaluationResult parseFormalParameter(int position) {
    EvaluationResult result = (FormalParameterMap == null ? null : FormalParameterMap.get(
        position));
    if (result == null) {
      result = evaluateFormalParameterExpression_1(position);
      FormalParameterMap = initializeMap(FormalParameterMap);
      FormalParameterMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ThrowsMap;

  private EvaluationResult parseThrows(int position) {
    EvaluationResult result = (ThrowsMap == null ? null : ThrowsMap.get(position));
    if (result == null) {
      result = evaluateThrowsExpression_0(position);
      ThrowsMap = initializeMap(ThrowsMap);
      ThrowsMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TypeParametersMap;

  private EvaluationResult parseTypeParameters(int position) {
    EvaluationResult result = (TypeParametersMap == null ? null : TypeParametersMap.get(position));
    if (result == null) {
      result = evaluateTypeParametersExpression_3(position);
      TypeParametersMap = initializeMap(TypeParametersMap);
      TypeParametersMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TypeParameterMap;

  private EvaluationResult parseTypeParameter(int position) {
    EvaluationResult result = (TypeParameterMap == null ? null : TypeParameterMap.get(position));
    if (result == null) {
      result = evaluateTypeParameterExpression_1(position);
      TypeParameterMap = initializeMap(TypeParameterMap);
      TypeParameterMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TypeBoundMap;

  private EvaluationResult parseTypeBound(int position) {
    EvaluationResult result = (TypeBoundMap == null ? null : TypeBoundMap.get(position));
    if (result == null) {
      result = evaluateTypeBoundExpression_3(position);
      TypeBoundMap = initializeMap(TypeBoundMap);
      TypeBoundMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TypeMap;

  private EvaluationResult parseType(int position) {
    EvaluationResult result = (TypeMap == null ? null : TypeMap.get(position));
    if (result == null) {
      result = evaluateTypeExpression_0(position);
      TypeMap = initializeMap(TypeMap);
      TypeMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ReferenceTypeMap;

  private EvaluationResult parseReferenceType(int position) {
    EvaluationResult result = (ReferenceTypeMap == null ? null : ReferenceTypeMap.get(position));
    if (result == null) {
      result = evaluateReferenceTypeExpression_3(position);
      ReferenceTypeMap = initializeMap(ReferenceTypeMap);
      ReferenceTypeMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ClassOrInterfaceTypeMap;

  private EvaluationResult parseClassOrInterfaceType(int position) {
    EvaluationResult result = (ClassOrInterfaceTypeMap == null ? null : ClassOrInterfaceTypeMap.get(
        position));
    if (result == null) {
      result = evaluateClassOrInterfaceTypeExpression_4(position);
      ClassOrInterfaceTypeMap = initializeMap(ClassOrInterfaceTypeMap);
      ClassOrInterfaceTypeMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TypeArgumentsMap;

  private EvaluationResult parseTypeArguments(int position) {
    EvaluationResult result = (TypeArgumentsMap == null ? null : TypeArgumentsMap.get(position));
    if (result == null) {
      result = evaluateTypeArgumentsExpression_3(position);
      TypeArgumentsMap = initializeMap(TypeArgumentsMap);
      TypeArgumentsMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TypeArgumentMap;

  private EvaluationResult parseTypeArgument(int position) {
    EvaluationResult result = (TypeArgumentMap == null ? null : TypeArgumentMap.get(position));
    if (result == null) {
      result = evaluateTypeArgumentExpression_4(position);
      TypeArgumentMap = initializeMap(TypeArgumentMap);
      TypeArgumentMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> NonWildcardTypeArgumentsMap;

  private EvaluationResult parseNonWildcardTypeArguments(int position) {
    EvaluationResult result =
        (NonWildcardTypeArgumentsMap == null ? null : NonWildcardTypeArgumentsMap.get(position));
    if (result == null) {
      result = evaluateNonWildcardTypeArgumentsExpression_3(position);
      NonWildcardTypeArgumentsMap = initializeMap(NonWildcardTypeArgumentsMap);
      NonWildcardTypeArgumentsMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> PrimitiveTypeMap;

  private EvaluationResult parsePrimitiveType(int position) {
    EvaluationResult result = (PrimitiveTypeMap == null ? null : PrimitiveTypeMap.get(position));
    if (result == null) {
      result = evaluatePrimitiveTypeExpression_0(position);
      PrimitiveTypeMap = initializeMap(PrimitiveTypeMap);
      PrimitiveTypeMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> AnnotationMap;

  private EvaluationResult parseAnnotation(int position) {
    EvaluationResult result = (AnnotationMap == null ? null : AnnotationMap.get(position));
    if (result == null) {
      result = evaluateAnnotationExpression_0(position);
      AnnotationMap = initializeMap(AnnotationMap);
      AnnotationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> NormalAnnotationMap;

  private EvaluationResult parseNormalAnnotation(int position) {
    EvaluationResult result = (NormalAnnotationMap == null ? null : NormalAnnotationMap.get(
        position));
    if (result == null) {
      result = evaluateNormalAnnotationExpression_3(position);
      NormalAnnotationMap = initializeMap(NormalAnnotationMap);
      NormalAnnotationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ElementValuePairMap;

  private EvaluationResult parseElementValuePair(int position) {
    EvaluationResult result = (ElementValuePairMap == null ? null : ElementValuePairMap.get(
        position));
    if (result == null) {
      result = evaluateElementValuePairExpression_0(position);
      ElementValuePairMap = initializeMap(ElementValuePairMap);
      ElementValuePairMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SingleElementAnnotationMap;

  private EvaluationResult parseSingleElementAnnotation(int position) {
    EvaluationResult result =
        (SingleElementAnnotationMap == null ? null : SingleElementAnnotationMap.get(position));
    if (result == null) {
      result = evaluateSingleElementAnnotationExpression_0(position);
      SingleElementAnnotationMap = initializeMap(SingleElementAnnotationMap);
      SingleElementAnnotationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> MarkerAnnotationMap;

  private EvaluationResult parseMarkerAnnotation(int position) {
    EvaluationResult result = (MarkerAnnotationMap == null ? null : MarkerAnnotationMap.get(
        position));
    if (result == null) {
      result = evaluateMarkerAnnotationExpression_0(position);
      MarkerAnnotationMap = initializeMap(MarkerAnnotationMap);
      MarkerAnnotationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ElementValueMap;

  private EvaluationResult parseElementValue(int position) {
    EvaluationResult result = (ElementValueMap == null ? null : ElementValueMap.get(position));
    if (result == null) {
      result = evaluateElementValueExpression_0(position);
      ElementValueMap = initializeMap(ElementValueMap);
      ElementValueMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ElementValueArrayInitializerMap;

  private EvaluationResult parseElementValueArrayInitializer(int position) {
    EvaluationResult result =
        (ElementValueArrayInitializerMap == null ? null : ElementValueArrayInitializerMap.get(
            position));
    if (result == null) {
      result = evaluateElementValueArrayInitializerExpression_4(position);
      ElementValueArrayInitializerMap = initializeMap(ElementValueArrayInitializerMap);
      ElementValueArrayInitializerMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> BlockMap;

  private EvaluationResult parseBlock(int position) {
    EvaluationResult result = (BlockMap == null ? null : BlockMap.get(position));
    if (result == null) {
      result = evaluateBlockExpression_1(position);
      BlockMap = initializeMap(BlockMap);
      BlockMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> BlockStatementMap;

  private EvaluationResult parseBlockStatement(int position) {
    EvaluationResult result = (BlockStatementMap == null ? null : BlockStatementMap.get(position));
    if (result == null) {
      result = evaluateBlockStatementExpression_0(position);
      BlockStatementMap = initializeMap(BlockStatementMap);
      BlockStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> LocalVariableDeclarationStatementMap;

  private EvaluationResult parseLocalVariableDeclarationStatement(int position) {
    EvaluationResult result =
        (LocalVariableDeclarationStatementMap == null ? null : LocalVariableDeclarationStatementMap
            .get(position));
    if (result == null) {
      result = evaluateLocalVariableDeclarationStatementExpression_0(position);
      LocalVariableDeclarationStatementMap = initializeMap(LocalVariableDeclarationStatementMap);
      LocalVariableDeclarationStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> LocalVariableDeclarationMap;

  private EvaluationResult parseLocalVariableDeclaration(int position) {
    EvaluationResult result =
        (LocalVariableDeclarationMap == null ? null : LocalVariableDeclarationMap.get(position));
    if (result == null) {
      result = evaluateLocalVariableDeclarationExpression_0(position);
      LocalVariableDeclarationMap = initializeMap(LocalVariableDeclarationMap);
      LocalVariableDeclarationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> StatementMap;

  private EvaluationResult parseStatement(int position) {
    EvaluationResult result = (StatementMap == null ? null : StatementMap.get(position));
    if (result == null) {
      result = evaluateStatementExpression_0(position);
      StatementMap = initializeMap(StatementMap);
      StatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> EmptyStatementMap;

  private EvaluationResult parseEmptyStatement(int position) {
    EvaluationResult result = (EmptyStatementMap == null ? null : EmptyStatementMap.get(position));
    if (result == null) {
      result = evaluateToken(position, SemicolonSeparatorToken.instance);
      EmptyStatementMap = initializeMap(EmptyStatementMap);
      EmptyStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> LabeledStatementMap;

  private EvaluationResult parseLabeledStatement(int position) {
    EvaluationResult result = (LabeledStatementMap == null ? null : LabeledStatementMap.get(
        position));
    if (result == null) {
      result = evaluateLabeledStatementExpression_0(position);
      LabeledStatementMap = initializeMap(LabeledStatementMap);
      LabeledStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ExpressionStatementMap;

  private EvaluationResult parseExpressionStatement(int position) {
    EvaluationResult result = (ExpressionStatementMap == null ? null : ExpressionStatementMap.get(
        position));
    if (result == null) {
      result = evaluateExpressionStatementExpression_0(position);
      ExpressionStatementMap = initializeMap(ExpressionStatementMap);
      ExpressionStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> IfStatementMap;

  private EvaluationResult parseIfStatement(int position) {
    EvaluationResult result = (IfStatementMap == null ? null : IfStatementMap.get(position));
    if (result == null) {
      result = evaluateIfStatementExpression_2(position);
      IfStatementMap = initializeMap(IfStatementMap);
      IfStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> AssertStatementMap;

  private EvaluationResult parseAssertStatement(int position) {
    EvaluationResult result = (AssertStatementMap == null ? null : AssertStatementMap.get(
        position));
    if (result == null) {
      result = evaluateAssertStatementExpression_2(position);
      AssertStatementMap = initializeMap(AssertStatementMap);
      AssertStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SwitchStatementMap;

  private EvaluationResult parseSwitchStatement(int position) {
    EvaluationResult result = (SwitchStatementMap == null ? null : SwitchStatementMap.get(
        position));
    if (result == null) {
      result = evaluateSwitchStatementExpression_2(position);
      SwitchStatementMap = initializeMap(SwitchStatementMap);
      SwitchStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SwitchBlockStatementGroupMap;

  private EvaluationResult parseSwitchBlockStatementGroup(int position) {
    EvaluationResult result =
        (SwitchBlockStatementGroupMap == null ? null : SwitchBlockStatementGroupMap.get(position));
    if (result == null) {
      result = evaluateSwitchBlockStatementGroupExpression_2(position);
      SwitchBlockStatementGroupMap = initializeMap(SwitchBlockStatementGroupMap);
      SwitchBlockStatementGroupMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SwitchLabelMap;

  private EvaluationResult parseSwitchLabel(int position) {
    EvaluationResult result = (SwitchLabelMap == null ? null : SwitchLabelMap.get(position));
    if (result == null) {
      result = evaluateSwitchLabelExpression_0(position);
      SwitchLabelMap = initializeMap(SwitchLabelMap);
      SwitchLabelMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> CaseSwitchLabelMap;

  private EvaluationResult parseCaseSwitchLabel(int position) {
    EvaluationResult result = (CaseSwitchLabelMap == null ? null : CaseSwitchLabelMap.get(
        position));
    if (result == null) {
      result = evaluateCaseSwitchLabelExpression_0(position);
      CaseSwitchLabelMap = initializeMap(CaseSwitchLabelMap);
      CaseSwitchLabelMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> DefaultSwitchLabelMap;

  private EvaluationResult parseDefaultSwitchLabel(int position) {
    EvaluationResult result = (DefaultSwitchLabelMap == null ? null : DefaultSwitchLabelMap.get(
        position));
    if (result == null) {
      result = evaluateDefaultSwitchLabelExpression_0(position);
      DefaultSwitchLabelMap = initializeMap(DefaultSwitchLabelMap);
      DefaultSwitchLabelMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> WhileStatementMap;

  private EvaluationResult parseWhileStatement(int position) {
    EvaluationResult result = (WhileStatementMap == null ? null : WhileStatementMap.get(position));
    if (result == null) {
      result = evaluateWhileStatementExpression_0(position);
      WhileStatementMap = initializeMap(WhileStatementMap);
      WhileStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> DoStatementMap;

  private EvaluationResult parseDoStatement(int position) {
    EvaluationResult result = (DoStatementMap == null ? null : DoStatementMap.get(position));
    if (result == null) {
      result = evaluateDoStatementExpression_0(position);
      DoStatementMap = initializeMap(DoStatementMap);
      DoStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ForStatementMap;

  private EvaluationResult parseForStatement(int position) {
    EvaluationResult result = (ForStatementMap == null ? null : ForStatementMap.get(position));
    if (result == null) {
      result = evaluateForStatementExpression_0(position);
      ForStatementMap = initializeMap(ForStatementMap);
      ForStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> BasicForStatementMap;

  private EvaluationResult parseBasicForStatement(int position) {
    EvaluationResult result = (BasicForStatementMap == null ? null : BasicForStatementMap.get(
        position));
    if (result == null) {
      result = evaluateBasicForStatementExpression_3(position);
      BasicForStatementMap = initializeMap(BasicForStatementMap);
      BasicForStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ForInitializerMap;

  private EvaluationResult parseForInitializer(int position) {
    EvaluationResult result = (ForInitializerMap == null ? null : ForInitializerMap.get(position));
    if (result == null) {
      result = evaluateForInitializerExpression_0(position);
      ForInitializerMap = initializeMap(ForInitializerMap);
      ForInitializerMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ForUpdateMap;

  private EvaluationResult parseForUpdate(int position) {
    EvaluationResult result = (ForUpdateMap == null ? null : ForUpdateMap.get(position));
    if (result == null) {
      result = evaluateArgumentsExpression_2(position);
      ForUpdateMap = initializeMap(ForUpdateMap);
      ForUpdateMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> EnhancedForStatementMap;

  private EvaluationResult parseEnhancedForStatement(int position) {
    EvaluationResult result = (EnhancedForStatementMap == null ? null : EnhancedForStatementMap.get(
        position));
    if (result == null) {
      result = evaluateEnhancedForStatementExpression_0(position);
      EnhancedForStatementMap = initializeMap(EnhancedForStatementMap);
      EnhancedForStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> BreakStatementMap;

  private EvaluationResult parseBreakStatement(int position) {
    EvaluationResult result = (BreakStatementMap == null ? null : BreakStatementMap.get(position));
    if (result == null) {
      result = evaluateBreakStatementExpression_1(position);
      BreakStatementMap = initializeMap(BreakStatementMap);
      BreakStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ContinueStatementMap;

  private EvaluationResult parseContinueStatement(int position) {
    EvaluationResult result = (ContinueStatementMap == null ? null : ContinueStatementMap.get(
        position));
    if (result == null) {
      result = evaluateContinueStatementExpression_0(position);
      ContinueStatementMap = initializeMap(ContinueStatementMap);
      ContinueStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ReturnStatementMap;

  private EvaluationResult parseReturnStatement(int position) {
    EvaluationResult result = (ReturnStatementMap == null ? null : ReturnStatementMap.get(
        position));
    if (result == null) {
      result = evaluateReturnStatementExpression_0(position);
      ReturnStatementMap = initializeMap(ReturnStatementMap);
      ReturnStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ThrowStatementMap;

  private EvaluationResult parseThrowStatement(int position) {
    EvaluationResult result = (ThrowStatementMap == null ? null : ThrowStatementMap.get(position));
    if (result == null) {
      result = evaluateThrowStatementExpression_0(position);
      ThrowStatementMap = initializeMap(ThrowStatementMap);
      ThrowStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SynchronizedStatementMap;

  private EvaluationResult parseSynchronizedStatement(int position) {
    EvaluationResult result =
        (SynchronizedStatementMap == null ? null : SynchronizedStatementMap.get(position));
    if (result == null) {
      result = evaluateSynchronizedStatementExpression_0(position);
      SynchronizedStatementMap = initializeMap(SynchronizedStatementMap);
      SynchronizedStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TryStatementMap;

  private EvaluationResult parseTryStatement(int position) {
    EvaluationResult result = (TryStatementMap == null ? null : TryStatementMap.get(position));
    if (result == null) {
      result = evaluateTryStatementExpression_0(position);
      TryStatementMap = initializeMap(TryStatementMap);
      TryStatementMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TryStatementWithFinallyMap;

  private EvaluationResult parseTryStatementWithFinally(int position) {
    EvaluationResult result =
        (TryStatementWithFinallyMap == null ? null : TryStatementWithFinallyMap.get(position));
    if (result == null) {
      result = evaluateTryStatementWithFinallyExpression_1(position);
      TryStatementWithFinallyMap = initializeMap(TryStatementWithFinallyMap);
      TryStatementWithFinallyMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TryStatementWithoutFinallyMap;

  private EvaluationResult parseTryStatementWithoutFinally(int position) {
    EvaluationResult result =
        (TryStatementWithoutFinallyMap == null ? null : TryStatementWithoutFinallyMap.get(
            position));
    if (result == null) {
      result = evaluateTryStatementWithoutFinallyExpression_1(position);
      TryStatementWithoutFinallyMap = initializeMap(TryStatementWithoutFinallyMap);
      TryStatementWithoutFinallyMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> CatchClauseMap;

  private EvaluationResult parseCatchClause(int position) {
    EvaluationResult result = (CatchClauseMap == null ? null : CatchClauseMap.get(position));
    if (result == null) {
      result = evaluateCatchClauseExpression_0(position);
      CatchClauseMap = initializeMap(CatchClauseMap);
      CatchClauseMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ExpressionMap;

  private EvaluationResult parseExpression(int position) {
    EvaluationResult result = (ExpressionMap == null ? null : ExpressionMap.get(position));
    if (result == null) {
      result = evaluateExpressionExpression_2(position);
      ExpressionMap = initializeMap(ExpressionMap);
      ExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> AssignmentOperatorMap;

  private EvaluationResult parseAssignmentOperator(int position) {
    EvaluationResult result = (AssignmentOperatorMap == null ? null : AssignmentOperatorMap.get(
        position));
    if (result == null) {
      result = evaluateAssignmentOperatorExpression_0(position);
      AssignmentOperatorMap = initializeMap(AssignmentOperatorMap);
      AssignmentOperatorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> Expression1Map;

  private EvaluationResult parseExpression1(int position) {
    EvaluationResult result = (Expression1Map == null ? null : Expression1Map.get(position));
    if (result == null) {
      result = evaluateExpression1Expression_0(position);
      Expression1Map = initializeMap(Expression1Map);
      Expression1Map.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> TernaryExpressionMap;

  private EvaluationResult parseTernaryExpression(int position) {
    EvaluationResult result = (TernaryExpressionMap == null ? null : TernaryExpressionMap.get(
        position));
    if (result == null) {
      result = evaluateTernaryExpressionExpression_0(position);
      TernaryExpressionMap = initializeMap(TernaryExpressionMap);
      TernaryExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> Expression2Map;

  private EvaluationResult parseExpression2(int position) {
    EvaluationResult result = (Expression2Map == null ? null : Expression2Map.get(position));
    if (result == null) {
      result = evaluateExpression2Expression_0(position);
      Expression2Map = initializeMap(Expression2Map);
      Expression2Map.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> BinaryExpressionMap;

  private EvaluationResult parseBinaryExpression(int position) {
    EvaluationResult result = (BinaryExpressionMap == null ? null : BinaryExpressionMap.get(
        position));
    if (result == null) {
      result = evaluateBinaryExpressionExpression_4(position);
      BinaryExpressionMap = initializeMap(BinaryExpressionMap);
      BinaryExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> InfixOperatorMap;

  private EvaluationResult parseInfixOperator(int position) {
    EvaluationResult result = (InfixOperatorMap == null ? null : InfixOperatorMap.get(position));
    if (result == null) {
      result = evaluateInfixOperatorExpression_2(position);
      InfixOperatorMap = initializeMap(InfixOperatorMap);
      InfixOperatorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> Expression3Map;

  private EvaluationResult parseExpression3(int position) {
    EvaluationResult result = (Expression3Map == null ? null : Expression3Map.get(position));
    if (result == null) {
      result = evaluateExpression3Expression_0(position);
      Expression3Map = initializeMap(Expression3Map);
      Expression3Map.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> PrefixExpressionMap;

  private EvaluationResult parsePrefixExpression(int position) {
    EvaluationResult result = (PrefixExpressionMap == null ? null : PrefixExpressionMap.get(
        position));
    if (result == null) {
      result = evaluatePrefixExpressionExpression_0(position);
      PrefixExpressionMap = initializeMap(PrefixExpressionMap);
      PrefixExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> PrefixOperatorMap;

  private EvaluationResult parsePrefixOperator(int position) {
    EvaluationResult result = (PrefixOperatorMap == null ? null : PrefixOperatorMap.get(position));
    if (result == null) {
      result = evaluatePrefixOperatorExpression_0(position);
      PrefixOperatorMap = initializeMap(PrefixOperatorMap);
      PrefixOperatorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> PossibleCastExpressionMap;

  private EvaluationResult parsePossibleCastExpression(int position) {
    EvaluationResult result =
        (PossibleCastExpressionMap == null ? null : PossibleCastExpressionMap.get(position));
    if (result == null) {
      result = evaluatePossibleCastExpressionExpression_1(position);
      PossibleCastExpressionMap = initializeMap(PossibleCastExpressionMap);
      PossibleCastExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> PrimaryExpressionMap;

  private EvaluationResult parsePrimaryExpression(int position) {
    EvaluationResult result = (PrimaryExpressionMap == null ? null : PrimaryExpressionMap.get(
        position));
    if (result == null) {
      result = evaluatePrimaryExpressionExpression_2(position);
      PrimaryExpressionMap = initializeMap(PrimaryExpressionMap);
      PrimaryExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> PostfixOperatorMap;

  private EvaluationResult parsePostfixOperator(int position) {
    EvaluationResult result = (PostfixOperatorMap == null ? null : PostfixOperatorMap.get(
        position));
    if (result == null) {
      result = evaluatePostfixOperatorExpression_0(position);
      PostfixOperatorMap = initializeMap(PostfixOperatorMap);
      PostfixOperatorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ValueExpressionMap;

  private EvaluationResult parseValueExpression(int position) {
    EvaluationResult result = (ValueExpressionMap == null ? null : ValueExpressionMap.get(
        position));
    if (result == null) {
      result = evaluateValueExpressionExpression_1(position);
      ValueExpressionMap = initializeMap(ValueExpressionMap);
      ValueExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ClassAccessMap;

  private EvaluationResult parseClassAccess(int position) {
    EvaluationResult result = (ClassAccessMap == null ? null : ClassAccessMap.get(position));
    if (result == null) {
      result = evaluateClassAccessExpression_0(position);
      ClassAccessMap = initializeMap(ClassAccessMap);
      ClassAccessMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SelectorMap;

  private EvaluationResult parseSelector(int position) {
    EvaluationResult result = (SelectorMap == null ? null : SelectorMap.get(position));
    if (result == null) {
      result = evaluateSelectorExpression_0(position);
      SelectorMap = initializeMap(SelectorMap);
      SelectorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> DotSelectorMap;

  private EvaluationResult parseDotSelector(int position) {
    EvaluationResult result = (DotSelectorMap == null ? null : DotSelectorMap.get(position));
    if (result == null) {
      result = evaluateDotSelectorExpression_0(position);
      DotSelectorMap = initializeMap(DotSelectorMap);
      DotSelectorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ArraySelectorMap;

  private EvaluationResult parseArraySelector(int position) {
    EvaluationResult result = (ArraySelectorMap == null ? null : ArraySelectorMap.get(position));
    if (result == null) {
      result = evaluateArraySelectorExpression_0(position);
      ArraySelectorMap = initializeMap(ArraySelectorMap);
      ArraySelectorMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ParenthesizedExpressionMap;

  private EvaluationResult parseParenthesizedExpression(int position) {
    EvaluationResult result =
        (ParenthesizedExpressionMap == null ? null : ParenthesizedExpressionMap.get(position));
    if (result == null) {
      result = evaluateParenthesizedExpressionExpression_0(position);
      ParenthesizedExpressionMap = initializeMap(ParenthesizedExpressionMap);
      ParenthesizedExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> MethodInvocationMap;

  private EvaluationResult parseMethodInvocation(int position) {
    EvaluationResult result = (MethodInvocationMap == null ? null : MethodInvocationMap.get(
        position));
    if (result == null) {
      result = evaluateMethodInvocationExpression_1(position);
      MethodInvocationMap = initializeMap(MethodInvocationMap);
      MethodInvocationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ThisConstructorInvocationMap;

  private EvaluationResult parseThisConstructorInvocation(int position) {
    EvaluationResult result =
        (ThisConstructorInvocationMap == null ? null : ThisConstructorInvocationMap.get(position));
    if (result == null) {
      result = evaluateThisConstructorInvocationExpression_0(position);
      ThisConstructorInvocationMap = initializeMap(ThisConstructorInvocationMap);
      ThisConstructorInvocationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> SuperConstructorInvocationMap;

  private EvaluationResult parseSuperConstructorInvocation(int position) {
    EvaluationResult result =
        (SuperConstructorInvocationMap == null ? null : SuperConstructorInvocationMap.get(
            position));
    if (result == null) {
      result = evaluateSuperConstructorInvocationExpression_0(position);
      SuperConstructorInvocationMap = initializeMap(SuperConstructorInvocationMap);
      SuperConstructorInvocationMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> CreationExpressionMap;

  private EvaluationResult parseCreationExpression(int position) {
    EvaluationResult result = (CreationExpressionMap == null ? null : CreationExpressionMap.get(
        position));
    if (result == null) {
      result = evaluateCreationExpressionExpression_0(position);
      CreationExpressionMap = initializeMap(CreationExpressionMap);
      CreationExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ObjectCreationExpressionMap;

  private EvaluationResult parseObjectCreationExpression(int position) {
    EvaluationResult result =
        (ObjectCreationExpressionMap == null ? null : ObjectCreationExpressionMap.get(position));
    if (result == null) {
      result = evaluateObjectCreationExpressionExpression_1(position);
      ObjectCreationExpressionMap = initializeMap(ObjectCreationExpressionMap);
      ObjectCreationExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ArrayCreationExpressionMap;

  private EvaluationResult parseArrayCreationExpression(int position) {
    EvaluationResult result =
        (ArrayCreationExpressionMap == null ? null : ArrayCreationExpressionMap.get(position));
    if (result == null) {
      result = evaluateArrayCreationExpressionExpression_4(position);
      ArrayCreationExpressionMap = initializeMap(ArrayCreationExpressionMap);
      ArrayCreationExpressionMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> ArrayInitializerMap;

  private EvaluationResult parseArrayInitializer(int position) {
    EvaluationResult result = (ArrayInitializerMap == null ? null : ArrayInitializerMap.get(
        position));
    if (result == null) {
      result = evaluateArrayInitializerExpression_4(position);
      ArrayInitializerMap = initializeMap(ArrayInitializerMap);
      ArrayInitializerMap.put(position, result);
    }
    return result;
  }

  private Map<Integer, EvaluationResult> VariableInitializerMap;

  private EvaluationResult parseVariableInitializer(int position) {
    EvaluationResult result = (VariableInitializerMap == null ? null : VariableInitializerMap.get(
        position));
    if (result == null) {
      result = evaluateVariableInitializerExpression_0(position);
      VariableInitializerMap = initializeMap(VariableInitializerMap);
      VariableInitializerMap.put(position, result);
    }
    return result;
  }

  protected abstract EvaluationResult anyToken(int position);
}