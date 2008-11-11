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

#import "ActivityIndicator.h"

@interface ActivityIndicator()
@property (retain) UINavigationItem* navigationItem;
//@property (retain) UIBarButtonItem* originalButton;
@property (retain) UIBarButtonItem* buttonItem;
@end


@implementation ActivityIndicator

@synthesize navigationItem;
@synthesize buttonItem;

- (void) dealloc {
    self.navigationItem = nil;
    self.buttonItem = nil;
    
    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.buttonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CurrentPosition.png"]
                                                            style:UIBarButtonItemStyleDone
                                                           target:self
                                                           action:@selector(onButtonTapped:)] autorelease];
    }
    
    return self;
}


- (void) updateImage:(NSNumber*) number {
    if (running == NO) {
        return;
    }
    
    NSInteger i = number.intValue;
    buttonItem.image =
        [UIImage imageNamed:[NSString stringWithFormat:@"Spinner%d.png", i]];
    
    [self performSelector:@selector(updateImage:)
               withObject:[NSNumber numberWithInt:((i + 1) % 10)]
               afterDelay:0.1];
}


- (void) start {
    running = YES;
    [self updateImage:[NSNumber numberWithInt:1]];
}


- (void) stop {
    running = NO;
    buttonItem.image = [UIImage imageNamed:@"CurrentPosition.png"];
    [navigationItem setLeftBarButtonItem:buttonItem animated:YES];
}


- (void) onButtonTapped:(id) sender {
    if (running) {
        [self stop];
    } else {
        [self start];
    }
}


- (void) setNavigationItem:(UINavigationItem*) navigationItem_ {
    self.navigationItem = navigationItem_;
    navigationItem.leftBarButtonItem = buttonItem;
}

/*
@synthesize navigationItem;
@synthesize originalButton;

- (void) dealloc {
    self.navigationItem = nil;
    self.originalButton = nil;

    [super dealloc];
}


- (id) initWithNavigationItem:(UINavigationItem*) item {
    if (self = [super init]) {
        self.navigationItem = item;
        self.originalButton = self.navigationItem.leftBarButtonItem;

        [navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CurrentPosition.png"]
                                                                               style:UIBarButtonItemStyleDone
                                                                              target:self
                                                                              action:@selector(onButtonTapped:)] autorelease]
                                    animated:YES];


        running = NO;
    }

    return self;
}


- (void) updateImage:(NSNumber*) number {
    if (running == NO) {
        return;
    }

    NSInteger i = number.intValue;
    self.navigationItem.leftBarButtonItem.image =
    [UIImage imageNamed:[NSString stringWithFormat:@"Spinner%d.png", i]];

    [self performSelector:@selector(updateImage:)
               withObject:[NSNumber numberWithInt:((i + 1) % 10)]
               afterDelay:0.1];
}


- (void) start {
    running = YES;
    [self updateImage:[NSNumber numberWithInt:1]];
}


- (void) stop:(id) sender {
    running = NO;

    [navigationItem setLeftBarButtonItem:originalButton animated:YES];
}


- (void) stop {
    [self stop:nil];
}


- (void) onButtonTapped:(id) sender {
    [self stop];
}
*/

@end