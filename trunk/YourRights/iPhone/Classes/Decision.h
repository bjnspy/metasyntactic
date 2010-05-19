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

typedef enum {
    FreedomOfAssociation,
    FreedomOfThePress,
    FreedomOfExpression,
    EqualityUnderTheLaw,
    RightToFairProcedures,
    RightToPrivacy,
    ChecksAndBalances,
    SeparationOfChurchAndState,
    FreeExerciseOfReligion,
} Category;

@interface Decision : NSObject {
@private
    NSInteger year;
    Category category;
    NSString* title;
    NSString* synopsis;
    NSString* link;
}

@property (readonly) NSInteger year;
@property (readonly) Category category;
@property (readonly, retain) NSString* title;
@property (readonly, retain) NSString* synopsis;
@property (readonly, retain) NSString* link;

+ (Decision*) decisionWithYear:(NSInteger) year
                      category:(Category) category
                         title:(NSString*) title
                      synopsis:(NSString*) synopsis
                          link:(NSString*) link;

+ (NSArray*) greatestHits;




+ (NSString*) categoryString:(Category) category;

@end
