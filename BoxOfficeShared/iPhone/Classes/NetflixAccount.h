//
//  NetflixAccount.h
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 7/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetflixAccount : AbstractData {
@private
  NSString* key;
  NSString* secret;
  NSString* userId;
}

@property (readonly, copy) NSString* key;
@property (readonly, copy) NSString* secret;
@property (readonly, copy) NSString* userId;

+ (NetflixAccount*) accountWithKey:(NSString*) key secret:(NSString*) secret userId:(NSString*) userId;

@end
