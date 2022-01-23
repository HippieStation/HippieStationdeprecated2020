DROP TABLE IF EXISTS `ipstack`;
CREATE TABLE `ipstack` (
	`ip` int(10) unsigned NOT NULL,
	`country` varchar(32) NOT NULL,
	PRIMARY KEY (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
