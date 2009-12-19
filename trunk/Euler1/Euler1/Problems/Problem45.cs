using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem45 : Problem
    {
        public bool run()
        {
            var triangleNumbers = new HashSet<long>();
            var pentagonalNumbers = new HashSet<long>();
            var hexagonalNumbers = new HashSet<long>();
            for (var n = 1L; ; n++)
            {
                long v1 = n * (n + 1) / 2;
                long v2 = n * (3 * n - 1) / 2;
                long v3 = n * (2 * n - 1);
                triangleNumbers.Add(v1);
                pentagonalNumbers.Add(v2);
                hexagonalNumbers.Add(v3);

                if ((pentagonalNumbers.Contains(v1) && hexagonalNumbers.Contains(v1)) ||
                    (triangleNumbers.Contains(v2) && hexagonalNumbers.Contains(v2)) ||
                    (triangleNumbers.Contains(v3) && pentagonalNumbers.Contains(v3)))
                {
                    {
                        if (triangleNumbers.Intersect(pentagonalNumbers)
                                .Intersect(hexagonalNumbers).Count() == 3)
                        {
                            break;
                        }
                    }
                }
            }

            var result =
                triangleNumbers.Intersect(pentagonalNumbers)
                    .Intersect(hexagonalNumbers).OrderBy(v => v).Last();

            return result == 1533776805;
        }
    }
}