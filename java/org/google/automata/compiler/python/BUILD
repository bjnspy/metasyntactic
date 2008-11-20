# -*- mode: python; -*-

# Description:
#   String manipulation utilities

java_library(name = "python",
             srcs = glob([
                        "*.java",
                        "parser/*.java",
                        "scanner/*.java",
                        "scanner/keywords/*.java",
                        "scanner/literals/*.java",
                        "scanner/operators/*.java",
                        "scanner/delimiters/*.java",
                        ]),
             deps = [
                     "//experimental/users/cyrusn/java/com/google/automata:automata",
                     "//java/com/google/common/base",
                    ])
