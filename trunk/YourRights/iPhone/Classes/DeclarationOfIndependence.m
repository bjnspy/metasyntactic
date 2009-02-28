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
    if (self = [super init]) {
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