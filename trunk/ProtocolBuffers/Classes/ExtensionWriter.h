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

#if 0
/**
 * Used by subclasses to serialize extensions.  Extension ranges may be
 * interleaved with field numbers, but we must write them in canonical
 * (sorted by field number) order.  ExtensionWriter helps us write
 * individual ranges of extensions at once.
 */
@interface PBExtensionWriter : NSObject {
  @private
    PBFieldSet* extensions;
    NSEnumerator* enumerator;
    PBFieldDescriptor* nextKey;
    id nextValue;
}

+ (PBExtensionWriter*) writerWithExtensions:(PBFieldSet*) extensions;

- (void) writeUntil:(int32_t) end output:(PBCodedOutputStream*) output;

@end
#endif