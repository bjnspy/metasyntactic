using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Numerics;

namespace Euler.Problems
{
    class Problem48 : Problem
    {
        public bool run()
        {
            BigInteger value =
                Enumerable.Range(1, 1000).Select(i => i.nthPower(i)).Sum();

            String result = value.ToString();
            result = result.Substring(result.Length - 10);

            return result == "9110846700";
        }
    }
}
