//
//  Application.m
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/29/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "Application.h"


@implementation Application

static NSRecursiveLock* gate = nil;
static NSString* _supportFolder = nil;
static NSString* _dataFolder = nil;
static NSString* _postersFolder = nil;
static NSString* _documentsFolder = nil;
static NSDateFormatter* dateFormatter = nil;
static UIColor* commandColor = nil;
static UIImage* freshImage = nil;
static UIImage* rottenImage = nil;
static UIImage* emptyStarImage = nil;
static UIImage* filledStarImage = nil;
static DifferenceEngine* differenceEngine = nil;
static NSString* starString = nil;

+ (void) initialize {
    if (self == [Application class]) {
        gate = [[NSRecursiveLock alloc] init];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        commandColor = [[UIColor colorWithRed:0.32 green:0.4 blue:0.55 alpha:1] retain];
        
        freshImage      = [[UIImage imageNamed:@"Fresh.png"] retain];
        rottenImage     = [[UIImage imageNamed:@"Rotten.png"] retain];
        emptyStarImage  = [[UIImage imageNamed:@"Empty Star.png"] retain];
        filledStarImage = [[UIImage imageNamed:@"Filled Star.png"] retain];
                
        differenceEngine = [[DifferenceEngine engine] retain];
    }
}

+ (void) createDirectory:(NSString*) folder {
    if (![[NSFileManager defaultManager] fileExistsAtPath:folder]) {
        NSError* error;
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:&error];
    }    
}

+ (NSString*) documentsFolder {
    [gate lock];
    {
        if (_documentsFolder == nil) {
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, /*expandTilde:*/YES);
            NSString* folder = [paths objectAtIndex:0];
            
            [Application createDirectory:folder];
            
            _documentsFolder = [folder retain];
        }
    }
    [gate unlock];
    
    return _documentsFolder;
}

+ (NSString*) supportFolder {
    [gate lock];
    {
        if (_supportFolder == nil) {
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, /*expandTilde:*/YES);
            
            NSString* executableName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
            NSString* folder = [[paths objectAtIndex:0] stringByAppendingPathComponent:executableName];
            
            [Application createDirectory:folder];
            
            _supportFolder = [folder retain];
        }
    }
    [gate unlock];
    
    return _supportFolder;
}

+ (NSString*) dataFolder {
    [gate lock];
    {
        if (_dataFolder == nil) {
            NSString* parent = [Application supportFolder];
            NSString* folder = [parent stringByAppendingPathComponent:@"Data"];
            
            [Application createDirectory:folder];
            
            _dataFolder = [folder retain];
        }
    }
    [gate unlock];
    
    return _dataFolder;
}

+ (NSString*) moviesFile {
    return [[Application dataFolder] stringByAppendingPathComponent:@"Movies.plist"];
}

+ (NSString*) theatersFile {
    return [[Application dataFolder] stringByAppendingPathComponent:@"Theaters.plist"];
}

+ (NSString*) postersFolder {
    [gate lock];
    {
        if (_postersFolder == nil) {
            NSString* parent = [Application supportFolder];
            NSString* folder = [parent stringByAppendingPathComponent:@"Posters"];
            
            [Application createDirectory:folder];
            
            _postersFolder = [folder retain];
        }
    }
    [gate unlock];
    
    return _postersFolder;
}

+ (NSString*) formatDate:(NSDate*) date {
    NSString* result;
    [gate lock];
    {
        result = [dateFormatter stringFromDate:date];
    }
    [gate unlock];
    return result;
}

+ (UIColor*) commandColor {
    return commandColor;
}

+ (UIImage*) freshImage {
    return freshImage;
}

+ (UIImage*) rottenImage {
    return rottenImage;
}

+ (UIImage*) emptyStarImage {
    return emptyStarImage;
}

+ (UIImage*) filledStarImage {
    return filledStarImage;
}

+ (void) openBrowser:(NSString*) address {
    if (address == nil) {
        return;
    }
    
    NSURL* url = [NSURL URLWithString:address];
    [[UIApplication sharedApplication] openURL:url];
}

+ (void) openMap:(NSString*) address {
    NSString* urlString =
    [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", 
     [address stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding]];
    
    [self openBrowser:urlString];
}

+ (void) makeCall:(NSString*) phoneNumber {
    if (![[[UIDevice currentDevice] model] isEqual:@"iPhone"]) {
        // can't make a phonecall if you're not an iPhone.
        return;
    }
    
    NSString* urlString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    
    [self openBrowser:urlString];   
}

+ (DifferenceEngine*) differenceEngine {
    NSAssert([NSThread isMainThread], @"Cannot access difference engine from main thread.");
    return differenceEngine;
}

+ (NSString*) searchHost {
    return @"http://metaboxoffice4.appspot.com";
    //return @"http://localhost:8082";
}

+ (NSMutableArray*) hosts {
    return [NSMutableArray arrayWithObjects:
            @"metaboxoffice",
            @"metaboxoffice2",
            @"metaboxoffice3",
            @"metaboxoffice4",
            @"metaboxoffice5",
            @"metaboxoffice6", nil]; 
}

+ (unichar) starCharacter {
    return (unichar)0x2605;
}

+ (NSString*) starString {
    if (starString == nil) {
        unichar c = [Application starCharacter];
        starString = [NSString stringWithCharacters:&c length:1];
    }
    
    return starString;
}

@end
