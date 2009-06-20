//
//  AbstractFullScreenImageListViewController.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractFullScreenViewController.h"

#import "TappableScrollViewDelegate.h"

@interface AbstractFullScreenImageListViewController : AbstractFullScreenViewController<TappableScrollViewDelegate, UIScrollViewDelegate, UIActionSheetDelegate> {
@private
  TappableScrollView* scrollView;
  
  NSInteger currentPage;
  NSInteger imageCount;
  NSMutableDictionary* pageNumberToView;
  
  BOOL shutdown;
  
  BOOL saving;
  UILabel* savingLabel;
}

- (id) initWithImageCount:(NSInteger) imageCount;

@end
