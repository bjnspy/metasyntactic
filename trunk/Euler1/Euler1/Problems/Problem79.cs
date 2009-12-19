using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem79 : Problem
    {
        public bool run()
        {
            var tests = data.Split('\n').Select(s => s.Replace("\r", "")).ToArray();
            var uniqueChars = tests.SelectMany(s => s.ToArray()).Distinct().OrderBy(c => c);
            var startString = new String(uniqueChars.ToArray());

            String value = null;
            for (int i = 0; ; i++)
            {
                value = startString.permute(i);
                if (tests.All(t => check(value, t)))
                {
                    break;
                }
            }

            return value == 73162890;
        }

        private bool check(string value, string test)
        {
            var trim = new String(value.Where(c => test.Contains(c)).ToArray());
            return trim.Contains(test);
        }

        string data = @"319
680
180
690
129
620
762
689
762
318
368
710
720
710
629
168
160
689
716
731
736
729
316
729
729
710
769
290
719
680
318
389
162
289
162
718
729
319
790
680
890
362
319
760
316
729
380
319
728
716";
    }
}