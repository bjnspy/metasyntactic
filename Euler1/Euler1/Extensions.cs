using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Numerics;

namespace Euler
{
    public static class Extensions
    {
        public static BigInteger Sum(this IEnumerable<BigInteger> e)
        {
            BigInteger result = 0;
            foreach (var v in e)
            {
                result += v;
            }
            return result;
        }

        public static BigInteger sqrt(this BigInteger N)
        {
            BigInteger rootN = N;
            int count = 0;
            int bitLength = 1;
            while (rootN / 2 != 0)
            {
                rootN /= 2;
                bitLength++;
            }
            bitLength = (bitLength + 1) / 2;
            rootN = N >> bitLength;

            BigInteger lastRoot = BigInteger.Zero;
            do
            {
                if (lastRoot > rootN)
                {
                    if (count++ > 1000)
                    {
                        return rootN;
                    }
                }
                lastRoot = rootN;
                rootN = (BigInteger.Divide(N, rootN) + rootN) >> 1;
            }
            while ((rootN ^ lastRoot) != BigInteger.Zero);
            return rootN;
        }

        public static BigInteger factorial(this int i)
        {
            return factorial((BigInteger)i);
        }

        public static BigInteger factorial(this BigInteger v)
        {
            BigInteger result = 1;
            while (v > 1)
            {
                result *= v;
                v--;
            }
            return result;
        }
    }
}