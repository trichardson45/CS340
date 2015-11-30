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
                res.render('main_page', context);
            });
        }
    } else if (req.query.accountType != null && req.query.accountType != '') {
        var newquery3 = "INSERT INTO `BI_accounts` (`user_id`,`account_type_id`,`is_active`,`current_balance`,`last_transaction_date`)";
        newquery3 += "VALUES ((SELECT `id` FROM `BI_user` WHERE `username` = '" + currentUser + "'),";
        newquery3 += "(SELECT `id` FROM `BI_account_types` WHERE `type_name` = '" + req.query.accountType + "'),1,0,CURRENT_TIMESTAMP);";
        console.log(newquery3);
        mysql.pool.query(newquery3, function (err) {
            if (err) {
                next(err);
                return;
            }
        })
        res.render('main_page', context);
    } else if (req.query.passwordLogins != null && req.query.usernameLogins != null && req.query.passwordLogins != '' && req.query.usernameLogins != '') {
        currentUser = req.query.usernameLogins;
        var newquery4 = "select * from BI_user WHERE `username` ='" + currentUser + "' ;";
        mysql.pool.query(newquery4, function (err, rows) {
            if (err) {
                next(err);
                return;
            }
            console.log(rows);
            console.log(newquery4);
            curId = rows[0].id;
            var curUser = rows[0].username;
            var pw = req.query.passwordLogins;
            var newquery5 = "select * from BI_password where `user_id`=" + curId + " and `password` ='" + pw + "';";
            mysql.pool.query(newquery5, function (err, rows) {
                if (err) {
                    next(err);
                    return;
                }
                if (rows.length == 0) {
                    context.error = "You have entered an incorrect user or password";
                    res.render('error', context);
                }
                else {
                    context.loggedInUser = curUser;
                    res.render('main_page', context);
                }
            })
        })

    } else if (req.query.depositAmt != 0 && req.query.depositAmt != '' && req.query.depositAmt != null) {
        var newquery6 = "UPDATE BI_accounts SET `current_balance` = `current_balance` + " + String(req.query.depositAmt) + " WHERE `user_id` =" + curId + " AND `account_type_id`=";
        newquery6 += "(SELECT `id` FROM BI_account_types WHERE `type_name` ='" + req.query.dep_account_type + "');";
        console.log(newquery6);
        mysql.pool.query(newquery6, function (err, rows) {
            if (err) {
                next(err);
                return;
            }
            var newquery7 = "INSERT INTO BI_account_transactions (`payee_account_id`, `payer_account_id`, `amount`, `transaction_date`, `transaction_type_id`, `memo`, `posting_date`, `isVoid`)";
            newquery7 += " VALUES ((SELECT `id` FROM BI_accounts WHERE `user_id` =" + curId + " AND `account_type_id` = (SELECT `id` FROM BI_account_types WHERE `type_name` ='" + req.query.dep_account_type + "')),";
            newquery7 += " (SELECT `id` FROM BI_accounts WHERE `user_id` = " + curId + " AND `account_type_id` = (SELECT `id` FROM BI_account_types WHERE `type_name` ='" + req.query.dep_account_type + "')),";
            newquery7 += " " + String(req.query.depositAmt) + ", CURRENT_TIMESTAMP, 1, 'DEPOSIT', CURRENT_TIMESTAMP, 0);";
            console.log(newquery7);
            mysql.pool.query(newquery7, function (err, rows) {
                if (err) {
                    next(err);
                    return;
                }
            })
        })
        res.render('main_page', context);

    } else if (req.query.withdrawlAmt != 0 && req.query.withdrawlAmt != '' && req.query.withdrawlAmt != null) {
        var newquery8 = "UPDATE BI_accounts SET `current_balance` = `current_balance` - " + String(req.query.withdrawlAmt) + " WHERE `user_id` =" + curId + " AND `account_type_id`=";
        newquery8 += "(SELECT `id` FROM BI_account_types WHERE `type_name` ='" + req.query.with_account_type + "')";
        console.log(newquery8);
        mysql.pool.query(newquery8, function (err, rows) {
            if (err) {
                next(err);
                return;
            }
        })
        var newquery9 = "INSERT INTO BI_account_transactions (`payee_account_id`, `payer_account_id`, `amount`, `transaction_date`, `transaction_type_id`, `memo`, `posting_date`, `isVoid`)";
        newquery9 += " VALUES ((SELECT `id` FROM BI_accounts WHERE `user_id` =" + curId + " AND `account_type_id` = (SELECT `id` FROM BI_account_types WHERE `type_name` ='" + req.query.with_account_type + "')),";
        newquery9 += " (SELECT `id` FROM BI_accounts WHERE `user_id` =" + curId + " AND `account_type_id` = (SELECT `id` FROM BI_account_types WHERE `type_name` ='" + req.query.with_account_type + "')),";
        newquery9 += " +" - String(req.query.withdrawlAmt) + ", CURRENT_TIMESTAMP, 1," + String('"WITHDRAWL"') +", CURRENT_TIMESTAMP, 0)";
        console.log(newquery9);
        mysql.pool.query(newquery9, function (err, rows){
            if (err) {
                next(err);
                return;
            }
          })
        })
        res.render('main_page', context);

    } else  mysql.pool.query('SELECT * FROM BI_accounts', function (err, rows, fields) {
        if (err) {
            next(err);
            return;
        }
        context.results = JSON.stringify(rows);
        res.render('main_page', context);
    });
});

app.use(function (req, res) {
    res.status(404);
    res.render('404');
});

app.use(function (err, req, res, next) {
    console.error(err.stack);
    res.status(500);
    res.render('500');
});

app.listen(app.get('port'), function () {
    console.log('Express started on http://localhost:' + app.get('port') + '; press Ctrl-C to terminate.');
});
