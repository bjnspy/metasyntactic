//
//  Donation.h
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 12/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface Donation : NSObject<StoreItem> {
@private
  NSString* itunesIdentifier;
}

+ (Donation*) donationWithItunesIdentifier:(NSString*) itunesIdentifier;

@end
