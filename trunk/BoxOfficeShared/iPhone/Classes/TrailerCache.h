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

@interface TrailerCache : AbstractMovieCache {
@private
  // Accessed from different threads.  needs gate.
  PersistentDictionaryThreadsafeValue*/*NSDictionary*/ indexData;
  ThreadsafeValue*/*NSArray*/ indexKeysData;

  BOOL updated;
}

+ (TrailerCache*) cache;

- (void) update;
- (NSArray*) trailersForMovie:(Movie*) movie;

+ (NSString*) downloadIndexString;
+ (id) downloadJSONIndex;
+ (NSDictionary/*<NSString*,(NSString*,NSString*)>*/*) processJSONIndex:(id) index;

+ (NSString*) downloadXmlStringForStudioKey:(NSString*) studioKey titleKey:(NSString*) titleKey;
+ (XmlElement*) downloadXmlElementForStudioKey:(NSString*) studioKey titleKey:(NSString*) titleKey;
+ (NSArray*) downloadTrailersForStudioKey:(NSString*) studioKey titleKey:(NSString*) titleKey;

@end
