//
//  XmlSerializer.h
//  BoxOffice
//
//  Created by Peter Schmitt on 5/3/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "XmlElement.h"
#import "XmlDocument.h"

@interface XmlSerializer : NSObject {
}

+ (NSString*) serializeElement:(XmlElement*) root;
+ (NSString*) serializeDocument:(XmlDocument*) document;

@end
