//
//  MultiDictionary.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/8/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

@interface MultiDictionary : NSObject {
    NSMutableDictionary* dictionary;
}

@property (retain) NSMutableDictionary* dictionary;

+ (MultiDictionary*) dictionary;

- (void) addObject:(id) object
            forKey:(id) key;

- (void) addObjects:(NSArray*) objects
             forKey:(id) key;

- (NSArray*) objectsForKey:(id) key;

@end
