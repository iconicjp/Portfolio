#!/usr/bin/env python3

import os
import datetime as dt
import numpy as np
import yfinance as yf


# Changes current working directory to same as py file
# so watchist.txt and stock_levels.txt are in same folder
abspath = os.path.abspath(__file__)
dname = os.path.dirname(abspath)
os.chdir(dname)

#How close prices should be to be considered a 'touch'. EDIT TO YOUR LIKING!!!
RANGE_OF_TOUCH = .001
#Removes the last 4 tickers on my watchlist. EDIT/REMOVE TO YOUR LIKING!!!
TICKERS_TO_REMOVE = 4

'''REMOVE THESE LINES OR EDIT THEM TO YOUR LIKING!!!
The more touches the lesser the amount of levels and vice versa for less touches. '''
#used in preferred_touches
# touches_3 = []
# touches_4 = []
# touches_5 = []
# touches_6 = []
# touches_7 = []
# touches_8 = []
# touches_9 = []
# touches_10 = []
# touches_11 = []
# touches_12 = []

def preferred_threshold(ticker):
    """
    Returns the preferred threshold for how close line should be together
    """
    #EDIT TO YOUR LIKING!!!
    short_list = ['SPY', 'QQQ', 'IWM', 'XLE', 'XLU']
    if ticker in short_list:
        return 1 / 100
    return 3 / 100


def preferred_touches(ticker):
    """
    Returns touches needed to make price a level
    """
    # if ticker in touches_3:
    #     return 3
    # elif ticker in touches_4:
    #     return 4
    # elif ticker in touches_5:
    #     return 5
    # elif ticker in touches_6:
    #     return 6
    # elif ticker in touches_7:
    #     return 7
    # elif ticker in touches_9:
    #     return 9
    # elif ticker in touches_11:
    #     return 11
    return 4


def make_open_touches_list(stock_opens, stock_closes, stock_highs, stock_lows):
    """
    Returns list of touches corresponding to list of stock opens. This will be used to eliminate low touched values
    """
    number_of_touches = []

    for stock_open in stock_opens:
        touches = 0
        for checking_open in stock_opens:
            if checking_open >= (stock_open * (1 - RANGE_OF_TOUCH)) and checking_open <= (stock_open * (1 + RANGE_OF_TOUCH)):
                touches += 1
        for checking_close in stock_closes:
            if checking_close >= (stock_open * (1 - RANGE_OF_TOUCH)) and checking_close <= (stock_open * (1 + RANGE_OF_TOUCH)):
                touches += 1
        for checking_high in stock_highs:
            if checking_high >= (stock_open * (1 - RANGE_OF_TOUCH)) and checking_high <= (stock_open * (1 + RANGE_OF_TOUCH)):
                touches += 1
        for checking_low in stock_lows:
            if checking_low >= (stock_open * (1 - RANGE_OF_TOUCH)) and checking_low <= (stock_open * (1 + RANGE_OF_TOUCH)):
                touches += 1

        number_of_touches.append(touches)

    return number_of_touches


def make_close_touches_list(stock_opens, stock_closes, stock_highs, stock_lows):
    """
    Returns list of touches corresponding to list of stock closes. This will be used to eliminate low touched values
    """
    number_of_touches = []

    for stock_close in stock_closes:
        touches = 0
        for checking_open in stock_opens:
            if checking_open >= (stock_close * (1 - RANGE_OF_TOUCH)) and checking_open <= (stock_close * (1 + RANGE_OF_TOUCH)):
                touches += 1
        for checking_close in stock_closes:
            if checking_close >= (stock_close * (1 - RANGE_OF_TOUCH)) and checking_close <= (stock_close * (1 + RANGE_OF_TOUCH)):
                touches += 1
        for checking_high in stock_highs:
            if checking_high >= (stock_close * (1 - RANGE_OF_TOUCH)) and checking_high <= (stock_close * (1 + RANGE_OF_TOUCH)):
                touches += 1
        for checking_low in stock_lows:
            if checking_low >= (stock_close * (1 - RANGE_OF_TOUCH)) and checking_low <= (stock_close * (1 + RANGE_OF_TOUCH)):
                touches += 1

        number_of_touches.append(touches)

    return number_of_touches

#EDIT TO YOUR LIKING!!! I recommend 5 years back
start = dt.datetime(2019, 1, 1)
end = dt.datetime.now()  # current date and time
time = dt.datetime.date(end)

with open('stock_levels.txt', 'w') as outfile:
    outfile.write(f"Report generated on {time}\n{'-' * 175}\n")

ticker_list = []

#EDIT PATH TO YOUR WATCHLIST FILE
with open('watchlist.txt', 'r') as file:
    contents = file.read()

# deleting unused tickers in watchlist
contents = contents.split(sep=',')
for _ in range(TICKERS_TO_REMOVE):
    contents.pop()

for content in contents:
    content = content.split(':')[1]
    ticker_list.append(content)

for ticker in ticker_list:
    #can change interval to create daily, weekly, or other interval levels
    data = yf.download(ticker, start, end=end, interval='1wk')
    #unused columns
    data.drop(columns=['Adj Close', 'Volume'], inplace=True)
    stock_opens = data.loc[:, 'Open'].values
    stock_closes = data.loc[:, 'Close'].values
    stock_highs = data.loc[:, 'High'].values
    stock_lows = data.loc[:, 'Low'].values

    stock_opens = np.round(stock_opens, decimals=2)
    stock_closes = np.round(stock_closes, decimals=2)
    stock_highs = np.round(stock_highs, decimals=2)
    stock_lows = np.round(stock_lows, decimals=2)

    #function variables
    threshold = preferred_threshold(ticker)
    touches_required = preferred_touches(ticker)
    
    length_of_data = len(stock_opens)

    number_of_touches_open = make_open_touches_list(stock_opens, stock_closes, stock_highs, stock_lows)
    number_of_touches_close = make_close_touches_list(stock_opens, stock_closes, stock_highs, stock_lows)

    stock_data_opens = np.empty([2,length_of_data])
    stock_data_closes = np.empty([2,length_of_data])
    
    stock_data_opens[0] = number_of_touches_open
    stock_data_closes[0] = number_of_touches_close
    stock_data_opens[1] = stock_opens
    stock_data_closes[1] = stock_closes

    stock_data_all = np.concatenate((stock_data_opens, stock_data_closes), axis=1)

    sda_sort = np.argsort(stock_data_all[1])
    stock_data_sorted = stock_data_all[:,sda_sort]
    
    length_of_stock_data_sorted = len(stock_data_sorted[0])

    sda_price_list = []
    sda_touch_list = []

    for i in range(length_of_stock_data_sorted):
        if stock_data_sorted[0][i] >= touches_required:
            sda_touch_list.append(stock_data_sorted[0][i])
            sda_price_list.append(stock_data_sorted[1][i])
    
    cleaned_array = np.vstack((sda_touch_list, sda_price_list))

    final_list = []

    length_of_cleaned_array = len(cleaned_array[0])

    max_touches = int(np.max(cleaned_array[0]))

    for y in range(max_touches, touches_required - 1, -1):
        for x in range(length_of_cleaned_array):
            if cleaned_array[0][x] == y:
                add_to_final = True
                if final_list:
                    for z in range(len(final_list)):
                        if (final_list[z] * (1 - threshold)) <= cleaned_array[1][x] <= (final_list[z] * (1 + threshold)):
                            add_to_final = False
                            break
                if add_to_final:
                    final_list.append(cleaned_array[1][x])

    final_list.sort()

    #EDIT TO YOUR PREFERRED FILE NAME & PATH!!!
    #By default, the file will be in the same path as this .py file.
    with open('stock_levels.txt', 'a') as outfile:
        outfile.write(f"{ticker}: threshold = {threshold:.1%} | touches = {touches_required}:\n{final_list}\n")
        outfile.write('-' * 175 + '\n')

print(f"Done!!\nYour levels are in {dname}\\stock_levels.txt")