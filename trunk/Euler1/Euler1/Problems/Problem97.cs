using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem97 : Problem
    {
        public bool run()
        {
            long current = 1;
            for (int i = 0; i < 7830457; i++)
            {
                current *= 2;
                current = long.Parse(current.ToString().lastNSubstring(10));
            }

            var result = 28433 * current + 1;
            var result1 = result.ToString().lastNSubstring(10);

            return result1 == "8739992577";
        }
    }
}
