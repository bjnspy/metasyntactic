using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem5 : Problem
    {
        public bool run()
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
            return result == 232792560;
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
