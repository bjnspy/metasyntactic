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

#import "PersistentDictionaryThreadsafeValue.h"

#import "FileUtilities.h"

@interface PersistentDictionaryThreadsafeValue()
@end


@implementation PersistentDictionaryThreadsafeValue

+ (PersistentDictionaryThreadsafeValue*) valueWithGate:(id<NSLocking>) gate
                                             file:(NSString*) file {
  return [[[PersistentDictionaryThreadsafeValue alloc] initWithGate:gate
                                                          file:file] autorelease];
}


- (NSDictionary*) loadFromFile {
  NSDictionary* result = [FileUtilities readObject:file];
  if (result.count == 0) {
    return [NSDictionary dictionary];
  }
  return result;
}


- (void) saveToFile:(NSDictionary*) object {
  [FileUtilities writeObject:object toFile:file];
}

@end
