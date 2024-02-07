import random


def get_requirements():
    """
    This module prints the requiremnents of the Assignment
    """
    print("Developer: Jevon Price")
    print("Pseudo-Random Number Generator")
    print("Program Requirements:\n"
          + "1. Get user beginning and ending integer values, and store in two variables.\n"
          + "2. Display 10 pseudo-random numbers between, and including, above values.\n"
          + "3. Must use integer data types.\n"
          + "4. Example 1: Using range() and randint() functions.\n"
          + "5. Example 2: Using a list with range() and shuffle() functions.\n")


def random_numbers():
    """
    Demonstrates randint and shuffle functions
    """

    start = 0
    end = 0

    print("Input: ")
    start = int(input("Enter beginning value: "))
    end = int(input("Enter ending value: "))

    mysequence = range(6)
    for item in mysequence:
        print(item)

    print("\nOutput: ")
    print("Example 1: Using range() and randint(0 functions: ")
    for item in range(10):
        print(random.randint(start, end), sep=', ', end=' ')

    print("\n")
    print("Example 2: Using a list, with range() and shuffle() functions: ")
    my_list = list(range(start, end + 1))
    random.shuffle(my_list)
    for item in my_list:
        print(item, sep=', ', end=' ')

    print()
