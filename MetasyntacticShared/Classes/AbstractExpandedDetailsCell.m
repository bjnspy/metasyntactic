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

#import "AbstractExpandedDetailsCell.h"

#import "MetasyntacticStockImages.h"
#import "MutableMultiDictionary.h"
#import "NSArray+Utilities.h"

@interface AbstractExpandedDetailsCell()
@property (retain) NSArray* titles;
@property (retain) NSDictionary* titleToLabel;
@property (retain) MultiDictionary* titleToValueLabels;
@end


@implementation AbstractExpandedDetailsCell

@synthesize titles;
@synthesize titleToLabel;
@synthesize titleToValueLabels;

- (void) dealloc {
  self.titles = nil;
  self.titleToLabel = nil;
  self.titleToValueLabels = nil;

  [super dealloc];
}


+ (void) addTitle:(NSString*) title
        andValues:(NSArray*) values
               to:(MutableMultiDictionary*) items
              and:(NSMutableArray*) itemsArray {
  [itemsArray addObject:title];
  [items addObjects:values forKey:title];
}


+ (void) addTitle:(NSString*) title
         andValue:(NSString*) value
               to:(MutableMultiDictionary*) items
              and:(NSMutableArray*) itemsArray {
  [itemsArray addObject:title];
  [items addObject:value forKey:title];
}


- (void) setLabelWidths {
  CGFloat titleWidth = 0;
  for (UILabel* label in titleToLabel.allValues) {
    titleWidth = MAX(titleWidth, [label.text sizeWithFont:label.font].width);
  }
  UILabel* firstLabel = [titleToLabel objectForKey:titles.firstObject];
  CGFloat firstTitleWidth = [firstLabel.text sizeWithFont:firstLabel.font].width;

  titleWidth = MAX(titleWidth + 20, firstTitleWidth + 40);

  for (UILabel* label in titleToLabel.allValues) {
    CGRect frame = label.frame;
    frame.size.width = titleWidth;
    label.frame = frame;
  }
  for (NSArray* labels in titleToValueLabels.allValues) {
    for (UILabel* label in labels) {
      CGRect frame = label.frame;
      frame.origin.x = titleWidth + 7;
      label.frame = frame;
    }
  }
}


- (void) setLabelPositions {
  NSInteger yPosition = 5;
  for (NSString* title in titles) {
    UILabel* titleLabel = [titleToLabel objectForKey:title];
    CGRect titleFrame = titleLabel.frame;

    titleFrame.origin.y = yPosition;
    titleLabel.frame = titleFrame;

    for (UILabel* valueLabel in [titleToValueLabels objectsForKey:title]) {
      CGRect valueFrame = valueLabel.frame;
      valueFrame.origin.y = yPosition;

      yPosition += valueLabel.font.pointSize + 10;
      valueLabel.frame = valueFrame;
    }
  }
}


- (void) addDisclosureArrow {
  UIImageView* imageView = [[[UIImageView alloc] initWithImage:[MetasyntacticStockImages collapseArrow]] autorelease];
  CGRect frame = imageView.frame;
  frame.origin.x = 10;
  frame.origin.y = 10;
  imageView.frame = frame;

  [self.contentView addSubview:imageView];
}


+ (UILabel*) createTitleLabel:(NSString*) title {
  UILabel* label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];

  label.font = [UIFont systemFontOfSize:14];
  label.textColor = [UIColor darkGrayColor];
  label.backgroundColor = [UIColor clearColor];
  label.text = title;
  label.textAlignment = UITextAlignmentRight;
  [label sizeToFit];

  return label;
}


+ (UILabel*) createValueLabel:(NSString*) value {
  UILabel* label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
  label.font = [UIFont systemFontOfSize:14];
  label.backgroundColor = [UIColor clearColor];
  label.text = value;
  [label sizeToFit];
  return label;
}


+ (void) initializeData:(MultiDictionary*) items
             itemsArray:(NSArray*) itemsArray
                 titles:(NSMutableArray*) titles
           titleToLabel:(NSMutableDictionary*) titleToLabel
     titleToValueLabels:(MutableMultiDictionary*) titleToValueLabel {
  for (NSString* title in itemsArray) {
    [titles addObject:title];

    UILabel* titleLabel = [self createTitleLabel:title];
    [titleToLabel setObject:titleLabel forKey:title];

    for (NSString* value in [items objectsForKey:title]) {
      UILabel* valueLabel = [self createValueLabel:value];
      [titleToValueLabel addObject:valueLabel forKey:title];
    }
  }
}


- (id)    initWithItems:(MultiDictionary*) items
             itemsArray:(NSArray*) itemsArray
    tableViewController:(UITableViewController*) tableViewController {
  if ((self = [super initWithTableViewController:tableViewController])) {
    NSMutableArray* titlesArray = [NSMutableArray array];
    NSMutableDictionary* titleToLabelDictionary = [NSMutableDictionary dictionary];
    MutableMultiDictionary* titleToValueLabelsDictionary = [MutableMultiDictionary dictionary];

    [AbstractExpandedDetailsCell initializeData:items
                                     itemsArray:itemsArray
                                         titles:titlesArray
                                   titleToLabel:titleToLabelDictionary
                             titleToValueLabels:titleToValueLabelsDictionary];

    self.titles = titlesArray;
    self.titleToLabel = titleToLabelDictionary;
    self.titleToValueLabels = titleToValueLabelsDictionary;

    for (UILabel* label in titleToLabel.allValues) {
      [self.contentView addSubview:label];
    }
    for (NSArray* array in titleToValueLabels.allValues) {
      for (UILabel* label in array) {
        [self.contentView addSubview:label];
      }
    }

    [self setLabelPositions];
    [self setLabelWidths];

    [self addDisclosureArrow];
  }

  return self;
}


- (void) layoutSubviews {
  [super layoutSubviews];

  for (NSArray* labels in titleToValueLabels.allValues) {
    for (UILabel* label in labels) {
      CGRect frame = label.frame;
      frame.size.width = MIN(frame.size.width, self.contentView.frame.size.width - frame.origin.x);
      label.frame = frame;
    }
  }
}


- (CGFloat) height {
  NSString* lastTitle = titles.lastObject;
  NSArray* labels = [titleToValueLabels objectsForKey:lastTitle];
  UILabel* lastLabel = labels.lastObject;

  NSInteger y = lastLabel.frame.origin.y;
  NSInteger height = lastLabel.frame.size.height;
  return y + height + 7;
}

@end
