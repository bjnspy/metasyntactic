//
//  Macros.h
//  ProtocolBuffers-Test
//
//  Created by Cyrus Najmabadi on 10/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#define AssertEquals(a1, a2, description, ...) \
do { \
    @try {\
        if (@encode(__typeof__(a1)) != @encode(__typeof__(a2))) { \
            [self failWithException:[NSException failureInFile:[NSString stringWithUTF8String:__FILE__] \
                atLine:__LINE__ \
                withDescription:[@"Type mismatch -- " stringByAppendingString:STComposeString(description, ##__VA_ARGS__)]]]; \
        } else { \
            __typeof__(a1) a1value = (a1); \
            __typeof__(a2) a2value = (a2); \
            NSValue *a1encoded = [NSValue value:&a1value withObjCType: @encode(__typeof__(a1))]; \
            NSValue *a2encoded = [NSValue value:&a2value withObjCType: @encode(__typeof__(a2))]; \
            if (![a1encoded isEqualToValue:a2encoded]) { \
                [self failWithException:[NSException failureInEqualityBetweenValue: a1encoded \
                    andValue: a2encoded \
                    withAccuracy: nil \
                    inFile: [NSString stringWithUTF8String:__FILE__] \
                    atLine: __LINE__ \
                    withDescription: STComposeString(description, ##__VA_ARGS__)]]; \
            } \
        } \
    } \
    @catch (id anException) { \
        [self failWithException:[NSException \
            failureInRaise:[NSString stringWithFormat: @"(%s) == (%s)", #a1, #a2] \
            exception:anException \
            inFile:[NSString stringWithUTF8String:__FILE__] \
            atLine:__LINE__ \
            withDescription:STComposeString(description, ##__VA_ARGS__)]]; \
    } \
} while(0)

