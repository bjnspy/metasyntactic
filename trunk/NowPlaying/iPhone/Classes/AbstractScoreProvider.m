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

#import "AbstractScoreProvider.h"

#import "Application.h"
#import "DifferenceEngine.h"
#import "FileUtilities.h"
#import "LinkedSet.h"
#import "LocaleUtilities.h"
#import "Location.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "AppDelegate.h"
#import "Model.h"
#import "Review.h"
#import "Score.h"
#import "ScoreCache.h"
#import "ThreadingUtilities.h"
#import "UserLocationCache.h"
#import "XmlElement.h"
#import "XmlParser.h"

@interface AbstractScoreProvider()
@property (retain) NSDictionary* scoresData;
@property (retain) NSString* hashData;
@property (retain) NSLock* movieMapLock;
@property (retain) NSArray* movies;
@property (retain) NSDictionary* movieMapData;
@property (retain) NSString* providerDirectory;
@property (retain) NSString* reviewsDirectory;
@property (retain) LinkedSet* prioritizedMovies;
@end


@implementation AbstractScoreProvider

@synthesize scoresData;
@synthesize hashData;
@synthesize movieMapLock;
@synthesize movies;
@synthesize movieMapData;
@synthesize providerDirectory;
@synthesize reviewsDirectory;
@synthesize prioritizedMovies;

- (void) dealloc {
    self.scoresData = nil;
    self.hashData = nil;
    self.movieMapLock = nil;
    self.movies = nil;
    self.movieMapData = nil;
    self.providerDirectory = nil;
    self.reviewsDirectory = nil;
    self.prioritizedMovies = nil;

    [super dealloc];
}


- (NSString*) providerName {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (NSString*) lookupServerHash {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (NSDictionary*) lookupServerScores {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id) initWithModel:(Model*) model_ {
    if (self = [super initWithModel:model_]) {
        self.providerDirectory = [[Application scoresDirectory] stringByAppendingPathComponent:self.providerName];
        self.reviewsDirectory = [[Application reviewsDirectory] stringByAppendingPathComponent:self.providerName];
        self.prioritizedMovies = [LinkedSet setWithCountLimit:8];

        [FileUtilities createDirectory:providerDirectory];
        [FileUtilities createDirectory:reviewsDirectory];
    }

    return self;
}


- (NSString*) scoresFile {
    return [providerDirectory stringByAppendingPathComponent:@"Scores.plist"];
}


- (NSString*) hashFile {
    return [providerDirectory stringByAppendingPathComponent:@"Hash.plist"];
}


- (NSString*) movieMapFile {
    return [providerDirectory stringByAppendingPathComponent:@"Map.plist"];
}


- (NSDictionary*) loadScores {
    NSDictionary* encodedScores = [FileUtilities readObject:self.scoresFile];
    if (encodedScores == nil) {
        return [NSDictionary dictionary];
    }

    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    for (NSString* title in encodedScores) {
        Score* rating = [Score scoreWithDictionary:[encodedScores objectForKey:title]];
        [result setObject:rating forKey:title];
    }

    return result;
}


- (NSString*) loadHash {
    NSString* result = [FileUtilities readObject:self.hashFile];
    if (result == nil) {
        return @"";
    }
    return result;
}


- (NSDictionary*) loadMovieMap {
    NSDictionary* result = [FileUtilities readObject:self.movieMapFile];
    if (result == nil) {
        return [NSDictionary dictionary];
    }
    return result;
}


- (NSDictionary*) scores {
    if (scoresData == nil) {
        self.scoresData = [self loadScores];
    }

    return scoresData;
}


- (NSString*) hash {
    if (hashData == nil) {
        self.hashData = [self loadHash];
    }

    return hashData;
}


- (NSDictionary*) movieMap {
    if (movieMapData == nil) {
        self.movieMapData = [self loadMovieMap];
    }

    return movieMapData;
}


- (void) update {
    [ThreadingUtilities backgroundSelector:@selector(updateScoresBackgroundEntryPoint)
                                  onTarget:self
                                      gate:gate
                                   visible:YES
                                      name:[NSString stringWithFormat:@"%@-UpdateScores", [self providerName]]];
}


- (void) saveScores:(NSDictionary*) scores hash:(NSString*) hash {
    NSMutableDictionary* encodedScores = [NSMutableDictionary dictionary];
    for (NSString* title in scores) {
        NSDictionary* dictionary = [[scores objectForKey:title] dictionary];
        [encodedScores setObject:dictionary forKey:title];
    }

    [FileUtilities writeObject:encodedScores toFile:self.scoresFile];
    [FileUtilities writeObject:hash toFile:self.hashFile];
}


- (void) updateScoresBackgroundEntryPointWorker {
    NSDate* lastLookupDate = [FileUtilities modificationDate:self.hashFile];
    
    if (lastLookupDate != nil) {
        if (ABS(lastLookupDate.timeIntervalSinceNow) < ONE_DAY) {
            return;
        }
    }
    
    NSString* localHash = self.hash;
    NSString* serverHash = [self lookupServerHash];
    
    if (serverHash.length == 0 ||
        [serverHash isEqual:@"0"] ||
        [serverHash isEqual:localHash]) {
        return;
    }
    
    NSDictionary* result = [self lookupServerScores];
    if (result.count == 0) {
        return;
    }
    
    [self saveScores:result hash:serverHash];
    
    [ThreadingUtilities foregroundSelector:@selector(reportResult:withHash:)
                                  onTarget:self
                                  argument:result
                                  argument:serverHash];
}


- (void) reportResult:(NSDictionary*) result withHash:(NSString*) hash {
    NSAssert([NSThread isMainThread], nil);

    self.scoresData = result;
    self.hashData = hash;
    self.movieMapData = nil;
    self.movies = nil;
    [AppDelegate majorRefresh:YES];
}


- (void) ensureMovieMap:(NSArray*) movies_ {
    if (movies_ != self.movies) {
        self.movies = movies_;

        NSDictionary* scores = self.scores;

        [ThreadingUtilities backgroundSelector:@selector(regenerateMap:forMovies:)
                                      onTarget:self
                                      argument:scores
                                      argument:movies
                                          gate:movieMapLock
                                       visible:YES
                                          name:@"EnsureMovieMap"];
    }
}


- (void) regenerateMap:(NSDictionary*) scores forMovies:(NSArray*) localMovies {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];

    NSArray* keys = scores.allKeys;
    NSMutableArray* lowercaseKeys = [NSMutableArray array];
    for (NSString* key in keys) {
        [lowercaseKeys addObject:key.lowercaseString];
    }

    DifferenceEngine* engine = [DifferenceEngine engine];

    for (Movie* movie in localMovies) {
        NSString* lowercaseTitle = movie.canonicalTitle.lowercaseString;
        NSInteger index = [lowercaseKeys indexOfObject:lowercaseTitle];
        if (index == NSNotFound) {
            index = [engine findClosestMatchIndex:movie.canonicalTitle.lowercaseString inArray:lowercaseKeys];
        }

        if (index != NSNotFound) {
            NSString* key = [keys objectAtIndex:index];
            [result setObject:key forKey:movie.canonicalTitle];
        }
    }

    if (result.count == 0) {
        return;
    }

    [FileUtilities writeObject:result toFile:self.movieMapFile];

    [ThreadingUtilities foregroundSelector:@selector(reportMap:forMovies:)
                                  onTarget:self
                                  argument:result
                                  argument:localMovies];
}


- (void) reportMap:(NSDictionary*) map forMovies:(NSArray*) localMovies {
    NSAssert([NSThread isMainThread], nil);

    self.movieMapData = map;
    self.movies = localMovies;

    [AppDelegate majorRefresh:YES];
}


- (Score*) scoreForMovie:(Movie*) movie inMovies:(NSArray*) movies_ {
    [self ensureMovieMap:movies_];

    NSString* title = [self.movieMap objectForKey:movie.canonicalTitle];
    return [self.scores objectForKey:title];
}


- (NSString*) reviewsFile:(NSString*) title {
    return [[reviewsDirectory stringByAppendingPathComponent:[FileUtilities sanitizeFileName:title]]
            stringByAppendingPathExtension:@"plist"];
}


- (NSString*) reviewsHashFile:(NSString*) title {
    return [reviewsDirectory stringByAppendingPathComponent:[[FileUtilities sanitizeFileName:title] stringByAppendingString:@"-Hash.plist"]];
}


- (NSArray*) reviewsForMovie:(Movie*) movie inMovies:(NSArray*) movies_ {
    [self ensureMovieMap:movies_];

    NSString* title = [self.movieMap objectForKey:movie.canonicalTitle];
    NSArray* encodedResult = [FileUtilities readObject:[self reviewsFile:title]];

    if (encodedResult == nil) {
        return [NSArray array];
    }

    NSMutableArray* result = [NSMutableArray array];
    for (NSDictionary* dictionary in encodedResult) {
        [result addObject:[Review reviewWithDictionary:dictionary]];
    }

    return result;
}


- (NSString*) serverReviewsAddress:(Location*) location
                             score:(Score*) score {
    NSString* country = location.country.length == 0 ? [LocaleUtilities isoCountry] :
    location.country;

    NSString* url =
    [NSString stringWithFormat:@"http://%@.appspot.com/LookupMovieReviews2?country=%@&language=%@&id=%@&provider=%@&latitude=%d&longitude=%d",
     [Application host],
     country,
     [LocaleUtilities isoLanguage],
     score.identifier,
     score.provider,
     (int)(location.latitude * 1000000),
     (int)(location.longitude * 1000000)];

    return url;
}


- (NSMutableArray*) extractReviews:(XmlElement*) element {
    NSMutableArray* result = [NSMutableArray array];
    for (XmlElement* reviewElement in element.children) {
        NSString* text = [reviewElement attributeValue:@"text"];
        NSString* score = [reviewElement attributeValue:@"score"];
        NSString* link = [reviewElement attributeValue:@"link"];
        NSString* author = [reviewElement attributeValue:@"author"];
        NSString* source = [reviewElement attributeValue:@"source"];

        if ([author rangeOfString:@"HREF"].length > 0) {
            continue;
        }

        NSInteger scoreValue = [score intValue];

        [result addObject:[Review reviewWithText:text
                                           score:scoreValue
                                            link:link
                                          author:author
                                          source:source]];
    }

    return result;
}


- (NSMutableArray*) downloadReviewContents:(Score*) score location:(Location*) location {
    NSString* address = [self serverReviewsAddress:location score:score];
    NSData* data = [NetworkUtilities dataWithContentsOfAddress:address important:NO];
    if (data == nil) {
        // We couldn't even connect.  Just abort what we're doing.
        return nil;
    }

    XmlElement* element = [XmlParser parse:data];
    if (element == nil) {
        // we got an empty string back.  record this so we don't try
        // downloading for another two days.
        return [NSMutableArray array];
    }

    return [self extractReviews:element];
}


- (void) saveEncodedReviews:(NSArray*) encodedReviews hash:(NSString*) hash title:(NSString*) title {
    [FileUtilities writeObject:encodedReviews toFile:[self reviewsFile:title]];
    // do this last.  it marks us being complete.
    [FileUtilities writeObject:hash toFile:[self reviewsHashFile:title]];
}


- (void) saveReviews:(NSArray*) reviews hash:(NSString*) hash title:(NSString*) title {
    NSMutableArray* encodedReviews = [NSMutableArray array];
    for (Review* review in reviews) {
        [encodedReviews addObject:review.dictionary];
    }

    [self saveEncodedReviews:encodedReviews hash:hash title:title];
}


- (void) downloadReviews:(Score*) score
                location:(Location*) location {
    if (score == nil) {
        return;
    }

    NSString* address = [[self serverReviewsAddress:location score:score] stringByAppendingString:@"&hash=true"];
    NSString* localHash = [FileUtilities readObject:[self reviewsHashFile:score.canonicalTitle]];
    NSString* serverHash = [NetworkUtilities stringWithContentsOfAddress:address important:NO];

    if (serverHash.length == 0 ||
        [serverHash isEqual:@"0"] ||
        [serverHash isEqual:localHash]) {
        return;
    }

    NSMutableArray* reviews = [self downloadReviewContents:score location:location];
    if (reviews == nil) {
        // didn't download.  just ignore it.
        return;
    }

    NSString* title = score.canonicalTitle;
    if (reviews.count == 0) {
        // we got no reviews.  only save that fact if we don't currently have
        // any reviews.  This way we don't end up checking every single time
        // for movies that don't have reviews yet
        NSArray* existingReviews = [FileUtilities readObject:[self reviewsFile:title]];
        if (existingReviews.count > 0) {
            // we have reviews already.  don't wipe it out.
            // rewrite the reviews so the mod date is correct.
            [Application moveItemToTrash:[self reviewsFile:title]];
            [self saveEncodedReviews:existingReviews hash:serverHash title:title];
            return;
        }
    }

    [reviews sortUsingSelector:@selector(compare:)];
    [self saveReviews:reviews hash:serverHash title:title];

    [AppDelegate minorRefresh];
}


- (Score*) getNextScore:(NSMutableArray*) scores
              scoresMap:(NSDictionary*) scoresMap {
    NSArray* arguments = [prioritizedMovies removeLastObjectAdded];
    if (arguments != nil) {
        Movie* movie = [arguments objectAtIndex:0];
        NSDictionary* movieMap = [arguments objectAtIndex:1];

        Score* score = [scoresMap objectForKey:[movieMap objectForKey:movie.canonicalTitle]];
        if (score != nil) {
            // only process this movie if we've got no data for it.
            if (![FileUtilities fileExists:[self reviewsFile:score.canonicalTitle]]) {
                return score;
            }
        }
    }

    if (scores.count > 0) {
        Score* score = [[[scores lastObject] retain] autorelease];
        [scores removeLastObject];
        return score;
    }

    return nil;
}


- (void) downloadReviews:(NSMutableArray*) scores
               scoresMap:(NSDictionary*) scoresMap {
    Location* location = [model.userLocationCache downloadUserAddressLocationBackgroundEntryPoint:model.userAddress];

    if (location == nil) {
        return;
    }

    Score* score;
    do {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        {
            score = [self getNextScore:scores scoresMap:scoresMap];
            [self downloadReviews:score location:location];
        }
        [autoreleasePool release];
    } while (score != nil);
}


- (void) updateReviewsBackgroundEntryPoint {
    NSDictionary* scoresMap = [self loadScores];
    NSMutableArray* scoresWithoutReviews = [NSMutableArray array];
    NSMutableArray* scoresWithReviews = [NSMutableArray array];

    for (Score* score in scoresMap.allValues) {
        NSString* file = [self reviewsFile:score.canonicalTitle];

        NSDate* lastLookupDate = [FileUtilities modificationDate:file];

        if (lastLookupDate == nil) {
            [scoresWithoutReviews addObject:score];
        } else {
            if (ABS(lastLookupDate.timeIntervalSinceNow) > (3 * ONE_DAY)) {
                [scoresWithReviews addObject:score];
            }
        }
    }

    [self downloadReviews:scoresWithoutReviews scoresMap:scoresMap];
    [self downloadReviews:scoresWithReviews scoresMap:scoresMap];
}


- (void) updateScoresBackgroundEntryPoint {
    [self updateScoresBackgroundEntryPointWorker];
    
    [ThreadingUtilities backgroundSelector:@selector(updateReviewsBackgroundEntryPoint)
                                  onTarget:self
                                  argument:nil
                                      gate:gate
                                   visible:NO
                                      name:[NSString stringWithFormat:@"%@-UpdateReviews", [self providerName]]];
}


- (void) prioritizeMovie:(Movie*) movie inMovies:(NSArray*) movies_ {
    [self ensureMovieMap:movies_];
    NSArray* arguments = [NSArray arrayWithObjects:movie, self.movieMap, nil];
    [prioritizedMovies addObject:arguments];
}

@end