//
//  ViewControllerUtilities.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/16/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "ViewControllerUtilities.h"


@implementation ViewControllerUtilities

+ (UILabel*) viewControllerTitleLabel {
    UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
    label.adjustsFontSizeToFitWidth = YES;
    label.opaque = NO;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor darkGrayColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = UITextAlignmentCenter;
    label.minimumFontSize = 14;

    return label;
}

@end
