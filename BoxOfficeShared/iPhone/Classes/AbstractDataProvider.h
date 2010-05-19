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

@interface AbstractDataProvider : AbstractCache {
@private
  // Accessed from multiple threads.  needs lock
  ThreadsafeValue*/*NSArray*/ moviesData;
  ThreadsafeValue*/*NSArray*/ theatersData;
  ThreadsafeValue*/*NSDictionary*/ synchronizationInformationData;
  ThreadsafeValue*/*NSDictionary*/ bookmarksData;

  // Shared amongst threads.
  AutoreleasingMutableDictionary* performancesData;

  NSMutableDictionary* cachedIsStale;
}

- (NSArray*) movies;
- (NSArray*) theaters;
- (NSArray*) moviePerformances:(Movie*) movie forTheater:(Theater*) theater;
- (NSDate*) synchronizationDateForTheater:(Theater*) theater;

- (void) markOutOfDate;
- (NSDate*) lastLookupDate;

- (BOOL) isStale:(Theater*) theater;

- (void) update:(NSDate*) searchDate delegate:(id<DataProviderUpdateDelegate>) delegate context:(id) context force:(BOOL) force;
- (void) saveResult:(LookupResult*) result;

- (void) addBookmark:(NSString*) canonicalTitle;
- (void) removeBookmark:(NSString*) canonicalTitle;

@end
