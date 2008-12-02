//
//  UpdatingListingsViewController.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "UpdatingListingsViewController.h"

@interface UpdatingListingsViewController()
@property (retain) id target;
@property SEL selector;
@end

@implementation UpdatingListingsViewController

@synthesize target;
@synthesize selector;

- (void)dealloc {
    self.target = nil;
    self.selector = nil;
    [super dealloc];
}


- (id) initWithTarget:(id) target_
             selector:(SEL) selector_ {
    if (self = [super init]) {
        self.target = target_;
        self.selector = selector_;
    }
    
    return self;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}


@end
