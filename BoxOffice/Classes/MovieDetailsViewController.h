// Copyright (C) 2008 Cyrus Najmabadi
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

@interface MovieDetailsViewController : UITableViewController {
    AbstractNavigationController* navigationController;

    Movie* movie;
    NSMutableArray* theatersArray;
    NSMutableArray* showtimesArray;
    NSArray* trailersArray;
    NSArray* reviewsArray;

    NSInteger hiddenTheaterCount;

    BOOL filterTheatersByDistance;
}

@property (assign) AbstractNavigationController* navigationController;
@property (retain) Movie* movie;
@property (retain) NSMutableArray* theatersArray;
@property (retain) NSMutableArray* showtimesArray;
@property (retain) NSArray* trailersArray;
@property (retain) NSArray* reviewsArray;
@property NSInteger hiddenTheaterCount;

- (id) initWithNavigationController:(AbstractNavigationController*) navigationController
                              movie:(Movie*) movie;

- (void) refresh;
- (BoxOfficeModel*) model;

@end
