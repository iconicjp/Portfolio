def get_requirements():
    """
    This module prints the requiremnents of the Assignment
    """
    print("Developer: Jevon Price")
    print("Payroll Calculator")
    print("Program Requirements:\n"
          + "1. Must use float data type for user input.\n"
          + "2. Overtime rate: 1.5 times hourly rate (hours over 40).\n"
          + "3. Holiday rate: 2.0 times hourly rate (all holiday hours).\n"
          + "4. Must format currency with dollar sign, and round to two decimal places.\n"
          + "5. Create at least three functions that are called by the program:\n"
          + "\ta. main(): calls at least two other functions.\n"
          + "\tb. get-requirements(): displays the program requirements.\n"
          + "\tc. calculate_payroll(): calculates an individual one-week paycheck.\n")


def calculate_payroll():
    """
    Gets user input and does the calculations to determine pay
    """
    #Set constants
    BASE_HOURS = 40
    OT_RATE = 1.5
    HOLIDAY_RATE = 2

    #Get user inputs
    print("Input: ")

    hours_worked = float(input("Enter hours worked: "))
    hol_hours = float(input("Enter holiday hours worked: "))
    pay_rate = float(input("Enter hourly pay rate: "))

    #Calculations
    base_pay = BASE_HOURS * pay_rate
    over_hours = hours_worked - BASE_HOURS


    if hours_worked > BASE_HOURS:
        #Pay with overtime
        over_pay = over_hours * pay_rate * OT_RATE #OT pay
        holiday_pay = hol_hours * pay_rate * HOLIDAY_RATE #holiday pay
        gross_pay = base_pay + over_pay + holiday_pay

        print_pay(base_pay, holiday_pay, gross_pay, over_pay)

    else:
        #Pay w/o OT
        base_pay = hours_worked * pay_rate
        holiday_pay = hol_hours * pay_rate * HOLIDAY_RATE #holiday pay
        gross_pay = (hours_worked * pay_rate) + holiday_pay

        print_pay(base_pay, holiday_pay, gross_pay)


def print_pay(base_pay, holiday_pay, gross_pay, over_pay = 0.0):
    """
    Accepts the base, holiday, overtime, and gross pay 
    and prints a formatted string of those values
    """
    print("\nOutput: ")
    print(f"{'Base: ':<10} ${base_pay:,.2f}")
    print(f"{'Overtime: ':<10} ${over_pay:,.2f}")
    print(f"{'Holiday: ':<10} ${holiday_pay:,.2f}")
    print(f"{'Gross: ':<10} ${gross_pay:,.2f}")
