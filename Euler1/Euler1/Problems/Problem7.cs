using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem7 : Problem
    {
        public void run()
        {
            int current = 1;
            long prime = 0;
            foreach (var p in Prime.Generator)
            {
                if (current == 10001)
                {
                    prime = p;
                    break;
                }

                current++;
            }

            if (prime != 104743)
            {
                throw new Exception();
            }
        }
    }
}
