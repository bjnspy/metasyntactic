//
//  GeneratedMessage_RepeatedFieldAccessor.h
//  ProtocolBuffers
//
//  Created by Cyrus Najmabadi on 9/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GeneratedMessage_FieldAccessor.h"

@interface GeneratedMessage_RepeatedFieldAccessor : NSObject<GeneratedMessage_FieldAccessor> {
    
}

+ (GeneratedMessage_RepeatedFieldAccessor*) accessorWithField:(FieldDescriptor*) field
                                                             name:(NSString*) name
                                                     messageClass:(Class) messageClass
                                                     builderClass:(Class) builderClass;

- (id) get:(GeneratedMessage*) message;
- (void) set:(GeneratedMessage_Builder*) builder value:(id) value;
- (id) getRepeated:(GeneratedMessage*) message index:(int32_t) index;
- (void) setRepeated:(GeneratedMessage_Builder*) builder index:(int32_t) index value:(id) value;
- (void) addRepeated:(GeneratedMessage_Builder*) builder value:(id) value;
- (BOOL) has:(GeneratedMessage*) message;
- (int32_t) getRepeatedCount:(GeneratedMessage*) message;
- (void) clear:(GeneratedMessage_Builder*) builder;
- (id<Message_Builder>) newBuilder;

@end
