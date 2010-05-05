//
//  LanguageViewController.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 5/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LanguageViewController.h"

#import "MetasyntacticSharedApplication.h"

@interface LanguageViewController()
@property (retain) NSArray* languageCodes;
@end


@implementation LanguageViewController

@synthesize languageCodes;

- (void) dealloc {
  self.languageCodes = nil;
  [super dealloc];
}


- (id) init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    NSLog(@"%@", [NSLocale availableLocaleIdentifiers]);
    
    NSMutableArray* array = [NSMutableArray array];
    for (NSString* isoLanguageCode in [NSLocale ISOLanguageCodes]) {
      NSLocale* locale = [[[NSLocale alloc] initWithLocaleIdentifier:isoLanguageCode] autorelease];
      NSString* displayLanguage = [locale displayNameForKey:NSLocaleLanguageCode value:isoLanguageCode];
      [array addObject:displayLanguage];
    }
    [array sortUsingSelector:@selector(compare:)];
    self.languageCodes = array;
  }
  
  return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return languageCodes.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString* reuseIdentifier = @"reuseIdentifier";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
  }
  
  if (indexPath.row == 0) {
    cell.textLabel.text = LocalizedString(@"Default (%@)", [LocaleUtilities displayLanguage]);
  } else {
    NSInteger index = indexPath.row - 1;
    NSString* language = [languageCodes objectAtIndex:index];
    
    cell.textLabel.text = language;
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

