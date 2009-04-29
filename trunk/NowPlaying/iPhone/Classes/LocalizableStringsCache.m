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
#import "OperationQueue.h"

@interface LocalizableStringsCache()
@property (retain) NSDictionary* indexData;
@end

@implementation LocalizableStringsCache

@synthesize indexData;

- (void) dealloc {
    self.indexData = nil;
    [super dealloc];
}


+ (LocalizableStringsCache*) cache {
    return [[[LocalizableStringsCache alloc] init] autorelease];
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


- (NSString*) hashFile {
    NSString* language = [LocaleUtilities isoLanguage];
    NSString* name = [NSString stringWithFormat:@"%@-hash.plist", language];
    return [[Application localizableStringsDirectory] stringByAppendingPathComponent:name];
}


- (NSString*) indexFile {
    NSString* language = [LocaleUtilities isoLanguage];
    NSString* name = [NSString stringWithFormat:@"%@.plist", language];
    return [[Application localizableStringsDirectory] stringByAppendingPathComponent:name];
}


- (void) updateBackgroundEntryPoint {
    NSString* hashFile = self.hashFile;
    NSDate* modificationDate = [FileUtilities modificationDate:hashFile];
    if (modificationDate != nil) {
        if (ABS(modificationDate.timeIntervalSinceNow) < ONE_WEEK) {
            return;
        }
    }

    NSString* address = [NSString stringWithFormat:@"http://%@.appspot.com/LookupLocalizableStrings?id=%@&language=%@",
                         [Application host],
                         [[NSBundle mainBundle] bundleIdentifier],
                         [LocaleUtilities isoLanguage]];
    NSString* hashAddress = [address stringByAppendingString:@"&hash=true"];
                         
    NSString* serverHash = [NetworkUtilities stringWithContentsOfAddress:hashAddress];
    if (serverHash.length > 0 && [address isEqual:serverHash]) {
        return;
    }

    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:address]];
    if (dict.count <= 0) {
        return;
    }
    
    [FileUtilities writeObject:dict toFile:self.indexFile];
    [FileUtilities writeObject:serverHash toFile:hashFile];
    [self performSelectorOnMainThread:@selector(reportResult:) withObject:dict waitUntilDone:NO];
}


- (void) reportResult:(NSDictionary*) dict {
    self.indexData = dict;
}


- (NSDictionary*) loadIndex {
    NSDictionary* result = [FileUtilities readObject:self.indexFile];
    if (result.count == 0) {
        return [NSDictionary dictionary];
    }
    
    return result;
}


- (NSDictionary*) index {
    if (indexData == nil) {
        self.indexData = [self loadIndex];
    }
    
    return self.indexData;
}


- (NSString*) localizedString:(NSString*) key {
    NSString* result = [self.index objectForKey:key];
    if (result.length > 0) {
        return result;
    }
    
    return [[NSBundle mainBundle] localizedStringForKey:key value:key table:nil];
}

@end
