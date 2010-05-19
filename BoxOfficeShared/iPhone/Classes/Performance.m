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

#import "Performance.h"

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
  if ((self = [super init])) {
    self.time = time_;
    self.url = [StringUtilities nonNilString:url_];
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


+ (Performance*) createWithDictionaryWorker:(NSDictionary*) dictionary {
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
