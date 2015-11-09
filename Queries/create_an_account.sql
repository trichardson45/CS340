--not sure if we want to open a new account with $0 or allow an initial deposit during account opening...
--also, date would be current date of account opening I am guessing?
INSERT INTO BI ACCOUNTS (user_id, account_type_id, is_active, current_balance, last_transaction_date)
VALUES ((SELECT id FROM BI_user WHERE username = [username]), (SELECT id FROM BI_account_types WHERE type_name = [userselection]),
1, 0, CURRENT_TIMESTAMP))