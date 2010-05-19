// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "LocalizableStringsCache.h"

#import "Application.h"

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
  NSString* address = [NSString stringWithFormat:@"http://%@.appspot.com/LookupLocalizableStrings%@?id=%@&language=%@",
                       [Application apiHost], [Application apiVersion],
                       [[NSBundle mainBundle] bundleIdentifier],
                       [LocaleUtilities preferredLanguage]];
  NSString* hashAddress = [address stringByAppendingString:@"&hash=true"];

  NSString* localHash = [FileUtilities readObject:[self hashFile]];
  NSString* serverHash = [NetworkUtilities stringWithContentsOfAddress:hashAddress pause:NO];
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

  return NSLocalizedString(key, nil);
//  return [[NSBundle mainBundle] localizedStringForKey:key value:key table:nil];
}

@end
