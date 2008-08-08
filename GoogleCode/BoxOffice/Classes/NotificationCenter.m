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

#import "NotificationCenter.h"

@implementation NotificationCenter

@synthesize window;
@synthesize messages;
@synthesize currentlyDisplayedMessage;
@synthesize background;

- (void) dealloc {
    self.window = nil;
    self.messages = nil;
    self.currentlyDisplayedMessage = nil;
    self.background = nil;
    [super dealloc];
}

static CGPoint offScreenLeftPoint = { -160, 423 };

static CGRect offScreenRightFrame = { 480, 423 };
static CGRect emptyFrame = { { 160, 423 }, { 0, 0 } };
static CGRect frame = { { 0, 416 }, { 320, 15 } };

- (id) initWithWindow:(UIWindow*) window_ {
    if (self = [super init]) {
        self.window = window_;
        self.messages = [NSMutableArray array];

        self.background = [[[UILabel alloc] initWithFrame:emptyFrame] autorelease];
        self.background.opaque = NO;
        self.background.alpha = 0.5;
        self.background.backgroundColor = [UIColor lightGrayColor];
    }

    return self;
}

+ (NotificationCenter*) centerWithWindow:(UIWindow*) window {
    return [[[NotificationCenter alloc] initWithWindow:window] autorelease];
}

- (void) addToWindow {
    [self.window addSubview:self.background];
}

- (void) addStatusMessage:(NSString*) message {
    return;

    [self.messages addObject:message];

    if (self.messages.count == 1) {
        self.background.frame = emptyFrame;

        [UIView beginAnimations:nil context:NULL];
        {
            self.background.frame = frame;
        }
        [UIView commitAnimations];

        [self performSelector:@selector(update:) withObject:nil afterDelay:0.1];
    }
}

- (void) clearStatus {
    [UIView beginAnimations:nil context:NULL];
    {
        self.background.frame = emptyFrame;
        self.currentlyDisplayedMessage.center = offScreenLeftPoint;
    }
    [UIView commitAnimations];
}

- (void) displayNextMessage {
    UILabel* label = [[[UILabel alloc] initWithFrame:offScreenRightFrame] autorelease];

    label.text = [self.messages objectAtIndex:0];
    [self.messages removeObjectAtIndex:0];

    label.font = [UIFont systemFontOfSize:11];
    label.textColor = [UIColor blackColor];
    label.textAlignment = UITextAlignmentCenter;
    label.opaque = NO;
    label.backgroundColor = [UIColor clearColor];

    [UIView beginAnimations:nil context:NULL];
    {
        self.currentlyDisplayedMessage.center = offScreenLeftPoint;
        [self performSelector:@selector(removeViewFromSuperview:)
                   withObject:self.currentlyDisplayedMessage
                   afterDelay:1];

        self.currentlyDisplayedMessage = label;
        self.currentlyDisplayedMessage.frame = frame;

        [self.window addSubview:self.currentlyDisplayedMessage];
    }
    [UIView commitAnimations];

    [self performSelector:@selector(update:) withObject:nil afterDelay:1];
}

- (void) update:(id) object {
    if (self.messages.count == 0) {
        [self clearStatus];
    } else {
        [self displayNextMessage];
    }
}

- (void) removeViewFromSuperview:(UIView*) view {
    [view removeFromSuperview];
}

@end
