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

#import "LookupRequest.h"

@interface LookupRequest()
@property (retain) NSDate* searchDate;
@property (retain) id<DataProviderUpdateDelegate> delegate;
@property (retain) id context;
@property BOOL force;
@property (retain) NSArray* currentMovies;
@property (retain) NSArray* currentTheaters;
@end

@implementation LookupRequest

@synthesize searchDate;
@synthesize delegate;
@synthesize context;
@synthesize force;
@synthesize currentMovies;
@synthesize currentTheaters;

- (void) dealloc {
  self.searchDate = nil;
  self.delegate = nil;
  self.context = nil;
  self.force = NO;
  self.currentMovies = nil;
  self.currentTheaters = nil;

  [super dealloc];
}


- (id) initWithSearchDate:(NSDate*) searchDate_
                 delegate:(id<DataProviderUpdateDelegate>) delegate_
                  context:(id) context_
                    force:(BOOL) force_
            currentMovies:(NSArray*) currentMovies_
          currentTheaters:(NSArray*) currentTheaters_ {
  if ((self = [super init])) {
    self.searchDate = searchDate_;
    self.delegate = delegate_;
    self.context = context_;
    self.force = force_;
    self.currentMovies = currentMovies_;
    self.currentTheaters = currentTheaters_;
  }

  return self;
}


+ (LookupRequest*) requestWithSearchDate:(NSDate*) searchDate
                                delegate:(id<DataProviderUpdateDelegate>) delegate
                                 context:(id) context
                                   force:(BOOL) force
                           currentMovies:(NSArray*) currentMovies
                         currentTheaters:(NSArray*) currentTheaters {
  return [[[LookupRequest alloc] initWithSearchDate:searchDate
                                           delegate:delegate
                                            context:context
                                              force:force
                                      currentMovies:currentMovies
                                    currentTheaters:currentTheaters] autorelease];
}

@end
