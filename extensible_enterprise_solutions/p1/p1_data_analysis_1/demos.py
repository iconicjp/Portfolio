print("Developer: Jevon Price")
print("Data Analysis 1")
print("Program Requirements:\n"
      + "1. Run demo.py.\n"
      + "2. If errors, more than likely missing installations.\n"
      + "3. Test Python Package Installer: pip freeze\n"
      + "4. Research how to do the following installations:\n"
      + "\ta. pandas (only if missing)\n"
      + "\tb. pandas-datareader (only if missing)\n"
      + "\tc. matplotlib (only if missing)\n"
      + "5. Create at least three functions that are called by the program:\n"
      + "\ta. main(): calls at least two other functions.\n"
      + "\tb. get_requirements(): displays the program requirements.\n"
      + "\tc. data_analysis_1(): displays the following data.\n")
#Pandas = "Python Data Analysis Library"
# Be sure to: pip install pandas-datareader
import datetime as dt
import pandas_datareader as pdr # remote data access for pandas
import matplotlib.pyplot as plt
from matplotlib import style
start = dt.datetime(2010, 1, 1)
# end = dt.datetime(2018, 10, 15)
end = dt.datetime.now() # current date and time
# for "end": "must* use Python function for current day/time
# Federal Reserve Economic Data (FRED): https://fred.stlouisfed.org/
# Categories: https://fred.stlouisfed.org/categories
# GDP = Gross Domestic Product (https://fred.stlouisfed.org/series/GDP)
# DJIA = Dow Jones Industrial Average (https://fred.stlouisfed.org/series/DJIA)
# SP500 = S&P 500 (https://fred.stlouisfed.org/series/SP500)
# Read data into Pandas DataFrame
# single series
# df=pdr.DataReader("GDP", "fred", start, end)
# multiple series

df = pdr.DataReader(["DJIA", "SP500"], "fred", start, end)

print("\nPrint number of records: ")
print(len(df))

print("\nPrint columns: ")
# Why is it important to run the following print statement ...
# To see the structure of the data
print(df.columns)


print("\nPrint data frame:")
print(df) # Note: for efficiency, only prints 60 -- not "all* records

print("\nPrint first five lines:")
# Note: "Date" is lower than the other columns as it is treated as an index
print(df.iloc[0:5,:])
# for i in range(5):
#     print(df.iloc[[i,0:3]])

print("\nPrint last five lines:")
print(df.iloc[-5:,:])

print("\nPrint first 2 lines:")
print(df.iloc[0:2,:])

print("\nPrint last 2 lines:")
print(df.iloc[-2:,:])

# Research what these styles do!
# style.use('fivethirtyeight')
# compare with ...
style.use('ggplot')
df['DJIA'].plot()
df['SP500'].plot()
plt.legend()
plt.show()