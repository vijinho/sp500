--- Get ALL COLUMNS (DATE, OPEN, high, low, CLOSE, adj CLOSE, volume) FOR days FROM 1 November 2018:

SELECT * FROM sp500 WHERE DATE >= '2018-11-01' ORDER BY DATE;

---  Get min/max open, close, low and high for date range
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

SELECT
	LEFT(`Date`,10) `Date`,
	DAYNAME(`Date`) AS 'Day',
	ROUND(`Open`,2) `Open`,
	ROUND(`Close`,2) `Close`,
	CONCAT(
		ROUND(`High` - `Open`),
		'/',
		ROUND(`Open` - `Low`),
		'/',
		ROUND(`Open` - `Close`)
	) `Up/Down/Close`,
	ROUND(`High`,2) `High`,
	ROUND(`Low`,2) `Low`,
	ROUND(`High` - `Low`) `Range`
FROM sp500
WHERE `DATE` BETWEEN '2018-01-01' AND '2018-12-31'
ORDER BY `DATE` DESC;


---  Get the Top-10 days with the biggest range between high and low
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


---  Get the previous opens in a given range
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


---  Show the frequency of days per points movement
SELECT ROUND(`Close` - `Open`) AS Gain, COUNT(*) AS `Days`
FROM sp500
WHERE
`DATE` > '2007-01-01 00:00:00' AND '2018-12-31 00:00:00'
GROUP BY `Gain`
;

---  Show the range of points moved and frequency
SELECT ROUND(`High` - `Low`) AS `Range`, COUNT(*) AS `Days`
FROM sp500
WHERE
`DATE` > '2007-01-01 00:00:00' AND '2018-12-31 00:00:00'
GROUP BY `Range`
ORDER BY `Range`
;


---  Volume (billions) and year/month
SELECT
	YEAR(`date`) AS `Year`,
	LEFT(`Volume`,1) `Volume (blns)`,
	COUNT(*) AS Sessions
FROM sp500
WHERE Volume  > 7000000000
GROUP BY YEAR(`date`), LEFT(Volume, 1)
ORDER BY YEAR(`date`) DESC, `Sessions` DESC;

SELECT
	YEAR(`date`) AS `Year`,
	MONTHNAME(`date`) AS `Month`,
	ROUND(MAX(Volume / 1000000000),2) `Volume (Max)`,
	ROUND(MIN(Volume / 1000000000),2) `Volume (Min)`,
	ROUND(AVG(Volume / 1000000000),2) `Volume (Avg)`,
	COUNT(*) AS Sessions
FROM sp500
WHERE Volume  > 7000000000
GROUP BY YEAR(`Date`), MONTH(`Date`)
ORDER BY YEAR(`DATE`) DESC, `Sessions` DESC;

SELECT
	YEAR(`date`) AS `Year`,
	MONTHNAME(`date`) AS `Month`,
	ROUND(MAX(Volume / 1000000000),2) `Volume (Max)`,
	ROUND(MIN(Volume / 1000000000),2) `Volume (Min)`,
	ROUND(AVG(Volume / 1000000000),2) `Volume (Avg)`,
	COUNT(*) AS Sessions
FROM sp500
WHERE `Date` BETWEEN '2018-01-01' AND LAST_DAY(NOW())
GROUP BY YEAR(`DATE`), MONTH(`DATE`)
ORDER BY YEAR(`DATE`) DESC, MONTH(`DATE`) DESC, `Sessions` DESC;


---  Most points down from open price
SELECT LEFT(`Date`,11) AS `Date`,
	round(Low) Low,
	round(High) High,
	round(`Open`) `Open`,
	round(`Close`) `Close`,
	round(`Open` - Low) `Most Points Down`,
	round(`CLOSE` - `OPEN`) `Rise or Fall`
FROM sp500
WHERE `DATE` BETWEEN '2018-12-01' AND NOW()
ORDER BY round(`Open` - Low) DESC;


-- Corrections/Bear Markets
SELECT LEFT(`Date`,11) AS `Date`,
	round(Low) Low,
	round(High) High,
	round(`Open`) `Open`,
	round(`Close`) `Close`,
	round(`High` - `Open`) `Most Points Up`,
	round(`Open` - Low) `Most Points Down`,
	round(`CLOSE` - `OPEN`) `Rise or Fall`
FROM sp500
WHERE
`DATE` BETWEEN '2010-04-23' AND '2010-07-02'
OR `DATE` BETWEEN '2011-04-29' AND '2011-10-03'
OR `DATE` BETWEEN '2015-05-21' AND '2015-08-25'
OR `DATE` BETWEEN '2015-11-03' AND '2016-02-11'
OR `DATE` BETWEEN '2018-01-26' AND '2018-02-11'
OR `DATE` BETWEEN '2018-12-01' AND NOW()
ORDER BY `Open` - Low DESC;

--

-- get total rows
SELECT COUNT(*)
FROM sp500
WHERE  `DATE` BETWEEN '2015-05-21' AND '2015-08-25'
OR `DATE` BETWEEN '2015-11-03' AND '2016-02-11'
OR `DATE` BETWEEN '2018-01-26' AND '2018-02-11'
OR `DATE` BETWEEN '2018-12-01' AND NOW();

-- group get points down by %
SELECT
	ROUND(100 * (COUNT(*) / 162),1) '%',
	ROUND(`Open` - Low) `Points Down`,
	COUNT(*) AS Sessions,
	ROUND((`Open` - Low) * COUNT(*)) AS Score
FROM sp500
WHERE `DATE` BETWEEN '2015-05-21' AND '2015-08-25'
OR `DATE` BETWEEN '2015-11-03' AND '2016-02-11'
OR `DATE` BETWEEN '2018-01-26' AND '2018-02-11'
OR `DATE` BETWEEN '2018-12-01' AND NOW()
GROUP BY ROUND((`Open` - Low) / 10)
ORDER BY COUNT(*) DESC;

-- get total rows
SELECT COUNT(*)
FROM sp500
WHERE `DATE` BETWEEN '2007-01-01' AND NOW();

-- group get points down by %
SELECT
	ROUND(100 * (COUNT(*) / 3016),1) '%',
	ROUND(`Open` - Low) `Points Down`,
	COUNT(*) AS Sessions,
	ROUND((`Open` - Low) * COUNT(*)) AS Score
FROM sp500
WHERE  `DATE` BETWEEN '2007-01-01' AND NOW()
GROUP BY ROUND((`Open` - Low) / 10)
ORDER BY COUNT(*) DESC;


SELECT LEFT(`Date`,11) AS `Date`,
	round(Low) Low,
	round(High) High,
	round(`Open`) `Open`,
	round(`Close`) `Close`,
	round(`High` - `Open`) `Most Points Up`,
	round(`Open` - Low) `Most Points Down`,
	round(`CLOSE` - `OPEN`) `Rise or Fall`
FROM sp500
WHERE 24 <= (`Open` - Low)
AND (
`DATE` BETWEEN '2010-04-23' AND '2010-07-02'
OR `DATE` BETWEEN '2011-04-29' AND '2011-10-03'
OR `DATE` BETWEEN '2015-05-21' AND '2015-08-25'
OR `DATE` BETWEEN '2015-11-03' AND '2016-02-11'
OR `DATE` BETWEEN '2018-01-26' AND '2018-02-11'
OR `DATE` BETWEEN '2018-12-01' AND NOW()
)
ORDER BY `Open` - Low DESC;

SELECT COUNT(*)
FROM sp500
WHERE ROUND(`Open` - Low) < 10
AND (`DATE` BETWEEN '2015-05-21' AND '2015-08-25'
OR `DATE` BETWEEN '2015-11-03' AND '2016-02-11'
OR `DATE` BETWEEN '2018-01-26' AND '2018-02-11'
OR `DATE` BETWEEN '2018-12-01' AND NOW());

SELECT
	ROUND(100 * (COUNT(*) / 162),1) '%',
	FLOOR((`Open` - Low) / 10) * 10 `Points Down`,
	COUNT(*) AS Sessions,
	FLOOR((`Open` - Low) / 10) * 10 * COUNT(*) AS Score
FROM sp500
WHERE
(`DATE` BETWEEN '2015-05-21' AND '2015-08-25'
OR `DATE` BETWEEN '2015-11-03' AND '2016-02-11'
OR `DATE` BETWEEN '2018-01-26' AND '2018-02-11'
OR `DATE` BETWEEN '2018-12-01' AND NOW())
GROUP BY FLOOR((`Open` - Low) / 10)
ORDER BY FLOOR((`OPEN` - Low) / 10) DESC;
