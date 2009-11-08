//
//  Rope.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface Rope : NSObject {

}

+ (Rope*) createRope:(NSString*) value;

- (unichar) characterAt:(NSInteger) index;

- (NSInteger) length;
- (BOOL) isEmpty;
- (NSInteger) indexOf:(unichar) c;

- (Rope*) ropeByReplacingOccurrencesOfChar:(unichar) oldChar withChar:(unichar) newChar;

- (Rope*) subRope:(NSInteger) beginIndex;
- (Rope*) subRope:(NSInteger) beginIndex endIndex:(NSInteger) endIndex;

- (Rope*) appendChar:(unichar) c;
- (Rope*) appendString:(NSString*) string;
- (Rope*) appendRope:(Rope*) rope;

- (Rope*) prependChar:(unichar) c;
- (Rope*) prependString:(NSString*) string;
- (Rope*) prependRope:(Rope*) rope;

- (Rope*) insertChar:(unichar) c index:(NSInteger) index;
- (Rope*) insertString:(NSString*) string index:(NSInteger) index;
- (Rope*) insertRope:(Rope*) rope index:(NSInteger) index;

- (Rope*) replace:(NSInteger) beginIndex endIndex:(NSInteger) endIndex withChar:(unichar) c;
- (Rope*) replace:(NSInteger) beginIndex endIndex:(NSInteger) endIndex withString:(NSString*) string;
- (Rope*) replace:(NSInteger) beginIndex endIndex:(NSInteger) endIndex withRope:(Rope*) rope;

- (BOOL) isEqualToRope:(Rope*) other;

- (NSString*) stringValue;

@end
