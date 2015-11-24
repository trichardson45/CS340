
-- account types 
checking -- no fees
savings -- start up fee
brokerage -- transaction fee
mortgage -- % fee

-- transaction types
deposit
withdrawal
transfer
payment

if exists ( select account_type from Bi_accounts where id = 'dasjkldas' and account_type = 'brokerage' )
	begin 
	--create 5 $ fee
	end 
	
week 7
	create test accounts/fee types/users/ etc... --matt
	Finish all queries 
			-- make deposit
			sql --Trent
			html --Trent
			-- make withdrawal
			sql --Trent
			html -- Trent
			-- pay another account 
			sql -- Trent
			html -- Trent
			-- view account summary
			sql --Matt
			html -- Matt
			-- deativate account
			sql --Matt
			html -- Matt
			-- open account
			sql done -- verify
			html -- Matt
			-- create a user
			sql done --verify
			html -- Matt
		
	start .js files -- Your own pages
	start .css files as needed -- Matt 
	outline -- Trent
	Table creation queries -- Verified w/inserts
week 9  --DUE 12/6
	Database schema -- matt
	ER diagram of Database -- matt
Connect to DB: using node
--Dynamic tables 
Make payment
	Payment to: Constant, first 4 are matt,ezra,ellie,trent (checking), mortgage account
	Payment from: add brokerage (verify fee logic)
Transfer money: 
	Transfer to & from brokerage
Make a deposit/withdrawal
	add brokerage
Close an account:
	disable buttons/make a drop down
Open an account: 
	change to drop down, deativate options that shouldnt be selected
Login:
	Create it
Logout:
	Create it
database outline
--Cheatsheet for grader:
--	Add all account info for "test users"
--	Name, account type, balance
--Assess interest rate button:
--	LAST THING TO DO, TRY TO SEPARATE

	style (optional)