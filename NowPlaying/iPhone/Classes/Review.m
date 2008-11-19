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

#import "Review.h"

@interface Review()
@property NSInteger score;
@property (copy) NSString* link;
@property (copy) NSString* text;
@property (copy) NSString* author;
@property (copy) NSString* source;
@end


@implementation Review

property_definition(score);
property_definition(link);
property_definition(text);
property_definition(author);
property_definition(source);

- (void) dealloc {
    self.score = 0;
    self.link = nil;
    self.text = nil;
    self.author = nil;
    self.source = nil;

    [super dealloc];
}


- (id) initWithText:(NSString*) text_
              score:(NSInteger) score_
               link:(NSString*) link_
             author:(NSString*) author_
             source:(NSString*) source_ {
    if (self = [super init]) {
        self.score = score_;
        self.link = link_ == nil ? @"" : link_;
        self.text = text_ == nil ? @"" : text_;
        self.author = author_ == nil ? @"" : author_;
        self.source = source_ == nil ? @"" : source_;
    }

    return self;
}


+ (Review*) reviewWithText:(NSString*) text
                     score:(NSInteger) score
                      link:(NSString*) link
                    author:(NSString*) author
                    source:(NSString*) source {
    return [[[Review alloc] initWithText:text
                                   score:score
                                    link:link
                                  author:author
                                  source:source] autorelease];
}


+ (Review*) reviewWithDictionary:(NSDictionary*) dictionary {
    return [Review reviewWithText:[dictionary objectForKey:text_key]
                            score:[[dictionary objectForKey:score_key] intValue]
                             link:[dictionary objectForKey:link_key]
                           author:[dictionary objectForKey:author_key]
                           source:[dictionary objectForKey:source_key]];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInt:score]  forKey:score_key];
    [dict setObject:link                            forKey:link_key];
    [dict setObject:text                            forKey:text_key];
    [dict setObject:author                          forKey:author_key];
    [dict setObject:source                          forKey:source_key];
    return dict;
}

@end