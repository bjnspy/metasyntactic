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

static NSString* dataFolder = nil;
static NSString* documentsFolder = nil;
static NSString* tempFolder = nil;
static NSString* trailersFolder = nil;
static NSString* postersFolder = nil;
static NSString* searchFolder = nil;
static NSString* supportFolder = nil;

static DifferenceEngine* differenceEngine = nil;
static NSString* starString = nil;

+ (void) initialize {
    if (self == [Application class]) {
        gate = [[NSRecursiveLock alloc] init];
                        
        differenceEngine = [[DifferenceEngine engine] retain];
    }
}

+ (void) createDirectory:(NSString*) folder {
    if (![[NSFileManager defaultManager] fileExistsAtPath:folder]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:NULL];
    }    
}

+ (NSString*) documentsFolder {
    [gate lock];
    {
        if (documentsFolder == nil) {
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, /*expandTilde:*/YES);
            NSString* folder = [paths objectAtIndex:0];
            
            [Application createDirectory:folder];
            
            documentsFolder = [folder retain];
        }
    }
    [gate unlock];
    
    return documentsFolder;
}

+ (NSString*) supportFolder {
    [gate lock];
    {
        if (supportFolder == nil) {
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, /*expandTilde:*/YES);
            
            NSString* executableName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
            NSString* folder = [[paths objectAtIndex:0] stringByAppendingPathComponent:executableName];
            
            [Application createDirectory:folder];
            
            supportFolder = [folder retain];
        }
    }
    [gate unlock];
    
    return supportFolder;
}

+ (NSString*) tempFolder {
    [gate lock];
    {
        if (tempFolder == nil) {
            tempFolder = [NSTemporaryDirectory() retain];
        }
    }
    [gate unlock];
    
    return tempFolder;
}

+ (NSString*) dataFolder {
    [gate lock];
    {
        if (dataFolder == nil) {
            NSString* parent = [Application supportFolder];
            NSString* folder = [parent stringByAppendingPathComponent:@"Data"];
            
            [Application createDirectory:folder];
            
            dataFolder = [folder retain];
        }
    }
    [gate unlock];
    
    return dataFolder;
}

+ (NSString*) searchFolder {
    [gate lock];
    {
        if (searchFolder == nil) {
            NSString* parent = [Application supportFolder];
            NSString* folder = [parent stringByAppendingPathComponent:@"Search"];
            
            [Application createDirectory:folder];
            
            searchFolder = [folder retain];
        }
    }
    [gate unlock];
    
    return searchFolder;
}

+ (NSString*) randomString {
    NSMutableString* string = [NSMutableString string];
    for (int i = 0; i < 8; i++) {
        [string appendFormat:@"%c", ((rand() % 26) + 'a')];
    }
    return string;
}

+ (NSString*) uniqueTemporaryFolder {
    NSString* finalDir;
    
    [gate lock];
    {
        NSFileManager* manager = [NSFileManager defaultManager];
        
        NSString* tempDir = [Application tempFolder];
        do {
            NSString* random = [Application randomString];
            finalDir = [tempDir stringByAppendingPathComponent:random];
        } while ([manager fileExistsAtPath:finalDir]);
        
        [Application createDirectory:finalDir];
    }
    [gate unlock];
    
    return finalDir; 
}

+ (NSString*) movieMapFile {
    return [[Application dataFolder] stringByAppendingPathComponent:@"MovieMap.plist"];
}

+ (NSString*) moviesFile {
    return [[Application dataFolder] stringByAppendingPathComponent:@"Movies.plist"];
}

+ (NSString*) ratingsFile:(NSString*) provider {
    return [[Application dataFolder] stringByAppendingPathComponent:[[@"Ratings" stringByAppendingString:[NSString stringWithFormat:@"-%@", provider]] stringByAppendingPathExtension:@"plist"]];
}

+ (NSString*) theatersFile {
    return [[Application dataFolder] stringByAppendingPathComponent:@"Theaters.plist"];
}

+ (NSString*) reviewsFolder:(NSString*) ratingsProvider {
    NSString* grandParent = [Application supportFolder];
    NSString* parent = [grandParent stringByAppendingPathComponent:@"Reviews"];
    NSString* folder = [parent stringByAppendingPathComponent:ratingsProvider];
    
    [Application createDirectory:folder];
    
    return folder;
}

+ (NSString*) trailersFolder {
    [gate lock];
    {
        if (trailersFolder == nil) {
            NSString* parent = [Application supportFolder];
            NSString* folder = [parent stringByAppendingPathComponent:@"Trailers"];
            
            [Application createDirectory:folder];
            
            trailersFolder = [folder retain];
        }
    }
    [gate unlock];
    
    return trailersFolder;
}

+ (NSString*) postersFolder {
    [gate lock];
    {
        if (postersFolder == nil) {
            NSString* parent = [Application supportFolder];
            NSString* folder = [parent stringByAppendingPathComponent:@"Posters"];
            
            [Application createDirectory:folder];
            
            postersFolder = [folder retain];
        }
    }
    [gate unlock];
    
    return postersFolder;
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
    //return @"http://metaboxoffice6.appspot.com";
    return @"http://localhost:8086";
}

+ (NSMutableArray*) hosts {
    return [NSMutableArray arrayWithObjects:
            @"metaboxoffice",
            @"metaboxoffice2",
            @"metaboxoffice3",
            @"metaboxoffice4",
            @"metaboxoffice5", nil]; 
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
