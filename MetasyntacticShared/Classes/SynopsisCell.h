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

#import "AbstractDetailsCell.h"

@interface SynopsisCell : AbstractDetailsCell {
@private
  NSString* synopsis;
  BOOL limitLength;

  UILabel* synopsisChunk1Label;
  UILabel* synopsisChunk2Label;

  CGSize imageSize;
}


+ (SynopsisCell*) cellWithSynopsis:(NSString*) synopsis
                         imageView:(UIImageView*) imageView
                       limitLength:(BOOL) limitLength
               tableViewController:(UITableViewController*) tableViewController;


+ (SynopsisCell*) cellWithSynopsis:(NSString*) synopsis
                       limitLength:(BOOL) limitLength
               tableViewController:(UITableViewController*) tableViewController;

@end
