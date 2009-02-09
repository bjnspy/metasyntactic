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

#import "Section.h"

@interface Section()
@property (copy) NSString* text;
@end


@implementation Section

@synthesize text;

- (void) dealloc {
    self.text = nil;
    [super dealloc];
}


- (id) initWithText:(NSString*) text_ {
    if (self = [super init]) {
        self.text = text_;
    }
    
    return self;
}


+ (Section*) sectionWithText:(NSString*) text {
    return [[[Section alloc] initWithText:text] autorelease];
}

@end