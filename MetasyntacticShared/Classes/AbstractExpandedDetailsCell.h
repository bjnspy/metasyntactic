//
//  AbstractExpandedDetailsCell.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractDetailsCell.h"

@interface AbstractExpandedDetailsCell : AbstractDetailsCell {
@private
  NSArray* titles;
  NSDictionary* titleToLabel;
  MultiDictionary* titleToValueLabels;
}

/* @protected */
- (id) initWithItems:(MultiDictionary*) items itemsArray:(NSArray*) itemsArray;



+ (void) addTitle:(NSString*) title
        andValues:(NSArray*) values
               to:(MutableMultiDictionary*) items 
              and:(NSMutableArray*) itemsArray;


+ (void) addTitle:(NSString*) title
         andValue:(NSString*) value
               to:(MutableMultiDictionary*) items 
              and:(NSMutableArray*) itemsArray;

@end
