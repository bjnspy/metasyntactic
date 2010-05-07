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

#import "CountryViewController.h"

#import "LocaleUtilities.h"
#import "MetasyntacticSharedApplication.h"

@interface CountryViewController()
@property (retain) NSArray* countryCodes;
@end


@implementation CountryViewController

@synthesize countryCodes;

- (void) dealloc {
  self.countryCodes = nil;
  [super dealloc];
}


- (id) init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    NSMutableArray* array = [NSMutableArray array];
    for (NSString* isoCountryCode in [NSLocale ISOCountryCodes]) {
      [array addObject:[LocaleUtilities displayCountry:isoCountryCode]];
    }
    [array sortUsingSelector:@selector(compare:)];
    self.countryCodes = array;
  }

  return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return countryCodes.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString* reuseIdentifier = @"reuseIdentifier";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
  }

  if (indexPath.row == 0) {
    cell.textLabel.text = LocalizedString(@"Default (%@)", [LocaleUtilities displayCountry]);
  } else {
    NSInteger index = indexPath.row - 1;
    NSString* country = [countryCodes objectAtIndex:index];

    cell.textLabel.text = country;
  }

  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
   // ...
   // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}

@end
