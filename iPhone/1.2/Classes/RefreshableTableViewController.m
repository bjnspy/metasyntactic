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

#import "RefreshableTableViewController.h"


@implementation RefreshableTableViewController

- (void)dealloc {
    [super dealloc];
}


- (id) initWithStyle:(UITableViewStyle) style {
    if (self = [super initWithStyle:style]) {
    }

    return self;
}


- (void) majorRefreshWorker {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (void) minorRefreshWorker {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (void) refreshWithSelector:(SEL) selector subclassSelector:(SEL) subclassSelector {
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:selector
                                               object:nil];

    if (self.tableView.dragging || self.tableView.decelerating) {
        [self performSelector:selector withObject:nil afterDelay:1];
        return;
    }

    [self performSelector:subclassSelector];
}


- (void) majorRefresh {
    [self refreshWithSelector:@selector(majorRefresh) subclassSelector:@selector(majorRefreshWorker)];
}


- (void) minorRefresh {
    [self refreshWithSelector:@selector(minorRefresh) subclassSelector:@selector(minorRefreshWorker)];
}

@end