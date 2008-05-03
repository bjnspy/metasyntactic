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

+ (void) initialize
{
    if (self == [Application class])
    {
        gate = [[NSLock alloc] init];
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
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:folder])
            {
                [[NSFileManager defaultManager] createDirectoryAtPath:folder attributes:nil];
            }
            
            _supportFolder = folder;
        }
    }
    [gate unlock];
    
    return _supportFolder;
}

@end
