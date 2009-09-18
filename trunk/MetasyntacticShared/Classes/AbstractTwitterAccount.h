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

@interface AbstractTwitterAccount : NSObject<MGTwitterEngineDelegate> {
@private
  MGTwitterEngine* engine;
  NSString* lastCheckCredentialsIdentifier;

  NSMutableDictionary* requestsInProgress;
}

- (void) login;

- (BOOL) enabled;
- (void) setEnabled:(BOOL) enabled;

- (NSString*) username;
- (NSString*) password;

- (void) setUserName:(NSString*) username password:(NSString*) password;

- (void) sendUpdate:(NSString*) message;

@end
