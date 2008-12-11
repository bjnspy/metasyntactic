// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.util;

import java.io.IOException;
import java.io.Writer;

/**
 * TODO(cyrusn): javadoc
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class IndentingWriter extends Writer {
  private final Writer writer;
  private final String indentString;

  private int indentLevel;
  private boolean needsIndent;

  public IndentingWriter(Writer writer) {
    this(writer, 0, "  ");
  }

  public IndentingWriter(Writer writer, String indentString) {
    this(writer, 0, indentString);
  }

  public IndentingWriter(Writer writer, int indentLevel, String indentString) {
    this.writer = writer;
    this.indentLevel = indentLevel;
    this.indentString = indentString;
  }

  public int getIndentLevel() {
    return indentLevel;
  }

  public void indent() {
    indentLevel++;
  }

  public void dedent() {
    indentLevel--;
  }

  public void writeLine() {
    try {
      write("\n");
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }

  public void writeLineAndIndent(String line) {
    writeLine(line);
    indent();
  }

  public void dedentAndWriteLine(String line) {
    dedent();
    writeLine(line);
  }

  public void dedentWriteLineAndIndent(String line) {
    dedent();
    writeLine(line);
    indent();
  }

  public void writeLine(String line) {
    try {
      write(line);
      write("\n");
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }

   public void write(char cbuf[], int off, int len) throws IOException {
    for (int i = 0; i < len; i++) {
      final char c = cbuf[i + off];
      if (c == '\r' || c == '\n') {
        needsIndent = true;
      } else if (needsIndent) {
        writeIndent();
        needsIndent = false;
      }

      writer.write(c);
    }
  }

  private void writeIndent() throws IOException {
    for (int i = 0; i < indentLevel; i++) {
      writer.write(indentString);
    }
  }

   public void flush() throws IOException {
    writer.flush();
  }

   public void close() throws IOException {
    writer.close();
  }
}