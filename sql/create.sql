CREATE TABLE `sp500` (
  `Date` date NOT NULL,
  `Open` float unsigned NOT NULL,
  `High` float unsigned NOT NULL,
  `Low` float unsigned NOT NULL,
  `Close` float unsigned NOT NULL,
  `Adj Close` float unsigned NOT NULL,
  `Volume` bigint(20) unsigned NOT NULL,
  KEY `date` (`Date`)
);
