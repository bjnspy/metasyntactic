//
//  Utilities.m
//  ProtocolBuffers
//
//  Created by Cyrus Najmabadi on 9/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"


int64_t convertFloat64ToInt64(Float64 v) {
    union { Float64 f; int64_t i; } u;
    u.f = v;
    return u.i;
}


int32_t convertFloat32ToInt32(Float32 v) {
    union { Float32 f; int32_t i; } u;
    u.f = v;
    return u.i;
}


uint64_t convertInt64ToUInt64(int64_t v) {
    union { int64_t i; uint64_t u; } u;
    u.i = v;
    return u.u;
}


int64_t convertUInt64ToInt64(uint64_t v) {
    union { int64_t i; uint64_t u; } u;
    u.u = v;
    return u.i;
}

uint32_t convertInt32ToUInt32(int32_t v) {
    union { int32_t i; uint32_t u; } u;
    u.i = v;
    return u.u;
}


int64_t convertUInt32ToInt32(uint32_t v) {
    union { int32_t i; uint32_t u; } u;
    u.u = v;
    return u.i;
}


int32_t logicalRightShift32(int32_t value, int32_t spaces) {
    return convertUInt32ToInt32((convertInt32ToUInt32(value) >> spaces));
}


int64_t logicalRightShift64(int64_t value, int32_t spaces) {
    return convertUInt64ToInt64((convertInt64ToUInt64(value) >> spaces));
}