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

#import "Review.h"

@interface Review()
@property NSInteger score;
@property (copy) NSString* link;
@property (copy) NSString* text;
@property (copy) NSString* author;
@property (copy) NSString* source;
@end


@implementation Review

property_definition(score);
property_definition(link);
property_definition(text);
property_definition(author);
property_definition(source);

- (void) dealloc {
  self.score = 0;
  self.link = nil;
  self.text = nil;
  self.author = nil;
  self.source = nil;

  [super dealloc];
}


- (id) initWithText:(NSString*) text_
              score:(NSInteger) score_
               link:(NSString*) link_
             author:(NSString*) author_
             source:(NSString*) source_ {
  if ((self = [super init])) {
    self.score = score_;
    self.link = [StringUtilities nonNilString:link_];
    self.text = [StringUtilities nonNilString:text_];
    self.author = [StringUtilities nonNilString:author_];
    self.source = [StringUtilities nonNilString:source_];
  }

  return self;
}


- (id) initWithCoder:(NSCoder*) coder {
  return [self initWithText:[coder decodeObjectForKey:text_key]
                      score:[coder decodeIntegerForKey:score_key]
                       link:[coder decodeObjectForKey:link_key]
                     author:[coder decodeObjectForKey:author_key]
                     source:[coder decodeObjectForKey:source_key]];
}


+ (Review*) reviewWithText:(NSString*) text
                     score:(NSInteger) score
                      link:(NSString*) link
                    author:(NSString*) author
                    source:(NSString*) source {
  return [[[Review alloc] initWithText:text
                                 score:score
                                  link:link
                                author:author
                                source:source] autorelease];
}


+ (Review*) createWithDictionaryWorker:(NSDictionary*) dictionary {
  return [Review reviewWithText:[dictionary objectForKey:text_key]
                          score:[[dictionary objectForKey:score_key] integerValue]
                           link:[dictionary objectForKey:link_key]
                         author:[dictionary objectForKey:author_key]
                         source:[dictionary objectForKey:source_key]];
}


- (NSDictionary*) dictionary {
  NSMutableDictionary* dict = [NSMutableDictionary dictionary];
  [dict setObject:[NSNumber numberWithInteger:score]  forKey:score_key];
  [dict setObject:link                            forKey:link_key];
  [dict setObject:text                            forKey:text_key];
  [dict setObject:author                          forKey:author_key];
  [dict setObject:source                          forKey:source_key];
  return dict;
}


- (void) encodeWithCoder:(NSCoder*) coder {
  [coder encodeInteger:score  forKey:score_key];
  [coder encodeObject:link    forKey:link_key];
  [coder encodeObject:text    forKey:text_key];
  [coder encodeObject:author  forKey:author_key];
  [coder encodeObject:source  forKey:source_key];
}


- (id) copyWithZone:(NSZone*) zone {
  return [self retain];
}


- (NSComparisonResult) compare:(Review*) other {
  if (score < other.score) {
    return NSOrderedDescending;
  } else if (score > other.score) {
    return NSOrderedAscending;
  } else {
    NSInteger naturalSort = self - other;
    if (naturalSort < 0) {
      return NSOrderedAscending;
    } else if (naturalSort > 0) {
      return NSOrderedDescending;
    } else {
      return NSOrderedSame;
    }
  }
}

@end
