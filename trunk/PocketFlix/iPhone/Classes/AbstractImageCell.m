//
//  AbstractImageCell.m
//  PocketFlix
//
//  Created by Cyrus Najmabadi on 1/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractImageCell.h"

#import "GlobalActivityIndicator.h"
#import "ImageCache.h"

@interface AbstractImageCell()
@property ImageState state;
@property (retain) Model* model;
@property (retain) UIImageView* imageLoadingView;
@property (retain) UIImageView* imageView;
@property (retain) UIActivityIndicatorView* activityView;
@property (retain) UILabel* titleLabel;
@end


@implementation AbstractImageCell

@synthesize state;
@synthesize model;
@synthesize imageLoadingView;
@synthesize imageView;
@synthesize activityView;
@synthesize titleLabel;

- (void) dealloc {
    self.model = nil;
    self.imageLoadingView = nil;
    self.imageView = nil;
    self.activityView = nil;
    self.titleLabel = nil;
    
    [super dealloc];
}


- (id) initWithFrame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier
               model:(Model*) model_ {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.model = model_;
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 2, 0, 20)] autorelease];
        
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.minimumFontSize = 14;
        
        state = Loading;
        self.imageLoadingView = [[[UIImageView alloc] initWithImage:[ImageCache imageLoading]] autorelease];
        imageLoadingView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.imageView = [[[UIImageView alloc] init] autorelease];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.alpha = 0;
        
        CGRect imageFrame = imageLoadingView.frame;
        imageFrame.size.width = (int)(imageFrame.size.width * SMALL_POSTER_HEIGHT / imageFrame.size.height);
        imageFrame.size.height = (int)SMALL_POSTER_HEIGHT;
        imageView.frame = imageLoadingView.frame = imageFrame;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        self.activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        activityView.hidesWhenStopped = YES;
        CGRect frame = activityView.frame;
        frame.origin.x = 25;
        frame.origin.y = 40;
        activityView.frame = frame;
        
        [self.contentView addSubview:titleLabel];
        [self.contentView addSubview:imageLoadingView];
        [self.contentView addSubview:imageView];
        [self.contentView addSubview:activityView];
    }
    
    return self;
}


- (UIImage*) loadImageWorker {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (void) prioritizeImage {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (void) loadImage {
    if (state == Loaded) {
        // we're done.  nothing else to do.
        return;
    }
    
    UIImage* image = [self loadImageWorker];
    if (image == nil) {
        [self prioritizeImage];
        if ([GlobalActivityIndicator hasBackgroundTasks]) {
            // don't need to do anything.
            // keep up the spinner
            state = Loading;
        } else {
            state = NotFound;
        }
    } else {
        CGSize imageSize = image.size;
        CGSize frameSize = imageView.frame.size;
        
        if (imageSize.height < frameSize.height &&
            imageSize.width < frameSize.width) {
            imageView.contentMode = UIViewContentModeCenter;
        } else {
            imageView.contentMode = UIViewContentModeScaleAspectFill;
        }
        
        state = Loaded;
    }
    
    switch (state) {
        case Loading: {
            [activityView startAnimating];
            imageView.image = nil;
            imageView.alpha = 0;
            return;
        }
        case Loaded: {
            [activityView stopAnimating];
            imageView.image = image;
            break;
        }
        case NotFound: {
            [activityView stopAnimating];
            imageView.image = [ImageCache imageNotAvailable];
            break;
        }
    }
    
    [UIView beginAnimations:nil context:NULL];
    {
        imageLoadingView.alpha = 0;
        imageView.alpha = 1;
    }
    [UIView commitAnimations];
}


- (void) clearImage {
    [activityView startAnimating];
    
    state = Loading;
    imageView.image = nil;
    imageView.alpha = 0;
    imageLoadingView.alpha = 1;
}


- (NSArray*) allLabels {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (NSArray*) titleLabels {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (NSArray*) valueLabels {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGRect imageFrame = imageView.frame;
    
    CGRect titleFrame = titleLabel.frame;
    titleFrame.origin.x = (int)(imageFrame.size.width + 7);
    titleFrame.size.width = self.contentView.frame.size.width - titleFrame.origin.x;
    titleLabel.frame = titleFrame;
    
    for (UILabel* label in self.valueLabels) {
        CGRect frame = label.frame;
        frame.origin.x = (int)(imageFrame.size.width + 7 + titleWidth + 5);
        frame.size.width = self.contentView.frame.size.width - frame.origin.x;
        label.frame = frame;
    }
}


- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        titleLabel.textColor = [UIColor whiteColor];
        
        for (UILabel* label in self.allLabels) {
            label.textColor = [UIColor whiteColor];
        }
    } else {
        titleLabel.textColor = [UIColor blackColor];
        
        for (UILabel* label in self.allLabels) {
            label.textColor = [UIColor darkGrayColor];
        }
    }
}


- (UILabel*) createTitleLabel:(NSString*) title yPosition:(NSInteger) yPosition {
    UILabel* label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor darkGrayColor];
    label.text = title;
    label.textAlignment = UITextAlignmentRight;
    [label sizeToFit];
    CGRect frame = label.frame;
    frame.origin.y = yPosition;
    label.frame = frame;
    
    return label;
}


- (UILabel*) createValueLabel:(NSInteger) yPosition forTitle:(UILabel*) title {
    CGFloat height = title.frame.size.height;
    UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, yPosition, 0, height)] autorelease];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor darkGrayColor];
    
    return label;
}


@end
