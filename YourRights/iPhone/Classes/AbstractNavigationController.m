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

#import "AbstractNavigationController.h"

#import "Model.h"

@implementation AbstractNavigationController

- (Model*) model {
    return [Model model];
}


- (void) refresh:(SEL) selector {
    for (id controller in self.viewControllers) {
        if ([controller respondsToSelector:selector]) {
            [controller performSelector:selector];
        }
    }
}


- (void) majorRefresh {
    [self refresh:@selector(majorRefresh)];
}


- (void) minorRefresh {
    [self refresh:@selector(minorRefresh)];
}


- (void) pushBrowser:(NSString*) address animated:(BOOL) animated {
    [self pushBrowser:address animated:animated showSafariButton:YES];
}


- (void) pushBrowser:(NSString*) address animated:(BOOL) animated showSafariButton:(BOOL) showSafariButton {
    WebViewController* controller = [[[WebViewController alloc] initWithAddress:address showSafariButton:showSafariButton] autorelease];
    [self pushViewController:controller animated:animated];
}

@end