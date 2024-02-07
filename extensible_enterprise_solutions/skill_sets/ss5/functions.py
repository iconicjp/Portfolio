def get_requirements():
    """
    This module prints the requiremnents of the Assignment
    """
    print("Developer: Jevon Price")
    print("Python Selection Structures")
    print("Program Requirements:\n"
          + "1. Use Python selection structure.\n"
          + "2. Prompt user for two numbers, and a suitable operator.\n"
          + "3. Test for correct numeric operator.\n"
          + "4. Replicate display below.\n")


def get_user_input():
    """
    Gets user inputs
    """
    num1 = num2 = 0.0

    num1 = float(input("Enter number 1:"))
    num2 = float(input("Enter number 2:"))

    print("Suitable Operators: +,-,*,/,//(integer division),%(modulo operator),**(power)")
    op = input("Enter operator: ")

    return num1, num2, op


def print_selection_structures(num1, num2, op):
    """
    Performs operations based on 'op'
    """
    if (op == "+"):
        print(num1 + num2)
    elif (op == "-"):
        print(num1 - num2)
    elif (op == "*"):
        print(num1 * num2)
    elif (op == "/"):
        if num2 == 0:
            print("Cannot divide by 0!")
        else:
            print(num1 / num2)
    elif (op == "//"):
        if num2 == 0:
            print("Cannot divide by 0!")
        else:
            print(num1 // num2)
    elif (op == "%"):
        if num2 == 0:
            print("Cannot divide by 0!")
        else:
            print(num1 % num2)
    elif (op == "**"):
        print(num1 ** num2)
    else:
        print("Incorrect operator!")