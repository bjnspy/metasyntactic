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

#import "Constitution.h"

@interface Constitution()
@property (copy) NSString* country;
@property (copy) NSString* preamble;
@property (retain) NSArray* articles;
@property (retain) NSArray* amendments;
@property (copy) NSString* conclusion;
@property (retain) MultiDictionary* signers;
@end

@implementation Constitution

@synthesize country;
@synthesize preamble;
@synthesize articles;
@synthesize amendments;
@synthesize conclusion;
@synthesize signers;

- (void) dealloc {
  self.country = nil;
  self.preamble = nil;
  self.articles = nil;
  self.amendments = nil;
  self.conclusion = nil;
  self.signers = nil;

  [super dealloc];
}


- (id) initWithCountry:(NSString*) country_
              preamble:(NSString*) preamble_
              articles:(NSArray*) articles_
            amendments:(NSArray*) amendments_
            conclusion:(NSString*) conclusion_
               signers:(MultiDictionary*) signers_ {
  if ((self = [super init])) {
    self.country = country_;
    self.preamble = preamble_;
    self.articles = articles_;
    self.amendments = amendments_;
    self.conclusion = conclusion_;
    self.signers = signers_;
  }

  return self;
}


+ (Constitution*) constitutionWithCountry:(NSString*) country_
                                 preamble:(NSString*) preamble_
                                 articles:(NSArray*) articles_
                               amendments:(NSArray*) amendments_
                               conclusion:(NSString*) conclusion_
                                  signers:(MultiDictionary*) signers_ {
  return [[[Constitution alloc] initWithCountry:country_
                                       preamble:preamble_
                                       articles:articles_
                                     amendments:amendments_
                                     conclusion:conclusion_
                                        signers:signers_] autorelease];
}

@end
