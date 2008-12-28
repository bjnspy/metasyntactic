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

#import "NetflixCache.h"

#import "Application.h"
#import "DateUtilities.h"
#import "DifferenceEngine.h"
#import "Feed.h"
#import "FileUtilities.h"
#import "GlobalActivityIndicator.h"
#import "ImageUtilities.h"
#import "IMDbCache.h"
#import "LinkedSet.h"
#import "Movie.h"
#import "NetflixAddMovieDelegate.h"
#import "NetflixMoveMovieDelegate.h"
#import "NetflixModifyQueueDelegate.h"
#import "NetworkUtilities.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "IdentitySet.h"
#import "Queue.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"
#import "XmlElement.h"

@interface NetflixCache()
@property (retain) NSArray* feedsData;
@property (retain) NSMutableDictionary* queues;
@property (retain) LinkedSet* normalMovies;
@property (retain) LinkedSet* searchMovies;
@property (retain) LinkedSet* prioritizedMovies;
@property (retain) NSCondition* updateDetailsLock;
@property (retain) NSDate* lastQuotaErrorDate;

- (void) updateDetails:(Movie*) movie;
@end


@implementation NetflixCache

static NSString* cast_key = @"cast";
static NSString* title_key = @"title";
static NSString* series_key = @"series";
static NSString* formats_key = @"formats";
static NSString* synopsis_key = @"synopsis";
static NSString* directors_key = @"directors";
static NSString* average_rating_key = @"average_rating";

@synthesize feedsData;
@synthesize queues;
@synthesize normalMovies;
@synthesize searchMovies;
@synthesize prioritizedMovies;
@synthesize updateDetailsLock;
@synthesize lastQuotaErrorDate;

- (void) dealloc {
    self.feedsData = nil;
    self.queues = nil;
    self.normalMovies = nil;
    self.searchMovies = nil;
    self.prioritizedMovies = nil;
    self.updateDetailsLock = nil;
    self.lastQuotaErrorDate = nil;
    
    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super initWithModel:model_]) {
        self.queues = [NSMutableDictionary dictionary];
        
        self.normalMovies = [LinkedSet set];
        self.searchMovies = [LinkedSet set];
        self.prioritizedMovies = [LinkedSet setWithCountLimit:8];
        self.updateDetailsLock = [[[NSCondition alloc] init] autorelease];
        
        [ThreadingUtilities backgroundSelector:@selector(updateDetailsBackgroundEntryPoint)
                                      onTarget:self
                                          gate:nil
                                       visible:NO];
    }
    
    return self;
}


- (NSString*) noInformationFound {
    if ([GlobalActivityIndicator hasVisibleBackgroundTasks]) {
        return NSLocalizedString(@"Downloading data", nil);
    } else if (![NetworkUtilities isNetworkAvailable]) {
        return NSLocalizedString(@"Network unavailable", nil);
    } else {
        return NSLocalizedString(@"No information found", nil);
    }
}


- (NSString*) feedsFile {
    return [[Application netflixDirectory] stringByAppendingPathComponent:@"Feeds.plist"];
}


- (NSArray*) loadFeeds {
    NSArray* array = [FileUtilities readObject:self.feedsFile];
    if (array.count == 0) {
        return [NSArray array];
    }
    
    NSMutableArray* result = [NSMutableArray array];
    for (NSDictionary* dictionary in array) {
        [result addObject:[Feed feedWithDictionary:dictionary]];
    }
    return result;
}


- (NSArray*) feeds {
    if (feedsData == nil) {
        self.feedsData = [self loadFeeds];
    }
    
    return feedsData;
}


- (NSString*) queueFile:(NSString*) key {
    return [[[Application netflixQueuesDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:key]]
            stringByAppendingPathExtension:@"plist"];
}


- (NSString*) queueEtagFile:(Queue*) queue {
    NSString* name = [NSString stringWithFormat:@"%@-etag", queue.feed.key];
    return [[[Application netflixQueuesDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:name]]
            stringByAppendingPathExtension:@"plist"];
}


- (Queue*) loadQueue:(Feed*) feed {
    NSDictionary* dictionary = [FileUtilities readObject:[self queueFile:feed.key]];
    if (dictionary.count == 0) {
        return nil;
    }
    
    return [Queue queueWithDictionary:dictionary];
}


- (Queue*) queueForFeed:(Feed*) feed {
    if (feed == nil) {
        return nil;
    }
    
    Queue* queue = [queues objectForKey:feed.key];
    if (queue == nil) {
        queue = [self loadQueue:feed];
        if (queue != nil) {
            [queues setObject:queue forKey:feed.key];
        }
    }
    return queue;
}


- (void) clear {
    [Application resetNetflixDirectories];
    self.feedsData = nil;
    self.queues = nil;
    
    [NowPlayingAppDelegate majorRefresh:YES];
}


- (void) update {
    if (model.netflixUserId.length == 0) {
        [self clear];
        return;
    }
    
    [ThreadingUtilities backgroundSelector:@selector(updateBackgroundEntryPoint)
                                  onTarget:self
                                      gate:gate
                                   visible:YES];
}


- (NSArray*) downloadFeeds {
    NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/feeds", model.netflixUserId];
    OAMutableURLRequest* request = [self createURLRequest:address];
    
    [request prepare];
    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request
                                                              important:YES];
    
    [self checkApiResult:element];
    
    NSSet* allowableFeeds = [NSSet setWithObjects:
                             [NetflixCache dvdQueueKey],
                             [NetflixCache instantQueueKey],
                             [NetflixCache atHomeKey],
                             [NetflixCache recommendationKey],
                             [NetflixCache rentalHistoryKey],
                             [NetflixCache rentalHistoryWatchedKey],
                             [NetflixCache rentalHistoryReturnedKey], nil];
    
    NSMutableArray* feeds = [NSMutableArray array];
    for (XmlElement* child in element.children) {
        if ([child.name isEqual:@"link"]) {
            NSString* key = [child attributeValue:@"rel"];
            
            if ([allowableFeeds containsObject:key]) {
                Feed* feed = [Feed feedWithUrl:[child attributeValue:@"href"]
                                           key:key
                                          name:[child attributeValue:@"title"]];
                
                [feeds addObject:feed];
            }
        }
    }
    
    return feeds;
}


- (void) saveFeeds:(NSArray*) feeds {
    NSMutableArray* result = [NSMutableArray array];
    
    for (Feed* feed in feeds) {
        [result addObject:feed.dictionary];
    }
    
    [FileUtilities writeObject:result toFile:self.feedsFile];
}


+ (Movie*) processItem:(XmlElement*) element
                 saved:(BOOL*) saved {
    if (element == nil) {
        return nil;
    }
    
    NSMutableDictionary* additionalFields = [NSMutableDictionary dictionary];
    
    NSString* identifier = nil;
    NSString* title = nil;
    NSString* link = nil;
    NSString* poster = nil;
    NSString* rating = nil;
    NSString* year = nil;
    NSMutableArray* genres = [NSMutableArray array];
    BOOL save = NO;
    
    for (XmlElement* child in element.children) {
        if ([@"id" isEqual:child.name]) {
            identifier = child.text;
        } else if ([@"link" isEqual:child.name]) {
            NSString* rel = [child attributeValue:@"rel"];
            if ([@"alternate" isEqual:rel]) {
                link = [child attributeValue:@"href"];
            } else if ([@"http://schemas.netflix.com/catalog/title" isEqual:rel]) {
                [additionalFields setObject:[child attributeValue:@"href"] forKey:title_key];
            } else if ([@"http://schemas.netflix.com/catalog/people.cast" isEqual:rel]) {
                [additionalFields setObject:[child attributeValue:@"href"] forKey:cast_key];
            } else if ([@"http://schemas.netflix.com/catalog/people.directors" isEqual:rel]) {
                [additionalFields setObject:[child attributeValue:@"href"] forKey:directors_key];
            } else if ([@"http://schemas.netflix.com/catalog/titles/synopsis" isEqual:rel]) {
                [additionalFields setObject:[child attributeValue:@"href"] forKey:synopsis_key];
            } else if ([@"http://schemas.netflix.com/catalog/titles.series" isEqual:rel]) {
                [additionalFields setObject:[child attributeValue:@"href"] forKey:series_key];
            } else if ([@"http://schemas.netflix.com/catalog/titles/format_availability" isEqual:rel]) {
                [additionalFields setObject:[child attributeValue:@"href"] forKey:formats_key];
            }
        } else if ([@"title" isEqual:child.name]) {
            title = [child attributeValue:@"short"];
            if (title == nil) {
                title = [child attributeValue:@"medium"];
            }
        } else if ([@"box_art" isEqual:child.name]) {
            poster = [child attributeValue:@"large"];
            if (poster == nil) {
                poster = [child attributeValue:@"medium"];
                if (poster == nil) {
                    poster = [child attributeValue:@"small"];
                }
            }
        } else if ([@"category" isEqual:child.name]) {
            NSString* scheme = [child attributeValue:@"scheme"];
            if ([@"http://api.netflix.com/categories/mpaa_ratings" isEqual:scheme]) {
                rating = [child attributeValue:@"label"];
            } else if ([@"http://api.netflix.com/categories/genres" isEqual:scheme]) {
                [genres addObject:[child attributeValue:@"label"]];
            } else if ([@"http://api.netflix.com/categories/queue_availability" isEqual:scheme]) {
                save = [[child attributeValue:@"label"] isEqual:@"saved"];
            }
        } else if ([@"release_year" isEqual:child.name]) {
            year = child.text;
        } else if ([average_rating_key isEqual:child.name]) {
            [additionalFields setObject:child.text forKey:average_rating_key];
        }
    }
    
    NSDate* date = nil;
    if (year.length > 0) {
        date = [DateUtilities dateWithNaturalLanguageString:year];
    }
    Movie* movie = [Movie movieWithIdentifier:identifier
                                        title:title
                                       rating:rating
                                       length:0
                                  releaseDate:date
                                  imdbAddress:nil
                                       poster:poster
                                     synopsis:nil
                                       studio:nil
                                    directors:nil
                                         cast:nil
                                       genres:genres
                             additionalFields:additionalFields];
    
    if (saved != NULL) {
        *saved = save;
    }
    
    return movie;
}


+ (void) processItem:(XmlElement*) element
              movies:(NSMutableArray*) movies
               saved:(NSMutableArray*) saved {
    if (![@"queue_item" isEqual:element.name] &&
        ![@"rental_history_item" isEqual:element.name] &&
        ![@"at_home_item" isEqual:element.name] &&
        ![@"recommendation" isEqual:element.name] &&
        ![@"catalog_title" isEqual:element.name]) {
        return;
    }
    
    BOOL save;
    Movie* movie = [self processItem:element saved:&save];
    
    if (save) {
        [saved addObject:movie];
    } else {
        [movies addObject:movie];
    }
}


- (void) saveQueue:(Queue*) queue {
    [FileUtilities writeObject:queue.dictionary toFile:[self queueFile:queue.feed.key]];
    [FileUtilities writeObject:queue.etag toFile:[self queueEtagFile:queue]];
}


- (NSString*) downloadEtag:(Feed*) feed {
    NSRange range = [feed.url rangeOfString:@"&output=atom"];
    NSString* url = feed.url;
    if (range.length > 0) {
        url = [NSString stringWithFormat:@"%@%@", [url substringToIndex:range.location], [url substringFromIndex:range.location + range.length]];
    }
    
    NSString* address = [NSString stringWithFormat:@"%@&max_results=1", url];
    
    XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:address
                                                           important:YES];
    
    return [[element element:@"etag"] text];
}


- (BOOL) etagChanged:(Feed*) feed {
    Queue* queue = [self queueForFeed:feed];
    NSString* localEtag = queue.etag;
    if (localEtag.length == 0) {
        return YES;
    }
    
    NSString* serverEtag = [self downloadEtag:feed];
    
    return ![serverEtag isEqual:localEtag];
}


+ (void) processMovieItemList:(XmlElement*) element
                       movies:(NSMutableArray*) movies
                        saved:(NSMutableArray*) saved {
    for (XmlElement* child in element.children) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            [self processItem:child
                       movies:movies
                        saved:saved];
        }
        [pool release];
    }
}


- (NSArray*) search:(NSString*) query {
    OAMutableURLRequest* request = [self createURLRequest:@"http://api.netflix.com/catalog/titles"];
    
    NSArray* parameters = [NSArray arrayWithObject:
                           [OARequestParameter parameterWithName:@"term" value:query]];
    
    [request setParameters:parameters];
    [request prepare];
    
    XmlElement* element =
    [NetworkUtilities xmlWithContentsOfUrlRequest:request
                                        important:YES];
    
    [self checkApiResult:element];
    
    NSMutableArray* movies = [NSMutableArray array];
    NSMutableArray* saved = [NSMutableArray array];
    [NetflixCache processMovieItemList:element movies:movies saved:saved];
    
    [movies addObjectsFromArray:saved];
    
    if (movies.count > 0) {
        [searchMovies setArray:movies];
    }
    
    return movies;
}


- (void) downloadQueue:(Feed*) feed {
    // first download and check the feed's current etag against the current one.
    if (![self etagChanged:feed]) {
        return;
    }
    
    NSRange range = [feed.url rangeOfString:@"&output=atom"];
    NSString* url = feed.url;
    if (range.length > 0) {
        url = [NSString stringWithFormat:@"%@%@", [url substringToIndex:range.location], [url substringFromIndex:range.location + range.length]];
    }
    
    NSString* address = [NSString stringWithFormat:@"%@&max_results=500", url];
    
    XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:address
                                                           important:YES];
    
    NSString* etag = [[element element:@"etag"] text];
    
    NSMutableArray* movies = [NSMutableArray array];
    NSMutableArray* saved = [NSMutableArray array];
    
    [NetflixCache processMovieItemList:element movies:movies saved:saved];
    
    if (movies.count > 0 || saved.count > 0) {
        Queue* queue = [Queue queueWithFeed:feed
                                       etag:etag
                                     movies:movies
                                      saved:saved];
        [self saveQueue:queue];
        [self performSelectorOnMainThread:@selector(reportQueue:)
                               withObject:queue
                            waitUntilDone:NO];
    }
}


- (void) reportQueue:(Queue*) queue {
    NSAssert([NSThread isMainThread], nil);
    [queues setObject:queue forKey:queue.feed.key];
    [NowPlayingAppDelegate majorRefresh];
}


- (void) downloadQueues:(NSArray*) feeds {
    for (Feed* feed in feeds) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            [self downloadQueue:feed];
        }
        [pool release];
    }
}


- (void) updateBackgroundEntryPoint {
    if (model.netflixUserId.length == 0) {
        return;
    }
    
    NSArray* feeds = [self downloadFeeds];
    if (feeds.count > 0) {
        [self saveFeeds:feeds];
        [self performSelectorOnMainThread:@selector(reportFeeds:)
                               withObject:feeds
                            waitUntilDone:NO];
        
        [self downloadQueues:feeds];
    }
    
    [updateDetailsLock lock];
    {
        for (NSInteger i = self.feeds.count - 1; i >= 0; i--) {
            Feed* feed = [self.feeds objectAtIndex:i];
            
            Queue* queue = [self queueForFeed:feed];
            if (queue != nil) {
                [normalMovies addObjectsFromArray:queue.saved];
                [normalMovies addObjectsFromArray:queue.movies];
            }
        }
        [updateDetailsLock signal];
    }
    [updateDetailsLock unlock];
}


- (NSString*) posterFile:(Movie*) movie {
    return
    [[[Application netflixPostersDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"jpg"];
}


- (NSString*) smallPosterFile:(Movie*) movie {
    NSString* fileName = [FileUtilities sanitizeFileName:movie.canonicalTitle];
    fileName = [fileName stringByAppendingString:@"-small.png"];
    return [[Application netflixPostersDirectory] stringByAppendingPathComponent:fileName];
}


- (void) updatePoster:(Movie*) movie {
    if (movie.poster.length == 0) {
        return;
    }
    
    NSString* path = [self posterFile:movie];
    if ([FileUtilities fileExists:path]) {
        return;
    }
    
    NSData* data = [NetworkUtilities dataWithContentsOfAddress:movie.poster important:NO];
    if (data.length > 0) {
        [FileUtilities writeData:data toFile:path];
        [NowPlayingAppDelegate minorRefresh];
    }
}


- (NSString*) synopsisFile:(Movie*) movie {
    return
    [[[Application netflixSynopsesDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (NSString*) cleanupSynopsis:(NSString*) synopsis {
    NSInteger index = 0;
    
    NSRange range;
    while ((range = [synopsis rangeOfString:@"<a href"
                                    options:0
                                      range:NSMakeRange(index, synopsis.length - index)]).length > 0) {
        index = range.location + 1;
        NSRange closeAngleRange = [synopsis rangeOfString:@">"
                                                  options:0
                                                    range:NSMakeRange(range.location, synopsis.length - range.location)];
        if (closeAngleRange.length > 0) {
            synopsis = [NSString stringWithFormat:@"%@%@", [synopsis substringToIndex:range.location], [synopsis substringFromIndex:closeAngleRange.location + 1]];
        }
    }
    
    
    index = 0;
    while ((range = [synopsis rangeOfString:@"&#x"
                                    options:0
                                      range:NSMakeRange(index, synopsis.length - index)]).length > 0) {
        NSRange semiColonRange = [synopsis rangeOfString:@";" options:0 range:NSMakeRange(range.location, synopsis.length - range.location)];
        
        index = range.location + 1;
        if (semiColonRange.length > 0) {
            NSScanner* scanner = [NSScanner scannerWithString:synopsis];
            [scanner setScanLocation:range.location + 3];
            unsigned hex;
            if ([scanner scanHexInt:&hex] && hex > 0) {
                synopsis = [NSString stringWithFormat:@"%@%@%@",
                            [synopsis substringToIndex:range.location],
                            [Utilities stringFromUnichar:(unichar) hex],
                            [synopsis substringFromIndex:semiColonRange.location + 1]];
            }
        }
    }
    
    synopsis = [Utilities stripHtmlCodes:synopsis];
    synopsis = [synopsis stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return synopsis;
}


- (void) updateSynopsis:(Movie*) movie  {
    NSString* address = [movie.additionalFields objectForKey:synopsis_key];
    if (address.length == 0) {
        return;
    }
    
    NSString* path = [self synopsisFile:movie];
    if ([FileUtilities fileExists:path]) {
        return;
    }
    
    OAMutableURLRequest* request = [self createURLRequest:address];
    [request prepare];
    
    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request important:NO];
    
    [self checkApiResult:element];
    
    NSString* synopsis = element.text;
    synopsis = [self cleanupSynopsis:synopsis];
    
    if (synopsis.length > 0) {
        [FileUtilities writeObject:synopsis toFile:path];
        [NowPlayingAppDelegate minorRefresh];
    }
}


- (NSString*) castFile:(Movie*) movie {
    return
    [[[Application netflixCastDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (NSArray*) extractPeople:(XmlElement*) element {
    NSMutableArray* cast = [NSMutableArray array];
    
    for (XmlElement* child in element.children) {
        if (cast.count >= 6) {
            // cap the number of actors we care about
            break;
        }
        
        if (![child.name isEqual:@"person"]) {
            continue;
        }
        
        NSString* name = [[child element:@"name"] text];
        if (name.length > 0) {
            [cast addObject:name];
        }
    }
    
    return cast;
}


- (void)       updateCast:(Movie*) movie {
    NSString* address = [movie.additionalFields objectForKey:cast_key];
    if (address.length == 0) {
        return;
    }
    
    NSString* path = [self castFile:movie];
    if ([FileUtilities fileExists:path]) {
        return;
    }
    
    OAMutableURLRequest* request = [self createURLRequest:address];
    [request prepare];
    
    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request important:NO];
    
    [self checkApiResult:element];
    
    NSArray* cast = [self extractPeople:element];
    if (cast.count > 0) {
        [FileUtilities writeObject:cast toFile:path];
        [NowPlayingAppDelegate minorRefresh];
    }
}


- (NSString*) directorsFile:(Movie*) movie {
    return [[[Application netflixDirectorsDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (void) updateDirectors:(Movie*) movie {
    NSString* address = [movie.additionalFields objectForKey:directors_key];
    if (address.length == 0) {
        return;
    }
    
    NSString* path = [self directorsFile:movie];
    if ([FileUtilities fileExists:path]) {
        return;
    }
    
    OAMutableURLRequest* request = [self createURLRequest:address];
    [request prepare];
    
    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request important:NO];
    
    [self checkApiResult:element];
    
    NSArray* directors = [self extractPeople:element];
    if (directors.count > 0) {
        [FileUtilities writeObject:directors toFile:path];
        [NowPlayingAppDelegate minorRefresh];
    }
}


- (NSString*) formatsFile:(Movie*) movie {
    return [[[Application netflixFormatsDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (void) updateFormats:(Movie*) movie {
    NSString* address = [movie.additionalFields objectForKey:formats_key];
    if (address.length == 0) {
        return;
    }
    
    NSString* path = [self formatsFile:movie];
    if ([FileUtilities fileExists:path]) {
        return;
    }
    
    OAMutableURLRequest* request = [self createURLRequest:address];
    [request prepare];
    
    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request important:NO];
    
    [self checkApiResult:element];
    
    NSMutableArray* formats = [NSMutableArray array];
    for (XmlElement* child in element.children) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            if ([@"availability" isEqual:child.name]) {
                for (XmlElement* grandChild in child.children) {
                    if ([@"category" isEqual:grandChild.name] &&
                        [@"http://api.netflix.com/categories/title_formats" isEqual:[grandChild attributeValue:@"scheme"]]) {
                        [formats addObject:[grandChild attributeValue:@"label"]];
                    }
                }
            }
        }
        [pool release];
    }
    
    if (formats.count > 0) {
        [FileUtilities writeObject:formats toFile:path];
    }
}


- (void) updateIMDb:(Movie*) movie {
    [model.imdbCache updateMovie:movie];
}


- (NSString*) seriesFile:(NSString*) seriesKey {
    return
    [[[Application netflixSeriesDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:seriesKey]]
     stringByAppendingPathExtension:@"plist"];
}


- (void) updateSeries:(Movie*) movie {
    NSString* seriesKey = [movie.additionalFields objectForKey:series_key];
    if (seriesKey.length == 0) {
        return;
    }
    
    NSString* file = [self seriesFile:seriesKey];
    if ([FileUtilities fileExists:file]) {
        return;
    }
    
    OAMutableURLRequest* request = [self createURLRequest:seriesKey];
    [request prepare];
    
    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request
                                                              important:NO];
    
    [self checkApiResult:element];
    
    Movie* series = [NetflixCache processItem:element saved:NULL];
    if (series == nil) {
        return;
    }
    
    [FileUtilities writeObject:series.dictionary toFile:file];
    [self updateDetails:series];
}


- (BOOL) isSeriesDisc:(Movie*) movie {
    return [movie.additionalFields objectForKey:series_key] != nil;
}


- (Movie*) seriesForDisc:(Movie*) movie {
    NSDictionary* dictionary = [FileUtilities readObject:[self seriesFile:[movie.additionalFields objectForKey:series_key]]];
    if (dictionary == nil) {
        return nil;
    }
    
    return [Movie movieWithDictionary:dictionary];
}


- (Movie*) promoteDiscToSeries:(Movie*) disc {
    Movie* series = [self seriesForDisc:disc];
    if (series == nil) {
        return disc;
    }
    return series;
}


- (NSString*) userRatingsFile:(Movie*) movie {
    return [[[Application netflixUserRatingsDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]]
            stringByAppendingPathExtension:@"plist"];
    
}


- (NSString*) predictedRatingsFile:(Movie*) movie {
    return [[[Application netflixPredictedRatingsDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]]
            stringByAppendingPathExtension:@"plist"];
    
}


- (void) updateRatings:(Movie*) movie {
    NSString* userRatingsFile = [self userRatingsFile:movie];
    NSString* predictedRatingsFile = [self predictedRatingsFile:movie];
    
    if ([FileUtilities fileExists:userRatingsFile] &&
        [FileUtilities fileExists:predictedRatingsFile]) {
        return;
    }
    
    NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/ratings/title", model.netflixUserId];
    OAMutableURLRequest* request = [self createURLRequest:address];
    OARequestParameter* parameter = [OARequestParameter parameterWithName:@"title_refs" value:movie.identifier];
    [request setParameters:[NSArray arrayWithObject:parameter]];
    [request prepare];
    
    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request
                                                              important:NO];
    
    [self checkApiResult:element];
    
    XmlElement* ratingsItemElment = [element element:@"ratings_item"];
    if (ratingsItemElment == nil) {
        return;
    }
    
    NSString* userRating = [[ratingsItemElment element:@"user_rating"] text];
    NSString* predictedRating = [[ratingsItemElment element:@"predicted_rating"] text];
    
    if (userRating.length == 0) {
        userRating = @"";
    }
    
    if (predictedRating.length == 0) {
        predictedRating = @"";
    }
    
    [FileUtilities writeObject:userRating toFile:userRatingsFile];
    [FileUtilities writeObject:predictedRating toFile:predictedRatingsFile];
    [NowPlayingAppDelegate minorRefresh];
}


- (void) updateDetails:(Movie*) movie {
    if (movie == nil) {
        return;
    }
    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
        [self updateSeries:movie];
        
        // we download the formats for both a series and a disc.
        [self updateSynopsis:movie];
        
        if (![self isSeriesDisc:movie]) {
            // we don't download this stuff on a per disc basis.  only for a series.
            [self updatePoster:movie];
            [self updateCast:movie];
            [self updateDirectors:movie];
            [self updateIMDb:movie];
            [self updateRatings:movie];
        }

        [self updateFormats:movie];
    }
    [pool release];
}


- (void) addSearchResult:(Movie*) movie {
    if (![movie isNetflix]) {
        return;
    }
    
    [updateDetailsLock lock];
    {
        [searchMovies addObject:movie];
        [updateDetailsLock signal];
    }
    [updateDetailsLock unlock];
}


- (void) prioritizeMovie:(Movie*) movie {
    if (![movie isNetflix]) {
        return;
    }
    
    [updateDetailsLock lock];
    {
        [prioritizedMovies addObject:movie];
        [updateDetailsLock signal];
    }
    [updateDetailsLock unlock];
}


- (void) updateDetailsBackgroundEntryPoint {
    while (YES) {
        Movie* movie = nil;
        [updateDetailsLock lock];
        {
            while ((movie = [prioritizedMovies removeLastObjectAdded]) == nil &&
                   (movie = [searchMovies removeLastObjectAdded]) == nil &&
                   (movie = [normalMovies removeLastObjectAdded]) == nil) {
                [updateDetailsLock wait];
            }
        }
        [updateDetailsLock unlock];
        
        [self updateDetails:movie];
    }
}


- (BOOL) feedsContainsKey:(NSString*) key {
    for (Feed* feed in self.feeds) {
        if ([feed.key isEqual:key]) {
            return YES;
        }
    }
    
    return NO;
}



- (void) reportFeeds:(NSArray*) feeds {
    NSAssert([NSThread isMainThread], nil);
    
    self.feedsData = feeds;
    
    for (NSString* key in self.queues.allKeys) {
        if (![self feedsContainsKey:key]) {
            [self.queues removeObjectForKey:key];
        }
    }
    
    [NowPlayingAppDelegate majorRefresh];
}


- (UIImage*) posterForMovie:(Movie*) movie {
    movie = [self promoteDiscToSeries:movie];
    
    NSData* data = [FileUtilities readData:[self posterFile:movie]];
    return [UIImage imageWithData:data];
}


- (UIImage*) smallPosterForMovie:(Movie*) movie {
    movie = [self promoteDiscToSeries:movie];
    
    NSString* smallPosterPath = [self smallPosterFile:movie];
    NSData* smallPosterData;
    
    if ([FileUtilities size:smallPosterPath] == 0) {
        NSData* normalPosterData = [FileUtilities readData:[self posterFile:movie]];
        smallPosterData = [ImageUtilities scaleImageData:normalPosterData
                                                toHeight:SMALL_POSTER_HEIGHT];
        
        [FileUtilities writeData:smallPosterData
                          toFile:smallPosterPath];
    } else {
        smallPosterData = [FileUtilities readData:smallPosterPath];
    }
    
    return [UIImage imageWithData:smallPosterData];
}


- (NSArray*) castForMovie:(Movie*) movie {
    movie = [self promoteDiscToSeries:movie];
    
    return [FileUtilities readObject:[self castFile:movie]];
}


- (NSArray*) directorsForMovie:(Movie*) movie {
    movie = [self promoteDiscToSeries:movie];
    
    return [FileUtilities readObject:[self directorsFile:movie]];
}


- (NSString*) netflixRatingForMovie:(Movie*) movie {
    movie = [self promoteDiscToSeries:movie];
    
    NSString* rating = [FileUtilities readObject:[self predictedRatingsFile:movie]];
    if (rating.length > 0) {
        return rating;
    }
    
    return [movie.additionalFields objectForKey:average_rating_key];
}


- (NSString*) userRatingForMovie:(Movie*) movie {
    movie = [self promoteDiscToSeries:movie];
    
    return [FileUtilities readObject:[self userRatingsFile:movie]];
}


- (NSArray*) formatsForMovie:(Movie*) movie {
    return [FileUtilities readObject:[self formatsFile:movie]];
}


- (NSString*) synopsisForMovieWorker:(Movie*) movie {
    NSString* discSynopsis = [FileUtilities readObject:[self synopsisFile:movie]];
    NSString* seriesSynopsis = [FileUtilities readObject:[self synopsisFile:[self seriesForDisc:movie]]];
    
    if (discSynopsis.length == 0) {
        return seriesSynopsis;
    } else {
        if (seriesSynopsis.length == 0) {
            return discSynopsis;
        }
        
        return [NSString stringWithFormat:@"%@\n\n%@", discSynopsis, seriesSynopsis];
    }
}


- (NSString*) synopsisForMovie:(Movie*) movie {
    if (!movie.isNetflix) {
        return @"";
    }
    
    NSString* synopsis = [self synopsisForMovieWorker:movie];
    if (synopsis.length == 0) {
        return NSLocalizedString(@"Downloading information.", nil);
    }
    
    return synopsis;
}


- (Feed*) feedForKey:(NSString*) key {
    for (Feed* feed in self.feeds) {
        if ([key isEqual:feed.key]) {
            return feed;
        }
    }
    
    return nil;
}


- (Queue*) queueForKey:(NSString*) key {
    return [self queueForFeed:[self feedForKey:key]];
}


- (NSString*) titleForKey:(NSString*) key includeCount:(BOOL) includeCount {
    NSString* title = nil;
    if ([key isEqual:[NetflixCache dvdQueueKey]]) {
        title = NSLocalizedString(@"DVD/Blu-ray Queue", nil);
    } else if ([key isEqual:[NetflixCache instantQueueKey]]) {
        title = NSLocalizedString(@"Instant Queue", nil);
    } else if ([key isEqual:[NetflixCache atHomeKey]]) {
        title = NSLocalizedString(@"At Home", nil);
    } else if ([key isEqual:[NetflixCache rentalHistoryWatchedKey]]) {
        title = NSLocalizedString(@"Recently Watched", nil);
    } else if ([key isEqual:[NetflixCache rentalHistoryReturnedKey]]) {
        title = NSLocalizedString(@"Recently Returned", nil);
    } else if ([key isEqual:[NetflixCache rentalHistoryKey]]) {
        title = NSLocalizedString(@"Entire History", nil);
    } else if ([key isEqual:[NetflixCache recommendationKey]]) {
        title = NSLocalizedString(@"Recommendations", nil);
    }
    
    Queue* queue = [self queueForKey:key];
    if (queue == nil || !includeCount) {
        return title;
    }
    
    return [NSString stringWithFormat:NSLocalizedString(@"%@ (%d)", @"Netflix queue title and title count.  i.e: 'Instant Queue (45)'"),
            title, queue.movies.count + queue.saved.count];
}


- (NSString*) titleForKey:(NSString*) key {
    return [self titleForKey:key includeCount:YES];
}


- (BOOL) isEnqueued:(Movie*) movie inArray:(NSArray*) array {
    return [array containsObject:movie];
}


- (BOOL) isEnqueued:(Movie*) movie inQueue:(Queue*) queue {
    return
    [self isEnqueued:movie inArray:queue.movies] ||
    [self isEnqueued:movie inArray:queue.saved];
}


- (BOOL) isEnqueued:(Movie*) movie {
    return
    [self isEnqueued:movie inQueue:[self queueForKey:[NetflixCache dvdQueueKey]]] ||
    [self isEnqueued:movie inQueue:[self queueForKey:[NetflixCache instantQueueKey]]] ||
    [self isEnqueued:movie inQueue:[self queueForKey:[NetflixCache atHomeKey]]];
}


- (BOOL) hasAccount {
    return model.netflixUserId.length > 0;
}


- (Movie*) lookupMovieWorker:(Movie*) movie {
    OAMutableURLRequest* request = [self createURLRequest:@"http://api.netflix.com/catalog/titles"];
    
    NSArray* parameters = [NSArray arrayWithObjects:
                           [OARequestParameter parameterWithName:@"term" value:movie.canonicalTitle],
                           [OARequestParameter parameterWithName:@"max_results" value:@"1"], nil];
    
    [request setParameters:parameters];
    [request prepare];
    
    XmlElement* element =
    [NetworkUtilities xmlWithContentsOfUrlRequest:request
                                        important:YES];
    
    [self checkApiResult:element];
    
    NSMutableArray* movies = [NSMutableArray array];
    NSMutableArray* saved = [NSMutableArray array];
    [NetflixCache processMovieItemList:element movies:movies saved:saved];
    
    [movies addObjectsFromArray:saved];
    
    if (movies.count > 0) {
        Movie* netflixMovie = [movies objectAtIndex:0];
        if ([DifferenceEngine areSimilar:movie.canonicalTitle other:netflixMovie.canonicalTitle]) {
            return netflixMovie;
        }
    }
    
    return nil;
}


- (NSString*) netflixFile:(Movie*) movie {
    return [[[Application netflixSearchDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (void) lookupMovieBackgroundEntryPoint:(Movie*) movie {
    NSString* file = [self netflixFile:movie];
    if ([FileUtilities fileExists:file]) {
        return;
    }
    
    Movie* netflixMovie = [self lookupMovieWorker:movie];
    if (netflixMovie != nil) {
        [FileUtilities writeObject:netflixMovie.dictionary toFile:file];
        [self addSearchResult:netflixMovie];
        [NowPlayingAppDelegate minorRefresh];
    }
}


- (void) lookupNetflixMovieForLocalMovie:(Movie*) movie {
    if ([self hasAccount]) {
        [ThreadingUtilities backgroundSelector:@selector(lookupMovieBackgroundEntryPoint:)
                                      onTarget:self
                                      argument:movie
                                          gate:gate
                                       visible:NO];
    }
}


- (void) lookupNetflixMoviesForLocalMovies:(NSArray*) movies {
    if ([self hasAccount]) {
        [ThreadingUtilities backgroundSelector:@selector(lookupMoviesBackgroundEntryPoint:)
                                      onTarget:self
                                      argument:movies
                                          gate:gate
                                       visible:NO];
    }
}


- (void) lookupMoviesBackgroundEntryPoint:(NSArray*) movies {
    for (Movie* movie in movies) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            [self lookupMovieBackgroundEntryPoint:movie];
        }
        [pool release];
    }
}


- (Movie*) netflixMovieForMovie:(Movie*) movie {
    if (movie.isNetflix) {
        return movie;
    }
    
    NSString* file = [self netflixFile:movie];
    NSDictionary* dictionary = [FileUtilities readObject:file];
    if (dictionary.count == 0) {
        return nil;
    }
    
    return [Movie movieWithDictionary:dictionary];
}


- (void) checkApiResult:(XmlElement*) element {
    NSString* message = [[element element:@"message"] text];
    if ([@"Over queries per day limit" isEqual:message]) {
        self.lastQuotaErrorDate = [NSDate date];
        [NowPlayingAppDelegate minorRefresh];
    }
}

@end