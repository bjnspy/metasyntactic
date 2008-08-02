// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it 
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51 
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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

        [self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CurrentPosition.png"]
                                                                                    style:UIBarButtonItemStyleDone
                                                                                   target:self
                                                                                   action:@selector(onButtonClicked:)] autorelease]
         animated:YES];


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

    [self.navigationItem setLeftBarButtonItem:self.originalButton animated:YES];
}

- (void) stop {
    [self stop:nil];
}

- (void) onButtonClicked:(id) sender {
    [self stop];
}

@end
