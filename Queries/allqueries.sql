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
  payee_account_id INT(11) NOT NULL,
  payer_account_id INT(11) NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  transaction_date DATE NOT NULL,
  transaction_type_id INT(11) NOT NULL,
  memo TEXT,
  posting_date DATE NOT NULL,
  isVoid TINYINT(1) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (payee_account_id) REFERENCES BI_accounts (id),
  FOREIGN KEY (payer_account_id) REFERENCES BI_accounts (id),
  FOREIGN KEY (transaction_type_id) REFERENCES BI_transaction_types (id)
)ENGINE = InnoDB;



--create a user --
INSERT INTO `BI_user` (`f_name`,`m_name`,`l_name`,`email`,`username`,`is_active`)
values([fname],IFNULL([mname],''),[lnane],[email],[username],[isactive]);

INSERT INTO `BI_password` (`user_id`,`is_active`,`password`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = [username]),1,[password]);

INSERT INTO `BI_accounts` (`user_id`,`account_type_id`,`is_active`,`current_balance`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = [username]) 
,(SELECT `id` FROM `BI_account_types` WHERE `type_name` = [userselection])
,1
,0);

--create an account 
--not sure if we want to open a new account with $0 or allow an initial deposit during account opening...
--also, date would be current date of account opening I am guessing?
INSERT INTO BI ACCOUNTS (user_id, account_type_id, is_active, current_balance, last_transaction_date)
VALUES ((SELECT id FROM BI_user WHERE username = [username]), (SELECT id FROM BI_account_types WHERE type_name = [userselection]),
1, 0, CURRENT_TIMESTAMP))


----deactivate account 

UPDATE `BI_accounts`
SET `is_active` = 0 
	WHERE `user_id` = [CUR_USER] 
	AND `account_type_id` = (SELECT `id` FROM `BI_account_types` WHERE `type_name` = [CUR_SELECTION]);
	
	----get name and stuff
SELECT `username` 
+ ' ' + (SELECT `type_name` FROM `BI_account_types` WHERE `id` = [CUR_SELECTION]) as `Account Nickname`
,`current_balance` as `Current Balance`
,`last_transaction_date` as `Last Activity Date` FROM `BI_accounts`
WHERE `user_id` = [CUR_USER] AND `account_type_id` = [CUR_SELECTION];

-- get last 5 transactions
SELECT 
	TOP 5 `payee_account_id` as `Payee`
	,`payer_account_id` as `Payer`
	,`amount` as `Amount`
	,(SELECT `transaction_type` FROM `BI_account_types`
			WHERE `id` = J.transaction_type_id) as `Transaction Type`
	,`transaction_date` as `Date`
	,`memo` as `Memo`
	FROM `BI_transactions` WHERE `payee_account_id` = [CUR_USER] 
								OR `payer_account_id` = [CUR_USER];
								
								
--transactions

--transaction queries (deposit, withdrawl, transfer, payment)

--deposit
UPDATE BI_accounts
SET current_balance = current_balance + [amount]
WHERE user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]);

INSERT INTO BI_account_transactions (payee_account_id, payer_account_id, amount, transaction_date, transaction_type_id, memo, posting_date, isVoid)
VALUES (SELECT id FROM BI_accounts WHERE 
user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]),
SELECT id FROM BI_accounts WHERE 
user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]), 
+[amount], CURRENT_TIMESTAMP, 1, [memo], CURRENT_TIMESTAMP, 0);

--withdrawl
UPDATE BI_accounts
SET current_balance = current_balance - [amount]
WHERE user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]);

INSERT INTO BI_account_transactions (payee_account_id, payer_account_id, amount, transaction_date, transaction_type_id, memo, posting_date, isVoid)
VALUES (SELECT id FROM BI_accounts WHERE 
user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]),
SELECT id FROM BI_accounts WHERE 
user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]), 
-[amount], CURRENT_TIMESTAMP, 4, [memo], CURRENT_TIMESTAMP, 0);

--transfer
UPDATE BI_accounts
SET current_balance = current_balance - [amount]
WHERE user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]);

INSERT INTO BI_account_transactions (payee_account_id, payer_account_id, amount, transaction_date, transaction_type_id, memo, posting_date, isVoid)
VALUES (SELECT id FROM BI_accounts WHERE 
user_id = [USER_SELECT] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]),
SELECT id FROM BI_accounts WHERE 
user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]), 
-[amount], CURRENT_TIMESTAMP, 3, [memo], CURRENT_TIMESTAMP, 0);

UPDATE BI_accounts
SET current_balance = current_balance + [amount]
WHERE user_id = [USER_SELECT] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]);

INSERT INTO BI_account_transactions (payee_account_id, payer_account_id, amount, transaction_date, transaction_type_id, memo, posting_date, isVoid)
VALUES (SELECT id FROM BI_accounts WHERE 
user_id = [USER_SELECT] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]),
SELECT id FROM BI_accounts WHERE 
user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]), 
+[amount], CURRENT_TIMESTAMP, 3, [memo], CURRENT_TIMESTAMP, 0);

--payment (same as transfer, except recorded as payment)
UPDATE BI_accounts
SET current_balance = current_balance - [amount]
WHERE user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]);

INSERT INTO BI_account_transactions (payee_account_id, payer_account_id, amount, transaction_date, transaction_type_id, memo, posting_date, isVoid)
VALUES (SELECT id FROM BI_accounts WHERE 
user_id = [USER_SELECT] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]),
SELECT id FROM BI_accounts WHERE 
user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]), 
-[amount], CURRENT_TIMESTAMP, 2, [memo], CURRENT_TIMESTAMP, 0);

UPDATE BI_accounts
SET current_balance = current_balance + [amount]
WHERE user_id = [USER_SELECT] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]);

INSERT INTO BI_account_transactions (payee_account_id, payer_account_id, amount, transaction_date, transaction_type_id, memo, posting_date, isVoid)
VALUES (SELECT id FROM BI_accounts WHERE 
user_id = [USER_SELECT] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]),
SELECT id FROM BI_accounts WHERE 
user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]), 
+[amount], CURRENT_TIMESTAMP, 2, [memo], CURRENT_TIMESTAMP, 0);