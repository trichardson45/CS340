INSERT INTO `BI_user` (`f_name`,`m_name`,`l_name`,`email`,`username`,`is_active`)
values([fname],IFNULL([mname],''),[lnane],[email],[username],[isactive]);

INSERT INTO `BI_password` (`user_id`,`is_active`,`password`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = [username]),1,[password]);

INSERT INTO `BI_accounts` (`user_id`,`account_type_id`,`is_active`,`current_balance`)
VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = [username]) 
,(SELECT `id` FROM `BI_account_types` WHERE `type_name` = [userselection])
,1
,0);