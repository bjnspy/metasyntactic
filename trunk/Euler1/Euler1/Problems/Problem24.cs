using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem24 : Problem
    {
        public bool run()
        {
            var current = "0123456789";
            var result = permute(current, 999999);

            return result == "2783915460";
        }

        private string permute(string current, int count)
        {
            if (current.Length == 0)
            {
                return "";
            }

            int f = (int)(current.Length - 1).factorial();
            char c = current[count / f];

            var sub = new String(current.Where(x => x != c).ToArray());

            return c + permute(sub, count % f);
        }
    }
}