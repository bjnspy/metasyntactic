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

@interface Model : AbstractModel {
@private
  RSSCache* rssCache;
}

@property (readonly, retain) RSSCache* rssCache;

+ (Model*) model;

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

- (DeclarationOfIndependence*) declarationOfIndependence;

- (BOOL) screenRotationEnabled;

@end
