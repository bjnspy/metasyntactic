// Copyright 2010 Cyrus Najmabadi
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

#import "DVD.h"

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
  if ((self = [super init])) {
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


+ (DVD*) createWithDictionaryWorker:(NSDictionary*) dictionary {
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
