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

#import "ChangeRatingArguments.h"
#import "Model.h"
#import "ModifyQueueArguments.h"
#import "MoveMovieArguments.h"
#import "Movie.h"
#import "NetflixAccount.h"
#import "NetflixAddMovieDelegate.h"
#import "NetflixChangeRatingDelegate.h"
#import "NetflixModifyQueueDelegate.h"
#import "NetflixMoveMovieDelegate.h"
#import "Queue.h"

@interface MutableNetflixCache()
@property (retain) NSDictionary* presubmitRatings;
@end

@implementation MutableNetflixCache

@synthesize presubmitRatings;

- (void) dealloc {
  self.presubmitRatings = nil;
  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.presubmitRatings = [NSDictionary dictionary];
  }
  return self;
}


+ (MutableNetflixCache*) cache {
  return [[[MutableNetflixCache alloc] init] autorelease];
}


- (Model*) model {
  return [Model model];
}


- (void) removePresubmitRatingsForMovie:(Movie*) movie {
  movie = [self promoteDiscToSeries:movie];
  NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithDictionary:presubmitRatings];
  [dictionary removeObjectForKey:movie];
  self.presubmitRatings = dictionary;
}


- (void) reportChangeRatingFailure:(Movie*) movie
                        toDelegate:(id<NetflixChangeRatingDelegate>) delegate
                           message:(NSString*) message {
  NSAssert([NSThread isMainThread], nil);

  [self removePresubmitRatingsForMovie:movie];

  [delegate changeFailedWithError:message];
}


- (void) reportChangeRatingSuccess:(Movie*) movie
                        toDelegate:(id<NetflixChangeRatingDelegate>) delegate {
  NSAssert([NSThread isMainThread], nil);

  [self removePresubmitRatingsForMovie:movie];

  [delegate changeSucceeded];
}


- (void)          saveQueue:(Queue*) queue
             andReportError:(NSString*) error
      toModifyQueueDelegate:(id<NetflixModifyQueueDelegate>) delegate
                 account:(NetflixAccount*) account {
  NSLog(@"Saving queue and reporting failure to NetflixModifyQueueDelegate.", nil);
  [self saveQueue:queue account:account];

  [ThreadingUtilities foregroundSelector:@selector(modifyFailedWithError:)
                                onTarget:delegate
                              withObject:error];
}


- (void)                          saveQueue:(Queue*) queue
      andReportSuccessToModifyQueueDelegate:(id<NetflixModifyQueueDelegate>) delegate
                                 account:(NetflixAccount*) account {
  NSLog(@"Saving queue and reporting success to NetflixModifyQueueDelegate.", nil);
  [self saveQueue:queue account:account];
  [ThreadingUtilities foregroundSelector:@selector(modifySucceeded)
                                onTarget:delegate];
}


- (void)                       saveQueue:(Queue*) queue
      andReportSuccessToAddMovieDelegate:(id<NetflixAddMovieDelegate>) delegate
                              account:(NetflixAccount*) account {
  NSLog(@"Saving queue and reporting success to NetflixAddMovieDelegate.", nil);
  [self saveQueue:queue account:account];
  [ThreadingUtilities foregroundSelector:@selector(addSucceeded)
                                onTarget:delegate];
}


- (Queue*) moveMovie:(Movie*) movie
          toPosition:(NSInteger) position
             inQueue:(Queue*) queue
          account:(NetflixAccount*) account
               error:(NSString**) error {
  *error = nil;
  NSString* queueType = queue.isDVDQueue ? @"disc" : @"instant";
  NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/queues/%@", account.userId, queueType];

  OAMutableURLRequest* request = [self createURLRequest:address account:account];
  [request setHTTPMethod:@"POST"];

  NSArray* parameters = [NSArray arrayWithObjects:
                         [OARequestParameter parameterWithName:@"title_ref" value:movie.identifier],
                         [OARequestParameter parameterWithName:@"position" value:[NSString stringWithFormat:@"%d", position + 1]],
                         [OARequestParameter parameterWithName:@"etag" value:queue.etag],
                         nil];

  [NSMutableURLRequestAdditions setParameters:parameters
                                   forRequest:request];
  [request prepare];

  NSHTTPURLResponse* response;
  XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request
                                                             response:&response];

  [self checkApiResult:element];

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


- (void) moveMovieToTopOfQueueBackgroundEntryPointWorker:(MoveMovieArguments*) moveArguments {
  NSLog(@"Moving '%@' to top of queue.", moveArguments.movie.canonicalTitle);

  NSString* error;
  Queue* finalQueue = [self moveMovie:moveArguments.movie
                           toPosition:0
                              inQueue:moveArguments.queue
                              account:moveArguments.account
                                error:&error];
  if (finalQueue == nil) {
    NSLog(@"Moving '%@' failed: %@", moveArguments.movie.canonicalTitle, error);
    [ThreadingUtilities foregroundSelector:@selector(moveFailedWithError:)
                                  onTarget:moveArguments.delegate
                                withObject:error];
    return;
  }

  NSLog(@"Moving '%@' succeeded.  Saving and reporting queue with etag: %@", moveArguments.movie.canonicalTitle, finalQueue.etag);
  [self saveQueue:finalQueue account:moveArguments.account];

  [ThreadingUtilities foregroundSelector:@selector(moveSucceededForMovie:)
                                onTarget:moveArguments.delegate
                              withObject:moveArguments.movie];
}


- (void) moveMovieToTopOfQueueBackgroundEntryPoint:(MoveMovieArguments*) moveArguments {
  NSString* notification = LocalizedString(@"moving movie", nil);
  [NotificationCenter addNotification:notification];
  {
    [self moveMovieToTopOfQueueBackgroundEntryPointWorker:moveArguments];
  }
  [NotificationCenter removeNotification:notification];
}


- (void) updateQueue:(Queue*) queue
  byMovingMovieToTop:(Movie*) movie
            delegate:(id<NetflixMoveMovieDelegate>) delegate
          account:(NetflixAccount*) account {
  MoveMovieArguments* arguments = [MoveMovieArguments argumentsWithQueue:queue
                                                                   movie:movie
                                                                delegate:delegate
                                                                 account:account];

  [[OperationQueue operationQueue] performSelector:@selector(moveMovieToTopOfQueueBackgroundEntryPoint:)
                                          onTarget:self
                                        withObject:arguments
                                              gate:runGate
                                          priority:Now];
}



- (void) updateQueue:(Queue*) queue
    byDeletingMovies:(NSSet*) deletedMovies
 andReorderingMovies:(NSSet*) reorderedMovies
                  to:(NSArray*) movies
            delegate:(id<NetflixModifyQueueDelegate>) delegate
             account:(NetflixAccount*) account {
  ModifyQueueArguments* arguments = [ModifyQueueArguments argumentsWithQueue:queue
                                                               deletedMovies:deletedMovies
                                                             reorderedMovies:reorderedMovies
                                                               moviesInOrder:movies
                                                                    delegate:delegate
                                                                     account:account];

  [[OperationQueue operationQueue] performSelector:@selector(modifyQueueBackgroundEntryPoint:)
                                          onTarget:self
                                        withObject:arguments
                                              gate:runGate
                                          priority:Now];
}


- (void) updateQueue:(Queue*) queue
     byDeletingMovie:(Movie*) movie
            delegate:(id<NetflixModifyQueueDelegate>) delegate
             account:(NetflixAccount*) account {
  [self updateQueue:queue
   byDeletingMovies:[IdentitySet setWithObject:movie]
andReorderingMovies:[IdentitySet set]
                 to:[NSArray array]
           delegate:delegate
            account:account];
}


- (void) changeRatingTo:(NSString*) rating
               forMovie:(Movie*) movie
               delegate:(id<NetflixChangeRatingDelegate>) delegate
                account:(NetflixAccount*) account {
  NSAssert([NSThread isMainThread], @"");
  movie = [self promoteDiscToSeries:movie];

  NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithDictionary:presubmitRatings];
  [dictionary setObject:rating forKey:movie];
  self.presubmitRatings = dictionary;

  ChangeRatingArguments* arguments = [ChangeRatingArguments argumentsWithRating:rating movie:movie delegate:delegate account:account];
  [[OperationQueue operationQueue] performSelector:@selector(changeRatingBackgroundEntryPoint:)
                                          onTarget:self
                                        withObject:arguments
                                              gate:runGate
                                          priority:Now];
}


- (NSString*) putChangeRatingTo:(NSString*) rating
                       forMovie:(Movie*) movie
                 withIdentifier:(NSString*) identifier
                        account:(NetflixAccount*) account {
  NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/ratings/title/actual/%@", account.userId, identifier];
  OAMutableURLRequest* request = [self createURLRequest:address account:account];

  NSString* netflixRating = rating.length > 0 ? rating : @"no_opinion";
  OARequestParameter* parameter1 = [OARequestParameter parameterWithName:@"method" value:@"PUT"];
  OARequestParameter* parameter2 = [OARequestParameter parameterWithName:@"rating" value:netflixRating];
  [NSMutableURLRequestAdditions setParameters:[NSArray arrayWithObjects:parameter1, parameter2, nil]
                                   forRequest:request];

  [request prepare];

  XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request];

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
                  withIdentifier:(NSString*) identifier
                         account:(NetflixAccount*) account {
  NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/ratings/title/actual/%@", account.userId, identifier];
  OAMutableURLRequest* request = [self createURLRequest:address account:account];
  [request setHTTPMethod:@"POST"];

  NSString* netflixRating = rating.length > 0 ? rating : @"no_opinion";
  OARequestParameter* parameter1 = [OARequestParameter parameterWithName:@"title_refs" value:movie.identifier];
  OARequestParameter* parameter2 = [OARequestParameter parameterWithName:@"rating" value:netflixRating];
  [NSMutableURLRequestAdditions setParameters:[NSArray arrayWithObjects:parameter1, parameter2, nil]
                                   forRequest:request];

  [request prepare];

  XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request];

  [self checkApiResult:element];

  NSInteger status = [[[element element:@"status_code"] text] intValue];
  if (status < 200 || status >= 300) {
    // we failed.  restore the rating to its original value
    return [self extractErrorMessage:element];
  }

  return nil;
}


- (NSString*) changeRatingTo:(NSString*) rating
              forMovieWorker:(Movie*) movie
                     account:(NetflixAccount*) account {
  // I hate the netflix API.  In order to do this, we need to first
  // test if the user already has a rating set.  If so, we will 'PUT'
  // to that rating.  Otherwise we will 'POST' to it.

  NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/ratings/title", account.userId];
  OAMutableURLRequest* request = [self createURLRequest:address account:account];
  OARequestParameter* parameter = [OARequestParameter parameterWithName:@"title_refs" value:movie.identifier];
  [NSMutableURLRequestAdditions setParameters:[NSArray arrayWithObject:parameter] forRequest:request];
  [request prepare];

  XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request];

  if (element == nil) {
    // we failed.  restore the rating to its original value
    NSLog(@"Couldn't parse Netflix response.", nil);
    return LocalizedString(@"Could not connect to Netflix.", nil);
  }

  XmlElement* ratingsItemElement = [element element:@"ratings_item"];
  NSString* identifier = [[ratingsItemElement element:@"id"] text];
  if (identifier.length == 0) {
    NSLog(@"No identifier returned.", nil);
    return LocalizedString(@"An unknown error occurred.", nil);
  }

  NSRange lastSlashRange = [identifier rangeOfString:@"/" options:NSBackwardsSearch];
  identifier = [identifier substringFromIndex:lastSlashRange.location + 1];

  XmlElement* userRatingElement = [ratingsItemElement element:@"user_rating"];

  if (userRatingElement == nil) {
    NSLog(@"No user rating.  Posting response.", nil);
    return [self postChangeRatingTo:rating
                           forMovie:movie
                     withIdentifier:identifier
                            account:account];
  } else {
    NSLog(@"Existing user rating.  Putting response.", nil);
    return [self putChangeRatingTo:rating
                          forMovie:movie
                    withIdentifier:identifier
                           account:account];
  }
}


- (void) changeRatingBackgroundEntryPointWorker:(ChangeRatingArguments*) changeArguments {
  NSString* userRatingsFile = [self userRatingsFile:changeArguments.movie account:changeArguments.account];
  NSString* existingUserRating = [StringUtilities nonNilString:[FileUtilities readObject:userRatingsFile]];

  NSLog(@"Changing rating for '%@' from '%@' to '%@'.", changeArguments.movie.canonicalTitle, existingUserRating, changeArguments.rating);

  // First, persist the change so that the UI picks it up

  NSString* message = [self changeRatingTo:changeArguments.rating
                            forMovieWorker:changeArguments.movie
                                   account:changeArguments.account];
  if (message.length > 0) {
    NSLog(@"Changing rating failed. Restoring existing rating.", nil);
    [ThreadingUtilities foregroundSelector:@selector(reportChangeRatingFailure:toDelegate:message:)
                                  onTarget:self
                                withObject:changeArguments.movie
                                withObject:changeArguments.delegate
                                withObject:message];
    return;
  }

  NSLog(@"Changing rating succeeded.", nil);
  [FileUtilities writeObject:changeArguments.rating toFile:userRatingsFile];
  
  [ThreadingUtilities foregroundSelector:@selector(reportChangeRatingSuccess:toDelegate:)
                                onTarget:self
                              withObject:changeArguments.movie
                              withObject:changeArguments.delegate];
}


- (void) changeRatingBackgroundEntryPoint:(ChangeRatingArguments*) changeArguments {
  NSString* notification = LocalizedString(@"movie rating", nil);
  [NotificationCenter addNotification:notification];
  {
    [self changeRatingBackgroundEntryPointWorker:changeArguments];
  }
  [NotificationCenter removeNotification:notification];
}


- (void) updateQueue:(Queue*) queue
       byAddingMovie:(Movie*) movie
          toPosition:(NSInteger) position
            delegate:(id<NetflixAddMovieDelegate>) delegate
             account:(NetflixAccount*) account {
  NSArray* arguments =
  [NSArray arrayWithObjects:queue, movie, [NSNumber numberWithInt:position], delegate, account, nil];

  [[OperationQueue operationQueue] performSelector:@selector(addMovieToQueueBackgroundEntryPoint:)
                                          onTarget:self
                                        withObject:arguments
                                              gate:runGate
                                          priority:Now];
}


- (void) updateQueue:(Queue*) queue
       byAddingMovie:(Movie*) movie
            delegate:(id<NetflixAddMovieDelegate>) delegate
             account:(NetflixAccount*) account {
  [self updateQueue:queue byAddingMovie:movie toPosition:-1 delegate:delegate account:account];
}


- (Queue*) processAddMovieResult:(XmlElement*) element
                           queue:(Queue*) queue
                        position:(NSInteger) position
                           error:(NSString**) error {
  *error = nil;

  NSInteger status = [[[element element:@"status_code"] text] intValue];
  if (status < 200 || status >= 300) {
    *error = [self extractErrorMessage:element];
    return nil;
  }

  NSString* etag = [[element element:@"etag"] text];

  NSMutableArray* addedMovies = [NSMutableArray array];
  NSMutableArray* addedSaved = [NSMutableArray array];
  [NetflixCache processMovieItemList:[element element:@"resources_created"]
                              movies:addedMovies
                               saved:addedSaved];

  NSMutableArray* newMovies = [NSMutableArray arrayWithArray:queue.movies];
  NSMutableArray* newSaved = [NSMutableArray arrayWithArray:queue.saved];

  if (position >= 0) {
    [newMovies insertObjects:addedMovies atIndex:position];
  } else {
    [newMovies addObjectsFromArray:addedMovies];
  }

  [newSaved addObjectsFromArray:addedSaved];

  return [Queue queueWithFeed:queue.feed
                         etag:etag
                       movies:newMovies
                        saved:newSaved];
}


- (void) addMovieToQueueBackgroundEntryPointWorker:(NSArray*) arguments {
  Queue* queue = [arguments objectAtIndex:0];
  Movie* movie = [arguments objectAtIndex:1];
  NSInteger position = [[arguments objectAtIndex:2] intValue];
  id<NetflixAddMovieDelegate> delegate = [arguments objectAtIndex:3];
  NetflixAccount* account = [arguments objectAtIndex:4];

  NSString* address;
  if ([queue isInstantQueue]) {
    NSLog(@"Adding '%@' to instant queue.", movie.canonicalTitle);
    address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/queues/instant", account.userId];
  } else {
    NSLog(@"Adding '%@' to DVD queue.", movie.canonicalTitle);
    address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/queues/disc", account.userId];
  }

  OAMutableURLRequest* request = [self createURLRequest:address account:account];
  [request setHTTPMethod:@"POST"];

  NSMutableArray* parameters = [NSMutableArray array];
  [parameters addObject:[OARequestParameter parameterWithName:@"title_ref" value:movie.identifier]];
  [parameters addObject:[OARequestParameter parameterWithName:@"etag" value:queue.etag]];
  if (position >= 0) {
    [parameters addObject:[OARequestParameter parameterWithName:@"position" value:[NSString stringWithFormat:@"%d", position + 1]]];
  }

  [NSMutableURLRequestAdditions setParameters:parameters forRequest:request];
  [request prepare];

  XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request];

  [self checkApiResult:element];

  NSString* error;
  Queue* finalQueue = [self processAddMovieResult:element
                                            queue:queue
                                         position:position
                                            error:&error];
  if (finalQueue == nil) {
    NSLog(@"Adding '%@' failed: %@", movie.canonicalTitle, error);
    [(id)delegate performSelectorOnMainThread:@selector(addFailedWithError:) withObject:error waitUntilDone:NO];
    return;
  }

  NSLog(@"Adding '%@' succeeded.", movie.canonicalTitle);
  [self saveQueue:finalQueue andReportSuccessToAddMovieDelegate:delegate account:account];
}


- (void) addMovieToQueueBackgroundEntryPoint:(NSArray*) arguments {
  NSString* notification = LocalizedString(@"adding movie", @"Notification shown to the user when we are in the process of adding a movie to their Netflix queue");
  [NotificationCenter addNotification:notification];
  {
    [self addMovieToQueueBackgroundEntryPointWorker:arguments];
  }
  [NotificationCenter removeNotification:notification];
}


- (Queue*) deleteMovie:(Movie*) movie
               inQueue:(Queue*) queue
               account:(NetflixAccount*) account
                 error:(NSString**) error {
  *error = nil;

  OAMutableURLRequest* request = [self createURLRequest:movie.identifier account:account];

  [request setHTTPMethod:@"DELETE"];
  [request prepare];

  XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request];

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


- (void) modifyQueueBackgroundEntryPointWorker:(ModifyQueueArguments*) modifyArguments {
  Queue* finalQueue = modifyArguments.queue;
  NSLog(@"Deleting:\n'%@'\nReordering:\n%@", modifyArguments.deletedMovies, modifyArguments.reorderedMovies);

  for (Movie* movie in modifyArguments.deletedMovies.allObjects) {
    NSString* error;
    Queue* resultantQueue = [self deleteMovie:movie
                                      inQueue:finalQueue
                                      account:modifyArguments.account
                                        error:&error];

    if (resultantQueue == nil) {
      NSLog(@"Failed to delete '%@'. %@.", movie.canonicalTitle, error);
      [self saveQueue:finalQueue
       andReportError:error
toModifyQueueDelegate:modifyArguments.delegate
              account:modifyArguments.account];
      return;
    }

    NSLog(@"Succeeded in deleting '%@'. New etag: %@.", movie.canonicalTitle, resultantQueue.etag);
    finalQueue = resultantQueue;
  }

  NSArray* orderedMoviesToReorder = [modifyArguments.reorderedMovies.allObjects sortedArrayUsingFunction:orderMovies context:modifyArguments.moviesInOrder];
  for (Movie* movie in orderedMoviesToReorder) {
    NSInteger position = [modifyArguments.moviesInOrder indexOfObjectIdenticalTo:movie];
    NSLog(@"Moving %@ to %d", movie.canonicalTitle, position);

    NSString* error = nil;
    Queue* resultantQueue = [self moveMovie:movie
                                 toPosition:position
                                    inQueue:finalQueue
                                    account:modifyArguments.account
                                      error:&error];

    if (resultantQueue == nil) {
      NSLog(@"Failed to move'%@' to %d. %@", movie.canonicalTitle, position, error);
      [self saveQueue:finalQueue
       andReportError:error
toModifyQueueDelegate:modifyArguments.delegate
              account:modifyArguments.account];
      return;
    }

    NSLog(@"Succeeded in moving '%@' to %d. New etag: %@.", movie.canonicalTitle, position, resultantQueue.etag);
    finalQueue = resultantQueue;
  }

  NSLog(@"Delete/Reorder completed successfully.  Saving queue and reporting.", nil);
  [self saveQueue:finalQueue andReportSuccessToModifyQueueDelegate:modifyArguments.delegate account:modifyArguments.account];
}


- (void) modifyQueueBackgroundEntryPoint:(ModifyQueueArguments*) arguments {
  NSString* notification = LocalizedString(@"updating queue", nil);
  [NotificationCenter addNotification:notification];
  {
    [self modifyQueueBackgroundEntryPointWorker:arguments];
  }
  [NotificationCenter removeNotification:notification];
}


- (NSString*) userRatingForMovie:(Movie*) movie account:(NetflixAccount*) account {
  NSAssert([NSThread isMainThread], @"");
  movie = [self promoteDiscToSeries:movie];

  NSString* presubmitRating = [presubmitRatings objectForKey:movie];
  if (presubmitRating != nil) {
    return presubmitRating;
  }

  return [super userRatingForMovie:movie account:account];
}

@end
