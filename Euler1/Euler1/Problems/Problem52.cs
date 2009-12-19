using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem52 : Problem
    {
        public bool run()
        {
            var i = 0;
            for (i = 1; ; i++)
            {
                var x1 = (i * 1).ToString().OrderBy(c => c).ToArray();
                var x2 = (i * 2).ToString().OrderBy(c => c).ToArray();
                var x3 = (i * 3).ToString().OrderBy(c => c).ToArray();
                var x4 = (i * 4).ToString().OrderBy(c => c).ToArray();
                var x5 = (i * 5).ToString().OrderBy(c => c).ToArray();
                var x6 = (i * 6).ToString().OrderBy(c => c).ToArray();

                if (x1.SequenceEqual(x2) &&
                    x2.SequenceEqual(x3) &&
                    x3.SequenceEqual(x4) &&
                    x4.SequenceEqual(x5) &&
                    x5.SequenceEqual(x6))
                {
                    break;
                }
            }

            return i == 142857;
        }
    }
}
