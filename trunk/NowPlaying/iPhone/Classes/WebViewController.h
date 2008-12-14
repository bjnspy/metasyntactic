//
//  WebViewController.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface WebViewController : UIViewController<UIWebViewDelegate> {
@private
    AbstractNavigationController* navigationController;
    UIWebView* webView;
    UIToolbar* toolbar;
    UIActivityIndicatorView* activityView;
    UILabel* label;
    NSString* address;
    BOOL showSafariButton;
}

- (id) initWithNavigationController:(AbstractNavigationController*) navigationController
                            address:(NSString*) address
                   showSafariButton:(BOOL) showSafariButton;

@end
