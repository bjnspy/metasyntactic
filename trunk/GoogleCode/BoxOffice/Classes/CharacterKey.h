//
//  CharacterKey.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Key.h"

@interface CharacterKey : Key {

}

+ (CharacterKey*) keyWithIdentifier:(NSString*) identifier
                               name:(NSString*) name;

@end
