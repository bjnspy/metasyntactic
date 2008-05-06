//
//  ActivityIndicator.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ActivityIndicator.h"

@implementation ActivityIndicator

@synthesize navigationItem;
@synthesize startButtonItem;

- (void) dealloc
{
    self.navigationItem = nil;
    self.startButtonItem = nil;
    [super dealloc];
}

- (id) initWithNavigationItem:(UINavigationItem*) item
{
    if (self = [super init])
    {
        self.navigationItem = item;
        self.startButtonItem = self.navigationItem.customLeftItem;
        running = NO;
    }
    
    return self;
}

- (void) updateImage:(NSNumber*) number
{
    if (running == NO)
    {
        return;
    }
    
    NSInteger i = [number intValue];
    NSString* imageName = [NSString stringWithFormat:@"Spinner%d.png", i];
    UIBarButtonItem* currentLocationItem =
        [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName]
                                                              style:UIBarButtonItemStylePlain
                                                             target:nil
                                                             action:nil] autorelease];
   // [currentLocationItem 
    
    self.navigationItem.customLeftItem = currentLocationItem;
    
    [self performSelector:@selector(updateImage:) withObject:[NSNumber numberWithInt:((i + 1) % 10)] afterDelay:0.1];
}

- (void) start
{
    running = YES;
    [self updateImage:[NSNumber numberWithInt:1]];
}

- (void) stop:(id) sender
{
    running = NO;
    self.navigationItem.customLeftItem = self.startButtonItem;
}

- (void) stop
{
    [self stop:nil];
}

@end
