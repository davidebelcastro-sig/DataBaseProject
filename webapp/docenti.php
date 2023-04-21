<?php
require_once('./database.php');
$sql = "select Persona.nome,Persona.cognome,Persona.codice_fiscale from Persona,Docente where Docente.id_docente = Persona.id_persona;";
$result = $mysqli->query($sql);
echo "Elenco Docenti";
echo "<table>";
echo "<tr><td>Nome</td><td>Cognome</td><td>Cod fiscale</td></tr>";
while($row = $result->fetch_assoc()) {
echo "<tr><td>".$row['nome']."</td><td>".$row['cognome']."</td><td>".$row['codice_fiscale']."</td></tr>";
}
echo "</table>";
?>