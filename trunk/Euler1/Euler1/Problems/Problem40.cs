using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem40 : Problem
    {
        public bool run()
        {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < 1000000; i++)
            {
                sb.Append(i.ToString());
            }
            string value = sb.ToString();

            int result =
                value[1].digitToInt() * value[10].digitToInt() *
                value[100].digitToInt() * value[1000].digitToInt() *
                value[10000].digitToInt() * value[100000].digitToInt() *
                value[1000000].digitToInt();

            return result == 210;
        }
    }
}
