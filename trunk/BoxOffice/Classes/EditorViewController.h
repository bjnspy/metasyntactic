//
//  EditorViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/6/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

@interface EditorViewController : UIViewController {
    UINavigationController* navigationController;
    id object;
    SEL selector;
}

@property (assign) UINavigationController* navigationController;
@property (retain) id object;

- (void) dealloc;
- (id) initWithController:(UINavigationController*) navigationController
               withObject:(id) object
             withSelector:(SEL) selector;

- (void) cancel:(id) sender;
- (void) save:(id) sender;

@end
