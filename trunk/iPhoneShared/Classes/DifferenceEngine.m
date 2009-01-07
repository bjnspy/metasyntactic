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

#import "DifferenceEngine.h"

#define MaxLength 128

@implementation DifferenceEngine

+ (DifferenceEngine*) engine {
    return [[[DifferenceEngine alloc] init] autorelease];
}


- (id) initWithAddCost:(NSInteger) add
            deleteCost:(NSInteger) delete
            switchCost:(NSInteger) switch_
         transposeCost:(NSInteger) transpose {
    if (self = [super init]) {
        addCost = add;
        deleteCost = delete;
        switchCost = switch_;
        transposeCost = transpose;

        for (NSInteger i = 0; i < MaxLength; i++) {
            costTable[i][0] = (i * deleteCost);
            costTable[0][i] = (i * addCost);
        }
    }

    return self;
}


- (id) init {
    return [self initWithAddCost:1
                      deleteCost:1
                      switchCost:1
                   transposeCost:1];
}


- (BOOL) initializeFrom:(NSString*) S
                     to:(NSString*) T
          withThreshold:(NSInteger) threshold {
    if (S == nil || T == nil) {
        return NO;
    }

    cached_S_length = S.length;
    cached_T_length = T.length;

    if (cached_T_length > MaxLength || cached_S_length > MaxLength) {
        return NO;
    }

    costThreshold = threshold;

    if (costThreshold >= 0) {
        if (deleteCost > 0) {
            NSInteger minimumTLength = cached_S_length - (costThreshold * deleteCost);

            if (cached_T_length < minimumTLength) {
                return NO;
            }
        }

        if (addCost > 0) {
            NSInteger minimumSLength = cached_T_length - (costThreshold * addCost);

            if (cached_S_length < minimumSLength) {
                return NO;
            }
        }
    }

    return YES;
}


- (NSInteger) editDistanceFrom:(NSString*) from
                            to:(NSString*) to {
    return [self editDistanceFrom:from to:to withThreshold:-1];
}


- (NSInteger) editDistanceFrom:(NSString*) from
                            to:(NSString*) to
                 withThreshold:(NSInteger) threshold {
    if ([self initializeFrom:from to:to withThreshold:threshold] == NO) {
        return NSIntegerMax;
    }

    unichar S[MaxLength];
    unichar T[MaxLength];

    [from getCharacters:S];
    [to getCharacters:T];

    for (NSInteger i = 1; i < cached_S_length; i++) {
        BOOL rowIsUnderThreshold = (costThreshold < 0);

        for (NSInteger j = 1; j < cached_T_length; j++) {
            const NSInteger adds = 1;
            const NSInteger deletes = 1;
            NSInteger switches = (S[(i - 1)] == T[(j - 1)]) ? 0 : 1;

            NSInteger totalDeleteCost = costTable[i - 1][j] + (deletes * deleteCost);
            NSInteger totalAddCost = costTable[i][j - 1] + (adds * addCost);
            NSInteger totalSwitchCost = costTable[i - 1][j - 1] + (switches * switchCost);
            NSInteger cost = MIN(totalDeleteCost, MIN(totalAddCost, totalSwitchCost));

            if (i >= 2 && j >= 2) {
                NSInteger transposes = 1 + ((S[(i - 1)] == T[j]) ? 0 : 1) +
                ((S[i] == T[(j - 1)]) ? 0 : 1);
                NSInteger tCost = costTable[i - 2][j - 2] + (transposes * transposeCost);

                costTable[i][j] = MIN(cost, tCost);
            } else {
                costTable[i][j] = cost;
            }

            if (costThreshold >= 0) {
                rowIsUnderThreshold |= (cost <= costThreshold);
            }
        }

        if (!rowIsUnderThreshold) {
            return NSIntegerMax;
        }
    }

    NSInteger cost = costTable[cached_S_length - 1][cached_T_length - 1];

    if (cost > 1) {
        if ([from rangeOfString:to options:NSCaseInsensitiveSearch].location != NSNotFound ||
            [to rangeOfString:from options:NSCaseInsensitiveSearch].location != NSNotFound) {
            return 1;
        }
    }

    return cost;
}


+ (BOOL) areSimilar:(NSString*) s1
              other:(NSString*) s2 {
    return [[DifferenceEngine engine] similar:s1 other:s2];
}


- (NSInteger) threshold:(NSString*) string {
    NSInteger threshold = string.length / 4;
    if (threshold == 0) {
        threshold = 1;
    }
    return threshold;
}


+ (BOOL) substringSimilar:(NSString*) s1 other:(NSString*) s2 {
    if (s1.length > 4 && s2.length > 4) {
        if (([s1 rangeOfString:s2 options:NSCaseInsensitiveSearch].length > 0) ||
            ([s2 rangeOfString:s1 options:NSCaseInsensitiveSearch].length > 0)) {
            return YES;
        }
    }

    return NO;
}


- (BOOL) similar:(NSString*) s1
           other:(NSString*) s2 {
    if (s1 == nil || s2 == nil) {
        return NO;
    }

    if ([DifferenceEngine substringSimilar:s1 other:s2]) {
        return YES;
    }

    NSInteger threshold = [self threshold:s1];
    NSInteger diff = [self editDistanceFrom:s1 to:s2 withThreshold:threshold];
    return (diff <= threshold);
}


- (NSInteger) findClosestMatchIndex:(NSString*) string
                            inArray:(NSArray*) array {
    {
        NSInteger index = [array indexOfObject:string];
        if (index != NSNotFound) {
            return index;
        }
    }

    {
        if (string.length > 4) {
            for (int i = 0; i < array.count; i++) {
                NSString* other = [array objectAtIndex:i];
                if (other.length > 4) {
                    if (([string rangeOfString:other options:NSCaseInsensitiveSearch].length > 0) ||
                        ([other rangeOfString:string options:NSCaseInsensitiveSearch].length > 0)) {
                        return i;
                    }
                }
            }
        }
    }


    NSInteger bestDistance = INT_MAX;
    NSInteger bestIndex = -1;

    for (int i = 0; i < array.count; i++) {
        NSString* value = [array objectAtIndex:i];

        int distance = [self editDistanceFrom:string
                                           to:value
                                withThreshold:[self threshold:string]];

        if (distance < bestDistance) {
            bestIndex = i;
            bestDistance = distance;
        }
    }

    if (bestIndex != -1 &&
        [self similar:[array objectAtIndex:bestIndex] other:string]) {
        return bestIndex;
    }

    return NSNotFound;
}


- (NSString*) findClosestMatch:(NSString*) string
                       inArray:(NSArray*) array {
    NSInteger index = [self findClosestMatchIndex:string inArray:array];
    if (index == NSNotFound) {
        return nil;
    }

    return [array objectAtIndex:index];
}

@end