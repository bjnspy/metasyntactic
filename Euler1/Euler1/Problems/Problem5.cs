using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem5 : Problem
    {
        public void run()
        {
            int result = 20;
            while (true)
            {
                if (matches(result))
                {
                    break;
                }
                result++;
            }
            if (result != 232792560)
            {
                throw new Exception();
            }
        }

        private bool matches(int result)
        {
            for (var i = 1; i <= 20; i++)
            {
                if (result % i != 0)
                {
                    return false;
                }
            }
            return true;
        }
    }
}
