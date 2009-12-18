using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Numerics;

namespace Euler.Problems
{
    class Problem16 : Problem
    {
        public void run()
        {
            BigInteger value = 1;
            for (int i = 0; i < 1000; i++)
            {
                value *= 2;
            }
            int sum = value.ToString().Sum(c => c - '0');
            if (sum != 1366)
            {
                throw new Exception();
            }
        }
    }
}
