DROP TABLE IF EXISTS `authentication`;
CREATE TABLE `authentication` (
	`ckey` VARCHAR(32) NOT NULL,
	`key` VARCHAR(32) NOT NULL,
	`last_login` CHAR(32) NOT NULL,
	`password` CHAR(60),
	`pubkey` BINARY(32),
	PRIMARY KEY (`ckey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
