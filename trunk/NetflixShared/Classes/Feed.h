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

@interface Feed : AbstractData<NSCopying, NSCoding> {
@private
  NSString* url;
  NSString* key;
  NSString* name;
}

@property (readonly, copy) NSString* url;
@property (readonly, copy) NSString* key;
@property (readonly, copy) NSString* name;

+ (Feed*) feedWithUrl:(NSString*) url
                  key:(NSString*) key
                 name:(NSString*) name;

- (BOOL) isRecommendationsFeed;
- (BOOL) isDVDQueueFeed;
- (BOOL) isInstantQueueFeed;
- (BOOL) isAtHomeFeed;

@end
