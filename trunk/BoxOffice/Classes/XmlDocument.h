//
//  XmlDocument.h
//  BoxOffice
//
//  Created by Peter Schmitt on 5/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "XmlElement.h"


@interface XmlDocument : NSObject {
	XmlElement* root;
	NSString* version;
	NSString* encoding;
}

@property (retain) XmlElement* root;
@property (copy) NSString* version;
@property (copy) NSString* encoding;

+ (XmlDocument*) documentWithRoot:(XmlElement*) root;

- (id) initWithRoot:(XmlElement*) root;
- (id) initWithRoot:(XmlElement*) root 
			version:(NSString*) version 
		   encoding:(NSString*) encoding;
- (void) dealloc;

@end
