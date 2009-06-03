//
//  MutableExtensionRegistry.m
//  ProtocolBuffers
//
//  Created by Cyrus Najmabadi on 6/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MutableExtensionRegistry.h"

#import "ExtensionField.h"

@interface PBMutableExtensionRegistry()
@property (retain) NSMutableDictionary* mutableClassMap;
@end

@implementation PBMutableExtensionRegistry

@synthesize mutableClassMap;

- (void) dealloc {
  self.mutableClassMap = nil;
  [super dealloc];
}


- (id) initWithClassMap:(NSMutableDictionary*) mutableClassMap_ {
  if ((self = [super initWithClassMap:mutableClassMap_])) {
    self.mutableClassMap = mutableClassMap_;
  }
  
  return self;
}


+ (PBMutableExtensionRegistry*) registry {
  return [[[PBMutableExtensionRegistry alloc] initWithClassMap:[NSMutableDictionary dictionary]] autorelease];
}


- (void) addExtension:(id<PBExtensionField>) extension {
  if (extension == nil) {
    return;
  }
  
  Class extendedClass = [extension extendedClass];
  id key = [self keyForClass:extendedClass];
  
  NSMutableDictionary* extensionMap = [classMap objectForKey:key];
  if (extensionMap == nil) {
    extensionMap = [NSMutableDictionary dictionary];
    [mutableClassMap setObject:extensionMap forKey:key];
  }
  
  [extensionMap setObject:extension
                   forKey:[NSNumber numberWithInteger:[extension fieldNumber]]];
}


@end
