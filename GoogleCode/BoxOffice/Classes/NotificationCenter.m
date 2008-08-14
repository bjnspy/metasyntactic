// Copyright (c) 2008, Cyrus Najmabadi
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//   Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
//   Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
//   Neither the name 'Cyrus Najmabadi' nor the names of its contributors may be
//   used to endorse or promote products derived from this software without
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

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
