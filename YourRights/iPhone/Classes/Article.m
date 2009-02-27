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

#import "Article.h"

@interface Article()
@property (copy) NSString* title;
@property (copy) NSString* link;
@property (retain) NSArray* sections;
@end


@implementation Article

@synthesize title;
@synthesize link;
@synthesize sections;

- (void) dealloc {
    self.title = nil;
    self.link = nil;
    self.sections = nil;
    
    [super dealloc];
}


- (id) initWithTitle:(NSString*) title_ 
                link:(NSString*) link_
            sections:(NSArray*) sections_ {
    if (self = [super init]) {
        self.title = title_;
        self.link = link_;
        self.sections = sections_;
    }
    
    return self;
}


+ (Article*) articleWithTitle:(NSString*) title
                         link:(NSString*) link
                     sections:(NSArray*) sections {
    return [[[Article alloc] initWithTitle:title
                                      link:link
                                  sections:sections] autorelease];
}


+ (Article*) articleWithTitle:(NSString*) title
                         link:(NSString*) link
                      section:(Section*) section {
    return [Article articleWithTitle:title link:link sections:[NSArray arrayWithObject:section]];
}


+ (Article*) articleWithTitle:(NSString*) title
                      section:(Section*) section {
    return [Article articleWithTitle:title link:@"" section:section];
}

@end