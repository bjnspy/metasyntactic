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

#import "RottenTomatoesDownloader.h"

#import "Application.h"
#import "BoxOfficeModel.h"
#import "ExtraMovieInformation.h"
#import "Utilities.h"

@implementation RottenTomatoesDownloader

@synthesize model;

- (void) dealloc {
    self.model = nil;
    [super dealloc];
}


- (id) initWithModel:(BoxOfficeModel*) model_ {
    if (self = [super init]) {
        self.model = model_;
    }

    return self;
}


+ (RottenTomatoesDownloader*) downloaderWithModel:(BoxOfficeModel*) model {
    return [[[RottenTomatoesDownloader alloc] initWithModel:model] autorelease];
}


- (NSDictionary*) lookupMovieListings:(NSString*) localHash {
    NSString* host = [Application host];

    NSString* serverHash = [Utilities stringWithContentsOfAddress:[NSString stringWithFormat:@"http://%@.appspot.com/LookupMovieListings?q=RottenTomatoes&hash=true", host]];
    if (serverHash == nil) {
        serverHash = @"0";
    }

    if (localHash != nil &&
        [localHash isEqual:serverHash]) {
        return [NSDictionary dictionary];
    }

    NSString* movieListings = [Utilities stringWithContentsOfAddress:[NSString stringWithFormat:@"http://%@.appspot.com/LookupMovieListings?q=RottenTomatoes", host]];

    if (movieListings != nil) {
        NSMutableDictionary* ratings = [NSMutableDictionary dictionary];

        NSArray* rows = [movieListings componentsSeparatedByString:@"\n"];

        // first row are the column headers.  last row is empty.  skip both.
        for (NSInteger i = 1; i < rows.count - 1; i++) {
            NSArray* columns = [[rows objectAtIndex:i] componentsSeparatedByString:@"\t"];

            if (columns.count >= 9) {
                NSString* title = [columns objectAtIndex:1];
                NSString* synopsis = [columns objectAtIndex:8];

                ExtraMovieInformation* extraInfo = [ExtraMovieInformation infoWithTitle:title
                                                                                   link:[columns objectAtIndex:2]
                                                                               synopsis:synopsis
                                                                                  score:[columns objectAtIndex:3]];


                [ratings setObject:extraInfo forKey:[extraInfo canonicalTitle]];
            }
        }

        if (ratings.count > 0) {
            NSMutableDictionary* result = [NSMutableDictionary dictionary];
            [result setObject:ratings forKey:@"Ratings"];
            [result setObject:serverHash forKey:@"Hash"];

            return result;
        }
    }

    return nil;
}


- (NSString*) ratingsFile {
    return [Application ratingsFile:[[self.model ratingsProviders] objectAtIndex:0]];
}


@end
