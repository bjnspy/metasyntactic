//
//  InternationalViewController.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 5/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InternationalViewController.h"

#import "LanguageViewController.h"
#import "LocaleUtilities.h"
#import "MetasyntacticSharedApplication.h"

@interface InternationalViewController()
@property (retain) NSArray* languages;
@end

@implementation InternationalViewController

@synthesize languages;

- (void) dealloc {
  self.languages = nil;
  [super dealloc];
}


static NSInteger compareLanguageCodes(id lang1, id lang2, void* context) {
  NSLocale* locale1 = [[[NSLocale alloc] initWithLocaleIdentifier:lang1] autorelease];
  NSLocale* locale2 = [[[NSLocale alloc] initWithLocaleIdentifier:lang2] autorelease];
  
  NSString* display1 = [locale1 displayNameForKey:NSLocaleLanguageCode value:lang1];
  NSString* display2 = [locale2 displayNameForKey:NSLocaleLanguageCode value:lang2];
  
  return [display1 compare:display2];
}


//static NSInteger compareCountryCodes(id code1, id code2, void* context) {
//  NSString* countryCode1 = code1;
//  NSString* countryCode2 = code2;
//  
//  NSLocale* locale = context;
//  NSString* display1 = [locale displayNameForKey:NSLocaleCountryCode value:countryCode1];
//  NSString* display2 = [locale displayNameForKey:NSLocaleCountryCode value:countryCode2];
//  
//  return [display1 compare:display2];
//}


- (void) initializeData {
  NSLog(@"%@", [[NSBundle mainBundle] localizations]);
  
  NSMutableSet* set = [NSMutableSet set];
  for (NSString* localIdentifier in [NSLocale availableLocaleIdentifiers]) {
    NSRange underscoreRange = [localIdentifier rangeOfString:@"_"];
    
    NSString* language = nil;
    
    if (underscoreRange.length == 0) {
      language = localIdentifier;
    } else {
      language = [localIdentifier substringToIndex:underscoreRange.location];
      
      NSString* country = [localIdentifier substringFromIndex:underscoreRange.location + 1];
      underscoreRange = [country rangeOfString:@"_"];
      if (underscoreRange.length > 0) {
        continue;
      }
    }
    
    [set addObject:language];
  }
  
  self.languages = [[set allObjects] sortedArrayUsingFunction:compareLanguageCodes context:NULL];
}


- (id) init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    [self initializeData];
  }
  return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return languages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString* reuseIdentifier = @"reuseIdentifier";
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
  }
  
  NSString* languageCode = [languages objectAtIndex:indexPath.row];
  NSLocale* locale = [[[NSLocale alloc] initWithLocaleIdentifier:languageCode] autorelease];
  
  NSString* displayLanguage = [locale displayNameForKey:NSLocaleLanguageCode value:languageCode];
  cell.textLabel.text = displayLanguage;
  
  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    UIViewController* controller = [[[LanguageViewController alloc] init] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
  } else {
    UIViewController* controller = [[[LanguageViewController alloc] init] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
  }
}

/*
@synthesize languageToCountries;

- (void)dealloc {
  self.languages = nil;
  self.languageToCountries = nil;
  [super dealloc];
}

static NSInteger compareLanguageCodes(id lang1, id lang2, void* context) {
  NSLocale* locale1 = [[[NSLocale alloc] initWithLocaleIdentifier:lang1] autorelease];
  NSLocale* locale2 = [[[NSLocale alloc] initWithLocaleIdentifier:lang2] autorelease];

  NSString* display1 = [locale1 displayNameForKey:NSLocaleLanguageCode value:lang1];
  NSString* display2 = [locale2 displayNameForKey:NSLocaleLanguageCode value:lang2];
  
  return [display1 compare:display2];
}


static NSInteger compareCountryCodes(id code1, id code2, void* context) {
  NSString* countryCode1 = code1;
  NSString* countryCode2 = code2;
  
  NSLocale* locale = context;
  NSString* display1 = [locale displayNameForKey:NSLocaleCountryCode value:countryCode1];
  NSString* display2 = [locale displayNameForKey:NSLocaleCountryCode value:countryCode2];

  return [display1 compare:display2];
}


- (void) initializeData {
  NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
  for (NSString* localIdentifier in [NSLocale availableLocaleIdentifiers]) {
    NSRange underscoreRange = [localIdentifier rangeOfString:@"_"];
    
    NSString* language = nil;
    NSString* country = nil;
    
    if (underscoreRange.length == 0) {
      language = localIdentifier;
    } else {
      language = [localIdentifier substringToIndex:underscoreRange.location];
      country = [localIdentifier substringFromIndex:underscoreRange.location + 1];
      underscoreRange = [country rangeOfString:@"_"];
      if (underscoreRange.length > 0) {
        continue;
      }
    }
    
    NSMutableArray* array = [dictionary objectForKey:language];
    if (array == nil) {
      array = [NSMutableArray array];
      [dictionary setObject:array forKey:language];
    }
    
    if (country != nil) {
      [array addObject:country];
    }
  }
  
  for (NSString* language in dictionary) {
    NSMutableArray* array = [dictionary objectForKey:language];
    NSLocale* locale = [[[NSLocale alloc] initWithLocaleIdentifier:language] autorelease];

    [array sortUsingFunction:compareCountryCodes context:locale];
  }
  
  self.languages = [[dictionary allKeys] sortedArrayUsingFunction:compareLanguageCodes context:NULL];
  self.languageToCountries = dictionary;
}


- (id) init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    [self initializeData];
  }
  return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return languages.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSString* language = [languages objectAtIndex:section];
  
  return [[languageToCountries objectForKey:language] count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString* reuseIdentifier = @"reuseIdentifier";
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
  }
            
  NSString* languageCode = [languages objectAtIndex:indexPath.section];
  NSLocale* locale = [[[NSLocale alloc] initWithLocaleIdentifier:languageCode] autorelease];
  
  if (indexPath.row == 0) {
    NSString* displayLanguage = [locale displayNameForKey:NSLocaleLanguageCode value:languageCode];
    
    cell.textLabel.text = displayLanguage;
    cell.indentationLevel = 0;
  } else {
    NSString* countryCode = [[languageToCountries objectForKey:languageCode] objectAtIndex:indexPath.row - 1];
    NSString* displayCountry = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
    
    cell.textLabel.text = displayCountry;
    cell.indentationLevel = 1;
  }
  
  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    UIViewController* controller = [[[LanguageViewController alloc] init] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
  } else {
    UIViewController* controller = [[[LanguageViewController alloc] init] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
  }
}
*/

@end

