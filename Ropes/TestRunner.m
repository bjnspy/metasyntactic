#import <Foundation/Foundation.h>
#import "Rope.h"

@interface RopeTests : NSObject {
}

@end

@implementation RopeTests

static NSString* largeString;
static Rope* largeRope;
static NSString* mediumString;
static Rope* mediumRope;

+ (NSString*) createTestString:(NSInteger) size {
  NSMutableString* result = [NSMutableString string];
  for (NSInteger i = 0; i < size; i++) {
    unichar c = (unichar)('a' + (i % 26));
    [result appendString:[NSString stringWithCharacters:&c length:1]];
  }
  
  return result;
}


+ (Rope*) createChunkedRope:(NSString*) string {
  Rope* result = [Rope emptyRope];
  
  for (NSInteger i = 0; i < string.length; i += [Rope coalesceLeafLength]) {
    NSInteger endIndex = MIN(string.length, i + [Rope coalesceLeafLength]);
    result = [result appendString:[string substringWithRange:NSMakeRange(i, endIndex - i)]];
  }
  
  return result;
}


+ (void) initialize {
  if (self == [RopeTests class]) {
    mediumString = [[self createTestString:(1 << 16)] retain];
    mediumRope = [[self createChunkedRope:mediumString] retain];
    
    largeString = [[self createTestString:(1 << 20)] retain];
    largeRope = [[self createChunkedRope:largeString] retain];
  }
}


- (void) testStringValue {
  [largeString isEqual:@"A"];
  //STAssertEqualObjects(largeString, @"a", @"");
}

@end


int main (int argc, const char * argv[]) {
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  
  [[[[RopeTests alloc] init] autorelease] testStringValue];
  
  // insert code here...
  NSLog(@"Hello, World!");
  [pool drain];
  return 0;
}