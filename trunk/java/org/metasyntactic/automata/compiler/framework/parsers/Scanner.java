package org.metasyntactic.automata.compiler.framework.parsers;

import org.metasyntactic.automata.compiler.util.Optional;

import java.util.List;

public interface Scanner<T extends Token> {
    List<SourceToken<T>> scan();
}
