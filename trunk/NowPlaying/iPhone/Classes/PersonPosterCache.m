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

#import "PersonPosterCache.h"

#import "AppDelegate.h"
#import "ApplePosterDownloader.h"
#import "Application.h"
#import "DifferenceEngine.h"
#import "FandangoPosterDownloader.h"
#import "FileUtilities.h"
#import "ImageUtilities.h"
#import "ImdbPosterDownloader.h"
#import "LargePosterCache.h"
#import "LinkedSet.h"
#import "Model.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "Person.h"
#import "StringUtilities.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"
#import "XmlElement.h"

@interface PersonPosterCache()
@property (retain) LinkedSet* normalPeople;
@property (retain) LinkedSet* prioritizedPeople;
@end


@implementation PersonPosterCache

@synthesize normalPeople;
@synthesize prioritizedPeople;

- (void) dealloc {
    self.normalPeople = nil;
    self.prioritizedPeople = nil;

    [super dealloc];
}


- (id) initWithModel:(Model*) model__ {
    if (self = [super initWithModel:model__]) {
        self.normalPeople = [LinkedSet set];
        self.prioritizedPeople = [LinkedSet setWithCountLimit:8];
/*
        [ThreadingUtilities backgroundSelector:@selector(updatePostersBackgroundEntryPoint)
                                      onTarget:self
                                          gate:nil
                                       visible:NO];
 */
    }

    return self;
}


+ (PersonPosterCache*) cacheWithModel:(Model*) model {
    return [[[PersonPosterCache alloc] initWithModel:model] autorelease];
}


- (void) update:(Person*) person {
    [self.gate lock];
    {
        [normalPeople addObject:person];
        [self.gate signal];
    }
    [self.gate unlock];
}


- (void) prioritizePerson:(Person*) person {
    [self.gate lock];
    {
        [prioritizedPeople addObject:person];
        [self.gate signal];
    }
    [self.gate unlock];
}


- (NSString*) posterFilePath:(Person*) person {
    NSString* sanitizedTitle = [FileUtilities sanitizeFileName:person.name];
    return [[[Application peoplePostersDirectory] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingPathExtension:@"jpg"];
}


- (NSString*) smallPosterFilePath:(Person*) person {
    NSString* sanitizedTitle = [FileUtilities sanitizeFileName:person.name];
    return [[[Application peoplePostersDirectory] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingString:@"-small.png"];
}


- (BOOL) hasProperSuffix:(NSString*) name {
    NSString* lowercaseName = [name lowercaseString];

    return [lowercaseName hasSuffix:@"png"] ||
           [lowercaseName hasSuffix:@"jpg"] ||
           [lowercaseName hasSuffix:@"jpeg"];
}


- (BOOL) isStockImage:(NSString*) name {
    NSString* lowercaseName = [name lowercaseString];

    return
    [@"file:us-actor.png" isEqual:lowercaseName] ||
    [@"file:spainfilm.png" isEqual:lowercaseName];
}


- (NSData*) downloadPosterWorker:(Person*) person {
    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupWikipediaListings?q=%@", [Application host], [StringUtilities stringByAddingPercentEscapes:person.name]];
    NSString* wikipediaAddress = [NetworkUtilities stringWithContentsOfAddress:url];

    if (wikipediaAddress.length == 0) {
        return nil;
    }

    NSRange slashRange = [wikipediaAddress rangeOfString:@"/" options:NSBackwardsSearch];
    if (slashRange.length == 0) {
        return nil;
    }

    NSString* wikiTitle = [wikipediaAddress substringFromIndex:slashRange.location + 1];
    if (wikiTitle.length == 0) {
        return nil;
    }

    NSString* wikiSearchAddress = [NSString stringWithFormat:@"http://en.wikipedia.org/w/api.php?action=query&titles=%@&prop=images&format=xml", wikiTitle];
    XmlElement* apiElement = [NetworkUtilities xmlWithContentsOfAddress:wikiSearchAddress];
    NSArray* imElements = [apiElement elements:@"im" recurse:YES];

    NSString* imageName = nil;
    for (XmlElement* imElement in imElements) {
        NSString* name = [imElement attributeValue:@"title"];
        if ([self hasProperSuffix:name] &&
            ![self isStockImage:name]) {
            imageName = name;
            break;
        }
    }

    if (imageName.length == 0) {
        return nil;
    }

    NSString* wikiDetailsAddress = [NSString stringWithFormat:@"http://en.wikipedia.org/w/api.php?action=query&titles=%@&prop=imageinfo&iiprop=url&format=xml", [StringUtilities stringByAddingPercentEscapes:imageName]];
    XmlElement* apiElement2 = [NetworkUtilities xmlWithContentsOfAddress:wikiDetailsAddress];
    XmlElement* iiElement = [apiElement2 element:@"ii" recurse:YES];

    NSString* imageUrl = [iiElement attributeValue:@"url"];

    return [NetworkUtilities dataWithContentsOfAddress:imageUrl];
}


- (void) downloadPoster:(Person*) person {
    NSString* path = [self posterFilePath:person];

    if ([FileUtilities fileExists:path]) {
        if ([FileUtilities size:path] > 0) {
            // already have a real poster.
            return;
        }

        if ([FileUtilities size:path] == 0) {
            // sentinel value.  only update if it's been long enough.
            NSDate* modificationDate = [FileUtilities modificationDate:path];
            if (ABS(modificationDate.timeIntervalSinceNow) < 3 * ONE_DAY) {
                return;
            }
        }
    }

    NSData* data = [self downloadPosterWorker:person];
    if (data == nil && [NetworkUtilities isNetworkAvailable]) {
        data = [NSData data];
    }

    if (data != nil) {
        [FileUtilities writeData:data toFile:path];

        if (data.length > 0) {
            [AppDelegate minorRefresh];
        }
    }
}


- (void) updatePostersBackgroundEntryPoint {
    while (YES) {
        Person* person = nil;

        [self.gate lock];
        {
            while ((person = [prioritizedPeople removeLastObjectAdded]) == nil &&
                   (person = [normalPeople removeLastObjectAdded]) == nil) {
                [self.gate wait];
            }
        }
        [self.gate unlock];

        [self downloadPoster:person];
    }
}


- (UIImage*) posterForPerson:(Person*) person {
    NSString* path = [self posterFilePath:person];
    NSData* data = [FileUtilities readData:path];
    return [UIImage imageWithData:data];
}


- (UIImage*) smallPosterForPerson:(Person*) person {
    NSString* smallPosterPath = [self smallPosterFilePath:person];
    NSData* smallPosterData;

    if ([FileUtilities size:smallPosterPath] == 0) {
        NSData* normalPosterData = [FileUtilities readData:[self posterFilePath:person]];
        smallPosterData = [ImageUtilities scaleImageData:normalPosterData
                                                toHeight:SMALL_POSTER_HEIGHT];

        [FileUtilities writeData:smallPosterData toFile:smallPosterPath];
    } else {
        smallPosterData = [FileUtilities readData:smallPosterPath];
    }

    return [UIImage imageWithData:smallPosterData];
}

@end