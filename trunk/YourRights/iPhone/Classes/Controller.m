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

#import "Controller.h"

#import "Model.h"
#import "RSSCache.h"

@implementation Controller

static Controller* controller = nil;

+ (void) initialize {
  if (self == [Controller class]) {
    controller = [[Controller alloc] init];
  }
}

+ (Controller*) controller {
  return controller;
}


- (Model*) model {
  return [Model model];
}


- (void) start {
  [super start:self.model];
  [self.model.rssCache update];
}

@end
