package com.google.common.base;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: Jun 18, 2008
 * Time: 3:05:19 PM
 * To change this template use File | Settings | File Templates.
 */
public interface Function<A,R> {
    R apply(A argument);
}

