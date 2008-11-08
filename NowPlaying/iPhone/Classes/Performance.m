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

#import "Performance.h"

#import "Utilities.h"

@implementation Performance

property_definition(time);
property_definition(url);

- (void) dealloc {
    self.time = nil;
    self.url = nil;

    [super dealloc];
}


- (id) initWithTime:(NSString*) time_
                url:(NSString*) url_ {
    if (self = [super init]) {
        self.time = [Utilities nonNilString:time_];
        self.url = [Utilities nonNilString:url_];
    }

    return self;
}


+ (Performance*) performanceWithTime:(NSString*) time
                                 url:(NSString*) url {
    return [[[Performance alloc] initWithTime:time
                                          url:url] autorelease];
}


+ (Performance*) performanceWithDictionary:(NSDictionary*) dictionary {
    return [Performance performanceWithTime:[dictionary valueForKey:time_key]
                                        url:[dictionary valueForKey:url_key]];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];

    [dictionary setObject:time forKey:time_key];
    [dictionary setObject:url forKey:url_key];

    return dictionary;
}


@end