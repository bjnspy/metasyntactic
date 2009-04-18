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
#import "SquareMovieTitleCell.h"

#import "ColorCache.h"
#import "FontCache.h"

@implementation SquareMovieTitleCell

- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
#ifdef IPHONE_OS_VERSION_3
        CGRect frame = CGRectMake(6, 6, 30, 30);
#else
        CGRect frame = CGRectMake(10, 7, 30, 30);
#endif
        scoreLabel.font = [FontCache boldSystem19];
        scoreLabel.textColor = [ColorCache darkDarkGray];
        scoreLabel.frame = frame;
    }

    return self;
}

@end