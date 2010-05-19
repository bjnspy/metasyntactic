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

@protocol ScoreProvider<NSObject>
- (NSString*) providerName;
- (NSDictionary*) scores;
- (Score*) scoreForMovie:(Movie*) movie;
- (NSArray*) reviewsForMovie:(Movie*) movie;
- (void) updateWithNotifications;
- (void) updateWithoutNotifications;
- (void) processMovie:(Movie*) movie force:(BOOL) force;
@end
