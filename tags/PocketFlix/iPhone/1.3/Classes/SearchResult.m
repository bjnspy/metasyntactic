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

#import "SearchResult.h"

#import "Utilities.h"


@interface SearchResult()
@property NSInteger requestId;
@property (copy) NSString* value;
@property (retain) NSArray* movies;
@property (retain) NSArray* people;
@end


@implementation SearchResult

@synthesize requestId;
@synthesize value;
@synthesize movies;
@synthesize people;

- (void) dealloc {
    self.requestId = 0;
    self.value = nil;
    self.movies = nil;
    self.people = nil;

    [super dealloc];
}


- (id) initWithId:(NSInteger) requestId_
            value:(NSString*) value_
           movies:(NSArray*) movies_
           people:(NSArray*) people_ {
    if (self = [super init]) {
        self.requestId = requestId_;
        self.value = value_;
        self.movies = [Utilities nonNilArray:movies_];
        self.people = [Utilities nonNilArray:people_];
    }

    return self;
}


+ (SearchResult*) resultWithId:(NSInteger) requestId
                         value:(NSString*) value
                        movies:(NSArray*) movies {
    return [SearchResult resultWithId:requestId value:value movies:movies people:nil];
}


+ (SearchResult*) resultWithId:(NSInteger) requestId
                         value:(NSString*) value
                        movies:(NSArray*) movies
                        people:(NSArray*) people {
    return [[[SearchResult alloc] initWithId:requestId
                                       value:value
                                      movies:movies
                                      people:people] autorelease];
}

@end