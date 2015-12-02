TRUNCATE TABLE `BI_account_transactions`;
TRUNCATE TABLE `BI_accounts`;
TRUNCATE TABLE `BI_password`;
TRUNCATE TABLE `BI_user`;
TRUNCATE TABLE `BI_account_types`;
TRUNCATE TABLE `BI_account_fee`;
TRUNCATE TABLE `BI_transaction_types`;

INSERT INTO `BI_account_fee` (`amount`,`description`)
VALUES ('25','Start new account'), ('5','Transfer to savings'), ('2.5','Stock Transfer Fee')
,('1.5','Mortgage Payment Interest');


INSERT INTO `BI_account_types` (`type_name`,`interest_rate`,`fee_type_id`)
VALUES 
 ('Checking',1.1, NULL)
,('Savings',1.3,(SELECT `id` from `BI_account_fee` WHERE `description` = 'Start new account'))
,('Mortgage',0,(SELECT `id` from `BI_account_fee` WHERE `description` = 'Mortgage Payment Interest'))
,('Brokerage',2.5,(SELECT `id` from `BI_account_fee` WHERE `description` = 'Stock Transfer Fee'));


INSERT INTO `BI_transaction_types` (`transaction_type`)
VALUES ('Deposit'),('Payment'),('Transfer'),('Withdrawal');


INSERT INTO `BI_user` (`f_name`,`m_name`,`l_name`,`email`,`username`,`is_active`)
values('Matt','S','Monroe','monroema@oregonstate.edu','monroema',1);

INSERT INTO `BI_password` (`user_id`,`is_active`,`password`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = 'monroema'),1,'1234');

INSERT INTO `BI_accounts` (`user_id`,`account_type_id`,`is_active`,`current_balance`,`last_transaction_date`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = 'monroema') 
,(SELECT `id` FROM `BI_account_types` WHERE `type_name` = 'Checking')
,1,1000,CURRENT_TIMESTAMP);


INSERT INTO `BI_user` (`f_name`,`m_name`,`l_name`,`email`,`username`,`is_active`)
values('Ezra','J','Monroe','monroeez@oregonstate.edu','monroeez',1);

INSERT INTO `BI_password` (`user_id`,`is_active`,`password`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = 'monroeez'),1,'1234');

INSERT INTO `BI_accounts` (`user_id`,`account_type_id`,`is_active`,`current_balance`,`last_transaction_date`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = 'monroeez') 
,(SELECT `id` FROM `BI_account_types` WHERE `type_name` = 'Savings')
,1 ,1000 ,CURRENT_TIMESTAMP);


INSERT INTO `BI_user` (`f_name`,`m_name`,`l_name`,`email`,`username`,`is_active`)
values('Ellie','N','Monroe','monroedn@oregonstate.edu','monroedn',1);

INSERT INTO `BI_password` (`user_id`,`is_active`,`password`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = 'monroedn'),1,'1234');

INSERT INTO `BI_accounts` (`user_id`,`account_type_id`,`is_active`,`current_balance`,`last_transaction_date`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = 'monroedn') 
,(SELECT `id` FROM `BI_account_types` WHERE `type_name` = 'Mortgage')
,1
,100000
,CURRENT_TIMESTAMP);


INSERT INTO `BI_user` (`f_name`,`m_name`,`l_name`,`email`,`username`,`is_active`)
values('Trent','','Richardson','richardstr@oregonstate.edu','richardstr',1);

INSERT INTO `BI_password` (`user_id`,`is_active`,`password`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = 'richardstr'),1,'1234');

INSERT INTO `BI_accounts` (`user_id`,`account_type_id`,`is_active`,`current_balance`,`last_transaction_date`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = 'richardstr') 
,(SELECT `id` FROM `BI_account_types` WHERE `type_name` = 'Checking')
,1
,100000
,CURRENT_TIMESTAMP);

INSERT INTO `BI_accounts` (`user_id`,`account_type_id`,`is_active`,`current_balance`,`last_transaction_date`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = 'richardstr') 
,(SELECT `id` FROM `BI_account_types` WHERE `type_name` = 'Brokerage')
,1
,200000
,CURRENT_TIMESTAMP);

INSERT INTO `BI_accounts` (`user_id`,`account_type_id`,`is_active`,`current_balance`,`last_transaction_date`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = 'richardstr') 
,(SELECT `id` FROM `BI_account_types` WHERE `type_name` = 'Savings')
,1
,10000000
,CURRENT_TIMESTAMP);

INSERT INTO `BI_accounts` (`user_id`,`account_type_id`,`is_active`,`current_balance`,`last_transaction_date`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = 'richardstr') 
,(SELECT `id` FROM `BI_account_types` WHERE `type_name` = 'Mortgage')
,1
,900000
,CURRENT_TIMESTAMP);

INSERT INTO `BI_user` (`f_name`,`m_name`,`l_name`,`email`,`username`,`is_active`)
values('Jack','','Daniels','jack@jackdaniels.com','jack_daniels',1);

INSERT INTO `BI_password` (`user_id`,`is_active`,`password`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = 'jack_daniels'),1,'1234');

INSERT INTO `BI_accounts` (`user_id`,`account_type_id`,`is_active`,`current_balance`,`last_transaction_date`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = 'jack_daniels') 
,(SELECT `id` FROM `BI_account_types` WHERE `type_name` = 'Checking')
,1
,0
,CURRENT_TIMESTAMP);

INSERT INTO `BI_user` (`f_name`,`m_name`,`l_name`,`email`,`username`,`is_active`)
values('Sierra','','Nevada','beer@sierranevada.com','sierra_nevada',1);

INSERT INTO `BI_password` (`user_id`,`is_active`,`password`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = 'sierra_nevada'),1,'1234');

INSERT INTO `BI_accounts` (`user_id`,`account_type_id`,`is_active`,`current_balance`,`last_transaction_date`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = 'sierra_nevada') 
,(SELECT `id` FROM `BI_account_types` WHERE `type_name` = 'Checking')
,1
,0
,CURRENT_TIMESTAMP);

INSERT INTO `BI_user` (`f_name`,`m_name`,`l_name`,`email`,`username`,`is_active`)
values('Quicken','','Loans','loans@quickenloans.com','quicken_loans',1);

INSERT INTO `BI_password` (`user_id`,`is_active`,`password`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = 'quicken_loans'),1,'1234');

INSERT INTO `BI_accounts` (`user_id`,`account_type_id`,`is_active`,`current_balance`,`last_transaction_date`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = 'quicken_loans') 
,(SELECT `id` FROM `BI_account_types` WHERE `type_name` = 'Checking')
,1
,0
,CURRENT_TIMESTAMP);

INSERT INTO `BI_user` (`f_name`,`m_name`,`l_name`,`email`,`username`,`is_active`)
values('Xcel','','Energy','energy@xcelenergy.com','xcel_energy',1);

INSERT INTO `BI_password` (`user_id`,`is_active`,`password`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = 'xcel_energy'),1,'1234');

INSERT INTO `BI_accounts` (`user_id`,`account_type_id`,`is_active`,`current_balance`,`last_transaction_date`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = 'xcel_energy') 
,(SELECT `id` FROM `BI_account_types` WHERE `type_name` = 'Checking')
,1
,0
,CURRENT_TIMESTAMP);

INSERT INTO `BI_user` (`f_name`,`m_name`,`l_name`,`email`,`username`,`is_active`)
values('Chase','','Bank','chase@chasebank.com','chase_bank',1);

INSERT INTO `BI_password` (`user_id`,`is_active`,`password`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = 'chase_bank'),1,'1234');

INSERT INTO `BI_accounts` (`user_id`,`account_type_id`,`is_active`,`current_balance`,`last_transaction_date`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = 'chase_bank') 
,(SELECT `id` FROM `BI_account_types` WHERE `type_name` = 'Checking')
,1
,0
,CURRENT_TIMESTAMP);