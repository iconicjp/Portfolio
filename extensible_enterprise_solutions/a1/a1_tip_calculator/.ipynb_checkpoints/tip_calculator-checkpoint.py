# Program requirements:
print("Tip Calculator")

# Developer: Jevon Price

# Course: LIS4369

# Date: September 14, 2023

print("Program Requirements:\n" +
      "1. Must use float data type for user input(except, \"Party Number\").\n" +
      "2. Must round calculations to two decimal places.\n" +
      "3. Must format currency with dollar sign and two decimal places.\n")

# Get user inputs and convert to correct type
print("\nUser Input:")
meal_cost = float(input("Cost of meal: "))
tax_percentage = float(input("Tax percentage (Enter whole number):"))
tip_percentage = float(input("Tip percentage (Enter whole number):"))
party_number = int(input("Number in party: "))


#Calculate Totals (tax, tip, amount)
tax_total = round(meal_cost * (tax_percentage / 100), 2) #Coonvert to percentage
due_amount = round(meal_cost + tax_total, 2)
tip_amount = round((due_amount) * (tip_percentage / 100), 2)

total = round(meal_cost + tax_total + tip_amount, 2)
split = round(total/party_number, 2)


#Display results (with formatting)
print("Program output:")
print("Subtotal:\t", "${0:,.2f}".format(meal_cost))
print("Tax:\t\t", "${0:,.2f}".format(tax_total))
print("Amount due:\t", "${0:,.2f}".format(due_amount))
print("Gratuity:\t", "${0:,.2f}".format(tip_amount))
print("Total:\t\t", "${0:,.2f}".format(total))
print("Split:" + "(" + str(party_number) + "):\t", "${0:,.2f}".format(split))
