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

#import "AbstractController.h"

#import "AbstractApplication.h"
#import "AbstractModel.h"
#import "MetasyntacticSharedApplication.h"

@interface AbstractController()
@property (retain) AbstractModel* abstractModel;
@end

@implementation AbstractController

@synthesize abstractModel;

- (void) dealloc {
  self.abstractModel = nil;
  [super dealloc];
}


- (id) initWithModel:(AbstractModel*) abstractModel_ {
  if ((self = [super init])) {
    self.abstractModel = abstractModel_;
  }
  return self;
}


- (id) init {
  @throw [NSException exceptionWithName:@"UnsupportedOperation" reason:@"" userInfo:nil];
}


- (void) startWorker:(BOOL) force AbstractMethod;

- (void) start:(BOOL) force {
  [abstractModel tryShowWriteReviewRequest];

  [self startWorker:force];
}


- (void) start {
  [self start:NO];
}

@end
