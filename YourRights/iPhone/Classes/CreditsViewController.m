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

#import "CreditsViewController.h"

#import "Application.h"
#import "LocaleUtilities.h"
#import "Model.h"

@interface CreditsViewController()
@property (assign) UINavigationController* navigationController;
@end


@implementation CreditsViewController

typedef enum {
    WrittenBySection,
    MyOtherApplicationsSection,
    InformationProvidedBySection,
    LicenseSection,
    LastSection = LicenseSection
} CreditsSection;

@synthesize navigationController;

- (void) dealloc {
    self.navigationController = nil;
    
    [super dealloc];
}


- (id) initWithNavigationController:(UINavigationController*) navigationController_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = navigationController_;
    }
    
    return self;
}


- (void) majorRefresh {
    [self.tableView reloadData];
}


- (void) viewWillAppear:(BOOL) animated {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return LastSection + 1;
}


- (NSInteger)       tableView:(UITableView*) table
        numberOfRowsInSection:(NSInteger) section {
    if (section == WrittenBySection) {
        return 3;
    } else if (section == MyOtherApplicationsSection) {
        return 3;
    } else if (section == InformationProvidedBySection) {
        return 1;
    } else if (section == LicenseSection) {
        return 1;
    }
    
    return 0;
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (section == WrittenBySection) {
        if (row == 0) {
            cell.text = NSLocalizedString(@"Send Feedback", nil);
        } else if (row == 1) {
            cell.text = NSLocalizedString(@"Project Website", nil);
        } else {
            cell.text = NSLocalizedString(@"Write Review", nil);
        }
    } else if (section == MyOtherApplicationsSection) {
        if (row == 0) {
            cell.text = @"Now Playing";
        } else if (row == 1) {
            cell.text = @"ComiXology";
        } else {
            cell.text = @"PocketFlix";
        }
    } else if (section == InformationProvidedBySection) {
        cell.text = NSLocalizedString(@"American Civil Liberties Union", nil);
    } else if (section == LicenseSection) {
        cell.text = NSLocalizedString(@"License", nil);
    }
    
    return cell;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == WrittenBySection) {
        return NSLocalizedString(@"Written by Cyrus Najmabadi", nil);
    } else if (section == MyOtherApplicationsSection) {
        return NSLocalizedString(@"My other applications", nil);
    } else if (section == InformationProvidedBySection) {
        return NSLocalizedString(@"Information obtained from the", nil);
    }
    
    return nil;
}


- (NSString*)      tableView:(UITableView*) tableView
     titleForFooterInSection:(NSInteger) section {
    if (section == WrittenBySection) {
        return [NSString stringWithFormat:NSLocalizedString(@"If you like %@, please consider writing a small review for the iTunes store. It will help new users discover this app, increase my ability to bring you great new features, and will also make me feel warm and fuzzy inside. Thanks!", nil), [Application name]];
    } else if (section == InformationProvidedBySection) {
        return NSLocalizedString(@"This application is not provided by or endorsed by the American Civil Liberties Union.\n\n"
                                 @"This application addresses what rights you  have when you are "
                                 @"stopped, questioned, arrested, or searched by law enforcement "
                                 @"officers. This information is for citizens and  non-citizens. "
                                 @"This application tells you about your basic rights. It is not a substitute "
                                 @"for legal advice. You should contact an attorney if you have been "
                                 @"arrested or believe that your rights have been violated.", nil);
    }
    
    return nil;
}


- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section < LicenseSection) {
        return UITableViewCellAccessoryDetailDisclosureButton;
    } else {
        return UITableViewCellAccessoryDisclosureIndicator;
    }
}


- (void) licenseCellTapped {
    UIViewController* controller = [[[UIViewController alloc] init] autorelease];
    controller.title = NSLocalizedString(@"License", nil);
    
    UITextView* textView = [[[UITextView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    textView.editable = NO;
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    NSString* licensePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"License.txt"];
    textView.text = [NSString stringWithContentsOfFile:licensePath];
    textView.font = [UIFont boldSystemFontOfSize:12];
    textView.textColor = [UIColor grayColor];
    
    [controller.view addSubview:textView];
    [navigationController pushViewController:controller animated:YES];
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == LicenseSection) {
        [self licenseCellTapped];
    }
}


- (void)                            tableView:(UITableView*) tableView
     accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSString* address = nil;
    if (section == WrittenBySection) {
        if (row == 0) {
            address = [Model feedbackUrl];
        } else if (row == 1) {
            address = @"http://metasyntactic.googlecode.com";
        } else {
            address = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=301494200&mt=8";
        }
    } else if (section == MyOtherApplicationsSection) {
        if (row == 0) {
            address = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=297414943&mt=8";
        } else if (row == 1) {
            address = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=284939567&mt=8";
        } else {
            address = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=301386724&mt=8";
        }
    } else if (section == InformationProvidedBySection) {
        address = @"http://www.aclu.org";
    } else if (section == LicenseSection) {
        return;
    }
    
    NSURL* url = [NSURL URLWithString:address];
    [[UIApplication sharedApplication] openURL:url];
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
}

@end