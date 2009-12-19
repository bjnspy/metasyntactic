using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem25 : Problem
    {
        public bool run()
        {
            int i = 1;
            foreach (var f in Fibonacci.Generator)
            {
                if (f.ToString().Length >= 1000)
                {
                    break;
                }
                i++;
            }

            return i == 4782;
        }
    }
}
