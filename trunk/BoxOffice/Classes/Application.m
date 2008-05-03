//
//  Application.m
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Application.h"


@implementation Application

static NSString* _supportFolder = nil;
static NSLock* gate = nil;
static NSString* _posterFolder = nil;
static NSDateFormatter* dateFormatter = nil;

+ (void) initialize
{
    if (self == [Application class])
    {
        gate = [[NSLock alloc] init];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
}

+ (void) createDirectory:(NSString*) folder
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:folder])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:folder attributes:nil];
    }    
}

+ (NSString*) supportFolder
{
    [gate lock];
    {
        if (_supportFolder == nil)
        {
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, /*expandTilde:*/YES);
            
            NSString* executableName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
            NSString* folder = [[paths objectAtIndex:0] stringByAppendingPathComponent:executableName];
            
            [Application createDirectory:folder];
            
            _supportFolder = folder;
        }
    }
    [gate unlock];
    
    return _supportFolder;
}

+ (NSString*) posterFolder
{
    [gate lock];
    {
        if (_posterFolder == nil)
        {
            NSString* folder = [[Application supportFolder] stringByAppendingPathComponent:@"Posters"];
            
            [Application createDirectory:folder];
            
            _posterFolder = folder;
        }
    }
    [gate unlock];
    
    return _posterFolder;
}

+ (NSString*) formatDate:(NSDate*) date
{
    NSString* result;
    [gate lock];
    {
        result = [dateFormatter stringFromDate:date];
    }
    [gate unlock];
    return result;
}

@end
