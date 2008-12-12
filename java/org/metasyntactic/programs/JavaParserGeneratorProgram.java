// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.programs;

import org.metasyntactic.automata.compiler.framework.parsers.packrat.generator.java.JavaParserGenerator;
import org.metasyntactic.automata.compiler.java.parser.JavaGrammar;

/**
 * TODO(cyrusn): javadoc
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class JavaParserGeneratorProgram {
  public static void main(String... args) {
    JavaParserGenerator generator = new JavaParserGenerator(JavaGrammar.instance,
                                                            "AbstractJavaGeneratedParser",
                                                            "org.metasyntactic.automata.compiler.java.parser");
    String result = generator.generate();
    System.out.println(result);
  }
}