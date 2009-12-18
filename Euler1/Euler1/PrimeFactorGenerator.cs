using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Numerics;

namespace Euler
{
    public class PrimeFactorGenerator : IEnumerable<BigInteger>
    {
        private BigInteger number;

        public PrimeFactorGenerator(BigInteger number)
        {
            this.number = number;
        } 

        public IEnumerator<BigInteger> GetEnumerator()
        {
            BigInteger squareRoot = number.sqrt();
            for (BigInteger i = 0; i < squareRoot; i++)
            {

            } 
            return null;
        } 

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator()
        {
            throw new NotImplementedException();
        } 
    } 
} 
