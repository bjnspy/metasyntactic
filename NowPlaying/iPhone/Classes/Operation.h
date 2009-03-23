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

@interface Operation : NSOperation {
@protected
    OperationQueue* operationQueue;
    BOOL isBounded;
    id target;
    SEL selector;
    id<NSLocking> gate;
}

+ (Operation*) operationWithTarget:(id) target selector:(SEL) selector operationQueue:(OperationQueue*) operationQueue isBounded:(BOOL) isBounded gate:(id<NSLocking>) gate;

/* @protected */
- (id) initWithTarget:(id) target selector:(SEL) selector operationQueue:(OperationQueue*) operationQueue isBounded:(BOOL) isBounded gate:(id<NSLocking>) gate;

@end