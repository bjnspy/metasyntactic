using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem56 : Problem
    {
        public bool run()
        {
            var q = from a in Enumerable.Range(1, 99)
                    from b in Enumerable.Range(1, 99)
                    let ab = a.nthPower(b)
                    let sum = ab.ToString().Sum(c => c.digitToInt())
                    select sum;

            var max = q.Max();
            return max == 972;
        }
    }
}
