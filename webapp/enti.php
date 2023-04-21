<?php
require_once('./database.php');
$sql = "SELECT nome from Ente";
$result = $mysqli->query($sql);
echo "Elenco Enti";
echo "<table>";
echo "<tr><td>Nome</td></tr>";
while($row = $result->fetch_assoc()) {
echo "<tr><td>".$row['nome']."</td></tr>";
}
echo "</table>";

?>