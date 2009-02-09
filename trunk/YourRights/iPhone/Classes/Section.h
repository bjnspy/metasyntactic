//
//  Section.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface Section : NSObject {
@private
    NSString* text;
}

@property (readonly, copy) NSString* text;

+ (Section*) sectionWithText:(NSString*) text;

@end
