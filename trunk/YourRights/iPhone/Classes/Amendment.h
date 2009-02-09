//
//  Amendment.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface Amendment : NSObject {
@private
    NSString* synopsis;
    NSInteger year;
    NSString* link;
    NSArray* sections;
}

@property (readonly, copy) NSString* synopsis;
@property (readonly) NSInteger year;
@property (readonly, copy) NSString* link;
@property (readonly, retain) NSArray* sections;

+ (Amendment*) amendmentWithSynopsis:(NSString*) synopsis
                                year:(NSInteger) year
                                link:(NSString*) link
                                text:(NSString*) text;

+ (Amendment*) amendmentWithSynopsis:(NSString*) synopsis
                                year:(NSInteger) year
                                link:(NSString*) link
                                sections:(NSArray*) sections;

@end
