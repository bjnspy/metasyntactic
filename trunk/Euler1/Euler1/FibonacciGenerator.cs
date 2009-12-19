using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Numerics;

namespace Euler
{
    class Fibonacci
    {
        public static IEnumerable<BigInteger> Generator
        {
            get
            {
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
            }
        }
    }
}