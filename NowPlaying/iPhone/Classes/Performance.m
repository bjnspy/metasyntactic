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

#import "DateUtilities.h"
#import "Utilities.h"

@interface Performance()
@property (copy) NSDate* time;
@property (copy) NSString* url;
@property (copy) NSString* timeString;
@end

@implementation Performance

property_definition(time);
property_definition(url);
@synthesize timeString;

- (void) dealloc {
    self.time = nil;
    self.url = nil;
    self.timeString = nil;

    [super dealloc];
}


- (id) initWithTime:(NSDate*) time_
                url:(NSString*) url_ {
    if (self = [super init]) {
        self.time = time_;
        self.url = [Utilities nonNilString:url_];
    }

    return self;
}


- (id) initWithCoder:(NSCoder*) coder {
    return [self initWithTime:[coder decodeObjectForKey:time_key]
                          url:[coder decodeObjectForKey:url_key]];
}


+ (Performance*) performanceWithTime:(NSDate*) time
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


- (void) encodeWithCoder:(NSCoder*) coder {
    [coder encodeObject:time forKey:time_key];
    [coder encodeObject:url forKey:url_key];
}


- (id) copyWithZone:(NSZone*) zone {
    return [self retain];
}


- (NSString*) timeString {
    if (timeString == nil) {
        self.timeString = [DateUtilities formatShortTime:time];
    }

    return timeString;
}

@end