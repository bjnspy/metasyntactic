// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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
    NSString* serverHash = [Utilities stringWithContentsOfAddress:[NSString stringWithFormat:@"http://%@.appspot.com/LookupMovieListings?q=RottenTomatoes&hash=true", [Application host]]];
    if (serverHash == nil) {
        serverHash = @"0";
    }

    if (localHash != nil &&
        [localHash isEqual:serverHash]) {
        return [NSDictionary dictionary];
    }

    NSString* movieListings = [Utilities stringWithContentsOfAddress:[NSString stringWithFormat:@"http://%@.appspot.com/LookupMovieListings?q=RottenTomatoes", [Application host]]];

    if (movieListings != nil) {
        NSMutableDictionary* ratings = [NSMutableDictionary dictionary];

        NSArray* rows = [movieListings componentsSeparatedByString:@"\n"];

        // first row are the column headers. last row is empty. skip both.
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