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

#import "AbstractCollapsedDetailsCell.h"

#import "MetasyntacticStockImages.h"

@implementation AbstractCollapsedDetailsCell

- (id) initWithTableViewController:(UITableViewController *)tableViewController {
  if ((self = [super initWithStyle:UITableViewCellStyleDefault
               tableViewController:tableViewController])) {
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


- (CGFloat) height {
  return self.tableViewController.tableView.rowHeight - 14;
}

@end
