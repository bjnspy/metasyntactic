//
//  NetflixAccount.m
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 7/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NetflixAccount.h"

@interface NetflixAccount()
@property (copy) NSString* key;
@property (copy) NSString* secret;
@property (copy) NSString* userId;
@end

@implementation NetflixAccount

property_definition(key);
property_definition(secret);
property_definition(userId);

- (void) dealloc {
  self.key = nil;
  self.secret = nil;
  self.userId = nil;
  [super dealloc];
}


- (id) initWithKey:(NSString*) key_ secret:(NSString*) secret_ userId:(NSString*) userId_ {
  if ((self = [super init])) {
    self.key = key_;
    self.secret = secret_;
    self.userId = userId_;
  }
  return self;
}


+ (NetflixAccount*) accountWithKey:(NSString*) key secret:(NSString*) secret userId:(NSString*) userId {
  return [[[NetflixAccount alloc] initWithKey:key secret:secret userId:userId] autorelease];
}


+ (NetflixAccount*) newWithDictionary:(NSDictionary*) dictionary {
  return [self accountWithKey:[dictionary objectForKey:key_key]
                       secret:[dictionary objectForKey:secret_key]
                       userId:[dictionary objectForKey:userId_key]];
}


- (NSDictionary*) dictionary {
  NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
  [dictionary setObject:key forKey:key_key];
  [dictionary setObject:secret forKey:secret_key];
  [dictionary setObject:userId forKey:userId_key];
  return dictionary;
}


- (BOOL) isEqual:(id) object {
  if (object == nil) {
    return NO;
  }
  if (self == object) {
    return YES;
  }
  
  return [userId isEqual:[object userId]];
}

@end
