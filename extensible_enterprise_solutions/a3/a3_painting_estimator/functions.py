def get_requirements():
    """
    This module prints the requiremnents of the Assignment
    """
    print("Developer: Jevon Price")
    print("Painting Estimator")
    print("Program Requirements:\n"
          + "1. Calculate home interior paint cost (w/o primer).\n"
          + "2. Must use float data types.\n"
          + "3. Must use SQFT_PER_GALLON constant (350).\n"
          + "4. Must use iteration structure (aka ""loop"").\n"
          + "5. Format, right-align numbers, and round to decimal places.\n"
          + "Create at least five functims that are called by the program: "
          + "\ta. main(): calls two other functions: get_requirements() and estimate_painting_cost().\n"
          + "\tb. get-requirements(): displays the program requirements.\n"
          + "\tc. estimate_painting_cost(): calculates interior home painting, and calls print functions.\n"
          + "\td. print_painting_estimate(): displays painting costs.\n"
          + "\te. print_painting_percentage(): displays painting costs percentages\n")


def estimate_painting_cost():
    """
    Calculates cost of painting and calls print functions
    """
    #Set constants
    SQFT_PER_GALLON = 350


    another = True
    while another:

        #initialize variables
        interior = ppg = painting_rate = 0.0
        num_gallons = paint_amount = labor_amount = total_amount = 0.0
        paint_percent = labor_percent = total_percent = 0.0

        #Get user inputs
        print("Input: ")

        interior = float(input("Enter total interior sq ft: "))
        ppg = float(input("Enter price per gallon paint: "))
        painting_rate = float(input("Enter hourly painting rate per sq ft: "))

        #Calculations
        num_gallons = interior / SQFT_PER_GALLON

        paint_amount = ppg * num_gallons
        labor_amount = painting_rate * interior
        total_amount = paint_amount + labor_amount

        paint_percent = paint_amount / total_amount
        labor_percent = labor_amount / total_amount
        total_percent = total_amount / total_amount


        print("\nOutput: ")
        print_painting_estimate(interior, ppg, painting_rate, SQFT_PER_GALLON, num_gallons)
        print_painting_percentage(paint_amount, labor_amount, total_amount, paint_percent, labor_percent, total_percent)

        response = input("Estimate another paint job? (y/n): ")
        if response == 'y':
            another = True
        elif response == 'n':
            another = False
        else:
            while response != 'y' and response != 'n':
                print("Invalid response please type a 'y' or 'n'.\n\n")
                response = input("Estimate another paint job? (y/n): ")

    print("Thank you for using our Painting Estimator!")
    print("Please see our web site: http://www.LIS4369.com")

def print_painting_estimate(interior_total, price_pg_paint, paint_rate, SQFT_PER_GALLON, gallon_num):
    """
    Prints painting estimates
    """
    print(f"{'Item':25}{'Amount':>9}")
    print(f"{'Total Sq Ft:':25}{interior_total:>9,.2f}")
    print(f"{'Sq Ft per Gallon:':25}{SQFT_PER_GALLON:>9.2f}")
    print(f"{'Number of Gallons:':25}{gallon_num:>9.2f}")
    print(f"{'Paint per Gallon:':25}${price_pg_paint:>8.2f}")
    print(f"{'Labor per Sq Ft:':25}${paint_rate:>8.2f}\n")


def print_painting_percentage(p_amount, l_amount, t_amount, p_percent, l_percent, t_percent):
    """
    Prints painting cost percentage
    """
    print(f"{'Cost':9}{'Amount':>10}{'Percentage':>15}")
    print(f"{'Paint:':9}${p_amount:>9.2f}{p_percent:>16.2%}")
    print(f"{'Labor:':9}${l_amount:>9.2f}{l_percent:>16.2%}")
    print(f"{'Total:':9}${t_amount:>9.2f}{t_percent:>16.2%}\n")