using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem22 : Problem
    {
        public bool run()
        {
            var result =
                Resource.Problem22Data.Split(',')
                   .Select(s => s.Replace("\"", ""))
                   .OrderBy(s => s)
                   .Select((s, i) => s.Sum(c => c - 'A' + 1) * (i + 1)).Sum();

            return result == 871198282;
        }
    }
}
