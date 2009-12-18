using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Numerics;

namespace Euler
{
    class FibonacciGenerator : IEnumerable<BigInteger>
    {
        public IEnumerator<BigInteger> GetEnumerator()
        {
            BigInteger f1 = 0;
            BigInteger f2 = 1;

            while (true)
            {
                yield return f2;
                BigInteger temp = f2;
                f2 = f1 + f2;
                f1 = temp;
            }
        }

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }
    }
}
