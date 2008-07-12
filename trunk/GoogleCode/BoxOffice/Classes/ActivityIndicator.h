//
//  ActivityIndicator.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/5/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

@interface ActivityIndicator : NSObject {
    UINavigationItem* navigationItem;
    
    id originalTarget;
    SEL originalSelector;
    
    BOOL running;
}

@property (retain) UINavigationItem* navigationItem;
@property (retain) id originalTarget;


- (id) initWithNavigationItem:(UINavigationItem*) navigationItem;

- (void) start;
- (void) stop;

@end
