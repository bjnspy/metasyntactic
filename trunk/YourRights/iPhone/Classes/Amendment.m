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

#import "Amendment.h"

#import "Section.h"

@interface Amendment()
@property (copy) NSString* synopsis;
@property NSInteger year;
@property (copy) NSString* link;
@property (retain) NSArray* sections;
@end


@implementation Amendment

@synthesize synopsis;
@synthesize year;
@synthesize link;
@synthesize sections;

- (void) dealloc {
    self.synopsis = nil;
    self.year = 0;
    self.link = nil;
    self.sections = nil;

    [super dealloc];
}


- (id) initWithSynopsis:(NSString*) synopsis_
                   year:(NSInteger) year_
                   link:(NSString*) link_
               sections:(NSArray*) sections_ {
    if (self = [super init]) {
        self.synopsis = synopsis_;
        self.year = year_;
        self.link = link_;
        self.sections = sections_;
    }
    
    return self;
}


+ (Amendment*) amendmentWithSynopsis:(NSString*) synopsis
                                year:(NSInteger) year
                                link:(NSString*) link
                            sections:(NSArray*) sections { 
    return [[[Amendment alloc] initWithSynopsis:synopsis
                                           year:year
                                           link:link
                                       sections:sections] autorelease];
}


+ (Amendment*) amendmentWithSynopsis:(NSString*) synopsis
                                year:(NSInteger) year
                                link:(NSString*) link
                                text:(NSString*) text {
    NSArray* sections = [NSArray arrayWithObject:[Section sectionWithText:text]];
    return [[[Amendment alloc] initWithSynopsis:synopsis
                                           year:year
                                           link:link
                                       sections:sections] autorelease];
}

@end