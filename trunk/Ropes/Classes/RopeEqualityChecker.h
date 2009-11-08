//
//  RopeEqualityChecker.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * To check if two ropes are equal, we need to process their leaves
 * simultaneously.
 *
 * <p>We are going to go through both ropes at the same time in 'chunks'.
 * Chunks will be the longest section of rope we can find that does *not*
 * cross a leaf barrier in either rope.  Note that after ever chunk test, we
 * will have consumed at least one leaf entirely (or both if they both end at
 * the same position).  After consuming a leaf, we then move to that rope's
 * next leaf and determine the next chunk to compare.
 *
 * <p>As an example,  Consider the case of the following streams shown below:
 * <pre class="code">
 *                 La               Lb      Lc                 Ld
 * s1 = ---------------------------------------------------------------------
 *      |                        |      |       |                           |
 *      ---------------------------------------------------------------------
 *      s1a                    s1b     s1c      s1d                       s1e
 *      s1i
 *
 *             Lw                       Lx                           Lz
 * s2 = ---------------------------------------------------------------------
 *      |                |                              |                   |
 *      ---------------------------------------------------------------------
 *      s2w             s2x                            s2y                s2z
 *      s2i
 * </pre>
 *
 * <p>We will need to chunk up both ropes and compare them.  The gory details
 * are listed below.   Note: in the explanation |a - b| means the length
 * between points 'a' and 'b'
 *
 * We'll perform the following steps in order:
 * <ol>
 *  <li>Set the indices (s1i and s2i) to 0.</li>
 *  <li>get the first leaf from s1 and s2, (i.e. La and Lw).</li>
 *  <li>Lw's remainder is smaller than La's, so we'll compare the chunks
 *      La[s1i, lw.length) to Lx[s2i, lw.length).</li>
 *  <li>move to s2's next leaf 'Lx'.  Set s1i to s1i + Lw.length.  Set s2i to
 *      0.</li>
 *  <li>Lx's remainder is larger than the remainder of La. so compare chunks
 *      La[s1i, La.length) to Lx[s2i, s2i + |La.length - s1i|).</li>
 *  <li>Move to s1's next leaf 'Lb'.  Set s2i to 's2i + La.length. Set s1i to
 *      0.</li>
 *  <li>Lx's remainder is larger than the remainder of 'Lb' so compare chunks
 *      Lb[s1i, Lb.length) to Lx[s2i, s2i + Lb.length).</li>
 *  <li>Move to s1's next leaf 'Lc'. Set s2i to 's2i + Lb.length'. Set s1i to
 *      0.</li>
 *  <li>Lx's remainder is larger than the remainder of 'Lc' so compare chunks
 *      Lc[s1i, Lc.length) to Lx[s2i, s2i + Lc.length).</li>
 *  <li>Move to s1's next leaf 'Ld'. Set s2i to 's2i + Lc.length'. Set s1i to
 *      0.</li>
 *  <li>Lx's remainder is smaller than Ld's.  So compare chunks
 *      Ld[s1i, s1i + |Lx.length - s2i|) to Lx[s2i, Lx.length).</li>
 *  <li>Move to s2's next leaf Lz. Set s1i to 'Lx.length - s2i'. Set s2i to
 *      0.</li>
 *  <li>The remainders are the same length.  So compare chunks
 *      Ld[s1i, Ld.length) to Lz(s2i, Lz.length).</li>
 *  <li>Both ropes have run out of leaves at this point.  If all the
 *      comparisons up to this point succeeded, then the ropes are the
 *      same.</li>
 * </ol>
 * <p>Note: You should not access instances of this class from multiple threads.
 * It should only be created on the stack, used by one thread, and then
 * discarded.  See {@link Rope#equals} to see the proper usage.
 */
@interface RopeEqualityChecker : NSObject {
@private
  Rope* rope1;
  Rope* rope2;
  
  Iterator* i1;
  Iterator* i2;
  
  Leaf* leaf1;
  Leaf* leaf2;
  
  NSInteger leaf1Start;
  NSInteger leaf1End;
  NSInteger leaf2Start;
  NSInteger leaf2End;
}

+ (RopeEqualityChecker*) createWithRope1:(Rope*) rope1 rope2:(Rope*) rope2;

- (BOOL) check;

@end
