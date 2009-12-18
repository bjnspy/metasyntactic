using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem3 : Problem
    {
        public bool run()
        {
            long value = 600851475143;
            foreach (var p in Prime.Generator) {
                while (p < value && value % p == 0)
                {
                    value /= p;
                } 
                if (p >= value)
                {
                    break;
                } 
            } 

            return value == 6857;
        } 
    } 
} 
