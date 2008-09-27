// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "UnknownFieldSet.h"

#import "CodedInputStream.h"
#import "CodedOutputStream.h"
#import "Field.h"
#import "UnknownFieldSet_Builder.h"

@implementation UnknownFieldSet

static UnknownFieldSet* defaultInstance = nil;

+ (void) initialize {
    if (self == [UnknownFieldSet class]) {
        defaultInstance = [[UnknownFieldSet setWithFields:[NSMutableDictionary dictionary]] retain];
    }
}


@synthesize fields;

- (void) dealloc {
    self.fields = nil;

    [super dealloc];
}


+ (UnknownFieldSet_Builder*) newBuilder {
    return [[[UnknownFieldSet_Builder alloc] init] autorelease];
}


+ (UnknownFieldSet_Builder*) newBuilder:(UnknownFieldSet*) copyFrom {
    return [[UnknownFieldSet_Builder newBuilder] mergeFrom:copyFrom];
}


+ (UnknownFieldSet*) getDefaultInstance {
    return defaultInstance;
}


- (id) initWithFields:(NSMutableDictionary*) fields_ {
    if (self = [super init]) {
        self.fields = fields_;
    }
    
    return self;
}


+ (UnknownFieldSet*) setWithFields:(NSMutableDictionary*) fields {
    return [[[UnknownFieldSet alloc] initWithFields:fields] autorelease];
}


- (NSMutableDictionary*) asMap {
    return fields;
}


- (BOOL) hasField:(int32_t) number {
    return [fields objectForKey:[NSNumber numberWithInt:number]] != nil;
}


- (Field*) getField:(int32_t) number {
    Field* result = [fields objectForKey:[NSNumber numberWithInt:number]];
    return (result == nil) ? [Field getDefaultInstance] : result;
}


- (void) writeToCodedOutputStream:(CodedOutputStream*) output {
    NSArray* sortedKeys = [fields.allKeys sortedArrayUsingSelector:@selector(compare:)];
    for (NSNumber* number in sortedKeys) {
        Field* value = [fields objectForKey:number];
        [value writeTo:number.intValue output:output];
    }
}


- (void) writeToOutputStream:(NSOutputStream*) output {
    CodedOutputStream* codedOutput = [CodedOutputStream newInstance:output];
    [self writeToCodedOutputStream:codedOutput];
    [codedOutput flush];
}


+ (UnknownFieldSet*) parseFromCodedInputStream:(CodedInputStream*) input {
    return [[[UnknownFieldSet newBuilder] mergeFromCodedInputStream:input] build];
}


+ (UnknownFieldSet*) parseFromData:(NSData*) data {
    return [[[UnknownFieldSet newBuilder] mergeFromData:data] build];
}


+ (UnknownFieldSet*) parseFromInputStream:(NSInputStream*) input {
    return [[[UnknownFieldSet newBuilder] mergeFromInputStream:input] build];
}


#if 0


/**
 * Converts the set to a string in protocol buffer text format. This is
 * just a trivial wrapper around
 * {@link TextFormat#printToString(UnknownFieldSet)}.
 */
public final String toString() {
    return TextFormat.printToString(this);
}

/**
 * Serializes the message to a {@code ByteString} and returns it. This is
 * just a trivial wrapper around {@link #writeTo(CodedOutputStream)}.
 */
public final ByteString toByteString() {
    try {
        ByteString.CodedBuilder out =
        ByteString.newCodedBuilder(getSerializedSize());
        writeTo(out.getCodedOutput());
        return out.build();
    } catch (IOException e) {
        throw new RuntimeException(
                                   "Serializing to a ByteString threw an IOException (should " +
                                   "never happen).", e);
    }
}


/**
 * Serializes the message and writes it to {@code output}.  This is just a
 * trivial wrapper around {@link #writeTo(CodedOutputStream)}.
 */


/** Get the number of bytes required to encode this set. */
public int getSerializedSize() {
    int result = 0;
    for (Map.Entry<Integer, Field> entry : fields.entrySet()) {
        result += entry.getValue().getSerializedSize(entry.getKey());
    }
    return result;
}

/**
 * Serializes the set and writes it to {@code output} using
 * {@code MessageSet} wire format.
 */
public void writeAsMessageSetTo(CodedOutputStream output)
throws IOException {
    for (Map.Entry<Integer, Field> entry : fields.entrySet()) {
        entry.getValue().writeAsMessageSetExtensionTo(
                                                      entry.getKey(), output);
    }
}

/**
 * Get the number of bytes required to encode this set using
 * {@code MessageSet} wire format.
 */
public int getSerializedSizeAsMessageSet() {
    int result = 0;
    for (Map.Entry<Integer, Field> entry : fields.entrySet()) {
        result += entry.getValue().getSerializedSizeAsMessageSetExtension(
                                                                          entry.getKey());
    }
    return result;
}
}
#endif
@end
