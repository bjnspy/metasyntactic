#import <Foundation/Foundation.h>

#import "UnknownFieldSetTest.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    [UnknownFieldSetTest runAllTests];
    
    [pool drain];
    return 0;
}
