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
#import "FileUtilities.h"
#import "LocaleUtilities.h"
#import "NetworkUtilities.h"
#import "NotificationCenter.h"
#import "OperationQueue.h"

@interface LocalizableStringsCache()
@property (retain) NSLock* gate;
@property (retain) NSDictionary* indexData;
@end

@implementation LocalizableStringsCache

@synthesize gate;
@synthesize indexData;

static LocalizableStringsCache* instance = nil;

- (void) dealloc {
    self.gate = nil;
    self.indexData = nil;
    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.gate = [[[NSLock alloc] init] autorelease];
    }

    return self;
}


+ (LocalizableStringsCache*) cache {
    if (instance == nil) {
        instance = [[LocalizableStringsCache alloc] init];
    }

    return instance;
}


- (NSString*) hashFile {
    NSString* name = [NSString stringWithFormat:@"%@-hash.plist", [LocaleUtilities preferredLanguage]];
    return [[Application localizableStringsDirectory] stringByAppendingPathComponent:name];
}


- (NSString*) indexFile {
    NSString* name = [NSString stringWithFormat:@"%@.plist", [LocaleUtilities preferredLanguage]];
    return [[Application localizableStringsDirectory] stringByAppendingPathComponent:name];
}


- (void) update {
    if (updated) {
        return;
    }
    updated = YES;

    [[OperationQueue operationQueue] performSelector:@selector(updateBackgroundEntryPoint)
                                            onTarget:self
                                                gate:nil
                                            priority:Priority];
}


+ (void) update {
    [[LocalizableStringsCache cache] update];
}


- (void) updateBackgroundEntryPointWorker {
    NSString* address = [NSString stringWithFormat:@"http://%@.appspot.com/LookupLocalizableStrings?id=%@&language=%@",
                         [Application host],
                         [[NSBundle mainBundle] bundleIdentifier],
                         [LocaleUtilities preferredLanguage]];
    NSString* hashAddress = [address stringByAppendingString:@"&hash=true"];

    NSString* localHash = [FileUtilities readObject:self.hashFile];
    NSString* serverHash = [NetworkUtilities stringWithContentsOfAddress:hashAddress];
    if (serverHash.length > 0 && [serverHash isEqual:localHash]) {
        return;
    }

    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:address]];
    if (dict.count <= 0) {
        return;
    }

    [FileUtilities writeObject:dict toFile:self.indexFile];
    [FileUtilities writeObject:serverHash toFile:self.hashFile];
    [gate lock];
    {
        self.indexData = dict;
    }
    [gate unlock];
}


- (void) updateBackgroundEntryPoint {
    NSDate* modificationDate = [FileUtilities modificationDate:self.hashFile];
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


- (NSDictionary*) loadIndex {
    NSDictionary* result = [FileUtilities readObject:self.indexFile];
    if (result.count == 0) {
        return [NSDictionary dictionary];
    }

    return result;
}


- (NSDictionary*) indexNoLock {
    if (indexData == nil) {
        self.indexData = [self loadIndex];
    }

    // access through pointer so we always get value value back.
    return self.indexData;
}


- (NSDictionary*) index {
    NSDictionary* result;
    [gate lock];
    {
        result = [self indexNoLock];
    }
    [gate unlock];
    return result;
}


- (NSString*) localizedString:(NSString*) key {
    NSString* result = [self.index objectForKey:key];
    if (result.length > 0) {
        return result;
    }

    return [[NSBundle mainBundle] localizedStringForKey:key value:key table:nil];
}


+ (NSString*) localizedString:(NSString*) key {
    return [[LocalizableStringsCache cache] localizedString:key];
}

@end