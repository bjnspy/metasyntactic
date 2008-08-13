// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "Review.h"

@implementation Review

@synthesize score;
@synthesize link;
@synthesize text;
@synthesize author;
@synthesize source;

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
        self.link = link_;
        self.text = text_;
        self.author = author_;
        self.source = source_;

        if (self.link == nil) {
            self.link = @"";
        }

        if (self.author == nil) {
            self.author = @"";
        }

        if (self.source == nil) {
            self.source = @"";
        }
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
    return [Review reviewWithText:[dictionary objectForKey:@"text"]
                            score:[[dictionary objectForKey:@"score"] intValue]
                             link:[dictionary objectForKey:@"link"]
                           author:[dictionary objectForKey:@"author"]
                           source:[dictionary objectForKey:@"source"]];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInt:score] forKey:@"score"];
    [dict setObject:link forKey:@"link"];
    [dict setObject:text forKey:@"text"];
    [dict setObject:author forKey:@"author"];
    [dict setObject:source forKey:@"source"];
    return dict;
}


- (CGFloat) heightWithFont:(UIFont*) font {
    CGFloat width = self.link ? 255 : 285;
    CGSize size = CGSizeMake(width, 1000);
    size = [self.text sizeWithFont:font
                 constrainedToSize:size
                     lineBreakMode:UILineBreakModeWordWrap];

    return size.height + 10;
}


@end
