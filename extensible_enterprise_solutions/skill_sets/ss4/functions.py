def get_requirements():
    """
    This module prints the requiremnents of the Assignment
    """
    print("Developer: Jevon Price")
    print("Calorie Percentage")
    print("Program Requirements:\n"
          + "1. Find calories per grams of fat, carbs, and protein.\n"
          + "2. Calculate percentages.\n"
          + "3. Must use float data type\n"
          + "4. Format, right-align numbers, and round to decimal places.\n")


def get_user_input():
    """
    Gets user inputs
    """
    #initialize variables
    fat_g = carb_g = protein_g = 0.0

    print("Input:")
    fat_g = float(input("Enter total fat grams: "))
    carb_g = float(input("Enter total carb grams: "))
    protein_g = float(input("Enter total protein grams: "))

    return fat_g, carb_g, protein_g


def calculate_calories(f_grams, c_grams, p_grams):
    """
    Calculates calorie percentages
    """
    #initialize variables
    total_calories = percent_fat = percent_carbs = percent_protein = 0.0
    
    #Calculate number of calories
    fat_cal = f_grams * 9
    carb_cal = c_grams * 4
    protein_cal = p_grams * 4
    total_calories = fat_cal + carb_cal + protein_cal

    #calculate percentages
    percent_fat = fat_cal / total_calories
    percent_carbs = carb_cal / total_calories
    percent_protein = protein_cal / total_calories

    print("Output:")
    print(f"{'Type':8} {'Calories':>10} {'Percentage':>13}")
    print(f"{'Fat':8} {fat_cal:10,.2f} {percent_fat:13.2%}")
    print(f"{'Carbs':8} {carb_cal:10,.2f} {percent_carbs:13.2%}")
    print(f"{'Protein':8} {protein_cal:10,.2f} {percent_protein:13.2%}")