<?php
try {
    $hostname = "localhost";
    $dbname = "corsi_formazione";
    $user = "root";
    $pass = "29.edivad.05";
    $mysqli = new mysqli($hostname, $user, $pass, $dbname);
}
catch(Exception $e)
{
    echo $e->getMessage();
}

?>
