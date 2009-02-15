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
#import "StringUtilities.h"
#import "Utilities.h"

@interface DVD()
@property (copy) NSString* canonicalTitle;
@property (copy) NSString* price;
@property (copy) NSString* format;
@property (copy) NSString* discs;
@property (copy) NSString* url;
@end


@implementation DVD

property_definition(canonicalTitle);
property_definition(price);
property_definition(format);
property_definition(discs);
property_definition(url);

- (void) dealloc {
    self.canonicalTitle = nil;
    self.price = nil;
    self.format = nil;
    self.discs = nil;
    self.url = nil;

    [super dealloc];
}


- (id) initWithCanonicalTitle:(NSString*) canonicalTitle_
                        price:(NSString*) price_
                       format:(NSString*) format_
                        discs:(NSString*) discs_
                          url:(NSString*) url_ {
    if (self = [super init]) {
        self.canonicalTitle = [StringUtilities nonNilString:canonicalTitle_];
        self.price = [StringUtilities nonNilString:price_];
        self.format = [StringUtilities nonNilString:format_];
        self.discs = [StringUtilities nonNilString:discs_];
        self.url = [StringUtilities nonNilString:url_];
    }

    return self;
}


- (id) initWithCoder:(NSCoder*) coder {
    return [self initWithCanonicalTitle:[coder decodeObjectForKey:canonicalTitle_key]
                                  price:[coder decodeObjectForKey:price_key]
                                 format:[coder decodeObjectForKey:format_key]
                                  discs:[coder decodeObjectForKey:discs_key]
                                    url:[coder decodeObjectForKey:url_key]];
}


+ (DVD*) dvdWithCanonicalTitle:(NSString*) canonicalTitle
                         price:(NSString*) price
                        format:(NSString*) format
                         discs:(NSString*) discs
                           url:(NSString*) url {
    return [[[DVD alloc] initWithCanonicalTitle:canonicalTitle
                                          price:price
                                         format:format
                                          discs:discs
                                            url:url] autorelease];
}


+ (DVD*) dvdWithTitle:(NSString*) title
                price:(NSString*) price
               format:(NSString*) format
                discs:(NSString*) discs
                  url:(NSString*) url {
    return [DVD dvdWithCanonicalTitle:[Movie makeCanonical:title]
                                price:price
                               format:format
                                discs:discs
                                  url:url];
}


+ (DVD*) dvdWithDictionary:(NSDictionary*) dictionary {
    return [DVD dvdWithCanonicalTitle:[dictionary objectForKey:canonicalTitle_key]
                                price:[dictionary objectForKey:price_key]
                               format:[dictionary objectForKey:format_key]
                                discs:[dictionary objectForKey:discs_key]
                                  url:[dictionary objectForKey:url_key]];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:canonicalTitle    forKey:canonicalTitle_key];
    [result setObject:price             forKey:price_key];
    [result setObject:format            forKey:format_key];
    [result setObject:discs             forKey:discs_key];
    [result setObject:url               forKey:url_key];
    return result;
}


- (void) encodeWithCoder:(NSCoder*) coder {
    [coder encodeObject:canonicalTitle    forKey:canonicalTitle_key];
    [coder encodeObject:price             forKey:price_key];
    [coder encodeObject:format            forKey:format_key];
    [coder encodeObject:discs             forKey:discs_key];
    [coder encodeObject:url               forKey:url_key];
}


- (id) copyWithZone:(NSZone*) zone {
    return [self retain];
}

@end