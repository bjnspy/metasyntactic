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

#import "ExtraMovieInformation.h"

#import "Movie.h"

@implementation ExtraMovieInformation

@synthesize canonicalTitle;
@synthesize link;
@synthesize synopsis;
@synthesize score;

- (void) dealloc {
    self.canonicalTitle = nil;
    self.link = nil;
    self.synopsis = nil;
    self.score = nil;

    [super dealloc];
}


- (id) initWithTitle:(NSString*) title_
                link:(NSString*) link_
            synopsis:(NSString*) synopsis_
               score:(NSString*) score_ {
    if (self = [super init]) {
        self.canonicalTitle = [Movie makeCanonical:title_];
        self.link = link_;
        self.synopsis = synopsis_;
        self.score = score_;

        self.synopsis = [synopsis stringByReplacingOccurrencesOfString:@"<i>" withString:@""];
        self.synopsis = [synopsis stringByReplacingOccurrencesOfString:@"</i>" withString:@""];
    }

    return self;
}


+ (ExtraMovieInformation*) infoWithTitle:(NSString*) title
                                    link:(NSString*) link
                                synopsis:(NSString*) synopsis
                                   score:(NSString*) score {
    return [[[ExtraMovieInformation alloc] initWithTitle:title
                                                    link:link
                                                synopsis:synopsis
                                                   score:score] autorelease];
}


+ (ExtraMovieInformation*) infoWithDictionary:(NSDictionary*) dictionary {
    return [ExtraMovieInformation infoWithTitle:[dictionary objectForKey:@"canonicalTitle"]
                                           link:[dictionary objectForKey:@"link"]
                                       synopsis:[dictionary objectForKey:@"synopsis"]
                                          score:[dictionary objectForKey:@"score"]];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:canonicalTitle forKey:@"canonicalTitle"];
    [dictionary setObject:link forKey:@"link"];
    [dictionary setObject:synopsis forKey:@"synopsis"];
    [dictionary setObject:score forKey:@"score"];
    return dictionary;
}


- (NSInteger) scoreValue {
    int value = [self.score intValue];
    if (value >= 0 && value <= 100) {
        return value;
    }

    return -1;
}


@end
