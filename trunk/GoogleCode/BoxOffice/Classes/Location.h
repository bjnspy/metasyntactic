//
//  Location.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/8/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#define UNKNOWN_DISTANCE FLT_MAX

@interface Location : NSObject {
    double latitude;
    double longitude;
}

@property (readonly) double latitude;
@property (readonly) double longitude;

+ (Location*) locationWithDictionary:(NSDictionary*) dictionary;
+ (Location*) locationWithLatitude:(double) latitude
                         longitude:(double) longitude;

- (NSDictionary*) dictionary;

- (double) distanceTo:(Location*) to;

@end
