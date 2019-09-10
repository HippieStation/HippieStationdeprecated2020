DROP TABLE IF EXISTS `authentication`;
CREATE TABLE `authentication` (
	`ckey` VARCHAR(32) NOT NULL,
	`key` VARCHAR(32) NOT NULL,
	`last_login` CHAR(32) NOT NULL,
	PRIMARY KEY (`ckey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
