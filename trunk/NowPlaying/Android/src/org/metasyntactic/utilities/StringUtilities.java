//Copyright 2008 Cyrus Najmabadi
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

package org.metasyntactic.utilities;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class StringUtilities {
  private StringUtilities() {

  }


  public static boolean isNullOrEmpty(String address) {
    return address == null || address.length() == 0;
  }


  public static String nonNullString(String name) {
    if (name == null) {
      return "";
    }

    return name;
  }


  public static String urlEncode(String string) {
    try {
      return URLEncoder.encode(string.replace('Õ', '\''), "ISO-8859-1");
    } catch (UnsupportedEncodingException e) {
      throw new RuntimeException(e);
    }
  }
}