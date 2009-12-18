using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Numerics;

namespace Euler.Problems
{
    class Problem15 : Problem
    {
        public bool run()
        {
            var result = (20 + 20).factorial() / (20.factorial() * 20.factorial());
            return result == 137846528820;
        }
    }
}