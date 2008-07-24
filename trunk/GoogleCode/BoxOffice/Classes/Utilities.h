//
//  Utilities.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/8/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "XmlElement.h"
#import "XmlDocument.h"

@interface Utilities : NSObject {
    
}

+ (BOOL) isNilOrEmpty:(NSString*) string;

+ (id) findSmallestElementInArray:(NSArray*) array 
                    usingFunction:(NSInteger(*)(id, id, void *)) comparator
                          context:(void*) context;

+ (id) findSmallestElementInArray:(NSArray*) array 
                    usingFunction:(NSInteger(*)(id, id, void*, void*)) comparator
                          context1:(void*) context1
                          context2:(void*) context2;

+ (NSString*) titleForMovie:(XmlElement*) element;

+ (NSData*) downloadData:(NSString*) urlString;
+ (XmlElement*) downloadXml:(NSString*) urlString;
+ (XmlElement*) makeSoapRequest:(XmlElement*) element
                          atUrl:(NSString*) urlString
                         atHost:(NSString*) host
                     withAction:(NSString*) soapAction;

+ (id) removeRandomElement:(NSMutableArray*) array;

+ (NSInteger) hashString:(NSString*) string;

+ (NSArray*) nonNilArray:(NSArray*) array;
+ (NSString*) nonNilString:(NSString*) string;

+ (void) writeObject:(id) object toFile:(NSString*) file;

@end
