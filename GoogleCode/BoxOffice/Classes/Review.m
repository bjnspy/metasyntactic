// Copyright (c) 2008, Cyrus Najmabadi
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//   Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
//   Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
//   Neither the name 'Cyrus Najmabadi' nor the names of its contributors may be
//   used to endorse or promote products derived from this software without
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

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
