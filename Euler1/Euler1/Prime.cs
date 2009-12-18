using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.Concurrent;

namespace Euler
{
    class Prime
    {
        public static bool isPrime(long v)
        {
            if (v < 2)
            {
                return false;
            }

            long sqrt = (long)Math.Sqrt(v) + 1;
            for (long i = 2; i <= sqrt; i++)
            {
                if (v % i == 0)
                {
                    return false;
                }
            }
            return true;
        }

        static List<long> primes = new List<long>();

        static Prime()
        {
            bool[] sieve = new bool[10000000];
            for (int i = 2; i < sieve.Length; i++)
            {
                sieve[i] = true;
            }

            int currentPrime = 2;
            while (currentPrime * currentPrime < sieve.Length)
            {
                for (int i = 2; i * currentPrime < sieve.Length; i++)
                {
                    sieve[i * currentPrime] = false;
                }
                for (var i = currentPrime + 1; ; i++)
                {
                    if (sieve[i])
                    {
                        currentPrime = i;
                        break;
                    }
                }
            }

            for (int i = 0; i < sieve.Length; i++)
            {
                if (sieve[i])
                {
                    primes.Add(i);
                }
            }
        }

        static bool done;

        public static IEnumerable<long> Generator
        {
            get
            {
                foreach (var v in primes)
                {
                    yield return v;
                }

                if (!done)
                {
                    long lastPrime = primes[primes.Count - 1];
                    long current = lastPrime;
                    do
                    {
                        current++;
                        if (Prime.isPrime(current))
                        {
                            primes.Add(current);
                            yield return current;
                        }
                    } while (current < long.MaxValue);
                    done = true;
                }
            }
        }
    }
}