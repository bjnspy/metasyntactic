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

@interface Model : NSObject {
@private
    RSSCache* rssCache;
}

@property (readonly, retain) RSSCache* rssCache;

+ (NSString*) version;

- (NSArray*) sectionTitles;
- (NSArray*) shortSectionTitles;

- (NSArray*) toughQuestions;
- (NSString*) answerForToughQuestion:(NSString*) question;

- (NSString*) shortSectionTitleForSectionTitle:(NSString*) sectionTitle;

- (NSString*) preambleForSectionTitle:(NSString*) sectionTitle;
- (NSArray*) questionsForSectionTitle:(NSString*) sectionTitle;
- (NSArray*) otherResourcesForSectionTitle:(NSString*) sectionTitle;
- (NSString*) answerForQuestion:(NSString*) question withSectionTitle:(NSString*) sectionTitle;
- (NSArray*) linksForSectionTitle:(NSString*) sectionTitle;
- (NSArray*) linksForQuestion:(NSString*) question withSectionTitle:(NSString*) sectionTitle;

- (NSInteger) greatestHitsSortIndex;
- (void) setGreatestHitsSortIndex:(NSInteger) index;

- (NSString*) feedbackUrl;

- (Constitution*) unitedStatesConstitution;
- (DeclarationOfIndependence*) declarationOfIndependence;
//+ (NSArray*)

@end