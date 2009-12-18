using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem6 : Problem
    {
        public bool run()
        {
            long sumOfSquares = 0;
            long sum = 0;
            for (long i = 1; i <= 100; i++)
            {
                sum += i;
                sumOfSquares += i * i;
            } 

            long sumSquared = sum * sum;
            long result = (sumSquared - sumOfSquares);

            return result == 25164150;
        } 
    } 
} 
