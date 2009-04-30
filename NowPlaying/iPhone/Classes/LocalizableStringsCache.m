//
//  StringsCache.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 4/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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
LocalizedString
        [[OperationQueue operationQueue] performSelector:@selector(updateBackgroundEntryPoint)
                                                onTarget:self
                                                    gate:nil
                                                priority:Priority];
    }

    return self;
}


+ (LocalizableStringsCache*) cache {
    if (instance == nil) {
        instance = [[LocalizableStringsCache alloc] init];
    }
LocalizedString
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


- (void) updateBackgroundEntryPointWorker {
    NSString* address = [NSString stringWithFormat:@"http://%@.appspot.com/LookupLocalizableStrings?id=%@&language=%@",
                         [Application host],
                         [[NSBundle mainBundle] bundleIdentifier],
                         [LocaleUtilities preferredLanguage]];
    NSString* hashAddress = [address stringByAppendingString:@"&hash=true"];
LocalizedString
    NSString* localHash = [FileUtilities readObject:self.hashFile];
    NSString* serverHash = [NetworkUtilities stringWithContentsOfAddress:hashAddress];
    if (serverHash.length > 0 && [localeHash isEqual:localHash]) {
        return;
    }

    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:address]];
    if (dict.count <= 0) {
        return;
    }
LocalizedString
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
LocalizedString
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
LocalizedString
    return result;
}


- (NSDictionary*) indexNoLock {
    if (indexData == nil) {
        self.indexData = [self loadIndex];
    }
LocalizedString
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
LocalizedString
    return [[NSBundle mainBundle] localizedStringForKey:key value:key table:nil];
}


+ (NSString*) localizedString:(NSString*) key {
    return [[LocalizableStringsCache cache] localizedString:key];
}

@end