//
//  untitled.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NotificationCenter.h"


@implementation NotificationCenter

@synthesize window;
@synthesize messages;
@synthesize currentlyDisplayedMessage;
@synthesize background;

- (void)dealloc {
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
	[self.messages addObject:message];
	
	if ([self.messages count] == 1) {
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
		self.currentlyDisplayedMessage.frame = emptyFrame;
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
	
	[self performSelector:@selector(update:) withObject:nil afterDelay:2];
}

- (void) update:(id) object {
	if ([self.messages count] == 0) {
		[self clearStatus];
	} else {
		[self displayNextMessage];
	}
}

- (void) removeViewFromSuperview:(UIView*) view {
	[view removeFromSuperview];
}

@end
