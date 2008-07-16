//
//  Review.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Review : NSObject {
    BOOL positive;
    NSString* link;
    NSString* text;
    NSString* author;
    NSString* source;
}

@property BOOL positive;
@property (copy) NSString* link;
@property (copy) NSString* text;
@property (copy) NSString* author;
@property (copy) NSString* source;

+ (Review*) reviewWithText:(NSString*) text
                positive:(BOOL) positive
                    link:(NSString*) link
                  author:(NSString*) author
                  source:(NSString*) source;

+ (Review*) reviewWithDictionary:(NSDictionary*) dictionary;

- (NSDictionary*) dictionary;

- (CGFloat) heightWithFont:(UIFont*) font;

@end
