#!/usr/bin/env python3
def get_requirements():
    """
    This module prints the requiremnents of the Assignment
    """
    print("Developer: Jevon Price")
    print("Python Calculator with Error Handling")
    print("Program Requirements:\n"
          + "1. Program calculates two numbers, and rounds to two decimal places.\n"
          + "2. Prompt user for two numbers, and a suitable operator.\n"
          + "3. Use Python error handling to validate data.\n"
          + "4. Test for correct arithmetic operator.\n"
          + "5. Division by zero not permitted.\n"
          + "6. Note: Program loops until correct input entered - numbers and arithmetic operator.\n"
          + "7. Replicate display below.\n")


def get_valid_float(pos):
    """
    Gets number and checks to ensure correct value
    """
    while True:
        try:
            num = float(input("\nEnter num" + str(pos) + ": "))
            return num
        except ValueError:
            print("Not valid number!")
            continue


def get_valid_operator():
    """
    Gets operator and makes sure it is valid
    """
    print("\nSuitable operators: +, -, *, /, //(integer division), %(modulo operator), **(power)")
    op_list = ['+', '-', '*', '/', '//', '%', '**']
    op_test = input("Enter operator: ")

    while True:
        if op_test in op_list:
            return op_test

        else:
            print("Incorrect operator!")
            op_test = input("\nEnter Operator: ")
            continue


def error_handling():
    """
    Makes sure division by 0 is not happening and computes results
    """
    num1 = num2 = 0.0
    op = ' '

    num1 = get_valid_float(1)
    num2 = get_valid_float(2)
    op = get_valid_operator()

    if op == '+':
        print(f"{num1 + num2:,.2f}")

    elif op == '-':
        print(f"{num1 - num2:,.2f}")

    elif op == '*':
        print(f"{num1 * num2:,.2f}")

    elif op == '/':
        while True:
            try:
                print(f"{num1 / num2:.2f}")
                break
            except ZeroDivisionError:
                print("Cannot divide by zero!")
                num2 = get_valid_float(2)
                continue

    elif op == '//':
        while True:
            try:
                print(f"{num1 // num2:,.2f}")
                break
            except ZeroDivisionError:
                print("Cannot divide by zero!")
                num2 = get_valid_float(2)
                continue

    elif op == '%':
        while True:
            try:
                print(f"{num1 % num2:,.2f}")
                break
            except ZeroDivisionError:
                print("Cannot divide by zero!")
                num2 = get_valid_float(2)
                continue

    elif op == '**':
        print(f"{num1 ** num2:.2f}")

    else:
        print("Incorrect operator!")
    print("\nThank you for using our Math Calculator!")
