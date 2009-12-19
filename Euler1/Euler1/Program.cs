

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
            new Problem27().run();
            Console.ReadLine();
            int current = 1;
            while (true)
            {
                String name = "Problem" + current;
                Type type = Type.GetType("Euler.Problems." + name);
                if (type == null)
                {
                    break;
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

                current++;
            } 

            Console.ReadLine();
        } 
    } 
} 