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

package org.metasyntactic.programs;

import org.metasyntactic.automata.compiler.framework.parsers.Source;
import org.metasyntactic.automata.compiler.framework.parsers.SourceToken;
import org.metasyntactic.automata.compiler.java.parser.JavaGeneratedParser;
import org.metasyntactic.automata.compiler.java.parser.JavaGrammar;
import org.metasyntactic.automata.compiler.java.parser.JavaParser;
import org.metasyntactic.automata.compiler.java.scanner.JavaLexicalAnalyzer;
import org.metasyntactic.automata.compiler.java.scanner.JavaScanner;
import org.metasyntactic.automata.compiler.java.scanner.JavaToken;

import java.io.*;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class ParseJavaFilesProgram {
  static long totalInterpreterTime;
  static long totalParserTime;
  static long totalLexTime;
  static long totalFiles;
  static long totalFileSize;

  public static void main(String... args) throws IOException {
    System.out.println(JavaGrammar.instance);

    if (true) {
      //  return;
    }

    if (false) {
    } else {
      //File start = new File("/home/cyrusn/Desktop/classes");
      File start = new File("/Projects/jdk/Projects/j2se/src/share/classes/");
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
        return;
      }
    }

    List<SourceToken<JavaToken>> analyzedTokens = new JavaLexicalAnalyzer().analyze(tokens);
    {
      long start = System.currentTimeMillis();
      JavaParser parser = new JavaParser(analyzedTokens);
      Object result = parser.parse();
      long diff = System.currentTimeMillis() - start;

      totalInterpreterTime += diff;

      if (result == null) {
        System.out.println("Couldn't parse: " + file);
        
        JavaGeneratedParser parser2 = new JavaGeneratedParser((List) analyzedTokens);
        Object result2 = parser.parse();

        return;
      }
    }

    {
      long start = System.currentTimeMillis();
      JavaGeneratedParser parser = new JavaGeneratedParser((List) analyzedTokens);
      Object result = parser.parse();
      long diff = System.currentTimeMillis() - start;

      totalParserTime += diff;

      if (result == null) {
        System.out.println("Couldn't parse: " + file);

        JavaGeneratedParser parser2 = new JavaGeneratedParser((List) analyzedTokens);
        Object result2 = parser.parse();

        return;
      }
    }

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
}
