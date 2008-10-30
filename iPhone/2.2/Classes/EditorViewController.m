// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "EditorViewController.h"

@implementation EditorViewController

@synthesize navigationController;
@synthesize object;

- (void) dealloc {
    self.navigationController = nil;
    self.object = nil;

    [super dealloc];
}


- (id) initWithController:(AbstractNavigationController*) controller
               withObject:(id) object_
             withSelector:(SEL) selector_ {
    if (self = [super init]) {
        self.navigationController = controller;
        self.object = object_;
        selector = selector_;
    }

    return self;
}


- (void) loadView {
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


- (void) cancel:(id) sender {
    [navigationController popViewControllerAnimated:YES];
}


- (void) save:(id) sender {
    [navigationController popViewControllerAnimated:YES];
}


@end