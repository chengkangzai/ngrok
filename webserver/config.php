<?php
define('DB_SERVER', 'localhost');
define('DB_USERNAME', 'root');
define('DB_PASSWORD', 'password');
define('DB_DATABASE', 'ngrok');
$db = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_DATABASE);

if (!$db) {
    echo "Not connect to database, Please check your credential or the connection to database. ";
}