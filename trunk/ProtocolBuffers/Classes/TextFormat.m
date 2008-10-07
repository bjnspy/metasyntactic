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

#import "TextFormat.h"


@implementation PBTextFormat


+ (int64_t) parseInteger:(NSString*) text
                isSigned:(BOOL) isSigned
                  isLong:(BOOL) isLong {
    int32_t pos = 0;
    
    BOOL negative = false;
    if ([text hasPrefix:@"-"]) {
        if (!isSigned) {
            @throw [NSException exceptionWithName:@"NumberFormat" reason:@"Number must be positive" userInfo:nil];
        }
        ++pos;
        negative = true;
    }
    
    int32_t radix = 10;
    if ([[text substringFromIndex:pos] hasPrefix:@"0x"]) {
        pos += 2;
        radix = 16;
    } else if ([[text substringFromIndex:pos] hasPrefix:@"0"]) {
        radix = 8;
    }
    
    if (radix != 10) {
        @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
    }
    
    NSString* numberText = [text substringFromIndex:pos];
    
    int64_t result = 0;
    if (numberText.length < 16) {
        // Can safely assume no overflow.
        //result = Long.parseLong(numberText, radix);
        result = [numberText longLongValue];
        if (negative) {
            result = -result;
        }
        
        // Check bounds.
        // No need to check for 64-bit numbers since they'd have to be 16 chars
        // or longer to overflow.
        if (!isLong) {
            if (isSigned) {
                if (result > INT_MAX || result < INT_MIN) {
                    @throw [NSException exceptionWithName:@"NumberFormat" reason:@"Number out of range for 32-bit signed integer: " userInfo:nil];
                }
            } else {
                if (result >= (1LL << 32) || result < 0) {
                    @throw [NSException exceptionWithName:@"NumberFormat" reason:@"Number out of range for 32-bit unsigned integer: " userInfo:nil];
                }
            }
        }
    } else {
        @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
#if 0
        BigInteger bigValue = new BigInteger(numberText, radix);
        if (negative) {
            bigValue = bigValue.negate();
        }
        
        // Check bounds.
        if (!isLong) {
            if (isSigned) {
                if (bigValue.bitLength() > 31) {
                    throw new NumberFormatException(
                                                    "Number out of range for 32-bit signed integer: " + text);
                }
            } else {
                if (bigValue.bitLength() > 32) {
                    throw new NumberFormatException(
                                                    "Number out of range for 32-bit unsigned integer: " + text);
                }
            }
        } else {
            if (isSigned) {
                if (bigValue.bitLength() > 63) {
                    throw new NumberFormatException(
                                                    "Number out of range for 64-bit signed integer: " + text);
                }
            } else {
                if (bigValue.bitLength() > 64) {
                    throw new NumberFormatException(
                                                    "Number out of range for 64-bit unsigned integer: " + text);
                }
            }
        }
        
        result = bigValue.longValue();
#endif
    }
    
    return result;
}


/**
 * Parse a 32-bit signed integer from the text.  Unlike the Java standard
 * {@code Integer.parseInt()}, this function recognizes the prefixes "0x"
 * and "0" to signify hexidecimal and octal numbers, respectively.
 */
+ (int32_t) parseInt32:(NSString*) text {
    return (int32_t)[self parseInteger:text isSigned:true isLong:false];
}


/**
 * Parse a 32-bit unsigned integer from the text.  Unlike the Java standard
 * {@code Integer.parseInt()}, this function recognizes the prefixes "0x"
 * and "0" to signify hexidecimal and octal numbers, respectively.  The
 * result is coerced to a (signed) {@code int} when returned since Java has
 * no unsigned integer type.
 */
+ (int32_t) parseUInt32:(NSString*) text {
    return (int32_t)[self parseInteger:text isSigned:false isLong:false];
}


/**
 * Parse a 64-bit signed integer from the text.  Unlike the Java standard
 * {@code Integer.parseInt()}, this function recognizes the prefixes "0x"
 * and "0" to signify hexidecimal and octal numbers, respectively.
 */
+ (int64_t) parseInt64:(NSString*) text {
    return [self parseInteger:text isSigned:true isLong:true];
}


/**
 * Parse a 64-bit unsigned integer from the text.  Unlike the Java standard
 * {@code Integer.parseInt()}, this function recognizes the prefixes "0x"
 * and "0" to signify hexidecimal and octal numbers, respectively.  The
 * result is coerced to a (signed) {@code long} when returned since Java has
 * no unsigned long type.
 */
+ (int64_t) parseUInt64:(NSString*) text {
    return [self parseInteger:text isSigned:false isLong:true];
}


/** Is this an octal digit? */
BOOL isOctal(unichar c) {
    return '0' <= c && c <= '7';
}

/** Is this a hex digit? */
BOOL isHex(unichar c) {
    return
    ('0' <= c && c <= '9') ||
    ('a' <= c && c <= 'f') ||
    ('A' <= c && c <= 'F');
}

/**
 * Interpret a character as a digit (in any base up to 36) and return the
 * numeric value.  This is like {@code Character.digit()} but we don't accept
 * non-ASCII digits.
 */
int32_t digitValue(unichar c) {
    if ('0' <= c && c <= '9') {
        return c - '0';
    } else if ('a' <= c && c <= 'z') {
        return c - 'a' + 10;
    } else {
        return c - 'A' + 10;
    }
}


/**
 * Un-escape a byte sequence as escaped using
 * {@link #escapeBytes(ByteString)}.  Two-digit hex escapes (starting with
 * "\x") are also recognized.
 */
+ (NSData*) unescapeBytes:(NSString*) input {
    NSMutableData* result = [NSMutableData dataWithLength:input.length];
    
    int32_t pos = 0;
    for (int32_t i = 0; i < input.length; i++) {
        unichar c = [input characterAtIndex:i];
        if (c == '\\') {
            if (i + 1 < input.length) {
                ++i;
                c = [input characterAtIndex:i];
                if (isOctal(c)) {
                    // Octal escape.
                    int32_t code = digitValue(c);
                    if (i + 1 < input.length && isOctal([input characterAtIndex:(i + 1)])) {
                        ++i;
                        code = code * 8 + digitValue([input characterAtIndex:i]);
                    }
                    if (i + 1 < input.length && isOctal([input characterAtIndex:(i + 1)])) {
                        ++i;
                        code = code * 8 + digitValue([input characterAtIndex:i]);
                    }
                    ((int8_t*)result.mutableBytes)[pos++] = (int8_t)code;
                } else {
                    switch (c) {
                        case 'a' : ((int8_t*)result.mutableBytes)[pos++] = 0x07; break;
                        case 'b' : ((int8_t*)result.mutableBytes)[pos++] = '\b'; break;
                        case 'f' : ((int8_t*)result.mutableBytes)[pos++] = '\f'; break;
                        case 'n' : ((int8_t*)result.mutableBytes)[pos++] = '\n'; break;
                        case 'r' : ((int8_t*)result.mutableBytes)[pos++] = '\r'; break;
                        case 't' : ((int8_t*)result.mutableBytes)[pos++] = '\t'; break;
                        case 'v' : ((int8_t*)result.mutableBytes)[pos++] = 0x0b; break;
                        case '\\': ((int8_t*)result.mutableBytes)[pos++] = '\\'; break;
                        case '\'': ((int8_t*)result.mutableBytes)[pos++] = '\''; break;
                        case '"' : ((int8_t*)result.mutableBytes)[pos++] = '\"'; break;
                            
                        case 'x': // hex escape 
                        {
                            int32_t code = 0;
                            if (i + 1 < input.length && isHex([input characterAtIndex:(i + 1)])) {
                                ++i;
                                code = digitValue([input characterAtIndex:i]);
                            } else {
                                @throw [NSException exceptionWithName:@"InvalidEscape" reason:@"Invalid escape sequence: '\\x' with no digits" userInfo:nil];
                            }
                            if (i + 1 < input.length && isHex([input characterAtIndex:(i + 1)])) {
                                ++i;
                                code = code * 16 + digitValue([input characterAtIndex:i]);
                            }
                            ((int8_t*)result.mutableBytes)[pos++] = (int8_t)code;
                            break;
                        }
                            
                        default:
                            @throw [NSException exceptionWithName:@"InvalidEscape" reason:@"Invalid escape sequence" userInfo:nil];
                    }
                }
            } else {
                @throw [NSException exceptionWithName:@"InvalidEscape" reason:@"Invalid escape sequence: '\\' at end of string" userInfo:nil];
            }
        } else {
            ((int8_t*)result.mutableBytes)[pos++] = (int8_t)c;
        }
    }
    
    [result setLength:pos];
    return result;
}

@end
