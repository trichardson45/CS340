DROP TABLE IF EXISTS `BI_account_transactions`;
DROP TABLE IF EXISTS `BI_accounts`;
DROP TABLE IF EXISTS `BI_password`;
DROP TABLE IF EXISTS `BI_user`;
DROP TABLE IF EXISTS `BI_account_types`;
DROP TABLE IF EXISTS `BI_account_fee`;
DROP TABLE IF EXISTS `BI_transaction_types`;


CREATE TABLE `BI_user`
(
`id` INT(11) NOT NULL AUTO_INCREMENT
,`f_name` VARCHAR(24) NOT NULL
,`m_name` VARCHAR(24) NULL
,`l_name` VARCHAR(24) NOT NULL
,`email` VARCHAR(50) NOT NULL
,`username` VARCHAR(24) NOT NULL
,`is_active` TINYINT(1) NOT NULL
,PRIMARY KEY (`id`)
,UNIQUE KEY `username` (`username`)
)ENGINE = InnoDB;


CREATE TABLE `BI_password`
(
`id` INT(11) NOT NULL AUTO_INCREMENT
,`user_id` int(11) NOT NULL
,`password` VARCHAR(24) NOT NULL
,`is_active` TINYINT(1) NOT NULL
,PRIMARY KEY (`id`)
,FOREIGN KEY (`user_id`) REFERENCES `BI_user` (`id`)
)ENGINE = InnoDB;

CREATE TABLE `BI_account_fee`
(`id` INT(11) NOT NULL AUTO_INCREMENT
,`amount` DECIMAL(10,2) NOT NULL 
,`description` VARCHAR(50) NOT NULL
,PRIMARY KEY (`id`)
)ENGINE = InnoDB; 

CREATE TABLE `BI_account_types`
(id INT(11) NOT NULL AUTO_INCREMENT
,`type_name` VARCHAR(50) NOT NULL
,`interest_rate` DECIMAL(10,4) NOT NULL
,`fee_type_id` INT(11) NULL
,PRIMARY KEY (`id`)
,FOREIGN KEY (`fee_type_id`) REFERENCES `BI_account_fee` (`id`)
)ENGINE = InnoDB; 

CREATE TABLE `BI_accounts` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) NOT NULL,
  `account_type_id` INT(11) NOT NULL,
  `is_active` TINYINT(1) NOT NULL,
  `current_balance` DECIMAL(10,2),
  `last_transaction_date` DATE NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY (`user_id`,`account_type_id`),
  FOREIGN KEY (`user_id`) REFERENCES BI_user (`id`),
  FOREIGN KEY (`account_type_id`) REFERENCES BI_account_types (`id`)
)ENGINE = InnoDB; 


CREATE TABLE `BI_transaction_types`
(`id` INT(11) NOT NULL AUTO_INCREMENT
,`transaction_type` VARCHAR(20) NOT NULL
,PRIMARY KEY (`id`)
)ENGINE = InnoDB; 

CREATE TABLE `BI_account_transactions`
(
  id INT(11) NOT NULL AUTO_INCREMENT,
  `payee_name` VARCHAR(24) NOT NULL,
  `payee_account_id` INT(11) NOT NULL,
  `payer_name` VARCHAR(24) NOT NULL,
  `payer_account_id` INT(11) NOT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `transaction_date` DATE NOT NULL,
  `transaction_type_id` INT(11) NOT NULL,
  `memo` TEXT,
  `posting_date` DATE NOT NULL,
  `isVoid` TINYINT(1) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (payee_name) REFERENCES BI_user (`username`),
  FOREIGN KEY (payee_account_id) REFERENCES BI_accounts (`id`),
  FOREIGN KEY (payer_name) REFERENCES BI_user (`username`),
  FOREIGN KEY (payer_account_id) REFERENCES BI_accounts (`id`),
  FOREIGN KEY (transaction_type_id) REFERENCES BI_transaction_types (`id`)
)ENGINE = InnoDB;