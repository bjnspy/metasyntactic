using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem14 : Problem
    {
        public void run()
        {
            var maxLength = 0L;
            var number = -1L;
            for (long i = 1; i < 1000000; i++)
            {
                var length = computeLength(i);
                if (length > maxLength)
                {
                    maxLength = length;
                    number = i;
                }
            }

            if (number != 837799)
            {
                throw new Exception();
            }
        }

        private long computeLength(long value)
        {
            long length = 1;
            while (value != 1)
            {
                length++;
                if (value % 2 == 0)
                {
                    value /= 2;
                }
                else
                {
                    value = 3 * value + 1;
                }
            }
            return length;
        }
    }
}
