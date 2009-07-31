//
//  NetflixUser.h
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 7/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface NetflixUser : NSObject {
@private
  NSString* firstName;
  NSString* lastName;
  BOOL canInstantWatch;
}

@property (readonly, copy) NSString* firstName;
@property (readonly, copy) NSString* lastName;
@property (readonly) BOOL canInstantWatch;

+ (NetflixUser*) userWithFirstName:(NSString*) firstName lastName:(NSString*) lastName canInstantWatch:(BOOL) canInstantWatch;

@end
