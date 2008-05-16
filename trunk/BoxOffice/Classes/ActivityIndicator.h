//
//  ActivityIndicator.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/5/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

@interface ActivityIndicator : NSObject {
    UIBarButtonItem* startButtonItem; 
    UINavigationItem* navigationItem;
    BOOL running;
}

@property (retain) UIBarButtonItem* startButtonItem;
@property (retain) UINavigationItem* navigationItem;

- (id) initWithNavigationItem:(UINavigationItem*) navigationItem;
- (void) dealloc;

- (void) start;
- (void) stop;

@end
