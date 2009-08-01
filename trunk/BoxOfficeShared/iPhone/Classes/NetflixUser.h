//
//  NetflixUser.h
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 7/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface NetflixUser : AbstractData {
@private
  NSString* firstName;
  NSString* lastName;
  BOOL canInstantWatch;
  NSArray* preferredFormats;
}

@property (readonly, copy) NSString* firstName;
@property (readonly, copy) NSString* lastName;
@property (readonly) BOOL canInstantWatch;
@property (readonly, retain) NSArray* preferredFormats;

+ (NetflixUser*) userWithFirstName:(NSString*) firstName
                          lastName:(NSString*) lastName
                   canInstantWatch:(BOOL) canInstantWatch
                  preferredFormats:(NSArray*) preferredFormats;


- (NSDictionary*) dictionary;

@end
