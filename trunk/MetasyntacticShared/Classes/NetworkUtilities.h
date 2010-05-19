// Copyright 2010 Cyrus Najmabadi
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

@interface NetworkUtilities : NSObject {
}

+ (XmlElement*) xmlWithContentsOfAddress:(NSString*) address;
+ (XmlElement*) xmlWithContentsOfAddress:(NSString*) address pause:(BOOL) pause;
+ (XmlElement*) xmlWithContentsOfAddress:(NSString*) address response:(NSHTTPURLResponse**) response;
+ (XmlElement*) xmlWithContentsOfAddress:(NSString*) address response:(NSHTTPURLResponse**) response pause:(BOOL) pause;
+ (XmlElement*) xmlWithContentsOfUrl:(NSURL*) url;
+ (XmlElement*) xmlWithContentsOfUrl:(NSURL*) url response:(NSHTTPURLResponse**) response;
+ (XmlElement*) xmlWithContentsOfUrl:(NSURL*) url response:(NSHTTPURLResponse**) response pause:(BOOL) pause;
+ (XmlElement*) xmlWithContentsOfUrlRequest:(NSURLRequest*) url;
+ (XmlElement*) xmlWithContentsOfUrlRequest:(NSURLRequest*) url response:(NSHTTPURLResponse**) response;
+ (XmlElement*) xmlWithContentsOfUrlRequest:(NSURLRequest*) url response:(NSHTTPURLResponse**) response pause:(BOOL) pause;
+ (NSString*) stringWithContentsOfAddress:(NSString*) address;
+ (NSString*) stringWithContentsOfAddress:(NSString*) address pause:(BOOL) pause;
+ (NSString*) stringWithContentsOfUrl:(NSURL*) url;
+ (NSString*) stringWithContentsOfUrl:(NSURL*) url pause:(BOOL) pause;
+ (NSString*) stringWithContentsOfUrlRequest:(NSURLRequest*) url;
+ (NSString*) stringWithContentsOfUrlRequest:(NSURLRequest*) url pause:(BOOL) pause;
+ (NSData*) dataWithContentsOfAddress:(NSString*) address;
+ (NSData*) dataWithContentsOfAddress:(NSString*) address pause:(BOOL) pause;
+ (NSData*) dataWithContentsOfAddress:(NSString*) address response:(NSHTTPURLResponse**) response;
+ (NSData*) dataWithContentsOfAddress:(NSString*) address response:(NSHTTPURLResponse**) response pause:(BOOL) pause;
+ (NSData*) dataWithContentsOfAddress:(NSString*) address response:(NSHTTPURLResponse**) response error:(NSError**) error pause:(BOOL) pause;
+ (NSData*) dataWithContentsOfUrl:(NSURL*) url;
+ (NSData*) dataWithContentsOfUrl:(NSURL*) url response:(NSHTTPURLResponse**) response;
+ (NSData*) dataWithContentsOfUrl:(NSURL*) url response:(NSHTTPURLResponse**) response pause:(BOOL) pause;
+ (NSData*) dataWithContentsOfUrl:(NSURL*) url response:(NSHTTPURLResponse**) response error:(NSError**) error pause:(BOOL) pause;
+ (NSData*) dataWithContentsOfUrlRequest:(NSURLRequest*) url;
+ (NSData*) dataWithContentsOfUrlRequest:(NSURLRequest*) url response:(NSHTTPURLResponse**) response;
+ (NSData*) dataWithContentsOfUrlRequest:(NSURLRequest*) url pause:(BOOL) pause;
+ (NSData*) dataWithContentsOfUrlRequest:(NSURLRequest*) url response:(NSHTTPURLResponse**) response pause:(BOOL) pause;
+ (NSData*) dataWithContentsOfUrlRequest:(NSURLRequest*) url response:(NSHTTPURLResponse**) response error:(NSError**) error pause:(BOOL) pause;

+ (BOOL) isNetworkAvailable;

+ (NSMutableURLRequest*) createRequest:(NSURL*) url;

@end
