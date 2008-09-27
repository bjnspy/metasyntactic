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

#import "UnknownFieldSet_Builder.h"


@implementation UnknownFieldSet_Builder

@synthesize fields;
@synthesize lastFieldNumber;
@synthesize lastField;


- (void) dealloc {
    self.fields = nil;
    self.lastFieldNumber = 0;
    self.lastField = nil;

    [super dealloc];
}


+ (UnknownFieldSet_Builder*) newBuilder {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (UnknownFieldSet*) build {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (UnknownFieldSet_Builder*) mergeFrom:(UnknownFieldSet*) other {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (UnknownFieldSet_Builder*) mergeFromCodedInputStream:(CodedInputStream*) input {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (UnknownFieldSet_Builder*) mergeFromData:(NSData*) data {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (UnknownFieldSet_Builder*) mergeFromInputStream:(NSInputStream*) input {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}

#if 0


/**
 * Builder for {@link UnknownFieldSet}s.
 *
 * <p>Note that this class maintains {@link Field.Builder}s for all fields
 * in the set.  Thus, adding one element to an existing {@link Field} does not
 * require making a copy.  This is important for efficient parsing of
 * unknown repeated fields.  However, it implies that {@link Field}s cannot
 * be constructed independently, nor can two {@link UnknownFieldSet}s share
 * the same {@code Field} object.
 *
 * <p>Use {@link UnknownFieldSet#newBuilder()} to construct a {@code Builder}.
 */
public static final class Builder {
    private Builder() {}
    

    
    /**
     * Get a field builder for the given field number which includes any
     * values that already exist.
     */
    private Field.Builder getFieldBuilder(int number) {
        if (lastField != null) {
            if (number == lastFieldNumber) {
                return lastField;
            }
            // Note:  addField() will reset lastField and lastFieldNumber.
            addField(lastFieldNumber, lastField.build());
        }
        if (number == 0) {
            return null;
        } else {
            Field existing = fields.get(number);
            lastFieldNumber = number;
            lastField = Field.newBuilder();
            if (existing != null) {
                lastField.mergeFrom(existing);
            }
            return lastField;
        }
    }
    
    /**
     * Build the {@link UnknownFieldSet} and return it.
     *
     * <p>Once {@code build()} has been called, the {@code Builder} will no
     * longer be usable.  Calling any method after {@code build()} will throw
     * {@code NullPointerException}.
     */
    public UnknownFieldSet build() {
        getFieldBuilder(0);  // Force lastField to be built.
        UnknownFieldSet result;
        if (fields.isEmpty()) {
            result = getDefaultInstance();
        } else {
            result = new UnknownFieldSet(Collections.unmodifiableMap(fields));
        }
        fields = null;
        return result;
    }
    
    /** Reset the builder to an empty set. */
    public Builder clear() {
        fields = new TreeMap<Integer, Field>();
        lastFieldNumber = 0;
        lastField = null;
        return this;
    }
    
    /**
     * Merge the fields from {@code other} into this set.  If a field number
     * exists in both sets, {@code other}'s values for that field will be
     * appended to the values in this set.
     */
    public Builder mergeFrom(UnknownFieldSet other) {
        if (other != getDefaultInstance()) {
            for (Map.Entry<Integer, Field> entry : other.fields.entrySet()) {
                mergeField(entry.getKey(), entry.getValue());
            }
        }
        return this;
    }
    
    /**
     * Add a field to the {@code UnknownFieldSet}.  If a field with the same
     * number already exists, the two are merged.
     */
    public Builder mergeField(int number, Field field) {
        if (number == 0) {
            throw new IllegalArgumentException("Zero is not a valid field number.");
        }
        if (hasField(number)) {
            getFieldBuilder(number).mergeFrom(field);
        } else {
            // Optimization:  We could call getFieldBuilder(number).mergeFrom(field)
            // in this case, but that would create a copy of the Field object.
            // We'd rather reuse the one passed to us, so call addField() instead.
            addField(number, field);
        }
        return this;
    }
    
    /**
     * Convenience method for merging a new field containing a single varint
     * value.  This is used in particular when an unknown enum value is
     * encountered.
     */
    public Builder mergeVarintField(int number, int value) {
        if (number == 0) {
            throw new IllegalArgumentException("Zero is not a valid field number.");
        }
        getFieldBuilder(number).addVarint(value);
        return this;
    }
    
    /** Check if the given field number is present in the set. */
    public boolean hasField(int number) {
        if (number == 0) {
            throw new IllegalArgumentException("Zero is not a valid field number.");
        }
        return number == lastFieldNumber || fields.containsKey(number);
    }
    
    /**
     * Add a field to the {@code UnknownFieldSet}.  If a field with the same
     * number already exists, it is removed.
     */
    public Builder addField(int number, Field field) {
        if (number == 0) {
            throw new IllegalArgumentException("Zero is not a valid field number.");
        }
        if (lastField != null && lastFieldNumber == number) {
            // Discard this.
            lastField = null;
            lastFieldNumber = 0;
        }
        fields.put(number, field);
        return this;
    }
    
    /**
     * Get all present {@code Field}s as an immutable {@code Map}.  If more
     * fields are added, the changes may or may not be reflected in this map.
     */
    public Map<Integer, Field> asMap() {
        getFieldBuilder(0);  // Force lastField to be built.
        return Collections.unmodifiableMap(fields);
    }
    
    /**
     * Parse an entire message from {@code input} and merge its fields into
     * this set.
     */
    public Builder mergeFrom(CodedInputStream input) throws IOException {
        while (true) {
            int tag = input.readTag();
            if (tag == 0 || !mergeFieldFrom(tag, input)) {
                break;
            }
        }
        return this;
    }
    
    /**
     * Parse a single field from {@code input} and merge it into this set.
     * @param tag The field's tag number, which was already parsed.
     * @return {@code false} if the tag is an engroup tag.
     */
    public boolean mergeFieldFrom(int tag, CodedInputStream input)
    throws IOException {
        int number = WireFormat.getTagFieldNumber(tag);
        switch (WireFormat.getTagWireType(tag)) {
            case WireFormat.WIRETYPE_VARINT:
                getFieldBuilder(number).addVarint(input.readInt64());
                return true;
            case WireFormat.WIRETYPE_FIXED64:
                getFieldBuilder(number).addFixed64(input.readFixed64());
                return true;
            case WireFormat.WIRETYPE_LENGTH_DELIMITED:
                getFieldBuilder(number).addLengthDelimited(input.readBytes());
                return true;
            case WireFormat.WIRETYPE_START_GROUP: {
                UnknownFieldSet.Builder subBuilder = UnknownFieldSet.newBuilder();
                input.readUnknownGroup(number, subBuilder);
                getFieldBuilder(number).addGroup(subBuilder.build());
                return true;
            }
            case WireFormat.WIRETYPE_END_GROUP:
                return false;
            case WireFormat.WIRETYPE_FIXED32:
                getFieldBuilder(number).addFixed32(input.readFixed32());
                return true;
            default:
                throw InvalidProtocolBufferException.invalidWireType();
        }
    }
    
    /**
     * Parse {@code data} as an {@code UnknownFieldSet} and merge it with the
     * set being built.  This is just a small wrapper around
     * {@link #mergeFrom(CodedInputStream)}.
     */
    public Builder mergeFrom(ByteString data)
    throws InvalidProtocolBufferException {
        try {
            CodedInputStream input = data.newCodedInput();
            mergeFrom(input);
            input.checkLastTagWas(0);
            return this;
        } catch (InvalidProtocolBufferException e) {
            throw e;
        } catch (IOException e) {
            throw new RuntimeException(
                                       "Reading from a ByteString threw an IOException (should " +
                                       "never happen).", e);
        }
    }
    
    /**
     * Parse {@code data} as an {@code UnknownFieldSet} and merge it with the
     * set being built.  This is just a small wrapper around
     * {@link #mergeFrom(CodedInputStream)}.
     */
    public Builder mergeFrom(byte[] data)
    throws InvalidProtocolBufferException {
        try {
            CodedInputStream input = CodedInputStream.newInstance(data);
            mergeFrom(input);
            input.checkLastTagWas(0);
            return this;
        } catch (InvalidProtocolBufferException e) {
            throw e;
        } catch (IOException e) {
            throw new RuntimeException(
                                       "Reading from a byte array threw an IOException (should " +
                                       "never happen).", e);
        }
    }
    
    /**
     * Parse an {@code UnknownFieldSet} from {@code input} and merge it with the
     * set being built.  This is just a small wrapper around
     * {@link #mergeFrom(CodedInputStream)}.
     */
    public Builder mergeFrom(InputStream input) throws IOException {
        CodedInputStream codedInput = CodedInputStream.newInstance(input);
        mergeFrom(codedInput);
        codedInput.checkLastTagWas(0);
        return this;
    }
}
#endif

@end
