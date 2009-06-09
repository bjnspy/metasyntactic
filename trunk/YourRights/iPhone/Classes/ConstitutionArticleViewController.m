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

#import "ConstitutionArticleViewController.h"

#import "Article.h"
#import "Section.h"
#import "WrappableCell.h"
#import "YourRightsNavigationController.h"

@interface ConstitutionArticleViewController()
@property (retain) Article* article;
@property (retain) NSArray* sectionChunks;
@end


@implementation ConstitutionArticleViewController

@synthesize article;
@synthesize sectionChunks;

- (void) dealloc {
    self.article = nil;
    self.sectionChunks = nil;

    [super dealloc];
}


- (id) initWithArticle:(Article*) article_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.article = article_;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        NSMutableArray* array = [NSMutableArray array];
        for (Section* section in article_.sections) {
            [array addObject:[StringUtilities splitIntoChunks:section.text]];
        }
        self.sectionChunks = array;
    }

    return self;
}


- (void) loadView {
    [super loadView];
    self.navigationItem.titleView =
    [ViewControllerUtilities viewControllerTitleLabel:article.title];
}


- (void) minorRefreshWorker {
}


- (void) majorRefreshWorker {
    [self reloadTableViewData];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return article.sections.count + 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < article.sections.count) {
        return [[sectionChunks objectAtIndex:section] count];
    } else {
        if (article.link.length > 0) {
            return 1;
        }
    }

    return 0;
}


- (UITableViewCell*) cellForSectionRowAtIndexPath:(NSIndexPath*) indexPath {
    NSArray* chunks = [sectionChunks objectAtIndex:indexPath.section];
    NSString* chunk = [chunks objectAtIndex:indexPath.row];
    WrappableCell *cell = [[[WrappableCell alloc] initWithTitle:chunk] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}


- (UITableViewCell*) cellForLinksRow:(NSInteger) row {
    UITableViewCell* cell = [[[UITableViewCell alloc] init] autorelease];
    cell.textLabel.text = @"Wikipedia";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < article.sections.count) {
        return [self cellForSectionRowAtIndexPath:indexPath];
    } else {
        return [self cellForLinksRow:indexPath.row];
    }
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section < article.sections.count) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    } else {
        [(id)self.navigationController pushBrowser:article.link animated:YES];
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section < article.sections.count) {
        if (article.sections.count > 1) {
            return [NSString stringWithFormat:NSLocalizedString(@"Section %d", nil), section + 1];
        }
    } else {
        if (article.link.length > 0) {
            return NSLocalizedString(@"Links", nil);
        }
    }

    return nil;
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section < article.sections.count) {
        NSArray* chunks = [sectionChunks objectAtIndex:indexPath.section];
        NSString* chunk = [chunks objectAtIndex:indexPath.row];

        return [WrappableCell height:chunk accessoryType:UITableViewCellAccessoryNone];
    } else {
        return tableView.rowHeight;
    }
}

@end
