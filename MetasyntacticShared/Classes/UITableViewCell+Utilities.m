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

#import "UITableViewCell+Utilities.h"

@implementation UITableViewCell(UITableViewCellUtilities)

#ifdef IPHONE_OS_VERSION_3

- (UIFont*) font {
    return self.textLabel.font;
}


- (UIImage*) image {
    return self.imageView.image;
}


- (NSString*) text {
    return self.textLabel.text;
}


- (void) setText:(NSString*) text {
    self.textLabel.text = text;
}


- (void) setImage:(UIImage*) image {
    self.imageView.image = image;
}


- (void) setTextColor:(UIColor*) color {
    self.textLabel.textColor = color;
}


- (void) setFont:(UIFont*) font {
    self.textLabel.font = font;
}


- (void) setTextAlignment:(UITextAlignment) alignment {
    self.textLabel.textAlignment = alignment;
}

#endif

@end