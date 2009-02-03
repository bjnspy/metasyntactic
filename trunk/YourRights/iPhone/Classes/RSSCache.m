//
//  RSSCache.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RSSCache.h"

#import "Application.h"
#import "FileUtilities.h"
#import "Item.h"
#import "NetworkUtilities.h"
#import "ThreadingUtilities.h"
#import "XmlElement.h"

@implementation RSSCache

static NSArray* titles;
static NSDictionary* titleToIdentifier;

+ (void) initialize {
    if (self == [RSSCache class]) {
        titles = [[NSArray arrayWithObjects:
                   NSLocalizedString(@"Action Alerts", nil),
                   NSLocalizedString(@"ACLU News", nil),
                   NSLocalizedString(@"Criminal Justice News", nil),
                   NSLocalizedString(@"Death Penalty News", nil),
                   NSLocalizedString(@"Disability Rights News", nil),
                   NSLocalizedString(@"Drug Policy News", nil),
                   NSLocalizedString(@"Free Speech News", nil),
                   NSLocalizedString(@"HIV/AIDS Rights News", nil),
                   NSLocalizedString(@"Immigrants Rights News", nil),
                   NSLocalizedString(@"Lesbian and Gay Rights News", nil),
                   NSLocalizedString(@"National Security News", nil),
                   NSLocalizedString(@"Police Practices News", nil),
                   NSLocalizedString(@"Prison News", nil),
                   NSLocalizedString(@"Privacy and Technology News", nil),
                   NSLocalizedString(@"Racial Justice News", nil),
                   NSLocalizedString(@"Racial Profiling News", nil),
                   NSLocalizedString(@"Religious Liberty News", nil),
                   NSLocalizedString(@"Reproductive Rights News", nil),
                   NSLocalizedString(@"Rights of the Poor News", nil),
                   NSLocalizedString(@"Safe and Free News", nil),
                   NSLocalizedString(@"Voting Rights News", nil),
                   NSLocalizedString(@"Women's Rights News", nil), nil] retain];
        
        titleToIdentifier = [[NSDictionary dictionaryWithObjects:
                              [NSArray arrayWithObjects:
                               @"http://action.aclu.org/feed/rss2_0/alerts.rss",
                               @"http://www.aclu.org/newsroom/Index_rss.xml",
                               @"http://www.aclu.org/crimjustice/feed.xml",
                               @"http://www.aclu.org/capital/feed.xml",
                               @"http://www.aclu.org/disability/feed.xml",
                               @"http://www.aclu.org/drugpolicy/feed.xml",
                               @"http://www.aclu.org/freespeech/feed.xml",
                               @"http://www.aclu.org/hiv/feed.xml",
                               @"http://www.aclu.org/immigrants/feed.xml",
                               @"http://www.aclu.org/lgbt/feed.xml",
                               @"http://www.aclu.org/natsec/feed.xml",
                               @"http://www.aclu.org/police/feed.xml",
                               @"http://www.aclu.org/prison/feed.xml",
                               @"http://www.aclu.org/privacy/feed.xml",
                               @"http://www.aclu.org/racialjustice/feed.xml",
                               @"http://www.aclu.org/police/racialprofiling/feed.xml",
                               @"http://www.aclu.org/religion/feed.xml",
                               @"http://www.aclu.org/reproductiverights/feed.xml",
                               @"http://www.aclu.org/rightsofthepoor/feed.xml",
                               @"http://www.aclu.org/safefree/feed.xml",
                               @"http://www.aclu.org/votingrights/feed.xml",
                               @"http://www.aclu.org/womensrights/feed.xml", nil]
                                                         forKeys:titles] retain];
    }
}


+ (NSArray*) titles {
    return titles;
}


- (void) dealloc {
    [super dealloc];
}


- (id) initWithModel:(Model*) model_ {
    if (self = [super initWithModel:model_]) {
    }
    
    return self;
}


+ (RSSCache*) cacheWithModel:(Model*) model {
    return [[[RSSCache alloc] initWithModel:model] autorelease];
}


- (void) update {
    [ThreadingUtilities backgroundSelector:@selector(updateBackgroundEntryPoint) onTarget:self gate:gate visible:YES];
}


- (NSString*) feedFile:(NSString*) identifier {
    NSString* name = [FileUtilities sanitizeFileName:identifier];
    return [[[Application rssDirectory] stringByAppendingPathComponent:name] stringByAppendingPathExtension:@"plist"];
}


- (Item*) processItem:(XmlElement*) itemElement {
    NSString* title = [[itemElement element:@"title"] text];
    NSString* link = [[itemElement element:@"link"] text];
    NSString* description = [[itemElement element:@"description"] text];
    NSString* date = [[itemElement element:@"pubDate"] text];
    NSString* author = [[itemElement element:@"author"] text];
    
    if (title.length == 0) {
        return nil;
    }
    
    return [Item itemWithTitle:title link:link description:description date:date author:author];
}


- (NSArray*) downloadFeed:(NSString*) identifier {
    XmlElement* rssElement = [NetworkUtilities xmlWithContentsOfAddress:identifier important:NO];
    XmlElement* channelElement = [rssElement element:@"channel"];
    
    NSMutableArray* items = [NSMutableArray array];
    
    for (XmlElement* itemElement in [channelElement elements:@"item"]) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            Item* item = [self processItem:itemElement];
            if (item != nil) {
                [items addObject:item];
            }
        }
        [pool release];
    }
    
    return items;
}


- (void) saveItems:(NSArray*) items toFile:(NSString*) file {
    NSMutableArray* result = [NSMutableArray array];
    
    for (Item* item in items) {
        [result addObject:item.dictionary];
    }
    
    [FileUtilities writeObject:result toFile:file];
}


- (void) updateTitle:(NSString*) title {
    NSString* identifier = [titleToIdentifier objectForKey:title];
    NSString* file = [self feedFile:identifier];
    
    if ([FileUtilities fileExists:file]) {
        NSDate* modificationDate = [FileUtilities modificationDate:file];
        
        if (ABS(modificationDate.timeIntervalSinceNow) < ONE_DAY) {
            return;
        }
    }
    
    NSArray* items = [self downloadFeed:identifier];
    
    if (items.count > 0) {
        [self saveItems:items toFile:file];
    }
}


- (void) updateBackgroundEntryPoint {
    for (NSString* title in titles) {
        [self updateTitle:title];
    }
}


@end
