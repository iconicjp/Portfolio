def get_requirements():
    """
    This module prints the requiremnents of the Assignment
    """
    print("Developer: Jevon Price")
    print("Square Feet to Acres\n")
    print("Program Requirements:\n"
          + "1. Research: number of square feet to acre of land.\n"
          + "2. Must use float data type for user input and calculation.\n"
          + "3. Format and round conversion to two decimal places.\n")


def calculate_acres():
    """
    Gets square feet and converts to acres and prints it
    """
    #Get input
    print("Input: ")
    square_footage = float(input("Enter Square feet: "))

    #Conversion
    acre_calc = square_footage / 43560.00

    print("\nOutput: ")
    print(f"{square_footage:,.2f} square feet = {acre_calc:.2f} acres")
