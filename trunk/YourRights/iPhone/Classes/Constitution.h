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

@interface Constitution : NSObject {
@private
    NSString* country;
    NSString* preamble;
    NSArray* articles;
    NSArray* amendments;
    NSString* conclusion;
    MultiDictionary* signers;
}

@property (readonly, copy) NSString* country;
@property (readonly, copy) NSString* preamble;
@property (readonly, retain) NSArray* articles;
@property (readonly, retain) NSArray* amendments;
@property (readonly, copy) NSString* conclusion;
@property (readonly, retain) MultiDictionary* signers;

+ (Constitution*) constitutionWithCountry:(NSString*) country
                                 preamble:(NSString*) preamble
                                 articles:(NSArray*) articles
                               amendments:(NSArray*) amendments
                               conclusion:(NSString*) conclusion
                                  signers:(MultiDictionary*) signers;

@end