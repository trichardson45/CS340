--deactivate account 

UPDATE `BI_accounts`
SET `is_active` = 0 
	WHERE `user_id` = [CUR_USER] 
	AND `account_type_id` = (SELECT `id` FROM `BI_account_types` WHERE `type_name` = [CUR_SELECTION]);