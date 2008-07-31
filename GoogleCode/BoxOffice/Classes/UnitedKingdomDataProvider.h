//
//  UnitedKingdomDataProvider.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractDataProvider.h"
#import "DataProvider.h"

@interface UnitedKingdomDataProvider : AbstractDataProvider<DataProvider> {

}

+ (UnitedKingdomDataProvider*) providerWithModel:(BoxOfficeModel*) model;

@end
