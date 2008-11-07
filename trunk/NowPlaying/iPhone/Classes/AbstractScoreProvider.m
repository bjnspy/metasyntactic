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
#import "Score.h"
#import "NetworkUtilities.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "Review.h"
#import "ScoreCache.h"
#import "ThreadingUtilities.h"
#import "UserLocationCache.h"
#import "XmlElement.h"
#import "XmlParser.h"

@implementation AbstractScoreProvider

@synthesize parentCache;
@synthesize lock;
@synthesize scoresData;
@synthesize hashData;
@synthesize movieMapLock;
@synthesize movies;
@synthesize movieMapData;
@synthesize providerDirectory;
@synthesize reviewsDirectory;
@synthesize prioritizedMovies;

- (void) dealloc {
    self.parentCache = nil;
    self.lock = nil;
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
    NSAssert(false, @"Someone subclassed incorrectly");
    return nil;
}


- (NSString*) lookupServerHash {
    NSAssert(false, @"Someone subclassed incorrectly");
    return nil;
}


- (NSDictionary*) lookupServerScores {
    NSAssert(false, @"Someone subclassed incorrectly");
    return nil;
}


- (id) initWithCache:(ScoreCache*) parentCache_ {
    if (self = [super init]) {
        self.lock = [[[NSRecursiveLock alloc] init] autorelease];
        self.parentCache = parentCache_;
        self.providerDirectory = [[Application scoresFolder] stringByAppendingPathComponent:self.providerName];
        self.reviewsDirectory = [[Application reviewsFolder] stringByAppendingPathComponent:self.providerName];
        self.prioritizedMovies = [LinkedSet setWithCountLimit:8];

        [FileUtilities createDirectory:providerDirectory];
        [FileUtilities createDirectory:reviewsDirectory];
    }

    return self;
}


- (NowPlayingModel*) model {
    return parentCache.model;
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


- (void) updateScores {
    [ThreadingUtilities performSelector:@selector(updateScoresBackgroundEntryPoint)
                               onTarget:self
               inBackgroundWithArgument:nil
                                   gate:lock
                                visible:YES];
}


- (void) updateReviews {
    NSDictionary* scores = self.scores;

    [ThreadingUtilities performSelector:@selector(updateReviewsBackgroundEntryPoint:)
                               onTarget:self
               inBackgroundWithArgument:scores
                                   gate:lock
                                visible:NO];
}


- (void) update {
    [self updateScores];
    [self updateReviews];
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


- (void) updateScoresBackgroundEntryPoint {
    NSDate* lastLookupDate = [FileUtilities modificationDate:self.hashFile];

    if (lastLookupDate != nil) {
        if (ABS([lastLookupDate timeIntervalSinceNow]) < ONE_DAY) {
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

    NSArray* arguments = [NSArray arrayWithObjects:result, serverHash, nil];
    [self performSelectorOnMainThread:@selector(reportResult:) withObject:arguments waitUntilDone:NO];
}



- (void) reportResult:(NSArray*) arguments {
    NSDictionary* result = [arguments objectAtIndex:0];
    NSString* hash = [arguments objectAtIndex:1];

    self.scoresData = result;
    self.hashData = hash;
    self.movieMapData = nil;
    self.movies = nil;
    [NowPlayingAppDelegate refresh:YES];

    [self updateReviews];
}


- (void) ensureMovieMap:(NSArray*) movies_ {
    if (movies_ != self.movies) {
        self.movies = movies_;

        NSDictionary* scores = self.scores;
        NSArray* arguments = [NSArray arrayWithObjects:scores, movies, nil];

        [ThreadingUtilities performSelector:@selector(regenerateMovieMap:)
                                   onTarget:self
                   inBackgroundWithArgument:arguments
                                       gate:movieMapLock
                                    visible:YES];
    }
}


- (void) regenerateMovieMap:(NSArray*) arguments {
    NSDictionary* scores = [arguments objectAtIndex:0];
    NSArray* movies_ = [arguments objectAtIndex:1];

    NSMutableDictionary* result = [NSMutableDictionary dictionary];

    NSArray* keys = scores.allKeys;
    NSMutableArray* lowercaseKeys = [NSMutableArray array];
    for (NSString* key in keys) {
        [lowercaseKeys addObject:key.lowercaseString];
    }

    DifferenceEngine* engine = [DifferenceEngine engine];

    for (Movie* movie in movies_) {
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

    NSArray* resultArguments = [NSArray arrayWithObjects:result, movies_, nil];
    [self performSelectorOnMainThread:@selector(reportMovieMap:) withObject:resultArguments waitUntilDone:NO];
}


- (void) reportMovieMap:(NSArray*) arguments {
    NSDictionary* map = [arguments objectAtIndex:0];
    NSArray* movies_ = [arguments objectAtIndex:1];

    self.movieMapData = map;
    self.movies = movies_;

    [NowPlayingAppDelegate refresh:YES];
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


- (NSArray*) extractReviews:(XmlElement*) element {
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


- (NSArray*) downloadReviewContents:(Score*) score location:(Location*) location {
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
        return [NSArray array];
    }

    return [self extractReviews:element];
}


- (void) saveReviews:(NSArray*) reviews hash:(NSString*) hash title:(NSString*) title {
    NSMutableArray* encodedReviews = [NSMutableArray array];
    for (Review* review in reviews) {
        [encodedReviews addObject:review.dictionary];
    }

    [FileUtilities writeObject:encodedReviews toFile:[self reviewsFile:title]];
    // do this last.  it marks us being complete.
    [FileUtilities writeObject:hash toFile:[self reviewsHashFile:title]];
}


- (void) downloadReviews:(Score*) score
                location:(Location*) location {
    if (score == nil) {
        return;
    }

    NSString* address = [[self serverReviewsAddress:location score:score] stringByAppendingString:@"&hash=true"];
    NSString* serverHash = [NetworkUtilities stringWithContentsOfAddress:address important:NO];

    if (serverHash == nil) {
        serverHash = @"0";
    }

    NSString* localHash = [FileUtilities readObject:[self reviewsHashFile:score.canonicalTitle]];
    if ([serverHash isEqual:localHash]) {
        return;
    }

    NSArray* reviews = [self downloadReviewContents:score location:location];
    if (reviews == nil) {
        // didn't download.  just ignore it.
        return;
    }


    if (reviews.count == 0) {
        // we got no reviews.  only save that fact if we don't currently have
        // any reviews.  This way we don't end up checking every single time
        // for movies that don't have reviews yet
        NSArray* existingReviews = [FileUtilities readObject:[self reviewsFile:score.canonicalTitle]];
        if (existingReviews.count > 0) {
            // we have reviews already.  don't wipe it out.
            return;
        }
    }

    [self saveReviews:reviews hash:serverHash title:score.canonicalTitle];

    [NowPlayingAppDelegate refresh];
}


- (Score*) getNextScore:(NSMutableArray*) scores {
    Movie* movie = [prioritizedMovies removeLastObjectAdded];
    Score* score = [self.scores objectForKey:[self.movieMap objectForKey:movie.canonicalTitle]];
    if (score != nil) {
        return score;
    }

    if (scores.count > 0) {
        score = [[[scores lastObject] retain] autorelease];
        [scores removeLastObject];
        return score;
    }

    return nil;
}


- (void) downloadReviews:(NSMutableArray*) scores {
    Location* location = [self.model.userLocationCache downloadUserAddressLocationBackgroundEntryPoint:self.model.userAddress];

    if (location == nil) {
        return;
    }

    Score* score;
    do {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        {
            score = [self getNextScore:scores];
            [self downloadReviews:score location:location];
        }
        [autoreleasePool release];
    } while (score != nil);
}


- (void) updateReviewsBackgroundEntryPoint:(NSDictionary*) scores {
    NSMutableArray* scoresWithoutReviews = [NSMutableArray array];
    NSMutableArray* scoresWithReviews = [NSMutableArray array];

    for (Score* score in scores.allValues) {
        NSString* file = [self reviewsFile:score.canonicalTitle];

        NSDate* lastLookupDate = [FileUtilities modificationDate:file];

        if (lastLookupDate == nil) {
            [scoresWithoutReviews addObject:score];
        } else {
            if (ABS([lastLookupDate timeIntervalSinceNow]) > (2 * ONE_DAY)) {
                [scoresWithReviews addObject:score];
            }
        }
    }

    [self downloadReviews:scoresWithoutReviews];
    [self downloadReviews:scoresWithReviews];
}


- (void) prioritizeMovie:(Movie*) movie {
    [prioritizedMovies addObject:movie];
}

@end