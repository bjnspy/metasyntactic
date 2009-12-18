using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    public class Problem1 : Problem
    {
        public bool run()
        {
            int result = (from v in Enumerable.Range(0, 1000)
                          where v % 3 == 0 || v % 5 == 0
                          select v).Sum();

            return result == 233168;
        } 
    } 
} 