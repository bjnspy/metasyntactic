using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem19 : Problem
    {
        public bool run()
        {
            var start = new DateTime(1901, 1, 1);
            var end = new DateTime(2000, 12, 31);
            var oneDay = new TimeSpan(1, 0, 0 , 0);

            var count = 0;
            for (var current = start; current <= end; current += oneDay)
            {
                if (current.DayOfWeek == DayOfWeek.Sunday &&
                    current.Day == 1)
                {
                    count++;
                } 
            } 

            return count == 171;
        } 
    } 
} 
