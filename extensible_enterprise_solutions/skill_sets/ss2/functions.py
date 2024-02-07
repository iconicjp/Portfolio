def get_requirements():
    """
    This module prints the requiremnents of the Assignment
    """
    print("Developer: Jevon Price")
    print("Miles Per Gallon\n")
    print("Program Requirements:\n"
          + "1. Convert MPG.\n"
          + "2. Must use float data type for user input and calculation.\n"
          + "3. Format and round conversion to two decimal places.\n")


def calculate_mpg():
    """
    Calculates miles per gallon
    """
    #Initialize variables
    miles, gallon, mpg = 0.0, 0.0, 0.0

    # Get user inputs and convert to float type
    print("User Input:")
    miles_driven = float(input("Enter miles driven: "))
    fuel_gallon = float(input("Enter gallons of fuel used: "))

    #Calculate MPG
    mpg = miles_driven / fuel_gallon
    
    #Display results (with formatting)
    print("\nOutput:")
    print(f"{miles_driven:,.2f} miles driven and {fuel_gallon:,.2f} gallons used = {mpg:,.2f} mpg")