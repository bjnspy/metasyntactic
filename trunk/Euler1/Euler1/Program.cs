

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Euler.Problems;

namespace Euler
{
    class Program
    {
        static void Main()
        {
            new Problem81().run();
            Console.ReadLine();
            for (int i = 1; i < 300; i++)
            {
                String name = "Problem" + i;
                Type type = Type.GetType("Euler.Problems." + name);
                if (type == null)
                {
                    continue;
                }
                Problem problem = (Problem)Activator.CreateInstance(type);
                Console.Write(name + ": ");

                if (problem.run())
                {
                    Console.WriteLine("passed");
                }
                else
                {
                    Console.WriteLine("failed");
                    break;
                }
            }

            Console.ReadLine();
        }
    }
}