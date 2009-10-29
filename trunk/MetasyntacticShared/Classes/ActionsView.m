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

#import "ActionsView.h"

#import "MetasyntacticSharedApplication.h"
#import "MetasyntacticStockImages.h"

@interface ActionsView()
@property (assign) id target;
@property (retain) NSArray* selectors;
@property (retain) NSArray* titles;
@property (retain) NSArray* buttons;
@property (retain) NSArray* arguments;
@property (retain) UIImageView* backgroundImageView;
@property CGFloat height;
@end


@implementation ActionsView

@synthesize target;
@synthesize selectors;
@synthesize titles;
@synthesize buttons;
@synthesize arguments;
@synthesize height;
@synthesize backgroundImageView;

- (void) dealloc {
  self.target = nil;
  self.selectors = nil;
  self.titles = nil;
  self.buttons = nil;
  self.arguments = nil;
  self.height = 0;
  self.backgroundImageView = nil;

  [super dealloc];
}


- (id) initWithTarget:(id) target_
            selectors:(NSArray*) selectors_
               titles:(NSArray*) titles_
            arguments:(NSArray*) arguments_ {
  if ((self = [super initWithFrame:CGRectZero])) {
    self.target = target_;
    self.selectors = selectors_;
    self.titles = titles_;
    self.arguments = arguments_;
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];

    UIImage* backgroundImage = MetasyntacticStockImage(@"ActionsViewBackground.png");
    if (backgroundImage != nil) {
      self.backgroundImageView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
      [self addSubview:backgroundImageView];
    }
    
    NSMutableArray* array = [NSMutableArray array];
    for (NSString* title in titles) {
      UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
      [button setTitle:title forState:UIControlStateNormal];
      [button sizeToFit];

      [button addTarget:self action:@selector(onButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

      [array addObject:button];
      [self addSubview:button];
    }

    self.buttons = array;

    if (buttons.count == 0) {
      self.height = 0;
    } else {
      int lastRow = (buttons.count - 1) / 2;

      UIButton* button = [buttons lastObject];
      CGRect frame = button.frame;
      self.height = (8 + frame.size.height) * (lastRow + 1);
    }
  }

  return self;
}


+ (ActionsView*) viewWithTarget:(id) target
                      selectors:(NSArray*) selectors
                         titles:(NSArray*) titles
                      arguments:(NSArray*) arguments {
  return [[[ActionsView alloc] initWithTarget:(id) target
                                    selectors:selectors
                                       titles:titles
                                    arguments:arguments] autorelease];
}


+ (ActionsView*) viewWithTarget:(id) target
                      selectors:(NSArray*) selectors
                         titles:(NSArray*) titles {
  NSMutableArray* arguments = [NSMutableArray array];

  for (NSInteger i = 0; i < selectors.count; i++) {
    [arguments addObject:[NSNull null]];
  }

  return [self viewWithTarget:target
                    selectors:selectors
                       titles:titles
                    arguments:arguments];
}


- (void) onButtonTapped:(UIButton*) button {
  NSInteger index = [buttons indexOfObject:button];

  SEL selector = [[selectors objectAtIndex:index] pointerValue];
  if ([target respondsToSelector:selector]) {
    id argument = [arguments objectAtIndex:index];

    if (argument == [NSNull null]) {
      [target performSelector:selector];
    } else {
      [target performSelector:selector withObject:argument];
    }
  }
}


- (CGSize) sizeThatFits:(CGSize) size {
  if (buttons.count == 0) {
    return CGSizeZero;
  }

  double width;
  if ([MetasyntacticSharedApplication screenRotationEnabled] &&
      UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
    width = [UIScreen mainScreen].bounds.size.height;
  } else {
    width = [UIScreen mainScreen].bounds.size.width;
  }

  return CGSizeMake(width, height);
}


- (void) layoutSubviews {
  [super layoutSubviews];

  backgroundImageView.frame = CGRectMake(10, 4, self.frame.size.width - 20, self.frame.size.height + 1);
  
  BOOL oddNumberOfButtons = ((buttons.count % 2) == 1);

  for (int i = 0; i < buttons.count; i++) {
    UIButton* button = [buttons objectAtIndex:i];

    NSInteger column;
    NSInteger row;
    if (oddNumberOfButtons && i != 0) {
      column = (i + 1) % 2;
      row = (i + 1) / 2;
    } else {
      column = i % 2;
      row = i / 2;
    }

    CGRect frame = button.frame;
    frame.origin.x = (column == 0 ? 10 : (self.frame.size.width / 2) + 4);
    frame.origin.y = (8 + frame.size.height) * row + 8;
    
    if (backgroundImageView != nil) {
      if (column == 0) {
        frame.origin.x += 5;
      }
    }
    
    if (i == 0 && oddNumberOfButtons) {
      frame.size.width = (self.frame.size.width - 2 * frame.origin.x);
    } else {
      frame.size.width = (self.frame.size.width / 2) - 14;
    
      if (backgroundImageView != nil) {
        frame.size.width -= 5;
      }      
    }
    
    button.frame = frame;
  }
}


- (void) disableButtons {
  for (UIButton* button in buttons) {
    button.enabled = NO;
  }
}


- (void) enableButtons {
  for (UIButton* button in buttons) {
    button.enabled = YES;
  }
}

@end
