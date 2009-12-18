using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem18 : Problem
    {
        string data =
@"75
95 64
17 47 82
18 35 87 10
20 04 82 47 65
19 01 23 75 03 34
88 02 77 73 07 63 67
99 65 04 28 06 16 70 92
41 41 26 56 83 40 80 70 33
41 48 72 33 47 32 37 16 94 29
53 71 44 65 25 43 91 52 97 51 14
70 11 33 28 77 73 17 78 39 68 17 57
91 71 52 38 17 14 91 43 58 50 27 29 48
63 66 04 68 89 53 67 30 73 16 69 87 40 31
04 62 98 27 23 09 70 98 73 93 38 53 60 04 23";

        public bool run()
        {
            List<List<int>> rows = new List<List<int>>();
            foreach (var line in data.Split('\n'))
            {
                List<int> row = new List<int>();
                foreach (var v in line.Split(' ')) {
                    row.Add(int.Parse(v));
                } 
                rows.Add(row);
            } 

            List<List<int>> maximalTotals = new List<List<int>>();
            maximalTotals.Add(rows[0]);
            for (int y = 1; y < rows.Count; y++)
            {
                List<int> lastTotal = maximalTotals.Last();
                List<int> row = rows[y];

                List<int> totals = new List<int>();

                for (int x = 0; x < row.Count; x++)
                {
                    int currentValue = row[x];
                    if (x == 0)
                    {
                        totals.Add(lastTotal.First() + currentValue);
                    } 
                    else if (x == row.Count - 1)
                    {
                        totals.Add(lastTotal.Last() + currentValue);
                    } 
                    else
                    {
                        int upperLeft = lastTotal[x - 1];
                        int upperRight = lastTotal[x];
                        int max = Math.Max(upperLeft + currentValue, upperRight + currentValue);
                        totals.Add(max);
                    } 
                } 

                maximalTotals.Add(totals);
            } 

            var result = maximalTotals.Last().Max();
            return result == 1074;
        } 
    } 
} 
