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
        
    
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CurrentPosition.png"]
                                                                                  style:UIBarButtonItemStyleDone
                                                                                 target:self
                                                                                 action:@selector(onButtonClicked:)] autorelease];
        
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
    
    self.navigationItem.leftBarButtonItem = self.originalButton;
}

- (void) stop {
    [self stop:nil];
}

- (void) onButtonClicked:(id) sender {
    [self stop];
}

@end
