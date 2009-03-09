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

#import "Model.h"

#import "AbstractNavigationController.h"
#import "AlertUtilities.h"
#import "AmazonCache.h"
#import "Application.h"
#import "DateUtilities.h"
#import "DifferenceEngine.h"
#import "FileUtilities.h"
#import "GlobalActivityIndicator.h"
#import "IMDbCache.h"
#import "LargePosterCache.h"
#import "LocaleUtilities.h"
#import "Movie.h"
#import "MovieDetailsViewController.h"
#import "MutableNetflixCache.h"
#import "NetflixViewController.h"
#import "NetworkUtilities.h"
#import "AppDelegate.h"
#import "PersonPosterCache.h"
#import "PosterCache.h"
#import "StringUtilities.h"
#import "TrailerCache.h"
#import "Utilities.h"
#import "WikipediaCache.h"

@interface Model()
@property (retain) IMDbCache* imdbCache;
@property (retain) AmazonCache* amazonCache;
@property (retain) WikipediaCache* wikipediaCache;
@property (retain) PosterCache* posterCache;
@property (retain) PersonPosterCache* personPosterCache;
@property (retain) LargePosterCache* largePosterCache;
@property (retain) TrailerCache* trailerCache;
@property (retain) MutableNetflixCache* netflixCache;
@end

@implementation Model

static NSString* currentVersion = @"1.5.0";
static NSString* persistenceVersion = @"105";

static NSString* VERSION = @"version";

static NSString* RUN_COUNT                              = @"runCount";
static NSString* UNSUPPORTED_COUNTRY                    = @"unsupportedCountry";
static NSString* NETFLIX_KEY                            = @"netflixKey";
static NSString* NETFLIX_SECRET                         = @"netflixSecret";
static NSString* NETFLIX_USER_ID                        = @"netflixUserId";
static NSString* NETFLIX_FIRST_NAME                     = @"netflixFirstName";
static NSString* NETFLIX_LAST_NAME                      = @"netflixLastName";
static NSString* NETFLIX_CAN_INSTANT_WATCH              = @"netflixCanInstantWatch";
static NSString* NETFLIX_PREFERRED_FORMATS              = @"netflixPreferredFormats";
static NSString* NETFLIX_UPDATED_APPLICATION_KEYS       = @"netflixUpdatedApplicationKeys";


static NSString** ALL_KEYS[] = {
&VERSION,
&RUN_COUNT,
&NETFLIX_KEY,
&NETFLIX_SECRET,
&NETFLIX_USER_ID,
&NETFLIX_FIRST_NAME,
&NETFLIX_LAST_NAME,
&NETFLIX_CAN_INSTANT_WATCH,
&NETFLIX_PREFERRED_FORMATS
};


static NSString** STRING_KEYS_TO_MIGRATE[] = {
&NETFLIX_KEY,
&NETFLIX_SECRET,
&NETFLIX_USER_ID,
&NETFLIX_FIRST_NAME,
&NETFLIX_LAST_NAME,
};

static NSString** INTEGER_KEYS_TO_MIGRATE[] = {
};

static NSString** BOOLEAN_KEYS_TO_MIGRATE[] = {
&NETFLIX_CAN_INSTANT_WATCH,
&NETFLIX_UPDATED_APPLICATION_KEYS,
};

static NSString** STRING_ARRAY_KEYS_TO_MIGRATE[] = {
&NETFLIX_PREFERRED_FORMATS,
};

static NSString** MOVIE_ARRAY_KEYS_TO_MIGRATE[] = {
};


@synthesize imdbCache;
@synthesize amazonCache;
@synthesize wikipediaCache;
@synthesize posterCache;
@synthesize personPosterCache;
@synthesize largePosterCache;
@synthesize trailerCache;
@synthesize netflixCache;

- (void) dealloc {
    self.imdbCache = nil;
    self.amazonCache = nil;
    self.wikipediaCache = nil;
    self.posterCache = nil;
    self.personPosterCache = nil;
    self.largePosterCache = nil;
    self.trailerCache = nil;
    self.netflixCache = nil;

    [super dealloc];
}


+ (NSString*) version {
    return currentVersion;
}


+ (void) saveMovies:(NSArray*) movies key:(NSString*) key {
    NSMutableArray* encoded = [NSMutableArray array];
    for (Movie* movie in movies) {
        [encoded addObject:movie.dictionary];
    }

    [[NSUserDefaults standardUserDefaults] setObject:encoded forKey:key];
}


- (NSDictionary*) valuesToMigrate {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    for (NSInteger i = 0; i < ArrayLength(STRING_KEYS_TO_MIGRATE); i++) {
        NSString* key = *STRING_KEYS_TO_MIGRATE[i];
        id previousValue = [defaults objectForKey:key];
        if ([previousValue isKindOfClass:[NSString class]]) {
            [result setObject:previousValue forKey:key];
        }
    }

    for (NSInteger i = 0; i < ArrayLength(BOOLEAN_KEYS_TO_MIGRATE); i++) {
        NSString* key = *BOOLEAN_KEYS_TO_MIGRATE[i];
        id previousValue = [defaults objectForKey:key];
        if ([previousValue isKindOfClass:[NSNumber class]]) {
            [result setObject:previousValue forKey:key];
        }
    }

    for (NSInteger i = 0; i < ArrayLength(INTEGER_KEYS_TO_MIGRATE); i++) {
        NSString* key = *INTEGER_KEYS_TO_MIGRATE[i];
        id previousValue = [defaults objectForKey:key];
        if ([previousValue isKindOfClass:[NSNumber class]]) {
            [result setObject:previousValue forKey:key];
        }
    }

    for (NSInteger i = 0; i < ArrayLength(STRING_ARRAY_KEYS_TO_MIGRATE); i++) {
        NSString* key = *STRING_ARRAY_KEYS_TO_MIGRATE[i];
        id previousValue = [defaults objectForKey:key];
        if ([previousValue isKindOfClass:[NSArray class]]) {
            NSMutableArray* elements = [NSMutableArray array];
            for (id element in previousValue) {
                if ([element isKindOfClass:[NSString class]]) {
                    [elements addObject:element];
                }
            }

            [result setObject:elements forKey:key];
        }
    }

    for (NSInteger i = 0; i < ArrayLength(MOVIE_ARRAY_KEYS_TO_MIGRATE); i++) {
        NSString* key = *MOVIE_ARRAY_KEYS_TO_MIGRATE[i];
        id previousValue = [defaults objectForKey:key];
        if ([previousValue isKindOfClass:[NSArray class]]) {
            NSMutableArray* elements = [NSMutableArray array];
            for (id element in previousValue) {
                if ([element isKindOfClass:[NSDictionary class]] &&
                    [Movie canReadDictionary:element]) {
                    [elements addObject:element];
                }
            }

            [result setObject:elements forKey:key];
        }
    }

    return result;
}


- (void) synchronize {
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void) loadData {
    NSString* version = [[NSUserDefaults standardUserDefaults] objectForKey:VERSION];
    if (version == nil || ![persistenceVersion isEqual:version]) {
        // First, capture any preferences that we can safely migrate
        NSDictionary* currentValues = [self valuesToMigrate];

        // Now, wipe out all keys
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        for (int i = 0; i < ArrayLength(ALL_KEYS); i++) {
            NSString* key = *ALL_KEYS[i];
            [defaults removeObjectForKey:key];
        }

        // And delete and stored state
        [Application resetDirectories];

        // Now restore the saved preferences.
        for (NSString* key in currentValues) {
            [defaults setObject:[currentValues objectForKey:key] forKey:key];
        }

        // Mark that we updated successfully, and flush to disc.
        [[NSUserDefaults standardUserDefaults] setObject:persistenceVersion forKey:VERSION];
        [self synchronize];
    }
}


- (void) clearCaches {
    NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey:RUN_COUNT];
    [[NSUserDefaults standardUserDefaults] setInteger:(runCount + 1) forKey:RUN_COUNT];
    [self synchronize];

    if ((runCount % 5) == 0) {
        [Application clearStaleData];
    }
}


- (void) checkCountry {
    if ([LocaleUtilities isSupportedCountry]) {
        return;
    }

    // Only warn once per upgrade.
    NSString* key = [NSString stringWithFormat:@"%@-%@-%@", UNSUPPORTED_COUNTRY, currentVersion, [LocaleUtilities isoCountry]];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:key]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];

    NSString* warning =
    [NSString stringWithFormat:
    NSLocalizedString(@"Your %@'s country is set to: %@\n\nFull support for %@ is coming soon to your country, and several features are already available for you to use today! When more features become ready, you will automatically be notified of updates.", nil),
     [UIDevice currentDevice].localizedModel,
     [LocaleUtilities displayCountry],
     [Application name]];

    [AlertUtilities showOkAlert:warning];
}


- (void) updateNetflixKeys {
    BOOL updatedNetflixApplicationKeys = [[NSUserDefaults standardUserDefaults] boolForKey:NETFLIX_UPDATED_APPLICATION_KEYS];
    if (updatedNetflixApplicationKeys) {
        return;
    }

    [self setNetflixKey:nil secret:nil userId:nil];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:NETFLIX_UPDATED_APPLICATION_KEYS];
    [self synchronize];
}


- (id) init {
    if (self = [super init]) {
        [self checkCountry];
        [self loadData];
        [self updateNetflixKeys];

        self.personPosterCache = [PersonPosterCache cacheWithModel:self];
        self.largePosterCache = [LargePosterCache cacheWithModel:self];
        self.imdbCache = [IMDbCache cacheWithModel:self];
        self.amazonCache = [AmazonCache cacheWithModel:self];
        self.wikipediaCache = [WikipediaCache cacheWithModel:self];
        self.trailerCache = [TrailerCache cacheWithModel:self];
        self.posterCache = [PosterCache cacheWithModel:self];
        self.netflixCache = [MutableNetflixCache cacheWithModel:self];

        [self clearCaches];
    }

    return self;
}


+ (Model*) model {
    return [[[Model alloc] init] autorelease];
}


- (NSString*) netflixKey {
    return [[NSUserDefaults standardUserDefaults] objectForKey:NETFLIX_KEY];
}


- (NSString*) netflixSecret {
    return [[NSUserDefaults standardUserDefaults] objectForKey:NETFLIX_SECRET];
}


-(NSString*) netflixUserId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:NETFLIX_USER_ID];
}


-(NSString*) netflixFirstName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:NETFLIX_FIRST_NAME];
}


-(NSString*) netflixLastName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:NETFLIX_LAST_NAME];
}


- (BOOL) netflixCanInstantWatch {
    return [[NSUserDefaults standardUserDefaults] boolForKey:NETFLIX_CAN_INSTANT_WATCH];
}


- (NSArray*) netflixPreferredFormats {
    return [[NSUserDefaults standardUserDefaults] objectForKey:NETFLIX_PREFERRED_FORMATS];
}


- (void) setNetflixKey:(NSString*) key secret:(NSString*) secret userId:(NSString*) userId {
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:NETFLIX_USER_ID];
    [[NSUserDefaults standardUserDefaults] setObject:secret forKey:NETFLIX_SECRET];
    [[NSUserDefaults standardUserDefaults] setObject:key forKey:NETFLIX_KEY];
    [self synchronize];
}


- (void) setNetflixFirstName:(NSString*) firstName
                    lastName:(NSString*) lastName
             canInstantWatch:(BOOL) canInstantWatch
            preferredFormats:(NSArray*) preferredFormats {
    [[NSUserDefaults standardUserDefaults] setObject:firstName forKey:NETFLIX_FIRST_NAME];
    [[NSUserDefaults standardUserDefaults] setObject:lastName forKey:NETFLIX_LAST_NAME];
    [[NSUserDefaults standardUserDefaults] setBool:canInstantWatch forKey:NETFLIX_CAN_INSTANT_WATCH];
    [[NSUserDefaults standardUserDefaults] setObject:preferredFormats forKey:NETFLIX_PREFERRED_FORMATS];
}


- (NSArray*) scoreProvider {
    return [NSArray arrayWithObjects:
            @"RottenTomatoes",
            @"Metacritic",
            @"Google",
            NSLocalizedString(@"None", @"This is what a user picks when they don't want any reviews."), nil];
}


- (NSDate*) releaseDateForMovie:(Movie*) movie {
    return movie.releaseDate;
}


- (NSArray*) directorsForMovie:(Movie*) movie {
    NSArray* directors = movie.directors;
    if (directors.count > 0) {
        return directors;
    }

    directors = [netflixCache directorsForMovie:movie];
    if (directors.count > 0) {
        return directors;
    }

    return [NSArray array];
}


- (NSArray*) castForMovie:(Movie*) movie {
    NSArray* cast = movie.cast;
    if (cast.count > 0) {
        return cast;
    }

    cast = [netflixCache castForMovie:movie];
    if (cast.count > 0) {
        return cast;
    }

    return [NSArray array];
}


- (NSArray*) genresForMovie:(Movie*) movie {
    return movie.genres;
}


- (NSString*) imdbAddressForMovie:(Movie*) movie {
    NSString* result = movie.imdbAddress;
    if (result.length > 0) {
        return result;
    }

    result = [imdbCache imdbAddressForMovie:movie];
    if (result.length > 0) {
        return result;
    }

    return nil;
}


- (NSString*) amazonAddressForMovie:(Movie*) movie {
    return [amazonCache amazonAddressForMovie:movie];
}


- (NSString*) netflixAddressForMovie:(Movie*) movie {
    return [netflixCache netflixAddressForMovie:movie];
}


- (NSString*) wikipediaAddressForMovie:(Movie*) movie {
    return [wikipediaCache wikipediaAddressForMovie:movie];
}


- (UIImage*) posterForMovie:(Movie*) movie
                    sources:(NSArray*) sources
                   selector:(SEL) selector {
    for (id source in sources) {
        UIImage* image = [source performSelector:selector withObject:movie];
        if (image != nil) {
            return image;
        }
    }

    return nil;
}


- (UIImage*) posterForMovie:(Movie*) movie {
    return [self posterForMovie:movie
                        sources:[NSArray arrayWithObjects:posterCache, largePosterCache, nil]
                       selector:@selector(posterForMovie:)];
}


- (UIImage*) smallPosterForMovie:(Movie*) movie {
    return [self posterForMovie:movie
                        sources:[NSArray arrayWithObjects:posterCache, largePosterCache, nil]
                       selector:@selector(smallPosterForMovie:)];
}


- (UIImage*) posterForPerson:(Person*) person {
    return [personPosterCache posterForPerson:person];
}


- (UIImage*) smallPosterForPerson:(Person*) person {
    return [personPosterCache smallPosterForPerson:person];
}


NSInteger compareMoviesByReleaseDateDescending(id t1, id t2, void* context) {
    if (t1 == t2) {
        return NSOrderedSame;
    }

    Model* model = context;
    Movie* movie1 = t1;
    Movie* movie2 = t2;

    NSDate* releaseDate1 = [model releaseDateForMovie:movie1];
    NSDate* releaseDate2 = [model releaseDateForMovie:movie2];

    if (releaseDate1 == nil) {
        if (releaseDate2 == nil) {
            return compareMoviesByTitle(movie1, movie2, context);
        } else {
            return NSOrderedDescending;
        }
    } else if (releaseDate2 == nil) {
        return NSOrderedAscending;
    }

    return -[releaseDate1 compare:releaseDate2];
}


NSInteger compareMoviesByReleaseDateAscending(id t1, id t2, void* context) {
    return -compareMoviesByReleaseDateDescending(t1, t2, context);
}


NSInteger compareMoviesByTitle(id t1, id t2, void* context) {
    if (t1 == t2) {
        return NSOrderedSame;
    }

    Movie* movie1 = t1;
    Movie* movie2 = t2;

    return [movie1.displayTitle compare:movie2.displayTitle options:NSCaseInsensitiveSearch];
}


- (NSString*) synopsisForMovie:(Movie*) movie {
    NSMutableArray* options = [NSMutableArray array];
    NSString* synopsis = movie.synopsis;
    if (synopsis.length > 0) {
        [options addObject:synopsis];
    }

    if (options.count == 0 || [LocaleUtilities isEnglish]) {
        synopsis = [netflixCache synopsisForMovie:movie];
        if (synopsis.length > 0) {
            [options addObject:synopsis];
        }
    }

    if (options.count == 0) {
        return NSLocalizedString(@"No synopsis available.", nil);
    }


    NSString* bestOption = @"";
    for (NSString* option in options) {
        if (option.length > bestOption.length) {
            bestOption = option;
        }
    }

    return bestOption;
}


- (NSArray*) trailersForMovie:(Movie*) movie {
    return [trailerCache trailersForMovie:movie];
}


- (NSString*) noInformationFound {
    if ([GlobalActivityIndicator hasVisibleBackgroundTasks]) {
        return NSLocalizedString(@"Downloading data", nil);
    } else if (![NetworkUtilities isNetworkAvailable]) {
        return NSLocalizedString(@"Network unavailable", nil);
    } else if (![LocaleUtilities isSupportedCountry]) {
        return [NSString stringWithFormat:
                NSLocalizedString(@"Local results unavailable", nil),
                [LocaleUtilities displayCountry]];
    } else {
        return NSLocalizedString(@"No information found", nil);
    }
}


- (void) prioritizeMovie:(Movie*) movie {
    [posterCache prioritizeMovie:movie];
    [trailerCache prioritizeMovie:movie];
    [imdbCache prioritizeMovie:movie];
    [amazonCache prioritizeMovie:movie];
    [wikipediaCache prioritizeMovie:movie];
    [netflixCache prioritizeMovie:movie];
}


- (void) prioritizePerson:(Person*) person {
    [netflixCache prioritizePerson:person];
    [personPosterCache prioritizePerson:person];
}


- (NSString*) feedbackUrl {
    NSString* body = [NSString stringWithFormat:@"\n\nVersion: %@\nCountry: %@\nLanguage: %@",
                      currentVersion,
                      [LocaleUtilities englishCountry],
                      [LocaleUtilities englishLanguage]];

    body = [body stringByAppendingFormat:@"\n\nNetflix:\nUser ID: %@\nKey: %@\nSecret: %@",
            [StringUtilities nonNilString:self.netflixUserId],
            [StringUtilities nonNilString:self.netflixKey],
            [StringUtilities nonNilString:self.netflixSecret]];

    NSString* subject;
    if ([LocaleUtilities isJapanese]) {
        subject = [StringUtilities stringByAddingPercentEscapes:@"PocketFlicksのフィードバック"];
    } else {
        subject = @"PocketFlicks%20Feedback";
    }

    NSString* encodedBody = [StringUtilities stringByAddingPercentEscapes:body];
    NSString* result = [NSString stringWithFormat:@"mailto:cyrus.najmabadi@gmail.com?subject=%@&body=%@", subject, encodedBody];
    return result;
}


- (BOOL) isBookmarked:(Movie*) movie {
    return NO;
}


- (BOOL) screenRotationEnabled {
    return YES;
}

@end