CREATE TABLE `sp500` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Date` datetime NOT NULL,
  `Open` float unsigned NOT NULL,
  `High` float unsigned NOT NULL,
  `Low` float unsigned NOT NULL,
  `Close` float unsigned NOT NULL,
  `Adj Close` float unsigned NOT NULL,
  `Volume` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=ascii;
