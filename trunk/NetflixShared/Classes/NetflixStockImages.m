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

#import "NetflixStockImages.h"

NSString* NetflixResourcePath(NSString* name) {
  static NSString* bundleName = @"NetflixResources.bundle";
  NSString* bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:nil];

  return [NSBundle pathForResource:name ofType:nil inDirectory:bundlePath];
}


UIImage* NetflixStockImage(NSString* name) {
  NSString* path = NetflixResourcePath(name);
  return [MetasyntacticStockImages imageForPath:path];
}

@implementation NetflixStockImages

@end
