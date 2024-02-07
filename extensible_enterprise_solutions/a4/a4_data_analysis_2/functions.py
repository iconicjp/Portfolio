import re  # provides regular expression matching
from matplotlib import style
import matplotlib.pyplot as plt
import pandas as pd  # Pandas = "Python Data Analysis Library"
# np supports arrays and matrices, along with mathematical functions for scientific computing
import numpy as np  # Numerical Python
# print full NumPy array, no ellipsis
np.set_printoptions(threshold=np.inf)


def get_requirements():
    """
    This module prints the requiremnents of the Assignment
    """
    print("Developer: Jevon Price")
    print("Data Analysis 1")
    print("Program Requirements:\n"
          + "1. Run demo.py.\n"
          + "2. If errors, more than likely missing installations.\n"
          + "3. Test Python Package Installer: conda list\n"
          + "4. Research how to install any missing packages:\n"
          + "5. Create at least three functions that are called by the program:\n"
          + "\ta. main(): calls at least two other functions.\n"
          + "\tb. get_requirements(): displays the program requirements.\n"
          + "\tc. data_analysis_2(): displays results as per demo.py.\n"
          + "6. Display graph as per instructions w/in demo.py.")


def data_analysis_2():
    """
    Gathers data and plots it in new 
    """

# Read CSV (comma-separated values) file into DataFrame
# Data sets: https://vincentarelbundock.github.io/Rdatasets/
# https://raw.github.com/vincentarelbundock/Rdatasets/master/csv/COUNT/titanic.csv
# https://vincentarelbundock.github.io/Rdatasets/csv/datasets/Titanic.csv
# https://raw.github.com/vincentarelbundock/Rdatasets/master/csv/carData/TitanicSurvival.csv

    url = "https://raw.github.com/vincentarelbundock/Rdatasets/master/csv/Stat2Data/Titanic.csv"
    df = pd.read_csv(url)

    print("\n *** DataFrame composed of three components: index, columns, and data. Data also known as values .*** ")
    # https://medium.com/dunder-data/selecting-subsets-of-data-in-pandas-6fcd0170be9c
    index = df.index
    columns = df.columns
    values = df.values

    print("\n1. Print indexes:")
    print(index)

    print("\n2. Print columns:")
    print(columns)

    # start/stop may be negative number; that is, counts from end of array instead of beginning.
    # a[-2:] # last two elements in array
    # a[ :- 2] # all elements except last two elements

    # Similarly, step may be a negative number:
    # a[ ::- 1] # all elements in array, reversed
    # a[1 ::- 1] # first two elements, reversed
    # a[ :- 3 :- 1] # last two elements, reversed
    # a[-3 ::- 1] # all elements except last two elements, reversed
    # Also, if fewer elements than requested, empty list, instead of error !.
    # For example, if [ :- 2] and only contains one element, returns empty list instead of an error!

    # Same as above
    print("\n3. Print columns (another way):")
    print(df.columns[:])  # using slicing notation

    print("\n3a. Print columns (slicing notation, using all three options):")
    print(df.columns[0:7:1])  # using slicing notation

    print("\n4. Print (all) values, in array format:")
    print(values)

    print("\n5. *** Print component data types :*** ")
    print("\na) index type:")
    print(type(index))
    # pandas.core.indexes.range.RangeIndex

    print("\nb) columns type:")
    print(type(columns))
    # pandas.core.indexes.base.Index

    print("\nc) values type:")
    print(type(values))
    # numpy.ndarray

    print("\n6. Print summary of DataFrame (similar to 'describe tablename;' in MySQL):")
    print(df.info())

    print("\n7. First five lines (all columns):")
    print(df.head())

    # https://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.drop.html
    # Note: 'Unnamed: 0' appears to be used just to number rows

    # df = df.drop('Unnaamed: 0', 1)  # drop column 'Unnamed: 0'

    print("\n8. Print summary of DataFrame (after dropping column 'Unnamed: 0'):")
    print(df.info())

    print("\n9. First five lines (after dropping column 'Unnamed: 0'):")
    print(df.head())

    # Note: contolled/precise data selection (data slicing)
    # 1) DataFrame.loc gets rows (or columns) with particular labels (names) from index
    # 2) DataFrame.iloc (stands for integer location) gets rows (or columns) at particular positions in index (i.e., only takes integers)
    # .loc/.iloc accepts same slice notation that Python lists do for both row and columns. Slice notation being start:stop:step
    # .loc includes last value with slice notation, .iloc does *not *-- that is, .iloc sliceis *** exclusive *** of last integer!
    print("\n *** Precise data selection (data slicing) :*** ")
    print("\n10. Using iloc, return first 3 rows:")
    print(df.iloc[:3])

    print("\n11. Using iloc, return last 3 rows (start on index 1310 to end):")
    print(df.iloc[1310:])

    # select rows and columns simultaneously
    # separate row and column with comma
    # example: df.iloc[row_index, column_index]

    print("\n12. Select rows 1, 3, and 5; and columns 2, 4, and 6 (includes index column):")
    a = df.iloc[[0, 2, 4], [1, 3, 5]]
    print(a)

    print("\n13. Select all rows; and columns 2, 4, and 6 (includes index column):")
    a = df.iloc[:, [1, 3, 5]]
    print(a)

    print("\n14. Select rows 1, 3, and 5; and all columns (includes index column):")
    a = df.iloc[[0, 2, 4], :]
    # a = df.iloc[[0, 2, 4]] # Note: leaving out colon selects all columns as well
    print(a)

    print("\n15. Select all rows, and all columns (includes index column). Note: only first and last 30 records displayed:")
    a = df.iloc[:, :]
    print(a)

    print("\n16. Select all rows, and all columns, starting at column 2 (includes index column). Note: only first and last 30 records displayed:")
    a = df.iloc[:, 1:]
    print(a)

    print("\n17. Select row 1, and column 1, (includes index column):")
    # Note: .iloc does *not* contain last index value -- here, should have included 1!
    a = df.iloc[0:1, 0:1]
    print(a)

    print("\n18. Select rows 3-5, and columns 3-5, (includes index column):")
    # Note: .iloc does *not* contain last index value -- here, should have included 5!
    a = df.iloc[2:5, 2:5]
    print(a)

    print("\n19. *** Convert pandas DataFrame df to NumPy ndarray, use values command :*** ")
    # Select all rows, and all columns, starting at column 2:
    # ndarray = N-dimensional array (rows and columns)
    b = df.iloc[:, 1:].values

    print("\n20. Print data frame type:")
    print(type(df))

    print("\n21. Print a type:")
    print(type(a))

    print("\n22. Print b type:")
    print(type(b))

    print("\n23. Print number of dimensions and items in array (rows, columns). Remember: starting at column 2:")
    print(b.shape)

    print("\n24. Print type of items in array. Remember: ndarray is an array of arrays. Each record/item is an array.")
    print(b.dtype)

    print("\n25. Printing a:")
    print(a)

    print("\n26. Length a:")
    print(len(a))

    print("\n27. Printing b:")
    print(b)

    print("\n28. Length b:")
    print(len(b))

    # Print element of ndarray b in *second* row, *third* column
    print("\n29. Print element of (NumPy array) ndarray b in *second* row, *third* column:")
    print(b[1, 2])

    # Print full NumPy array, no ellipsis: here is why np.set_printoptions(threshold=np.inf) is set at top of file
    print("\n30. Print all records for NumPy array column 2:")
    print(b[:, 1])

    print("\n31. Get passenger names:")
    names = df["Name"]
    print(names)

    print("\n32. Find all passengers with name 'Allison' (using regular expressions):")
    # Note: 'r' obviates the need for an escape sequence. For example: \'(Allison)\'
    # See: https://docs.python.org/2/library/re.html
    for name in names:
        print(re.search(r'(Allison)', name))
        # Note: there are various ways of retrieving data

    # Note: print full DataFrame, w/no ellipsis
    # will automatically return options to their default values
    # with pd.option_context('display.max_rows', None):
    # print(df) # print entire dataframe

    print("\n *** 33. Statistical Analysis (DataFrame notation) :*** ")
    # difference between np.mean and np.average: average takes optional weight parameter. If not supplied they are equivalent.
    print("\na) Print mean age:")
    avg = df["Age"].mean()  # second column
    print(avg)

    print("\nb) Print mean age, rounded to two decimal places:")

    avg = round(df["Age"].mean(), 2)  # no last 0 (works with Anaconda)
    # avg= df["Age"].mean().round(2) # will *not* display last 0 (does not work with Anaconda)
    print(avg)

    print("\nc) Print mean of every column in DataFrame (may not be suitable with certain columns):")
    # avg_all = df.mean(axis=0)  # mean every column
    # avg_all= df.mean(axis=1) # mean every row
    # print(avg_all)

    print("\nd) Print summary statistics (DataFrame notation):")
    # returns three quartiles, mean, count, min/max values, and standard deviation
    describe = df["Age"].describe()  # second column
    # describe = df["Age"].describe(percentiles=[.10, .20, .50, .80]) # choose different percentiles
    print(describe)

    print("\ne) Print minimum age (DataFrame notation):")
    # can also do functions separately
    min = df["Age"].min()  # second column
    print(min)

    print("\nf) Print maximum age (DataFrame notation):")
    max = df["Age"].max()  # second column
    print(max)

    print("\ng) Print median age (DataFrame notation):")
    median = df["Age"].median()  # second column
    print(median)

    print("\nh) Print mode age (DataFrame notation):")
    mode = df["Age"].mode()  # second column
    print(mode)

    print("\ni) Print number of values (DataFrame notation):")
    count = df["Age"].count()  # second column
    print(count)

    age_20 = df.iloc[:20, 3]
    # print(age_20)

    print("\n *** Graph: Display ages of the first 20 passengers (use code from previous assignment) :*** ")
    style.use('ggplot')
    age_20.plot()
    plt.legend()
    plt.show()
