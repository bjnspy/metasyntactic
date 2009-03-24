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

#import "SwitchCell.h"

@interface SwitchCell()
@property (retain) UISwitch* switchControl_;
@end


@implementation SwitchCell

@synthesize switchControl_;

property_wrapper(UISwitch*, switchControl, SwitchControl);

- (void) dealloc {
    self.switchControl = nil;
    [super dealloc];
}


- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.switchControl = [[[UISwitch alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
        self.accessoryView = self.switchControl;
    }

    return self;
}

@end