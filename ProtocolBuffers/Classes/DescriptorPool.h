//
//  DescriptorPool.h
//  ProtocolBuffers
//
//  Created by Cyrus Najmabadi on 9/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DescriptorPool : NSObject {
    NSMutableArray* dependencies;
    NSMutableDictionary* descriptorsByName;
    NSMutableDictionary* fieldsByNumber;
    NSMutableDictionary* enumValuesByNumber;
}

@property (retain) NSMutableArray* dependencies;
@property (retain) NSMutableDictionary* descriptorsByName;
@property (retain) NSMutableDictionary* fieldsByNumber;
@property (retain) NSMutableDictionary* enumValuesByNumber;

+ (DescriptorPool*) poolWithDependencies:(NSArray*) dependencies;

@end
