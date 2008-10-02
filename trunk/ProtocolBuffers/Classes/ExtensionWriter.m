// Protocol Buffers - Google's data interchange format
// Copyright 2008 Google Inc.
// http://code.google.com/p/protobuf/
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "ExtensionWriter.h"

#import "FieldSet.h"

@implementation PBExtensionWriter

@synthesize extensions;
@synthesize enumerator;
@synthesize nextKey;
@synthesize nextValue;

- (void) dealloc {
    self.extensions = nil;
    self.enumerator = nil;
    self.nextKey = nil;
    self.nextValue = nil;

    [super dealloc];
}


- (void) moveNext {
    self.nextKey = enumerator.nextObject;
    if (nextKey != nil) {
        self.nextValue = [extensions.fields objectForKey:nextKey];
    }
}


- (id) initWithExtensions:(PBFieldSet*) extensions_ {
    if (self = [super init]) {
        self.extensions = extensions_;
        self.enumerator = extensions.fields.keyEnumerator;
        
        [self moveNext];
    }
    
    return self;
}


+ (PBExtensionWriter*) writerWithExtensions:(PBFieldSet*) extensions {
    return [[[PBExtensionWriter alloc] initWithExtensions:extensions] autorelease];
}


/**
 * Used by subclasses to serialize extensions.  Extension ranges may be
 * interleaved with field numbers, but we must write them in canonical
 * (sorted by field number) order.  PBExtensionWriter helps us write
 * individual ranges of extensions at once.
 */
- (void) writeUntil:(int32_t) end output:(PBCodedOutputStream*) output {
    while (nextKey != nil && [nextValue number] < end) {
        [extensions writeField:nextKey value:nextValue output:output];
        [self moveNext];
    }
}


@end
