//
//  EditorViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "EditorViewController.h"


@implementation EditorViewController

@synthesize navigationController;
@synthesize object;

- (void)dealloc
{
    self.navigationController = nil;
    self.object = nil;
	[super dealloc];
}

- (id) initWithController:(UINavigationController*) controller
               withObject:(id) object_
             withSelector:(SEL) selector_
{
    if (self = [super init])
    {
        self.navigationController = controller;
        self.object = object_;
        selector = selector_;
    }
    
    return self;
}

- (void)loadView
{    
    [super loadView];
    
    UIBarButtonItem *saveItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                                                               target:self
                                                                               action:@selector(save:)] autorelease];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    UIBarButtonItem *cancelItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                 target:self
                                                                                 action:@selector(cancel:)] autorelease];
    self.navigationItem.leftBarButtonItem = cancelItem;   
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void) cancel:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) save:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
