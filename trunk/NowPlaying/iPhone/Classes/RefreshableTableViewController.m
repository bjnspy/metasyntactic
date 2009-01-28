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

@interface RefreshableTableViewController()
@property (retain) UITableView* tableView;
@end


@implementation RefreshableTableViewController

@synthesize tableView;

- (void) dealloc {
    self.tableView = nil;
    [super dealloc];
}


- (id) initWithStyle:(UITableViewStyle) style {
    if (self = [super init]) {
        self.tableView = [[[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:style] autorelease];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        // add the subviews and set their resize behavior
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }

    return self;
}


- (void) loadView {
    CGRect rect = [UIScreen mainScreen].bounds;
    
    self.view = [[[UIView alloc] initWithFrame:rect] autorelease];
    self.view.autoresizesSubviews = YES;
    
    [self.view addSubview:tableView];   
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

    if (tableView.dragging || tableView.decelerating) {
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


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (NSInteger) tableView:(UITableView*) tableView
  numberOfRowsInSection:(NSInteger) section {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}

@end