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

@interface NetflixNetworking : AbstractCache {
@private
  BOOL serverAndDeviceMatch;
}

+ (NSString*) netflixTimestamp;

+ (NSURLRequest*) createPostURLRequest:(NSString*) address parameters:(NSArray*) parameters account:(NetflixAccount*) account;
+ (NSURLRequest*) createGetURLRequest:(NSString*) address parameters:(NSArray*) parameters account:(NetflixAccount*) account;
+ (NSURLRequest*) createGetURLRequest:(NSString*) address parameter:(OARequestParameter*) parameter account:(NetflixAccount*) account;
+ (NSURLRequest*) createGetURLRequest:(NSString*) address account:(NetflixAccount*) account;
+ (NSURLRequest*) createDeleteURLRequest:(NSString*) address account:(NetflixAccount*) account;

+ (XmlElement*) downloadXml:(NSURLRequest*) request
                    account:(NetflixAccount*) account
                   response:(NSHTTPURLResponse**) response
                  outOfDate:(BOOL*) outOfDate;

@end
