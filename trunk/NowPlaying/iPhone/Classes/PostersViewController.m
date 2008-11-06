//
//  PostersViewController.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PostersViewController.h"

#import "AbstractNavigationController.h"
#import "ColorCache.h"
#import "LargePosterCache.h"
#import "NonClippingView.h"
#import "NowPlayingModel.h"
#import "TappableScrollViewDelegate.h"
#import "TappableScrollView.h"
#import "ThreadingUtilities.h"

@implementation PostersViewController

const double TRANSLUCENCY_LEVEL = 0.9;
const int ACTIVITY_INDICATOR_TAG = -1;

@synthesize navigationController;
@synthesize downloadCoverGate;
@synthesize pageViews;
@synthesize movie;
@synthesize toolBar;

- (void) dealloc {
    self.navigationController = nil;
    self.downloadCoverGate = nil;
    self.pageViews = nil;
    self.movie = nil;
    self.toolBar = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_
                              movie:(Movie*) movie_ 
                        posterCount:(NSInteger) posterCount_
                   smallPosterFrame:(CGRect) smallPosterFrame_ {
    if (self = [super init]) {
        self.navigationController = navigationController_;
        self.movie = movie_;
        posterCount = posterCount_;
        smallPosterFrame = smallPosterFrame_;
    }
    
    return self;
}


- (NowPlayingController*) controller {
    return navigationController.controller;
}


- (NowPlayingModel*) model {
    return navigationController.model;
}


- (void) setupTitle {
    NSString* title =
    [NSString stringWithFormat:
     NSLocalizedString(@"%d of %d", nil), (currentPage + 1), posterCount];
    
    [[toolBar.items objectAtIndex:0] setTitle:title];
}


- (UILabel*) createDownloadingLabel {
    UILabel* downloadingLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    downloadingLabel.backgroundColor = [UIColor clearColor];
    downloadingLabel.opaque = NO;
    downloadingLabel.text = NSLocalizedString(@"Downloading data", nil);
    downloadingLabel.font = [UIFont boldSystemFontOfSize:24];
    downloadingLabel.textColor = [UIColor whiteColor];
    [downloadingLabel sizeToFit];
    
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    CGRect labelFrame = downloadingLabel.frame;
    labelFrame.origin.x = (int)((frame.size.width - labelFrame.size.width) / 2.0);
    labelFrame.origin.y = (int)((frame.size.height - labelFrame.size.height) / 2.0);
    downloadingLabel.frame = labelFrame;
    
    return downloadingLabel;
}


- (UIActivityIndicatorView*) createActivityIndicator:(UILabel*) label {
    UIActivityIndicatorView* activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    activityIndicator.tag = ACTIVITY_INDICATOR_TAG;
    [activityIndicator sizeToFit];
    
    CGRect labelFrame = label.frame;
    CGRect activityFrame = activityIndicator.frame;
    
    activityFrame.origin.x = (int)(labelFrame.origin.x - activityFrame.size.width) - 5;
    activityFrame.origin.y = (int)(labelFrame.origin.y + (labelFrame.size.height / 2) - (activityFrame.size.height / 2));
    activityIndicator.frame = activityFrame;
    
    [activityIndicator startAnimating];
    
    return activityIndicator;
}


- (void) createDownloadViews:(UIView*) pageView {
    UILabel* downloadingLabel = [self createDownloadingLabel];
    UIActivityIndicatorView* activityIndicator = [self createActivityIndicator:downloadingLabel];
    
    CGRect frame = activityIndicator.frame;
    double width = frame.size.width;
    frame.origin.x = (int)(frame.origin.x + width / 2);
    activityIndicator.frame = frame;
    
    frame = downloadingLabel.frame;
    frame.origin.x = (int)(frame.origin.x + width / 2);
    downloadingLabel.frame = frame;
    
    [pageView addSubview:activityIndicator];
    [pageView addSubview:downloadingLabel];
}


- (UIImageView*) createImageView:(UIImage*) image {
    UIImageView* imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizesSubviews = YES;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    CGRect frame = [UIScreen mainScreen].applicationFrame;
    frame.origin.y = 0;
    imageView.frame = frame;
    
    return imageView;
}


- (TappableScrollView*) createScrollView {
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    frame.origin.y = 0;
    
//    frame.origin.y = -self.navigationController.navigationBar.frame.size.height;
//    frame.size.height = [UIScreen mainScreen].applicationFrame.size.height;
    
    TappableScrollView* scrollView = [[[TappableScrollView alloc] initWithFrame:frame] autorelease];
    scrollView.delegate = self;
    scrollView.tapDelegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.directionalLockEnabled = YES;
    scrollView.autoresizingMask = 0;
    scrollView.backgroundColor = [UIColor blackColor];
    
    frame.size.width *= posterCount;
    scrollView.contentSize = frame.size;
    
    return scrollView;
}


- (UIView*) loadPage:(NSInteger) page {
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    frame.origin.y = 0;
    frame.origin.x = page * frame.size.width;
    
    UIView* pageView = [[[UIView alloc] initWithFrame:frame] autorelease];
    pageView.backgroundColor = [UIColor blackColor];
    pageView.tag = page;
    pageView.autoresizesSubviews = YES;
    pageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    UIImage* image = nil;
    if (page == 0) {
        image = [self.model.largePosterCache firstPosterForMovie:movie];
    }
    
    if (image != nil) {
        UIImageView* imageView = [self createImageView:image];
        [pageView addSubview:imageView];
    } else {    
        [self createDownloadViews:pageView];
        
        NSArray* indexAndPageView = [NSArray arrayWithObjects:[NSNumber numberWithInt:page], pageView, nil];
        [ThreadingUtilities performSelector:@selector(loadPoster:)
                                   onTarget:self
                   inBackgroundWithArgument:indexAndPageView
                                       gate:downloadCoverGate
                                    visible:NO];
    }
    
    return pageView;
}


- (void) loadPoster:(NSArray*) indexAndPageView {
    NSNumber* index = [indexAndPageView objectAtIndex:0];
    UIView* pageView = [indexAndPageView objectAtIndex:1];
    
    UIImage* image = nil;
    while (!shutdown) {
        // try again in a second
        [self.model.largePosterCache downloadPosterForMovie:movie index:index.intValue];
        image = [self.model.largePosterCache posterForMovie:movie index:index.intValue];

        if (image != nil) {
            break;
        }
        
        [downloadCoverGate unlock];
        [NSThread sleepForTimeInterval:1];
        [downloadCoverGate lock];
    }
    
    NSArray* imageAndView = [NSArray arrayWithObjects:image, pageView, nil];
    [self performSelectorOnMainThread:@selector(addImageToView:) withObject:imageAndView waitUntilDone:NO];
}


- (void) disableActivityIndicator:(UIView*) pageView {
    id view = [pageView viewWithTag:ACTIVITY_INDICATOR_TAG];
    [view stopAnimating];
    [view removeFromSuperview];
}


- (void) addImageToView:(NSArray*) imageAndView {
    if (shutdown) {
        return;
    }
    
    UIImage* image = [imageAndView objectAtIndex:0];
    UIView* pageView = [imageAndView objectAtIndex:1];
    
    [self disableActivityIndicator:pageView];
    
    UIImageView* imageView = [self createImageView:image];
    
    [pageView addSubview:imageView];
    imageView.alpha = 0;
    
    [UIView beginAnimations:nil context:NULL];
    {
        imageView.alpha = 1;
    }
    [UIView commitAnimations];
}


- (void) loadView {
    NonClippingView* view = [[[NonClippingView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    view.autoresizesSubviews = YES;
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    TappableScrollView* scrollView = [self createScrollView];
    scrollView.autoresizesSubviews = YES;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    for (int i = 0; i < posterCount; i++) {
        UIView* pageView = [self loadPage:i];
        [scrollView addSubview:pageView];
    }
    
    self.toolBar = [[[UINavigationBar alloc] initWithFrame:CGRectZero] autorelease];
    UINavigationItem* item = [[[UINavigationItem alloc] init] autorelease];
    item.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                             target:self
                                                                             action:@selector(onDoneTapped:)] autorelease];
    toolBar.alpha = 0;
    toolBarHidden = YES;
    toolBar.items = [NSArray arrayWithObject:item];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    [toolBar sizeToFit];
    [self setupTitle];

    [view addSubview:scrollView];
    [view addSubview:toolBar];
    
    self.view = view;
}


- (void) onDoneTapped:(id) argument {
    toolBar.alpha = 0;

    [UIView beginAnimations:nil context:NULL];
    {   
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(onAfterDoneTapped:finished:context:)];
        
        self.view.frame = smallPosterFrame;
        self.view.alpha = 0;
    }
    [UIView commitAnimations];
}


- (void) onAfterDoneTapped:(NSString*) animationId
               finished:(BOOL) finished
                context:(void*) context {
    [self.view removeFromSuperview];
    [self autorelease];
}


- (void) hideToolBar:(BOOL) hidden {
    toolBarHidden = hidden;
    
    [UIView beginAnimations:nil context:NULL];
    {
        if (hidden) {
            toolBar.alpha = 0;
        } else {
            toolBar.alpha = TRANSLUCENCY_LEVEL;
        }
    }
    [UIView commitAnimations];
}


- (void) scrollView:(TappableScrollView*) scrollView
          wasTapped:(NSInteger) tapCount
            atPoint:(CGPoint) point {
    [self hideToolBar:!toolBarHidden];
}


- (void) scrollViewWillBeginDragging:(UIScrollView*) scrollView {
    [self hideToolBar:YES];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = (NSInteger)((scrollView.contentOffset.x + pageWidth / 2) / pageWidth);
 
    if (page != currentPage) {
        currentPage = page;
        [self setupTitle];
    }
}

@end
