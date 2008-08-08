// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it 
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51 
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "ReviewBodyCell.h"

#import "FontCache.h"
#import "Review.h"

@implementation ReviewBodyCell

@synthesize label;

- (void) dealloc {
    self.label = nil;

    [super dealloc];
}

- (id) initWithFrame:(CGRect) frame reuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.label = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.label.font = [FontCache helvetica14];
        self.label.lineBreakMode = UILineBreakModeWordWrap;
        self.label.numberOfLines = 0;

        [self.contentView addSubview:label];
    }
    return self;
}

- (void) setReview:(Review*) review {
    CGRect rect = CGRectMake(10, 5, review.link ? 255 : 285, [review heightWithFont:[FontCache helvetica14]] - 10);
    self.label.frame = rect;
    self.label.text = review.text;
}

@end
