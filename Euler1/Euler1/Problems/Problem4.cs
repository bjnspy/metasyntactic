using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem4 : Problem
    {
        public bool run()
        {
            var max = 0;
            for (var i = 100; i <= 999; i++)
            {
                for (var j = i; j <= 999; j++)
                {
                    var v = j * i;
                    if (v <= max)
                    {
                        continue;
                    }

                    if (v.isPalindrome()) {
                        max = v;
                    }
                }
            }
            return max == 906609;
        }
    }
}