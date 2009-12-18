using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Euler.Problems
{
    class Problem17 : Problem
    {
        public void run()
        {
            int count = 0;
            for (int i = 1; i <= 1000; i++)
            {
                count += IntToString(i).Length;
            }
            if (count != 21124)
            {
                throw new Exception();
            }
        }

        private string IntToString(int i)
        {
            string value = IntToStringWorker(i);
            Console.WriteLine(value);
            return value.Replace(" ", "");
        }

        private String IntToStringWorker(int i)
        {
            if (i < 20)
            {
                return sub20ToString(i);
            }
            else if (i < 100)
            {
                return multipleOf10ToString(i) + " " + IntToStringWorker(i % 10);
            }
            else if (i < 1000)
            {
                var result = IntToStringWorker(i / 100) + " hundred ";
                if (i % 100 != 0)
                {
                    result += "and " + IntToStringWorker(i % 100);
                }
                return result;
            }
            else
            {
                return "one thousand";
            }
        }


        private String multipleOf10ToString(int i)
        {
            switch (i / 10)
            {
                case 9: return "ninety";
                case 8: return "eighty";
                case 7: return "seventy";
                case 6: return "sixty";
                case 5: return "fifty";
                case 4: return "forty";
                case 3: return "thirty";
                case 2: return "twenty";
            }

            throw new Exception();
        }

        private String sub20ToString(int i)
        {
            switch (i)
            {
                case 19: return "nineteen";
                case 18: return "eighteen";
                case 17: return "seventeen";
                case 16: return "sixteen";
                case 15: return "fifteen";
                case 14: return "fourteen";
                case 13: return "thirteen";
                case 12: return "twelve";
                case 11: return "eleven";
                case 10: return "ten";
                case 9: return "nine";
                case 8: return "eight";
                case 7: return "seven";
                case 6: return "six";
                case 5: return "five";
                case 4: return "four";
                case 3: return "three";
                case 2: return "two";
                case 1: return "one";
                case 0: return "";
            }

            throw new Exception();
        }
    }
}