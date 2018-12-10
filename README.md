# Daily S&P500 Data (CSV/MySQL/sqlite)

> I heartily welcome patches to update this data or any gifts if you appreciate it, e.g. a postcard  -- vijay@yoyo.org

## Introduction

This is a raw set of imported [daily S&P500 CSV data from Yahoo Finance](https://finance.yahoo.com/quote/%5EGSPC/history?guccounter=1) converted to MySQL and sqlite formats.  The data is daily open, close, high, low and volume since 11, December 1950.

### Why?

I wanted to fetch the S&P500 historical data for my reference.

## Updating (for 2018-12-10 & future)

1. Get the latest CSV file of results from Yahoo!
2. Put the file in the folder 'csv', overwriting `sp500.csv`
3. In *phpMyAdmin* use the import feature to import the CSV file to the database
4. Convert the date column to a proper date and the encoding to ASCII and table format to 'ARCHIVE'
5. Export the data file

## Updating the sqlite database/converting between databases

Go to [rebasedata.com/convert-mysql-to-sqlite-online](https://www.rebasedata.com/convert-mysql-to-sqlite-online) for instructions on how to easily convert the data between various DBMSs.  This is how it was done originally:

```
curl -F files[]=@sp500.sql 'https://www.rebasedata.com/api/v1/convert?outputFormat=sqlite&errorResponse=zip' -o sp500.sqlite.zip
unzip sp500.sqlite.zip && mv data.sqlite sp500.sqlite && rm sp500.sqlite.zip
```
For convenience, this is in the shell script `sql/dbconvert.sh`

## Example Queries

Refer to `sql/queries/` and feel free to send any other queries with a github pull request.

## Simple Example

e.g. Get all columns (date, open, high, low, close, adj close, volume) for days from 1 November 2018:

```
select * from sp500 where date >= '2018-11-01' order by date;
```

## Complicated Example

### Get min/max open, close, low and high for date range

```
select min(Low) Lowest, max(High) Highest, min(Open), max(Open), min(Close), max(Close)
from sp500 where date >= '2018-11-01'  and date < '2018-12-01';
```

--
