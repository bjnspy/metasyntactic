//
//  MutableExtensionRegistry.h
//  ProtocolBuffers
//
//  Created by Cyrus Najmabadi on 6/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ExtensionRegistry.h"

@interface PBMutableExtensionRegistry : PBExtensionRegistry {
@private
  NSMutableDictionary* mutableClassMap;
}

+ (PBMutableExtensionRegistry*) registry;

- (void) addExtension:(id<PBExtensionField>) extension;

@end