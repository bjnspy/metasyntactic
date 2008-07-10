//
//  Performance.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Performance.h"


@implementation Performance

@synthesize identifier;
@synthesize time;

- (void) dealloc {
    self.identifier = nil;
    self.time = nil;
    
    [super dealloc];
}

- (id) initWithIdentifier:(NSString*) anIdentifier
                     time:(NSString*) aTime {
    if (self = [super init]) {
        self.identifier = anIdentifier;
        self.time = aTime;
    }
    
    return self;
}

+ (Performance*) performanceWithIdentifier:(NSString*) identifier
                                      time:(NSString*) time {
    return [[[Performance alloc] initWithIdentifier:identifier time:time] autorelease];
}

+ (Performance*) performanceWithDictionary:(NSDictionary*) dictionary {
    return [Performance performanceWithIdentifier:[dictionary valueForKey:@"identifier"]
                                             time:[dictionary valueForKey:@"time"]];
}
    
- (NSDictionary*) dictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setObject:self.identifier forKey:@"identifier"];
    [dictionary setObject:self.time forKey:@"time"];
    
    return dictionary;
}

@end
