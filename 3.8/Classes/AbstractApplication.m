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

#import "AbstractApplication.h"

#import "FileUtilities.h"
#import "LocaleUtilities.h"
#import "StringUtilities.h"
#import "ThreadingUtilities.h"

@implementation AbstractApplication

static NSLock* gate = nil;

// Special directories
static NSString* cacheDirectory = nil;
static NSString* supportDirectory = nil;
static NSString* tempDirectory = nil;
static NSString* trashDirectory = nil;
static NSCondition* emptyTrashCondition = nil;


+ (NSString*) name {
  return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}


+ (NSString*) version {
  return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}


+ (NSString*) nameAndVersion {
  NSString* appName = [self name];
  NSString* appVersion = [self version];

  return [NSString stringWithFormat:@"%@ v%@", appName, appVersion];
}


+ (void) emptyTrash {
  [ThreadingUtilities backgroundSelector:@selector(emptyTrashBackgroundEntryPoint)
                                onTarget:self
                                    gate:nil
                                  daemon:YES];
}


+ (void) initializeDirectories {
  tempDirectory = [NSTemporaryDirectory() retain];

  {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, /*expandTilde:*/YES);
    NSString* executableName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
    NSString* directory = [[paths objectAtIndex:0] stringByAppendingPathComponent:executableName];
    [FileUtilities createDirectory:directory];
    cacheDirectory = [directory retain];
  }

  {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, /*expandTilde:*/YES);
    NSString* executableName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
    NSString* directory = [[paths objectAtIndex:0] stringByAppendingPathComponent:executableName];
    [FileUtilities createDirectory:directory];
    supportDirectory = [directory retain];
  }

  {
    NSString* directory = [cacheDirectory stringByAppendingPathComponent:@"Trash"];
    [FileUtilities createDirectory:directory];
    trashDirectory = [directory retain];
  }
}


+ (void) initialize {
  if (self == [AbstractApplication class]) {
    gate = [[NSRecursiveLock alloc] init];
    emptyTrashCondition = [[NSCondition alloc] init];

    [self initializeDirectories];
    [self emptyTrash];
  }
}


+ (NSLock*) gate {
  return gate;
}


+ (NSString*) cacheDirectory {
  return cacheDirectory;
}


+ (NSString*) supportDirectory {
  return supportDirectory;
}


+ (NSString*) trashDirectory {
  return trashDirectory;
}


+ (NSString*) tempDirectory {
  return tempDirectory;
}


+ (void) emptyTrashBackgroundEntryPointWorker {
  NSLog(@"Application:emptyTrashBackgroundEntryPoint - start");
  NSFileManager* manager = [NSFileManager defaultManager];
  NSDirectoryEnumerator* enumerator = [manager enumeratorAtPath:trashDirectory];

  {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSString* fileName;
    while ((fileName = [enumerator nextObject]) != nil) {
      NSString* fullPath = [trashDirectory stringByAppendingPathComponent:fileName];
      NSDictionary* attributes = [enumerator fileAttributes];

      // don't delete folders yet
      if (![[attributes objectForKey:NSFileType] isEqual:NSFileTypeDirectory]) {
        NSLog(@"Application:emptyTrashBackgroundEntryPoint - %@", fullPath.lastPathComponent);
        [manager removeItemAtPath:fullPath error:NULL];
      }

      [NSThread sleepForTimeInterval:1];

      [pool release];
      pool = [[NSAutoreleasePool alloc] init];
    }

    [pool release];
  }

  // Now remove the directories.
  for (NSString* fileName in [FileUtilities directoryContentsNames:trashDirectory]) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
      NSString* fullPath = [trashDirectory stringByAppendingPathComponent:fileName];

      [manager removeItemAtPath:fullPath error:NULL];
      [NSThread sleepForTimeInterval:1];
    }
    [pool release];
  }

  NSLog(@"Application:emptyTrashBackgroundEntryPoint - stop");
}


+ (void) emptyTrashBackgroundEntryPoint {
  while (YES) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
      [emptyTrashCondition lock];
      {
        while ([FileUtilities directoryContentsNames:[self trashDirectory]].count == 0) {
          [emptyTrashCondition wait];
        }
      }
      [emptyTrashCondition unlock];

      [self emptyTrashBackgroundEntryPointWorker];
    }
    [pool release];
  }
}


+ (void) clearStaleItem:(NSString*) fullPath
           inEnumerator:(NSDirectoryEnumerator*) enumerator
            withManager:(NSFileManager*) manager {
  if ((rand() % 1000) < 50) {
    NSDictionary* attributes = [enumerator fileAttributes];

    // don't delete folders
    if (![[attributes objectForKey:NSFileType] isEqual:NSFileTypeDirectory]) {
      NSDate* lastModifiedDate = [attributes objectForKey:NSFileModificationDate];
      if (lastModifiedDate != nil) {
        if (ABS(lastModifiedDate.timeIntervalSinceNow) > CACHE_LIMIT) {
          NSLog(@"Application:clearStaleDataBackgroundEntryPoint - %@", fullPath.lastPathComponent);
          [manager removeItemAtPath:fullPath error:NULL];
        }
      }
    }
  }
}


+ (NSArray*) directoriesToKeep {
  @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


+ (void) clearStaleDataBackgroundEntryPoint {
  NSLog(@"Application:clearStaleDataBackgroundEntryPoint - start");
  NSFileManager* manager = [NSFileManager defaultManager];
  NSDirectoryEnumerator* enumerator = [manager enumeratorAtPath:cacheDirectory];
  NSArray* directoriesToKeep = [self directoriesToKeep];

  NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
  NSString* fileName;
  while ((fileName = [enumerator nextObject]) != nil) {
    NSString* fullPath = [cacheDirectory stringByAppendingPathComponent:fileName];
    if ([directoriesToKeep containsObject:fullPath]) {
      [enumerator skipDescendents];
    } else {
      [self clearStaleItem:fullPath inEnumerator:enumerator withManager:manager];
    }

    [pool release];
    pool = [[NSAutoreleasePool alloc] init];
  }
  [pool release];
  NSLog(@"Application:clearStaleDataBackgroundEntryPoint - stop");
}


+ (void) clearStaleData {
  [ThreadingUtilities backgroundSelector:@selector(clearStaleDataBackgroundEntryPoint)
                                onTarget:self
                                    gate:nil
                                  daemon:YES];
}


+ (void) moveItemToTrash:(NSString*) path {
  [gate lock];
  {
    NSString* trashPath = [self uniqueTrashDirectory];
    [[NSFileManager defaultManager] moveItemAtPath:path toPath:trashPath error:NULL];

    // safeguard, just in case.
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
  }
  [gate unlock];

  [emptyTrashCondition lock];
  {
    [emptyTrashCondition broadcast];
  }
  [emptyTrashCondition unlock];
}


+ (NSString*) randomString {
  NSMutableString* string = [NSMutableString string];
  for (int i = 0; i < 8; i++) {
    [string appendFormat:@"%c", ((rand() % 26) + 'a')];
  }
  return string;
}


+ (NSString*) uniqueDirectory:(NSString*) parentDirectory
                       create:(BOOL) create {
  NSString* finalDir;

  [gate lock];
  {
    do {
      NSString* random = [self randomString];
      finalDir = [parentDirectory stringByAppendingPathComponent:random];
    } while ([[NSFileManager defaultManager] fileExistsAtPath:finalDir]);

    if (create) {
      [FileUtilities createDirectory:finalDir];
    }
  }
  [gate unlock];

  return finalDir;
}


+ (NSString*) uniqueTemporaryDirectory {
  return [self uniqueDirectory:[self tempDirectory] create:YES];
}


+ (NSString*) uniqueTrashDirectory {
  return [self uniqueDirectory:[self trashDirectory] create:NO];
}


+ (void) openBrowser:(NSString*) address {
  if (address.length == 0) {
    return;
  }

  NSURL* url = [NSURL URLWithString:address];
  [[UIApplication sharedApplication] openURL:url];
}


+ (void) openMap:(NSString*) address {
  [self openBrowser:address];
}


+ (BOOL) isIPhone {
  return [[[UIDevice currentDevice] model] isEqual:@"iPhone"];
}


+ (void) makeCall:(NSString*) phoneNumber {
  if (![self isIPhone]) {
    return;
  }

  NSRange xRange = [phoneNumber rangeOfString:@"x"];
  if (xRange.length > 0 && xRange.location >= 12) {
    // 222-222-2222 x222
    // remove extension
    phoneNumber = [phoneNumber substringToIndex:xRange.location];
  }

  NSString* urlString = [NSString stringWithFormat:@"tel:%@", [StringUtilities stringByAddingPercentEscapes:phoneNumber]];

  [self openBrowser:urlString];
}


+ (BOOL) useKilometers {
  // yeah... so the UK supposedly uses metric...
  // except they don't. so we special case them to stick with 'miles' in the UI.
  BOOL isMetric = [[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue];
  BOOL isUK = [@"GB" isEqual:[LocaleUtilities isoCountry]];

  return isMetric && !isUK;
}


+ (BOOL) canSendMail {
  return [MFMailComposeViewController canSendMail];
}

@end
