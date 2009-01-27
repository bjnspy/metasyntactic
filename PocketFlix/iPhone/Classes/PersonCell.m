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

#import "PersonCell.h"

#import "Model.h"
#import "Person.h"

@interface PersonCell()
@property (retain) UILabel* bioTitleLabel;
@property (retain) UILabel* bioLabel;
@end


@implementation PersonCell

@synthesize person;
@synthesize bioTitleLabel;
@synthesize bioLabel;

- (void) dealloc {
    self.person = nil;
    self.bioTitleLabel = nil;
    self.bioLabel = nil;

    [super dealloc];
}


- (NSArray*) titleLabels {
    return [NSArray arrayWithObjects:
            bioTitleLabel, nil];
}


- (NSArray*) valueLabels {
    return [NSArray arrayWithObjects:
            bioLabel, nil];
}

- (id) initWithFrame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier
               model:(Model*) model_ {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier model:model_]) {
        self.bioTitleLabel = [self createTitleLabel:NSLocalizedString(@"Bio:", nil) yPosition:22];
        self.bioLabel = [self createValueLabel:22 + 1 forTitle:bioTitleLabel];
        bioLabel.numberOfLines = 0;

        titleWidth = 0;
        for (UILabel* label in self.titleLabels) {
            titleWidth = MAX(titleWidth, [label.text sizeWithFont:label.font].width);
        }

        for (UILabel* label in self.titleLabels) {
            CGRect frame = label.frame;
            frame.origin.x = (int)(imageView.frame.size.width + 7);
            frame.size.width = titleWidth;
            label.frame = frame;
        }
    }

    return self;
}


- (UIImage*) loadImageWorker {
    return [model smallPosterForPerson:person];
}


- (void) prioritizeImage {
    [model prioritizePerson:person];
}


- (void) onSetSamePerson:(Person*) person_
                  owner:(id) owner  {
    // refreshing with the same movie.
    // update our image if necessary.
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadImage) object:nil];
    [self performSelector:@selector(loadImage) withObject:nil afterDelay:0];
}


- (void) onSetDifferentPerson:(Person*) person_
                       owner:(id) owner  {
    // switching to a new movie.  update everything.
    self.person = person_;

    for (UILabel* label in self.allLabels) {
        [label removeFromSuperview];
    }

    [self clearImage];

    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadPerson:) object:owner];
    [self performSelector:@selector(loadPerson:) withObject:owner afterDelay:0];
}


- (void) setPerson:(Person*) person_
            owner:(id) owner {
    titleLabel.text = person_.name;

    if (person == person_) {
        [self onSetSamePerson:person_ owner:owner];
    } else {
        [self onSetDifferentPerson:person_ owner:owner];
    }
}


- (NSArray*) allLabels {
    return [self.titleLabels arrayByAddingObjectsFromArray:self.valueLabels];
}


- (void) loadPerson:(id) owner {
    [self loadImage];

    NSString* biography = person.biography;
    bioLabel.text = biography.length > 0 ? biography : NSLocalizedString(@"No biography available.", nil);

    for (UILabel* label in self.allLabels) {
        [self.contentView addSubview:label];
    }

    [self setNeedsLayout];
}


- (void) refresh {
    [self loadPerson:nil];
}


- (void) layoutSubviews {
    [super layoutSubviews];

    CGRect bioFrame = bioLabel.frame;

    CGFloat height = self.contentView.frame.size.height - bioFrame.origin.y;

    CGSize size = [bioLabel.text sizeWithFont:bioLabel.font constrainedToSize:CGSizeMake(bioFrame.size.width, height) lineBreakMode:UILineBreakModeWordWrap];
    bioFrame.size = size;
    bioLabel.frame = bioFrame;
}

@end