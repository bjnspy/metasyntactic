using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem9 : Problem
    {
        public void run()
        {
            int a = 0, b = 0, c = 0;
            for (a = 1; a < 1000; a++)
            {
                int a2 = a * a;
                for (b = a + 1; b < 1000; b++)
                {
                    int b2 = b * b;
                    for (c = b + 1; c < 1000; c++)
                    {
                        int c2 = c * c;
                        if (a2 + b2 != c2)
                        {
                            continue;
                        }

                        if (a + b + c == 1000)
                        {
                            goto done;
                        }
                    }
                }
            }
        done:
            long result = (a * b * c);
            if (result != 31875000)
            {
                throw new Exception();
            }
        }
    }
}
