
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


--
-- Database: `corsi_formazione`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `Allievo`
--

CREATE TABLE `Allievo` (
  `id_allievo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Trigger `Allievo`
--
DELIMITER $$
CREATE TRIGGER `check_allievo` BEFORE INSERT ON `Allievo` FOR EACH ROW if (new.id_allievo in (SELECT id_responsabile from Responsabile) or new.id_allievo in (select id_docente from Docente)) 
THEN
SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'questa persona non può essere un allievo!';
end if
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `AllievoRegistro`
--

CREATE TABLE `AllievoRegistro` (
  `id_all_reg` int(11) NOT NULL,
  `inizio` time DEFAULT NULL,
  `fine` time DEFAULT NULL,
  `nota` enum('Presente','Assente') NOT NULL,
  `id_allievo` int(11) NOT NULL,
  `id_lezione` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Trigger `AllievoRegistro`
--
DELIMITER $$
CREATE TRIGGER `check_allievo_legal` BEFORE INSERT ON `AllievoRegistro` FOR EACH ROW if 
(
   ( select id_progetto from Progetto where id_progetto = (select id_corso from Lezione where id_lezione = new.id_lezione)) not in 
    (select all_prog.id_progetto from all_prog where all_prog.id_allievo = new.id_allievo)
    
    
    
    
 )
 THEN
 SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'questo allievo non può registrare la presenza!';
 
 end if
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_legal3` BEFORE INSERT ON `AllievoRegistro` FOR EACH ROW if 
(
new.inizio < (select inizio from Lezione where Lezione.id_lezione = new.id_lezione)  or
 new.fine >
(select fine from Lezione where Lezione.id_lezione = new.id_lezione)
) 
THEN
SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'inserire periodo legale';
end if
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `all_prog`
--

CREATE TABLE `all_prog` (
  `id_allievo` int(11) NOT NULL,
  `id_progetto` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `Aula`
--

CREATE TABLE `Aula` (
  `id_aula` int(11) NOT NULL,
  `nome` varchar(25) NOT NULL,
  `indirizzo` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `Città`
--

CREATE TABLE `Città` (
  `nome` varchar(10) NOT NULL,
  `id_citta` int(11) NOT NULL,
  `id_nazione` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `Corso`
--

CREATE TABLE `Corso` (
  `nome` varchar(25) NOT NULL,
  `id_corso` int(11) NOT NULL,
  `id_progetto` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `Docente`
--

CREATE TABLE `Docente` (
  `id_docente` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Trigger `Docente`
--
DELIMITER $$
CREATE TRIGGER `check_docente2` BEFORE INSERT ON `Docente` FOR EACH ROW if (new.id_docente in (SELECT id_responsabile from Responsabile) or new.id_docente in (select id_allievo from Allievo)) 
THEN
SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'questa persona non può essere un docente!';
end if
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `doc_corso`
--

CREATE TABLE `doc_corso` (
  `id_docente` int(11) NOT NULL,
  `id_corso` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `doc_reg`
--

CREATE TABLE `doc_reg` (
  `id_lezione` int(11) NOT NULL,
  `inizio` time DEFAULT NULL,
  `fine` time DEFAULT NULL,
  `nota` enum('Presente','Assente') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Trigger `doc_reg`
--
DELIMITER $$
CREATE TRIGGER `check_legal2` BEFORE INSERT ON `doc_reg` FOR EACH ROW if 
(
new.inizio < (select inizio from Lezione where Lezione.id_lezione = new.id_lezione)  or
 new.fine >
(select fine from Lezione where Lezione.id_lezione = new.id_lezione)
) 
THEN
SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'inserire periodo legale';
end if
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `Ente`
--

CREATE TABLE `Ente` (
  `nome` varchar(25) NOT NULL,
  `id_ente` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `Lezione`
--

CREATE TABLE `Lezione` (
  `id_lezione` int(11) NOT NULL,
  `giorno` date NOT NULL,
  `inizio` time NOT NULL,
  `fine` time NOT NULL,
  `id_docente` int(11) NOT NULL,
  `id_aula` int(11) NOT NULL,
  `id_corso` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Trigger `Lezione`
--
DELIMITER $$
CREATE TRIGGER `check_docente` BEFORE INSERT ON `Lezione` FOR EACH ROW if new.id_docente not in(select doc_corso.id_docente from doc_corso where doc_corso.id_corso = new.id_corso)
THEN
SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'corso non assegnato a quel docente';
end if
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_legal` BEFORE INSERT ON `Lezione` FOR EACH ROW if (new.giorno < (select Progetto.inizio from Progetto where Progetto.id_progetto = (select Corso.id_progetto from Corso where Corso.id_corso = NEW.id_corso)) or
   new.giorno >
   (select Progetto.fine from Progetto where Progetto.id_progetto = (select Corso.id_progetto from Corso where Corso.id_corso = NEW.id_corso)))  then
   SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'inserire valori legali di inizio e fine';

end if
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_value` BEFORE INSERT ON `Lezione` FOR EACH ROW if (new.id_aula in ( select pippo.id_aula from (select DISTINCT Lezione.id_aula from Lezione where ( Lezione.giorno = new.giorno and ( (new.inizio <= Lezione.inizio and new.fine > Lezione.inizio) or (new.inizio < Lezione.fine and new.fine >= Lezione.fine) or (Lezione.inizio < new.inizio and Lezione.fine > new.fine) ) ) ) as pippo)) then 

SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'aula occupata!';
 end if
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `link`
--

CREATE TABLE `link` (
  `id_link` int(11) NOT NULL,
  `id_docente` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `Nazione`
--

CREATE TABLE `Nazione` (
  `nome` varchar(15) NOT NULL,
  `id_nazione` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `Persona`
--

CREATE TABLE `Persona` (
  `nome` varchar(20) NOT NULL,
  `codice_fiscale` varchar(25) NOT NULL,
  `cognome` varchar(25) NOT NULL,
  `data_nascita` date NOT NULL,
  `telefono` varchar(10) DEFAULT NULL,
  `indirizzo` varchar(25) NOT NULL,
  `id_persona` int(11) NOT NULL,
  `id_citta` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `Progetto`
--

CREATE TABLE `Progetto` (
  `nome` varchar(25) NOT NULL,
  `inizio` date NOT NULL,
  `fine` date NOT NULL,
  `id_progetto` int(11) NOT NULL,
  `id_ente` int(11) NOT NULL,
  `id_responsabile` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `Responsabile`
--

CREATE TABLE `Responsabile` (
  `id_responsabile` int(11) NOT NULL,
  `p_iva` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Trigger `Responsabile`
--
DELIMITER $$
CREATE TRIGGER `check_resp` BEFORE INSERT ON `Responsabile` FOR EACH ROW if (new.id_responsabile in (SELECT id_docente from Docente) or new.id_responsabile in (select id_allievo from Allievo)) 
THEN
SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'questa persona non può essere un responsabile!';
end if
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `ValoreLink`
--

CREATE TABLE `ValoreLink` (
  `valore` varchar(25) NOT NULL,
  `id_link` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `Allievo`
--
ALTER TABLE `Allievo`
  ADD PRIMARY KEY (`id_allievo`);

--
-- Indici per le tabelle `AllievoRegistro`
--
ALTER TABLE `AllievoRegistro`
  ADD PRIMARY KEY (`id_all_reg`),
  ADD UNIQUE KEY `id_allievo`(`id_allievo`,`id_lezione`);

--
-- Indici per le tabelle `all_prog`
--
ALTER TABLE `all_prog`
  ADD PRIMARY KEY (`id_allievo`,`id_progetto`);

--
-- Indici per le tabelle `Aula`
--
ALTER TABLE `Aula`
  ADD PRIMARY KEY (`id_aula`),
  ADD UNIQUE KEY `nome` (`nome`);

--
-- Indici per le tabelle `Città`
--
ALTER TABLE `Città`
  ADD PRIMARY KEY (`id_citta`),
  ADD UNIQUE KEY `nome` (`nome`,`id_nazione`);

--
-- Indici per le tabelle `Corso`
--
ALTER TABLE `Corso`
  ADD PRIMARY KEY (`id_corso`),
  ADD UNIQUE KEY `nome` (`nome`);

--
-- Indici per le tabelle `Docente`
--
ALTER TABLE `Docente`
  ADD PRIMARY KEY (`id_docente`);

--
-- Indici per le tabelle `doc_corso`
--
ALTER TABLE `doc_corso`
  ADD PRIMARY KEY (`id_docente`,`id_corso`);

--
-- Indici per le tabelle `doc_reg`
--
ALTER TABLE `doc_reg`
  ADD PRIMARY KEY (`id_lezione`);

--
-- Indici per le tabelle `Ente`
--
ALTER TABLE `Ente`
  ADD PRIMARY KEY (`id_ente`),
  ADD UNIQUE KEY `nome` (`nome`);

--
-- Indici per le tabelle `Lezione`
--
ALTER TABLE `Lezione`
  ADD PRIMARY KEY (`id_lezione`),
  ADD UNIQUE KEY `giorno` (`giorno`,`id_corso`);

--
-- Indici per le tabelle `link`
--
ALTER TABLE `link`
  ADD PRIMARY KEY (`id_link`,`id_docente`);

--
-- Indici per le tabelle `Nazione`
--
ALTER TABLE `Nazione`
  ADD PRIMARY KEY (`id_nazione`),
  ADD UNIQUE KEY `nome` (`nome`);

--
-- Indici per le tabelle `Persona`
--
ALTER TABLE `Persona`
  ADD PRIMARY KEY (`id_persona`),
  ADD UNIQUE KEY `codice_fiscale` (`codice_fiscale`);

--
-- Indici per le tabelle `Progetto`
--
ALTER TABLE `Progetto`
  ADD PRIMARY KEY (`id_progetto`),
  ADD UNIQUE KEY `nome` (`nome`);

--
-- Indici per le tabelle `Responsabile`
--
ALTER TABLE `Responsabile`
  ADD PRIMARY KEY (`id_responsabile`),
  ADD UNIQUE KEY `p_iva` (`p_iva`);

--
-- Indici per le tabelle `ValoreLink`
--
ALTER TABLE `ValoreLink`
  ADD PRIMARY KEY (`id_link`),
  ADD UNIQUE KEY `valore` (`valore`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `AllievoRegistro`
--
ALTER TABLE `AllievoRegistro`
  MODIFY `id_all_reg` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `Aula`
--
ALTER TABLE `Aula`
  MODIFY `id_aula` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `Città`
--
ALTER TABLE `Città`
  MODIFY `id_citta` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `Corso`
--
ALTER TABLE `Corso`
  MODIFY `id_corso` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `Docente`
--
ALTER TABLE `Docente`
  MODIFY `id_docente` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `Ente`
--
ALTER TABLE `Ente`
  MODIFY `id_ente` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `Lezione`
--
ALTER TABLE `Lezione`
  MODIFY `id_lezione` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `Nazione`
--
ALTER TABLE `Nazione`
  MODIFY `id_nazione` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `Persona`
--
ALTER TABLE `Persona`
  MODIFY `id_persona` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `Progetto`
--
ALTER TABLE `Progetto`
  MODIFY `id_progetto` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `ValoreLink`
--
ALTER TABLE `ValoreLink`
  MODIFY `id_link` int(11) NOT NULL AUTO_INCREMENT;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `Allievo`
--
ALTER TABLE `Allievo`
  ADD CONSTRAINT `Allievo_ibfk_1` FOREIGN KEY (`id_allievo`) REFERENCES `Persona` (`id_persona`);

--
-- Limiti per la tabella `AllievoRegistro`
--
ALTER TABLE `AllievoRegistro`
  ADD CONSTRAINT `AllievoRegistro_ibfk_1` FOREIGN KEY (`id_allievo`) REFERENCES `Allievo` (`id_allievo`),
  ADD CONSTRAINT `AllievoRegistro_ibfk_2` FOREIGN KEY (`id_lezione`) REFERENCES `Lezione` (`id_lezione`);

--
-- Limiti per la tabella `all_prog`
--
ALTER TABLE `all_prog`
  ADD CONSTRAINT `all_prog_ibfk_1` FOREIGN KEY (`id_allievo`) REFERENCES `Allievo` (`id_allievo`),
  ADD CONSTRAINT `all_prog_ibfk_2` FOREIGN KEY (`id_progetto`) REFERENCES `Progetto` (`id_progetto`);

--
-- Limiti per la tabella `Città`
--
ALTER TABLE `Città`
  ADD CONSTRAINT `Città_ibfk_1` FOREIGN KEY (`id_nazione`) REFERENCES `Nazione` (`id_nazione`);

--
-- Limiti per la tabella `Corso`
--
ALTER TABLE `Corso`
  ADD CONSTRAINT `Corso_ibfk_1` FOREIGN KEY (`id_progetto`) REFERENCES `Progetto` (`id_progetto`);

--
-- Limiti per la tabella `Docente`
--
ALTER TABLE `Docente`
  ADD CONSTRAINT `Docente_ibfk_1` FOREIGN KEY (`id_docente`) REFERENCES `Persona` (`id_persona`);

--
-- Limiti per la tabella `doc_corso`
--
ALTER TABLE `doc_corso`
  ADD CONSTRAINT `doc_corso_ibfk_1` FOREIGN KEY (`id_docente`) REFERENCES `Docente` (`id_docente`),
  ADD CONSTRAINT `doc_corso_ibfk_2` FOREIGN KEY (`id_corso`) REFERENCES `Corso` (`id_corso`);

--
-- Limiti per la tabella `doc_reg`
--
ALTER TABLE `doc_reg`
  ADD CONSTRAINT `doc_reg_ibfk_1` FOREIGN KEY (`id_lezione`) REFERENCES `Lezione` (`id_lezione`);

--
-- Limiti per la tabella `Lezione`
--
ALTER TABLE `Lezione`
  ADD CONSTRAINT `Lezione_ibfk_1` FOREIGN KEY (`id_aula`) REFERENCES `Aula` (`id_aula`),
  ADD CONSTRAINT `Lezione_ibfk_2` FOREIGN KEY (`id_corso`) REFERENCES `Corso` (`id_corso`),
  ADD CONSTRAINT `Lezione_ibfk_3` FOREIGN KEY (`id_docente`) REFERENCES `Docente` (`id_docente`);

--
-- Limiti per la tabella `link`
--
ALTER TABLE `link`
  ADD CONSTRAINT `link_ibfk_1` FOREIGN KEY (`id_link`) REFERENCES `ValoreLink` (`id_link`),
  ADD CONSTRAINT `link_ibfk_2` FOREIGN KEY (`id_docente`) REFERENCES `Docente` (`id_docente`);

--
-- Limiti per la tabella `Persona`
--
ALTER TABLE `Persona`
  ADD CONSTRAINT `Persona_ibfk_1` FOREIGN KEY (`id_citta`) REFERENCES `Città` (`id_citta`);

--
-- Limiti per la tabella `Progetto`
--
ALTER TABLE `Progetto`
  ADD CONSTRAINT `Progetto_ibfk_1` FOREIGN KEY (`id_ente`) REFERENCES `Ente` (`id_ente`),
  ADD CONSTRAINT `Progetto_ibfk_2` FOREIGN KEY (`id_responsabile`) REFERENCES `Responsabile` (`id_responsabile`);

--
-- Limiti per la tabella `Responsabile`
--
ALTER TABLE `Responsabile`
  ADD CONSTRAINT `Responsabile_ibfk_1` FOREIGN KEY (`id_responsabile`) REFERENCES `Persona` (`id_persona`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
