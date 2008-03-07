//
//  iAmazonAppDelegate.h
//  iAmazon
//
//  Created by Cyrus Najmabadi on 3/6/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyView;

@interface iAmazonAppDelegate : NSObject {
    UIWindow *window;
    MyView *contentView;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) MyView *contentView;

@end
