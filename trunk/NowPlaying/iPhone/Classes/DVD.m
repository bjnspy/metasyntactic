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

#import "DVD.h"

#import "Movie.h";
#import "Utilities.h"

@implementation DVD

property_definition(canonicalTitle);
property_definition(price);
property_definition(format);
property_definition(discs);

- (void) dealloc {
    self.canonicalTitle = nil;
    self.price = nil;
    self.format = nil;
    self.discs = nil;

    [super dealloc];
}


- (id) initWithCanonicalTitle:(NSString*) canonicalTitle_
                        price:(NSString*) price_
                       format:(NSString*) format_
                        discs:(NSString*) discs_ {
    if (self = [super init]) {
        self.canonicalTitle = [Utilities nonNilString:canonicalTitle_];
        self.price = [Utilities nonNilString:price_];
        self.format = [Utilities nonNilString:format_];
        self.discs = [Utilities nonNilString:discs_];
    }

    return self;
}


+ (DVD*) dvdWithCanonicalTitle:(NSString*) canonicalTitle
                price:(NSString*) price
               format:(NSString*) format
                         discs:(NSString*) discs {
    return [[[DVD alloc] initWithCanonicalTitle:canonicalTitle
                                          price:price
                                         format:format
                                          discs:discs] autorelease];
}


+ (DVD*) dvdWithTitle:(NSString*) title
                price:(NSString*) price
               format:(NSString*) format
                discs:(NSString*) discs {
    return [DVD dvdWithCanonicalTitle:[Movie makeCanonical:title]
                                price:price
                               format:format
                                discs:discs];
}


+ (DVD*) dvdWithDictionary:(NSDictionary*) dictionary {
    return [DVD dvdWithCanonicalTitle:[dictionary objectForKey:canonicalTitle_key]
                                price:[dictionary objectForKey:price_key]
                               format:[dictionary objectForKey:format_key]
                                discs:[dictionary objectForKey:discs_key]];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:canonicalTitle    forKey:canonicalTitle_key];
    [result setObject:price             forKey:price_key];
    [result setObject:format            forKey:format_key];
    [result setObject:discs             forKey:discs_key];
    return result;
}

@end