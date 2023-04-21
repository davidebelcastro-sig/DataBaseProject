<?php 
require_once('./database.php');
echo "</table>";
$sql = "SELECT Corso.nome as corso,Progetto.nome as progetto FROM `Corso`,Progetto WHERE Progetto.id_progetto = Corso.id_progetto";
$result = $mysqli->query($sql);
echo "Elenco Corsi";
echo "<table>";
echo "<tr><td>Corso</td><td>Progetto</td></tr>";
while($row = $result->fetch_assoc()) {
echo "<tr><td>".$row['corso']."</td><td>".$row['progetto']."</td></tr>";
}
echo "</table>";
?>