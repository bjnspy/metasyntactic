package org.metasyntactic.automata.compiler.java.scanner.keywords;

import org.metasyntactic.automata.compiler.java.scanner.JavaToken;

import java.util.*;

public abstract class KeywordToken extends JavaToken {
  private final static Map<String, KeywordToken> map = new HashMap<String, KeywordToken>();

  static {
    KeywordToken[] tokens = new KeywordToken[]{
        AbstractKeywordToken.instance,
        ContinueKeywordToken.instance,
        ForKeywordToken.instance,
        NewKeywordToken.instance,
        SwitchKeywordToken.instance,
        AssertKeywordToken.instance,
        DefaultKeywordToken.instance,
        IfKeywordToken.instance,
        PackageKeywordToken.instance,
        SynchronizedKeywordToken.instance,
        BooleanKeywordToken.instance,
        DoKeywordToken.instance,
        GotoKeywordToken.instance,
        PrivateKeywordToken.instance,
        ThisKeywordToken.instance,
        BreakKeywordToken.instance,
        DoubleKeywordToken.instance,
        ImplementsKeywordToken.instance,
        ProtectedKeywordToken.instance,
        ThrowKeywordToken.instance,
        ByteKeywordToken.instance,
        ElseKeywordToken.instance,
        ImportKeywordToken.instance,
        PublicKeywordToken.instance,
        ThrowsKeywordToken.instance,
        CaseKeywordToken.instance,
        EnumKeywordToken.instance,
        InstanceofKeywordToken.instance,
        ReturnKeywordToken.instance,
        TransientKeywordToken.instance,
        CatchKeywordToken.instance,
        ExtendsKeywordToken.instance,
        IntKeywordToken.instance,
        ShortKeywordToken.instance,
        TryKeywordToken.instance,
        CharKeywordToken.instance,
        FinalKeywordToken.instance,
        InterfaceKeywordToken.instance,
        StaticKeywordToken.instance,
        VoidKeywordToken.instance,
        ClassKeywordToken.instance,
        FinallyKeywordToken.instance,
        LongKeywordToken.instance,
        StrictfpKeywordToken.instance,
        VolatileKeywordToken.instance,
        ConstKeywordToken.instance,
        FloatKeywordToken.instance,
        NativeKeywordToken.instance,
        SuperKeywordToken.instance,
        WhileKeywordToken.instance
    };

    Set<String> keywords = new LinkedHashSet<String>(Arrays.asList(getKeywords()));
    if (keywords.size() != tokens.length) {
      throw new IllegalStateException();
    }

    for (KeywordToken token : tokens) {
      map.put(token.getText(), token);
    }
  }

  protected KeywordToken(String text) {
    super(text);
  }

  public static KeywordToken getKeywordToken(String text) {
    KeywordToken token = map.get(text);

    if (token == null) {
      throw new IllegalArgumentException("Unknown keyword: " + text);
    }

    return token;
  }

  public static String[] getKeywords() {
    return new String[]{
        "abstract",
        "continue",
        "for",
        "new",
        "switch",
        "assert",
        "default",
        "if",
        "package",
        "synchronized",
        "boolean",
        "do",
        "goto",
        "private",
        "this",
        "break",
        "double",
        "implements",
        "protected",
        "throw",
        "byte",
        "else",
        "import",
        "public",
        "throws",
        "case",
        "enum",
        "instanceof",
        "return",
        "transient",
        "catch",
        "extends",
        "int",
        "short",
        "try",
        "char",
        "final",
        "interface",
        "static",
        "void",
        "class",
        "finally",
        "long",
        "strictfp",
        "volatile",
        "const",
        "float",
        "native",
        "super",
        "while"
    };
  }
}