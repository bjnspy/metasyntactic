using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler
{
    class PrimeFactorization
    {
        private List<long> variables;
        private List<long> exponents;

        public PrimeFactorization(List<long> variables, List<long> exponents)
        {
            this.variables = variables;
            this.exponents = exponents;
        }

        public List<long> Variables
        {
            get
            {
                return variables;
            }
        }

        public List<long> Exponents
        {
            get
            {
                return exponents;
            }
        }
    }
}
