// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "RottenMovieTitleCell.h"

#import "ImageCache.h"
#import "UITableViewCell+Utilities.h"

@implementation RottenMovieTitleCell

+ (NSString*) reuseIdentifier {
    return @"RottenMovieTitleCell";
}


- (id) init {
    if (self = [super initWithReuseIdentifier:[[self class] reuseIdentifier]]) {
        self.image = [ImageCache rottenFadedImage];

        scoreLabel.font = [UIFont boldSystemFontOfSize:17];
        scoreLabel.textColor = [UIColor blackColor];

#ifdef IPHONE_OS_VERSION_3
        CGRect frame = CGRectMake(5, 5, 30, 32);
#else
        CGRect frame = CGRectMake(10, 6, 30, 32);
#endif

        scoreLabel.frame = frame;
    }

    return self;
}

@end