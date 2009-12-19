using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Numerics;

namespace Euler.Problems
{
    class Problem28 : Problem
    {
        public bool run()
        {
            BigInteger sum = 1;
            BigInteger current = 1;
            for (int i = 2; i <= 1000; i += 2)
            {
                for (int j = 0; j < 4; j++)
                {
                    current += i;
                    sum += current;
                }
            }

            return sum == 669171001;
        }
    }
}
