// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

@interface NetworkUtilities : NSObject {
}

+ (XmlElement*) xmlWithContentsOfAddress:(NSString*) address        important:(BOOL) important;
+ (XmlElement*) xmlWithContentsOfUrl:(NSURL*) url                   important:(BOOL) important;
+ (XmlElement*) xmlWithContentsOfUrlRequest:(NSURLRequest*) url     important:(BOOL) important;
+ (NSString*) stringWithContentsOfAddress:(NSString*) address       important:(BOOL) important;
+ (NSString*) stringWithContentsOfUrl:(NSURL*) url                  important:(BOOL) important;
+ (NSString*) stringWithContentsOfUrlRequest:(NSURLRequest*) url    important:(BOOL) important;
+ (NSData*) dataWithContentsOfAddress:(NSString*) address           important:(BOOL) important;
+ (NSData*) dataWithContentsOfUrl:(NSURL*) url                      important:(BOOL) important;
+ (NSData*) dataWithContentsOfUrlRequest:(NSURLRequest*) url        important:(BOOL) important;

+ (BOOL) isNetworkAvailable;

@end