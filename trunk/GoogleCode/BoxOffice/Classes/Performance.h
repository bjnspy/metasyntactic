//
//  Performance.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface Performance : NSObject {
    NSString* identifier;
    NSString* time;
}

@property (copy) NSString* identifier;
@property (copy) NSString* time;

+ (Performance*) performanceWithDictionary:(NSDictionary*) dictionary;
+ (Performance*) performanceWithIdentifier:(NSString*) identifier
                                     time:(NSString*) time;

- (NSDictionary*) dictionary;

@end
