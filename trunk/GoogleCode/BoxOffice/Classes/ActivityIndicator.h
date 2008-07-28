//
//  ActivityIndicator.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/5/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

@interface ActivityIndicator : NSObject {
    UINavigationItem* navigationItem;
    UIBarButtonItem* originalButton;

    BOOL running;
}

@property (retain) UINavigationItem* navigationItem;
@property (retain) UIBarButtonItem* originalButton;

- (id) initWithNavigationItem:(UINavigationItem*) navigationItem;

- (void) start;
- (void) stop;

@end
