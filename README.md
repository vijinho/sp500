# Daily S&P500 Data (CSV/MySQL/sqlite)

> I heartily welcome patches to update this data or any gifts if you appreciate it, e.g. a postcard  -- vijay@yoyo.org

## Introduction

This is a raw set of imported [daily S&P500 CSV data from Yahoo Finance](https://finance.yahoo.com/quote/%5EGSPC/history?guccounter=1) converted to MySQL and sqlite formats.  The data is daily open, close, high, low and volume since 3, January 1950.

### Why?

I wanted to fetch the S&P500 historical data for my reference.

## Updating

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
SELECT 
	ROUND(MIN(Low)) Lowest, 
	ROUND(MAX(High)) Highest, 
	ROUND(MIN(`Open`)) `Open Min`, 
	ROUND(MIN(`Close`)) `Close Min`, 
	ROUND(MAX(`Open`)) `Open Max`, 
	ROUND(MAX(`Close`)) `Close Max`,
	ROUND(AVG(`Open`)) `Open Avg`, 
	ROUND(AVG(`Close`)) `Close Avg`
FROM sp500 
WHERE 
DATE BETWEEN '2018-01-01' AND '2018-12-01';
```

### Get the Top-10 days with the biggest range between high and low

```
SELECT LEFT(`Date`,11) AS `Date`, 
	round(Volume / 1000000) Volume, 
	round(Low) Low, 
	round(High) High, 
	round(`Open`) `Open`, 
	round(`Close`) `Close`, 
	round(High - Low) `Range`, 
	round(High - `Open`) Max_Up, 
	round(`Open` - Low) Max_Down, 
	round(`Close` - `Open`) Rise_Fall
FROM sp500 
WHERE `Date` >= '2010-01-01'
ORDER BY `Date` DESC
LIMIT 10;
```

### Get the previous opens in a given range

```
SELECT LEFT(`Date`,11) AS `Date`, 
	round(Low) Low, 
	round(High) High, 
	round(`Open`) `Open`, 
	round(`Close`) `Close`, 
	round(High - Low) `Range`, 
	round(High - `Open`) Max_Up, 
	round(`Open` - Low) Max_Down, 
	round(`Close` - `Open`) Rise_Fall
FROM sp500
WHERE `Open` BETWEEN 2605 AND 2645
ORDER BY `Open` DESC;
```

### Show the frequency of days per points movement

```
SELECT ROUND(`Close` - `Open`) AS Gain, COUNT(*) AS `Days`
FROM sp500
WHERE 
`DATE` > '2007-01-01 00:00:00' AND '2018-12-31 00:00:00'
GROUP BY `Gain`
;
```

### Show the range of points moved and frequency

```
SELECT ROUND(`High` - `Low`) AS `Range`, COUNT(*) AS `Days`
FROM sp500
WHERE 
`DATE` > '2007-01-01 00:00:00' AND '2018-12-31 00:00:00'
GROUP BY `Range`
ORDER BY `Range`
;
```

--
