//
//  NorthAmericaDataProvider.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataProvider.h"
#import "BoxOfficeModel.h"
#import "AbstractDataProvider.h"

@interface NorthAmericaDataProvider : AbstractDataProvider<DataProvider> {
}

+ (NorthAmericaDataProvider*) providerWithModel:(BoxOfficeModel*) model;

@end
