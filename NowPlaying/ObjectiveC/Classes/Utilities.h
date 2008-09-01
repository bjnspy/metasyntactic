// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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

+ (XmlElement*) makeSoapRequest:(XmlElement*) element
                          atUrl:(NSString*) urlString
                         atHost:(NSString*) host
                     withAction:(NSString*) soapAction;

+ (id) removeRandomElement:(NSMutableArray*) array;

+ (NSInteger) hashString:(NSString*) string;

+ (NSArray*) nonNilArray:(NSArray*) array;
+ (NSString*) nonNilString:(NSString*) string;

+ (void) writeObject:(id) object toFile:(NSString*) file;
+ (id) readObject:(NSString*) file;

+ (NSString*) stringByAddingPercentEscapes:(NSString*) string;

+ (NSString*) generateShowtimeLinks:(NowPlayingModel*) model
                              movie:(Movie*) movie
                            theater:(Theater*) theater
                       performances:(NSArray*) performances;

+ (NSString*) generateShowtimesRetrievedOnString:(NSDate*) syncDate;

+ (XmlElement*) xmlWithContentsOfAddress:(NSString*) address;
+ (XmlElement*) xmlWithContentsOfUrl:(NSURL*) url;
+ (NSString*) stringWithContentsOfAddress:(NSString*) address;
+ (NSString*) stringWithContentsOfUrl:(NSURL*) url;
+ (NSData*) dataWithContentsOfAddress:(NSString*) address;
+ (NSData*) dataWithContentsOfUrl:(NSURL*) url;

+ (NSString*) stripHtmlCodes:(NSString*) string;

@end