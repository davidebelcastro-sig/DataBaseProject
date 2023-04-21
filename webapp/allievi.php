<?php
require_once('./database.php');
$sql = "select Persona.nome,Persona.cognome,Persona.codice_fiscale from Persona,Allievo where Allievo.id_allievo = Persona.id_persona;";
$result = $mysqli->query($sql);
echo "Elenco Allievi";
echo "<table>";
echo "<tr><td>Nome</td><td>Cognome</td><td>Cod fiscale</td></tr>";
while($row = $result->fetch_assoc()) {
    echo "<tr><td>".$row['nome']."</td><td>".$row['cognome']."</td><td>".$row['codice_fiscale']."</td></tr>";
}
echo "</table>";
?>