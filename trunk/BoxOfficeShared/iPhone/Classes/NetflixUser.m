//
//  NetflixUser.m
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 7/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NetflixUser.h"

@interface NetflixUser()
@property (copy) NSString* firstName;
@property (copy) NSString* lastName;
@property BOOL canInstantWatch;
@property (retain) NSArray* preferredFormats;
@end


@implementation NetflixUser

property_definition(firstName);
property_definition(lastName);
property_definition(canInstantWatch);
property_definition(preferredFormats);

- (void) dealloc {
  self.firstName = nil;
  self.lastName = nil;
  self.canInstantWatch = NO;
  self.preferredFormats = nil;
  [super dealloc];
}


- (id) initWithFirstName:(NSString*) firstName_
                lastName:(NSString*) lastName_
         canInstantWatch:(BOOL) canInstantWatch_
        preferredFormats:(NSArray*) preferredFormats_ {
  if ((self = [super init])) {
    self.firstName = firstName_;
    self.lastName = lastName_;
    self.canInstantWatch = canInstantWatch_;
    self.preferredFormats = preferredFormats_;
  }
  
  return self;
}


+ (NetflixUser*) userWithFirstName:(NSString*) firstName
                          lastName:(NSString*) lastName
                   canInstantWatch:(BOOL) canInstantWatch 
                  preferredFormats:(NSArray*) preferredFormats {
  return [[[NetflixUser alloc] initWithFirstName:firstName
                                        lastName:lastName
                                 canInstantWatch:canInstantWatch
                                preferredFormats:preferredFormats] autorelease];
}


+ (NetflixUser*) newWithDictionary:(NSDictionary*) dictionary {
  return [self userWithFirstName:[dictionary objectForKey:firstName_key]
                        lastName:[dictionary objectForKey:lastName_key]
                 canInstantWatch:[[dictionary objectForKey:canInstantWatch_key] boolValue]
                preferredFormats:[dictionary objectForKey:preferredFormats_key]];
}


- (NSDictionary*) dictionary {
  NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
  [dictionary setObject:firstName forKey:firstName_key];
  [dictionary setObject:lastName forKey:lastName_key];
  [dictionary setObject:[NSNumber numberWithBool:canInstantWatch] forKey:canInstantWatch_key];
  [dictionary setObject:preferredFormats forKey:preferredFormats_key];
  return dictionary;
}

@end
