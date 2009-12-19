using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem53 : Problem
    {
        public bool run()
        {
            var q = from n in Enumerable.Range(1, 100)
                    from r in Enumerable.Range(1, 100)
                    let val = n.choose(r)
                    where val > 1000000
                    select val;

            var result = q.Count();
            return result == 4075;
        }
    }
}
