//
//  MapViewControllerDelegate.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 7/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@protocol MapViewControllerDelegate
- (BOOL) hasDetailsForAnnotation:(id<MKAnnotation>) annotation;
- (void) detailsButtonTappedForAnnotation:(id<MKAnnotation>) annotation;
@end
