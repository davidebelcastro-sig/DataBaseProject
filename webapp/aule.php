<?php
require_once('./database.php');
$sql = "SELECT * from Aula";
$result = $mysqli->query($sql);
echo "Elenco Aule";
echo "<table>";
echo "<tr><td>Nome</td><td>Indirizzo</td></tr>";
while($row = $result->fetch_assoc()) {
echo "<tr><td>".$row['nome']."</td><td>".$row['indirizzo']."</td></tr>";
}
?>