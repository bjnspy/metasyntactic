package com.google.automata.compiler.framework.parsers;

import com.google.automata.compiler.util.Optional;

import java.util.List;

public interface Scanner<T extends Token> {
    List<SourceToken<T>> scan();
}
