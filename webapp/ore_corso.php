<?php
require_once('./database.php');
$sql = "create view lez_corso as SELECT sum(Lezione.fine - Lezione.inizio)/10000 as ore,Lezione.id_corso from Lezione GROUP by Lezione.id_corso;";
$mysqli->query($sql);
$sql = "select lez_corso.ore,Corso.nome from Corso,lez_corso where Corso.id_corso = lez_corso.id_corso;";
$result = $mysqli->query($sql);
echo "Ore previste per ogni corso";
echo "<table>";
echo "<tr><td>Ore</td><td>Corso</td></tr>";
while($row = $result->fetch_assoc()) {
echo "<tr><td>".$row['ore']."</td><td>".$row['nome']."</td></tr>";
}
$sql = "drop view lez_corso;";
$mysqli->query($sql);
?>



