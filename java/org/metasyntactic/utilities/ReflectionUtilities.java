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

package org.metasyntactic.utilities;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class ReflectionUtilities {
  private ReflectionUtilities() {

  }

/*
  public static boolean hasField(Class clazz, String name) {
    for (Field field : clazz.getFields()) {
      if (name.equals(field.getName())) {
        return true;
      }
    }

    return false;
  }

  public static boolean hasMethod(Class clazz, String name) {
    for (Method method : clazz.getMethods()) {
      if (name.equals(method.getName())) {
        return true;
      }
    }

    return false;
  }
  */

  public static String getSimpleName(Class c) {
    String value = c.getName();
    int dot = value.lastIndexOf('.');
    if (dot > 0) {
      return value.substring(dot + 1);
    }

    return value;
  }
}
