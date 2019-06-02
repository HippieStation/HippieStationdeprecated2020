CREATE TABLE `antag_tickets` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`ckey` varchar(32) NOT NULL,
	`creator` varchar(32) NOT NULL,
	`antag_type` varchar(32) NOT NULL,
	`desc` VARCHAR(2048) NOT NULL,
	`amount` smallint(4) UNSIGNED NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
