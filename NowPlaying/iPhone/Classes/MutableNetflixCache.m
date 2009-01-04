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

#import "MutableNetflixCache.h"

#import "Feed.h"
#import "FileUtilities.h"
#import "IdentitySet.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "NetflixAddMovieDelegate.h"
#import "NetflixModifyQueueDelegate.h"
#import "NetflixMoveMovieDelegate.h"
#import "Model.h"
#import "Queue.h"
#import "ThreadingUtilities.h"
#import "XmlElement.h"

@implementation MutableNetflixCache


- (void) dealloc {
    [super dealloc];
}


- (id) initWithModel:(Model*) model_ {
    if (self = [super initWithModel:model_]) {
    }

    return self;
}


+ (MutableNetflixCache*) cacheWithModel:(Model*) model {
    return [[[MutableNetflixCache alloc] initWithModel:model] autorelease];
}


- (void) reportMoveMovieFailure:(NSArray*) arguments {
    NSAssert([NSThread isMainThread], nil);
    id<NetflixMoveMovieDelegate> delegate = [arguments objectAtIndex:0];
    NSString* error = [arguments objectAtIndex:1];

    [delegate moveFailedWithError:error];
}


- (void) reportQueueAndMoveMovieSuccess:(NSArray*) arguments {
    NSAssert([NSThread isMainThread], nil);
    [self reportQueue:[arguments objectAtIndex:0]];

    Movie* movie = [arguments objectAtIndex:1];
    id<NetflixMoveMovieDelegate> delegate = [arguments objectAtIndex:2];

    [delegate moveSucceededForMovie:movie];
}


- (void) reportQueueAndModifyQueueError:(NSArray*) arguments {
    NSAssert([NSThread isMainThread], nil);
    [self reportQueue:[arguments objectAtIndex:0]];

    id<NetflixModifyQueueDelegate> delegate = [arguments objectAtIndex:1];
    NSString* error = [arguments objectAtIndex:2];

    [delegate modifyFailedWithError:error];
}


- (void) reportQueueAndModifyQueueSuccess:(NSArray*) arguments {
    NSAssert([NSThread isMainThread], nil);
    [self reportQueue:[arguments objectAtIndex:0]];
    id<NetflixModifyQueueDelegate> delegate = [arguments objectAtIndex:1];

    [delegate modifySucceeded];
}


- (void) reportQueueAndAddMovieSuccess:(NSArray*) arguments {
    NSAssert([NSThread isMainThread], nil);
    [self reportQueue:[arguments objectAtIndex:0]];
    id<NetflixAddMovieDelegate> delegate = [arguments objectAtIndex:1];

    [delegate addSucceeded];
}


- (void)          saveQueue:(Queue*) queue
             andReportError:(NSString*) error
      toModifyQueueDelegate:(id<NetflixModifyQueueDelegate>) delegate {
    [self saveQueue:queue];
    NSArray* arguments = [NSArray arrayWithObjects:queue, delegate, error, nil];
    [self performSelectorOnMainThread:@selector(reportQueueAndModifyQueueError:) withObject:arguments waitUntilDone:NO];
}


- (void)                          saveQueue:(Queue*) queue
      andReportSuccessToModifyQueueDelegate:(id<NetflixModifyQueueDelegate>) delegate {
    [self saveQueue:queue];
    NSArray* arguments = [NSArray arrayWithObjects:queue, delegate, nil];
    [self performSelectorOnMainThread:@selector(reportQueueAndModifyQueueSuccess:) withObject:arguments waitUntilDone:NO];
}


- (void)                       saveQueue:(Queue*) queue
      andReportSuccessToAddMovieDelegate:(id<NetflixAddMovieDelegate>) delegate {
    [self saveQueue:queue];
    NSArray* arguments = [NSArray arrayWithObjects:queue, delegate, nil];
    [self performSelectorOnMainThread:@selector(reportQueueAndAddMovieSuccess:) withObject:arguments waitUntilDone:NO];
}


- (NSString*) extractErrorMessage:(XmlElement*) element {
    NSString* message = [[element element:@"message"] text];
    if (message.length > 0) {
        return message;
    } else {
        return NSLocalizedString(@"An unknown error occurred.", nil);
    }
}


- (Queue*) moveMovie:(Movie*) movie
          toPosition:(NSInteger) position
             inQueue:(Queue*) queue
               error:(NSString**) error {
    *error = nil;
    NSString* queueType = queue.isDVDQueue ? @"disc" : @"instant";
    NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/queues/%@", model.netflixUserId, queueType];

    OAMutableURLRequest* request = [self createURLRequest:address];
    [request setHTTPMethod:@"POST"];

    NSArray* parameters = [NSArray arrayWithObjects:
                           [OARequestParameter parameterWithName:@"title_ref" value:movie.identifier],
                           [OARequestParameter parameterWithName:@"position" value:[NSString stringWithFormat:@"%d", position + 1]],
                           [OARequestParameter parameterWithName:@"etag" value:queue.etag], nil];

    [request setParameters:parameters];
    [request prepare];

    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request
                                                              important:YES];

    [self checkApiResult:element];
    if (element == nil) {
        *error = NSLocalizedString(@"Could not connect to Netflix.", nil);
        return nil;
    }

    NSInteger status = [[[element element:@"status_code"] text] intValue];
    if (status < 200 || status >= 300) {
        *error = [self extractErrorMessage:element];
        return nil;
    }

    NSString* etag = [[element element:@"etag"] text];
    NSMutableArray* movies = [NSMutableArray arrayWithArray:queue.movies];
    [movies removeObjectIdenticalTo:movie];
    [movies insertObject:movie atIndex:position];

    Queue* finalQueue = [Queue queueWithFeed:queue.feed
                                           etag:etag
                                         movies:movies
                                          saved:queue.saved];

    return finalQueue;
}


- (void) moveMovieToTopOfQueueBackgroundEntryPoint:(NSArray*) arguments {
    Queue* queue = [arguments objectAtIndex:0];
    Movie* movie = [arguments objectAtIndex:1];
    id<NetflixMoveMovieDelegate> delegate = [arguments objectAtIndex:2];

    NSString* error;
    Queue* finalQueue = [self moveMovie:movie
                             toPosition:0
                                inQueue:queue
                                  error:&error];
    if (finalQueue == nil) {
        NSArray* errorArguments = [NSArray arrayWithObjects:delegate, error, nil];
        [self performSelectorOnMainThread:@selector(reportMoveMovieFailure:) withObject:errorArguments waitUntilDone:NO];
        return;
    }

    [self saveQueue:finalQueue];

    NSArray* finalArguments = [NSArray arrayWithObjects:finalQueue, movie, delegate, nil];
    [self performSelectorOnMainThread:@selector(reportQueueAndMoveMovieSuccess:)
                           withObject:finalArguments
                        waitUntilDone:NO];
}


- (void) updateQueue:(Queue*) queue
  byMovingMovieToTop:(Movie*) movie
            delegate:(id<NetflixMoveMovieDelegate>) delegate {
    NSArray* arguments = [NSArray arrayWithObjects:queue, movie, delegate, nil];

    [ThreadingUtilities backgroundSelector:@selector(moveMovieToTopOfQueueBackgroundEntryPoint:)
                                  onTarget:self
                                  argument:arguments
                                      gate:gate
                                   visible:YES];
}



- (void) updateQueue:(Queue*) queue
    byDeletingMovies:(IdentitySet*) deletedMovies
 andReorderingMovies:(IdentitySet*) reorderedMovies
                  to:(NSArray*) movies
            delegate:(id<NetflixModifyQueueDelegate>) delegate {
    NSArray* arguments = [NSArray arrayWithObjects:queue, deletedMovies, reorderedMovies, movies, delegate, nil];

    [ThreadingUtilities backgroundSelector:@selector(modifyQueueBackgroundEntryPoint:)
                                  onTarget:self
                                  argument:arguments
                                      gate:gate
                                   visible:YES];
}


- (void) changeRatingTo:(NSString*) rating
               forMovie:(Movie*) movie
               delegate:(id<NetflixChangeRatingDelegate>) delegate {
    NSArray* arguments = [NSArray arrayWithObjects:rating, movie, delegate, nil];
    [ThreadingUtilities backgroundSelector:@selector(changeRatingBackgroundEntryPoint:)
                                  onTarget:self
                                  argument:arguments
                                      gate:gate
                                   visible:YES];
}


- (NSString*) putChangeRatingTo:(NSString*) rating
                       forMovie:(Movie*) movie
                 withIdentifier:(NSString*) identifier {
    NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/ratings/title/actual/%@", model.netflixUserId, identifier];
    OAMutableURLRequest* request = [self createURLRequest:address];

    NSString* netflixRating = rating.length > 0 ? rating : @"no_opinion";
    OARequestParameter* parameter1 = [OARequestParameter parameterWithName:@"method" value:@"PUT"];
    OARequestParameter* parameter2 = [OARequestParameter parameterWithName:@"rating" value:netflixRating];
    [request setParameters:[NSArray arrayWithObjects:parameter1, parameter2, nil]];

    [request prepare];

    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request
                                                              important:YES];

    [self checkApiResult:element];

    NSInteger status = [[[element element:@"status_code"] text] intValue];
    if (status < 200 || status >= 300) {
        // we failed.  restore the rating to its original value
        return [self extractErrorMessage:element];
    }

    return nil;
}


- (NSString*) postChangeRatingTo:(NSString*) rating
                        forMovie:(Movie*) movie
                  withIdentifier:(NSString*) identifier {
    NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/ratings/title/actual/%@", model.netflixUserId, identifier];
    OAMutableURLRequest* request = [self createURLRequest:address];
    [request setHTTPMethod:@"POST"];

    NSString* netflixRating = rating.length > 0 ? rating : @"no_opinion";
    OARequestParameter* parameter1 = [OARequestParameter parameterWithName:@"title_refs" value:movie.identifier];
    OARequestParameter* parameter2 = [OARequestParameter parameterWithName:@"rating" value:netflixRating];
    [request setParameters:[NSArray arrayWithObjects:parameter1, parameter2, nil]];

    [request prepare];

    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request
                                                              important:YES];

    [self checkApiResult:element];

    NSInteger status = [[[element element:@"status_code"] text] intValue];
    if (status < 200 || status >= 300) {
        // we failed.  restore the rating to its original value
        return [self extractErrorMessage:element];
    }

    return nil;
}


- (NSString*) changeRatingTo:(NSString*) rating
              forMovieWorker:(Movie*) movie {
    // I hate the netflix API.  In order to do this, we need to first
    // test if the user already has a rating set.  If so, we will 'PUT'
    // to that rating.  Otherwise we will 'POST' to it.

    NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/ratings/title", model.netflixUserId];
    OAMutableURLRequest* request = [self createURLRequest:address];
    OARequestParameter* parameter = [OARequestParameter parameterWithName:@"title_refs" value:movie.identifier];
    [request setParameters:[NSArray arrayWithObject:parameter]];
    [request prepare];

    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request
                                                              important:NO];

    if (element == nil) {
        // we failed.  restore the rating to its original value
        return NSLocalizedString(@"An unknown error occurred.", nil);
    }

    XmlElement* ratingsItemElement = [element element:@"ratings_item"];
    NSString* identifier = [[ratingsItemElement element:@"id"] text];
    if (identifier.length == 0) {
        return NSLocalizedString(@"An unknown error occurred.", nil);
    }

    NSRange lastSlashRange = [identifier rangeOfString:@"/" options:NSBackwardsSearch];
    identifier = [identifier substringFromIndex:lastSlashRange.location + 1];

    XmlElement* userRatingElement = [ratingsItemElement element:@"user_rating"];

    if (userRatingElement == nil) {
        return [self postChangeRatingTo:rating
                               forMovie:movie
                         withIdentifier:identifier];
    } else {
        return [self putChangeRatingTo:rating
                              forMovie:movie
                        withIdentifier:identifier];
    }
}


- (void) changeRatingBackgroundEntryPoint:(NSArray*) arguments {
    NSString* rating = [arguments objectAtIndex:0];
    Movie* movie = [arguments objectAtIndex:1];
    id<NetflixChangeRatingDelegate> delegate = [arguments objectAtIndex:2];

    movie = [self promoteDiscToSeries:movie];
    NSString* userRatingsFile = [self userRatingsFile:movie];
    NSString* existingUserRating = [FileUtilities readObject:userRatingsFile];

    // First, persist the change so that the UI picks it up
    [FileUtilities writeObject:rating toFile:userRatingsFile];

    NSString* message = [self changeRatingTo:rating forMovieWorker:movie];
    if (message.length > 0) {
        [FileUtilities writeObject:existingUserRating toFile:userRatingsFile];
        [(id)delegate performSelectorOnMainThread:@selector(changeFailedWithError:) withObject:message waitUntilDone:NO];
        return;
    }

    [(id)delegate performSelectorOnMainThread:@selector(changeSucceeded) withObject:nil waitUntilDone:NO];
}


- (void) updateQueue:(Queue*) queue
       byAddingMovie:(Movie*) movie
            delegate:(id<NetflixAddMovieDelegate>) delegate {
    NSArray* arguments = [NSArray arrayWithObjects:queue, movie, delegate, nil];

    [ThreadingUtilities backgroundSelector:@selector(addMovieToQueueBackgroundEntryPoint:)
                                  onTarget:self
                                  argument:arguments
                                      gate:gate
                                   visible:YES];
}


- (void) addMovieToQueueBackgroundEntryPoint:(NSArray*) arguments {
    Queue* queue = [arguments objectAtIndex:0];
    Movie* movie = [arguments objectAtIndex:1];
    id<NetflixAddMovieDelegate> delegate = [arguments objectAtIndex:2];

    NSString* address;
    if ([queue isInstantQueue]) {
        address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/queues/instant", model.netflixUserId];
    } else {
        address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/queues/disc", model.netflixUserId];
    }

    OAMutableURLRequest* request = [self createURLRequest:address];
    [request setHTTPMethod:@"POST"];

    NSArray* parameters = [NSArray arrayWithObjects:
                           [OARequestParameter parameterWithName:@"title_ref" value:movie.identifier],
                           [OARequestParameter parameterWithName:@"etag" value:queue.etag], nil];

    [request setParameters:parameters];
    [request prepare];

    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request
                                                              important:YES];

    [self checkApiResult:element];
    if (element == nil) {
        NSString* error = NSLocalizedString(@"Could not connect to Netflix.", nil);
        [(id)delegate performSelectorOnMainThread:@selector(addFailedWithError:) withObject:error waitUntilDone:NO];
        return;
    }

    NSInteger status = [[[element element:@"status_code"] text] intValue];
    if (status < 200 || status >= 300) {
        NSString* error = [self extractErrorMessage:element];

        [(id)delegate performSelectorOnMainThread:@selector(addFailedWithError:) withObject:error waitUntilDone:NO];
        return;
    }

    NSString* etag = [[element element:@"etag"] text];

    NSMutableArray* newMovies = [NSMutableArray array];
    NSMutableArray* newSaved = [NSMutableArray array];
    [NetflixCache processMovieItemList:[element element:@"resources_created"] movies:newMovies saved:newSaved];

    Queue* finalQueue = [Queue queueWithFeed:queue.feed
                                           etag:etag
                                         movies:[queue.movies arrayByAddingObjectsFromArray:newMovies]
                                          saved:[queue.saved arrayByAddingObjectsFromArray:newSaved]];

    [self saveQueue:finalQueue andReportSuccessToAddMovieDelegate:delegate];
}


- (Queue*) deleteMovie:(Movie*) movie
               inQueue:(Queue*) queue
                 error:(NSString**) error {
    *error = nil;

    OAMutableURLRequest* request = [self createURLRequest:movie.identifier];

    [request setHTTPMethod:@"DELETE"];
    [request prepare];

    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request
                                                              important:YES];

    [self checkApiResult:element];

    NSInteger status = [[[element element:@"status_code"] text] intValue];
    if (status < 200 || status >= 300) {
        *error = [self extractErrorMessage:element];
        return nil;
    }

    // TODO: what do we do if this fails?!
    NSString* etag = [self downloadEtag:queue.feed];
    NSMutableArray* newMovies = [NSMutableArray arrayWithArray:queue.movies];
    NSMutableArray* newSaved = [NSMutableArray arrayWithArray:queue.saved];
    [newMovies removeObjectIdenticalTo:movie];
    [newSaved removeObjectIdenticalTo:movie];

    return [Queue queueWithFeed:queue.feed
                           etag:etag
                         movies:newMovies
                          saved:newSaved];
}


NSInteger orderMovies(id t1, id t2, void* context) {
    Movie* movie1 = t1;
    Movie* movie2 = t2;

    NSArray* moviesInOrder = context;

    NSInteger i1 = [moviesInOrder indexOfObjectIdenticalTo:movie1];
    NSInteger i2 = [moviesInOrder indexOfObjectIdenticalTo:movie2];

    if (i1 < i2) {
        return NSOrderedAscending;
    } else if (i1 > i2) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}


- (void) modifyQueueBackgroundEntryPoint:(NSArray*) arguments {
    Queue* queue = [arguments objectAtIndex:0];
    IdentitySet* deletedMovies = [arguments objectAtIndex:1];
    IdentitySet* reorderedMovies = [arguments objectAtIndex:2];
    NSArray* moviesInOrder = [arguments objectAtIndex:3];
    id<NetflixModifyQueueDelegate> delegate = [arguments objectAtIndex:4];

    Queue* finalQueue = queue;

    for (Movie* movie in deletedMovies.allObjects) {
        NSString* error;
        Queue* resultantQueue = [self deleteMovie:movie
                                          inQueue:queue
                                            error:&error];

        if (resultantQueue == nil) {
            [self saveQueue:finalQueue
             andReportError:error
      toModifyQueueDelegate:delegate];
            return;
        }

        finalQueue = resultantQueue;
    }

    NSArray* orderedMoviesToReorder = [reorderedMovies.allObjects sortedArrayUsingFunction:orderMovies context:moviesInOrder];
    for (Movie* movie in orderedMoviesToReorder) {
        NSString* error = nil;
        Queue* resultantQueue = [self moveMovie:movie
                                     toPosition:[moviesInOrder indexOfObjectIdenticalTo:movie]
                                        inQueue:finalQueue
                                          error:&error];

        if (resultantQueue == nil) {
            [self saveQueue:finalQueue
             andReportError:error
      toModifyQueueDelegate:delegate];
            return;
        }

        finalQueue = resultantQueue;
    }

    [self saveQueue:finalQueue andReportSuccessToModifyQueueDelegate:delegate];
}



@end