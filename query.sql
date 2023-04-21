
ALLIEVI NATI A ROMA CHE HANNO FATTO ALMENO 5 ORE TOTALI PRESENZE

	create view allievi_roma as SELECT Allievo.id_allievo from Allievo,Persona,Città WHERE
	Allievo.id_allievo = Persona.id_persona and 
	Persona.id_citta = Città.id_citta AND
	Città.nome = 'Roma';
	create view allievi_ore as SELECT AllievoRegistro.id_allievo,sum(AllievoRegistro.fine-AllievoRegistro.inizio) / 10000 as ore from AllievoRegistro GROUP by AllievoRegistro.id_allievo having ore >= 5;
	SELECT Persona.codice_fiscale from Persona,allievi_ore WHERE
	Persona.id_persona = allievi_ore.id_allievo and 
	allievi_ore.id_allievo in (SELECT * from allievi_roma);


NUMERO LEZIONI DI DOCENTI NATI A ROMA

		create view docenti_roma as SELECT Docente.id_docente from Docente,Persona,Città where Persona.id_persona = Docente.id_docente AND
		Persona.id_citta = Città.id_citta and Città.nome = 'Roma';

		SELECT count(*) from Lezione WHERE
		Lezione.id_docente in (SELECT * from docenti_roma);



NUMERO DI PROGETTI DI OGNI RESPONSABILE	
	create view id_resp as SELECT Responsabile.id_responsabile from Responsabile;
	SELECT Persona.codice_fiscale, count(Progetto.id_responsabile) tot_progetti 
	from Persona,Progetto WHERE
	Progetto.id_responsabile = Persona.id_persona and
	Persona.id_persona in (SELECT * from id_resp) GROUP BY Progetto.id_responsabile;





NUMERO ORE SVOLTE DA OGNI ALLIEVO
	create view appo2 as select sum(AllievoRegistro.fine -AllievoRegistro.inizio) / 10000 as tot_ore, AllievoRegistro.id_allievo from AllievoRegistro GROUP by AllievoRegistro.id_allievo;
	select appo2.tot_ore,Persona.cognome,Persona.nome from appo2,Persona where Persona.id_persona = appo2.id_allievo;




ALLIEVI PRESENTI AD UNA LEZIONE E NUMERO ALLIEVI PREVISTI
	create view allievi_lezione as SELECT AllievoRegistro.id_allievo from AllievoRegistro,Lezione where Lezione.id_lezione = AllievoRegistro.id_lezione and Lezione.giorno = '2023-02-22' and Lezione.id_corso = 1 and AllievoRegistro.nota = 'Presente';
	select count(*) from allievi_lezione; //ritorna il numero di allievi previsti per quella lezione
	SELECT Persona.codice_fiscale from Persona WHERE Persona.id_persona in (SELECT * from allievi_lezione); //allievi presenti



ORE PREVISTE DEI CORSI
	create view lez_corso as SELECT sum(Lezione.fine - Lezione.inizio)/10000 as ore,Lezione.id_corso from Lezione GROUP by Lezione.id_corso;
	select lez_corso.ore,Corso.nome from Corso,lez_corso where Corso.id_corso = lez_corso.id_corso;







ORE PREVISTE DAI PROGETTI
	create view lez_prog as select sum(Lezione.fine -Lezione.inizio) / 10000 as ore, Progetto.id_progetto from 
	Lezione,Progetto,Corso WHERE
	Corso.id_corso = Lezione.id_corso AND
	Corso.id_progetto = Progetto.id_progetto
	group by Progetto.id_progetto;

select lez_prog.ore,Progetto.nome from lez_prog,Progetto where Progetto.id_progetto = lez_prog.id_progetto;


ORE SVOLTE DI UN CORSO
	select sum(doc_reg.fine - doc_reg.inizio) / 10000 as ore from doc_reg,Lezione
	 where 
	 Lezione.id_lezione = doc_reg.id_lezione AND
	 doc_reg.nota = 'Presente' and 
	 Lezione.id_corso = 1;
 
 
CALENDARIO CORSO
select distinct Lezione.*,Persona.nome,Persona.cognome,Aula.nome as aula from Lezione,Persona,Aula
where Lezione.id_corso = 1 and
Lezione.id_aula = Aula.id_aula and
Lezione.id_docente = Persona.id_persona;



CALENDARIO PROGETTO
select distinct Lezione.*,Persona.nome,Persona.cognome,Aula.nome as aula,Corso.nome as corso from Lezione,Persona,Aula,Corso
where Lezione.id_corso = Corso.id_corso and
Lezione.id_aula = Aula.id_aula and
Lezione.id_docente = Persona.id_persona and
Corso.id_progetto = 1;



RESTITUIRE TUTTI I DOCENTI DI UN CORSO
SELECT distinct Persona.nome,Persona.cognome FROM doc_corso,Persona WHERE doc_corso.id_docente = Persona.id_persona and doc_corso.id_corso=1;

DOCENTI DI UN PROGETTO
SELECT distinct Persona.nome,Persona.cognome FROM doc_corso,Persona,Corso WHERE doc_corso.id_docente = Persona.id_persona and Corso.id_corso = doc_corso.id_corso and Corso.id_progetto = 1;


ALLIEVI DI UN PROGETTO
select Persona.nome,Persona.cognome from Persona,all_prog where all_prog.id_allievo = Persona.id_persona and all_prog.id_progetto=1;



ALLIEVI DI UN CORSO
select Persona.nome,Persona.cognome from Persona,all_prog,Corso where all_prog.id_allievo = Persona.id_persona and
all_prog.id_progetto = Corso.id_corso AND
Corso.id_corso = 1;





PRESENZA DI UN DOCENTE
select Lezione.giorno,doc_reg.inizio,doc_reg.fine,Corso.nome from Lezione,doc_reg,Corso where
doc_reg.nota = 'Presente' AND
Lezione.id_corso = Corso.id_corso AND
Lezione.id_lezione = doc_reg.id_lezione AND
Lezione.id_docente=1;



PRESENZE DI UN ALLIEVO
select Lezione.giorno,AllievoRegistro.inizio,AllievoRegistro.fine,Corso.nome as corso from Lezione,AllievoRegistro,Corso where
AllievoRegistro.nota = 'Presente' AND
Lezione.id_corso = Corso.id_corso AND
Lezione.id_lezione = AllievoRegistro.id_lezione AND
AllievoRegistro.id_allievo = 1;



LEZIONI SVOLTE IN UN AULA
select Lezione.giorno,Lezione.inizio,Lezione.fine,Corso.nome from Lezione,Corso where Corso.id_corso = Lezione.id_corso AND
Lezione.id_aula = 1;



RESTITUIRE TUTTI GLI ALLIEVI PRESENTI AD UNA LEZIONE
select Persona.nome,Persona.cognome from AllievoRegistro,Persona where AllievoRegistro.id_allievo = Persona.id_persona AND
AllievoRegistro.id_lezione = 1 order by Persona.cognome;



RESTITUIRE I NOMI DELLE AULE IN CUI SONO STATE TENUTE LEZIONI DA DOCENTI CHE HANNO ALMENO 2 LINK
select distinct Aula.nome from Aula where Aula.id_aula in 
(select distinct Lazione.id_aula from Lezione where Lezione.id_docente in
	(select link.id_docente from link GROUP BY link.id_docente HAVING count(link.id_link >=2))
);


INSERIMENTO PRESENZA DI UN ALLIEVO
INSERT INTO all_prog(id_allievo,id_progetto) VALUES(1,1);


INSERIMENTO PRESENZA DI UN DOCENTE
INSERT INTO doc_corso(id_docente,id_corso) VALUES (1,2);


REGISTRARE UNA PERSONA
INSERT INTO Persona(nome,codice_fiscale,cognome,data_nascita,telefono,indirizzo,id_citta) VALUES('davide','adcsvf','belcastro','2001-05-29',NULL,'indirizzo','1');



ASSEGNARE UN DOCENTE AD UN CORSO
INSERT INTO AllievoRegistro(inizio,fine,nota,id_allievo,id_lezione) VALUES(10:00,12:00,'Presente',1,1);



ASSEGNARE UN ALLIEVO AD UN PROGETTO
INSERT INTO doc_reg(inizio,fine,nota,id_docente,id_lezione) VALUES(10:00,12:00,'Presente',1,1);









