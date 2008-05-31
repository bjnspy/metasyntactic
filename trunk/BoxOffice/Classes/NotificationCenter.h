//
//  untitled.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/11/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

@interface NotificationCenter : NSObject {
    UIWindow* window;
    NSMutableArray* messages;
    
    UILabel* background;
    UILabel* currentlyDisplayedMessage;
}

@property (retain) UIWindow* window;
@property (retain) NSMutableArray* messages;
@property (retain) UILabel* background;
@property (retain) UILabel* currentlyDisplayedMessage;

+ (NotificationCenter*) centerWithWindow:(UIWindow*) window;

- (void) addToWindow;
- (void) addStatusMessage:(NSString*) message;

@end
