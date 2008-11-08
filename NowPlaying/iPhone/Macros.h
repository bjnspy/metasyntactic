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

#define ArrayLength(x) (sizeof(x)/sizeof(*(x)))

#define ONE_MINUTE (60.0)
#define ONE_HOUR   (60.0 * ONE_MINUTE)
#define ONE_DAY    (24.0 * ONE_HOUR)
#define ONE_WEEK   (7.0 * ONE_DAY)
#define ONE_MONTH  (30.5 * ONE_DAY)
#define ONE_YEAR   (365.0 * ONE_DAY)

#define property_definition(x) static NSString* x ## _key = @#x; @synthesize x