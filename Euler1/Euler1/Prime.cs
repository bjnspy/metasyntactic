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
            return primesSet.Contains(v);

            if (v < 2)
            {
                return false;
            }
            if (v == 2)
            {
                return true;
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
        static HashSet<long> primesSet = new HashSet<long>();

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

            primesSet.UnionWith(primes);
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
                    }  while (current < long.MaxValue);
                    done = true;
                } 
            } 
        } 

        public static PrimeFactorization factorize(long value)
        {
            var variables = new List<long>();
            var exponents = new List<long>();

            long currentValue = value;
            foreach (var p in Prime.Generator)
            {
                if (currentValue < 2)
                {
                    break;
                } 
                if (currentValue % p == 0)
                {
                    variables.Add(p);
                    exponents.Add(0);

                    while (currentValue % p == 0)
                    {
                        currentValue /= p;
                        exponents[exponents.Count - 1]++;
                    } 
                } 
            } 

            return new PrimeFactorization(variables, exponents);
        } 
    } 
} 