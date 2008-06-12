package org.metasyntactic.automata.parsers;

import java.util.*;

public class Grammar<V extends Variable> {
    private final Set<Rule<V>> rules;
    private final Rule<V> startRule;
    private final Map<V,Rule<V>> ruleMap = new LinkedHashMap<V, Rule<V>>();

    public Grammar(Set<Rule<V>> rules, Rule<V> startRule) {
        this.rules = new LinkedHashSet<Rule<V>>(rules);
        this.startRule = startRule;

        for (Rule<V> rule : rules) {
            ruleMap.put(rule.getVariable(), rule);
        }
    }

    public Set<Rule<V>> getRules() {
        return Collections.unmodifiableSet(rules);
    }

    public Rule<V> getStartRule() {
        return startRule;
    }

    public Rule<V> getRule(V variable) {
        return ruleMap.get(variable);
    }
}