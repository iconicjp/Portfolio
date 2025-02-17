def get_requirements():
    """
    This module prints the requiremnents of the Assignment
    """
    print("Developer: Jevon Price")
    print("Python Dictionaries")
    print("Program Requirements:\n"
          + "1. Dictionaries (Python data structure): unordered key:value pairs.\n"
          + "2. Dictionary: an associative array (also known as hashes).\n"
          + "3. Any key in a dictionary is associated (or mapped) to a value (i.e., any Python data type).\n"
          + "4. Keys: must be of immutable type (string, number or tuple with immutable elements) and must be unique.\n"
          + "5. Values: can be any data type and can repeat.\n"
          + "6. Create a program that mirrors the following IPO (input/process/output) format.\n"
          + "\tCreate empty dictionary, using curly braces {}: my_dictionary = {} \n"
          + "\tUse the following keys: fname, lname, degree, major, gpa \n"
          + "Note: Dictionaries have key-value pairs instead of single values; this differentiates a dictionary from a set. \n")


def using_dictionaries():
    """
    Creates/Manipulates dictionaries
    """

    v_fname = ""
    v_lname = ""
    v_degree = ""
    v_major = ""
    v_gpa = 0.0
    my_dictionary = {}

    print("Input: ")
    v_fname = input("First Name: ")
    v_lname = input("Last Name: ")
    v_degree = input("Degree: ")
    v_major = input("Major (IT or ICT): ")
    gpa = float(input("GPA: "))

    print()

    my_dictionary['fname'] = v_fname
    my_dictionary['lname'] = v_lname
    my_dictionary['degree'] = v_degree
    my_dictionary['major'] = v_major
    my_dictionary['gpa'] = v_gpa

    print("Output: ")
    print("Print my_dictionary.")
    print(my_dictionary)

    print("\nReturn view of dictionary's (key, value) pair, built-in function:")
    print(my_dictionary.items())\

    print("\nReturn view object of all keys, built-in function:")
    print(my_dictionary.keys())

    print("\nReturn view object of all values in dictionary, builtin functon:")
    print(my_dictionary.values())

    print("\nPrint only first and last names, using keys")
    print(my_dictionary['fname'], my_dictionary['lname'])

    # gen() function returns value of key
    print("\nPrint only first and last names, using get()) function:")
    print(my_dictionary.get("fname"), my_dictionary.get("lname"))

    print("\nCount number of items (key: value pairs) in dictionary:")
    print(len(my_dictionary))

    print("\nRemove last dictionary item (popitem): ")
    my_dictionary.popitem()
    print(my_dictionary)

    print("\nDelete major from dictonary, using key: ")
    my_dictionary.pop("major")
    print(my_dictionary)

    print("\nReturn object type: ")
    print(type(my_dictionary))

    print("\nDelete all items from list: ")
    my_dictionary.clear()
    print(my_dictionary)

    del my_dictionary
