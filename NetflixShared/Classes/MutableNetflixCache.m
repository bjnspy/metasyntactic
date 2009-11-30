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

#import "AddMovieArguments.h"
#import "ChangeRatingArguments.h"
#import "ModifyQueueArguments.h"
#import "MoveMovieArguments.h"
#import "Movie.h"
#import "NetflixAccount.h"
#import "NetflixAccountCache.h"
#import "NetflixAddMovieDelegate.h"
#import "NetflixChangeRatingDelegate.h"
#import "NetflixConstants.h"
#import "NetflixModifyQueueDelegate.h"
#import "NetflixMoveMovieDelegate.h"
#import "NetflixNetworking.h"
#import "NetflixPaths.h"
#import "NetflixSiteStatus.h"
#import "NetflixUtilities.h"
#import "Queue.h"

@interface NetflixCache()
+ (Movie*) promoteDiscToSeries:(Movie*) disc;

- (NSString*) downloadEtag:(Feed*) feed account:(NetflixAccount*) account;
@end

@interface MutableNetflixCache()
@property (retain) NSDictionary* presubmitRatings;
@end

@implementation MutableNetflixCache

static MutableNetflixCache* cache;

+ (void) initialize {
  if (self == [MutableNetflixCache class]) {
    cache = [[MutableNetflixCache alloc] init];
  }
}


+ (MutableNetflixCache*) cache {
  return cache;
}

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


- (NetflixAccountCache*) accountCache {
  return [NetflixAccountCache cache];
}


- (void) checkForEtagMismatch:(NetflixAccount*) account element:(XmlElement*) element {
  NSInteger statusCode = [[[element element:@"status_code"] text] integerValue];
  
  if (statusCode == [NetflixConstants etagMismatchError]) {
    // Ok, we're out of date with the netflix servers.  Force a redownload of the users' queues.
    NSLog(@"Etag mismatch error. Force a redownload of the user's queues.");
    [self updateQueues:account force:YES];
  }
}


- (XmlElement*) downloadXml:(NSURLRequest*) request
                    account:(NetflixAccount*) account
                   response:(NSHTTPURLResponse**) response {
  BOOL outOfDate;
  XmlElement* element = [NetflixNetworking downloadXml:request
                                               account:account
                                              response:response
                                             outOfDate:&outOfDate];
                          
  if (outOfDate) {
    // Ok, we're out of date with the netflix servers.  Force a redownload of the users' queues.
    NSLog(@"Etag mismatch error. Force a redownload of the user's queues.");
    [self updateQueues:account force:YES];
  }

  return element;
}


- (XmlElement*) downloadXml:(NSURLRequest*) request account:(NetflixAccount*) account {
  return [self downloadXml:request account:account response:NULL];
}


- (void) removePresubmitRatingsForMovie:(Movie*) movie {
  movie = [NetflixCache promoteDiscToSeries:movie];
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


- (void)        saveQueue:(Queue*) queue
           andReportError:(NSString*) error
    toModifyQueueDelegate:(id<NetflixModifyQueueDelegate>) delegate
                  account:(NetflixAccount*) account {
  NSLog(@"Saving queue and reporting failure to NetflixModifyQueueDelegate.", nil);
  [self.accountCache saveQueue:queue account:account];

  [ThreadingUtilities foregroundSelector:@selector(modifyFailedWithError:)
                                onTarget:delegate
                              withObject:error];
}


- (void)                          saveQueue:(Queue*) queue
      andReportSuccessToModifyQueueDelegate:(id<NetflixModifyQueueDelegate>) delegate
                                    account:(NetflixAccount*) account {
  NSLog(@"Saving queue and reporting success to NetflixModifyQueueDelegate.", nil);
  [self.accountCache saveQueue:queue account:account];
  [ThreadingUtilities foregroundSelector:@selector(modifySucceeded)
                                onTarget:delegate];
}


- (void)                     saveQueue:(Queue*) queue
    andReportSuccessToAddMovieDelegate:(id<NetflixAddMovieDelegate>) delegate
                               account:(NetflixAccount*) account {
  NSLog(@"Saving queue and reporting success to NetflixAddMovieDelegate.", nil);
  [self.accountCache saveQueue:queue account:account];
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

  NSArray* parameters = [NSArray arrayWithObjects:
                         [OARequestParameter parameterWithName:@"title_ref" value:movie.identifier],
                         [OARequestParameter parameterWithName:@"position" value:[NSString stringWithFormat:@"%d", position + 1]],
                         [OARequestParameter parameterWithName:@"etag" value:queue.etag],
                         nil];

  NSURLRequest* request = [NetflixNetworking createPostURLRequest:address
                                                             parameters:parameters
                                                                account:account];

  NSHTTPURLResponse* response;
  XmlElement* element = [self downloadXml:request account:account response:&response];

  NSInteger statusCode = [[[element element:@"status_code"] text] integerValue];
  if (statusCode < 200 || statusCode >= 300) {
    *error = [NetflixUtilities extractErrorMessage:element];
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
  } else {
    NSLog(@"Moving '%@' succeeded.  Saving and reporting queue with etag: %@", moveArguments.movie.canonicalTitle, finalQueue.etag);
    [self.accountCache saveQueue:finalQueue account:moveArguments.account];
    
    [ThreadingUtilities foregroundSelector:@selector(moveSucceededForMovie:)
                                  onTarget:moveArguments.delegate
                                withObject:moveArguments.movie];
  }
}


- (void) moveMovieToTopOfQueueBackgroundEntryPoint:(MoveMovieArguments*) moveArguments {
  NSString* notification = [LocalizedString(@"Moving Movie", nil) lowercaseString];
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
   byDeletingMovies:[NSSet identitySetWithObject:movie]
andReorderingMovies:[NSSet identitySet]
                 to:[NSArray array]
           delegate:delegate
            account:account];
}


- (void) changeRatingTo:(NSString*) rating
               forMovie:(Movie*) movie
               delegate:(id<NetflixChangeRatingDelegate>) delegate
                account:(NetflixAccount*) account {
  NSAssert([NSThread isMainThread], @"");
  movie = [NetflixCache promoteDiscToSeries:movie];

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

  NSString* netflixRating = rating.length > 0 ? rating : @"no_opinion";
  NSArray* parameters = [NSArray arrayWithObjects:
                         [OARequestParameter parameterWithName:@"method" value:@"PUT"],
                         [OARequestParameter parameterWithName:@"rating" value:netflixRating],
                         nil];

  NSURLRequest* request = [NetflixNetworking createGetURLRequest:address parameters:parameters account:account];

  XmlElement* element = [self downloadXml:request account:account];

  NSInteger statusCode = [[[element element:@"status_code"] text] integerValue];
  if (statusCode < 200 || statusCode >= 300) {
    // we failed.  restore the rating to its original value
    return [NetflixUtilities extractErrorMessage:element];
  }

  return nil;
}


- (NSString*) postChangeRatingTo:(NSString*) rating
                        forMovie:(Movie*) movie
                  withIdentifier:(NSString*) identifier
                         account:(NetflixAccount*) account {
  NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/ratings/title/actual/%@", account.userId, identifier];

  NSString* netflixRating = rating.length > 0 ? rating : @"no_opinion";
  NSArray* parameters = [NSArray arrayWithObjects:
                         [OARequestParameter parameterWithName:@"title_refs" value:movie.identifier],
                         [OARequestParameter parameterWithName:@"rating" value:netflixRating], nil];

  NSURLRequest* request = [NetflixNetworking createPostURLRequest:address parameters:parameters account:account];

  XmlElement* element = [self downloadXml:request account:account];

  NSInteger statusCode = [[[element element:@"status_code"] text] integerValue];
  if (statusCode < 200 || statusCode >= 300) {
    // we failed.  restore the rating to its original value
    return [NetflixUtilities extractErrorMessage:element];
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
  NSURLRequest* request =
    [NetflixNetworking createGetURLRequest:address
                                parameter:[OARequestParameter parameterWithName:@"title_refs" value:movie.identifier]
                                  account:account];

  XmlElement* element = [self downloadXml:request account:account];

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
  NSString* userRatingsFile = [NetflixPaths userRatingsFile:changeArguments.movie account:changeArguments.account];
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
  } else {
    NSLog(@"Changing rating succeeded.", nil);
    [FileUtilities writeObject:changeArguments.rating toFile:userRatingsFile];
    
    [ThreadingUtilities foregroundSelector:@selector(reportChangeRatingSuccess:toDelegate:)
                                  onTarget:self
                                withObject:changeArguments.movie
                                withObject:changeArguments.delegate];
  }
}


- (void) changeRatingBackgroundEntryPoint:(ChangeRatingArguments*) changeArguments {
  NSString* notification = [LocalizedString(@"Movie Rating", nil) lowercaseString];
  [NotificationCenter addNotification:notification];
  {
    [self changeRatingBackgroundEntryPointWorker:changeArguments];
  }
  [NotificationCenter removeNotification:notification];
}


- (void) updateQueue:(Queue*) queue
       byAddingMovie:(Movie*) movie
          withFormat:(NSString*) format
          toPosition:(NSInteger) position
            delegate:(id<NetflixAddMovieDelegate>) delegate
             account:(NetflixAccount*) account {
  AddMovieArguments* arguments = [AddMovieArguments argumentsWithQueue:queue movie:movie format:format position:position delegate:delegate account:account];

  [[OperationQueue operationQueue] performSelector:@selector(addMovieToQueueBackgroundEntryPoint:)
                                          onTarget:self
                                        withObject:arguments
                                              gate:runGate
                                          priority:Now];
}


- (void) updateQueue:(Queue*) queue
       byAddingMovie:(Movie*) movie
          withFormat:(NSString*) format
            delegate:(id<NetflixAddMovieDelegate>) delegate
             account:(NetflixAccount*) account {
  [self updateQueue:queue byAddingMovie:movie withFormat:format toPosition:-1 delegate:delegate account:account];
}


- (Queue*) processAddMovieResult:(XmlElement*) element
                           queue:(Queue*) queue
                        position:(NSInteger) position
                           error:(NSString**) error {
  *error = nil;

  NSInteger status = [[[element element:@"status_code"] text] integerValue];
  if (status < 200 || status >= 300) {
    *error = [NetflixUtilities extractErrorMessage:element];
    return nil;
  }

  NSString* etag = [[element element:@"etag"] text];

  NSMutableArray* addedMovies = [NSMutableArray array];
  NSMutableArray* addedSaved = [NSMutableArray array];
  [NetflixUtilities processMovieItemList:[element element:@"resources_created"]
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


- (void) addMovieToQueueBackgroundEntryPointWorker:(AddMovieArguments*) addArguments {
  NSString* address;
  BOOL bluray = NO;
  if ([addArguments.queue isInstantQueue]) {
    NSLog(@"Adding '%@' to instant queue.", addArguments.movie.canonicalTitle);
    address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/queues/instant", addArguments.account.userId];
  } else {
    NSLog(@"Adding '%@' to DVD queue.", addArguments.movie.canonicalTitle);
    address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/queues/disc", addArguments.account.userId];
    bluray = [[NetflixConstants blurayFormat] isEqual:addArguments.format];
  }

  NSMutableArray* parameters = [NSMutableArray array];
  [parameters addObject:[OARequestParameter parameterWithName:@"title_ref" value:addArguments.movie.identifier]];
  [parameters addObject:[OARequestParameter parameterWithName:@"etag" value:addArguments.queue.etag]];
  if (bluray) {
    [parameters addObject:[OARequestParameter parameterWithName:@"format" value:[NetflixConstants blurayFormat]]];
  }
  if (addArguments.position >= 0) {
    [parameters addObject:[OARequestParameter parameterWithName:@"position" value:[NSString stringWithFormat:@"%d", addArguments.position + 1]]];
  }

  NSURLRequest* request = [NetflixNetworking createPostURLRequest:address
                                                             parameters:parameters
                                                                account:addArguments.account];

  XmlElement* element = [self downloadXml:request account:addArguments.account];

  NSString* error;
  Queue* finalQueue = [self processAddMovieResult:element
                                            queue:addArguments.queue
                                         position:addArguments.position
                                            error:&error];
  if (finalQueue == nil) {
    NSLog(@"Adding '%@' failed: %@", addArguments.movie.canonicalTitle, error);
    [ThreadingUtilities foregroundSelector:@selector(addFailedWithError:) onTarget:addArguments.delegate withObject:error];
    return;
  }

  NSLog(@"Adding '%@' succeeded.", addArguments.movie.canonicalTitle);
  [self saveQueue:finalQueue andReportSuccessToAddMovieDelegate:addArguments.delegate account:addArguments.account];
}


- (void) addMovieToQueueBackgroundEntryPoint:(AddMovieArguments*) arguments {
  NSString* notification = [LocalizedString(@"Adding Movie", @"Notification shown to the user when we are in the process of adding a movie to their Netflix queue") lowercaseString];
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

  NSURLRequest* request = [NetflixNetworking createDeleteURLRequest:movie.identifier account:account];

  XmlElement* element = [self downloadXml:request account:account];

  NSInteger statusCode = [[[element element:@"status_code"] text] integerValue];
  if (statusCode < 200 || statusCode >= 300) {
    *error = [NetflixUtilities extractErrorMessage:element];
    return nil;
  }

  // TODO: what do we do if this fails?!
  NSString* etag = [self downloadEtag:queue.feed account:account];
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
  NSString* notification = [LocalizedString(@"Updating Queue", nil) lowercaseString];
  [NotificationCenter addNotification:notification];
  {
    [self modifyQueueBackgroundEntryPointWorker:arguments];
  }
  [NotificationCenter removeNotification:notification];
}


- (NSString*) userRatingForMovie:(Movie*) movie account:(NetflixAccount*) account {
  NSAssert([NSThread isMainThread], @"");
  movie = [NetflixCache promoteDiscToSeries:movie];

  NSString* presubmitRating = [presubmitRatings objectForKey:movie];
  if (presubmitRating != nil) {
    return presubmitRating;
  }

  return [super userRatingForMovie:movie account:account];
}

@end
