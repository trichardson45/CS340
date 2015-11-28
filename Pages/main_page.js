var express = require('express');
var mysql = require('./db_connection.js');

var app = express();
var handlebars = require('express-handlebars').create({defaultLayout: 'main'});

app.engine('handlebars', handlebars.engine);
app.set('view engine', 'handlebars');
app.set('port', 3000);


app.get('/', function (req, res, next) {
    var context = {};
    var params = [];
    // for(var p in req.query)
    //{
    //    params.push({'name': p, 'value': req.query[p]});
    //    console.log(p);
    // }
    if (req.query.password1 != null && req.query.password1 != '') {
        if (req.query.password1 == req.query.password2) {
            var newquery = "INSERT INTO `BI_user` (`f_name`,`m_name`,`l_name`,`email`,`username`,`is_active`)";
            newquery += " values('" + req.query.fname + "', '" + req.query.mname + "', '";
            newquery += req.query.lname + "', '" + req.query.ename + "', '" + req.query.uname + "', 1);";
            console.log(newquery);
            mysql.pool.query(newquery, function (err, rows, fields) {
                if (err) {
                    next(err);
                    return;
                }
                context.results = JSON.stringify(rows);
                console.log(context.results);
                res.render('main_page', context);
            });
        }
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
