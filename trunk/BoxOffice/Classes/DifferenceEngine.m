//
//  DifferenceEngine.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DifferenceEngine.h"

#define MaxLength 128

@implementation DifferenceEngine

@synthesize S;
@synthesize T;
@synthesize costTable;

- (void) dealloc
{
    self.S = nil;
    self.T = nil;
    self.costTable = nil;
    [super dealloc];
}

- (id) init
{
    return [self initWithAddCost:1
                      deleteCost:1
                      switchCost:1
                   transposeCost:1];
}

- (id) initWithAddCost:(NSInteger) add
            deleteCost:(NSInteger) delete
            switchCost:(NSInteger) switch_
         transposeCost:(NSInteger) transpose
{
    if (self = [super init])
    {
        addCost = add;
        deleteCost = delete;
        switchCost = switch_;
        transposeCost = transpose;
        
        self.costTable = [[Matrix alloc] initWithX:MaxLength Y:MaxLength];
        
        for (NSInteger i = 0; i < MaxLength; i++)
        {
            [self.costTable setX:i Y:0 value:(i * deleteCost)];
            [self.costTable setX:0 Y:i value:(i * addCost)];
        }
    }
    
    return self;
}

- (BOOL) initializeFrom:(NSString*) from
                     to:(NSString*) to
          withThreshold:(NSInteger) threshold
{
    self.S = from;
    self.T = to;
    
    cached_S_length = [self.S length];
    cached_T_length = [self.T length];
    
    if (cached_T_length > MaxLength || cached_S_length > MaxLength)
    {
        return false;
    }
    
    costThreshold = threshold;
    
    if (costThreshold >= 0)
    {
        if (deleteCost > 0)
        {
            NSInteger minimumTLength = cached_S_length - (costThreshold * deleteCost);
            
            if (cached_T_length < minimumTLength)
            {
                return NO;
            }
        }
        
        if (addCost > 0)
        {
            NSInteger minimumSLength = cached_T_length - (costThreshold * addCost);
            
            if (cached_S_length < minimumSLength)
            {
                return NO;
            }
        }
    }
    
    return YES;
}

- (NSInteger) minX:(NSInteger) x
                 Y:(NSInteger) y
{
    return x < y ? x : y;
}

- (NSInteger) editDistanceFrom:(NSString*) from
                            to:(NSString*) to
{
    return [self editDistanceFrom:from to:to withThreshold:-1];
}

- (NSInteger) editDistanceFrom:(NSString*) from
                            to:(NSString*) to
                 withThreshold:(NSInteger) threshold
{
    if ([self initializeFrom:from to:to withThreshold:threshold] == NO)
    {
        return NSIntegerMax;
    }
    
    for (NSInteger i = 1; i < cached_S_length; i++)
    {
        BOOL rowIsUnderThreshold = (costThreshold < 0);
        
        for (NSInteger j = 1; j < cached_T_length; j++)
        {
            const NSInteger adds = 1;
            const NSInteger deletes = 1;
            NSInteger switches = ([self.S characterAtIndex:(i - 1)] == [self.T characterAtIndex:(j - 1)]) ? 0 : 1;
            
            NSInteger totalDeleteCost = [self.costTable getX:(i - 1) Y:j] + (deletes * deleteCost);
            NSInteger totalAddCost = [self.costTable getX:i Y:(j - 1)] + (adds * addCost);
            NSInteger totalSwitchCost = [self.costTable getX:(i - 1) Y:(j - 1)] + (switches * switchCost);
            NSInteger cost = [self minX:totalDeleteCost Y:[self minX:totalAddCost Y:totalSwitchCost]];
            
            if (i >= 2 && j >= 2)
            {
                NSInteger transposes = 1 + (([self.S characterAtIndex:(i - 1)] == [self.T characterAtIndex:j]) ? 0 : 1) + 
                                     (([self.S characterAtIndex:i] == [self.T characterAtIndex:(j - 1)]) ? 0 : 1);
                NSInteger tCost = [self.costTable getX:(i - 2) Y:(j - 2)] + (transposes * transposeCost);
                
                [self.costTable setX:i Y:j value:[self minX:cost Y:tCost]];
            }
            else
            {
                [self.costTable setX:i Y:j value:cost];
            }
            
            if (costThreshold >= 0)
            {
                rowIsUnderThreshold |= (cost <= costThreshold);
            }
        }
        
        if (!rowIsUnderThreshold)
        {
            return NSIntegerMax;
        }
    }
    
    return [self.costTable getX:cached_S_length Y:cached_T_length];    
}

@end
