using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem29 : Problem
    {
        public bool run()
        {
            var v = (from a in Enumerable.Range(2, 99)
                    from b in Enumerable.Range(2, 99)
                    select a.nthPower(b)).Distinct().Count();

            return v == 9183;
        }
    }
}
