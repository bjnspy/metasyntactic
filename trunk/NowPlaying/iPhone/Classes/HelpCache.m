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

#import "HelpCache.h"

#import "Application.h"
#import "FileUtilities.h"
#import "Model.h"
#import "NetworkUtilities.h"
#import "NotificationCenter.h"
#import "OperationQueue.h"
#import "XmlElement.h"

@interface HelpCache()
@property (retain) NSArray* questionsAndAnswersData;
@end


@implementation HelpCache

@synthesize questionsAndAnswersData;

- (void) dealloc {
    self.questionsAndAnswersData = nil;
    [super dealloc];
}


+ (HelpCache*) cache {
    return [[[HelpCache alloc] init] autorelease];
}


- (Model*) model {
    return [Model model];
}


- (void) update {
    if (self.model.userAddress.length == 0) {
        return;
    }

    if (updated) {
        return;
    }
    updated = YES;

    [[OperationQueue operationQueue] performSelector:@selector(updateBackgroundEntryPoint)
                                            onTarget:self
                                                gate:nil
                                            priority:Priority];
}


- (NSString*) questionsAndAnswersFile {
    return [[Application helpDirectory] stringByAppendingPathComponent:@"Index.plist"];
}


- (NSArray*) loadQuestionsAndAnswers {
    NSArray* result = [FileUtilities readObject:[self questionsAndAnswersFile]];
    if (result.count > 0) {
        return result;
    }

    NSArray* questions = [NSArray arrayWithObjects:
                      NSLocalizedString(@"Why did my theater disappear?", nil),
                      [NSString stringWithFormat:NSLocalizedString(@"%@ doesn't list my favorite theater. Can you add it?", nil), [Application name]],
                      [NSString stringWithFormat:NSLocalizedString(@"Why don't I see ratings and reviews for all movies in %@?", nil), [Application name]],
                      [NSString stringWithFormat:NSLocalizedString(@"Why doesn't %@ offer ticketing through Movietickets.com as well as Fandango.com?", nil), [Application name]],
                      NSLocalizedString(@"Can you increase the maximum search distance for theaters?", nil),
                      [NSString stringWithFormat:NSLocalizedString(@"Why is %@ always downloading data? Why doesn't it store the data locally?", nil), [Application name]],
                      [NSString stringWithFormat:NSLocalizedString(@"If %@ caches data, why do I always see the 'loading spinner' even on posters that were already loaded?", nil), [Application name]],
                      NSLocalizedString(@"How do I get to my alternative queues for my Netflix account?", nil),
                      [NSString stringWithFormat:NSLocalizedString(@"Why doesn't %@ provide IMDb user ratings and reviews?", nil), [Application name]],
                      [NSString stringWithFormat:NSLocalizedString(@"Why doesn't %@ provide Yahoo ratings and reviews?", nil), [Application name]],
                      NSLocalizedString(@"Could you add support for Blockbuster movie rentals in addition to Netflix movie rentals?", nil),
                      [NSString stringWithFormat:NSLocalizedString(@"Could you provide an option to let me choose the icon I want for the %@?", nil), [Application name]],
                      [NSString stringWithFormat:NSLocalizedString(@"What can I do if I have a question that hasn't been answered?", nil)], nil];

    NSArray* answers = [NSArray arrayWithObjects:
                    [NSString stringWithFormat:NSLocalizedString(@"Theaters are removed when they do not provide up-to-date listings. When up-to-date listing are provided, the theater will reappear automatically in %@.", nil), [Application name]],
                    NSLocalizedString(@"I will absolutely try. Please tap the 'Add Theater' button above to contact me. I'll need the theater's name and its telephone number. Thanks!", nil),
                    NSLocalizedString(@"Licensing restrictions with certain data providers only allow for a subset of all movie ratings and reviews. Sorry!", nil),
                    NSLocalizedString(@"Unfortunately, Movietickets.com will not provide ticketing support if I also provide ticketing through Fandango.com. I go to Fandango.com theaters, and so that's the provider I'm sticking with.", nil),
                    NSLocalizedString(@"Currently no. However, simply mark the theater as a 'favorite' (by tapping the 'star' in the theater details pane) and it will show up even if it is outside your search range.", nil),
                    [NSString stringWithFormat:NSLocalizedString(@"%@ aggressively caches all data locally on your device so that it will be usable even without a network connection.  The only data not cached are movie trailers.", nil), [Application name]],
                    [NSString stringWithFormat:NSLocalizedString(@"To make scrolling as fast and as smooth as possible, %@ does not show the poster until scrolling has stopped.", nil), [Application name]],
                    NSLocalizedString(@"Log out of Netflix and log back in with the user name and password for your alternative queue.", nil),
                    NSLocalizedString(@"IMDb's licensing fees are unfortunately too high for me to afford. Sorry!", nil),
                    NSLocalizedString(@"See the section on IMDb.", nil),
                    NSLocalizedString(@"Currently Blockbuster does not provided a supported API for 3rd party applications to plug into. When they do, I will add support for Blockbuster rentals.", nil),
                    NSLocalizedString(@"Apple does not provide a mechanism for 3rd party applications to change their icon. When they do, I will provide this capability.", nil),
                    NSLocalizedString(@"Tap the 'Send Feedback' button above to contact me directly about anything else you need. Cheers! :-)", nil), nil];

    return [NSArray arrayWithObjects:questions, answers, nil];
}


- (NSArray*) questionsAndAnswersWorker {
    if (questionsAndAnswersData == nil) {
        self.questionsAndAnswersData = [self loadQuestionsAndAnswers];
    }

    // Return through property to ensure safe pointer
    return self.questionsAndAnswersData;
}


- (NSArray*) questionsAndAnswers {
    NSArray* result;
    [dataGate lock];
    {
        result = [self questionsAndAnswersWorker];
    }
    [dataGate unlock];
    return result;
}


- (void) updateBackgroundEntryPointWorker {
    NSString* address = [NSString stringWithFormat:@"http://%@.appspot.com/LookupHelpListings", [Application host]];
    XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:address];

    NSMutableArray* questions = [NSMutableArray array];
    NSMutableArray* answers = [NSMutableArray array];

    for (XmlElement* child in element.children) {
        NSString* question = [child attributeValue:@"question"];
        NSString* answer = [child attributeValue:@"answer"];

        if (question.length > 0 && answer.length > 0) {
            [questions addObject:question];
            [answers addObject:answer];
        }
    }

    if (questions.count == 0 || answers.count == 0) {
        return;
    }

    NSArray* result = [NSArray arrayWithObjects:questions, answers, nil];
    [FileUtilities writeObject:result toFile:[self questionsAndAnswersFile]];

    [dataGate lock];
    {
        self.questionsAndAnswersData = result;
    }
    [dataGate unlock];
}


- (void) updateBackgroundEntryPoint {
    NSDate* modificationDate = [FileUtilities modificationDate:[self questionsAndAnswersFile]];
    if (modificationDate != nil) {
        if (ABS(modificationDate.timeIntervalSinceNow) < ONE_WEEK) {
            return;
        }
    }

    NSString* notification = NSLocalizedString(@"help", nil);
    [NotificationCenter addNotification:notification];
    {
        [self updateBackgroundEntryPointWorker];
    }
    [NotificationCenter removeNotification:notification];
}

@end