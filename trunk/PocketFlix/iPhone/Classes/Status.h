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

#import <Foundation/Foundation.h>


@interface Status : NSObject {
@private
    Queue* queue;
    Movie* movie;
    NSString* description;
    BOOL saved;
    NSInteger position;
}

@property (readonly, retain) Queue* queue;
@property (readonly, retain) Movie* movie;
@property (readonly, copy) NSString* description;
@property (readonly) BOOL saved;
@property (readonly) NSInteger position;

+ (Status*) statusWithQueue:(Queue*) queue
                      movie:(Movie*) movie
                description:(NSString*) description
                      saved:(BOOL) saved
                   position:(NSInteger) position;

@end