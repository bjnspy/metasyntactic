using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem4 : Problem
    {
        public bool run()
        {
            var max = 0;
            for (var i = 100; i <= 999; i++)
            {
                for (var j = i; j <= 999; j++)
                {
                    var v = j * i;
                    if (v <= max)
                    {
                        continue;
                    } 

                    if (isPalindrome(v))
                    {
                        max = v;
                    } 
                } 
            } 
            return max == 906609;
        } 

        private bool isPalindrome(int v)
        {
            return isPalidrome(v.ToString());
        } 

        private bool isPalidrome(string s)
        {
            for (int i = 0; i < s.Length / 2; i++)
            {
                if (s[i] != s[s.Length - 1 - i])
                {
                    return false;
                } 
            } 
            return true;
        } 
    } 
} 
