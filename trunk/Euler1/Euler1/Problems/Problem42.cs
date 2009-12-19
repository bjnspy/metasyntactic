using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem42 : Problem
    {
        public bool run()
        {
            var triangleNumbers = new HashSet<int>();
            int value = 0;
            for (int i = 1; i < 1000; i++)
            {
                value += i;
                triangleNumbers.Add(value);
            }

            var words =
                Resource.Problem42Data.Split(',')
                   .Select(s => s.Replace("\"", ""));

            var triangleWords =
                from w in words
                let v = w.Select(c => c - 'A' + 1).Sum()
                where triangleNumbers.Contains(v)
                select w;

            var result = triangleWords.Count();

            return result == 162;
        }
    }
}
