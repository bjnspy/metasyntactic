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
#import "Model.h"

@interface HelpCache()
@property (retain) ThreadsafeValue* questionsAndAnswersData;
@end


@implementation HelpCache

@synthesize questionsAndAnswersData;

- (void) dealloc {
  self.questionsAndAnswersData = nil;
  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.questionsAndAnswersData = [ThreadsafeValue valueWithGate:dataGate delegate:self loadSelector:@selector(loadQuestionsAndAnswers) saveSelector:@selector(saveQuestionsAndAnswers:)];
  }
  
  return self;
}


+ (HelpCache*) cache {
  return [[[HelpCache alloc] init] autorelease];
}


- (Model*) model {
  return [Model model];
}


- (void) update {
  if (!self.model.helpCacheEnabled) {
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
  NSString* name = [NSString stringWithFormat:@"%@.plist", [LocaleUtilities preferredLanguage]];
  return [[Application helpDirectory] stringByAppendingPathComponent:name];
}


- (NSMutableArray*) makeReplacements:(NSArray*) array {
  NSMutableArray* result = [NSMutableArray array];
  
  for (NSInteger i = 0; i < array.count; i++) {
    NSString* value = [array objectAtIndex:i];
    value = [value stringByReplacingOccurrencesOfString:@"%@" withString:[Application name]];
    [result addObject:value];
  }
  
  return result;
}


- (NSString*) convertToJavaString:(NSString*) value {
  NSMutableString* result = [NSMutableString string];
  for (NSInteger i = 0; i < value.length; i++) {
    unichar c = [value characterAtIndex:i];
    if (c >= 32 && c < 127) {
      [result appendString:[value substringWithRange:NSMakeRange(i, 1)]];
    } else {
      [result appendFormat:@"\\u%04X", c];
    }
  }
  return result;
}


- (void) generateLocLine: (NSMutableString *) result dictionary: (NSDictionary *) dictionary values: (NSArray *) values  {
  for (NSString* value in values) {
    NSString* loc = [dictionary objectForKey:value];
    if (loc.length == 0) {
      loc = value;
    }
    loc = [self convertToJavaString:loc];
    [result appendFormat:@"    \"%@\",\n", loc]; 
  }
}


- (void) appendLookupMethod: (NSMutableString *) result type:(NSString*) type {
  [result appendString:@"  @Override\n"];
  [result appendFormat:@"  protected String[] lookup%@(String id, String language) {\n", type];
  [result appendString:@"    if (\"org.metasyntactic.BoxOffice\".equals(id)) {\n"];
  for (NSString* language in [[NSBundle mainBundle] localizations]) {
    [result appendFormat:@"      if (\"%@\".equals(language)) {\n", language];
    [result appendFormat:@"        return org_metasyntactic_BoxOffice_%@_%@;\n", language, [type lowercaseString]];
    [result appendString:@"      }\n"];
  }  
  [result appendString:@"    }\n"];
  [result appendString:@"    return null;\n"];
  [result appendString:@"  }\n"];
}


- (void) generateOnlineHelpFiles:(NSArray*) questions
                         answers:(NSArray*) answers {
  //return;
  NSMutableString* result = [NSMutableString string];
  
  [result appendString:@"@SuppressWarnings(\"serial\")\n"];
  [result appendString:@"public class LookupHelpListingsServlet2 extends AbstractLookupHelpListingsServlet2 {\n"];
  
  for (NSString* language in [[NSBundle mainBundle] localizations]) {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"Localizable.strings" ofType:nil inDirectory:nil forLocalization:language];
    NSDictionary* dictionary = [FileUtilities readObject:path];
    
    [result appendFormat:@"  private static final String[] org_metasyntactic_BoxOffice_%@_questions = new String[] {\n", language];
    [self generateLocLine: result dictionary: dictionary values:questions];
    [result appendFormat:@"  };\n"];
    
    [result appendFormat:@"  private static final String[] org_metasyntactic_BoxOffice_%@_answers = new String[] {\n", language];
    [self generateLocLine:result dictionary:dictionary values:answers];
    [result appendFormat:@"  };\n"];
  }
  
  [self appendLookupMethod: result type:@"Questions"];
  [self appendLookupMethod: result type:@"Answers"];
  
  
  
  [result appendString:@"}\n"];
  [result appendString:@"\n"];
  
  NSLog(@"%@", result);
}


- (NSArray*) loadQuestionsAndAnswers {
  NSArray* questions = [NSArray arrayWithObjects:
                        LocalizedString(@"%@ contains missing/incorrect translations. Can you fix it?", @"%@ is replaced with the name of the program.  i.e. 'Now Playing'"),
                        LocalizedString(@"Why did my theater disappear?", nil),
                        LocalizedString(@"%@ doesn't list my favorite theater. Can you add it?", @"%@ is replaced with the name of the program.  i.e. 'Now Playing'"),
                        LocalizedString(@"Why don't I see ratings and reviews for all movies in %@?", @"%@ is replaced with the name of the program.  i.e. 'Now Playing'"),
                        LocalizedString(@"Why doesn't %@ offer ticketing through Movietickets.com as well as Fandango.com?", @"%@ is replaced with the name of the program.  i.e. 'Now Playing'"),
                        LocalizedString(@"Can you increase the maximum search distance for theaters?", nil),
                        LocalizedString(@"Why is %@ always downloading data? Why doesn't it store the data locally?", @"%@ is replaced with the name of the program.  i.e. 'Now Playing'"),
                        LocalizedString(@"If %@ caches data, why do I always see the 'loading spinner' even on posters that were already loaded?", @"%@ is replaced with the name of the program.  i.e. 'Now Playing'"),
                        LocalizedString(@"Why doesn't %@ provide IMDb user ratings and reviews?", @"%@ is replaced with the name of the program.  i.e. 'Now Playing'"),
                        LocalizedString(@"Why doesn't %@ provide Yahoo ratings and reviews?", @"%@ is replaced with the name of the program.  i.e. 'Now Playing'"),
                        LocalizedString(@"Could you add support for Blockbuster movie rentals in addition to Netflix movie rentals?", nil),
                        LocalizedString(@"Could you provide an option to let me choose the icon I want for the %@?", @"%@ is replaced with the name of the program.  i.e. 'Now Playing'"),
                        LocalizedString(@"What can I do if I have a question that hasn't been answered?", nil), nil];
  
  NSArray* answers = [NSArray arrayWithObjects:
                      LocalizedString(@"Definitely! Use the 'Send Feedback' button above to contact me. Let me know what needs to be corrected and I will get the issue resolved for the next version.", nil),
                      LocalizedString(@"Theaters are removed when they do not provide up-to-date listings. When up-to-date listing are provided, the theater will reappear automatically in %@.", @"%@ is replaced with the name of the program.  i.e. 'Now Playing'"),
                      LocalizedString(@"I will absolutely try. Please tap the 'Add Theater' button above to contact me. I'll need the theater's name and its telephone number. Thanks!", nil),
                      LocalizedString(@"Licensing restrictions with certain data providers only allow for a subset of all movie ratings and reviews. Sorry!", nil),
                      LocalizedString(@"Unfortunately, Movietickets.com will not provide ticketing support if I also provide ticketing through Fandango.com. I go to Fandango.com theaters, and so that's the provider I'm sticking with.", nil),
                      LocalizedString(@"Currently no. However, simply mark the theater as a 'favorite' (by tapping the 'star' in the theater details pane) and it will show up even if it is outside your search range.", nil),
                      LocalizedString(@"%@ aggressively caches all data locally on your device so that it will be usable even without a network connection.  The only data not cached are movie trailers.", @"%@ is replaced with the name of the program.  i.e. 'Now Playing'"),
                      LocalizedString(@"To make scrolling as fast and as smooth as possible, %@ does not show the poster until scrolling has stopped.", nil),
                      LocalizedString(@"IMDb's licensing fees are unfortunately too high for me to afford. Sorry!", nil),
                      LocalizedString(@"See the section on IMDb.", nil),
                      LocalizedString(@"Currently Blockbuster does not provide a supported API for 3rd party applications to plug into. When they do, I will add support for Blockbuster rentals.", nil),
                      LocalizedString(@"Apple does not provide a mechanism for 3rd party applications to change their icon. When they do, I will provide this capability.", nil),
                      LocalizedString(@"Tap the 'Send Feedback' button above to contact me directly about anything else you need. Cheers! :-)", nil), nil];
  
  [self generateOnlineHelpFiles:questions answers:answers];
  
  NSArray* result = [FileUtilities readObject:self.questionsAndAnswersFile];
  if (result.count > 0) {
    return result;
  }
  
  questions = [self makeReplacements:questions];
  answers = [self makeReplacements:answers];
  
  return [NSArray arrayWithObjects:questions, answers, nil];
}


- (void) saveQuestionsAndAnswers:(NSArray*) value {
  [FileUtilities writeObject:value toFile:self.questionsAndAnswersFile];
}


- (NSArray*) questionsAndAnswers {
  return questionsAndAnswersData.value;
}


- (void) updateBackgroundEntryPointWorker {
  NSString* address = [NSString stringWithFormat:@"http://%@.appspot.com/LookupHelpListings%@?id=%@&language=%@",
                       [Application apiHost], [Application apiVersion],
                       [[NSBundle mainBundle] bundleIdentifier],
                       [LocaleUtilities preferredLanguage]];
  
  XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:address pause:NO];
  
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
  
  questions = [self makeReplacements:questions];
  answers = [self makeReplacements:answers];
  
  if (questions.count == 0 || answers.count == 0) {
    return;
  }
  
  NSArray* result = [NSArray arrayWithObjects:questions, answers, nil];
  questionsAndAnswersData.value = result;
}


- (void) updateBackgroundEntryPoint {
  NSDate* modificationDate = [FileUtilities modificationDate:[self questionsAndAnswersFile]];
  if (modificationDate != nil) {
    if (ABS(modificationDate.timeIntervalSinceNow) < ONE_WEEK) {
      return;
    }
  }
  
  NSString* notification = [LocalizedString(@"Help", nil) lowercaseString];
  [NotificationCenter addNotification:notification];
  {
    [self updateBackgroundEntryPointWorker];
  }
  [NotificationCenter removeNotification:notification];
}

@end
