﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Numerics;

namespace Euler.Problems
{
    class Problem12 : Problem
    {
        public bool run()
        {
            long triangle = 0;
            long addValue = 1;

            while (true)
            {
                triangle += addValue;
                addValue++;

                var count = divisorCount(triangle);
                if (count > 500)
                {
                    break;
                } 
            } 

            return triangle == 76576500;
        } 

        private long divisorCount(long triangle)
        {
            PrimeFactorization p = Prime.factorize(triangle);
            long count = 1;

            foreach (var e in p.Exponents)
            {
                count *= (e + 1);
            } 
            return count;
        } 
    } 
} 
