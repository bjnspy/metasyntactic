//
//  AlertUtilities.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AlertUtilities.h"


@implementation AlertUtilities

+ (void) showOkAlert:(NSString*) message {
    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:nil
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                           otherButtonTitles:nil] autorelease];
    
    [alert show];
}

@end
