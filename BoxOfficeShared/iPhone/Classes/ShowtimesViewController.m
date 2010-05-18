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

#import "ShowtimesViewController.h"

#import "Application.h"
#import "BoxOfficeStockImages.h"
#import "LookupResult.h"
#import "Model.h"
#import "Performance.h"
#import "Theater.h"
#import "Utilities.h"
#import "WarningView.h"

@interface ShowtimesViewController()
@property (retain) Movie* movie;
@property (retain) Theater* theater;
@property (retain) NSArray* performances;
@property (retain) NSArray* calendarData;
@property (retain) NSMutableDictionary* indexToActionMap;
@end


@implementation ShowtimesViewController

typedef enum {
  EmailListing,
  SendSMS,
  AddToCalendar,
  RemoveFromCalendar,
  OrderTickets
} ShowtimeAction;

typedef enum {
  SpanThisEvent,
  SpanFutureEvents
} EventSpan;

@synthesize theater;
@synthesize movie;
@synthesize performances;
@synthesize calendarData;
@synthesize indexToActionMap;

- (void) dealloc {
  self.theater = nil;
  self.movie = nil;
  self.performances = nil;
  self.calendarData = nil;
  self.indexToActionMap = nil;

  [super dealloc];
}


- (void) initializePerformances {
  NSArray* allPerformances =  [[Model model] moviePerformances:movie
                                                    forTheater:theater];
  NSMutableArray* result = [NSMutableArray array];
  
  NSDate* now = [DateUtilities currentTime];
  
  for (Performance* performance in allPerformances) {
    if ([DateUtilities isToday:[Model model].searchDate]) {
      NSDate* time = performance.time;
      
      // skip times that have already passed.
      if ([now compare:time] == NSOrderedDescending) {
        
        // except for times that are before 4 AM
        NSDateComponents* components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit
                                                                       fromDate:time];
        if (components.hour > 4) {
          continue;
        }
      }
    }
    
    [result addObject:performance];
  }
  
  self.performances = result;
}


- (NSString*) performanceIdentifier:(Performance*) performance {
  return [NSString stringWithFormat:@"%@ - %@ - %@ - %@",
                              movie.canonicalTitle,
                              theater.name,
                              [DateUtilities formatFullDate:[Model model].searchDate],
                              performance.timeString];
}


- (NSString*) eventIdentifierForPerformance:(Performance*) performance {
  NSString* perfIdentifier = [self performanceIdentifier:performance];
  return [[Model model] eventIdentifierForPerformanceIdentifier:perfIdentifier];
}


- (id) eventWithIdentifier:(id) arg {
  return nil;
}


- (void) initializeCalendarData {
  NSMutableArray* result = [NSMutableArray array];
  
  if ([Application canAccessCalendar]) {
    Class class = NSClassFromString(@"EKEventStore");
    id store = [[[class alloc] init] autorelease];
    
    for (Performance* performance in performances) {
      id event = [store eventWithIdentifier:[self eventIdentifierForPerformance:performance]];
      BOOL inCalendar = event != nil;
      
      [result addObject:[NSNumber numberWithBool:inCalendar]];
    }
  } else {
    for (Performance* performance in performances) {
      [result addObject:[NSNumber numberWithBool:NO]];
    }
  }
  
  self.calendarData = result;
}


- (void) onBeforeReloadTableViewData {
  [super onBeforeReloadTableViewData];
  
  [self initializePerformances];
  [self initializeCalendarData];
}


- (id) initWithTheater:(Theater*) theater_
                 movie:(Movie*) movie_
                 title:(NSString*) title_ {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    self.theater = theater_;
    self.movie = movie_;
    self.title = title_;
  }

  return self;
}


- (void) didReceiveMemoryWarningWorker {
  [super didReceiveMemoryWarningWorker];
  self.performances = nil;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
  return 3;
}


- (NSInteger)       tableView:(UITableView*) tableView
        numberOfRowsInSection:(NSInteger) section {
  if (section == 0) {
    if (theater.phoneNumber.length == 0) {
      return 1;
    } else {
      return 2;
    }
  } else if (section == 1) {
    return 2;
  } else if (section == 2) {
    return performances.count;
  }

  return 0;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
  if (section == 0) {
    return nil;
  } else if (section == 1) {
    return nil;
  } else if (section == 2 && performances.count) {
    if ([DateUtilities isToday:[Model model].searchDate]) {
      return LocalizedString(@"Today", nil);
    } else {
      return [DateUtilities formatFullDate:[Model model].searchDate];
    }
  }

  return nil;
}


- (UIView*)        tableView:(UITableView*) tableView
      viewForFooterInSection:(NSInteger) section {
  if (section == 1) {
    if (performances.count > 0 ) {
      if ([[Model model] isStale:theater]) {
        return [WarningView viewWithText:[[Model model] showtimesRetrievedOnString:theater]];
      }
    }
  }

  return nil;
}

- (CGFloat)          tableView:(UITableView*) tableView
      heightForFooterInSection:(NSInteger) section {
  WarningView* view = (id)[self tableView:tableView viewForFooterInSection:section];
  if (view != nil) {
    return [view height:self];
  }

  return -1;
}


- (UITableViewCell*) showtimeCellForRow:(NSInteger) row {
  static NSString* reuseIdentifier = @"reuseIdentifier";

  UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:reuseIdentifier] autorelease];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    cell.textLabel.textColor = [ColorCache commandColor];
    cell.indentationLevel = 10;
  }

  Performance* performance = [performances objectAtIndex:row];
  BOOL isInCalendar = [[calendarData objectAtIndex:row] boolValue];
  
  cell.textLabel.text = performance.timeString;
  
  UIImage* actionImage = BoxOfficeStockImage(@"Action.png");
  UIImage* calendarImage = BoxOfficeStockImage(@"CalendarChecked.png");
  
  UIImageView* actionImageView = [[[UIImageView alloc] initWithImage:actionImage] autorelease];
  UIImageView* calendarImageView = [[[UIImageView alloc] initWithImage:calendarImage] autorelease];

  CGRect calendarFrame = calendarImageView.frame;
  
  CGRect actionFrame = actionImageView.frame;
  actionFrame.origin.x = calendarFrame.size.width + 10;
  actionFrame.origin.y = 
  (NSInteger)((calendarFrame.size.height - actionFrame.size.height) / 2);
  actionImageView.frame = actionFrame;
  
  CGRect frame = CGRectMake(0, 0, 
                            actionFrame.size.width + calendarFrame.size.width + 10 + 10,
                            MAX(actionFrame.size.height, calendarFrame.size.height));
  
  UIView* view = [[[UIView alloc] initWithFrame:frame] autorelease];
  
  [view addSubview:actionImageView]; 
  if (isInCalendar) {
    [view addSubview:calendarImageView];
  }
  
  cell.accessoryView = view;

  return cell;
}


- (UITableViewCell*) commandCellForRow:(NSInteger) row {
  AttributeCell* cell = [[[AttributeCell alloc] initWithReuseIdentifier:nil] autorelease];

  if (row == 0) {
    cell.textLabel.text = LocalizedString(@"Map", @"This string should try to be short.  So abbreviations are acceptable. It's a verb that means 'open a map to the currently listed address'");
    cell.detailTextLabel.text = [[Model model] simpleAddressForTheater:theater];
  } else {
    cell.textLabel.text = LocalizedString(@"Call", @"This string should try to be short.  So abbreviations are acceptable. It's a verb that means 'to make a phonecall'");
    cell.detailTextLabel.text = theater.phoneNumber;
  }

  return cell;
}


- (UITableViewCell*) infoCellForRow:(NSInteger) row {
  UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];

  cell.textLabel.textAlignment = UITextAlignmentCenter;
  cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
  cell.textLabel.textColor = [ColorCache commandColor];

  if (row == 0) {
    cell.textLabel.text = LocalizedString(@"E-mail listings", @"Title for a button. Needs to be very short. 2-3 words *max*. It means 'email the theater listings to a friend'");
  } else {
    cell.textLabel.text = LocalizedString(@"Change date", @"Title for a button. Needs to be very short. 2-3 words *max*. It means 'i want to change the date so i can see information from a different date'");
  }

  return cell;
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section == 0) {
    return [self commandCellForRow:indexPath.row];
  } else if (indexPath.section == 1) {
    return [self infoCellForRow:indexPath.row];
  } else if (indexPath.section == 2) {
    return [self showtimeCellForRow:indexPath.row];
  }

  return nil;
}


- (void) didSelectCommandAtRow:(NSInteger) row {
  if (row == 0) {
    [self.abstractNavigationController pushMapWithCenter:theater animated:YES];
  } else if (row == 1) {
    [Application makeCall:theater.phoneNumber];
  }
}


- (void) addAction:(ShowtimeAction) action title:(NSString*) title toSheet:(UIActionSheet*) actionSheet {
  NSInteger index = [actionSheet addButtonWithTitle:title];
  [indexToActionMap setObject:[NSNumber numberWithInteger:action]
                       forKey:[NSNumber numberWithInteger:index]];
}


- (void) didSelectShowtimeAtRow:(NSIndexPath*) indexPath {
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  Performance* performance = [performances objectAtIndex:indexPath.row];
  BOOL isInCalendar = [[calendarData objectAtIndex:indexPath.row] boolValue];
  
  UIActionSheet* actionSheet =
   [[[UIActionSheet alloc] initWithTitle:nil
                                delegate:self
                       cancelButtonTitle:nil
                  destructiveButtonTitle:nil 
                       otherButtonTitles:nil] autorelease];
  
  self.indexToActionMap = [NSMutableDictionary dictionary];
  [self addAction:EmailListing title:LocalizedString(@"E-mail listings", nil) toSheet:actionSheet];
  
  if ([AbstractApplication canSendText]) {
    [self addAction:SendSMS title:LocalizedString(@"Send SMS", nil) toSheet:actionSheet];
  }
  
  if ([Application canAccessCalendar]) {
    if (isInCalendar) {
      [self addAction:RemoveFromCalendar title:LocalizedString(@"Remove from Calendar", nil) toSheet:actionSheet];
    } else {
      [self addAction:AddToCalendar title:LocalizedString(@"Add to Calendar", nil) toSheet:actionSheet];
    }
  }
  
  if (performance.url.length > 0) {
    [self addAction:OrderTickets title:LocalizedString(@"Order Tickets", nil) toSheet:actionSheet];
  }
  
  actionSheet.cancelButtonIndex =
    [actionSheet addButtonWithTitle:LocalizedString(@"Cancel", nil)];
  
  actionSheet.tag = indexPath.row;
  
  [self showActionSheet:actionSheet];
}


- (void) didSelectEmailListings:(NSArray*) listings {
  NSString* subject = [NSString stringWithFormat:@"%@ - %@",
                       movie.canonicalTitle,
                       [DateUtilities formatFullDate:[Model model].searchDate]];
  NSMutableString* body = [NSMutableString string];
  
  [body appendString:@"<p>"];
  [body appendString:theater.name];
  [body appendString:@"<br/>"];
  [body appendString:@"<a href=\""];
  [body appendString:theater.mapUrl];
  [body appendString:@"\">"];
  [body appendString:[[Model model] simpleAddressForTheater:theater]];
  [body appendString:@"</a>"];
  
  [body appendString:@"<p>"];
  [body appendString:movie.canonicalTitle];
  [body appendString:@"<br/>"];
  
  [body appendString:[Utilities generateShowtimeLinks:[Model model]
                                                movie:movie
                                              theater:theater
                                         performances:listings]];
  
  [self openMailTo:nil
       withSubject:subject
              body:body
            isHTML:YES];
}


- (void) setMessageComposeDelegate:(id) arg {
}


- (void) setBody:(id) body {
}


- (void) sendSMS:(Performance*) performance {
  Class class = NSClassFromString(@"MFMessageComposeViewController");
  id controller =
  [[[class alloc] init] autorelease];
  
  [(id)controller setMessageComposeDelegate:(id)self];
  
  NSString* body;
  if ([DateUtilities isToday:[Model model].searchDate]) {
    body = [NSString stringWithFormat:@"%@ - %@ - %@",
                       movie.canonicalTitle,
                       theater.name,
                       performance.timeString];
  } else {
    body = [NSString stringWithFormat:@"%@ - %@ - %@ - %@",
                       movie.canonicalTitle,
                       theater.name,
                       [DateUtilities formatShortDate:[Model model].searchDate],
                       performance.timeString];
  }
  
  [controller setBody:body];
  
  [self presentModalViewController:controller animated:YES];
}


- (void)messageComposeViewController:(id)controller didFinishWithResult:(NSInteger)result {
  [self dismissModalViewControllerAnimated:YES];
}


+ (id) eventWithEventStore:(id) store {
  return nil;
}


- (void) setLocation:(id) location {
}


- (void) setStartDate:(id) date {
}


- (void) setEndDate:(id) date {
}


- (id) defaultCalendarForNewEvents {
  return nil;
}


- (id) eventIdentifier {
  return nil;
}


- (void) saveEvent:(id) event span:(EventSpan) span error:(NSError**) error {
}


- (void) removeEvent:(id) event span:(EventSpan) span error:(NSError**) error {
}


- (void) addToCalendar:(Performance*) performance {
  Class storeClass = NSClassFromString(@"EKEventStore");
  Class eventClass = NSClassFromString(@"EKEvent");
  
  id store = [[[storeClass alloc] init] autorelease];
  id event = [eventClass eventWithEventStore:store];
  
  NSCalendar* calendar = [NSCalendar currentCalendar];
  
  NSDate* day = [Model model].searchDate;
  NSDate* time = performance.time;
  
  NSDateComponents* dayComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                fromDate:day];
  NSDateComponents* timeComponents = [calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit
                                                fromDate:time];
  NSDateComponents* fullComponents = [[[NSDateComponents alloc] init] autorelease];
  [fullComponents setYear:dayComponents.year];
  [fullComponents setMonth:dayComponents.month];
  [fullComponents setDay:dayComponents.day];
  [fullComponents setHour:timeComponents.hour];
  [fullComponents setMinute:timeComponents.minute];
  
  NSDate* fullStartDate = [calendar dateFromComponents:fullComponents];
  NSDate* fullEndDate = [[[NSDate alloc] initWithTimeInterval:2 * ONE_HOUR sinceDate:fullStartDate] autorelease];
  
  [event setTitle:movie.canonicalTitle];
  [event setLocation:(id)theater.name];
  [event setStartDate:fullStartDate];
  [event setEndDate:fullEndDate];
  [event setCalendar:(id)[store defaultCalendarForNewEvents]];
  
  NSError* error = nil;
  [store saveEvent:event span:SpanThisEvent error:&error];

  if (error != nil) {
    [AlertUtilities showOkAlert:error.localizedDescription];
  }

  [[Model model] setEventIdentifier:[event eventIdentifier]
           forPerformanceIdentifier:[self performanceIdentifier:performance]];
  [self majorRefresh];
}


- (void) removeFromCalendar:(Performance*) performance {
  Class storeClass = NSClassFromString(@"EKEventStore");
  
  id store = [[[storeClass alloc] init] autorelease];
  id event = [store eventWithIdentifier:[self eventIdentifierForPerformance:performance]];

  if (event != nil) {  
    NSError* error = nil;
    [store removeEvent:event span:SpanThisEvent error:&error];
    [self majorRefresh];
  }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == actionSheet.cancelButtonIndex) {
    return;
  }
  
  NSInteger row = actionSheet.tag;
  Performance* performance = [performances objectAtIndex:row];
  
  ShowtimeAction action = [[indexToActionMap objectForKey:[NSNumber numberWithInteger:buttonIndex]] integerValue];
  
  if (action == EmailListing) {
    [self didSelectEmailListings:[NSArray arrayWithObject:performance]];
  } else if (action == SendSMS) {
    [self sendSMS:performance];
  } else if (action == AddToCalendar) {
    [self addToCalendar:performance];
  } else if (action == RemoveFromCalendar) {
    [self removeFromCalendar:performance];
  } else if (action == OrderTickets) {
    [self.commonNavigationController pushBrowser:performance.url animated:YES];
  }
}


- (void) didSelectInfoCellAtRow:(NSInteger) row {
  if (row == 0) {
    [self didSelectEmailListings:performances];
  } else {
    [self changeDate];
  }
}


- (void) onDataProviderUpdateSuccess:(LookupResult*) lookupResult context:(NSArray*) array {
  if (updateId != [array.firstObject integerValue]) {
    return;
  }

  NSDate* searchDate = array.lastObject;

  NSArray* lookupResultPerformances = [[lookupResult.performances objectForKey:theater.name] objectForKey:movie.canonicalTitle];

  if (lookupResultPerformances.count == 0) {
    NSString* text =
    [NSString stringWithFormat:
     LocalizedString(@"No listings found for '%@' at '%@' on %@", @"No listings found for 'The Dark Knight' at 'Regal Meridian 6' on 5/18/2008"),
     movie.canonicalTitle,
     theater.name,
     [DateUtilities formatShortDate:searchDate]];

    [self onDataProviderUpdateFailure:text context:array];
  } else {
    // find the up to date version of this theater and movie
    self.theater = [lookupResult.theaters objectAtIndex:[lookupResult.theaters indexOfObject:theater]];
    self.movie = [lookupResult.movies objectAtIndex:[lookupResult.movies indexOfObject:movie]];

    [super onDataProviderUpdateSuccess:lookupResult context:array];
  }
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section == 0) {
    [self didSelectCommandAtRow:indexPath.row];
  } else if (indexPath.section == 1) {
    [self didSelectInfoCellAtRow:indexPath.row];
  } else if (indexPath.section == 2) {
    [self didSelectShowtimeAtRow:indexPath];
  }
}

@end
