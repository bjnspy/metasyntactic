// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner;

import com.google.automata.compiler.framework.parsers.Source;

/**
 * TODO(cyrusn): javadoc
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class JavaPreprocessor {
  public Source preprocess(Source source) {
    String preprocessedText = preprocess(source.getText());
    return new Source(preprocessedText);
  }

  private static String preprocess(String text) {
    StringBuilder builder = new StringBuilder();

    for (int i = 0; i < text.length(); i++) {
      char c = getChar(text, i);

      if (c == '\\') {
        char nextChar = getChar(text, i + 1);

        if (getChar(text, i + 1) == '\\') {
          builder.append('\\');
          builder.append('\\');

          i += 1;
        } else if (nextChar == 'u') {
          char h1 = getChar(text, i + 2),
              h2 = getChar(text, i + 3),
              h3 = getChar(text, i + 4),
              h4 = getChar(text, i + 5);

          if (isHexDigit(h1) && isHexDigit(h2) && isHexDigit(h3) && isHexDigit(h4)) {

            int result = 0;
            result = result * 16 + digitToInt(h1);
            result = result * 16 + digitToInt(h2);
            result = result * 16 + digitToInt(h3);
            result = result * 16 + digitToInt(h4);

            for (char v : Character.toChars(result)) {
              builder.append(v);
            }

            i += 5; //'u' + 4 digits
          }
        } else {
          builder.append('\\');
        }
      } else {
        builder.append(c);
      }
    }

    return builder.toString();
  }

  private static int digitToInt(char h1) {
    if (h1 >= '0' && h1 <= '9') {
      return h1 - '0';
    } else if (h1 >= 'a' && h1 <= 'f') {
      return 10 + (h1 - 'a');
    } else {
      return 10 + (h1 - 'A');
    }
  }

  private static boolean isHexDigit(char h1) {
    return (h1 >= '0' && h1 <= '9') || (h1 >= 'a' && h1 <= 'f') || (h1 >= 'A' && h1 <= 'F');
  }

  private static char getChar(String text, int index) {
    if (index < text.length()) {
      return text.charAt(index);
    }

    return 0;
  }
}
