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

#import "PerfectGreenMovieTitleCell.h"

#import "ImageCache.h"

@implementation PerfectGreenMovieTitleCell


+ (NSString*) reuseIdentifier {
    return @"PerfectGreenMovieTitleCell";
}

- (id) init {
    if (self = [super initWithReuseIdentifier:[[self class] reuseIdentifier]]) {
        self.image = [ImageCache greenRatingImage];

        scoreLabel.font = [UIFont boldSystemFontOfSize:15];
        scoreLabel.text = @"100";
    }

    return self;
}


- (void) setScore:(Score*) score {
}

@end