<?php
require_once('./database.php');
echo "VISTE DI ALCUNE TABELLE</br><br>";
?>


<a class='aule' id = "" href='./aule.php' >Vista Aule</a> 
<br>
<a class='corsi' id = "" href='./corsi.php' >Vista Corsi</a> 
<br>
<a class='progetti' id = "" href='./progetti.php' >Vista Progetti</a> 
<br>
<a class='docenti' id = "" href='./docenti.php' >Vista Docenti</a> 
<br>
<a class='allievi' id = "" href='./allievi.php' >Vista Allievi</a> 
<br>
<a class='enti' id = "" href='./enti.php' >Vista Enti</a>
<br>
<a class='enti' id = "" href='./ore_corso.php' >Vista ore previste per ogni corso</a> 
<br>
<a class='enti' id = "" href='./ore_prog.php' >Vista ore previste per ogni progetto</a>
<br>
<form class="user" action="./usecase.php" method="post"  onSubmit="return validate(this);">
<!-- vedere progetti di un docente-->
<?php
echo "</br><br>";
echo "QUERY</br>
Scegliere solo un usecase e poi premere invio(se si selezionano più di uno usecase verrà eseguito il primo e basta)</br><br>";
echo "Selezionare un docente per vedere i suoi progetti<br>";
?>
<label style="width:20%;">Docente</label><select class = "" id="docenteprog" name="docenteprog" style="width:30%;" ><option value="">Seleziona Docente</option>
<?php 

$sql = "select Persona.nome,Persona.cognome,Persona.id_persona from Persona,Docente where Docente.id_docente = Persona.id_persona;";
$result = $mysqli->query($sql);
while ($row = $result->fetch_assoc()) {

echo "<option value=".$row['id_persona'].">".$row['nome']." ".$row['cognome']."</option>";
}
?> 
<br>
</select>

<!-- vedere progetti di un responsabile-->
<?php
echo "</br><br>";
echo "Selezionare un responsabile per vedere i suoi progetti<br>";
?>
<label style="width:20%;">Responsabile</label><select id="respprog" name="respprog" style="width:30%;"><option value="">Seleziona Responsabile</option>
<?php 
$sql = "select Persona.nome,Persona.cognome,Persona.id_persona from Persona,Responsabile where Responsabile.id_responsabile = Persona.id_persona;";
$result = $mysqli->query($sql);
while ($row = $result->fetch_assoc()) {

echo "<option value=".$row['id_persona'].">".$row['nome']." ".$row['cognome']."</option>";
}
?>

<br>
</select>

<!--  vedere corsi di un allievo-->
<?php
echo "</br><br>";
echo "Selezionare un allievo per vedere i suoi corsi<br>";
?>
<label style="width:20%;">Allievo</label><select id="corall" name="corall" style="width:30%;" ><option value="">Seleziona Allievo</option>
<?php 
$sql = "select Persona.nome,Persona.cognome,Persona.id_persona from Persona,Allievo where Allievo.id_allievo = Persona.id_persona;";
$result = $mysqli->query($sql);
while ($row = $result->fetch_assoc()) {

echo "<option value=".$row['id_persona'].">".$row['nome']." ".$row['cognome']."</option>";
}
?> 

<br>
</select>
<!-- vedere progetti di un ente-->
<?php
echo "</br><br>";
echo "Selezionare un ente per vedere i suoi progetti<br>";
?>
<label style="width:20%;">Ente</label><select id="entprog" name="entprog" style="width:30%;" ><option value="">Seleziona Ente</option>
<?php 

$sql = "SELECT nome,id_ente from Ente;";
$result = $mysqli->query($sql);
while ($row = $result->fetch_assoc()) {

echo "<option value=".$row['id_ente'].">".$row['nome']."</option>";
}
?>
 
<br>
</select>
<!--vedere corsi di un progetto-->
<?php
echo "</br><br>";
echo "Selezionare un progetto per vedere i corsi</br>";
?>
<label style="width:20%;">Progetto</label><select id="corprog" name="corprog" style="width:30%;" ><option value="">Seleziona Progetto</option>
<?php 
$sql = "select Progetto.id_progetto,Progetto.nome from Progetto";
$result = $mysqli->query($sql);
while ($row = $result->fetch_assoc()) {

echo "<option value=".$row['id_progetto'].">".$row['nome']."</option>";
}
?>

<br>
</select>
<!--vedere calendario di un corso-->
<?php
echo "</br><br>";
echo "Selezionare un corso per vedere il calendario</br>";
?>
<label style="width:20%;">Corso</label><select id="calcor" name="calcor" style="width:30%;" ><option value="">Seleziona Corso</option>
<?php 
$sql = "select * from Corso";
$result = $mysqli->query($sql);
while ($row = $result->fetch_assoc()) {

echo "<option value=".$row['id_corso'].">".$row['nome']."</option>";
}
?>

<br>
</select>
<?php
echo "</br><br>";
echo "Selezionare un progetto per vedere il suo calendario</br>";
?>
<!--vedere calendario di un progetto-->
<label style="width:20%;">Progetto</label><select id="calprog" name="calprog" style="width:30%;" ><option value="">Seleziona Progetto</option>
<?php 
$sql = "select * from Progetto";
$result = $mysqli->query($sql);
while ($row = $result->fetch_assoc()) {

echo "<option value=".$row['id_progetto'].">".$row['nome']."</option>";
}

?>

<br>
</select>
<!--assegna allievo a progettp-->
<?php
echo "</br><br>";
echo "</br><br>";
echo "INSERIMENTI</br>";
echo "Selezionare progetto e allievo per assegnare il progetto all'allievo</br>";
?>
<label style="width:20%;">Progetto</label><select id="allprog" name="allprog" style="width:30%;" ><option value="">Seleziona Progetto</option>
<?php 
$sql = "select * from Progetto";
$result = $mysqli->query($sql);
while ($row = $result->fetch_assoc()) {

echo "<option value=".$row['id_progetto'].">".$row['nome']."</option>";
}
echo "<br><br>";

?>
</select>
<label style="width:20%;">Allievo</label><select id="allprog2" name="allprog2" style="width:30%;" ><option value="">Seleziona Allievo</option>
<?php 
$sql = "select Persona.nome,Persona.cognome,Persona.id_persona from Allievo,Persona where Allievo.id_allievo = Persona.id_persona";
$result = $mysqli->query($sql);
while ($row = $result->fetch_assoc()) {
$all = $row['nome']." ".$row['cognome'];
echo "<option value=".$row['id_persona'].">".$all."</option>";
}
echo "<br><br>";
?>
</select>
<br>
<!--inserisci persona-->
<?php
echo "</br><br>";
echo "Aggiungere i relativi campi per inserire una persona</br>";
?>
Nome*<input type='text' name='nome' id='nome' value=''/>
<br>
Cognome*<input type='text' name='cnome' id='cnome' value=''/>
<br>
Codice fiscale*<input type='text' name='cod' id='cod' value=''/>
<br>
Data Nascita(yyyy-mm-gg)*<input type='text' name='dt' id='dt' value=''/>
<br>
Telefono<input type='text' name='tel' id='tel' value=''/>
<br>
Indirizzo*<input type='text' name='via' id='via' value=''/>
<br>
<label style="width:20%;">Citta*</label><select id="cit" name="cit" style="width:30%;" ><option value="">Seleziona Citta</option>
<?php 
$sql = "select * from Città";
$result = $mysqli->query($sql);
while ($row = $result->fetch_assoc()) {

echo "<option value=".$row['id_citta'].">".$row['nome']."</option>";
}
?>
</select>
<br><br>
<input type="submit" class="btn btn-success btn-icon-split" name="invio" id="invio" onclick="clickme(this.id);" value="Invio"></span>
                  
<script>
 $(" .aule").on("click",function(){
	var select = $(this);

 // var value=$(id).text();
  //alert(value);
 $("#content").load("./aule.php");
  });
  $(" .corsi").on("click",function(){
	var select = $(this);
   

 // var value=$(id).text();
  //alert(value);
 $("#content").load("corsi.php");
  });
  $(" .progetti").on("click",function(){
	var select = $(this);
  

 // var value=$(id).text();
  //alert(value);
 $("#content").load("progetti.php");
  });
  $(" .docenti").on("click",function(){
	var select = $(this);
  

 // var value=$(id).text();
  //alert(value);
 $("#content").load("docenti.php");
  });
  $(" .allievi").on("click",function(){
	var select = $(this);
 

 // var value=$(id).text();
  //alert(value);
 $("#content").load("allievi.php");
  });
  $(" .enti").on("click",function(){
	var select = $(this);
  

 // var value=$(id).text();
  //alert(value);
 $("#content").load("enti.php");
  });

  </script> 
