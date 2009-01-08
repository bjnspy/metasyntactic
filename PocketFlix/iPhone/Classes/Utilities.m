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

#import "Utilities.h"

#import "DateUtilities.h"
#import "Model.h"
#import "XmlDocument.h"
#import "XmlElement.h"
#import "XmlParser.h"
#import "XmlSerializer.h"

@implementation Utilities

+ (id) removeRandomElement:(NSMutableArray*) array {
    NSInteger index = rand() % array.count;
    id value = [array objectAtIndex:index];
    [array removeObjectAtIndex:index];

    return value;
}


+ (NSDictionary*) nonNilDictionary:(NSDictionary*) dictionary {
    if (dictionary == nil) {
        return [NSDictionary dictionary];
    }

    return dictionary;
}


+ (NSArray*) nonNilArray:(NSArray*) array {
    if (array == nil) {
        return [NSArray array];
    }

    return array;
}

@end