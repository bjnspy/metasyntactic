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

#import "DeclarationOfIndependence.h"

@interface DeclarationOfIndependence()
@property (copy) NSString* text;
@property (retain) MultiDictionary* signers;
@property (retain) NSDate* date;
@end

@implementation DeclarationOfIndependence

@synthesize text;
@synthesize signers;
@synthesize date;

- (void) dealloc {
  self.text = nil;
  self.signers = nil;
  self.date = nil;

  [super dealloc];
}


- (id) initWithText:(NSString*) text_
            signers:(MultiDictionary*) signers_
               date:(NSDate*) date_ {
  if ((self = [super init])) {
    self.text = text_;
    self.signers = signers_;
    self.date = date_;
  }

  return self;
}


+ (DeclarationOfIndependence*) declarationWithText:(NSString*) text_
                                           signers:(MultiDictionary*) signers_
                                              date:(NSDate*) date_ {
  return [[[DeclarationOfIndependence alloc] initWithText:text_
                                                  signers:signers_
                                                     date:date_] autorelease];
}

@end
