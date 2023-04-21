<?php
require_once('./database.php');
$sql = "create view lez_prog as select sum(Lezione.fine -Lezione.inizio) / 10000 as ore, Progetto.id_progetto from 
Lezione,Progetto,Corso WHERE
Corso.id_corso = Lezione.id_corso AND
Corso.id_progetto = Progetto.id_progetto
group by Progetto.id_progetto;";
$mysqli->query($sql);
$sql = "select lez_prog.ore,Progetto.nome from lez_prog,Progetto where Progetto.id_progetto = lez_prog.id_progetto;";
$result = $mysqli->query($sql);
echo "Ore previste per ogni progetto";
echo "<table>";
echo "<tr><td>Ore</td><td>Progetto</td></tr>";
while($row = $result->fetch_assoc()) {
echo "<tr><td>".$row['ore']."</td><td>".$row['nome']."</td></tr>";
}
$sql = "drop view lez_prog;";
$mysqli->query($sql);
?>