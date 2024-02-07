def get_requirements():
    """
    This module prints the requiremnents of the Assignment
    """
    print("Developer: Jevon Price")
    print("IT/ICT Student Percentage")
    print("Program Requirements:\n" +
        "1. Find number of IT/ ICT students in class.\n" +
        "2. Calculate IT/ ICT Student Percentage.\n" +
        "3. Must use float data type (to facilitate right-alignment). \n" +
        "4. Format, right-align numbers, and round to two decimal places.\n")

def calculate_it_ict_student_percentage():
    """
    Calculates the percetage of IT and ICT students in a class
    """
    #Initialize variables
    num_of_it = 0
    num_of_ict = 0

    #Get user input
    print("Input:")
    num_of_it = int(input("Enter number of IT students: "))
    num_of_ict = int(input("Enter number of ICT students: "))

    #Calculations
    tot_students = num_of_it + num_of_ict
    pct_of_it = num_of_it / tot_students
    pct_of_ict = num_of_ict / tot_students

    #Output
    print("Output :")
    print(f"{'Total Students:':17} {tot_students:>5.2f}")
    print(f"{'IT Students:':17} {pct_of_it:>5.2%}")
    print(f"{'ICT Students:':17} {pct_of_ict:>5.2%}")