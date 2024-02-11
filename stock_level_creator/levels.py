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



def find_duplicates(price_levels):
    """
    Returns price where the stocks open or close is perfectly touched twice
    """
    duplicates = []
    length_of_pl = len(price_levels)
    for x in range(length_of_pl):
        r = x + 1
        if r >= length_of_pl:
            break
        if price_levels[x] == price_levels[r]:
            duplicates.append(price_levels[x])

    duplicates = sorted(set(duplicates))
    return duplicates


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

# print(contents)
# print(ticker_list)
n = 0
for ticker in ticker_list:
    #can change interval to create daily, weekly, or other interval levels
    data = yf.download(ticker, start, end=end, interval='1wk')
    #unused columns
    data.drop(columns=['Adj Close', 'Volume'], inplace=True)
    # print(data)
    stock_opens = data.loc[:, 'Open'].values
    stock_closes = data.loc[:, 'Close'].values
    stock_highs = data.loc[:, 'High'].values
    stock_lows = data.loc[:, 'Low'].values

    stock_opens = np.round(stock_opens, decimals=2)
    stock_closes = np.round(stock_closes, decimals=2)
    stock_highs = np.round(stock_highs, decimals=2)
    stock_lows = np.round(stock_lows, decimals=2)

    length_of_data = len(stock_opens)
    # print(stock_opens, "\n", length_of_data)

    price_levels = []

    number_of_touches_open = make_open_touches_list(
        stock_opens, stock_closes, stock_highs, stock_lows)
    number_of_touches_close = make_close_touches_list(
        stock_opens, stock_closes, stock_highs, stock_lows)

    for i in range(len(number_of_touches_open)):
        if number_of_touches_open[i] >= preferred_touches(ticker):
            price_levels.append(stock_opens[i])

    for i in range(len(number_of_touches_close)):
        if number_of_touches_close[i] >= preferred_touches(ticker):
            price_levels.append(stock_closes[i])

    #duplicates should have higher priority over non duplicated numbers
    duplicates = find_duplicates(price_levels)

    cleaned_price_levels = np.unique(price_levels)

    threshold = preferred_threshold(ticker)

    cleaned_list = []
    length_of_cpl = len(cleaned_price_levels)
    y = 0
    while y < length_of_cpl:
        cleaned_list.append(cleaned_price_levels[y])
        j = y + 1
        # raises index until price is outside of threshold
        while j < length_of_cpl and (cleaned_price_levels[y] * (1 + threshold)) > cleaned_price_levels[j]:
            j += 1
        y = j

    #EDIT TO YOUR PREFERRED FILE NAME/ PATH!!!
    #By default, the file will be in the same path as this .py file.
    with open('stock_levels.txt', 'a') as outfile:
        outfile.write(f"\n{ticker}: threshold = {threshold * 100:.1%} | touches = placeholder:\nDuplicates:\n{duplicates}\nCleaned Array:\n{cleaned_list}\n")
        outfile.write('-' * 175 + '\n')

print(f"Done!!\nYour levels are in {dname}\\stock_levels.txt")