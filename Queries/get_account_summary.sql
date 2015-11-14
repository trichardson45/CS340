--get name and stuff
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
								