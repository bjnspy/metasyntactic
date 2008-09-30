// Protocol Buffers - Google's data interchange format
// Copyright 2008 Google Inc.
// http://code.google.com/p/protobuf/
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "Message_Builder.h"

@interface AbstractMessage_Builder : NSObject<Message_Builder> {
@private
}

- (UnknownFieldSet*) getUnknownFields;

- (id<Message>) buildParsed;

- (id<Message_Builder>) mergeFromCodedInputStream:(CodedInputStream*) input;
- (id<Message_Builder>) mergeFromCodedInputStream:(CodedInputStream*) input extensionRegistry:(ExtensionRegistry*) extensionRegistry;
- (id<Message_Builder>) mergeUnknownFields:(UnknownFieldSet*) unknownFields;    
- (id<Message_Builder>) mergeFromData:(NSData*) data;    
- (id<Message_Builder>) mergeFromData:(NSData*) data extensionRegistry:(ExtensionRegistry*) extensionRegistry;    
- (id<Message_Builder>) mergeFromInputStream:(NSInputStream*) input;
- (id<Message_Builder>) mergeFromInputStream:(NSInputStream*) input extensionRegistry:(ExtensionRegistry*) extensionRegistry;

- (id<Message_Builder>) mergeFromMessage:(id<Message>) other; 

@end
