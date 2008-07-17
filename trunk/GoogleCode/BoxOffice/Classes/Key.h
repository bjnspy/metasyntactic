//
//  Key.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Key : NSObject {
    NSString* identifier;
    NSString* name;
}

@property (copy) NSString* identifier;
@property (copy) NSString* name;

- (id) initWithIdentifier:(NSString*) identifier
                     name:(NSString*) name;

- (NSDictionary*) dictionary;

@end
