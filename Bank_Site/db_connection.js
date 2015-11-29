var mysql = require('mysql');
var pool = mysql.createPool({
  connectionLimit : 10,
  host            : 'localhost',
  user            : 'root',
  password        : 'trentmatt123',
  database        : 'BANK_CS340'
});

module.exports.pool = pool;
