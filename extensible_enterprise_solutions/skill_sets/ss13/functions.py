import math as m


def get_requirements():
    """
    This module prints the requiremnents of the Assignment
    """
    print("Developer: Jevon Price")
    print("Sphere Volume Program")
    print("Program Requirements:\n"
          + "1. Program calculates sphere volume in liquid U.S. gallons from user-entered diameter value in inches, and rounds to two decimal places.\n"
          + "2. Must use Python's *built-in* PI and pow() capabilities.\n"
          + "3. Program checks for non-integers and non-numeric values.\n"
          + "4. Program continues to prompt for user entry until no longer requested, prompt accepts upper or lower case letters.\n")


def get_user_input():
    """
    Gets user inputs and converts it to U.S. gallons
    """

    calc_question = 'y'
    diameter = 1
    volume = 0.0
    print("Input:")
    calc_question = input(
        "Do you want to calculate a sphere volume (y or n)? ").lower()
    print("\nOutput:")
    while calc_question == 'y':
        while True:
            try:
                diameter = int(
                    input("Please enter diameter in inches (integers only): "))
                break
            except ValueError:
                print("\nNot valid integer!")
        volume = convert_to_gallons(convert_to_cubic(diameter))
        print(f"\nSphere volume: {volume:.2f} liquid U.S. gallons\n")
        calc_question = input(
            "Do you want to calculate another sphere volume? ").lower()
    print("\nThank you for using our Sphere Volume Calculator!")


def convert_to_cubic(diameter):
    """
    Gets sphere diameter in inches and converts to cubic inches
    """
    # radius = diameter / 2
    volume = m.pi * (m.pow(diameter, 3) / 6)
    return volume


def convert_to_gallons(cub_inches):
    """
    Converts cubic inches to US gallons
    """
    return (cub_inches / 231)
