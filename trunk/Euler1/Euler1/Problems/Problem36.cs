using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem36 : Problem
    {
        public bool run()
        {
            var result =
                (from i in Enumerable.Range(1, 1000000)
                 where i.isPalindrome(10) && i.isPalindrome(2)
                 select i).Sum();

            return 872187;
        }
    }
}
