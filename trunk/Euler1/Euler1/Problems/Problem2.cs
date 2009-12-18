using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem2 : Problem
    {
        public bool run()
        {
            var result =
                new FibonacciGenerator()
                    .TakeWhile(v => v < 4000000)
                    .Where(v => v % 2 == 0).Sum();

            return result == 4613732;
        } 
    } 
} 
