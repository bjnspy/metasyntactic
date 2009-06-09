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

#import "LocalizableStringsCache.h"

#import "Application.h"

@interface LocalizableStringsCache()
@end

@implementation LocalizableStringsCache

static NSDictionary* stringsIndex = nil;
static BOOL updated = NO;

+ (NSString*) indexFile {
  NSString* name = [NSString stringWithFormat:@"%@.plist", [LocaleUtilities preferredLanguage]];
  return [[Application localizableStringsDirectory] stringByAppendingPathComponent:name];
}


+ (void) initialize {
  if (self == [LocalizableStringsCache class]) {
    stringsIndex = [[NSDictionary dictionaryWithContentsOfFile:[self indexFile]] retain];
    if (stringsIndex.count == 0) {
      stringsIndex = [[NSDictionary alloc] init];
    }
  }
}


+ (NSString*) hashFile {
  NSString* name = [NSString stringWithFormat:@"%@-hash.plist", [LocaleUtilities preferredLanguage]];
  return [[Application localizableStringsDirectory] stringByAppendingPathComponent:name];
}


+ (void) update {
  if (updated) {
    return;
  }
  updated = YES;
  
  [[OperationQueue operationQueue] performSelector:@selector(updateBackgroundEntryPoint)
                                          onTarget:self
                                              gate:nil
                                          priority:Priority];
}


+ (void) updateBackgroundEntryPointWorker {
  NSString* address = [NSString stringWithFormat:@"http://%@.appspot.com/LookupLocalizableStrings?id=%@&language=%@",
                       [Application host],
                       [[NSBundle mainBundle] bundleIdentifier],
                       [LocaleUtilities preferredLanguage]];
  NSString* hashAddress = [address stringByAppendingString:@"&hash=true"];
  
  NSString* localHash = [FileUtilities readObject:[self hashFile]];
  NSString* serverHash = [NetworkUtilities stringWithContentsOfAddress:hashAddress];
  if (serverHash.length > 0 && [serverHash isEqual:localHash]) {
    return;
  }
  
  NSDictionary* dict = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:address]];
  if (dict.count <= 0) {
    return;
  }
  
  [FileUtilities writeObject:dict toFile:[self indexFile]];
  [FileUtilities writeObject:serverHash toFile:[self hashFile]];
}


+ (void) updateBackgroundEntryPoint {
  NSDate* modificationDate = [FileUtilities modificationDate:[self hashFile]];
  if (modificationDate != nil) {
    if (ABS(modificationDate.timeIntervalSinceNow) < ONE_WEEK) {
      return;
    }
  }
  
  NSString* notification = [LocalizedString(@"Translations", nil) lowercaseString];
  [NotificationCenter addNotification:notification];
  {
    [self updateBackgroundEntryPointWorker];
  }
  [NotificationCenter removeNotification:notification];
}


+ (NSString*) localizedString:(NSString*) key {
  NSString* result = [stringsIndex objectForKey:key];
  if (result.length > 0) {
    return result;
  }
  
  return [[NSBundle mainBundle] localizedStringForKey:key value:key table:nil];
}

@end
