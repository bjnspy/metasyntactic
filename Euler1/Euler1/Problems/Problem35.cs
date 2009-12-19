using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem35 : Problem
    {
        public bool run()
        {
            var result =
                (from i in Enumerable.Range(1, 1000000)
                 where isCircularPrime(i)
                 select i).Count();

            return result == 55;
        }

        private bool isCircularPrime(int value)
        {
            String str = value.ToString();
            for (int i = 0; i < str.Length; i++)
            {
                String rotated =str.Substring(i) + str.Substring(0, i);
                if (!Prime.isPrime(int.Parse(rotated)))
                {
                    return false;
                }
            }

            return true;
        }
    }
}
