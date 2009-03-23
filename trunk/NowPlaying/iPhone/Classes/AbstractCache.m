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

#import "AbstractCache.h"

@interface AbstractCache()
@property (retain) Model* model_;
@property (retain) NSCondition* gate_;
@end


@implementation AbstractCache

@synthesize model_;
@synthesize gate_;

property_wrapper(Model*, model, Model);
property_wrapper(NSCondition*, gate, Gate);

- (void) dealloc {
    self.model = nil;
    self.gate = nil;

    [super dealloc];
}


- (id) initWithModel:(Model*) model__ {
    if (self = [super init]) {
        self.model = model__;
        self.gate = [[[NSCondition alloc] init] autorelease];
    }

    return self;
}


- (void) didReceiveMemoryWarning {

}

@end