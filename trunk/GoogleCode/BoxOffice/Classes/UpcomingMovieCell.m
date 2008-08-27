// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "UpcomingMovieCell.h"

#import "Application.h"
#import "BoxOfficeModel.h"
#import "Movie.h"

@implementation UpcomingMovieCell

@synthesize model;
@synthesize titleLabel;
@synthesize directorLabel;
@synthesize castLabel;
@synthesize ratingsLabel;
@synthesize imageView;

- (void) dealloc {
    self.model = nil;
    self.titleLabel = nil;
    self.directorLabel = nil;
    self.castLabel = nil;
    self.ratingsLabel = nil;
    self.imageView = nil;

    [super dealloc];
}


- (id) initWithFrame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier
               model:(BoxOfficeModel*) model_ {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.model = model_;
        
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 0, 20)] autorelease];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.minimumFontSize = 14;
        titleLabel.textColor = [UIColor blackColor];
        
        self.directorLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 25, 0, 14)] autorelease];
        directorLabel.font = [UIFont systemFontOfSize:12];
        directorLabel.textColor = [UIColor grayColor];

        self.castLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 44, 0, 30)] autorelease];
        castLabel.font = [UIFont systemFontOfSize:12];
        castLabel.textColor = [UIColor grayColor];
        castLabel.numberOfLines = 0;
        
        self.ratingsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 80, 0, 14)] autorelease];
        ratingsLabel.font = [UIFont systemFontOfSize:12];
        ratingsLabel.textColor = [UIColor grayColor];
        
        self.imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ImageNotAvailable.png"]] autorelease];

        [self.contentView addSubview:titleLabel];
        [self.contentView addSubview:directorLabel];
        [self.contentView addSubview:castLabel];
        [self.contentView addSubview:ratingsLabel];
        [self.contentView addSubview:imageView];
    }
    
    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGRect imageFrame = imageView.frame;
    if (imageFrame.size.height >= 100) {
        imageFrame.size.width *= 99.0 / imageFrame.size.height;
        imageFrame.size.height = 99.0;
    }
    imageView.frame = imageFrame;
    
    for (UILabel* label in [NSArray arrayWithObjects:self.titleLabel, self.directorLabel, self.castLabel, self.ratingsLabel, nil]) {
        CGRect frame = label.frame;
        frame.origin.x = (int)(imageFrame.size.width + 7);
        frame.size.width = self.contentView.frame.size.width - frame.origin.x;
        label.frame = frame;
    }
}


- (void) setMovie:(Movie*) movie {
    self.titleLabel.text = movie.displayTitle;
    self.directorLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Directed by: %@", nil), movie.director];
    self.castLabel.text = [movie.cast componentsJoinedByString:@", "];
    self.ratingsLabel.text = movie.ratingAndRuntimeString;
    UIImage* image = [self.model posterForMovie:movie];
    if (image == nil) {
        imageView.image = [UIImage imageNamed:@"ImageNotAvailable.png"];
    } else {
        imageView.image = image;
    }
}


- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        titleLabel.textColor = [UIColor whiteColor];
        directorLabel.textColor = [UIColor whiteColor];
        castLabel.textColor = [UIColor whiteColor];
        ratingsLabel.textColor = [UIColor whiteColor];
    } else {
        titleLabel.textColor = [UIColor blackColor];
        directorLabel.textColor = [UIColor grayColor];
        castLabel.textColor = [UIColor grayColor];
        ratingsLabel.textColor = [UIColor grayColor];
    }
}


@end
