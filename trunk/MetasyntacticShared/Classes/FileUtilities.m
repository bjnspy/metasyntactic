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

#import "FileUtilities.h"

#import "MainThreadGate.h"

@implementation FileUtilities

static MainThreadGate* gate = nil;

+ (void) initialize {
  if (self == [FileUtilities class]) {
    gate = [[MainThreadGate gate] retain];
  }
}


// NSFileManager instances are not threadsafe.  So anyone who wants one should
// create a new instance that they can use.
+ (NSFileManager*) localFileManager {
  static NSString* key = @"FileManager";

  NSMutableDictionary* threadDictionary = [[NSThread currentThread] threadDictionary];

  NSFileManager* manager = [threadDictionary objectForKey:key];
  if (manager == nil) {
    manager = [[[NSFileManager alloc] init] autorelease];
    [threadDictionary setObject:manager forKey:key];
  }
  return manager;
}


+ (void) createDirectory:(NSString*) directory {
  [gate lock];
  {
    NSFileManager* fileManager = [self localFileManager];
    if (![fileManager fileExistsAtPath:directory]) {
      [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
  }
  [gate unlock];
}


+ (NSDate*) modificationDate:(NSString*) file {
  NSDate* result;
  [gate lock];
  {
    result = [[[self localFileManager] attributesOfItemAtPath:file
                                                        error:NULL] objectForKey:NSFileModificationDate];
  }
  [gate unlock];
  return result;
}


+ (unsigned long long) size:(NSString*) file {
  unsigned long long result;
  [gate lock];
  {
    NSNumber* number = [[[self localFileManager] attributesOfItemAtPath:file
                                                                  error:NULL] objectForKey:NSFileSize];
    result = [number unsignedLongLongValue];
  }
  [gate unlock];
  return result;
}


+ (NSDictionary*) attributesOfItemAtPath:(NSString*) path {
  NSDictionary* result;
  [gate lock];
  {
    result = [[self localFileManager] attributesOfItemAtPath:path error:NULL];
  }
  [gate unlock];
  return result;
}


+ (NSArray*) directoryContentsNames:(NSString*) directory {
  NSArray* result;
  [gate lock];
  {
    NSError* error = nil;
    result = [[self localFileManager] contentsOfDirectoryAtPath:directory error:&error];
  }
  [gate unlock];
  return result;
}


+ (NSArray*) directoryContentsPaths:(NSString*) directory {
  NSMutableArray* result = [NSMutableArray array];
  [gate lock];
  {
    NSError* error = nil;
    NSArray* names = [[self localFileManager] contentsOfDirectoryAtPath:directory error:&error];
    for (NSString* name in names) {
      [result addObject:[directory stringByAppendingPathComponent:name]];
    }
  }
  [gate unlock];
  return result;
}


+ (BOOL) fileExists:(NSString*) path {
  BOOL result;
  [gate lock];
  {
    result = [[self localFileManager] fileExistsAtPath:path];
  }
  [gate unlock];
  return result;
}


+ (void) moveItem:(NSString*) from to:(NSString*) to {
  [gate lock];
  {
    [[self localFileManager] moveItemAtPath:from toPath:to error:NULL];
  }
  [gate unlock];
}


+ (NSString*) sanitizeFileName:(NSString*) name {
  return [[name stringByReplacingOccurrencesOfString:@"/" withString:@"-slash-"]
          stringByReplacingOccurrencesOfString:@":" withString:@"-colon-"];
}


+ (void) writeObject:(id) object toFile:(NSString*) file {
  [gate lock];
  {
    NSData* plistData = [NSPropertyListSerialization dataFromPropertyList:object
                                                                   format:NSPropertyListBinaryFormat_v1_0
                                                         errorDescription:NULL];

    if (plistData != nil) {
      [plistData writeToFile:file atomically:YES];
    } if (object == nil) {
      [[self localFileManager] removeItemAtPath:file error:NULL];
    }
  }
  [gate unlock];
}


+ (id) readObject:(NSString*) file {
  if (file == nil) {
    return nil;
  }

  id result = nil;
  [gate lock];
  {
    NSData* data = [NSData dataWithContentsOfFile:file];
    if (data != nil) {
      result = [NSPropertyListSerialization propertyListFromData:data
                                                mutabilityOption:NSPropertyListImmutable
                                                          format:NULL
                                                errorDescription:NULL];
    }
  }
  [gate unlock];
  return result;
}


+ (void) writeData:(NSData*) data toFile:(NSString*) file {
  [gate lock];
  {
    [data writeToFile:file atomically:YES];
  }
  [gate unlock];
}


+ (NSData*) readData:(NSString*) file {
  if (file == nil) {
    return nil;
  }

  NSData* result = nil;
  [gate lock];
  {
    result = [NSData dataWithContentsOfFile:file];
  }
  [gate unlock];
  return result;
}


+ (BOOL) isDirectory:(NSString*) path {
  BOOL result;

  [gate lock];
  {
    [[self localFileManager] fileExistsAtPath:path isDirectory:&result];
  }
  [gate unlock];

  return result;
}

@end
