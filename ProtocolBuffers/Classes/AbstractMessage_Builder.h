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

}


- (id<Message_Builder>) mergeFrom:(CodedInputStream*) input
                extensionRegistry:(ExtensionRegistry*) extensionRegistry;

- (UnknownFieldSet*) getUnknownFields;

- (id<Message>) buildParsed;

#if 0
- (AbstractMessage_Builder*) clone;
- (AbstractMessage_Builder*) clear;
- (AbstractMessage_Builder*) mergeFrom:(id<Message>) other; 
- (AbstractMessage_Builder*) mergeFromCodedInputStream:(CodedInputStream*) input;
- (AbstractMessage_Builder*) mergeFromCodedInputStream:(CodedInputStream*) input extensionRegistry:(ExtensionRegistry*) extensionRegistry;
- (AbstractMessage_Builder*) mergeUnknownFields:(UnknownFieldSet*) unknownFields;    
- (AbstractMessage_Builder*) mergeFromData:(NSData*) data;    
- (AbstractMessage_Builder*) mergeFromData:(NSData*) data extensionRegistry:(ExtensionRegistry*) extensionRegistry;    
- (AbstractMessage_Builder*) mergeFromInputStream:(NSInputStream*) input;
- (AbstractMessage_Builder*) mergeFromInputStream:(NSInputStream*) input extensionRegistry:(ExtensionRegistry*) extensionRegistry;    
#endif

@end
