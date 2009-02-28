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

#import "Person.h"

Person* person(NSString* name, NSString* link) {
    return [Person personWithName:name link:link];
}

@interface Person()
@property (copy) NSString* name;
@property (copy) NSString* link;
@end


@implementation Person

@synthesize name;
@synthesize link;

- (void) dealloc {
    self.name = nil;
    self.link = nil;
    
    [super dealloc];
}


- (id) initWithName:(NSString*) name_
               link:(NSString*) link_ {
    if (self = [super init]) {
        self.name = name_;
        self.link = link_;
    }
    
    return self;
}


+ (Person*) personWithName:(NSString*) name link:(NSString*) link {
    return [[[Person alloc] initWithName:name link:link] autorelease];
}

@end