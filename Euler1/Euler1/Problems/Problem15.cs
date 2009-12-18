using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Numerics;

namespace Euler.Problems
{
    class Problem15 : Problem
    {
        public void run()
        {
            var result = factorial(20 + 20) / (factorial(20) * factorial(20));
            Console.WriteLine(result);
        }

        private BigInteger factorial(BigInteger v)
        {
            BigInteger result = 1;
            while (v > 1)
            {
                result *= v;
                v--;
            }
            return result;
        }
    }
}
