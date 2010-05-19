// Copyright 2010 Cyrus Najmabadi
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


+ (NetflixAccount*) createWithDictionaryWorker:(NSDictionary*) dictionary {
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
