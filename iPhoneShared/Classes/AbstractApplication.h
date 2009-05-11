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

@interface AbstractApplication : NSObject {
@protected

}

+ (NSLock*) gate;

+ (NSString*) name;
+ (NSString*) version;
+ (NSString*) nameAndVersion;

+ (NSString*) cacheDirectory;
+ (NSString*) tempDirectory;
+ (NSString*) trashDirectory;

+ (NSString*) uniqueTemporaryDirectory;
+ (NSString*) uniqueTrashDirectory;

+ (void) moveItemToTrash:(NSString*) path;

+ (void) openBrowser:(NSString*) address;
+ (void) openMap:(NSString*) address;
+ (void) makeCall:(NSString*) phoneNumber;

+ (BOOL) isIPhone;
+ (BOOL) useKilometers;
+ (BOOL) canSendMail;

/* @protected */
+ (NSLock*) gate;
+ (void) clearStaleData;

@end