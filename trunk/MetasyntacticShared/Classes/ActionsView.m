// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "ActionsView.h"

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
    self.backgroundColor = [UIColor clearColor];// [UIColor groupTableViewBackgroundColor];

    if ([Portability userInterfaceIdiom] == UserInterfaceIdiomPad) {
      marginWidth = 44;
    } else {
      marginWidth = 10;
    }

    UIImage* backgroundImage = MetasyntacticStockImage(@"ActionsViewBackground.png");
    if (backgroundImage != nil) {
      self.backgroundImageView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
      [self addSubview:backgroundImageView];
    }

    NSMutableArray* array = [NSMutableArray array];
    for (NSInteger i = 0; i < titles.count; i++) {
      NSString* title = [titles objectAtIndex:i];
      UIImage* image = [MetasyntacticStockImage([NSString stringWithFormat:@"ActionsViewButton%d.png", ((i + 1) % 4) / 2])
                        stretchableImageWithLeftCapWidth:9 topCapHeight:9];

      UIButton* button;

      if (image == nil) {
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
      } else {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
      }

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
      NSInteger lastRow = (buttons.count - 1) / 2;

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


//- (CGSize) sizeThatFits:(CGSize) size {
//  if (buttons.count == 0) {
//    return CGSizeZero;
//  }
//
//  CGFloat width;
//  if ([MetasyntacticSharedApplication screenRotationEnabled] &&
//      UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
//    width = [UIScreen mainScreen].bounds.size.height;
//  } else {
//    width = [UIScreen mainScreen].bounds.size.width;
//  }
//
//  return CGSizeMake(width, height);
//}


- (void) layoutSubviews {
  [super layoutSubviews];

  NSInteger outerMargin = marginWidth;
  NSInteger innerMargin = outerMargin / 2 - 1;

  backgroundImageView.frame =
    CGRectMake(marginWidth, 4,
               self.frame.size.width - 2 * marginWidth,
               self.frame.size.height + 1);

  BOOL oddNumberOfButtons = ((buttons.count % 2) == 1);

  for (NSInteger i = 0; i < buttons.count; i++) {
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
    frame.origin.x = (column == 0 ? outerMargin : (self.frame.size.width / 2) + innerMargin);
    frame.origin.y = (8 + frame.size.height) * row + 8;

    if (backgroundImageView != nil) {
      if (column == 0) {
        frame.origin.x += 5;
      }
    }

    frame.size.width = (self.frame.size.width / 2) - outerMargin - innerMargin;
    if (i == 0 && oddNumberOfButtons) {
      if (button.buttonType != UIButtonTypeCustom) {
        frame.size.width = (self.frame.size.width - 2 * frame.origin.x);
      }
    } else {
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
