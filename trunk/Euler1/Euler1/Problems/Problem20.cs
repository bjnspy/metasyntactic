using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Numerics;

namespace Euler.Problems
{
    class Problem20 : Problem
    {
        public bool run()
        {
            BigInteger b = 100;
            b = b.factorial();

            var result = b.ToString().Sum(c => c - '0');
            return result == 648;
        } 
    } 
} 
