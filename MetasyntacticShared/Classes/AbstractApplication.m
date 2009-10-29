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

#include <sys/sysctl.h>

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
static NSString* dirtyFile = nil;
static BOOL shutdownCleanly = NO;


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

  {
    NSString* file = [supportDirectory stringByAppendingPathComponent:@"Dirty.plist"];
    dirtyFile = [file retain];
  }
}


+ (void) initialize {
  if (self == [AbstractApplication class]) {
    gate = [[NSRecursiveLock alloc] init];
    emptyTrashCondition = [[NSCondition alloc] init];

    [self initializeDirectories];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    shutdownCleanly = ![FileUtilities fileExists:dirtyFile];
    [FileUtilities writeObject:@"" toFile:dirtyFile];

    [self performSelector:@selector(emptyTrash) withObject:nil afterDelay:10];
  }
}


+ (void) onApplicationWillTerminate:(id) argument {
  [self moveItemToTrash:dirtyFile];
}


+ (BOOL) shutdownCleanly {
  return shutdownCleanly;
}


+ (void) emptyTrash {
  [ThreadingUtilities backgroundSelector:@selector(emptyTrashBackgroundEntryPoint)
                                onTarget:self
                                    gate:nil
                                  daemon:YES];
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
  NSFileManager* manager = [[[NSFileManager alloc] init] autorelease];
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
    NSFileManager* fileManager = [[[NSFileManager alloc] init] autorelease];
    NSString* trashPath = [self uniqueTrashDirectory];
    [fileManager moveItemAtPath:path toPath:trashPath error:NULL];

    // safeguard, just in case.
    [fileManager removeItemAtPath:path error:NULL];
  }
  [gate unlock];

  [emptyTrashCondition lock];
  {
    [emptyTrashCondition broadcast];
  }
  [emptyTrashCondition unlock];
}


+ (NSString*) uniqueDirectory:(NSString*) parentDirectory
                       create:(BOOL) create {
  NSString* finalDir;
  NSFileManager* fileManager = [[[NSFileManager alloc] init] autorelease];
  [gate lock];
  {
    do {
      NSString* random = [StringUtilities randomString:8];
      finalDir = [parentDirectory stringByAppendingPathComponent:random];
    } while ([fileManager fileExistsAtPath:finalDir]);

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
  UIDevice* device = [UIDevice currentDevice];
  return [[device model] isEqual:@"iPhone"];
}


+ (NSString*) hardware {
  size_t size;
  sysctlbyname("hw.machine", NULL, &size, NULL, 0);
  char* machine = malloc(size);
  sysctlbyname("hw.machine", machine, &size, NULL, 0);
  NSString* hardware = [NSString stringWithCString:machine encoding: NSUTF8StringEncoding];
  free(machine);
  return hardware;
}


+ (BOOL) isIPhone3G {
  if (![self isIPhone]) {
    return NO;
  }

  NSString* hardware = [self hardware];
  return [hardware hasPrefix:@"iPhone1"];
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


+ (UIBarStyle) barStyleFromString:(NSString*) string {
  if ([@"UIBarStyleBlack" isEqual:string]) {
    return UIBarStyleBlack;
  } else {
    return UIBarStyleDefault;
  }
}


+ (UIBarStyle) navigationBarStyle {
  return [self barStyleFromString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"UINavigationBarStyle"]];
}


+ (UIBarStyle) searchBarStyle {
  return [self barStyleFromString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"UISearchBarStyle"]];
}


+ (UIBarStyle) toolBarStyle {
  return [self barStyleFromString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIToolBarStyle"]];
}


+ (BOOL) toolBarTranslucent {
  return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIToolBarTranslucent"] boolValue];
}

@end
