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
package com.google;

import java.util.Iterator;
import java.util.Enumeration;

public class Utilities {
    private Utilities() {
    }

    @SuppressWarnings("unchecked")
    public static <T> Iterable<T> cast(final Iterable iterable, final Class<T> clazz) {
        return new Iterable<T>() {
            public Iterator<T> iterator() {
                return cast(iterable.iterator(), clazz);
            }
        };
    }

    public static <T> Iterator<T> cast(final Iterator iterator, final Class<T> clazz) {
        return new Iterator<T>() {
            public boolean hasNext() {
                return iterator.hasNext();
            }

            @SuppressWarnings("unchecked")
            public T next() {
                final Object next = iterator.next();
                if (next != null && !clazz.isInstance(next)) {
                    throw new ClassCastException("Got instance of: " + next.getClass().getName() + ", but expected: " + clazz.getName());
                }
                return (T) next;
            }

            public void remove() {
                iterator.remove();
            }
        };
    }

    public static <T> Iterable<T> iterable(final Iterator<T> iterator) {
        return new Iterable<T>() {
            public Iterator<T> iterator() {
                return iterator;
            }
        };
    }

    public static Iterable iterable(final Enumeration enumeration) {
        return new Iterable() {
            public Iterator iterator() {
                return Utilities.iterator(enumeration);
            }
        };
    }

    public static Iterator iterator(final Enumeration enumeration) {
        return new Iterator() {
            public boolean hasNext() {
                return enumeration.hasMoreElements();
            }

            public Object next() {
                return enumeration.nextElement();
            }

            public void remove() {
                throw new UnsupportedOperationException();
            }
        };
    }
}
