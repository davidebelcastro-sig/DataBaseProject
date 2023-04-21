<?php

require_once('./database.php');
if($_POST["docenteprog"] != NULL)
{
        $sql = "select distinct Progetto.nome from Progetto,doc_corso,Corso 
        where Corso.id_progetto = Progetto.id_progetto and doc_corso.id_corso = Corso.id_corso 
        and doc_corso.id_docente =".$_POST["docenteprog"];
        $result = $mysqli->query($sql);
        echo "Elenco Progetti";
        echo "<table>";
        echo "<tr><td>Nome</td></tr>";
        while($row = $result->fetch_assoc()) {
        echo "<tr><td>".$row['nome']."</td></tr>";
        }
}
elseif ($_POST["respprog"]!= NULL)
{
        $sql = "select distinct Progetto.nome from Progetto
        where Progetto.id_responsabile =".$_POST["respprog"];
        $result = $mysqli->query($sql);
        echo "Elenco Progetti";
        echo "<table>";
        echo "<tr><td>Nome</td></tr>";
        while($row = $result->fetch_assoc()) {
        echo "<tr><td>".$row['nome']."</td></tr>";
        }
}
elseif ($_POST["corall"]!= NULL)
{
    $sql = "select distinct Corso.nome as corso,Progetto.nome as progetto from Corso,Progetto,all_prog
    where Progetto.id_progetto =all_prog.id_progetto and
    Progetto.id_progetto = Corso.id_progetto and
    all_prog.id_progetto = Corso.id_progetto and
    all_prog.id_allievo = ".$_POST["corall"];
    $result = $mysqli->query($sql);
    echo "Elenco Corsi";
    echo "<table>";
    echo "<tr><td>Corso</td><td>Progetto</td></tr>";
    while($row = $result->fetch_assoc()) {
    echo "<tr><td>".$row['corso']."</td><td>".$row['progetto']."</td></tr>";
    }
}
elseif ($_POST["entprog"]!= NULL)
{
    $sql = "select distinct Progetto.nome from Progetto
        where Progetto.id_ente =".$_POST["entprog"];
        $result = $mysqli->query($sql);
        echo "Elenco Progetti";
        echo "<table>";
        echo "<tr><td>Nome</td></tr>";
        while($row = $result->fetch_assoc()) {
        echo "<tr><td>".$row['nome']."</td></tr>";
        }
}
elseif ($_POST["corprog"]!= NULL)
{
    $sql = "select distinct Corso.nome from Corso
    where Corso.id_progetto =".$_POST["corprog"];
    $result = $mysqli->query($sql);
    echo "Elenco Corsi";
    echo "<table>";
    echo "<tr><td>Nome</td></tr>";
    while($row = $result->fetch_assoc()) {
    echo "<tr><td>".$row['nome']."</td></tr>";
    }
}
elseif ($_POST["calcor"]!= NULL)
{
    $sql = "select distinct Lezione.*,Persona.nome,Persona.cognome,Aula.nome as aula from Lezione,Persona,Aula
    where Lezione.id_corso = ".$_POST["calcor"]." and
    Lezione.id_aula = Aula.id_aula and
    Lezione.id_docente = Persona.id_persona";
    $result = $mysqli->query($sql);
    echo "Elenco Lezioni";
    echo "<table>";
    echo "<tr><td>Giorno</td><td>Inizio</td><td>Fine</td><td>Docente</td><td>Aula</td></tr>";
    while($row = $result->fetch_assoc()) {
        $docente = $row['nome']." ".$row['cognome'];
    echo "<tr><td>".$row['giorno']."</td><td>".$row['inizio']."</td><td>".$row['fine']."</td><td>".$docente."</td><td>".$row['aula']."</td></tr>";
    }
}
elseif ($_POST["calprog"]!= NULL)
{
    $sql = "select distinct Lezione.*,Persona.nome,Persona.cognome,Aula.nome as aula,Corso.nome as corso from Lezione,Persona,Aula,Corso
    where Lezione.id_corso = Corso.id_corso and
    Lezione.id_aula = Aula.id_aula and
    Lezione.id_docente = Persona.id_persona and
    Corso.id_progetto = ".$_POST["calprog"];
    $result = $mysqli->query($sql);
    echo "Elenco Lezioni";
    echo "<table>";
    echo "<tr><td>Giorno</td><td>Inizio</td><td>Fine</td><td>Docente</td><td>Aula</td><td>Corso</td></tr>";
    while($row = $result->fetch_assoc()) {
    echo "<tr><td>".$row['giorno']."</td><td>".$row['inizio']."</td><td>".$row['fine']."</td><td>".$row['nome']." ".$row['cognome']."</td><td>".$row['aula']."</td><td>".$row['corso']."</td></tr>";
    }
}
elseif ($_POST["allprog"]!= NULL)
{
    if($_POST["allprog2"]!= NULL)
    {
                try
                {
                $stmt = $mysqli->prepare("INSERT INTO all_prog(id_allievo,id_progetto) VALUES (".$_POST["allprog2"].",".$_POST["allprog"].")");
                if ($stmt === false)
                    die('prepare() failed: ' . htmlspecialchars($mysqli->error));	
                $rc = $stmt->execute();
                if ($rc === false)
                    die('Inserire valori corretti!'); 
                echo "Operazione avvenuta con successo";                    
                }

                catch(Exception $e) {
                    //echo 'Message: ' .$e->getMessage();
                    echo "errore nell'inserimento";	
                }
    }
    else
    {
        echo "Selezionare anche l'allievo!";
    }
}
elseif ($_POST["allprog2"] != NULL)
{
    if($_POST["allprog"]!= NULL)
    {
        try
        {
        $stmt = $mysqli->prepare("INSERT INTO all_prog(id_allievo,id_progetto) VALUES (".$_POST["allprog2"].",".$_POST["allprog"].")");
        if ($stmt === false)
            die('prepare() failed: ' . htmlspecialchars($mysqli->error));	
        $rc = $stmt->execute();
        if ($rc === false)
            die('Inserire valori corretti!');     
        echo "Operazione avvenuta con successo";                    
        }

        catch(Exception $e) {
            //echo 'Message: ' .$e->getMessage();
            echo "errore nell'inserimento";	
        }
    }
    else
    {
        echo "Selezionare anche il progetto!";
    }
}
elseif ($_POST["nome"] != NULL || $_POST["cnome"] != NULL || $_POST["cod"] != NULL || $_POST["dt"] != NULL || $_POST["via"] != NULL || $_POST["cit"] != NULL )
{
        try
        {
        $stmt = $mysqli->prepare("INSERT INTO Persona(nome,cognome,codice_fiscale,data_nascita,telefono,indirizzo,id_citta) VALUES ('".$_POST["nome"]."','".$_POST["cnome"]."','".$_POST["cod"]."','".$_POST["dt"]."','".$_POST["tel"]."','".$_POST["via"]."',".$_POST["cit"].")");
        if ($stmt === false)
            die('prepare() failed: ' . htmlspecialchars($mysqli->error));	
        $rc = $stmt->execute();
        if ($rc === false)
            die('Inserire valori corretti!');     
        echo "Operazione avvenuta con successo";                    
        }

        catch(Exception $e) {
            //echo 'Message: ' .$e->getMessage();
            echo "errore nell'inserimento";	
        }
   
}
else
{
    echo "Selezionare una tra le alternative proposte!";
}

?>