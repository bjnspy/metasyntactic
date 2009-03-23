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

#import "Status.h"

@interface Status()
@property (retain) Queue* queue_;
@property (retain) Movie* movie_;
@property (copy) NSString* description_;
@property BOOL saved_;
@property NSInteger position_;
@end

@implementation Status

@synthesize queue_;
@synthesize movie_;
@synthesize description_;
@synthesize saved_;
@synthesize position_;

property_wrapper(Queue*, queue, Queue);
property_wrapper(Movie*, movie, Movie);
property_wrapper(NSString*, description, Description);
property_wrapper(BOOL, saved, Saved);
property_wrapper(NSInteger, position, Position);

- (void) dealloc {
    self.queue = nil;
    self.movie = nil;
    self.description = nil;
    self.saved = NO;
    self.position = 0;

    [super dealloc];
}


- (id) initWithWithQueue:(Queue*) queue__
                   movie:(Movie*) movie__
             description:(NSString*) description__
                   saved:(BOOL) saved__
                position:(NSInteger) position__ {
    if (self = [super init]) {
        self.queue = queue__;
        self.movie = movie__;
        self.description = description__;
        self.saved = saved__;
        self.position = position__;
    }

    return self;
}


+ (Status*) statusWithQueue:(Queue*) queue
                      movie:(Movie*) movie
                description:(NSString*) description
                      saved:(BOOL) saved
                   position:(NSInteger) position {
    return [[[Status alloc] initWithWithQueue:queue
                                        movie:movie
                                  description:description
                                        saved:saved
                                     position:position] autorelease];
}

@end