//
//  CachedCell.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CachedCell.h"

@implementation CachedCell

@synthesize indexPath;
@synthesize cellCache;

- (void) dealloc { 
    self.indexPath = nil;
    self.cellCache = nil;
    
    [super dealloc];
}


- (id) initWithFrame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
    }
    
    return self;
}


- (void) drawRectWorker:(CGRect) rect {
    @throw [NSException exceptionWithName:@"Improper Subclassing" reason:@"" userInfo:nil];
}


- (void) drawRect:(CGRect) rect {
    if (indexPath == nil) {
        [super drawRect:rect];
    } else {
        UIImage* cached = [cellCache objectForKey:indexPath];
        if (cached == nil) {
            CGRect bounds = self.bounds;
            
            UIGraphicsBeginImageContext(bounds.size);
            {
                [super drawRect:rect];
                cached = UIGraphicsGetImageFromCurrentImageContext();
            }
            UIGraphicsEndImageContext();
            
            [cellCache setObject:cached forKey:indexPath];
        } else {
            NSLog(@"");
        }
        
        [cached drawAtPoint:CGPointMake(0,0)];
    }
    
    /*
    [super drawRect:rect];

    if (indexPath == nil) {
        [self drawRectWorker:rect];
    } else {
        UIImage* cached = [cellCache objectForKey:indexPath];
        if (cached == nil) {
            CGRect bounds = self.bounds;
            
            UIGraphicsBeginImageContext(bounds.size);
            {
                [self drawRectWorker:rect];
                cached = UIGraphicsGetImageFromCurrentImageContext();
            }
            UIGraphicsEndImageContext();
            
            [cellCache setObject:cached forKey:indexPath];
        }
        
        [cached drawAtPoint:CGPointMake(0,0)];
    }
     */
}

@end
