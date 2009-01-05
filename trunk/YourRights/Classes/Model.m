//
//  Model.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Model.h"


@implementation Model

static NSArray* sectionTitles;
static NSArray* shortSectionTitles;

+ (void) initialize {
    if (self == [Model class]) {
        sectionTitles = [[NSArray arrayWithObjects:
                          NSLocalizedString(@"Questioning", nil),
                          NSLocalizedString(@"Stops and Arrests", nil),
                          NSLocalizedString(@"Searches and Warrants", nil),
                          NSLocalizedString(@"Additional Information for Non-Citizens", nil),
                          NSLocalizedString(@"Rights at Airports and Other Ports of Entry into the United States", nil),
                          NSLocalizedString(@"Charitable Donations and Religious Practices", nil), nil] retain];
        
        shortSectionTitles = [[NSArray arrayWithObjects:
                               NSLocalizedString(@"Questioning", nil),
                               NSLocalizedString(@"Stops and Arrests", nil),
                               NSLocalizedString(@"Searches and Warrants", nil),
                               NSLocalizedString(@"Info for Non-Citizens", nil),
                               NSLocalizedString(@"Rights at Airports", nil),
                               NSLocalizedString(@"Charitable Donations", nil), nil] retain];
        
    }
}


+ (NSArray*) sectionTitles {
    return sectionTitles;
}


+ (NSArray*) shortSectionTitles {
    return shortSectionTitles;
}


+ (NSString*) shortSectionTitleForSectionTitle:(NSString*) sectionTitle {
    return [shortSectionTitles objectAtIndex:[sectionTitles indexOfObject:sectionTitle]];
}


+ (NSArray*) questionsForSectionTitle:(NSString*) sectionTitle {
    return [NSArray array];
}

@end
