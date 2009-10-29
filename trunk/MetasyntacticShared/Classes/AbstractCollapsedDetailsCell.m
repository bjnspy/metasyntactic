//
//  AbstractCollapsedDetailsCell.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractCollapsedDetailsCell.h"

#import "MetasyntacticStockImages.h"

@implementation AbstractCollapsedDetailsCell

- (id) init {
  if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil])) {
    self.textLabel.font = [UIFont boldSystemFontOfSize:14];
    self.textLabel.textAlignment = UITextAlignmentCenter;
    
    UIImage* backgroundImage = [MetasyntacticStockImage(@"CollapsedDetailsBackground.png") stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    if (backgroundImage != nil) {
      self.backgroundView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
      self.textLabel.textColor = [UIColor whiteColor];
      self.textLabel.backgroundColor = [UIColor clearColor];
      self.textLabel.opaque = NO;
    }

    self.imageView.image = [MetasyntacticStockImages expandArrow];
  }
  
  return self;
}


- (CGFloat) height:(UITableView*) tableView {
  return tableView.rowHeight - 14;
}

@end
