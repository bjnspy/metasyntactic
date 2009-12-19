using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem27 : Problem
    {
        public bool run()
        {
            var result =
                from a in Enumerable.Range(0, 999).SelectMany(i => new[] { -i, i })
                from b in Enumerable.Range(0, 999).SelectMany(i => new[] { -i, i })
                let primeCount = computePrimes(a, b).Count()
                orderby primeCount descending
                select a * b;

            var total = result.First();
            return total == -59231;
        }

        private IEnumerable<long> computePrimes(long a, long b)
        {
            for (long n = 0; ; n++) {
                long value = n * n + a * n + b;
                if (Prime.isPrime(value))
                {
                    yield return value;
                }
                else
                {
                    yield break;
                }
            }
        }
    }
}
