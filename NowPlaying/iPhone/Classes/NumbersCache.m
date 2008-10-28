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

#if 0
#import "NumbersCache.h"

#import "Application.h"
#import "FileUtilities.h"
#import "MovieNumbers.h"
#import "NetworkUtilities.h"
#import "ThreadingUtilities.h"
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


- (NSString*) indexFile {
    return [[Application numbersFolder] stringByAppendingPathComponent:@"Index.plist"];
}


- (NSDictionary*) loadIndex {
    NSDictionary* encoded = [FileUtilities readObject:self.indexFile];
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
    [ThreadingUtilities performSelector:@selector(updateIndexBackgroundEntryPoint)
                               onTarget:self
               inBackgroundWithArgument:nil
                                   gate:gate
                                visible:YES];
}


- (void) updateDetails {
    if (indexData != nil) {
        [ThreadingUtilities performSelector:@selector(updateDetailsBackgroundEntryPoint:)
                                   onTarget:self
                   inBackgroundWithArgument:indexData
                                       gate:gate
                                    visible:NO];
    }
}


- (NSArray*) encodeArray:(NSArray*) array {
    NSMutableArray* result = [NSMutableArray array];
    for (MovieNumbers* stats in array) {
        [result addObject:stats.dictionary];
    }
    return result;
}


- (void) writeFile:(NSString*) file
           weekend:(NSArray*) weekend
             daily:(NSArray*) daily
            budget:(NSString*) budget{
    NSArray* encodedWeekend = [self encodeArray:weekend];
    NSArray* encodedDaily = [self encodeArray:daily];

    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:encodedWeekend forKey:@"Weekend"];
    [dictionary setObject:encodedDaily forKey:@"Daily"];
    [dictionary setObject:budget forKey:@"Budget"];

    [FileUtilities writeObject:dictionary toFile:file];
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
    NSDate* lastLookupDate = [FileUtilities modificationDate:self.indexFile];

    if (lastLookupDate != nil) {
        if (ABS(lastLookupDate.timeIntervalSinceNow) < ONE_DAY) {
            return;
        }
    }

    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupNumbersListings?q=index", [Application host]];
    XmlElement* result = [NetworkUtilities xmlWithContentsOfAddress:url important:NO];

    if (result == nil) {
        return;
    }

    NSArray* weekendNumbers = [self processNumbers:[result element:@"weekend"]];
    NSArray* dailyNumbers = [self processNumbers:[result element:@"daily"]];

    if (weekendNumbers.count && dailyNumbers.count) {
        [self writeFile:self.indexFile weekend:weekendNumbers daily:dailyNumbers budget:@""];

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
    [self updateIndexBackgroundWorker];
    [self performSelectorOnMainThread:@selector(updateDetails) withObject:nil waitUntilDone:NO];
}


- (NSString*) movieDetailsFile:(MovieNumbers*) numbers {
    NSString* name = [[FileUtilities sanitizeFileName:numbers.canonicalTitle] stringByAppendingPathExtension:@"plist"];
    return [[Application numbersDetailsFolder] stringByAppendingPathComponent:name];
}


- (void) downloadDetails:(MovieNumbers*) numbers {
    NSString* file = [self movieDetailsFile:numbers];
    NSDate* lastLookupDate = [FileUtilities modificationDate:file];

    if (lastLookupDate != nil) {
        if (ABS(lastLookupDate.timeIntervalSinceNow) < ONE_DAY) {
            return;
        }
    }

    if (numbers.identifier.length == 0 ||
        [@"0" isEqual:numbers.identifier]) {
        return;
    }

    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupNumbersListings?id=%@", [Application host], numbers.identifier];
    XmlElement* result = [NetworkUtilities xmlWithContentsOfAddress:url important:NO];

    if (result == nil) {
        return;
    }

    NSString* budget = [result attributeValue:@"budget"];
    NSArray* weekendNumbers = [self processNumbers:[result element:@"weekend"]];
    NSArray* dailyNumbers = [self processNumbers:[result element:@"daily"]];

    if (weekendNumbers.count || dailyNumbers.count) {
        [self writeFile:file weekend:weekendNumbers daily:dailyNumbers budget:budget];
    }
}


- (void) updateDetailsBackgroundEntryPoint:(NSDictionary*) numbers {
    for (MovieNumbers* movie in [numbers objectForKey:@"Weekend"]) {
        NSAutoreleasePool* autoreleasePool = [[NSAutoreleasePool alloc] init];
        {
            [self downloadDetails:movie];
        }
        [autoreleasePool release];
    }
}


- (double) change:(NSInteger) current previous:(NSInteger) previous {
    if (previous == 0) {
        return NOT_ENOUGH_DATA;
    }

    return ((double)current / (double)previous) - 1;
}


- (double) totalChangeValue:(NSArray*) values {
    if (values == nil) {
        return RETRIEVING;
    }

    if (values.count != 2) {
        return NOT_ENOUGH_DATA;
    }

    MovieNumbers* previous = [MovieNumbers numbersWithDictionary:[values objectAtIndex:0]];
    MovieNumbers* current = [MovieNumbers numbersWithDictionary:[values objectAtIndex:1]];

    return [self change:current.totalGross previous:previous.totalGross];
}


- (double) currentChangeValue:(NSArray*) values {
    if (values == nil) {
        return RETRIEVING;
    }

    if (values.count != 2) {
        return NOT_ENOUGH_DATA;
    }

    MovieNumbers* previous = [MovieNumbers numbersWithDictionary:[values objectAtIndex:0]];
    MovieNumbers* current = [MovieNumbers numbersWithDictionary:[values objectAtIndex:1]];

    return [self change:current.currentGross previous:previous.currentGross];
}


- (double) dailyChange:(MovieNumbers*) movie {
    NSDictionary* dictionary = [FileUtilities readObject:[self movieDetailsFile:movie]];

    return [self currentChangeValue:[dictionary objectForKey:@"Daily"]];
}


- (double) weekendChange:(MovieNumbers*) movie {
    NSDictionary* dictionary = [FileUtilities readObject:[self movieDetailsFile:movie]];

    return [self currentChangeValue:[dictionary objectForKey:@"Weekend"]];
}


- (double) totalChange:(MovieNumbers*) movie {
    NSDictionary* dictionary = [FileUtilities readObject:[self movieDetailsFile:movie]];

    double result = [self totalChangeValue:[dictionary objectForKey:@"Weekend"]];
    if (IS_NOT_ENOUGH_DATA(result) || IS_RETRIEVING(result)) {
        result = [self totalChangeValue:[dictionary objectForKey:@"Daily"]];
    }

    return result;
}


- (NSInteger) budgetForMovie:(MovieNumbers*) movie {
    NSDictionary* dictionary = [FileUtilities readObject:[self movieDetailsFile:movie]];
    if (dictionary == nil) {
        return -1;
    }

    return [[dictionary objectForKey:@"Budget"] intValue];
}

@end

#endif