# -*- mode: python; -*-

# Description:
#   String manipulation utilities

java_library(name = "automata",
             srcs = glob([
                        "*.java",
                        "compiler/*.java",
                        "compiler/framework/*.java",
                        "compiler/framework/parsers/*.java",
                        "compiler/framework/parsers/packrat/*.java",
                        "compiler/framework/parsers/packrat/expressions/*.java",
                        "compiler/util/*.java",
                        ]),
             deps = [
                     "//java/com/google/common/base",
                     "//java/com/google/common/collect"
                    ])
