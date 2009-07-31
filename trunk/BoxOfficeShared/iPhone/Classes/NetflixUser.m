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
@end


@implementation NetflixUser

property_definition(firstName);
property_definition(lastName);
property_definition(canInstantWatch);

- (void) dealloc {
  self.firstName = nil;
  self.lastName = nil;
  self.canInstantWatch = NO;
  [super dealloc];
}


- (id) initWithFirstName:(NSString*) firstName_
                lastName:(NSString*) lastName_
         canInstantWatch:(BOOL) canInstantWatch_ {
  if ((self = [super init])) {
    self.firstName = firstName_;
    self.lastName = lastName_;
    self.canInstantWatch = canInstantWatch_;
  }
  
  return self;
}


+ (NetflixUser*) userWithFirstName:(NSString*) firstName
                          lastName:(NSString*) lastName
                   canInstantWatch:(BOOL) canInstantWatch {
  return [[[NetflixUser alloc] initWithFirstName:firstName lastName:lastName canInstantWatch:canInstantWatch] autorelease];
}


+ (NetflixUser*) newWithDictionary:(NSDictionary*) dictionary {
  return [self userWithFirstName:[dictionary objectForKey:firstName_key]
                        lastName:[dictionary objectForKey:lastName_key]
                 canInstantWatch:[[dictionary objectForKey:canInstantWatch_key] boolValue]];
}


- (NSDictionary*) dictionary {
  NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
  [dictionary setObject:firstName forKey:firstName_key];
  [dictionary setObject:lastName forKey:lastName_key];
  [dictionary setObject:[NSNumber numberWithBool:canInstantWatch] forKey:canInstantWatch_key];
  return dictionary;
}

@end
