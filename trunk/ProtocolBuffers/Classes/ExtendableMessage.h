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

#import "GeneratedMessage.h"

@interface PBExtendableMessage : PBGeneratedMessage {
@private
    PBFieldSet* extensions;
}

@property (readonly, retain) PBFieldSet* extensions;

- (void) verifyExtensionContainingType:(PBGeneratedExtension*) extension;

- (BOOL) hasExtension:(PBGeneratedExtension*) extension;
- (int32_t) getExtensionCount:(PBGeneratedExtension*) extension;
- (id) getExtension:(PBGeneratedExtension*) extension;
- (id) getExtension:(PBGeneratedExtension*) extension index:(int32_t) index;

//@protected
- (BOOL) extensionsAreInitialized;
- (int32_t) extensionsSerializedSize;

//@internal
- (void) verifyContainingType:(PBFieldDescriptor*) field;

@end