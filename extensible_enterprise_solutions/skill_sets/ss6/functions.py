def get_requirements():
    """
    This module prints the requiremnents of the Assignment
    """
    print("Developer: Jevon Price")
    print("Python Looping Structures")
    print("Program Requirements:\n"
          + "1. Print while loop.\n"
          + "2. Print for loops using range() function, and implicit and explicit lists.\n"
          + "3. Use break and continue statements.\n"
          + "4. Replicate display below.\n"
          + "Note: In Python, for loop used for iterating over a sequence (i.e., list, tuple, dictionary, set, or string).")


def print_loops():
    """
    Shows the structure of different loops
    """

    # range() function has two sets of parameters:

    # 1. range(stop)
    # stop: Number of integers (whole numbers) to generate, starting from zero.

    # Example: range(3) == [0, 1, 2]

    # 2. range([start], stopL, step])
    # start: starting number
    # stop: generate numbers up to, but not including number
    # step: difference between each number in sequence


    print("\n1. while loop:")
    i=1
    while i <= 3:
        print(i)
        i += 1

    # or, i +=1

    print("\n2. for loop: using range() function with 1 arg")
    # range() function returns sequence of numbers, starting from 0 by default, and increments by 1 (by default),
    # and ends at a specified number, *not* including that number.
    # prints 0 - 3, not including 3
    for i in range(4):
        print(i)


    print("\n3. for loop: using range function with two args")
    # calling it with two arguments creates sequence of numbers from first to second, not including second
    # [1, 2, 3]
    for i in range(1, 4):
        print(i)

    print("\n4. for loop: using range()) function with three args (interval 2):")
    # third argument is interval
    # [1, 3]
    for i in range(1, 4, 2):
        print(i)

    print("\n5. for loop: using range() function with three args (negative interval):")
    # interval can be negative
    # [3, 1]
    for i in range(3, 0, -2):
        print(i)

    print("\n6. for loop using (implicit) list (i.e., list not assigned to variable):")
    # prints 1 - 3, including 1 and 3
    for i in [1, 2, 3]:
        print(i)

    print("\n7. for loop iterating through (explicit) string list:")
    states = ['Michigan', 'Alabama', "Florida"]
    for state in states:
        print(state)

    print("\n8. for loop using break statement (stops loop):")
    # break statement stops loop
    states = ['Michigan', 'Alabama', 'Florida']
    for state in states:
        if state == "Alabama":
            break
        print(state)

    print("\n9. for loop using continue statement (stops and continues with next):")
    # continue statement stops current iteration, and continues with next
    states = ['Michigan', 'Alabama', 'Florida']
    for state in states:
        if state == "Alabama":
            continue
        print(state)

    print("\n10. print list length:")
    states = ['Michigan', 'Alabama', 'Florida']
    print(len(states))
