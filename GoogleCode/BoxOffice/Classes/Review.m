//
//  Review.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Review.h"


@implementation Review

@synthesize score;
@synthesize link;
@synthesize text;
@synthesize author;
@synthesize source;

- (void) dealloc {
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
