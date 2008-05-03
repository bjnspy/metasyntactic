//
//  TheaterShowtimesXmlParser.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface TheaterShowtimesXmlParser : NSObject {
    NSMutableArray* theaters;
    NSMutableString* stringBuffer;
    
    NSString* theaterName;
    NSString* theaterAddress;
    
    NSString* movieName;
    NSMutableArray* showtimes;
    
    NSDictionary* movieToShowtimeMap;
}

@property (retain) NSMutableArray* theaters;
@property (retain) NSMutableString* stringBuffer;
@property (retain) NSString* theaterName;
@property (retain) NSString* theaterAddress;
@property (retain) NSString* movieName;
@property (retain) NSMutableArray* showtimes;
@property (retain) NSDictionary* movieToShowtimeMap;

- (id) initWithData:(NSData*) data;
- (void) dealloc;

- (void)        parser:(NSXMLParser*) parser
       didStartElement:(NSString*) elementName
          namespaceURI:(NSString*) namespaceURI
         qualifiedName:(NSString*) qName
            attributes:(NSDictionary*) attributeDict;

- (void)        parser:(NSXMLParser*) parser
         didEndElement:(NSString*) elementName
          namespaceURI:(NSString*) namespaceURI
         qualifiedName:(NSString*) qName;

- (void)        parser:(NSXMLParser*) parser
       foundCharacters:(NSString*) string;

@end
