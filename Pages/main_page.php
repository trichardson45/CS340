<?php
//Turn on error reporting
ini_set('display_errors', 'On');
//Connects to the database
$mysqli = new mysqli("oniddb.cws.oregonstate.edu","monroema-db","jbV6B6BZEPFiLc2N","monroema-db");
if($mysqli->connect_errno){
echo "Connection error " . $mysqli->connect_errno . " " . $mysqli->connect_error;
}
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
    <link rel="stylesheet" href="main_page.css" type="text/css">
    <script type="text/javascript" src="main_page.js"></script>
</head>
<body>
<p>Look at me </p>

</body>
</html>