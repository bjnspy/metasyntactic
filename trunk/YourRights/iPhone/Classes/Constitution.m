// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
    if (self = [super init]) {
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