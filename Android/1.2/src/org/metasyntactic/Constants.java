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
package org.metasyntactic;

public interface Constants {
  long ONE_SECOND = 1000;
  long ONE_MINUTE = 60 * ONE_SECOND;
  long ONE_HOUR = 60 * ONE_MINUTE;
  long ONE_DAY = 24 * ONE_HOUR;
  long ONE_WEEK = 7 * ONE_DAY;
  long FOUR_WEEKS = 4 * ONE_WEEK;
  long CACHE_LIMIT = 30 * ONE_DAY;
}
