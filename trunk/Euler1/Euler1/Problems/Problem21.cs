using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem21 : Problem
    {
        public bool run()
        {
            int sum = 0;
            for (int i = 1; i < 10000; i++)
            {
                if (isAmicable(i))
                {
                    sum += i;
                }
            }

            Console.WriteLine(sum);
            return false;
        }

        private bool isAmicable(int value)
        {
            int divisorSum = computeDivisorSum(value);
            if (divisorSum == value)
            {
                return false;
            }
            if (divisorSum >= 10000)
            {
                return false;
            }

            int otherDivisorSum = computeDivisorSum(divisorSum);
            return otherDivisorSum == value;
        }

        private int computeDivisorSum(int value)
        {
            int sum = 0;
            for (int i = 1; i <= value / 2; i++)
            {
                if (value % i == 0)
                {
                    sum += i;
                }
            }
            return sum;
        }
    }
}
