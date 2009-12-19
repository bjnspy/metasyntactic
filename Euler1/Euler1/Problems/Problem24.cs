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
            var result = current.permute(999999);

            return result == "2783915460";
        }
    }
}