//
//  ActivityIndicator.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/5/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "ActivityIndicator.h"

@implementation ActivityIndicator

@synthesize navigationItem;
@synthesize originalTarget;

- (void) dealloc {
    self.navigationItem = nil;
    self.originalTarget = nil;
    
    [super dealloc];
}

- (id) initWithNavigationItem:(UINavigationItem*) item {
    if (self = [super init]) {
        self.navigationItem = item;
        UIBarButtonItem* button = self.navigationItem.leftBarButtonItem;
        
        self.originalTarget = button.target;
        originalSelector = button.action;
        
        button.target = self;
        button.action = @selector(onButtonClicked:);
        
        running = NO;
    }
    
    return self;
}

- (void) updateImage:(NSNumber*) number {
    if (running == NO) {
        return;
    }

    NSInteger i = [number intValue];
    self.navigationItem.leftBarButtonItem.image = 
        [UIImage imageNamed:[NSString stringWithFormat:@"Spinner%d.png", i]];
    
    [self performSelector:@selector(updateImage:) withObject:[NSNumber numberWithInt:((i + 1) % 10)] afterDelay:0.1];
}

- (void) start {
    running = YES;
    [self updateImage:[NSNumber numberWithInt:1]];
}

- (void) stop:(id) sender {
    running = NO;
    
    UIBarButtonItem* button = self.navigationItem.leftBarButtonItem;

    button.image = [UIImage imageNamed:@"CurrentPosition.png"];
    button.target = originalTarget;
    button.action = originalSelector;
}

- (void) stop {
    [self stop:nil];
}

- (void) onButtonClicked:(id) sender {
    [self stop];
}

@end
