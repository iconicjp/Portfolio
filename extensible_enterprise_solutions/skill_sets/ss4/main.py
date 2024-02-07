import functions as f
def main():
    f.get_requirements()
    user_input = f.get_user_input()

    fat, carb, protein = user_input

    f.calculate_calories(fat, carb, protein)

if __name__ == "__main__":
    main()