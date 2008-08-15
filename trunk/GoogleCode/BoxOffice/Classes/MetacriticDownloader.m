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

#import "MetacriticDownloader.h"

#import "Application.h"
#import "BoxOfficeModel.h"
#import "ExtraMovieInformation.h"
#import "Utilities.h"

@implementation MetacriticDownloader

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


+ (MetacriticDownloader*) downloaderWithModel:(BoxOfficeModel*) model {
    return [[[MetacriticDownloader alloc] initWithModel:model] autorelease];
}


- (NSDictionary*) lookupMovieListings:(NSString*) localHash {
    NSString* host = [Application host];

    NSString* serverHash = [Utilities stringWithContentsOfAddress:[NSString stringWithFormat:@"http://%@.appspot.com/LookupMovieListings?q=Metacritic&hash=true", host]];
    if (serverHash == nil) {
        serverHash = @"0";
    }

    if (localHash != nil &&
        [localHash isEqual:serverHash]) {
        return [NSDictionary dictionary];
    }

    NSString* movieListings = [Utilities stringWithContentsOfAddress:[NSString stringWithFormat:@"http://%@.appspot.com/LookupMovieListings?q=Metacritic", host]];

    if (movieListings != nil) {
        NSMutableDictionary* ratings = [NSMutableDictionary dictionary];

        NSArray* rows = [movieListings componentsSeparatedByString:@"\n"];

        for (NSString* row in rows) {
            NSArray* columns = [row componentsSeparatedByString:@"\t"];

            if (columns.count >= 3) {
                NSString* synopsis = @"";
                NSString* score = [columns objectAtIndex:0];
                NSString* link  = [columns objectAtIndex:1];
                NSString* title = [columns objectAtIndex:2];
                if ([score isEqual:@"xx"]) {
                    score = @"-1";
                }

                ExtraMovieInformation* extraInfo = [ExtraMovieInformation infoWithTitle:title
                                                                                   link:link
                                                                               synopsis:synopsis
                                                                                  score:score];


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
    return [Application ratingsFile:[[self.model ratingsProviders] objectAtIndex:1]];
}


@end
