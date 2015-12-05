var express = require('express');
var bodyParser = require('body-parser');
var mysql = require('./db_connection.js');

var app = express();
var handlebars = require('express-handlebars').create({defaultLayout: 'main'});

app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());
app.engine('handlebars', handlebars.engine);
app.set('view engine', 'handlebars');
app.set('port', 3000);
app.use(express.static('public')); //css styling of the page

//using trent for debugging/testing #removelater
var currentUser = '';
var curId = 0;
var curPW = '';
app.get('/', function (req, res, next) {
    var context = {};
    //var params = [];
    // for(var p in req.query)
    //{
    //    params.push({'name': p, 'value': req.query[p]});
    //    console.log(p);
    // }
    if (req.query.password1 != null && req.query.password1 != '') {
        if (req.query.password1 == req.query.password2) {
            var newquery2 = '';

            var newquery = "INSERT INTO `BI_user` (`f_name`,`m_name`,`l_name`,`email`,`username`,`is_active`)";
            newquery += " values('" + req.query.fname + "', '" + req.query.mname + "', '";
            newquery += req.query.lname + "', '" + req.query.ename + "', '" + req.query.uname + "', 1);";
            console.log(newquery);
            mysql.pool.query(newquery, function (err) {
                if (err) {
                    next(err);
                    return;
                }
                newquery2 += "INSERT INTO `BI_password` (`user_id`,`is_active`,`password`)"
                newquery2 += "VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = '" + req.query.uname + "')";
                newquery2 += ",1,'" + req.query.password1 + "');";
                console.log(newquery2);
                mysql.pool.query(newquery2, function (err) {
                    if (err) {
                        next(err);
                        return;
                    }
                })
                context.loggedInUser = currentUser;
                res.render('main_page', context);
            });
        }
    } else if (req.query.accountType != null && req.query.accountType != '') {
        var newquery3 = "INSERT INTO `BI_accounts` (`user_id`,`account_type_id`,`is_active`,`current_balance`,`last_transaction_date`)";
        newquery3 += "VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = '" + currentUser + "'),";
        newquery3 += "(SELECT `id` FROM `BI_account_types` WHERE `type_name` = '" + req.query.accountType + "'),1,0,CURRENT_TIMESTAMP);";
        console.log(newquery3);
        mysql.pool.query(newquery3, function (err, rows) {
            if (err) {
                next(err);
            }
            context.loggedInUser = currentUser;
            res.render('main_page', context);

        })
        /*{ [Error: ER_DUP_ENTRY: Duplicate entry '1-1' for key 'user_id'] code: 'ER_DUP_ENTRY', errno: 1062, sqlState: '23000', index: 0 }
         */
    } else if (req.query.closeAccountType != null && req.query.closeAccountType != '') {
        var newquery4 = "DELETE FROM BI_accounts WHERE user_id = (SELECT id FROM BI_user WHERE username = ";
        newquery4 += "'" + String(currentUser) + "') AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name ";
        newquery4 += "= '" + req.query.closeAccountType + "');";

        console.log(newquery4);
        mysql.pool.query(newquery4, function (err, rows) {
            if (err) {
                next(err);
                return;
            }
            if (rows.length == 0) {
                context.error = "That entry is invalid";
                res.render('error', context);
            }
            else {
                context.loggedInUser = currentUser;
                res.render('main_page', context);
            }
        })

    } else if (req.query.passwordLogins != null && req.query.usernameLogins != null && req.query.passwordLogins != '' && req.query.usernameLogins != '') {
        currentUser = req.query.usernameLogins;
        var newquery4 = "select * from BI_user WHERE `username` ='" + currentUser + "' ;";
        mysql.pool.query(newquery4, function (err, rows) {
            if (err) {
                next(err);
                return;
            }
            if (rows != [] && rows != 0 && rows.length != 0) {
                curId = rows[0].id;
                currentUser = rows[0].username;
            }
            var pw = req.query.passwordLogins;
            var newquery5 = "select * from BI_password where `user_id`=" + curId + " and `password` ='" + pw + "';";
            mysql.pool.query(newquery5, function (err, rows) {
                if (err) {
                    next(err);
                    return;
                }
                if (rows.length == 0) {
                    currentUser = '';
                    context.error = "You have entered an incorrect user or password";
                    res.render('error', context);
                }
                else {
                    context.loggedInUser = currentUser;
                    res.render('main_page', context);
                }
            })
        })

    } else if (req.query.depositAmt != 0 && req.query.depositAmt != '' && req.query.depositAmt != null) {
        var errorcheck = "SELECT `id` FROM BI_account_types WHERE `type_name` ='" + req.query.dep_account_type + "';";
        mysql.pool.query(errorcheck, function (err, rows) {
            if (err) {
                next(err);
                return;
            }
            var actId = rows.id;
            var newquery6 = "UPDATE BI_accounts SET `current_balance` = `current_balance` + " + String(req.query.depositAmt) + " WHERE `user_id` =" + curId + " AND `account_type_id`=";
            newquery6 += String(actId)+";";
            console.log(newquery6);
            mysql.pool.query(newquery6, function (err, rows) {
                if (err) {
                    next(err);
                    return;
                }
                var newquery7 = "INSERT INTO BI_account_transactions (`payee_account_id`, `payee_name`, `payer_account_id`, `payer_name`, `amount`, `transaction_date`, `transaction_type_id`, `memo`, `posting_date`, `isVoid`)";
                newquery7 += " VALUES ((SELECT `id` FROM BI_accounts WHERE `user_id` =" + curId + " AND `account_type_id` = (SELECT `id` FROM BI_account_types WHERE `type_name` ='" + req.query.dep_account_type + "')),";
                newquery7 += " (SELECT `username` FROM BI_user WHERE `id` =" + curId + "),";
                newquery7 += " (SELECT `id` FROM BI_accounts WHERE `user_id` = " + curId + " AND `account_type_id` = (SELECT `id` FROM BI_account_types WHERE `type_name` ='" + req.query.dep_account_type + "')),";
                newquery7 += " (SELECT `username` FROM BI_user WHERE `id` =" + curId + "),";
                newquery7 += " " + String(req.query.depositAmt) + ", CURRENT_TIMESTAMP, 1, 'DEPOSIT', CURRENT_TIMESTAMP, 0);";
                console.log(newquery7);
                mysql.pool.query(newquery7, function (err, rows) {
                    if (err) {
                        next(err);
                        return;
                    }
                    context.loggedInUser = currentUser;
                    res.render('main_page', context);
                })
            })

        })


    } else if (req.query.withdrawlAmt != 0 && req.query.withdrawlAmt != '' && req.query.withdrawlAmt != null) {
        var newquery8 = "UPDATE BI_accounts SET `current_balance` = `current_balance` - " + String(req.query.withdrawlAmt) + " WHERE `user_id` =" + curId + " AND `account_type_id`=";
        newquery8 += "(SELECT `id` FROM BI_account_types WHERE `type_name` ='" + req.query.with_account_type + "')";
        console.log(newquery8);
        mysql.pool.query(newquery8, function (err, rows) {
            if (err) {
                next(err);
                return;
            }
            var newquery9 = "INSERT INTO BI_account_transactions (`payee_account_id`, `payee_name`, `payer_account_id`, `payer_name`, `amount`, `transaction_date`, `transaction_type_id`, `memo`, `posting_date`, `isVoid`)";
            newquery9 += " VALUES ((SELECT `id` FROM BI_accounts WHERE `user_id` =" + curId + " AND `account_type_id` = (SELECT `id` FROM BI_account_types WHERE `type_name` ='" + req.query.with_account_type + "')),";
            newquery9 += " (SELECT `username` FROM BI_user WHERE `id` =" + curId + "),";
            newquery9 += " (SELECT `id` FROM BI_accounts WHERE `user_id` = " + curId + " AND `account_type_id` = (SELECT `id` FROM BI_account_types WHERE `type_name` ='" + req.query.with_account_type + "')),";
            newquery9 += " (SELECT `username` FROM BI_user WHERE `id` =" + curId + "),";
            newquery9 += " " - String(req.query.withdrawlAmt) + ", CURRENT_TIMESTAMP, 4, 'WITHDRAWL', CURRENT_TIMESTAMP, 0);";
            console.log(newquery9);
            mysql.pool.query(newquery9, function (err, rows) {
                if (err) {
                    next(err);
                    return;
                }
            })
        })
        if (rows.length == 0) {
            context.error = "You do not have that type of account";
            res.render('error', context);
        }
        else {
            context.loggedInUser = currentUser;
            res.render('main_page', context);
        }

    } else if (req.query.paymentAmt != 0 && req.query.paymentAmt != '' && req.query.paymentAmt != null) {
        var newquery10 = "UPDATE BI_accounts SET `current_balance` = `current_balance` - " + String(req.query.paymentAmt) + " WHERE `user_id` =" + curId + " AND `account_type_id`=";
        newquery10 += "(SELECT `id` FROM BI_account_types WHERE `type_name` ='" + req.query.payment_from + "')";
        console.log(newquery10);
        mysql.pool.query(newquery10, function (err, rows) {
            if (err) {
                next(err);
                return;
            }
            var newquery11 = "INSERT INTO BI_account_transactions (`payee_account_id`, `payee_name`, `payer_account_id`, `payer_name`, `amount`, `transaction_date`, `transaction_type_id`, `memo`, `posting_date`, `isVoid`)";
            newquery11 += " VALUES (((SELECT `id` FROM BI_accounts WHERE `user_id` = (SELECT `id` from BI_user WHERE `username` ='" + req.query.payment_to + "') AND `account_type_id` = (SELECT `id` FROM BI_account_types WHERE `type_name` ='Checking'))),";
            newquery11 += " (SELECT `username` FROM BI_user WHERE `username` ='" + req.query.payment_to + "'),";
            newquery11 += " (SELECT `id` FROM BI_accounts WHERE `user_id` = " + curId + " AND `account_type_id` = (SELECT `id` FROM BI_account_types WHERE `type_name` ='" + req.query.payment_from + "')),";
            newquery11 += " (SELECT `username` FROM BI_user WHERE `id` =" + curId + "),";
            newquery11 += " " - String(req.query.paymentAmt) + ", CURRENT_TIMESTAMP, 2, 'PAYMENT', CURRENT_TIMESTAMP, 0);";
            console.log(newquery11);
            mysql.pool.query(newquery11, function (err, rows) {
                if (err) {
                    next(err);
                    return;
                }
            })
        })
        var newquery12 = "UPDATE BI_accounts SET `current_balance` = `current_balance` + " + String(req.query.paymentAmt) + " WHERE `user_id` = (SELECT `id` FROM BI_user WHERE `username` = '" + req.query.payment_to + "')";
        newquery12 += " AND `account_type_id`= (SELECT `id` FROM BI_account_types WHERE `type_name` ='Checking')";
        console.log(newquery12);
        mysql.pool.query(newquery12, function (err, rows) {
            if (err) {
                next(err);
                return;
            }
            var newquery13 = "INSERT INTO BI_account_transactions (`payee_account_id`, `payee_name`, `payer_account_id`, `payer_name`, `amount`, `transaction_date`, `transaction_type_id`, `memo`, `posting_date`, `isVoid`)";
            newquery13 += " VALUES (((SELECT `id` FROM BI_accounts WHERE `user_id` = (SELECT `id` from BI_user WHERE `username` ='" + req.query.payment_to + "') AND `account_type_id` = (SELECT `id` FROM BI_account_types WHERE `type_name` ='Checking'))),";
            newquery13 += " (SELECT `username` FROM BI_user WHERE `username` ='" + req.query.payment_to + "'),";
            newquery13 += " (SELECT `id` FROM BI_accounts WHERE `user_id` = " + curId + " AND `account_type_id` = (SELECT `id` FROM BI_account_types WHERE `type_name` ='" + req.query.payment_from + "')),";
            newquery13 += " (SELECT `username` FROM BI_user WHERE `id` =" + curId + "),";
            newquery13 += " " + String(req.query.paymentAmt) + ", CURRENT_TIMESTAMP, 2, 'PAYMENT', CURRENT_TIMESTAMP, 0);";
            console.log(newquery13);
            mysql.pool.query(newquery13, function (err, rows) {
                if (err) {
                    next(err);
                    return;
                }
            })
        })
        if (rows.length == 0) {
            context.error = "You do not have that type of account";
            res.render('error', context);
        }
        else {
            context.loggedInUser = currentUser;
            res.render('main_page', context);
        }

    } else if (req.query.transferAmt != 0 && req.query.transferAmt != '' && req.query.transferAmt != null) {
        var newquery14 = "UPDATE BI_accounts SET `current_balance` = `current_balance` - " + String(req.query.transferAmt) + " WHERE `user_id` =" + curId + " AND `account_type_id`=";
        newquery14 += "(SELECT `id` FROM BI_account_types WHERE `type_name` ='" + req.query.transfer_from + "')";
        console.log(newquery14);
        mysql.pool.query(newquery14, function (err, rows) {
            if (err) {
                next(err);
                return;
            }
            var newquery15 = "INSERT INTO BI_account_transactions (`payee_account_id`, `payee_name`, `payer_account_id`, `payer_name`, `amount`, `transaction_date`, `transaction_type_id`, `memo`, `posting_date`, `isVoid`)";
            newquery15 += " VALUES ((SELECT `id` FROM BI_accounts WHERE `user_id` =" + curId + " AND `account_type_id` = (SELECT `id` FROM BI_account_types WHERE `type_name` ='" + req.query.transfer_to + "')),";
            newquery15 += " (SELECT `username` FROM BI_user WHERE `id` =" + curId + "),";
            newquery15 += " (SELECT `id` FROM BI_accounts WHERE `user_id` = " + curId + " AND `account_type_id` = (SELECT `id` FROM BI_account_types WHERE `type_name` ='" + req.query.transfer_from + "')),";
            newquery15 += " (SELECT `username` FROM BI_user WHERE `id` =" + curId + "),";
            newquery15 += " " - String(req.query.transferAmt) + ", CURRENT_TIMESTAMP, 3, 'TRANSFER', CURRENT_TIMESTAMP, 0);";
            console.log(newquery15);
            mysql.pool.query(newquery15, function (err, rows) {
                if (err) {
                    next(err);
                    return;
                }
            })
        })
        var newquery16 = "UPDATE BI_accounts SET `current_balance` = `current_balance` + " + String(req.query.transferAmt) + " WHERE `user_id` =" + curId + " AND `account_type_id`=";
        newquery16 += "(SELECT `id` FROM BI_account_types WHERE `type_name` ='" + req.query.transfer_to + "')";
        console.log(newquery16);
        mysql.pool.query(newquery16, function (err, rows) {
            if (err) {
                next(err);
                return;
            }
            var newquery17 = "INSERT INTO BI_account_transactions (`payee_account_id`, `payee_name`, `payer_account_id`, `payer_name`, `amount`, `transaction_date`, `transaction_type_id`, `memo`, `posting_date`, `isVoid`)";
            newquery17 += " VALUES ((SELECT `id` FROM BI_accounts WHERE `user_id` =" + curId + " AND `account_type_id` = (SELECT `id` FROM BI_account_types WHERE `type_name` ='" + req.query.transfer_to + "')),";
            newquery17 += " (SELECT `username` FROM BI_user WHERE `id` =" + curId + "),";
            newquery17 += " (SELECT `id` FROM BI_accounts WHERE `user_id` = " + curId + " AND `account_type_id` = (SELECT `id` FROM BI_account_types WHERE `type_name` ='" + req.query.transfer_from + "')),";
            newquery17 += " (SELECT `username` FROM BI_user WHERE `id` =" + curId + "),";
            newquery17 += " " + String(req.query.transferAmt) + ", CURRENT_TIMESTAMP, 3, 'TRANSFER', CURRENT_TIMESTAMP, 0);";
            console.log(newquery17);
            mysql.pool.query(newquery17, function (err, rows) {
                if (err) {
                    next(err);
                    return;
                }
            })
        })
        if (rows.length == 0) {
            context.error = "You do not have that type of account";
            res.render('error', context);
        }
        else {
            context.loggedInUser = currentUser;
            res.render('main_page', context);
        }

    } else mysql.pool.query('SELECT * FROM BI_accounts', function (err, rows, fields) {
        if (err) {
            next(err);
            return;
        }

        context.loggedInUser = currentUser;
        res.render('main_page', context);
    });
});

app.use(function (req, res) {
    res.status(404);
    res.render('404');
});

app.use(function (err, req, res, next) {
    var context = {};
    context.errCode = 'Cannot deposit/withdraw/transfer money to/from an account that doesn\'t exist';
    var s = String(err.stack).split('(');
    console.log(s[0]);
    if (s[0].search("Error: ER_BAD_NULL_ERROR: Column 'payee_account_id' cannot be null") != -1) {
        context.errCode = 'Cannot deposit/withdraw/transfer money to/from an account that doesn\'t exist';
        res.render('500', context);
    }
    else if (s[0].search("Error: ER_DUP_ENTRY: Duplicate entry") != -1) {
        context.errCode = 'This would be a duplicate entry which is not allowed';
        res.render('500', context)
    }

    else {
        res.status(500);
        res.render('500', context);
    }
});

app.listen(app.get('port'), function () {
    console.log('Express started on http://localhost:' + app.get('port') + '; press Ctrl-C to terminate.');
});
