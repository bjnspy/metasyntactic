// Copyright (C) 2008 Cyrus Najmabadi
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

#import "NumbersCache.h"

#import "Application.h"
#import "MovieNumbers.h"
#import "Utilities.h"
#import "XmlElement.h"

@implementation NumbersCache

@synthesize gate;
@synthesize indexData;

- (void) dealloc {
    self.gate = nil;
    self.indexData = nil;
    
    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.gate = [[[NSRecursiveLock alloc] init] autorelease];
    }
    
    return self;
}


+ (NumbersCache*) cache {
    return [[[NumbersCache alloc] init] autorelease];
}


- (NSArray*) decodeNumbers:(NSArray*) array {
    NSMutableArray* result = [NSMutableArray array];
    for (NSDictionary* dictionary in array) {
        [result addObject:[MovieNumbers numbersWithDictionary:dictionary]];
    }
    return result;
}


- (NSDictionary*) loadIndex {
    NSDictionary* encoded = [NSDictionary dictionaryWithContentsOfFile:[Application numbersIndexFile]];
    if (encoded == nil) {
        return [NSDictionary dictionary];
    }

    NSArray* weekend = [self decodeNumbers:[encoded objectForKey:@"Weekend"]];
    NSArray* daily = [self decodeNumbers:[encoded objectForKey:@"Daily"]];
    
    NSMutableDictionary* result = [NSMutableDictionary dictionary];    
    [result setObject:weekend forKey:@"Weekend"];  
    [result setObject:daily forKey:@"Daily"];
    return result;
}


- (NSDictionary*) index {
    if (indexData == nil) {
        self.indexData = [self loadIndex];
    }
    
    return indexData;
}


- (NSArray*) dailyNumbers {
    NSArray* numbers = [self.index objectForKey:@"Daily"];
    if (numbers == nil) {
        return [NSArray array];
    }
    return numbers;
}


- (NSArray*) weekendNumbers {
    NSArray* numbers = [self.index objectForKey:@"Weekend"];
    if (numbers == nil) {
        return [NSArray array];
    }
    return numbers;
}


- (void) updateIndex {
    [self performSelectorInBackground:@selector(updateIndexBackgroundEntryPoint) withObject:nil];
}


- (void) updateDetails {
    if (indexData != nil) {
        [self performSelectorInBackground:@selector(updateDetailsBackgroundEntryPoint:) withObject:indexData];
    }
}


- (NSArray*) encodeArray:(NSArray*) array {
    NSMutableArray* result = [NSMutableArray array];
    for (MovieNumbers* stats in array) {
        [result addObject:stats.dictionary];
    }
    return result;
}


- (void) writeFile:(NSArray*) weekendNumbers daily:(NSArray*) dailyNumbers {
    NSArray* weekend = [self encodeArray:weekendNumbers];
    NSArray* daily = [self encodeArray:dailyNumbers];
    
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:weekend forKey:@"Weekend"];
    [dictionary setObject:daily forKey:@"Daily"]; 
    
    [Utilities writeObject:dictionary toFile:[Application numbersIndexFile]];
}


- (MovieNumbers*) processMovieElement:(XmlElement*) movieElement {
    return [MovieNumbers numbersWithIdentifier:[movieElement attributeValue:@"id"]
                                         title:[movieElement attributeValue:@"title"]
                                   currentRank:[[movieElement attributeValue:@"current_rank"] intValue]
                                  previousRank:[[movieElement attributeValue:@"previous_rank"] intValue]
                                  currentGross:[[movieElement attributeValue:@"revenue"] intValue]
                                    totalGross:[[movieElement attributeValue:@"total_revenue"] intValue]
                                      theaters:[[movieElement attributeValue:@"theaters"] intValue] 
                                          days:[[movieElement attributeValue:@"days"] intValue]];
    
}


- (NSArray*) processNumbers:(XmlElement*) element {
    NSMutableArray* result = [NSMutableArray array];
    for (XmlElement* movieElement in element.children) {
        [result addObject:[self processMovieElement:movieElement]];
    }
    return result;
}


- (void) updateIndexBackgroundWorker {
    NSDate* lastLookupDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:[Application numbersIndexFile]
                                                                               error:NULL] objectForKey:NSFileModificationDate];
    
    if (lastLookupDate != nil) {
        if (ABS(lastLookupDate.timeIntervalSinceNow) < (24 * 60 * 60)) {
            return;
        }
    }
    
    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupNumbersListings?q=index", [Application host]];
    XmlElement* result = [Utilities downloadXml:url];

    if (result == nil) {
        return;
    }
    
    NSArray* weekendNumbers = [self processNumbers:[result element:@"weekend"]];
    NSArray* dailyNumbers = [self processNumbers:[result element:@"daily"]];
    
    if (weekendNumbers.count && dailyNumbers.count) {
        [self writeFile:weekendNumbers daily:dailyNumbers];
        
        NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:weekendNumbers forKey:@"Weekend"];
        [dictionary setObject:dailyNumbers forKey:@"Daily"];
        
        [self performSelectorOnMainThread:@selector(reportResults:) withObject:dictionary waitUntilDone:NO];
    }
}


- (void) reportResults:(NSDictionary*) results {
    self.indexData = results;
}


- (void) updateIndexBackgroundEntryPoint {
    NSAutoreleasePool* autoreleasePool = [[NSAutoreleasePool alloc] init];
    [gate lock];
    {
        [NSThread setThreadPriority:0.0];
        [self updateIndexBackgroundWorker];    
        [self performSelectorOnMainThread:@selector(updateIndexBackgroundWorker) withObject:nil waitUntilDone:NO];
    }
    [gate unlock];
    [autoreleasePool release];    
}


- (void) updateDetailsBackgroundWorker:(NSDictionary*) numbers {
}


- (void) updateDetailsBackgroundEntryPoint:(NSDictionary*) numbers {
    NSAutoreleasePool* autoreleasePool = [[NSAutoreleasePool alloc] init];
    [gate lock];
    {
        [NSThread setThreadPriority:0.0];
        [self updateDetailsBackgroundWorker:numbers];    
    }
    [gate unlock];
    [autoreleasePool release];    
}


@end