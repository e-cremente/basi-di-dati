-- MySQL Workbench Forward Engineering
-- SET GLOBAL log_bin_trust_function_creators = 1; -- serve per far compilare le funzioni, dava problemi sul portatile  
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema smartmobility
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `smartmobility` ;

-- -----------------------------------------------------
-- Schema smartmobility
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `smartmobility` DEFAULT CHARACTER SET latin1 ;
USE `smartmobility` ;

-- -----------------------------------------------------
-- Table `classtecstrada`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `classtecstrada` ;

CREATE TABLE IF NOT EXISTS `classtecstrada` (
  `CodClassificazioneTecnica` VARCHAR(3) NOT NULL COMMENT 'Codice della classificazione tecnica di una strada',
  `Descrizione` VARCHAR(32) NOT NULL COMMENT 'Descrizione della classificazione tecnica',
  PRIMARY KEY (`CodClassificazioneTecnica`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Anagrafica delle classificazioni tecniche delle strade:\nSUR=Strada Urbana;\nSXP=Strada Extraurbana Principale\nSXS=Strada Extraurbana Secondaria\nAUT=Autostrada';


-- -----------------------------------------------------
-- Table `strada`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `strada` ;

CREATE TABLE IF NOT EXISTS `strada` (
  `CodStrada` VARCHAR(12) NOT NULL COMMENT 'Codice univoco della strada',
  `Lunghezza` DECIMAL(9,3) NULL DEFAULT NULL COMMENT 'Lunghezza della strada espressa in Km con precisione fino al metro',
  `NumCarreggiate` DECIMAL(2,0) NULL DEFAULT NULL COMMENT 'Numero di carreggiate della strada',
  `CodClassTec` VARCHAR(3) NULL DEFAULT NULL COMMENT 'Classificazione tecnica della strada',
  `Nome` VARCHAR(64) NULL DEFAULT NULL COMMENT 'Nome della strada (può essere il nome di una strada extraurbana (AURELIA, SUD ORIENTALE SICULA, ) oppure di una strada urbana (BRIGATE PARTIGIANE, UGO FOSCOLO, FILISTO)',
  PRIMARY KEY (`CodStrada`),
  CONSTRAINT `FK_Strada_ClassificazioneTecnica`
    FOREIGN KEY (`CodClassTec`)
    REFERENCES `classtecstrada` (`CodClassificazioneTecnica`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE INDEX `FK_Strada_ClassificazioneTecnica_idx` ON `strada` (`CodClassTec` ASC);


-- -----------------------------------------------------
-- Table `stradaurbana`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stradaurbana` ;

CREATE TABLE IF NOT EXISTS `stradaurbana` (
  `CodStrada` VARCHAR(12) NOT NULL COMMENT 'Codice univoco della strada',
  `DUG` VARCHAR(32) NULL DEFAULT NULL COMMENT 'Denominazione Urbanistica Generale (VIA, VIALE, PIAZZA, ) di questa strada',
  `CAP` VARCHAR(5) NULL DEFAULT NULL COMMENT 'Eventuale complemento della DUG (DI, DELLA, AL, DEL, DIETRO LE, ) di questa strada',
  `Nazione` VARCHAR(2) NULL DEFAULT NULL COMMENT 'Codice della nazione in cui si trova questa strada urbana',
  `Regione` VARCHAR(3) NULL DEFAULT NULL COMMENT 'Codice della regione in cui si trova questa strada urbana',
  `Provincia` VARCHAR(4) NULL DEFAULT NULL COMMENT 'Codice della provincia in cui si trova questa strada urbana',
  `Comune` VARCHAR(64) NOT NULL COMMENT 'Denominazione del comune in cui si trova questa strada urbana',
  PRIMARY KEY (`CodStrada`),
  CONSTRAINT `FK_StradaUrbana_Strada`
    FOREIGN KEY (`CodStrada`)
    REFERENCES `strada` (`CodStrada`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Sottoinsieme delle strade che sono strade urbane';


-- -----------------------------------------------------
-- Table `indirizzo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `indirizzo` ;

CREATE TABLE IF NOT EXISTS `indirizzo` (
  `CodIndirizzo` VARCHAR(12) NOT NULL COMMENT 'Identificativo univoco dellindirizzo',
  `CodStrada` VARCHAR(12) NOT NULL COMMENT 'Codice della strada di questo indirizzo',
  `Civico` VARCHAR(16) NULL DEFAULT NULL COMMENT 'Numero Civico di questo indirizzo. Può essere NULL (Senza Numero)',
  `Esponente` VARCHAR(16) NULL DEFAULT NULL COMMENT 'Eventuale esponente del civico (A,B,C,bis,ter,quater,...)',
  PRIMARY KEY (`CodIndirizzo`),
  CONSTRAINT `fk_Indirizzo_StradaUrbana`
    FOREIGN KEY (`CodStrada`)
    REFERENCES `stradaurbana` (`CodStrada`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contiene tutti i numeri civici di una strada';

CREATE INDEX `fk_Indirizzo_StradaUrbana_idx` ON `indirizzo` (`CodStrada` ASC);


-- -----------------------------------------------------
-- Table `utente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `utente` ;

CREATE TABLE IF NOT EXISTS `utente` (
  `CodFiscale` VARCHAR(16) NOT NULL COMMENT 'Codice fiscale dell\'utente',
  `Cognome` VARCHAR(64) NOT NULL COMMENT 'Cognome dell\'utente',
  `Nome` VARCHAR(64) NOT NULL COMMENT 'Nome dell\'utente',
  `CodIndirizzo` VARCHAR(12) NOT NULL COMMENT 'Codice dell\'indirizzo di residenza',
  `Telefono` VARCHAR(16) NOT NULL COMMENT 'Numero di telefono dell\'utente; necessario per comunicazioni relativi al servizio',
  `Stato` VARCHAR(8) NOT NULL COMMENT 'Stato dell\'utente:\nINATTIVO: all\'atto dell\'iscrizione\nATTIVO: dopo la verifica dell\'identità',
  `DataIscrizione` DATETIME NOT NULL COMMENT 'Data in cui l\'utente si iscrive al servizio',
  PRIMARY KEY (`CodFiscale`),
  CONSTRAINT `fk_Utente_Indirizzo`
    FOREIGN KEY (`CodIndirizzo`)
    REFERENCES `indirizzo` (`CodIndirizzo`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Anagrafica degli utenti del sistema';

CREATE INDEX `fk_Utente_Indirizzo_idx` ON `utente` (`CodIndirizzo` ASC);


-- -----------------------------------------------------
-- Table `account`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `account` ;

CREATE TABLE IF NOT EXISTS `account` (
  `CodFiscale` VARCHAR(16) NOT NULL COMMENT 'Codice fiscale dell\'utente identificato da questo account',
  `Username` VARCHAR(32) NOT NULL COMMENT 'Username dell\'account',
  `Password` VARCHAR(16) NOT NULL COMMENT 'Password dell\'account (criptata MD5)',
  `DomandaDiRiserva` VARCHAR(128) NULL DEFAULT NULL COMMENT 'Domanda di riserva per il recupero della password in caso di smarrimento',
  `Risposta` VARCHAR(128) NULL DEFAULT NULL COMMENT 'Risposta segreta per il recupero della password in caso di smarrimento (criptata MD5)',
  PRIMARY KEY (`CodFiscale`),
  CONSTRAINT `fk_Account_Utente`
    FOREIGN KEY (`CodFiscale`)
    REFERENCES `utente` (`CodFiscale`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Anagrafica degli account associati agli utenti. Può esserci un solo account per utente';

CREATE UNIQUE INDEX `uk_Account_Username` ON `account` (`Username` ASC);

CREATE INDEX `fk_Account_Utente_idx` ON `account` (`CodFiscale` ASC);


-- -----------------------------------------------------
-- Table `aspettovalutabile`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `aspettovalutabile` ;

CREATE TABLE IF NOT EXISTS `aspettovalutabile` (
  `CodAspettoValutabile` VARCHAR(12) NOT NULL COMMENT 'Codice univoco dellaspetto valutabile',
  `Descrizione` VARCHAR(32) NULL DEFAULT NULL COMMENT 'Breve descrizione dellaspetto valutabile',
  PRIMARY KEY (`CodAspettoValutabile`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Anagrafica degli aspetti valutabili di un utente (PERSONALITA, COMPORTAMENTO, SERIETA, COMFORT_VIAGGIO). La valutazione di ogni aspetto valutabile è espresso in numero di stelle da 1 a 5';


-- -----------------------------------------------------
-- Table `autovettura`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `autovettura` ;

CREATE TABLE IF NOT EXISTS `autovettura` (
  `NumTarga` VARCHAR(8) NOT NULL COMMENT 'Numero di targa dellautovettura',
  `CasaProduttrice` VARCHAR(32) NULL DEFAULT NULL COMMENT 'Nome della casa produttrice dell\'autovettura ',
  `Modello` VARCHAR(16) NULL DEFAULT NULL COMMENT 'Nome del modello dell\'autovettura ',
  PRIMARY KEY (`NumTarga`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Anagrafica delle autovetture note al sistema (ossia quelle r';


-- -----------------------------------------------------
-- Table `proponente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `proponente` ;

CREATE TABLE IF NOT EXISTS `proponente` (
  `CodFiscale` VARCHAR(16) NOT NULL COMMENT 'Codice fiscale dell\'utente proponente',
  PRIMARY KEY (`CodFiscale`),
  CONSTRAINT `fk_Proponente_Utente`
    FOREIGN KEY (`CodFiscale`)
    REFERENCES `utente` (`CodFiscale`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Sottoinsieme degli utenti del sistema che possono assumere il ruolo di PROPONENTI';


-- -----------------------------------------------------
-- Table `autovetturaregistrata`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `autovetturaregistrata` ;

CREATE TABLE IF NOT EXISTS `autovetturaregistrata` (
  `NumTarga` VARCHAR(8) NOT NULL COMMENT 'Numero di targa dell\'autovettura',
  `CodFiscale` VARCHAR(16) NOT NULL COMMENT 'Codice fiscale dellutente proponente che ha registrato questa autovettura',
  `NumPosti` DECIMAL(2,0) NULL DEFAULT NULL COMMENT 'Numero di posti massimo per cui questa autovettura è omologata',
  `Cilindrata` DECIMAL(5,0) NULL DEFAULT NULL COMMENT 'Cilindrata espressa in centimetri cubici (cc) di questa autovettura',
  `AnnoImmatricolazione` DECIMAL(4,0) NULL DEFAULT NULL COMMENT 'Anno di immatricolazione di questa autovettura',
  `Comfort` DECIMAL(3,2) NULL DEFAULT NULL COMMENT 'Numero da 1 a 5 (con eventualmente due cifre decimali) che esprime il valore (misurato in numero di stelle) del comfort di questa auto',
  `VelocitaMax` DECIMAL(5,2) NULL DEFAULT NULL COMMENT 'Velocità massima espressa in Km/h raggiungibile da questa autovettura',
  `CapacitaSerbatoio` DECIMAL(3,0) NULL DEFAULT NULL COMMENT 'Capacità espressa in litri del serbatoio di questa autovettura',
  `TipoAlimentazione` VARCHAR(16) NULL DEFAULT NULL COMMENT 'BENZINA; DIESEL; GPL; METANO; ELETTRICITA',
  PRIMARY KEY (`NumTarga`),
  CONSTRAINT `fk_AutovetturaRegistrata_Autovettura`
    FOREIGN KEY (`NumTarga`)
    REFERENCES `autovettura` (`NumTarga`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Autovettura_Proponente`
    FOREIGN KEY (`CodFiscale`)
    REFERENCES `proponente` (`CodFiscale`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Anagrafica delle autovetture registrate dai proponenti per l\'espletamento di un servizio';

CREATE INDEX `fk_Autovettura_Proponente_idx` ON `autovetturaregistrata` (`CodFiscale` ASC);


-- -----------------------------------------------------
-- Table `autocarpooling`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `autocarpooling` ;

CREATE TABLE IF NOT EXISTS `autocarpooling` (
  `NumTarga` VARCHAR(8) NOT NULL COMMENT 'Numero di targa dell\'autovettura',
  PRIMARY KEY (`NumTarga`),
  CONSTRAINT `fk_AutoCarPooling_AutovetturaRegistrata`
    FOREIGN KEY (`NumTarga`)
    REFERENCES `autovetturaregistrata` (`NumTarga`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Sottinsieme delle autovetture registrate che svolgono il servizio di Car Pooling';


-- -----------------------------------------------------
-- Table `autocarsharing`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `autocarsharing` ;

CREATE TABLE IF NOT EXISTS `autocarsharing` (
  `NumTarga` VARCHAR(8) NOT NULL COMMENT 'Numero di targa della vettura.',
  `Disponibilita` VARCHAR(16) NULL DEFAULT NULL COMMENT 'DISPONIBILE, NOLEGGIATA',
  PRIMARY KEY (`NumTarga`),
  CONSTRAINT `fk_AutoCarSharing_AutovetturaRegistrata`
    FOREIGN KEY (`NumTarga`)
    REFERENCES `autovetturaregistrata` (`NumTarga`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Sottoinsieme di tutte le autovetture utilizzabili per il servizio di Car Sharing (CS)';

CREATE INDEX `fk_AutoCarSharing_Autovettura_idx` ON `autocarsharing` (`NumTarga` ASC);


-- -----------------------------------------------------
-- Table `fruitore`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fruitore` ;

CREATE TABLE IF NOT EXISTS `fruitore` (
  `CodFiscale` VARCHAR(16) NOT NULL COMMENT 'Codice fiscale dell\'utente fruitore',
  PRIMARY KEY (`CodFiscale`),
  CONSTRAINT `fk_Fruitore_Utente`
    FOREIGN KEY (`CodFiscale`)
    REFERENCES `utente` (`CodFiscale`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Sottoinsieme degli utenti del sistema che possono assumere il ruolo di FRUITORI';


-- -----------------------------------------------------
-- Table `prenotazionecs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `prenotazionecs` ;

CREATE TABLE IF NOT EXISTS `prenotazionecs` (
  `CodPrenotazione` VARCHAR(12) NOT NULL COMMENT 'Codice univoco della prenotazione. Se la prenotazione diventa il CodNoleggio della tabella Noleggio',
  `CFFruitore` VARCHAR(16) NOT NULL COMMENT 'Codice fiscale dell\'utente fruitore che effettua la prenotazione',
  `NumTarga` VARCHAR(8) NOT NULL COMMENT 'Numero targa dell\'autovettura che il fruitore intende noleggiare',
  `DataIni` DATE NOT NULL COMMENT 'Data iniziale della prenotazione del noleggio',
  `DataFin` DATE NOT NULL COMMENT 'Data finale della prenotazione di noleggio',
  `Stato` VARCHAR(16) NOT NULL COMMENT 'NUOVA\nACCETTATA\nRIFIUTATA',
  PRIMARY KEY (`CodPrenotazione`),
  CONSTRAINT `fk_PrenotazioneCS_AutoCarSharing`
    FOREIGN KEY (`NumTarga`)
    REFERENCES `autocarsharing` (`NumTarga`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_PrenotazioneCS_Fruitore`
    FOREIGN KEY (`CFFruitore`)
    REFERENCES `fruitore` (`CodFiscale`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contiene tutte le prenotazioni che un fruitore effettua per una certa autovettura registrata per il servizio di Car Sharing. Per ogni prenotazione viene creata un nuovo CodPrenotazione. La terna (CFFruitore, Targa, DataIni) deve essere univoca.';

CREATE UNIQUE INDEX `uk_PrenotazioneCS` ON `prenotazionecs` (`CFFruitore` ASC, `NumTarga` ASC, `DataIni` ASC);

CREATE INDEX `fk_PrenotazioneCS_Fruitore_idx` ON `prenotazionecs` (`CFFruitore` ASC);

CREATE INDEX `fk_PrenotazioneCS_AutoCarSharing_idx` ON `prenotazionecs` (`NumTarga` ASC);


-- -----------------------------------------------------
-- Table `noleggio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `noleggio` ;

CREATE TABLE IF NOT EXISTS `noleggio` (
  `CodNoleggio` VARCHAR(12) NOT NULL COMMENT 'Codice univoco del noleggio.',
  `CodPrenotazione` VARCHAR(12) NOT NULL COMMENT 'Codice della prenotazione da cui questo noleggio ha origine.',
  `QtaCarburanteIni` DECIMAL(7,0) NULL DEFAULT NULL COMMENT 'Quantità di carburante con cui l\'autovettura viene consegnata al fruitore all\'inizio del noleggio.',
  `KmPercorsiIni` DECIMAL(7,0) NULL DEFAULT NULL COMMENT 'Numero di chilometri segnati sul contachilometri (e rilevati dalla sensoristica installata presso il proponente) dell\'autovettura al momento della consegna al fruitore all\'inizio del noleggio.',
  `QtaCarburanteFin` DECIMAL(7,0) NULL DEFAULT NULL COMMENT 'Quantità di carburante con cui l\'autovettura viene riconsegnata dal fruitore alla fine del noleggio.',
  `KmPercorsiFin` DECIMAL(7,0) NULL DEFAULT NULL COMMENT 'Numero di chilometri segnati sul contachilometri (e rilevati dalla sensoristica installata presso il proponente) dell\'autovettura al momento della riconsegna al proponente alla fine del noleggio.',
  PRIMARY KEY (`CodNoleggio`),
  CONSTRAINT `fk_Noleggio_PrenotazioneCS`
    FOREIGN KEY (`CodPrenotazione`)
    REFERENCES `prenotazionecs` (`CodPrenotazione`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contiene tutti i noleggi effettuati (ossia le prenotazioni che sono state accettate dal proponente).\nAlla consegna, AUTOVETTURA_CS.Disponibilita deve diventare NOLEGGIATA;\nAlla riconsegna, la sensoristica rileverà la quantità di carburante presente nell\'autovettura e se la quantità rilevata è inferiore al valore registrato nel campo QtaCarburante, oltre una certa soglia di tolleranza, la riconsegna viene impedita e il fruitore deve provvedere al rimbocco di carburante presso un distributore. Alla riconsegna AUTOVETTURA_CS.Disponibilita deve diventare DISPONIBILE';

CREATE INDEX `fk_Noleggio_PrenotazioneCS` ON `noleggio` (`CodPrenotazione` ASC);


-- -----------------------------------------------------
-- Table `posizione`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `posizione` ;

CREATE TABLE IF NOT EXISTS `posizione` (
  `CodPosizione` VARCHAR(12) NOT NULL COMMENT 'Codice univoco della posizione',
  `Latitudine` DECIMAL(10,7) NOT NULL COMMENT 'Latitudine di questa posizione geografica. La latitudine di una posizione geografica è la distanza angolare dall\'equatore, misurata in gradi e frazioni di grado lungo l\'arco del meridiano passante per quella posizione',
  `Longitudine` DECIMAL(10,7) NOT NULL COMMENT 'Longitudine di questa posizione geografica. La longitudine di una posizione geografica è la distanza angolare dal meridiano fondamentale di Greenwich, misurata in gradi e frazioni di grado lungo l\'arco del parallelo passante per quella posizione',
  `CodStrada` VARCHAR(12) NULL DEFAULT NULL,
  `Chilometro` DECIMAL(9,3) NULL DEFAULT NULL COMMENT 'Chilometro della strada di questa posizione CHILOMETRICA. Indica anche la distanza dal punto di inizio della strada.',
  `CodIndirizzo` VARCHAR(12) NULL DEFAULT NULL,
  PRIMARY KEY (`CodPosizione`),
  CONSTRAINT `fk_Posizione_Indirizzo1`
    FOREIGN KEY (`CodIndirizzo`)
    REFERENCES `indirizzo` (`CodIndirizzo`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Posizione_Strada1`
    FOREIGN KEY (`CodStrada`)
    REFERENCES `strada` (`CodStrada`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Anagrafica della posizioni GEOGRAFICHE comuni ad ogni tipo di posizione (sia CHILOMETRICA sia INDIRIZZO)';

CREATE INDEX `fk_Posizione_Strada1_idx` ON `posizione` (`CodStrada` ASC);

CREATE INDEX `fk_Posizione_Indirizzo1_idx` ON `posizione` (`CodIndirizzo` ASC);


-- -----------------------------------------------------
-- Table `sinistro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sinistro` ;

CREATE TABLE IF NOT EXISTS `sinistro` (
  `CodSinistro` VARCHAR(12) NOT NULL COMMENT 'Codice univoco del sinistro',
  `CodNoleggio` VARCHAR(12) NOT NULL COMMENT 'Codice del noleggio durante il quale si è verificato il sinistro. Da esso si ricava il fruitore del noleggio e la targa dell\'auto noleggiata che è rimasta coinvolta nel sinistro',
  `DataOraSinistro` DATETIME NULL DEFAULT NULL COMMENT 'Data e ora del sinistro',
  `CodPosizione` VARCHAR(12) NOT NULL COMMENT 'Codice della posizione del sinistro. Deve essere una posizione CHILOMETRICA e/o una posizione GEOGRAFICA',
  `Dinamica` VARCHAR(256) NULL DEFAULT NULL COMMENT 'Descrizione libera della dinamica dellincidente',
  PRIMARY KEY (`CodSinistro`),
  CONSTRAINT `fk_Sinistro_Noleggio`
    FOREIGN KEY (`CodNoleggio`)
    REFERENCES `noleggio` (`CodNoleggio`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Sinistro_Posizione`
    FOREIGN KEY (`CodPosizione`)
    REFERENCES `posizione` (`CodPosizione`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contiene l\'elenco degli eventuali sinistri in cui l\'autovettura noleggiata rimane coinvolta';

CREATE UNIQUE INDEX `uk_Sinistro` ON `sinistro` (`CodNoleggio` ASC, `DataOraSinistro` ASC);

CREATE INDEX `fk_Sinistro_Noleggio_idx` ON `sinistro` (`CodNoleggio` ASC);

CREATE INDEX `fk_Sinistro_Posizione_idx` ON `sinistro` (`CodPosizione` ASC);


-- -----------------------------------------------------
-- Table `autocoinvolta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `autocoinvolta` ;

CREATE TABLE IF NOT EXISTS `autocoinvolta` (
  `CodSinistro` VARCHAR(12) NOT NULL,
  `NumTarga` VARCHAR(8) NOT NULL,
  PRIMARY KEY (`CodSinistro`, `NumTarga`),
  CONSTRAINT `fk_AutoCoinvolta_Autovettura1`
    FOREIGN KEY (`NumTarga`)
    REFERENCES `autovettura` (`NumTarga`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_AutoCoinvolta_Sinistro1`
    FOREIGN KEY (`CodSinistro`)
    REFERENCES `sinistro` (`CodSinistro`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE INDEX `fk_AutoCoinvolta_Autovettura1_idx` ON `autocoinvolta` (`NumTarga` ASC);


-- -----------------------------------------------------
-- Table `autoridesharing`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `autoridesharing` ;

CREATE TABLE IF NOT EXISTS `autoridesharing` (
  `NumTarga` VARCHAR(8) NOT NULL,
  PRIMARY KEY (`NumTarga`),
  CONSTRAINT `fk_AutoRideSharing_AutovetturaRegistrata`
    FOREIGN KEY (`NumTarga`)
    REFERENCES `autovetturaregistrata` (`NumTarga`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Sottoinsieme di tutte le autovetture utilizzabili per il servizio di Ride Sharing (RS)';


-- -----------------------------------------------------
-- Table `carreggiata`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `carreggiata` ;

CREATE TABLE IF NOT EXISTS `carreggiata` (
  `CodStrada` VARCHAR(12) NOT NULL COMMENT 'Identificativo della strada a cui appartiene questa carreggiata',
  `NumCarreggiata` TINYINT(4) NOT NULL,
  `NumCorsie` TINYINT(4) NULL DEFAULT NULL COMMENT 'Numero di corsie di questa carreggiata',
  `NumSensiMarcia` TINYINT(4) NULL DEFAULT NULL COMMENT 'Numero dei sensi dei marcia della carreggiata. Se uguale a 1 la carreggiata è \"a senso unico\"',
  PRIMARY KEY (`CodStrada`, `NumCarreggiata`),
  CONSTRAINT `fk_Carreggiata_Strada`
    FOREIGN KEY (`CodStrada`)
    REFERENCES `strada` (`CodStrada`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Elenca, per ogni strada, le sue carreggiate. Ogni carreggiata il numero di corsie e il numero di sensi si marcia';


-- -----------------------------------------------------
-- Table `categoriastrada`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `categoriastrada` ;

CREATE TABLE IF NOT EXISTS `categoriastrada` (
  `CodCategStrada` VARCHAR(8) NOT NULL COMMENT 'Codice univoco della categoria strada',
  `Descrizione` VARCHAR(16) NOT NULL COMMENT 'Descrizione della categoria strada',
  PRIMARY KEY (`CodCategStrada`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Anagrafica delle categorie di strade extraurbane:\ndir=diramazione; var=variante; racc=raccordo; radd=raddoppio; bis=bis; ter=ter; quater=quater, ...';


-- -----------------------------------------------------
-- Table `cfg_progressivo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cfg_progressivo` ;

CREATE TABLE IF NOT EXISTS `cfg_progressivo` (
  `tipo` VARCHAR(3) NOT NULL COMMENT 'Definisce il tipo di progressivo da generare',
  `progressivo` INT(11) NOT NULL COMMENT 'Prossimo progressivo di questo tipo da usare',
  `ownerTable` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`tipo`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `tragitto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tragitto` ;

CREATE TABLE IF NOT EXISTS `tragitto` (
  `CodTragitto` VARCHAR(12) NOT NULL COMMENT 'Codice univoco del tragitto',
  `CodPosizioneP` VARCHAR(12) NOT NULL,
  `CodPosizioneA` VARCHAR(12) NULL DEFAULT NULL,
  PRIMARY KEY (`CodTragitto`),
  CONSTRAINT `fk_Tragitto_PosizioneA`
    FOREIGN KEY (`CodPosizioneA`)
    REFERENCES `posizione` (`CodPosizione`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Tragitto_PosizioneP`
    FOREIGN KEY (`CodPosizioneP`)
    REFERENCES `posizione` (`CodPosizione`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Anagrafica dei tragitti effettuati delle varie vetture del sistema.';

CREATE INDEX `fk_Tragitto_Posizione1_idx` ON `tragitto` (`CodPosizioneP` ASC);

CREATE INDEX `fk_Tragitto_Posizione1_idx1` ON `tragitto` (`CodPosizioneA` ASC);


-- -----------------------------------------------------
-- Table `tragittoprogrammato`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tragittoprogrammato` ;

CREATE TABLE IF NOT EXISTS `tragittoprogrammato` (
  `CodTragitto` VARCHAR(12) NOT NULL,
  `Lunghezza` DECIMAL(9,3) NULL DEFAULT NULL,
  `TipoPercorso` CHAR(1) NULL DEFAULT NULL COMMENT 'Indica il tipo di percorso del tragitto sulla base della tipologia delle singole tratte:\nU: se le tratte del tragitto sono tutte urbane; X: se le tratte del tragitto sono tutte extraurbane; M: se le tratte del tragitto sono miste (un po urbane un po extraurbane)',
  PRIMARY KEY (`CodTragitto`),
  CONSTRAINT `fk_TragittoProgrammato_Tragitto1`
    FOREIGN KEY (`CodTragitto`)
    REFERENCES `tragitto` (`CodTragitto`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Sottoinsieme dei tragitti che devono essere programmati anticipatamente per poter inserire un Pool (del servizio CarPooling) o una Sharing (del servizio RideSharing)';

CREATE INDEX `fk_TragittoProgrammato_Tragitto1_idx` ON `tragittoprogrammato` (`CodTragitto` ASC);


-- -----------------------------------------------------
-- Table `sharing`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sharing` ;

CREATE TABLE IF NOT EXISTS `sharing` (
  `CodSharing` VARCHAR(12) NOT NULL COMMENT 'Codice univoco dello sharing',
  `NumTarga` VARCHAR(8) NOT NULL COMMENT 'Numero di targa dellauto che svolge questo servizio di sharing',
  `CodTragittoPrg` VARCHAR(12) NOT NULL,
  `DataPartenza` DATE NOT NULL COMMENT 'Data di partenza (dal punto iniziale del tragitto)',
  `OraPartenza` TIME NOT NULL COMMENT 'Ora di partenza (dal punto iniziale del tragitto)',
  PRIMARY KEY (`CodSharing`),
  CONSTRAINT `fk_Sharing_AutoRideSharing`
    FOREIGN KEY (`NumTarga`)
    REFERENCES `autoridesharing` (`NumTarga`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Sharing_TragittoProgrammato1`
    FOREIGN KEY (`CodTragittoPrg`)
    REFERENCES `tragittoprogrammato` (`CodTragitto`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contiene gli sharing (viaggi programmati da un proponente) effettuati da autovetture durante il servizio di Ride Sharing.';

CREATE INDEX `fk_Sharing_AutoRideSharing_idx` ON `sharing` (`NumTarga` ASC);

CREATE INDEX `fk_Sharing_TragittoProgrammato1_idx` ON `sharing` (`CodTragittoPrg` ASC);


-- -----------------------------------------------------
-- Table `chiamata`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `chiamata` ;

CREATE TABLE IF NOT EXISTS `chiamata` (
  `CodChiamata` VARCHAR(12) NOT NULL COMMENT 'Codice univoco della chiamata',
  `CFFruitore` VARCHAR(16) NOT NULL COMMENT 'Codice fiscale dellutente fruitore che ha inserito la chiamata',
  `CodSharing` VARCHAR(12) NOT NULL COMMENT 'Codice dello sharing per il quale lutente fruitore ha inserito la chiamata',
  `CodPosizioneFruitore` VARCHAR(12) NOT NULL COMMENT 'Codice della posizione CHILOMETRICA del fruitore che ha inserito questa chiamata',
  `CodPosizioneDestinazione` VARCHAR(12) NOT NULL COMMENT 'Codice della posizione CHILOMETRICA della destinazione alla quale il fruitore desidera andare.',
  `DataOraChiamata` DATETIME NOT NULL COMMENT 'Data e ora in cui lutente fruitore ha inserito la chiamata',
  `Stato` VARCHAR(8) NULL DEFAULT NULL COMMENT 'Stato della chiamata. Può essere PENDING, REJECTED, ACCEPTED',
  `DataOraRisposta` DATETIME NULL DEFAULT NULL COMMENT 'è la data e ora (timestamp) in cui lutente proponente risponde alla chiamata e coincide con il momento in cui la chiamata assume lo stato finale di ACCEPTED o REJECTED.',
  PRIMARY KEY (`CodChiamata`),
  CONSTRAINT `fk_Chiamata_Fruitore`
    FOREIGN KEY (`CFFruitore`)
    REFERENCES `fruitore` (`CodFiscale`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Chiamata_PosizioneD`
    FOREIGN KEY (`CodPosizioneDestinazione`)
    REFERENCES `posizione` (`CodPosizione`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Chiamata_PosizioneF`
    FOREIGN KEY (`CodPosizioneFruitore`)
    REFERENCES `posizione` (`CodPosizione`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Chiamata_Sharing`
    FOREIGN KEY (`CodSharing`)
    REFERENCES `sharing` (`CodSharing`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contiene le chiamate che gli utenti fruitori inseriscono (in base alla reputazione del proponente, ma anche sulla base della rapidità con cui il proponente è in grado di raggiungere la posizione in cui si trova il fruitore) per richiedere un servizio di Ride Sharing.\nOgni chiamata è inizialmente nello stato PENDING (in attesa), REJECTED (rifiutata) o ACCEPTED (accettata)';

CREATE INDEX `fk_Chiamata_Fruitore_idx` ON `chiamata` (`CFFruitore` ASC);

CREATE INDEX `fk_Chiamata_Sharing_idx` ON `chiamata` (`CodSharing` ASC);

CREATE INDEX `fk_Chiamata_PosizioneF_idx` ON `chiamata` (`CodPosizioneFruitore` ASC);

CREATE INDEX `fk_Chiamata_PosizioneD_idx` ON `chiamata` (`CodPosizioneDestinazione` ASC);


-- -----------------------------------------------------
-- Table `tragittotracciato`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tragittotracciato` ;

CREATE TABLE IF NOT EXISTS `tragittotracciato` (
  `CodTragitto` VARCHAR(12) NOT NULL,
  PRIMARY KEY (`CodTragitto`),
  CONSTRAINT `fk_TragittoTracciato_Tragitto1`
    FOREIGN KEY (`CodTragitto`)
    REFERENCES `tragitto` (`CodTragitto`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Sottoinsieme dei tragitti che sono tracciati in tempo reale mediante i messaggi di tracciamento provenienti dalle auto registrate';

CREATE INDEX `fk_TragittoTracciato_Tragitto1_idx` ON `tragittotracciato` (`CodTragitto` ASC);


-- -----------------------------------------------------
-- Table `corsa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `corsa` ;

CREATE TABLE IF NOT EXISTS `corsa` (
  `CodChiamata` VARCHAR(12) NOT NULL COMMENT 'Codice chiamata (accepted) che ha dato origine a questa corsa ',
  `CodTragittoTrc` VARCHAR(12),
  `DataOraInizioCorsa` DATETIME NOT NULL COMMENT 'Data e ora (timestamp) dellinizio della corsa',
  `DataOraFineCorsa` DATETIME NULL DEFAULT NULL COMMENT 'Data e ora (timestamp) della fine della corsa',
  PRIMARY KEY (`CodChiamata`),
  CONSTRAINT `fk_Corsa_Chiamata`
    FOREIGN KEY (`CodChiamata`)
    REFERENCES `chiamata` (`CodChiamata`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Corsa_TragittoTracciato1`
    FOREIGN KEY (`CodTragittoTrc`)
    REFERENCES `tragittotracciato` (`CodTragitto`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Corsa che viene effettuate nellambito del servizio di Ride Sharing a seguito di una chiamata ACCEPTED.';

CREATE INDEX `fk_Corsa_TragittoTracciato1_idx` ON `corsa` (`CodTragittoTrc` ASC);


-- -----------------------------------------------------
-- Table `costoautovettura`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `costoautovettura` ;

CREATE TABLE IF NOT EXISTS `costoautovettura` (
  `NumTarga` VARCHAR(8) NOT NULL,
  `NumPasseggeri` DECIMAL(2,0) NOT NULL COMMENT 'Numero di passeggeri che (in base al peso totale) determinano i costi tecnici di questa autovettura',
  `CostoOperativo` DECIMAL(12,5) NOT NULL COMMENT 'Costo operativo, espresso in EUR/km, di questa autovettura quando viaggia con questo numero passeggeri',
  `CostoUsura` DECIMAL(12,5) NOT NULL COMMENT 'Costo dell\'usura, espresso in EUR/Km, di questa autovettura quando viaggia con questo numero passeggeri',
  `ConsumoU` DECIMAL(5,3) NOT NULL COMMENT 'Consumo medio urbano, espresso in l/100Km, di questa autovettura',
  `ConsumoXU` DECIMAL(5,3) NOT NULL COMMENT 'Consumo medio extra urbano, espresso il l/100km, di questa autovettura',
  `ConsumoM` DECIMAL(5,3) NOT NULL COMMENT 'Consumo medio misto (ossia su percorsi in parte urbani e in parte extra urbani), espresso il l/100km, di questa autovettura',
  PRIMARY KEY (`NumTarga`, `NumPasseggeri`),
  CONSTRAINT `fk_CostoAutovettura_AutovetturaRegistrata`
    FOREIGN KEY (`NumTarga`)
    REFERENCES `autovetturaregistrata` (`NumTarga`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Anagrafica delle caratteristiche dell\'autovettura che contribuiscono a determinare il costo di di un viaggio fatto con questa autovettura';


-- -----------------------------------------------------
-- Table `documentoriconoscimento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `documentoriconoscimento` ;

CREATE TABLE IF NOT EXISTS `documentoriconoscimento` (
  `CodFiscale` VARCHAR(16) NOT NULL COMMENT 'Codice fiscale dell\'utente identificato da questo documento di riconoscimento',
  `TipoDocumento` VARCHAR(3) NOT NULL COMMENT 'Tipo del documento (CI=Carta d\'Identità; P=Patente, PP=Passaporto, ...)',
  `EnteRilascio` VARCHAR(64) NOT NULL COMMENT 'Ente che ha rilasciato il documento (es: COMUNE DI PISA, PREFETTURA DI LA SPEZIA, ...)',
  `NumeroDocumento` VARCHAR(16) NOT NULL COMMENT 'Numero del documento.',
  `Scadenza` DATE NOT NULL COMMENT 'Data di scadenza del documento',
  PRIMARY KEY (`CodFiscale`),
  CONSTRAINT `fk_DocumentoRiconoscimento_Utente`
    FOREIGN KEY (`CodFiscale`)
    REFERENCES `utente` (`CodFiscale`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Anagrafica dei documenti di riconoscimento';


-- -----------------------------------------------------
-- Table `fasciaoraria`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fasciaoraria` ;

CREATE TABLE IF NOT EXISTS `fasciaoraria` (
  `CodFascia` VARCHAR(12) NOT NULL COMMENT 'Codice univoco della fascia oraria',
  `OraIni` TIME NULL DEFAULT NULL COMMENT 'Orario di inizio della fascia oraria',
  `OraFin` TIME NULL DEFAULT NULL COMMENT 'Orario di fine della fascia oraria',
  PRIMARY KEY (`CodFascia`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Anagrafica delle fasce orarie di interesse';


-- -----------------------------------------------------
-- Table `fruibilita`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fruibilita` ;

CREATE TABLE IF NOT EXISTS `fruibilita` (
  `NumTarga` VARCHAR(8) NOT NULL,
  `ProgrFascia` INT(11) NOT NULL COMMENT 'Progressivo della fascia:',
  `TipoFruibilita` VARCHAR(3) NOT NULL COMMENT 'PER=Periodica (es. tutti i lunedì dalle ... alle ...)\nFAS=Fascia (da Giorno1Ora1 a Giorno2Ora2)',
  `NomeGiorno` VARCHAR(3) NULL DEFAULT NULL COMMENT 'Valorizzato con LUN, MAR, ..., DOM quando TipoFruibilità = PER, altrimenti NULL',
  `GiornoIni` DATE NULL DEFAULT NULL COMMENT 'Giorno iniziale della fascia di fruibilità, quando TipoFruibilita=FAS, altrimenti NULL',
  `GiornoFin` DATE NULL DEFAULT NULL COMMENT 'Giorno Finale della fascia di fruibilità, quando TipoFruibilita=FAS, altrimenti NULL',
  `OraIni` TIME NULL DEFAULT NULL COMMENT 'Orario iniziale della fascia di fruibilità. Per una fruibilità a fasce è lora a partire dalla quale la vettura è disponibile il primo giorno.',
  `OraFin` TIME NULL DEFAULT NULL COMMENT 'Orario finale della fascia di fruibilità. Per una fruibilità a fasce è lora entro la quale la vettura deve essere riconsegnata lultimo giorno.',
  PRIMARY KEY (`ProgrFascia`, `NumTarga`),
  CONSTRAINT `fk_Fruibilita_AutoCarSharing`
    FOREIGN KEY (`NumTarga`)
    REFERENCES `autocarsharing` (`NumTarga`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Tabella delle fasce orarie di fruibilità di questa autovettura. La fruibilità può essere PERIODICA (es. tutti i LUN dalle 8:00 alle 20:00) oppure per fasce specifiche (es. dalle 08:00 del giorno 01/08/2018 fino alle 20:00 del 31/08/2018)\nCHECK per TipoFruibilita=PER: non devono esistere record con lo stesso NomeGiorno e con fasce orarie che si accavallano;\nCHECK per TipoFruibilita=FAS: Occorre controllare che non esistano due record con intervalli di giorni che si accavallano';

CREATE INDEX `fk_Fruibilita_AutoCarSharing_idx` ON `fruibilita` (`NumTarga` ASC);


-- -----------------------------------------------------
-- Table `incrocio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `incrocio` ;

CREATE TABLE IF NOT EXISTS `incrocio` (
  `CodIncrocio` VARCHAR(12) NOT NULL COMMENT 'Codice univoco dell\'incrocio. La quaterna (CodStrada, Posizione, CodStradaX, PosizioneX) deve essere univoca',
  `CodStrada` VARCHAR(12) NOT NULL COMMENT 'Codice univoco della strada che ha questo incrocio',
  `NumCarreggiata` TINYINT(4) NOT NULL COMMENT 'Numero della carreggiata in cui si trova l\'incrocio',
  `CodPosizione` VARCHAR(12) NOT NULL COMMENT 'Posizione CHILOMETRICA alla quale si trova questo incrocio',
  `CodStradaX` VARCHAR(12) NOT NULL COMMENT 'Codice univoco della strada che si incrocia con questa',
  `NumCarreggiataX` TINYINT(4) NOT NULL COMMENT 'Numero della carreggiata in cui si trova l\'incrocio sulla strada che si incrocia con questa',
  `CodPosizioneX` VARCHAR(12) NOT NULL COMMENT 'Posizione CHILOMETRICA dell\'incrocio rispetto alla strada che viene incrociata',
  PRIMARY KEY (`CodIncrocio`),
  CONSTRAINT `fk_Incrocio_Carreggiata`
    FOREIGN KEY (`CodStrada` , `NumCarreggiata`)
    REFERENCES `carreggiata` (`CodStrada` , `NumCarreggiata`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Incrocio_CarreggiataX`
    FOREIGN KEY (`CodStradaX` , `NumCarreggiataX`)
    REFERENCES `carreggiata` (`CodStrada` , `NumCarreggiata`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Incrocio_Posizione`
    FOREIGN KEY (`CodPosizione`)
    REFERENCES `posizione` (`CodPosizione`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Incrocio_PosizioneX`
    FOREIGN KEY (`CodPosizioneX`)
    REFERENCES `posizione` (`CodPosizione`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Elenco degli incroci che \"attraversano\" l\'unica carreggiata di una strada. Le strade che possono avere degli incroci sono solo le SUR (Strada Urbana) e le SXS (Strada Extraurbana Secondaria) con al più una corsia per senso di marcia. All\'atto dell\'inserimento di un incrocio il sistema deve controllare che questo vincolo sia rispettato analizzando le caratteristiche delle due strade che si incrociano.';

CREATE INDEX `fk_Incrocio_Carreggiata_idx` ON `incrocio` (`CodStrada` ASC, `NumCarreggiata` ASC);

CREATE INDEX `fk_Incrocio_CarreggiataX_idx` ON `incrocio` (`CodStradaX` ASC, `NumCarreggiataX` ASC);

CREATE INDEX `fk_Incrocio_Posizione_idx` ON `incrocio` (`CodPosizione` ASC);

CREATE INDEX `fk_Incrocio_PosizioneX_idx` ON `incrocio` (`CodPosizioneX` ASC);


-- -----------------------------------------------------
-- Table `limitevelocita`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `limitevelocita` ;

CREATE TABLE IF NOT EXISTS `limitevelocita` (
  `CodStrada` VARCHAR(12) NOT NULL COMMENT 'Codice univoco della strada cui questo limite di velocità appartiene',
  `NumCarreggiata` TINYINT(4) NOT NULL COMMENT 'numero della carreggiata della strada in cui questo limite di velocità è posto',
  `CodPosizione` VARCHAR(12) NOT NULL COMMENT 'Codice della posizione CHILOMETRICA in cui è posto questo limite di velocità',
  `Limite` DECIMAL(5,2) NULL DEFAULT NULL COMMENT 'Valore, espresso in Km/h, di questo limite di velocità',
  CONSTRAINT `fk_LimiteVelocita_Carreggiata`
    FOREIGN KEY (`CodStrada` , `NumCarreggiata`)
    REFERENCES `carreggiata` (`CodStrada` , `NumCarreggiata`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_LimiteVelocita_Posizione`
    FOREIGN KEY (`CodPosizione`)
    REFERENCES `posizione` (`CodPosizione`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Elenca, per ogni strada, le posizioni in cui sono posti dei limiti di velocità.';

CREATE INDEX `fk_LimiteVelocita_Carreggiata_idx` ON `limitevelocita` (`CodStrada` ASC, `NumCarreggiata` ASC);

CREATE INDEX `fk_LimiteVelocita_Posizione_idx` ON `limitevelocita` (`CodPosizione` ASC);


-- -----------------------------------------------------
-- Table `optional`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `optional` ;

CREATE TABLE IF NOT EXISTS `optional` (
  `CodOptional` VARCHAR(16) NOT NULL COMMENT 'Codice univoco delloptional',
  `Descrizione` VARCHAR(64) NOT NULL COMMENT 'Breve descrizione delloptional',
  `TipoOptional` CHAR(1) NOT NULL COMMENT 'Tipo delloptional: P=Primario; S=Secondario',
  `Voto` DECIMAL(3,2) NULL DEFAULT NULL COMMENT 'Voto (0 < voto <= 5) delloptional. Obbligatorio per gli optional secondari.',
  PRIMARY KEY (`CodOptional`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Anagrafica degli optional che possono essere primari (TipoOptional=P) o secondari (TipoOptional=S). Gli optional primari sono quelli ritenuti indispensabili per il comfort di unautovettura e contribuiscono a 3/5 della sua valutazione finale. Ogni optional primario ha lo stesso voto (sottinteso e uguale a 3/Count(Optional primari)); ovviamente la somma dei voti (sottintesi) di tutti gli optional primari fa sempre 3.\nGli optional secondari sono quelli ritenuti graditi per il comfort di unautovettura. Essi contribuiscono al più 2/5 della valutazione finale dellautovettura. Ogni optional secondario ha un voto. La quota parte del valore del comfort finale dovuta agli optional secondari è calcolata come: SUM(voto degli optional presenti nellauto)/SUM(voto di tutti gli optional secondari) * 2. Il rapporto delle due somme è un numero compreso tra 0 e 1.\nIl voto di confort dellautovettura tiene anche conto della cilindrata secondo criteri specificati altrove.';


-- -----------------------------------------------------
-- Table `optionalauto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `optionalauto` ;

CREATE TABLE IF NOT EXISTS `optionalauto` (
  `NumTarga` VARCHAR(8) NOT NULL COMMENT 'Targa dell\'autovettura che ha questo optional',
  `CodOptional` VARCHAR(64) NOT NULL COMMENT 'Codice dell\'optional presente in questa autovettura',
  `Valore` DECIMAL(9,3) NULL DEFAULT NULL COMMENT 'Eventuale valore numerico dell\'optional (es. la capacità del bagagliaio è un optional di cui occorre specificare il valore in litri; il valore medio del rumore è un optional di cui occorre specificare il valore in dB)',
  `UnitaMisura` VARCHAR(16) NULL DEFAULT NULL COMMENT 'Unità di misura dell\'eventuale valore di questo optional (es; l=LITRI, dB=DECIBEL, ...)',
  PRIMARY KEY (`NumTarga`, `CodOptional`),
  CONSTRAINT `fk_OptionalAuto_AutovetturaRegistrata`
    FOREIGN KEY (`NumTarga`)
    REFERENCES `autovetturaregistrata` (`NumTarga`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_OptionalAuto_Optional`
    FOREIGN KEY (`CodOptional`)
    REFERENCES `optional` (`CodOptional`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Tabella della relazione n:m tra autovettura e optional; contiene per ogni autovettura l\'elenco dei suoi optional e per ogni optional l\'elenco delle autovettura che ce l\'hanno.';

CREATE INDEX `fk_OptionalAuto_Optional_idx` ON `optionalauto` (`CodOptional` ASC);


-- -----------------------------------------------------
-- Table `svincolo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `svincolo` ;

CREATE TABLE IF NOT EXISTS `svincolo` (
  `CodSvincolo` VARCHAR(12) NOT NULL COMMENT 'Codice univoco dello svincolo',
  `CodStrada` VARCHAR(12) NOT NULL COMMENT 'Codice univoco della strada in cui si trova lo svincolo',
  `NumCarreggiata` TINYINT(4) NOT NULL COMMENT 'Numero della carreggiata in cui si trova lo svincolo',
  `CodPosizione` VARCHAR(12) NOT NULL COMMENT 'Posizione CHILOMETRICA dello svincolo',
  `Tipo` CHAR(1) NOT NULL COMMENT 'Indica se lo svincolo è di Uscita (U) oppure di entrata (E)',
  PRIMARY KEY (`CodSvincolo`),
  CONSTRAINT `fk_Svincolo_Carreggiata`
    FOREIGN KEY (`CodStrada` , `NumCarreggiata`)
    REFERENCES `carreggiata` (`CodStrada` , `NumCarreggiata`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Svincolo_Posizione`
    FOREIGN KEY (`CodPosizione`)
    REFERENCES `posizione` (`CodPosizione`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Elenco degli svincoli di una strada. Le strade che possono avere svincoli sono: SXS (Strade Extraurbane Secondarie) con più di una corsia per almeno un senso di marcia; SXP (Strade Extraurbane Principali) e AUT (Autostrade).\nLa quaterna (CodStrada, NumCarreggiata, CodPosizione, Tipo) deve essere univoca.';

CREATE INDEX `fk_Svincolo_Carreggiata_idx` ON `svincolo` (`CodStrada` ASC, `NumCarreggiata` ASC);

CREATE INDEX `fk_Svincolo_Posizione_idx` ON `svincolo` (`CodPosizione` ASC);


-- -----------------------------------------------------
-- Table `pedaggio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pedaggio` ;

CREATE TABLE IF NOT EXISTS `pedaggio` (
  `CodSvincoloE` VARCHAR(12) NOT NULL COMMENT 'Codice dello svincolo di entrata. Deve essere uno svincolo autostradale.',
  `CodSvincoloU` VARCHAR(12) NOT NULL COMMENT 'Codice dello svincolo di Uscita. Deve essere uno svincolo autostradale. Potrebbe essere anche di un\'autostrada diversa da quella dello svincolo di entrata (vedi RACCORDI)',
  `Pedaggio` DECIMAL(9,2) NOT NULL COMMENT 'Importo, espresso in EURO, del pedaggio',
  PRIMARY KEY (`CodSvincoloE`, `CodSvincoloU`),
  CONSTRAINT `fk_Pedaggio_SvincoloE`
    FOREIGN KEY (`CodSvincoloE`)
    REFERENCES `svincolo` (`CodSvincolo`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Pedaggio_SvincoloU`
    FOREIGN KEY (`CodSvincoloU`)
    REFERENCES `svincolo` (`CodSvincolo`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Permette di specificate il pedaggio che si paga per percorrere un\'autostrada da uno svincolo a un altro.';

CREATE INDEX `fk_Pedaggio_SvincoloU_idx` ON `pedaggio` (`CodSvincoloU` ASC);


-- -----------------------------------------------------
-- Table `pietramiliare`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pietramiliare` ;

CREATE TABLE IF NOT EXISTS `pietramiliare` (
  `CodStrada` VARCHAR(12) NOT NULL COMMENT 'Codice univoco della strada cui questa pietra miliare appartiene',
  `NumCarreggiata` TINYINT(4) NOT NULL COMMENT 'Numero della carreggiata della strada in cui questa pietra miliare si trova',
  `CodPosizione` VARCHAR(12) NOT NULL COMMENT 'Codice della posizione CHILOMETRICA che individua la pietra miliare. La posizione individuata deve avere CodStrada uguale al CodStrada di questa strada e il Chilometro espresso come numero intero',
  PRIMARY KEY (`CodStrada`, `NumCarreggiata`, `CodPosizione`),
  CONSTRAINT `fk_PietraMiliare_Carreggiata`
    FOREIGN KEY (`CodStrada` , `NumCarreggiata`)
    REFERENCES `carreggiata` (`CodStrada` , `NumCarreggiata`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_PietraMiliare_Posizione`
    FOREIGN KEY (`CodPosizione`)
    REFERENCES `posizione` (`CodPosizione`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Elenco delle \"pietre miliari\" di una carreggiata di una strada extraurbana. Le pietre miliari sono posizione ad ogni chilometro.';

CREATE INDEX `fk_PietraMiliare_Posizione_idx` ON `pietramiliare` (`CodPosizione` ASC);


-- -----------------------------------------------------
-- Table `pool`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pool` ;

CREATE TABLE IF NOT EXISTS `pool` (
  `CodPool` VARCHAR(12) NOT NULL COMMENT 'Codice univoco di questo Pool (TragittoCP)',
  `NumTarga` VARCHAR(8) NOT NULL,
  `CodTragittoPrg` VARCHAR(12) NOT NULL,
  `CodTragittoTrc` VARCHAR(12),
  `DataPartenza` DATE NOT NULL COMMENT 'Data di partenza di questo pool',
  `OraPartenza` TIME NOT NULL COMMENT 'Orario di partenza di questo pool',
  `DataArrivo` DATE NULL DEFAULT NULL COMMENT 'Data di arrivo del pool. Specificata solo se diversa dalla data di partenza.',
  `Flessibilita` VARCHAR(8) NULL DEFAULT NULL COMMENT 'Indica il grado di flessibilità (BASSO, MEDIO, ALTO) attribuito al tragitto dal proponente. Un tragitto con flessibilità può essere soggetto a variazioni (proposte dal fruitore ed eventualmente accettate dal proponente)',
  `Validita` INT(11) NOT NULL COMMENT 'Periodo di validità, espresso in numero di ore, del Tragitto. Viene deciso dal proponente e non può essere inferiore a 48h. Esso determina lo stato del Pool che sarà:\nAPERTO: se il numero di ore che mancano alla partenza è superiore alla validità specificata;\nCHIUSO se il numero di ore che mancano alla partenza è compreso tra la validità specificata e 1;\nPARTITO se il numero di ore che mancano alla partenza è inferiore a 1.\nSu un tragitto in stato CHIUSO è interdetta ogni attività.',
  `Percentuale` DECIMAL(3,0) NULL DEFAULT NULL COMMENT 'Percentuale di aumento della spesa di questo viaggio in caso di presenza di variazioni accettate dal proponente. Ossia: costo_viaggio = calcola_costo(...) * Percentuale/100. Se il campo Flessibilita è diverso da NULL, anche Percentuale dev\'essere diverso da NULL.',
  `Spesa` DECIMAL(9,2) NULL DEFAULT NULL COMMENT 'Spesa totale del viaggio. Quando il fruitore interroga un pool per decidere se partecipare o meno l\'app a sua disposizione mostrerà la spesa pro capite mediante la formula spesa = spesa totale/(numero partecipanti + 1)\n',
  `PostiDisponibili` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`CodPool`),
  CONSTRAINT `fk_Pool_AutoCarPooling`
    FOREIGN KEY (`NumTarga`)
    REFERENCES `autocarpooling` (`NumTarga`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Pool_TragittoProgrammato1`
    FOREIGN KEY (`CodTragittoPrg`)
    REFERENCES `tragittoprogrammato` (`CodTragitto`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Pool_TragittoTracciato1`
    FOREIGN KEY (`CodTragittoTrc`)
    REFERENCES `tragittotracciato` (`CodTragitto`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contiene i pool (viaggi programmati da un proponente) effettuati da autovetture durante il servizio di Car Pooling.\nLo stato di un pool (APERTO, CHIUSO, PARTITO) deve essere calcolato dinamicamente perché dipende dal momento in cui si fa l\'interrogazione, dalla data e ora di partenza e dalla validità espressa dal proponente (non inferiore a 48h).';

CREATE INDEX `fk_Pool_AutoCarPooling_idx` ON `pool` (`NumTarga` ASC);

CREATE INDEX `fk_Pool_TragittoProgrammato1_idx` ON `pool` (`CodTragittoPrg` ASC);

CREATE INDEX `fk_Pool_TragittoTracciato1_idx` ON `pool` (`CodTragittoTrc` ASC);


-- -----------------------------------------------------
-- Table `prenotazionecp`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `prenotazionecp` ;

CREATE TABLE IF NOT EXISTS `prenotazionecp` (
  `CodPrenotazione` VARCHAR(12) NOT NULL COMMENT 'Codice univoco della prenotazione di partecipazione ad un pool',
  `CodPool` VARCHAR(12) NOT NULL COMMENT 'Codice univoco del pool a cui si riferisce questa prenotazione',
  `CFFruitore` VARCHAR(16) NOT NULL COMMENT 'Codice fiscale dellutente fruitore che ha inserito questa prenotazione',
  `Stato` VARCHAR(16) NULL DEFAULT NULL COMMENT 'Indica lo stato della prenotazione che può essere: NUOVA, ACCETTATA, RIFIUTATA, RINUNCIA\n',
  PRIMARY KEY (`CodPrenotazione`),
  CONSTRAINT `fk_PrenotazioneCP_Fruitore`
    FOREIGN KEY (`CFFruitore`)
    REFERENCES `fruitore` (`CodFiscale`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_PrenotazioneCP_Pool`
    FOREIGN KEY (`CodPool`)
    REFERENCES `pool` (`CodPool`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contiene lelenco delle prenotazioni avanzate da utenti fruitori per partecipare ad un pool. Ogni prenotazione ha uno stato che può essere:\nNUOVA: il fruitore ha inserito la prenotazione ma il proponente non lha ancora valutata\nACCETTATA: il proponente ha accettato la prenotazione; il fruitore che lha sottoposta fa parte del pool (a meno di rinuncia)\nRIFIUTATA: Il proponente ha rifiutato la prenotazione o ha rifiutato la proposta di variazione eventualmente a corredo della prenotazione: il fruitore è escluso dal pool.\nRINUNCIA: il fruitore ha ritirato la sua prenotazione e non intende più partecipare a questo pool';

CREATE INDEX `fk_PrenotazioneCP_Pool_idx` ON `prenotazionecp` (`CodPool` ASC);

CREATE INDEX `fk_PrenotazioneCP_Fruitore_idx` ON `prenotazionecp` (`CFFruitore` ASC);


-- -----------------------------------------------------
-- Table `raccordo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `raccordo` ;

CREATE TABLE IF NOT EXISTS `raccordo` (
  `CodRaccordo` VARCHAR(12) NOT NULL COMMENT 'Codice univoco di questo raccordo',
  `CodStradaU` VARCHAR(12) NOT NULL COMMENT 'Codice univoco della strada che si abbandona con questo raccordo (U=Uscita)',
  `NumCarreggiataU` TINYINT(4) NOT NULL COMMENT 'Numero della carreggiata in cui si trova questa raccordo',
  `CodPosizioneU` VARCHAR(12) NOT NULL COMMENT 'Posizione CHILOMETRICA in cui si trova il raccordo sulla strada che si abbandona',
  `CodStradaE` VARCHAR(12) NOT NULL COMMENT 'Codice della strada in cui ci si immette con questo raccordo (E=Entrata)',
  `NumCarreggiataE` TINYINT(4) NOT NULL COMMENT 'Numero della carreggiata della strada in cui ci si immette',
  `CodPosizioneE` VARCHAR(12) NOT NULL COMMENT 'Posizione CHILOMETRICA in cui si trova il raccordo sulla strada in cui ci si immette',
  PRIMARY KEY (`CodRaccordo`),
  CONSTRAINT `fk_Raccordo_Carreggiata1`
    FOREIGN KEY (`CodStradaU` , `NumCarreggiataU`)
    REFERENCES `carreggiata` (`CodStrada` , `NumCarreggiata`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Raccordo_Carreggiata2`
    FOREIGN KEY (`CodStradaE` , `NumCarreggiataE`)
    REFERENCES `carreggiata` (`CodStrada` , `NumCarreggiata`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Raccordo_PosizioneE`
    FOREIGN KEY (`CodPosizioneE`)
    REFERENCES `posizione` (`CodPosizione`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Raccordo_PosizioneU`
    FOREIGN KEY (`CodPosizioneU`)
    REFERENCES `posizione` (`CodPosizione`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Elenco dei raccordi di una strada senza incroci';

CREATE INDEX `fk_Raccordo_CarreggiataU_idx` ON `raccordo` (`CodStradaU` ASC, `NumCarreggiataU` ASC);

CREATE INDEX `fk_Raccordo_CarreggiataE_idx` ON `raccordo` (`CodStradaE` ASC, `NumCarreggiataE` ASC);

CREATE INDEX `fk_Raccordo_PosizioneU_idx` ON `raccordo` (`CodPosizioneU` ASC);

CREATE INDEX `fk_Raccordo_PosizioneE_idx` ON `raccordo` (`CodPosizioneE` ASC);


-- -----------------------------------------------------
-- Table `tipostrada`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tipostrada` ;

CREATE TABLE IF NOT EXISTS `tipostrada` (
  `CodTipoStrada` VARCHAR(3) NOT NULL COMMENT 'Codice del tipo ddi una strada',
  `Descrizione` VARCHAR(32) NULL DEFAULT NULL COMMENT 'Descrizione del tipo di una strada',
  PRIMARY KEY (`CodTipoStrada`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Anagrafica delle tipologie di strade:\nSS=Strada statale; SR=Strade Regionale; SP=Strada Provinciale; SC=Strada Comunale; SV=Strada Vicinale; A=Autostrada';


-- -----------------------------------------------------
-- Table `stradaextraurbana`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stradaextraurbana` ;

CREATE TABLE IF NOT EXISTS `stradaextraurbana` (
  `CodStrada` VARCHAR(12) NOT NULL COMMENT 'Codice univoco della strada',
  `CodTipoStrada` VARCHAR(2) NOT NULL COMMENT 'Codice della tipologia di questa strada extraurbana',
  `CodCategStrada` VARCHAR(8) NULL DEFAULT NULL COMMENT 'Codice delleventuale categoria di questa strada extraurbana',
  `Numero` INT(11) NOT NULL COMMENT 'Numero di questa strada extraurbana',
  `AltroNumero` INT(11) NULL DEFAULT NULL COMMENT 'Altro eventuale numero di questa strada extraurbana',
  PRIMARY KEY (`CodStrada`),
  CONSTRAINT `FK_StradaExtraurbana_CategoriaStrada`
    FOREIGN KEY (`CodCategStrada`)
    REFERENCES `categoriastrada` (`CodCategStrada`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `FK_StradaExtraurbana_Strada`
    FOREIGN KEY (`CodStrada`)
    REFERENCES `strada` (`CodStrada`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `FK_StradaExtraurbana_TipoStrada`
    FOREIGN KEY (`CodTipoStrada`)
    REFERENCES `tipostrada` (`CodTipoStrada`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Sottoinsieme delle strade che sono strade extraurbane';

CREATE INDEX `FK_StradaExtraurbana_TipoStrada_idx` ON `stradaextraurbana` (`CodTipoStrada` ASC);

CREATE INDEX `FK_StradaExtraurbana_CategoriaStrada_idx` ON `stradaextraurbana` (`CodCategStrada` ASC);


-- -----------------------------------------------------
-- Table `tracciamento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tracciamento` ;

CREATE TABLE IF NOT EXISTS `tracciamento` (
  `CodTracciamento` VARCHAR(12) NOT NULL COMMENT 'Identificativo univoco del tracciamento. La coppia (Targa, Timestamp) deve essere univoca.',
  `NumTarga` VARCHAR(8) NOT NULL COMMENT 'Numero targa della vettura che ha inviato i dati di tracciamento',
  `Timestamp` DATETIME NOT NULL COMMENT 'Data e ora del momento in cui la vettura ha inviato i dati di tracciamento',
  `Latitudine` DECIMAL(10,7) NULL DEFAULT NULL COMMENT 'Latitudine della posizione dell\'autovettura al momento dell\'invio di questi dati di tracciamento',
  `Longitudine` DECIMAL(10,7) NULL DEFAULT NULL COMMENT 'Longitudine della posizione dell\'autovettura al momento dell\'invio di questi dati di tracciamento',
  `Chilometro` DECIMAL(9,3) NULL DEFAULT NULL COMMENT 'Chilometro della strada in cui si trova l\'autovettura al momento dell\'invio di questi dati di tracciamento',
  `Nazione` VARCHAR(2) NULL DEFAULT NULL COMMENT 'Nazione in cui si trova l\'autovettura al momento dell\'invio di questi dati di tracciamento',
  `Regione` VARCHAR(3) NULL DEFAULT NULL COMMENT 'Codice della regione in cui si trova l\'autovettura al momento dell\'invio di questi dati di tracciamento',
  `Provincia` VARCHAR(4) NULL DEFAULT NULL COMMENT 'Sigla dell provincia in cui si trova l\'autovettura al momento dell\'invio di questi dati di tracciamento',
  `Comune` VARCHAR(64) NULL DEFAULT NULL COMMENT 'Comune in cui si trova l\'autovettura al momento dell\'invio di questi dati di tracciamento',
  `DUG` VARCHAR(32) NULL DEFAULT NULL COMMENT 'Dug della strada URBANA in cui si trova l\'autovettura al momento dell\'invio di questi dati di tracciamento',
  `NomeStd` VARCHAR(64) NULL DEFAULT NULL COMMENT 'Nome standard della strada URBANA in cui si trova l\'autovettura al momento dell\'invio di questi dati di tracciamento',
  `TipoStrada` VARCHAR(2) NULL DEFAULT NULL COMMENT 'Tipo della strada EXTRAURBANA in cui si trova l\'autovettura al momento dell\'invio di questi dati di tracciamento',
  `CategStrada` VARCHAR(8) NULL DEFAULT NULL COMMENT 'Categoria della strada EXTRAURBANA in cui si trova l\'autovettura al momento dell\'invio di questi dati di tracciamento',
  `Numero` INT(11) NULL DEFAULT NULL COMMENT 'Numero della strada EXTRAURBANA in cui si trova l\'autovettura al momento dell\'invio di questi dati di tracciamento',
  `Nome` VARCHAR(64) NULL DEFAULT NULL COMMENT 'Nome della strada EXTRAURBANA in cui si trova l\'autovettura al momento dell\'invio di questi dati di tracciamento',
  PRIMARY KEY (`CodTracciamento`),
  CONSTRAINT `fk_Tracciamento_Autovettura1`
    FOREIGN KEY (`NumTarga`)
    REFERENCES `autovettura` (`NumTarga`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contiene i dati di tracciamento di tutte le vetture del servizio. Ogni autovettura, a intervalli regolari, invia al sistema un insieme di informazioni da tracciare';

CREATE UNIQUE INDEX `UK_TRACCIAMENTO` ON `tracciamento` (`NumTarga` ASC, `Timestamp` ASC);


-- -----------------------------------------------------
-- Table `tragittotracciatocs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tragittotracciatocs` ;

CREATE TABLE IF NOT EXISTS `tragittotracciatocs` (
  `CodNoleggio` VARCHAR(12) NOT NULL COMMENT 'Codice del noleggio che percorre questo tragitto',
  `CodTragitto` VARCHAR(12) NOT NULL COMMENT 'Codice univoco di questo tragitto tracciato',
  PRIMARY KEY (`CodNoleggio`, `CodTragitto`),
  CONSTRAINT `fk_TragittoCS_Noleggio`
    FOREIGN KEY (`CodNoleggio`)
    REFERENCES `noleggio` (`CodNoleggio`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_TragittoTracciatoCS_TragittoTracciato1`
    FOREIGN KEY (`CodTragitto`)
    REFERENCES `tragittotracciato` (`CodTragitto`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Sottoinsieme dei tragitti tracciati percorsi da autovetture durante il servizio di Car Sharing (Noleggio).\nUn tragitto di un noleggio inizia all\'atto dell\'accensione del veicolo e termina al momento della sosta.\nLa posizione iniziale del tragitto viene impostata uguale alla posizione del primo record di tracciamento che arriva durante questo noleggio (all\'atto dell\'accensione dopo la consegna dell\'autovettura); mentre la posizione finale viene impostata all\'atto della riconsegna della vettura.';

CREATE INDEX `fk_TragittoTracciatoCS_TragittoTracciato1_idx` ON `tragittotracciatocs` (`CodTragitto` ASC);


-- -----------------------------------------------------
-- Table `tratta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tratta` ;

CREATE TABLE IF NOT EXISTS `tratta` (
  `CodTratta` VARCHAR(12) NOT NULL,
  `CodStrada` VARCHAR(12) NOT NULL,
  `NumCarreggiata` TINYINT(4) NOT NULL,
  `Lunghezza` DECIMAL(9,3) NULL DEFAULT NULL COMMENT 'Lunghezza, espressa in Chilometri, di questa tratta',
  `CodPosizioneIni` VARCHAR(12) NOT NULL,
  `CodPosizioneFin` VARCHAR(12) NULL DEFAULT NULL,
  PRIMARY KEY (`CodTratta`),
  CONSTRAINT `fk_Tratta_Carreggiata`
    FOREIGN KEY (`CodStrada` , `NumCarreggiata`)
    REFERENCES `carreggiata` (`CodStrada` , `NumCarreggiata`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Tratta_PosizioneFin`
    FOREIGN KEY (`CodPosizioneFin`)
    REFERENCES `posizione` (`CodPosizione`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Tratta_PosizioneIni`
    FOREIGN KEY (`CodPosizioneIni`)
    REFERENCES `posizione` (`CodPosizione`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contiene l\'elenco di tutte le possibili tratte appartenenti ad (pPosizione_CodPosizioneercorribili su) una strada. Il numero di tratte percorribili (in uno stesso senso di marcia) su una strada che ha N incroci è dato da: SUM_{i=1}^{N+1}{i} (Sommatoria per i che va da 1 a N+1 di i). Altrettante sono le tratte percorribili in senso inverso.';

CREATE INDEX `fk_Tratta_PosizioneIni_idx` ON `tratta` (`CodPosizioneIni` ASC);

CREATE INDEX `fk_Tratta_Carreggiata_idx` ON `tratta` (`CodStrada` ASC, `NumCarreggiata` ASC);

CREATE INDEX `fk_Tratta_PosizioneFin_idx` ON `tratta` (`CodPosizioneFin` ASC);


-- -----------------------------------------------------
-- Table `trattapercorsa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trattapercorsa` ;

CREATE TABLE IF NOT EXISTS `trattapercorsa` (
  `CodTratta` VARCHAR(12) NOT NULL COMMENT 'Codice univoco della tratta percorsa (da una qualunque vettura durante un qualsiasi servizio).',
  `DataOraInserimento` DATETIME NOT NULL COMMENT 'Data e ora in cui è stato inserito questo record.',
  `TempoPercorrenza` INT(11) NULL DEFAULT NULL COMMENT 'Tempo, espresso in ore, minuti e secondi, impiegato (da una certa auto durante un certo servizio) per percorre questa tratta ',
  PRIMARY KEY (`CodTratta`, `DataOraInserimento`),
  CONSTRAINT `fk_TrattaPercorsa_Tratta1`
    FOREIGN KEY (`CodTratta`)
    REFERENCES `tratta` (`CodTratta`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contiene, per ogni tratta percorsa (da una qualsiasi autovettura durante un qualsiasi noleggio), il tempo impiegato per percorrerla. Per ogni tratta vengono memorizzati un numero limitato (10? 50? 200?) di tempi che serviranno per calcolare il tempo medio di percorrenza di quella tratta. Raggiunto il numero stabilito ogni nuovo inserimento causa l\'eliminazione del record più vecchio in modo che la media venga calcolata sempre con i tempi più recenti. Le informazioni di questa tabella possono anche essere usate per dare informazioni sul traffico in tempo reale (ossia dare il tempo medio di percorrenza con le attuali condizioni di traffico) a patto che Il calcolo della media sia fatto utilizzando solo i record che sono stati registrati in un intervallo ragionevolmente significativo (15min) rispetto al momento del calcolo.  ';

CREATE INDEX `fk_TrattaPercorsa_Tratta1_idx` ON `trattapercorsa` (`CodTratta` ASC);


-- -----------------------------------------------------
-- Table `trattatemporizzata`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trattatemporizzata` ;

CREATE TABLE IF NOT EXISTS `trattatemporizzata` (
  `CodTratta` VARCHAR(12) NOT NULL COMMENT 'Codice univoco della tratta di strada che, in questa fascia oraria, si percorre in questo tempo medio.',
  `CodFascia` VARCHAR(12) NOT NULL COMMENT 'Codice della fascia oraria',
  `TempoMedio` DECIMAL(13,2) NULL DEFAULT NULL COMMENT 'Tempo medio di percorrenza di questa tratta',
  PRIMARY KEY (`CodTratta`, `CodFascia`),
  CONSTRAINT `fk_TrattaTemporizzata_FasciaOraria`
    FOREIGN KEY (`CodFascia`)
    REFERENCES `fasciaoraria` (`CodFascia`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_TrattaTemporizzata_Tratta`
    FOREIGN KEY (`CodTratta`)
    REFERENCES `tratta` (`CodTratta`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Specifica, per ogni tratta di una strada e per ogni fascia oraria di interesse, il tempo medio di percorrenza della tratta nella fascia oraria. Il tempo medio è stimato utilizzando i tempi impiegati da un numero prestabilito di autovetture che hanno percorso la tratta di recente (vedi tabella TRATTA_PERCORSA).\nLa tratta è specificata con il codice della strada più due posizioni chilometriche che devono appartenere alla stessa strada. Il codice della strada deve essere ricavato dalle informazioni di tracciamento inviate dalle autovetture';

CREATE INDEX `fk_TrattaTemporizzata_FasciaOraria_idx` ON `trattatemporizzata` (`CodFascia` ASC);

CREATE INDEX `fk_TrattaTemporizzata_Tratta_idx` ON `trattatemporizzata` (`CodTratta` ASC);


-- -----------------------------------------------------
-- Table `trattatracciata`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trattatracciata` ;

CREATE TABLE IF NOT EXISTS `trattatracciata` (
  `CodTratta` VARCHAR(12) NOT NULL COMMENT 'Codice della tratta tracciata.',
  `DataOraEntrata` DATETIME NOT NULL COMMENT 'Indica il momento (timestamp) in cui viene rilevato l\'ingresso in questa tratta di strada',
  `CodTracciamentoE` VARCHAR(12) NOT NULL COMMENT 'Riferimento al record di tracciamento che determina la DataOraEntrata.',
  `DataOraUscita` DATETIME NULL DEFAULT NULL COMMENT 'Indica il momento (timestamp) in cui viene rilevato l\'uscita da questa tratta di strada',
  `CodTracciamentoU` VARCHAR(12) NULL DEFAULT NULL COMMENT 'Riferimento al record di tracciamento che determina la DataOraUscita',
  PRIMARY KEY (`CodTratta`, `DataOraEntrata`),
  CONSTRAINT `fk_TrattaTracciata_TracciamentoE`
    FOREIGN KEY (`CodTracciamentoE`)
    REFERENCES `tracciamento` (`CodTracciamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TrattaTracciata_TracciamentoU`
    FOREIGN KEY (`CodTracciamentoU`)
    REFERENCES `tracciamento` (`CodTracciamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TrattaTracciata_Tratta`
    FOREIGN KEY (`CodTratta`)
    REFERENCES `tratta` (`CodTratta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE INDEX `fk_TrattaTracciata_Tratta_idx` ON `trattatracciata` (`CodTratta` ASC);

CREATE INDEX `fk_TrattaTracciata_TracciamentoE_idx` ON `trattatracciata` (`CodTracciamentoE` ASC);

CREATE INDEX `fk_TrattaTracciata_TracciamentoU_idx` ON `trattatracciata` (`CodTracciamentoU` ASC);


-- -----------------------------------------------------
-- Table `trattatragittoprg`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trattatragittoprg` ;

CREATE TABLE IF NOT EXISTS `trattatragittoprg` (
  `CodTragitto` VARCHAR(12) NOT NULL,
  `CodTratta` VARCHAR(12) NOT NULL,
  PRIMARY KEY (`CodTragitto`, `CodTratta`),
  CONSTRAINT `fk_TrattaTragittoPrg_TragittoProgrammato1`
    FOREIGN KEY (`CodTragitto`)
    REFERENCES `tragittoprogrammato` (`CodTragitto`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_TrattaTragittoPrg_Tratta1`
    FOREIGN KEY (`CodTratta`)
    REFERENCES `tratta` (`CodTratta`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contiene l\'elenco (ordinato) delle tratte di strade che compongono questo tragitto programmato. La tabella viene alimentata dal proponente allatto dellinserimento di un pool o di uno sharing';

CREATE INDEX `fk_TrattaTragittoPrg_Tratta1_idx` ON `trattatragittoprg` (`CodTratta` ASC);


-- -----------------------------------------------------
-- Table `trattatragittotrc`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trattatragittotrc` ;

CREATE TABLE IF NOT EXISTS `trattatragittotrc` (
  `CodTragitto` VARCHAR(12) NOT NULL COMMENT 'Codice univoco del tragitto',
  `CodTratta` VARCHAR(12) NOT NULL,
  `DataOraEntrata` DATETIME NOT NULL,
  PRIMARY KEY (`CodTragitto`, `CodTratta`, `DataOraEntrata`),
  CONSTRAINT `fk_TragittoProgrammato_TragittoTracciato1`
    FOREIGN KEY (`CodTragitto`)
    REFERENCES `tragittotracciato` (`CodTragitto`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_TrattaTragittoTrc_TrattaTracciata1`
    FOREIGN KEY (`CodTratta` , `DataOraEntrata`)
    REFERENCES `trattatracciata` (`CodTratta` , `DataOraEntrata`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contiene l\'elenco (ordinato) delle tratte di strade che compongono questo tragitto tracciato. La tabella viene alimentata dalla procedura che gestisce i record di tracciamento';

CREATE INDEX `fk_TragittoProgrammato_TragittoTracciato1_idx` ON `trattatragittotrc` (`CodTragitto` ASC);

CREATE INDEX `fk_TrattaTragittoTrc_TrattaTracciata1_idx` ON `trattatragittotrc` (`CodTratta` ASC, `DataOraEntrata` ASC);


-- -----------------------------------------------------
-- Table `valutazione`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `valutazione` ;

CREATE TABLE IF NOT EXISTS `valutazione` (
  `CodValutazione` VARCHAR(12) NOT NULL COMMENT 'Codice univoco della valutazione',
  `CFUtenteGiudicante` VARCHAR(16) NOT NULL COMMENT 'Codice fiscale dellutente che esprime il giudizio (su CFUtenteGiudicato)',
  `RuoloUtenteGiudicante` CHAR(1) NOT NULL COMMENT 'Ruolo dellutente giudicante (F=Fruitore, P=Proponente)',
  `CFUtenteGiudicato` VARCHAR(16) NOT NULL COMMENT 'Codice Fiscale dellutente giudicato (da CFUtenteGiudicante)',
  `RuoloUtenteGiudicato` CHAR(1) NOT NULL COMMENT 'Ruolo dellutente giudicato (F=Fruitore, P=Proponente)',
  `CodTragitto` VARCHAR(12) NULL DEFAULT NULL COMMENT 'Codice del tragitto al quale si riferisce il giudizio (solo per servizio CAR_POOLING o RIDE_SHARING, vale NULL se il servizio è CAR_SHARING)',
  `Servizio` VARCHAR(32) NOT NULL COMMENT 'Descrive il servizio nellambito del quale questo valutazione viene data: CAR_SHARING, CAR_POOLING, RIDE_SHARING',
  `Recensione` VARCHAR(256) NULL DEFAULT NULL COMMENT 'Recensione testuale espressa dallutente giudicate nei riguardi dellutente giudicante',
  PRIMARY KEY (`CodValutazione`),
  CONSTRAINT `fk_Valutazione_Tragitto`
    FOREIGN KEY (`CodTragitto`)
    REFERENCES `tragitto` (`CodTragitto`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Valutazione_Utente1`
    FOREIGN KEY (`CFUtenteGiudicante`)
    REFERENCES `utente` (`CodFiscale`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Valutazione_Utente2`
    FOREIGN KEY (`CFUtenteGiudicato`)
    REFERENCES `utente` (`CodFiscale`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'elenca tutte le valutazioni che ogni utente esprime verso un altro utente';

CREATE INDEX `fk_Valutazione_Utente1_idx` ON `valutazione` (`CFUtenteGiudicante` ASC);

CREATE INDEX `fk_Valutazione_Utente2_idx` ON `valutazione` (`CFUtenteGiudicato` ASC);

CREATE INDEX `fk_Valutazione_Tragitto1_idx` ON `valutazione` (`CodTragitto` ASC);


-- -----------------------------------------------------
-- Table `valutazioneaspetti`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `valutazioneaspetti` ;

CREATE TABLE IF NOT EXISTS `valutazioneaspetti` (
  `CodValutazione` VARCHAR(12) NOT NULL COMMENT 'Codice univoco della valutazione',
  `CodAspettoValutabile` VARCHAR(12) NOT NULL,
  `Voto` DECIMAL(3,2) NOT NULL COMMENT 'Voto espresso in numero di stelle',
  PRIMARY KEY (`CodValutazione`, `CodAspettoValutabile`),
  CONSTRAINT `fk_ValutazioneAspetti_AspettoValutabile1`
    FOREIGN KEY (`CodAspettoValutabile`)
    REFERENCES `aspettovalutabile` (`CodAspettoValutabile`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ValutazioneAspetti_Valutazione1`
    FOREIGN KEY (`CodValutazione`)
    REFERENCES `valutazione` (`CodValutazione`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contiene la valutazione espressa dallutente fruitore circa gli aspetti valutabili del proponente nellambito del servizio erogato.';

CREATE INDEX `fk_ValutazioneAspetti_AspettoValutabile1_idx` ON `valutazioneaspetti` (`CodAspettoValutabile` ASC);


-- -----------------------------------------------------
-- Table `variazionecp`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `variazionecp` ;

CREATE TABLE IF NOT EXISTS `variazionecp` (
  `CodVariazione` VARCHAR(12) NOT NULL COMMENT 'Codice univoco della variazione',
  `CodPrenotazione` VARCHAR(12) NOT NULL COMMENT 'Codice univoco della prenotazione collegata a questa variazione di tragitto; permette di identificare il tragitto del pool a cui questa proposta di variazione si riferisce',
  PRIMARY KEY (`CodVariazione`),
  CONSTRAINT `fk_VariazioneCP_PrenotazioneCP`
    FOREIGN KEY (`CodPrenotazione`)
    REFERENCES `prenotazionecp` (`CodPrenotazione`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contiene le eventuali variazioni di tragitto proposte dallutente fruitore su un pool con flessibilità. La tabella specifica la tratta che si propone di eliminare per sostituirla con le tratte contenute in VariazioneTrattaCP. Se la variazione interessa più di una tratta del tragitto originale ognuna ha un CodVariazione proprio';

CREATE INDEX `fk_VariazioneCP_PrenotazioneCP_idx` ON `variazionecp` (`CodPrenotazione` ASC);


-- -----------------------------------------------------
-- Table `variazionetrattacp`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `variazionetrattacp` ;

CREATE TABLE IF NOT EXISTS `variazionetrattacp` (
  `CodVariazione` VARCHAR(12) NOT NULL,
  `Operazione` CHAR(1) NOT NULL COMMENT 'Operazione relaziona a questa tratta:\nE=Eliminazione di una tratta del tragitto originale\nI=Inserimento di una nuova tratta da aggiungere al tragitto originale',
  `CodTratta` VARCHAR(12) NOT NULL COMMENT 'Codice della tratta inserita nella variazione',
  PRIMARY KEY (`CodVariazione`, `Operazione`, `CodTratta`),
  CONSTRAINT `fk_VariazioneTrattaCP_Tratta`
    FOREIGN KEY (`CodTratta`)
    REFERENCES `tratta` (`CodTratta`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_VariazioneTrattaCP_VariazioneCP`
    FOREIGN KEY (`CodVariazione`)
    REFERENCES `variazionecp` (`CodVariazione`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Elenca le tratte di strada interessate da una proposta di variazione. In particolare per ogni variazione vengono inserite tanti record con operazione E (Eliminazione) quante sono le tratte del percorso originale da eliminare + tanti record con operazione I (Inserimento) quante sono le nuove tratte che soddisfano il grado di flessibilità del pool (pena la non accettazione della proposta di variazione) e le esigenze dellutente fruitore proponente.';

CREATE INDEX `fk_VariazioneTrattaCP_VariazioneCP_idx` ON `variazionetrattacp` (`CodVariazione` ASC);

CREATE INDEX `fk_VariazioneTrattaCP_Tratta_idx` ON `variazionetrattacp` (`CodTratta` ASC);

USE `smartmobility` ;

-- -----------------------------------------------------
-- procedure AggiornaCostoPool
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `AggiornaCostoPool`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AggiornaCostoPool`(
pCodPool varchar(16),
pCostoCarburante decimal(6,4), -- EUR/LITRO
pMotivo varchar(16) -- ACCETTAZIONE | RINUNCIA
)
AggiornaCostoPool:BEGIN
     DECLARE POOL_INESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvNumTarga varchar(8);
    DECLARE lvSpesa decimal(9,2);
    DECLARE lvPostiDisponibili decimal(2);
    DECLARE lvLunghezza decimal(9,3);
    DECLARE lvTipoPercorso char(1);
    DECLARE lvNumPostiTotali decimal(2);
    DECLARE lvNumPasseggeri decimal(2);
    DECLARE lvCostoOperativo decimal(9,2);
    DECLARE lvCostoUsura decimal(9,2);
    DECLARE lvConsumoU decimal(5,3);
    DECLARE lvConsumoXU decimal(5,3);
    DECLARE lvConsumoM decimal(5,3);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    -- Recupero le informazioni necessarie per iil calcolo del costo
    select DT.Lunghezza, DT.TipoPercorso, DT.NumTarga, DT.NumPosti, DT.NumPasseggeri,
           C.CostoOperativo, C.CostoUsura, C.ConsumoU, C.ConsumoXU, C.ConsumoM
      into lvLunghezza, lvTipoPercorso, lvNumTarga, lvNumPostiTotali, lvNumPasseggeri,
           lvCostoOperativo, lvCostoUsura, lvConsumoU, lvConsumoXU, lvConsumoM
      from (select T.Lunghezza, T.TipoPercorso, P.NumTarga, A.NumPosti,
                   A.NumPosti - P.PostiDisponibili + case pMotivo when 'ACCETTAZIONE' then +1 when 'RINUNCIA' then -1 else 0 end NumPasseggeri
              from Pool P
                   inner join TragittoProgrammato T on (
                       T.CodTragitto = P.CodTragittoPrg
                   )
                   inner join AutovetturaRegistrata A on (
                       A.NumTarga = P.NumTarga
                   )
             where P.CodPool = pCodPool
            ) DT
            inner join CostoAutovettura C on (
                C.NumTarga = DT.NumTarga
                and C.NumPasseggeri = DT.NumPasseggeri
            );
    -- Testiamo per assicurarci che il pool sia stato trovato
    if lvRecNotFound = 1 then
        SIGNAL POOL_INESISTENTE
           SET MESSAGE_TEXT = 'Pool inesistente';
    end if;
    -- Calcoliamo la spesa dovuta al consumo di carburante sul tipo di percorso determinato
    set lvSpesa = (lvLunghezza/100) *
        (case lvTipoPercorso when 'U' then lvConsumoU when 'X' then lvConsumoXU when 'M' then lvConsumoM end) *
        pCostoCarburante;
    -- Aggiungiamo i costi operativi e di usura dipendenti dalla lunghezza del tragitto
    set lvSpesa = lvSpesa + (lvCostoOperativo + lvCostoUsura) * lvLunghezza;
    -- Aggiorniamo la tabella Pool con la nuova spesa calcolata e con il numero di passeggeri modificati in seguito alla accettazione/rinuncia verificatasi
    update Pool
       set Spesa = lvSpesa,
           PostiDisponibili = lvNumPostiTotali - lvNumPasseggeri
     where CodPool = pCodPool;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure AggiornaStatoTragittoPrg
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `AggiornaStatoTragittoPrg`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AggiornaStatoTragittoPrg`(
pCodTragitto varchar(12)
)
AggiornaStatoTragittoPrg:BEGIN
    --
    DECLARE lvQtaUrbana int;
    DECLARE lvQtaExtraurbana int;
    -- Conto la quantita di Strade Urbane e di Strade Extraurbane presenti nel tragitto
    select sum(if(CodClassTec = 'SUR', 1, 0)),
           sum(if(CodClassTec = 'SXP' 
               or CodClassTec = 'SXS' 
               or CodClassTec = 'AUT', 1, 0)) 
      into lvQtaUrbana, lvQtaExtraurbana    
      from Tratta T
           natural join TrattaTragittoPrg TTP
           inner join Strada S on (S.CodStrada = T.CodStrada)
     where TTP.CodTragitto = pCodTragitto;      
    -- Aggiorno il valore dello Stato in TragittoProgrammato      
    if lvQtaUrbana > 0 and lvQtaExtraurbana = 0 then
        update TragittoProgrammato
           set TipoPercorso = 'U'
         where CodTragitto = pCodTragitto;
    elseif lvQtaUrbana = 0 and lvQtaExtraurbana > 0 then
        update TragittoProgrammato
           set TipoPercorso = 'X'
         where CodTragitto = pCodTragitto;     
    elseif lvQtaUrbana > 0 and lvQtaExtraurbana > 0 then
        update TragittoProgrammato
           set TipoPercorso = 'M'
         where CodTragitto = pCodTragitto;     
    end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ChkInsCarreggiata
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `ChkInsCarreggiata`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ChkInsCarreggiata`(
pCodStrada varchar(32),
pNumCarreggiata tinyint,
pNumCorsie tinyint,
pNumSensiMarcia tinyint
)
ChkInsCarreggiata:BEGIN
    DECLARE lvCodStrada varchar(12);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodStrada
      into lvCodStrada
      from Carreggiata C
     where C.CodStrada = pCodStrada
       and C.NumCarreggiata = pNumCarreggiata;
    --
    if lvRecNotFound = 1 then
        insert into Carreggiata (
            CodStrada, NumCarreggiata, NumCorsie, NumSensiMarcia
        ) VALUES (
            pCodStrada, pNumCarreggiata, pNumCorsie, pNumSensiMarcia
        );
    end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function ChkInsFruitore
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `ChkInsFruitore`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ChkInsFruitore`(
pCFFruitore varchar(16)
) RETURNS char(16) CHARSET latin1
ChkInsFruitore:BEGIN
    DECLARE lvCodFiscale varchar(16);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodFiscale
      into lvCodFIscale
      from Fruitore
     where CodFiscale = pCFFruitore;
    --
    if lvRecNotFound = 1 then
        insert into Fruitore (
            CodFiscale
        ) VALUES (
            pCFFruitore
        );
    end if;
    --
    return pCFFruitore;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function ChkInsIncrocio
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `ChkInsIncrocio`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ChkInsIncrocio`(
pCodStrada1 varchar(32),
pNumCarreggiata1 tinyint,
pChilometro1 decimal(9,3),
pLatitudine decimal(10,7),
pLongitudine decimal(10,7),
pCodStrada2 varchar(32),
pNumCarreggiata2 tinyint,
pChilometro2 decimal(9,3)
) RETURNS varchar(12) CHARSET latin1
ChkInsIncrocio:BEGIN
    DECLARE lvCodIncrocio varchar(12);
    DECLARE lvCodPosizione1 varchar(12);
    DECLARE lvCodPosizione2 varchar(12);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select I.CodIncrocio
      into lvCodIncrocio
      from Incrocio I
	 where I.CodStrada = pCodStrada1
	   and I.NumCarreggiata = pNumCarreggiata1
       and I.CodStradaX = pCodStrada2
	   and I.NumCarreggiataX = pNumCarreggiata2
    ;
    if lvRecNotFound = 1 then
		set lvRecNotFound = 0;
		select P.CodPosizione
		  into lvCodPosizione1
		  from Posizione P
		 where P.Latitudine = MyRound(pLatitudine, 0.00005)
		   and P.Longitudine = MyRound(pLongitudine, 0.00005)
		   and P.CodStrada = pCodStrada1;
		--
		if lvRecNotFound = 1 then
			set lvCodPosizione1 = ChkInsPosizione(pLatitudine, pLongitudine, pCodStrada1, pChilometro1, NULL);
		end if;
		--
		set lvRecNotFound = 0; 
		select P.CodPosizione
		  into lvCodPosizione2
		  from Posizione P
		 where P.Latitudine = MyRound(pLatitudine, 0.00005)
		   and P.Longitudine = MyRound(pLongitudine, 0.00005)
		   and P.CodStrada = pCodStrada2;
		--
		if lvRecNotFound = 1 then
			set lvCodPosizione2 = ChkInsPosizione(pLatitudine, pLongitudine, pCodStrada2, pChilometro2, NULL);
		end if;
        --
        set lvCodIncrocio = NewProgressivo('INC', 'Incrocio');
        insert into Incrocio (
			CodIncrocio, CodStrada, NumCarreggiata, CodPosizione, CodStradaX, NumCarreggiataX, CodPosizioneX
        ) VALUES (
			lvCodIncrocio, pCodStrada1, pNumCarreggiata1, lvCodPosizione1, pCodStrada2, pNumCarreggiata2, lvCodPosizione2
        );
	end if;
    --
    return lvCodIncrocio;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function ChkInsIndirizzo
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `ChkInsIndirizzo`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ChkInsIndirizzo`(
pCodStrada varchar(32),
pCivico varchar(32),
pEsponente varchar(32)
) RETURNS char(12) CHARSET latin1
ChkInsIndirizzo:BEGIN
    DECLARE lvCodIndirizzo varchar(12) default NULL;
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodIndirizzo
      into lvCodIndirizzo
      from Indirizzo
     where CodStrada = pCodStrada
       and coalesce(Civico,'#') = coalesce(pCivico, '#')
       and coalesce(Esponente,'#') = coalesce(pEsponente, '#');
    --
    if lvRecNotFound = 1 then
        set lvCodIndirizzo = NewProgressivo('IND', 'Indirizzo');
        insert into Indirizzo (
            CodIndirizzo, CodStrada, Civico, Esponente
        ) VALUES (
            lvCodIndirizzo, pCodStrada, pCivico, pEsponente
        );
    end if;
    --
    return lvCodIndirizzo;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function ChkInsNoleggio
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `ChkInsNoleggio`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ChkInsNoleggio`(
pCodPrenotazione varchar(12),
pQtaCarburanteIni decimal(7,0),
pKmPercorsiIni decimal(7,0)
) RETURNS char(12) CHARSET latin1
ChkInsNoleggio:BEGIN
    DECLARE lvCodNoleggio varchar(12) default NULL;
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodNoleggio
      into lvCodNoleggio
      from Noleggio
     where CodPrenotazione = pCodPrenotazione;
    --
    if lvRecNotFound = 1 then
        set lvCodNoleggio = NewProgressivo('NOL', 'Noleggio');
        insert into Noleggio (
            CodNoleggio, CodPrenotazione, QtaCarburanteIni, KmPercorsiIni
        ) VALUES (
            lvCodNoleggio, pCodPrenotazione, pQtaCarburanteIni, pKmPercorsiIni
        );
    end if;
    --
    return lvCodNoleggio;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function ChkInsPool
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `ChkInsPool`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ChkInsPool`(
pNumTarga varchar(12),
pCodTragittoPrg varchar(12),
pCodTragittoTrc varchar(12),
pDataPartenza date,
pOraPartenza time,
pDataArrivo date,
pFlessibilita varchar(8),
pValidità int(11),
pPercentuale decimal(3,0),
pSpesa decimal(9,2),
pPostiDisponibili int(11)
) RETURNS char(12)
--
ChkInsPool:BEGIN
    DECLARE lvCodPool varchar(12) default NULL;
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodPool
      into lvCodPool
      from Pool
     where NumTarga = pNumTarga
       and DataPartenza = pDataPartenza
       and OraPartenza = pOraPartenza;
    --
    if lvRecNotFound = 1 then
        set lvCodPool = smartmobility.NewProgressivo('POL', 'Pool');
        insert into Pool (
            CodPool, NumTarga, CodTragittoPrg, CodTragittoTrc, DataPartenza, OraPartenza, DataArrivo, Flessibilita, Validita, Percentuale, Spesa, PostiDisponibili
        ) VALUES (
            lvCodPool, pNumTarga, pCodTragittoPrg, pCodTragittoTrc, pDataPartenza, pOraPartenza, pDataArrivo, pFlessibilita, pValidita, pPercentuale, pSpesa, pPostiDisponibili
        );
    end if;
    --
    return lvCodPool;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function ChkInsPosizione
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `ChkInsPosizione`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ChkInsPosizione`(
pLatitudine decimal(10,7),
pLongitudine decimal(10,7),
pCodStrada varchar(12),
pChilometro decimal(9,3),
pCodIndirizzo varchar(12)
) RETURNS char(12) CHARSET latin1
ChkInsPosizione:BEGIN
    DECLARE lvCodPosizione varchar(12) default NULL;
    DECLARE lvLatitudine decimal(10,7);
    DECLARE lvLongitudine decimal(10,7);
    DECLARE lvCodStrada varchar(12);
    DECLARE lvChilometro decimal(9,3);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    set lvLatitudine = MyRound(pLatitudine, 0.00005);
    set lvLongitudine = MyRound(pLongitudine, 0.00005);
    set lvCodStrada = case when pCodStrada is null or pChilometro is null then null else pCodStrada end;
    set lvChilometro = case when pCodStrada is null or pChilometro is null then null else pChilometro end;
    select CodPosizione
      into lvCodPosizione
      from Posizione
     where Latitudine = lvLatitudine
       and Longitudine = lvLongitudine
       and coalesce(CodStrada,'#') = coalesce(lvCodStrada, '#')
       and coalesce(Chilometro, -1) = coalesce(lvChilometro, -1)
       and coalesce(CodIndirizzo,'#') = coalesce(pCodIndirizzo, '#');
    --
    if lvRecNotFound = 1 then
        set lvCodPosizione = NewProgressivo('POS', 'Posizione');
        insert into Posizione (
            CodPosizione, Latitudine, Longitudine, CodStrada, Chilometro, CodIndirizzo
        ) VALUES (
            lvCodPosizione, lvLatitudine, lvLongitudine, lvCodStrada, lvChilometro, pCodIndirizzo
        );
    end if;
    --
    return lvCodPosizione;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function ChkInsPrenotazioneCP
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `ChkInsPrenotazioneCP`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ChkInsPrenotazioneCP`(
pCodPool varchar(12),
pCFFruitore varchar(16)
) RETURNS char(12)
--
ChkInsPrenotazioneCP:BEGIN
    DECLARE lvCodPrenotazione varchar(12) default NULL;
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodPrenotazione
      into lvCodPrenotazione
      from PrenotazioneCP
     where CFFruitore = pCFFruitore
       and CodPool = pCodPool;
    --
    if lvRecNotFound = 1 then
        call GestioneRuolo(pCFFruitore, 'FRUITORE', 'GRANT');
        set lvCodPrenotazione = smartmobility.NewProgressivo('PRN', 'Prenotazione');
        insert into PrenotazioneCP (
            CodPrenotazione, CodPool, CFFruitore, Stato
        ) VALUES (
            lvCodPrenotazione, pCodPool, pCFFruitore, 'NUOVA'
        );
    end if;
    --
    return lvCodPrenotazione;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function ChkInsPrenotazioneCS
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `ChkInsPrenotazioneCS`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ChkInsPrenotazioneCS`(
pCFFruitore varchar(16),
pNumTarga varchar(8),
pDataIni date,
pDataFin date
) RETURNS char(12) CHARSET latin1
ChkInsPrenotazioneCS:BEGIN
    DECLARE lvCodPrenotazione varchar(12) default NULL;
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodPrenotazione
      into lvCodPrenotazione
      from PrenotazioneCS
     where CFFruitore = pCFFruitore
       and NumTarga = pNumTarga
       and DataIni = pDataIni;
    --
    if lvRecNotFound = 1 then
        -- TODO: Controllare che il periodo della prenotazione [DataIni, DataFin] sia compatibile con (l'agenda della) fruibilità dell'autovettura
        call GestioneRuolo(pCFFruitore, 'FRUITORE', 'GRANT');
        set lvCodPrenotazione = NewProgressivo('PRN', 'Prenotazione');
        insert into PrenotazioneCS (
            CodPrenotazione, CFFruitore, NumTarga, DataIni, DataFin, Stato
        ) VALUES (
            lvCodPrenotazione, pCFFruitore, pNumTarga, pDataIni, pDataFin, 'NUOVA'
        );
    end if;
    --
    return lvCodPrenotazione;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function ChkInsProponente
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `ChkInsProponente`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ChkInsProponente`(
pCFProponente varchar(16)
) RETURNS char(16) CHARSET latin1
ChkInsProponente:BEGIN
    DECLARE lvCodFiscale varchar(16);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodFiscale
      into lvCodFIscale
      from Proponente
     where CodFiscale = pCFProponente;
    --
    if lvRecNotFound = 1 then
        insert into Proponente (
            CodFiscale
        ) VALUES (
            pCFProponente
        );
    end if;
    --
    return pCFProponente;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function ChkInsRaccordo
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `ChkInsRaccordo`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ChkInsRaccordo`(
pCodStradaU varchar(12),
pNumCarreggiataU tinyint(4),
pCodPosizioneU varchar(12),
pCodStradaE varchar(12),
pNumCarreggiataE tinyint(4),
pCodPosizioneE varchar(12)
) RETURNS char(16)
--
ChkInsRaccordo:BEGIN
    DECLARE lvCodRaccordo varchar(12);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodRaccordo
      into lvCodRaccordo
      from Raccordo
     where CodStradaU = pCodStradaU
       and CodStradaE = pCodStradaE
       and NumCarreggiataU = pNumCarreggiataU
       and NumCarreggiataE = pNumCarreggiataE
       and CodPosizioneU = pCodPosizioneU
       and CodPosizioneE = pCodPosizioneE;
    --
    if lvRecNotFound = 1 then
		set lvCodRaccordo = smartmobility.NewProgressivo('RAC', 'Raccordo');
        insert into Raccordo (
            CodRaccordo, CodStradaU, NumCarreggiataU, CodPosizioneU, CodStradaE, NumCarreggiataE, CodPosizioneE
        ) VALUES (
            lvCodRaccordo, pCodStradaU, pNumCarreggiataU, pCodPosizioneU, pCodStradaE, pNumCarreggiataE, pCodPosizioneE
        );
    end if;
    --
    return lvCodRaccordo;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function ChkInsSharing
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `ChkInsSharing`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ChkInsSharing`(
pNumTarga varchar(12),
pCodTragittoPrg varchar(12),
pDataPartenza date,
pOraPartenza time
) RETURNS char(12)
--
ChkInsSharing:BEGIN
    DECLARE lvCodSharing varchar(12) default NULL;
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodSharing
      into lvCodSharing
      from Sharing
     where NumTarga = pNumTarga
       and DataPartenza = pDataPartenza
       and OraPartenza = pOraPartenza;
    --
    if lvRecNotFound = 1 then
        set lvCodSharing = smartmobility.NewProgressivo('SRG', 'Sharing');
        insert into Sharing (
            CodSharing, NumTarga, CodTragittoPrg, DataPartenza, OraPartenza
        ) VALUES (
            lvCodSharing, pNumTarga, pCodTragittoPrg, pDataPartenza, pOraPartenza
        );
    end if;
    --
    return lvCodSharing;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function InsSinistro
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `InsSinistro`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `InsSinistro`(
pCodNoleggio varchar(12),
pDataOraSinistro datetime,
pCodPosizione varchar(12),
pDinamica varchar(256)
) RETURNS char(12)
--
InsSinistro:BEGIN
    DECLARE lvCodSinistro varchar(12) default NULL;
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodSinistro
      into lvCodSinistro
      from Sinistro
     where CodNoleggio = pCodNoleggio
	   and DataOraSinistro = pDataOraSinistro
       and CodPosizione = pCodPosizione;
    --
    if lvRecNotFound = 1 then
        set lvCodSinistro = smartmobility.NewProgressivo('SNR', 'Sinistro');
        insert into Sinistro (
            CodSinistro, CodNoleggio, DataOraSinistro, CodPosizione, Dinamica
        ) VALUES (
            lvCodSinistro, pCodNoleggio, pDataOraSinistro, pCodPosizione, pDinamica
        );
    end if;
    --
    return lvCodSinistro;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function ChkInsStradaUR
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `ChkInsStradaUR`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ChkInsStradaUR`(
pDUG varchar(32),
pNome varchar(64),
pComune varchar(64),
pProvincia varchar(4),
pRegione varchar(3),
pNazione varchar(2),
pCAP varchar(5),
pLunghezza decimal (9,3),
pNumCarreggiate decimal(2),
pCodClassTec varchar(3)
) RETURNS varchar(12) CHARSET latin1
ChkInsStradaUR:BEGIN
    DECLARE lvCodStrada varchar(12);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select S.CodStrada
      into lvCodStrada
      from StradaUrbana SU
           inner join Strada S on (S.CodStrada = SU.CodStrada)
     where SU.Nazione = coalesce(pNazione, 'IT')
       and SU.Provincia = pProvincia
       and SU.Comune = pComune
       and SU.DUG = pDUG
       and S.Nome = pNome;
    --
    if lvRecNotFound = 1 then
        set lvCodStrada = NewProgressivo('STR', 'Strada');
        insert into Strada(
            CodStrada, Lunghezza, NumCarreggiate, CodClassTec, Nome
        ) VALUES (
            lvCodStrada, coalesce(pLunghezza, 0), coalesce(pNumCarreggiate, 1), pCodClassTec, pNome
        );
        --
        insert into StradaUrbana(
            CodStrada, DUG, CAP, Nazione, Regione, Provincia, Comune
        ) VALUES (
            lvCodStrada, pDUG, pCAP, coalesce(pNazione, 'IT'), pRegione, pProvincia, pComune
        );
    end if;
    --
    return lvCodStrada;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function ChkInsStradaXU
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `ChkInsStradaXU`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ChkInsStradaXU`(
pCodTipoStrada varchar(2),
pCodCategStrada varchar(8),
pNumero integer,
pAltroNumero integer,
pNome varchar(64),
pLunghezza decimal (9,3),
pNumCarreggiate decimal(2),
pCodClassTec varchar(3)
) RETURNS varchar(12) CHARSET latin1
ChkInsStradaXU:BEGIN
    DECLARE lvCodStrada varchar(12);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select S.CodStrada
      into lvCodStrada
      from StradaExtraurbana SX
           inner join Strada S on (S.CodStrada = SX.CodStrada)
     where SX.CodTipoStrada = pCodTipoStrada
       and coalesce(SX.CodCategStrada, '#') = coalesce(pCodCategStrada, '#')
       and SX.Numero = pNumero
       and coalesce(S.Nome, '#') = coalesce(pNome, '#');
    --
    if lvRecNotFound = 1 then
        set lvCodStrada = NewProgressivo('STR', 'Strada');
        insert into Strada(
            CodStrada, Lunghezza, NumCarreggiate, CodClassTec, Nome
        ) VALUES (
            lvCodStrada, coalesce(pLunghezza, 0), coalesce(pNumCarreggiate, 1), pCodClassTec, pNome
        );
        --
        insert into StradaExtraurbana(
            CodStrada, CodTipoStrada, CodCategStrada, Numero, AltroNumero
        ) VALUES (
            lvCodStrada, pCodTipoStrada, pCodCategStrada, pNumero, pAltroNumero
        );
    end if;
    --
    return lvCodStrada;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function ChkInsSvincolo
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `ChkInsSvincolo`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ChkInsSvincolo`(
pCodStrada varchar(12),
pNumCarreggiata tinyint(4),
pCodPosizione varchar(12),
pTipo char(1)
) RETURNS char(12)
--
ChkInsFruitore:BEGIN
    DECLARE lvCodSvincolo varchar(12);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodSvincolo
      into lvCodSvincolo
      from Svincolo
     where CodStrada = pCodStrada
       and NumCarreggiata = pNumCarreggiata
       and Tipo = pTipo
       and CodPosizione = pCodPosizione;
    --
    if lvRecNotFound = 1 then
		set lvCodSvincolo = smartmobility.NewProgressivo('SVI', 'Svincolo');
        insert into Svincolo (
            CodSvincolo, CodStrada, NumCarreggiata, CodPosizione, Tipo
        ) VALUES (
            lvCodSvincolo, pCodStrada, pNumCarreggiata, pCodPosizione, pTipo
        );
    end if;
    --
    return lvCodSvincolo;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function ChkInsTratta
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `ChkInsTratta`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ChkInsTratta`(
pCodStrada varchar(32),
pNumCarreggiata tinyint,
pLunghezza decimal (9,3),
pLatitudineIni decimal(10,7),
pLongitudineIni decimal(10,7),
pLatitudineFin decimal(10,7),
pLongitudineFin decimal(10,7)
) RETURNS varchar(12) CHARSET latin1
ChkInsTratta:BEGIN
    DECLARE lvCodTratta varchar(12);
    DECLARE lvCodPosizioneIni varchar(12);
    DECLARE lvCodPosizioneFIn varchar(12);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select T.CodTratta
      into lvCodTratta
      from Tratta T
           inner join Posizione PI on (PI.CodPosizione = T.CodPosizioneIni)
           inner join Posizione PF on (PF.CodPosizione = T.CodPosizioneFin)
     where T.CodStrada = pCodStrada
       and T.NumCarreggiata = pNumCarreggiata
       and PI.Latitudine = MyRound(pLatitudineIni, 0.00005)
       and PI.Longitudine = MyRound(pLongitudineIni, 0.00005)
       and PF.Latitudine = MyRound(pLatitudineFin, 0.00005)
       and PF.Longitudine = MyRound(pLongitudineFin, 0.00005);
    --
    if lvRecNotFound = 1 then
        set lvCodTratta = NewProgressivo('TRT', 'Tratta');
        set lvCodPosizioneIni = ChkInsPosizione(pLatitudineIni, pLongitudineIni, pCodStrada, NULL, NULL);
        set lvCodPosizioneFIn = ChkInsPosizione(pLatitudineFin, pLongitudineFin, pCodStrada, NULL, NULL);
        insert into Tratta(
            CodTratta, CodStrada, NumCarreggiata, Lunghezza, CodPosizioneIni, CodPosizioneFin
        ) VALUES (
            lvCodTratta, pCodStrada, pNumCarreggiata, pLunghezza, lvCodPosizioneIni, lvCodPosizioneFin
        );
        --
    end if;
    --
    return lvCodTratta;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function ChkInsValutazione
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `ChkInsValutazione`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ChkInsValutazione`(
pCFUtenteGiudicante varchar(16),
pRuoloUtenteGiudicante char(1),
pCFUtenteGiudicato varchar(16),
pRuoloUtenteGiudicato char(1),
pCodTragitto varchar(12),
pServizio varchar(32),
pRecensione varchar(256)
) RETURNS char(12) CHARSET latin1
ChkInsValutazione:BEGIN
    DECLARE lvCodValutazione varchar(12) default NULL;
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodValutazione
      into lvCodValutazione
      from Valutazione
     where CFUtenteGiudicante = pCFUtenteGiudicante
       and RuoloUtenteGiudicante = pRuoloUtenteGiudicante
       and CFUtenteGiudicato = pCFUtenteGiudicato
       and RuoloUtenteGiudicato = pRuoloUtenteGiudicato
       and CodTragitto = pCodTragitto
       and Servizio = pServizio;
    --
    if lvRecNotFound = 1 then
        set lvCodValutazione = NewProgressivo('VAL', 'Valutazione');
        insert into Valutazione (
            CodValutazione, CFUtenteGiudicante, RuoloUtenteGiudicante, CFUtenteGiudicato, RuoloUtenteGiudicato, CodTragitto, Servizio, Recensione
        ) VALUES (
            lvCodValutazione, pCFUtenteGiudicante, pRuoloUtenteGiudicante, pCFUtenteGiudicato, pRuoloUtenteGiudicato, pCodTragitto, pServizio, pRecensione
        );
    end if;
    --
    return lvCodValutazione;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ClassificaAuto
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `ClassificaAuto`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ClassificaAuto`()
ClassificaAuto: BEGIN
	--
	select @rank := @rank + 1 AS Classifica,
		   AU.NumTarga, 
		   AU.Comfort
	  from (
		    select A.NumTarga, A.Comfort
		      from AutovetturaRegistrata A
			       cross join (select @rank := 0) R
		    order by A.Comfort desc, A.AnnoImmatricolazione desc
		   ) as AU;
	--
END $$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ClassificaUtenti
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `ClassificaUtenti`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ClassificaUtenti`(
Comportamento TINYINT,
GiudizioP TINYINT,
Serieta TINYINT,
PiacereViaggio TINYINT,
RispettoOrari TINYINT,
RispettoLimiti TINYINT,
ruoloGto CHAR(1)
)
BEGIN
	IF GiudizioP THEN
		SELECT @rank := @rank + 1 AS Rank,
			P.CFUtenteGiudicato,
			P. CodAspettoValutabile,
			P.Voto
		FROM(
			SELECT V.CFUtenteGiudicato,
				VA.CodAspettoValutabile,
				AVG(VA.Voto) AS Voto
			FROM Valutazione V
				NATURAL JOIN ValutazioneAspetti VA
			WHERE VA.CodAspettoValutabile = 'ASP000000001'
				AND V.RuoloUtenteGiudicato = RuoloGto
			GROUP BY V.CFUtenteGiudicato
		) AS P CROSS JOIN (SELECT @rank := 0) AS R
        ORDER BY Voto desc;
	END IF;

IF Comportamento THEN
		SELECT @rank := @rank + 1 AS Rank,
			P.CFUtenteGiudicato,
			P.CodAspettoValutabile,
			P.Voto
		FROM(
			SELECT V.CFUtenteGiudicato,
				VA.CodAspettoValutabile,
				AVG(VA.Voto) AS Voto
			FROM Valutazione V
				NATURAL JOIN ValutazioneAspetti VA
			WHERE VA.CodAspettoValutabile = 'ASP000000002'
				AND V.RuoloUtenteGiudicato = RuoloGto
			GROUP BY V.CFUtenteGiudicato
		) AS P CROSS JOIN (SELECT @rank := 0) AS R
        ORDER BY Voto desc;
	END IF;

IF Serieta THEN
		SELECT @rank := @rank + 1 AS Rank,
			P.CFUtenteGiudicato,
			P.CodAspettoValutabile,
			P.Voto
		FROM(
			SELECT V.CFUtenteGiudicato,
				VA.CodAspettoValutabile,
				AVG(VA.Voto) AS Voto
			FROM Valutazione V
				NATURAL JOIN ValutazioneAspetti VA
			WHERE VA.CodAspettoValutabile = 'ASP000000003'
				AND V.RuoloUtenteGiudicato = RuoloGto
			GROUP BY V.CFUtenteGiudicato
		) AS P CROSS JOIN (SELECT @rank := 0) AS R
        ORDER BY Voto desc;
	END IF;

IF PiacereViaggio THEN
		SELECT @rank := @rank + 1 AS Rank,
			P.CFUtenteGiudicato,
			P. CodAspettoValutabile,
			P.Voto
		FROM(
			SELECT V.CFUtenteGiudicato,
				VA.CodAspettoValutabile,
				AVG(VA.Voto) AS Voto
			FROM Valutazione V
				NATURAL JOIN ValutazioneAspetti VA
			WHERE VA.CodAspettoValutabile = 'ASP000000004'
				AND V.RuoloUtenteGiudicato = RuoloGto
			GROUP BY V.CFUtenteGiudicato
		) AS P CROSS JOIN (SELECT @rank := 0) AS R
        ORDER BY Voto desc;
END IF;

IF RispettoOrari THEN
		SELECT @rank := @rank + 1 AS Rank,
			P.CFUtenteGiudicato,
			CodAspettoValutabile,
			P.Voto
		FROM(
			SELECT V.CFUtenteGiudicato,
				VA.CodAspettoValutabile,
				AVG(VA.Voto) AS Voto
			FROM Valutazione V
				NATURAL JOIN ValutazioneAspetti VA
			WHERE VA.CodAspettoValutabile = 'ASP000000005'
				AND V.RuoloUtenteGiudicato = RuoloGto
			GROUP BY V.CFUtenteGiudicato
		) AS P CROSS JOIN (SELECT @rank := 0) AS R
        ORDER BY Voto desc;
	END IF;

IF RispettoLimiti THEN
		SELECT @rank := @rank + 1 AS Rank,
			P.CFUtenteGiudicato,
			P. CodAspettoValutabile,
			P.Voto
		FROM(
			SELECT V.CFUtenteGiudicato,
				VA.CodAspettoValutabile,
				AVG(VA.Voto) AS Voto
			FROM Valutazione V
				NATURAL JOIN ValutazioneAspetti VA
			WHERE VA.CodAspettoValutabile = 'ASP000000006'
				AND V.RuoloUtenteGiudicato = RuoloGto
			GROUP BY V.CFUtenteGiudicato
		) AS P CROSS JOIN (SELECT @rank := 0) AS R
        ORDER BY Voto desc;
	END IF;
    --
END $$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CloseTrattaTracciata
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `CloseTrattaTracciata`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CloseTrattaTracciata`(
pCodTratta varchar(32),
pCodPosizioneFin varchar(12),
pCodTracciamentoU varchar(12),
pDataOraUscita datetime
)
CloseTrattaTracciata:BEGIN
    DECLARE lvLunghezzaTratta DECIMAL(9,3);
    DECLARE lvDataOraEntrata datetime;
    DECLARE lvDataOraUscita datetime;
    DECLARE lvTempoImpiegato INT;
    DECLARE lvTempoMedio decimal(13,2);
    DECLARE lvCodFascia varchar(12);
    DECLARE lvCodPosizioneIni varchar(12);
    DECLARE lvCodTrattaDaUsare varchar(12);
    DECLARE lvCodAltraTratta varchar(12);
    DECLARE lvCodTracciamentoE varchar(12);
    DECLARE lvNewDataOraEntrata datetime;
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    set lvCodTrattaDaUsare = pCodTratta;
    -- Determino la posizione iniziale della tratta
    select CodPosizioneIni
      into lvCodPosizioneIni
      from tratta T
	 where CodTratta = pCodTratta;
	-- Determino se esista già una tratta (diversa da pCodTratta) che abbia le stesse posizioni iniziale e finale
    set lvRecNotFound = 0;
    select CodTratta
      into lvCodAltraTratta
      from tratta T
	 where CodPosizioneIni = lvCodPosizioneIni
       and CodPosizioneFin = pCodPosizioneFin;
	--
    if lvRecNotFound = 1 then -- LA TRATTA DESIDERATA NON ESISTE
		-- Determiniamo la lunghezza della tratta da chiudere
		select abs(FIN.Chilometro - INI.Chilometro)
		  into lvLunghezzaTratta
		  from Posizione FIN,
			   Tratta T
			   inner join Posizione INI on (INI.CodPosizione = T.CodPosizioneIni)
		 where FIN.CodPosizione = pCodPosizioneFin
		   and T.CodTratta = pCodTratta;
		-- Chiudiamo la Tratta
		update Tratta
		   set Lunghezza = lvLunghezzaTratta,
			   CodPosizioneFin = pCodPosizioneFin
		 where CodTratta = pCodTratta;
		--
	else -- LA TRATTA DESIDERATA ESISTE (ed è lvCodAltraTratta)
		set lvCodTrattaDaUsare = lvCodAltraTratta;
	end if;
	-- Recupero la DataOraEntrata nella tratta
	select DataOraEntrata
	  into lvNewDataOraEntrata
	  from TrattaTracciata
	 where CodTratta = pCodTratta;

	--
	update TrattaTracciata
	   set CodTratta = lvCodTrattaDaUsare,
           DataOraUscita = pDataOraUScita,
		   CodTracciamentoU = pCodTracciamentoU
	 where CodTratta = pCodTratta
       and DataOraEntrata = lvNewDataOraEntrata;
	-- Cancella la tratta inutile
    if lvCodTrattaDaUsare != pCodTratta then
		delete from tratta where CodTratta = pCodTratta;
    end if;
    -- Calcoliamo il tempo (come numero di secondi) impiegato a percorrere la tratta
    select DataOraEntrata, DataOraUscita, TimestampDiff(SECOND, DataOraEntrata, DataOraUscita)
      into lvDataOraEntrata, lvDataoraUscita, lvTempoImpiegato
      from TrattaTracciata
     where CodTratta = lvCodTrattaDaUsare
       and DataOraEntrata = lvNewDataOraEntrata;
    -- Memorizziamo il tempo impiegato nella tabella TrattaPercorsa
    insert into TrattaPercorsa (
        CodTratta, DataOraInserimento, TempoPercorrenza
    ) VALUES (
        lvCodTrattaDaUsare, current_timestamp(), lvTempoImpiegato
    );
    -- Calcolo il tempo medio di tutti i tempi di percorrenza della tratta
    -- inseriti nella fascia oraria a cui appartiene pDataOraUScita
    select FO.CodFascia, avg(TP.TempoPercorrenza)
      into lvCodFascia, lvTempoMedio
      from TrattaPercorsa TP
           inner join FasciaOraria FO on (
               time(pDataOraUscita) >= FO.OraIni
               and time(pDataOraUscita) < FO.OraFin
           )
     where TP.CodTratta = lvCodTrattaDaUsare
     group by FO.CodFascia;
    --
    call smartmobility.UpdInsTrattaTemporizzata(lvCodTrattaDaUsare, lvCodFascia, lvTempoMedio);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ConsegnaNoleggio
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `ConsegnaNoleggio`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ConsegnaNoleggio`(
pCodPrenotazione varchar(12),
pQtaCarburanteFin decimal(7,0),
pKmPercorsiFin decimal(7,0)
) 
--
ConsegnaNoleggio:BEGIN
    DECLARE lvCodNoleggio varchar(12) default NULL;
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodNoleggio
      into lvCodNoleggio
      from Noleggio
     where CodPrenotazione = pCodPrenotazione;
    --
    if lvRecNotFound = 1 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il noleggio non esiste';
    end if;
    --
    update Noleggio
       set QtaCarburanteFin = pQtaCarburanteFin,
           KmPercorsiFin = pKmPercorsiFin
	 where CodNoleggio = lvCodNoleggio;
	--
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure EliminaAutovettura
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `EliminaAutovettura`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliminaAutovettura`(
pNumTarga varchar(8)
)
EliminaAutovettura:BEGIN
    DECLARE AUTOVETTURA_INESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION begin
        ROLLBACK;
    end;
    --
    if EsisteAutovettura(pNumTarga) = 'N' then
        SIGNAL AUTOVETTURA_INESISTENTE
           SET MESSAGE_TEXT = 'Autovettura inesistente';
    end if;
    START TRANSACTION;
    -- Elimiamo i costi dell'autovettura
    delete from CostoAutovettura
     where NumTarga = pNumTarga;
    -- Eliminiamo gli optional dell'autovettura
    delete from OptionalAuto
     where NumTarga = pNumTarga;
    -- Eliminiamo l'autovettura registrata
    delete from AutovetturaRegistrata
     where NumTarga = pNumTarga;
    -- Eliminiamo l'autovettura
    delete from Autovettura
     where NumTarga = pNumTarga;
    COMMIT;
 END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure EliminaUtente
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `EliminaUtente`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliminaUtente`(
pCodFiscale varchar(16)
)
EliminaUtente:BEGIN
    DECLARE UTENTE_INESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    if EsisteUtente(pCOdFiscale) = 'N' then
        SIGNAL UTENTE_INESISTENTE SET MESSAGE_TEXT = 'Utente inesistente';
    end if;
    -- Elimiamo i L'account dell'utente
    delete from Account
     where CodFiscale = pCodFiscale;
    -- Eliminiamo il Documento di Riconoscimento dell'autovettura
    delete from DocumentoRiconoscimento
     where CodFiscale = pCodFiscale;
    -- Eliminiamo l'utente
    delete from Utente
     where CodFiscale = pCodFiscale;
 END$$

DELIMITER ;

-- -----------------------------------------------------
-- function EsisteAutovettura
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `EsisteAutovettura`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `EsisteAutovettura`(
pNumTarga varchar(8)
) RETURNS char(1) CHARSET latin1
    COMMENT 'Restituisce S o N a seconda che pNumTarga sia presente nella tabella Autovettura'
EsisteAutovettura:BEGIN
    DECLARE lvRes char(1) default 'N';
    select 'S'
      into lvRes
      from Autovettura
     where NumTarga = pNumTarga;
    --
    return lvRes;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function EsisteChiamata
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `EsisteChiamata`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `EsisteChiamata`(
pCodChiamata varchar(12)
) RETURNS char(1)
    COMMENT 'Restituisce S o N a seconda che pCodChiamata sia presente nella tabella Chiamata'
EsisteChiamata:BEGIN
    DECLARE lvRes char(1) default 'N';
    select 'S'
      into lvRes
      from Chiamata
     where CodChiamata = pCodChiamata;
    --
    return lvRes;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function EsistePool
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `EsistePool`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `EsistePool`(
pCodPool varchar(12)
) RETURNS char(1) CHARSET latin1
    COMMENT 'Restituisce S o N a seconda che pCodPool sia presente nella tabella Pool'
EsistePool:BEGIN
    DECLARE lvRes char(1) default 'N';
    select 'S'
      into lvRes
      from Pool
     where CodPool = pCodPool;
    --
    return lvRes;
END$$

DELIMITER ;


-- -----------------------------------------------------
-- function EsistePrenotazioneCP
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `EsistePrenotazioneCP`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `EsistePrenotazioneCP`(
pCodPrenotazione varchar(12)
) RETURNS char(1)
    COMMENT 'Restituisce S o N a seconda che pCodPrenotazione sia presente nella tabella PrenotazioneCP'
EsistePrenotazioneCP:BEGIN
    DECLARE lvRes char(1) default 'N';
    select 'S'
      into lvRes
      from PrenotazioneCP
     where CodPrenotazione = pCodPrenotazione;
    --
    return lvRes;
END$$

DELIMITER ;


-- -----------------------------------------------------
-- function EsistePrenotazioneCS
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `EsistePrenotazioneCS`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `EsistePrenotazioneCS`(
pCodPrenotazione varchar(12)
) RETURNS char(1) CHARSET latin1
    COMMENT 'Restituisce S o N a seconda che pCodPrenotazione sia presente nella tabella PrenotazioneCS'
EsistePrenotazioneCS:BEGIN
    DECLARE lvRes char(1) default 'N';
    select 'S'
      into lvRes
      from PrenotazioneCS
     where CodPrenotazione = pCodPrenotazione;
    --
    return lvRes;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function EsisteTragitto
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `EsisteTragitto`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `EsisteTragitto`(
pCodTragitto varchar(16)
) RETURNS char(1)
    COMMENT 'Restituisce S o N a seconda che pCodTragitto sia presente nella tabella Tragitto'
EsisteTragitto:BEGIN
    DECLARE lvRes char(1) default 'N';
    select 'S'
      into lvRes
      from Tragitto
     where CodTragitto = pCodTragitto;
    --
    return lvRes;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function EsisteUsername
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `EsisteUsername`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `EsisteUsername`(
pUsername varchar(32)
) RETURNS char(1) CHARSET latin1
    COMMENT 'Restituisce S o N a seconda che pUsername sia presente nella tabella Account'
EsisteUsername:BEGIN
    DECLARE lvRes char(1) default 'N';
    select 'S'
      into lvRes
      from Account
     where Username = pUsername;
    --
    return lvRes;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function EsisteUtente
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `EsisteUtente`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `EsisteUtente`(
pCodFiscale varchar(16)
) RETURNS char(1) CHARSET latin1
    COMMENT 'Restituisce S o N a seconda che pCodFiscale sia presente nella tabella Utente'
EsisteUtente:BEGIN
    DECLARE lvRes char(1) default 'N';
    select 'S'
      into lvRes
      from Utente
     where CodFiscale = pCodFiscale;
    --
    return lvRes;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GestioneRuolo
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `GestioneRuolo`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GestioneRuolo`(
pCodFiscale varchar(16),
pRuolo varchar(16),
pOperazione varchar(8)
)
GestioneRuolo:BEGIN
    DECLARE CODFISCALE_INESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    if EsisteUtente(pCodFiscale) = 'N' then
        SIGNAL CODFISCALE_INESISTENTE
           SET MESSAGE_TEXT = 'Utente non è registrato';
    end if;
    --
    if pOperazione = 'GRANT' then
        if pRuolo = 'FRUITORE' then
            set pCodFiscale = ChkInsFruitore(pCodFiscale);
        elseif pRuolo = 'PROPONENTE' then
            set pCodFiscale = ChkInsProponente(pCodFiscale);
        end if;
    elseif pOperazione = 'REVOKE' then
        if pRuolo = 'FRUITORE' then
            delete from Fruitore where CodFiscale = pCodFiscale;
        elseif pRuolo = 'PROPONENTE' then
            delete from Proponente where CodFiscale = pCodFiscale;
        end if;
    end if;
 END$$

DELIMITER ;

-- -----------------------------------------------------
-- function GetCodStrada
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `GetCodStrada`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `GetCodStrada`(
pStrada varchar(256)
) RETURNS varchar(256) CHARSET latin1
    COMMENT 'Restituisce (o ne crea uno nuovo e poi lo restituisce) il codice della strada corrispondente a pStrada'
GetCodStrada:BEGIN
    DECLARE lvCodStrada varchar(12) default 'TOBEFOUND';
    DECLARE lvLen int;
    DECLARE lvIdx int;
    DECLARE lvChr varchar(1);
    DECLARE lvTok varchar(64) default '';
    DECLARE lvNextProgr int;
    DECLARE lvStato varchar(32) default 'START';
    DECLARE lvDUG varchar(32) default '';
    DECLARE lvNomeStd varchar(64) default '';
    DECLARE lvComune varchar(64) default '';
    DECLARE lvProvincia varchar(4) default '';
    DECLARE lvNazione varchar(2) default '';
    DECLARE lvTipoStrada varchar(32) default '';
    DECLARE lvNumero varchar(32) default '';
    DECLARE lvAltroNumero varchar(32) default '';
    DECLARE lvCategoria varchar(8) default '';
    DECLARE lvNome varchar(64) default '';
   -- DECLARE lvRecNotFound int default 0;
    -- DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    set pStrada = upper(pStrada);
    set lvLen = length(pStrada);
    set lvIdx = 1;
    while lvIdx <= lvLen do
        set lvChr = substr(pStrada, lvIdx, 1);
        case lvstato
            when 'START' then
                if IsNumeric(lvChr) = 'S' then
                    if isTipoStrada(lvTok) = 'S' then
                        set lvTipoStrada = lvTok;
                        set lvTok = '';
                        set lvStato = 'TIPO_STRADA';
                        set lvNumero = lvChr;
                    else
                        return concat('ERR at ', lvIdx, ' <', lvTipoStrada, '>'); 
                    end if;
                elseif lvChr = ' ' then
                    if isTipoStrada(lvTok) = 'S' then
                        set lvTipoStrada = lvTok;
                        set lvTok = '';
                        set lvStato = 'TIPO_STRADA';
                    else
                        set lvDUG = lvTok;
                        set lvTok = '';
                        set lvStato = 'DUG';
                    end if;
                else
                    set lvTok = concat(lvTok, lvChr);
                end if;
            when 'DUG' then
                if lvChr = ',' then
                    set lvStato = 'NOME_STD';
                else
                    set lvNomeStd = concat(lvNomeStd, lvChr);
                end if;
            when 'NOME_STD' then
                if lvChr = '(' then
                    set lvStato = 'COMUNE';
                else
                    set lvComune = concat(lvComune, lvChr);
                end if;
            when 'COMUNE' then
                if lvChr = ')' then
                    set lvStato = 'PROVINCIA';
                else
                    set lvProvincia = concat(lvProvincia, lvChr);
                end if;
            when 'PROVINCIA' then
                if lvIdx = lvLen then
                    set lvStato = 'NAZIONE';
                else
                    set lvNazione = concat(lvNazione, lvChr);
                end if;
           -- RICONOSCIMENTO di una strada extraurbana
            when 'TIPO_STRADA' then
                if isNumeric(lvChr) = 'N' then
                    if lvChr != ' ' and lvChr != '/' then
                        set lvTok = lvChr;
                    end if;
                    set lvStato = 'NUMERO';
                else
                    set lvNumero = concat(lvNumero, lvChr);
                end if;
            when 'NUMERO' then
                if lvChr = ' ' or lvIdx = lvLen  then
                    if lvIdx = lvLen then set lvTok = concat(lvTok, lvChr); end if;
                    -- dopo NUMERO, nella variabile lvTok potrebbe esserci: un altro numero, oppure una categoria oppure il nome
                    if isNumeric(lvTok) = 'S' then
                        set lvAltroNumero = lvTok;
                        set lvTok = '';
                        set lvStato = 'ALTRO_NUMERO';
                    elseif isCategoria(lvTok) = 'S' then
                        set lvCategoria = lvTok;
                        set lvTok = '';
                        set lvStato = 'CATEGORIA';
                    else
                        set lvNome = lvTok;
                        set lvTok = '';
                        set lvStato = 'NOME';
                    end if;
                else
                    set lvTok = concat(lvTok, lvChr);
                end if;
                --
            when 'ALTRO_NUMERO' then
                if lvChr = ' ' or lvIdx = lvLen then
                    if lvIdx = lvLen then set lvTok = concat(lvTok, lvChr); end if;
                    -- dopo ALTRO_NUMERO, nella variabile lvTok potrebbe esserci: una categoria oppure il nome
                    if isCategoria(lvTok) = 'S' then
                        set lvCategoria = lvTok;
                        set lvTok = '';
                        set lvStato = 'CATEGORIA';
                    else
                        set lvNome = lvTok;
                        set lvTok = '';
                        set lvStato = 'NOME';
                    end if;
                else
                    set lvTok = concat(lvTok, lvChr);
                end if;
            when 'CATEGORIA' then
                if lvChr = ' ' or lvIdx = lvLen then
                    if lvIdx = lvLen then set lvTok = concat(lvTok, lvChr); end if;
                    -- dopo CATEGORIA, nella variabile lvTok potrebbe esserci solo il nome
                    set lvNome = lvTok;
                    set lvTok = '';
                    set lvStato = 'NOME';
                else
                   set lvTok = concat(lvTok, lvChr);
                end  if;
            when 'NOME' then
                return concat('ERR at ', lvIdx, ' <', lvChr, '>');
            else
                return concat(lvStato, ' non gestito.');
        end case;
        --
        set lvIdx = lvIdx + 1;
    end while;
-- STRADA URBANA
 return concat(pStrada, '-', lvidx, '/', lvLen, ' (', lvChr, '): ', coalesce(nullif(lvDUG,''),'-'), ', ', coalesce(nullif(lvNomeStd,''),'-'), ', ', coalesce(nullif(lvComune,''),'-'), ', ', coalesce(nullif(lvProvincia,''),'-'), ', ', coalesce(nullif(lvNazione,''),'-'));
-- STRADA EXTRAURBANA
-- return concat(pStrada, '-', lvidx, '/', lvLen, ' (', lvChr, '): ', coalesce(nullif(lvTipoStrada,''),'-'), ', ', coalesce(nullif(lvNumero,''),'-'), ', ', coalesce(nullif(lvAltroNumero,''),'-'), ', ', coalesce(nullif(lvCategoria,''),'-'), ', ', coalesce(nullif(lvNome,''),'-'));
    if lvDug != '' then
        set lvCodStrada = ChkInsStradaUR(lvDUG, lvNomeStd, lvComune, lvProvincia, nullif(lvNazione,''));
    else
        set lvCodStrada = ChkInsStradaXU(lvTipoStrada, lvNNumero, lvAltroNumero, lvNome);
    end if;
    return lvCodStrada;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function GetCodTragitto
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `GetCodTragitto`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `GetCodTragitto`(
pNumTarga varchar(8),
pDataOra  datetime
) RETURNS varchar(16) CHARSET latin1
GetCodTragitto:BEGIN
    DECLARE lvCodTragitto varchar(12) default NULL;
    DECLARE lvRecFound int default 1;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecFound = 0;
    -- Tentiamo il servizio di Car Sharing
    select TTCS.CodTragitto
      into lvCodTragitto
      from TragittoTracciatoCS TTCS
           inner join Noleggio NCS on (NCS.CodNoleggio = TTCS.CodNoleggio)
           inner join PrenotazioneCS PCS on (PCS.CodPrenotazione = NCS.CodPrenotazione)
     where PCS.NumTarga = pNumTarga
       and PCS.DataIni <= date(pDataOra)
       and PCS.DataFin >= date(pDataOra);
    --
    if lvRecFound = 1 then return lvCodTragitto; end if;
    -- Tentiamo il servizio di Car Pooling
    select TT.CodTragitto
      into lvCodTragitto
      from TragittoTracciato TT
           inner join Pool P on (P.CodTragittoTrc = TT.CodTragitto)
     where P.NumTarga = pNumTarga
       and timestamp(P.DataPartenza, P.OraPartenza) <= pDataOra
       and date(pDataOra) <= P.DataArrivo;
    --
    if lvRecFound = 1 then return lvCodTragitto; end if;
    -- Tentiamo il servizio di Ride Sharing On Demand
    select TT.CodTragitto
      into lvCodTragitto
      from TragittoTracciato TT
           inner join Corsa C on (C.CodTragittoTrc = TT.CodTragitto)
           inner join Chiamata CH on (CH.CodChiamata = C.CodChiamata)
           inner join Sharing S on (S.CodSharing = CH.CodSharing)
	 where S.NumTarga = pNumTarga
       and C.DataOraInizioCorsa <= pDataOra
       and C.DataOraFineCorsa is null;
    --
    if lvRecFound = 1 then return lvCodTragitto; end if;
    --
    return lvCodTragitto;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function GetComfortAuto
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `GetComfortAuto`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `GetComfortAuto`(
pNumTarga varchar(8)
) RETURNS decimal(3,2)
    COMMENT 'Restituisce un valore da 0 a 5 (stelle) che rappresenta il livello di comfort dell''autovettura'
GetComfortAuto:BEGIN
    DECLARE NO_AUTOVETTURA CONDITION FOR SQLSTATE '45000';
    DECLARE NO_OPTIONAL CONDITION FOR SQLSTATE '45000';
    DECLARE lvRecNotFound int default 0;
    DECLARE lvComfort decimal(3,2);
    DECLARE lvCilindrata decimal(5);
    DECLARE lvNumOptP int;
    DECLARE lvNumOptS int;
    DECLARE lvValOptS int;
    DECLARE lvNumOptPAuto int;
    DECLARE lvNumOptSAuto int;
    DECLARE lvValOptSAuto int;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    -- Recupero la cilindrata dell'autovettura
    set lvRecNotFound = 0;
    select Cilindrata
      into lvCilindrata
      from AutovetturaRegistrata
     where NumTarga = pNumTarga;
    if lvRecNotFound = 1 then
        SIGNAL NO_AUTOVETTURA
            SET MESSAGE_TEXT = 'Vettura inesistente';
    end if;
    -- Recupero il numero di optional primari
    select count(*)
      into lvNumOptP
      from Optional
     where TipoOptional = 'P';
    if lvNumOptP = 0 then
        SIGNAL NO_OPTIONAL
            SET MESSAGE_TEXT = 'Nessun Optional PRIMARIO nell\'anagrafica degli Optional.';
    end if;
    -- Recupero il numero e la somma dei voti degli optional secondari
    select count(*), sum(Voto)
      into lvNumOptS, lvValOptS
      from Optional
     where TipoOptional = 'S';
    if lvNumOptS = 0 then
        SIGNAL NO_OPTIONAL
            SET MESSAGE_TEXT = 'Nessun Optional SECONDARIO nell\'anagrafica degli Optional.';
    end if;
    -- Recupero il numero di optional primari posseduti dall'auto
    select count(*)
      into lvNumOptPAuto
      from OptionalAuto OA
           inner join Optional O on (
               O.CodOptional = OA.CodOptional
           )
     where OA.NumTarga = pNumTarga
       and O.TipoOptional = 'P';
    -- Recupero il numero e la somma dei voti degli optional secondari posseduti dall'auto
    select count(*), sum(O.Voto)
      into lvNumOptSAuto, lvValOptSAuto
      from OptionalAuto OA
           inner join Optional O on (
               O.CodOptional = OA.CodOptional
           )
     where OA.NumTarga = pNumTarga
       and O.TipoOptional = 'S';
    --
    set lvComfort = (
        (lvNumOptPAuto/lvNumOptP) * 3 +  -- Contributo degli optional primari
        (lvValOptSAuto/lvValOptS) * 2 + -- Contributo degli optional secondari
        case
            when lvCilindrata between 0 and 599 then 2
            when lvCilindrata between 600 and 999 then 3
            when lvCilindrata between 1000 and 1199 then 3.5
            when lvCilindrata between 1200 and 1599 then 4
            when lvCilindrata between 1600 and 1999 then 4.5
            when lvCilindrata >= 2000 then 5
        end -- Contributo della cilindrata
        ) / 2;
    return MyRound(lvComfort, 0.5);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function GetFlessibilita
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `GetFlessibilita`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `GetFlessibilita`(
pFlessibilita int
) RETURNS varchar(5)
GetFlessibilita:BEGIN
    DECLARE lvRes varchar(5) default NULL;
    --
    if pFlessibilita <= 5 then
		set lvRes = 'Bassa';
	elseif pFlessibilita > 5 and pFlessibilita <= 10 then
		set lvRes = 'Media';
	elseif pFlessibilita > 10 and pFlessibilita <= 15 then
		set lvRes = 'Alta';
	else
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La flessibilità è troppo alta';
	end if;
    --
    return lvRes;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetLunghezzaTrgPrg
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `GetLunghezzaTrgPrg`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetLunghezzaTrgPrg`(
pCodTragitto varchar(12)
)
--
GetLunghezzaTrgPrg:BEGIN
    declare lvLunghezza decimal(9,3) default NULL;
    --
    select sum(Lunghezza)
      into lvLunghezza
      from TrattaTragittoPrg TTP
           natural join Tratta T 
     where TTP.CodTragitto = pCodTragitto;
    --
    update TragittoProgrammato
       set Lunghezza = lvLunghezza
     where CodTragitto = pCodTragitto;
    --
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function GetPostiIniziali
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `GetPostiIniziali`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `GetPostiIniziali`(
pNumTarga varchar(7)
) RETURNS int
GetPostiIniziali:BEGIN
    DECLARE lvRes int default NULL;
    --
    select NumPosti - 1
      into lvRes
      from AutovetturaRegistrata
     where NumTarga = pNumTarga;
    --
    return lvRes;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetPrevTracciamento
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `GetPrevTracciamento`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetPrevTracciamento`(
pNumTarga  varchar(8),
pTimestamp datetime,
out poCodTracciamento varchar(12),
out poTimestamp datetime,
out poLatitudine decimal(10,7),
out poLongitudine decimal(10,7),
out poChilometro decimal(9,3),
-- Strada
out poNazione varchar(2),
out poRegione varchar(3),
out poProvincia varchar(4),
out poComune varchar(64),
-- Strada URBANA
out poDUG varchar(32),
out poNomeStd varchar(64),
-- Strada EXTRAURBANA
out poTipoStrada varchar(2),
out poCategStrada varchar(8),
out poNumero int(11),
out poNome varchar(64)
)
GetPrevTracciamento:BEGIN
    select TR.CodTracciamento, TR.Timestamp, TR.Latitudine, TR.Longitudine,
           TR.Chilometro, TR.Nazione, TR.Regione, TR.Provincia, TR.Comune,
           TR.DUG, TR.NomeStd,
           TR.TipoStrada, TR.CategStrada, TR.Numero, TR.Nome
      into poCodTracciamento, poTimestamp, poLatitudine, poLongitudine,
           poChilometro, poNazione, poRegione, poProvincia, poComune,
           poDUG, poNomeStd,
           poTipoStrada, poCategStrada, poNumero, poNome
      from Tracciamento TR
     where TR.NumTarga = pNumTarga
       and TR.Timestamp = (
               select max(T.Timestamp)
                 from Tracciamento T
                where T.NumTarga = TR.NumTarga
                  and T.Timestamp < pTimestamp
           );
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetServizioCorrente
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `GetServizioCorrente`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetServizioCorrente`(
pNumTarga varchar(8),
pDataOra  datetime,
out pServizio varchar(12),
out pCodServizio varchar(12)
)
GetServizioCorrente:BEGIN
    DECLARE lvRecFound int default 1;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecFound = 0;
    set pServizio = NULL;
    set pCodServizio = NULL;
    -- Tentiamo il servizio di Car Sharing
    select NCS.CodNoleggio, 'CarSharing'
      into pCodServizio, pServizio
      from Noleggio NCS
           inner join PrenotazioneCS PCS on (PCS.CodPrenotazione = NCS.CodPrenotazione)
     where PCS.NumTarga = pNumTarga
       and PCS.DataIni <= date(pDataOra)
       and PCS.DataFin >= date(pDataOra);
    --
    if lvRecFound = 1 then leave GetServizioCorrente; end if;
    -- Tentiamo il servizio di Car Pooling
    select P.CodPool, 'CarPooling'
      into pCodServizio, pServizio
      from Pool P
     where P.NumTarga = pNumTarga
       and timestamp(P.DataPartenza, P.OraPartenza) <= pDataOra
       and P.DataArrivo is null;
    --
    if lvRecFound = 1 then leave GetServizioCorrente; end if;
    -- Tentiamo il servizio di Ride Sharing On Demand
    select S.CodSharing, 'RideSharing'
      into pCodServizio, pServizio
      from Corsa C
           inner join Chiamata CH on (CH.CodChiamata = C.CodChiamata)
           inner join Sharing S on (S.CodSharing = CH.CodSharing)
     where S.NumTarga = pNumTarga
       and C.DataOraInizioCorsa <= pDataOra
       and C.DataOraFineCorsa is null;
    --
    if lvRecFound = 1 then leave GetServizioCorrente; end if;
    --
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function GiornoSettimana
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `GiornoSettimana`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `GiornoSettimana`(
pGiornoSettimana varchar(3)
) RETURNS int(11)
    COMMENT 'Restituisce il giorno della settimana come intero (DOM = 1, LUN = 2, MAR = 3 ...)'
GiornoSettimana:BEGIN
    DECLARE lvRes int;
    set lvRes = case pGiornoSettimana
                    when 'DOM' then 1
                    when 'LUN' then 2
                    when 'MAR' then 3
                    when 'MER' then 4
                    when 'GIO' then 5
                    when 'VEN' then 6
                    when 'SAB' then 7
                end;
    --
    return lvRes;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GiudizioRiepilogativo
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `GiudizioRiepilogativo`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GiudizioRiepilogativo`(
pCodFiscale VARCHAR(16),
pGiudizioP VARCHAR(16),
pComportamento VARCHAR(16),
pSerieta VARCHAR(16),
pPiacereViaggio VARCHAR(16),
pRispettoOrari VARCHAR(16),
pRispettoLimiti VARCHAR(16),
pRuoloGto CHAR(1)
)
GiudizioRiepilogativo: BEGIN
	SELECT CFUtenteGiudicato,
		   CodAspettoValutabile,
		   AVG(Voto) AS Voto
	  FROM Valutazione 
		   NATURAL JOIN ValutazioneAspetti
	 WHERE CFUtenteGiudicato = pCodFiscale
	   AND (
		   CodAspettoValutabile = pGiudizioP
		   OR CodAspettoValutabile = pComportamento
		   OR CodAspettoValutabile = pSerieta
		   OR CodAspettoValutabile = pPiacereViaggio
           OR CodAspettoValutabile = pRispettoOrari
		   OR CodAspettoValutabile = pRispettoLimiti	
		   )
       AND RuoloUtenteGiudicato = pRuoloGto
     GROUP BY CFUtenteGiudicato,
		      CodAspettoValutabile;
END $$

DELIMITER ;

-- -----------------------------------------------------
-- procedure IndividuaResidenza
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `IndividuaResidenza`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `IndividuaResidenza`(
pCodFiscale varchar(16)
)
--
IndividuaResidenza:BEGIN
    --
    select SU.DUG, S.Nome, I.Civico, I.Esponente, SU.Comune, SU.Provincia
      from Indirizzo I
           inner join Utente U on (U.CodIndirizzo = I.CodIndirizzo)
           inner join Strada S on (I.CodStrada = S.CodStrada)
           inner join StradaUrbana SU on (S.CodStrada = SU.CodStrada)
	 where U.CodFiscale = pCodFiscale;
    --  
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function IndividuaSinistro
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `IndividuaSinistro`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `IndividuaSinistro`(
pCodStrada varchar(12),
pChilometro decimal(9,3),
pLatitudine decimal(10,7),
pLongitudine decimal(10,7)
) RETURNS char(12)
--
IndividuaSinistro:BEGIN
    DECLARE lvCodSinistro varchar(12) default NULL;
    --
    if pLatitudine is not null and pLongitudine is not null then
		select CodSinistro
		  into lvCodSinistro
		  from Sinistro
		 where CodPosizione = ChkInsPosizione(pLatitudine, pLongitudine, NULL, NULL, NULL);
	else
		select CodSinistro 
          into lvCodSinistro
          from Sinistro S
               inner join Posizione P on (S.CodPosizione = P.CodPosizione)
		 where P.CodStrada = pCodStrada
           and P.Chilometro = pChilometro;
	end if;
    --
    return lvCodSinistro;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure IndividuaUltimaPosizione
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `IndividuaUltimaPosizione`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `IndividuaUltimaPosizione`(
pNumTarga varchar(8)
)
--
IndividuaUltimaPosizione:BEGIN
    --
    select *
      from Tracciamento T
     where T.NumTarga = 'EH732KV'
       and T.Timestamp = (
           select max(T2.Timestamp)
             from Tracciamento T2
            where T2.NumTarga = 'EH732KV'
	       );
    --  
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure InsAutoCarPooling
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `InsAutoCarPooling`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsAutoCarPooling`(
pNumTarga varchar(8)
)
--
InsAutoCarPooling:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1062;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into AutoCarPooling (
        NumTarga
    ) VALUES (
        pNumTarga
    );
    --
    if lvDuplicatedKey = 1 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La vettura è già presente';
    end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure InsAutoCoinvolta
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `InsAutoCoinvolta`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsAutoCoinvolta`(
pCodSinistro varchar(12), 
pNumTarga varchar(8), 
pCasaProduttrice varchar(32),
pModello varchar(16)
)
--
InsAutoCoinvolta:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1062;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into Autovettura (
        NumTarga, CasaProdruttrice, Modello
    ) VALUES (
        pNumTarga, pCasaProdruttrice, pModello
    );
    --
    if lvDuplicatedKey = 1 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La vettura è già presente';
    end if;
    
    insert into AutoCoinvolta (
		CodSinistro, NumTarga
	) VALUES (
		pCodSinistro, pNumTarga
	);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure InsAutoRideSharingOnDemand
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `InsAutoRideSharingOnDemand`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsAutoRideSharingOnDemand`(
pNumTarga varchar(8)
)
--
InsAutoRideSharingOnDemand:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1062;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into AutoRideSharing (
        NumTarga
    ) VALUES (
        pNumTarga
    );
    --
    if lvDuplicatedKey = 1 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La vettura è già presente';
    end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function InsChiamata
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `InsChiamata`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `InsChiamata`(
pCFFruitore varchar(16),
pCodSharing varchar(12),
pCodPosizioneFruitore varchar(12),
pCodPosizioneDestinazione varchar(12),
pDataOraChiamata datetime,
pStato varchar(8),
pDataOraRisposta datetime
) RETURNS char(12)
--
InsChiamata:BEGIN
    DECLARE lvCodChiamata varchar(12) default NULL;
    --
	set lvCodChiamata = smartmobility.NewProgressivo('CMT', 'Chiamata');
	insert into Chiamata (
		CodChiamata, CFFruitore, CodSharing, CodPosizioneFruitore, CodPosizioneDestinazione, DataOraChiamata, Stato, DataOraRisposta
	) VALUES (
		lvCodChiamata, pCFFruitore, pCodSharing, pCodPosizioneFruitore, pCodPosizioneDestinazione, pDataOraChiamata, pStato, pDataOraRisposta
	);
    --
    return lvCodChiamata;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function InsTracciamento
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `InsTracciamento`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `InsTracciamento`(
  pNumTarga  varchar(8),
  pTimestamp datetime,
  pLatitudine decimal(10,7),
  pLongitudine decimal(10,7),
  pChilometro decimal(9,3),
  -- Strada
  pNazione varchar(2),
  pRegione varchar(3),
  pProvincia varchar(4),
  pComune varchar(64),
  -- Strada URBANA
  pDUG varchar(32),
  pNomeStd varchar(64),
  -- STrada EXTRAURBANA
  pTipoStrada varchar(2),
  pCategStrada varchar(8),
  pNumero int(11),
  pNome varchar(64)
) RETURNS char(12) CHARSET latin1
InsTracciamento:BEGIN
    declare lvCodTracciamento varchar(12);
    set lvCodTracciamento = NewProgressivo('TRC', 'Tracciamento');
    --
    insert into Tracciamento (
        CodTracciamento, NumTarga, Timestamp, Latitudine, Longitudine,
        Chilometro, Nazione, Regione, Provincia, Comune,
        DUG, NomeStd, TipoStrada, CategStrada, Numero,
        Nome
    ) VALUES (
        lvCodTracciamento, pNumTarga, pTimestamp, pLatitudine, pLongitudine,
        pChilometro, pNazione, pRegione, pProvincia, pComune,
        pDUG, pNomeStd, pTipoStrada, pCategStrada, pNumero,
        pNome
    );
    --
    return lvCodTracciamento;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function InsTragittoProgrammato
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `InsTragittoProgrammato`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `InsTragittoProgrammato`(
pCodPosizioneP varchar(12),
pCodPosizioneA varchar(12),
pLunghezza decimal(9,3),
pTipoPercorso char(1)
) returns varchar(12)
--
InsTragittoProgrammato:BEGIN
    DECLARE lvCodTragitto varchar(12);
    --
    set lvCodTragitto = smartmobility.NewProgressivo('TGT', 'Tragitto');
    --
    insert into smartmobility.tragitto (
        CodTragitto, CodPosizioneP, CodPosizioneA
    ) VALUES (
        lvCodTragitto, pCodPosizioneP, pCodPosizioneA
    );
    --
    insert into smartmobility.tragittoprogrammato (
        CodTragitto, Lunghezza, TipoPercorso
    ) VALUES (
        lvCodTragitto, pLunghezza, pTipoPercorso
    );
    --
    return lvCodTragitto;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function InsTragittoTracciato
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `InsTragittoTracciato`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `InsTragittoTracciato`(
pCodPosizioneP varchar(12),
pServizio varchar(12),
pCodServizio varchar(12) -- CodNoleggio/Pool/Sharing in base al valore di pServizio
) RETURNS varchar(12) CHARSET latin1
InsTragittoTracciato:BEGIN
    DECLARE lvCodTragitto varchar(12);
    --
    set lvCodTragitto = NewProgressivo('TGT', 'TragittoTracciato');
    --
    insert into tragitto (
        CodTragitto, CodPosizioneP
    ) VALUES (
        lvCodTragitto, pCodPosizioneP
    );
    --
    insert into tragittotracciato (
        CodTragitto
    ) VALUES (
        lvCodTragitto
    );
    --
    if pServizio = 'CarSharing' then
        insert into tragittotracciatocs (
            CodNoleggio, CodTragitto
        ) VALUES (
            pCodServizio, lvCodTragitto
        );
    end if;
    --
    return lvCodTragitto;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure InsTrattaTragittoTrc
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `InsTrattaTragittoTrc`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsTrattaTragittoTrc`(
pCodTragitto  varchar(12),
pCodTratta varchar(12),
pDataOraEntrata datetime
)
InsTrattaTragittoTrc:BEGIN
    insert into TrattaTragittoTrc (
        CodTragitto, CodTratta, DataOraEntrata
    ) VALUES (
        pCodTragitto, pCodTratta, pDataOraEntrata
    );
    --
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure InsUpdAccount
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `InsUpdAccount`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsUpdAccount`(
pCodFiscale varchar(16),
pUsername varchar(32),
pPassword varchar(16),
pDomandaDiRiserva varchar(128),
pRisposta varchar(128)
)
InsUpdAccount:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1602;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into Account (
        CodFiscale, Username, Password, DomandaDiRiserva, Risposta
    ) VALUES (
        pCodFiscale, pUsername, pPassword, pDomandaDiRiserva, pRisposta
    );
    --
    if lvDuplicatedKey = 1 then
        update Account
           set Username = pUsername,
               Password = pPassword,
               DomandaDiRiserva = pDomandaDiRiserva,
               Risposta = pRisposta
         where CodFiscale = pCodFiscale;
    end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure InsUpdAutoCarSharing
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `InsUpdAutoCarSharing`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsUpdAutoCarSharing`(
pNumTarga varchar(8),
pDisponibilita varchar(16)
)
InsUpdAutoCarSharing:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1062;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into AutoCarSharing (
        NumTarga, Disponibilita
    ) VALUES (
        pNumTarga, pDisponibilita
    );
    --
    if lvDuplicatedKey = 1 then
        update AutoCarSharing
           set Disponibilita = pDisponibilita
         where NumTarga = pNumTarga;
    end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure InsUpdAutovettura
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `InsUpdAutovettura`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsUpdAutovettura`(
pNumTarga varchar(8),
pCFProponente varchar(16),
pNumPosti decimal(2),
pCilindrata decimal(5),
pAnnoImmatricolazione decimal(4),
pCasaProduttrice varchar(32),
pModello varchar(32),
pComfort decimal(3,2),
pVelocitaMax decimal(5,2),
pCapacitaSerbatoio decimal(3),
pTipoAlimentazione varchar(16)
)
InsUpdAutovettura:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1062;
    DECLARE ERRORE CONDITION FOR SQLSTATE '45000';
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into Autovettura (
        NumTarga, CasaProduttrice, Modello
    ) VALUES (
        pNumTarga, pCasaProduttrice, pModello
    );
    --
    if lvDuplicatedKey = 1 then
        update Autovettura
           set CasaProduttrice = pCasaProduttrice,
               Modello = pModello
         where NumTarga = pNumTarga;
        --
        update AutovetturaRegistrata
           set CodFiscale = pCFProponente,
               NumPosti = pNumPosti,
               Cilindrata = pCilindrata,
               AnnoImmatricolazione = pAnnoImmatricolazione,
               CasaProduttrice = pCasaProduttrice,
               Modello = pModello,
               Comfort = pComfort,
               VelocitaMax = pVelocitaMax,
               CapacitaSerbatoio = pCapacitaSerbatoio,
               TipoAlimentazione = pTipoAlimentazione
         where NumTarga = pNumTarga;
    else
        insert into AutovetturaRegistrata (
            NumTarga, CodFiscale, NumPosti, Cilindrata, AnnoImmatricolazione,
            Comfort, VelocitaMax, CapacitaSerbatoio, TipoAlimentazione
        ) VALUES (
            pNumTarga, pCFProponente, pNumPosti, pCilindrata, pAnnoImmatricolazione,
            pComfort, pVelocitaMax, pCapacitaSerbatoio, pTipoAlimentazione
        );
    end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure InsUpdCarreggiata
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `InsUpdCarreggiata`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsUpdCarreggiata`(
pCodStrada varchar(32),
pNumCarreggiata tinyint,
pNumCorsie tinyint,
pNumSensiMarcia tinyint
)
InsUpdCarreggiata:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1602;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into Carreggiata (
        CodStrada, NumCarreggiata, NumCorsie, NumSensiMarcia
    ) VALUES (
        pCodStrada, pNumCarreggiata, pNumCorsie, pNumSensiMarcia
    );
    --
    if lvDuplicatedKey = 1 then
        update Carreggiata
           set NumCorsie = pNumCorsie,
               NumSensiMarcia = pNumSensiMarcia
         where CodStrada = pCodStrada
           and NumCarreggiata = pNumCarreggiata;
    end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure InsUpdCostoAutovettura
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `InsUpdCostoAutovettura`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsUpdCostoAutovettura`(
pNumTarga varchar(8),
pNumPasseggeri decimal(2),
pCostoOperativo decimal(12,5),
pCostoUsura decimal(12,5),
pConsumoU decimal(5,3),
pConsumoXU decimal(5,3),
pConsumoM decimal(5,3)
)
InsUpdCostoAutovettura:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1062;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into CostoAutovettura (
        NumTarga, NumPasseggeri, CostoOperativo, CostoUsura,
        ConsumoU, ConsumoXU, ConsumoM
    ) VALUES (
        pNumTarga, pNumPasseggeri, pCostoOperativo, pCostoUsura,
        pConsumoU, pConsumoXU, pConsumoM
    );
    --
    if lvDuplicatedKey = 1 then
        update CostoAutovettura
           set NumPasseggeri = pNumPasseggeri,
               CostoOperativo = pCostoOperativo,
               CostoUsura = pCostoUsura,
               ConsumoU = pConsumoU,
               ConsumoXU = pConsumoXU,
               ConsumoM = pConsumoM
         where NumTarga = pNumTarga;
    end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure InsUpdDocumentoRiconoscimento
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `InsUpdDocumentoRiconoscimento`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsUpdDocumentoRiconoscimento`(
pCodFiscale varchar(16),
pTipoDocumento varchar(3),
pEnteRilascio varchar(64),
pNumeroDocumento varchar(16),
pScadenza date
)
InsUpdDocumentoRiconoscimento:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1062;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into DocumentoRiconoscimento (
        CodFiscale, TipoDocumento, EnteRilascio, NumeroDocumento, Scadenza
    ) VALUES (
        pCodFiscale, pTipoDocumento, pEnteRilascio, pNumeroDocumento, pScadenza
    );
    --
    if lvDuplicatedKey = 1 then
        update DocumentoRiconoscimento
           set TipoDocumento = pTipoDocumento,
               EnteRilascio = pEnteRilascio,
               NumeroDocumento = pNumeroDocumento,
               Scadenza = pScadenza
         where CodFiscale = pCodFiscale;
    end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure InsUpdFruibilita
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `InsUpdFruibilita`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsUpdFruibilita`(
pNumTarga varchar(8),
pProgrFascia int,
pTipoFruibilita varchar(3), -- PER=Periodica; FAS=Fascia
pNomeGiorno varchar(3), -- LUN, MAR, ..., DOM (Valido se TipoFruibilita = PER)
pGiornoIni date,
pGiornoFin date,
pOraIni time,
pOraFin time
)
InsUpdFruibilita:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1062;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into Fruibilita (
        NumTarga, ProgrFascia, TipoFruibilita, NomeGiorno,
        GiornoIni, GiornoFin, OraIni, OraFin
    ) VALUES (
        pNumTarga, pProgrFascia, pTipoFruibilita, pNomeGiorno,
        pGiornoIni, pGiornoFin, pOraIni, pOraFin
    );
    --
    if lvDuplicatedKey = 1 then
        update Fruibilita
           set TipoFruibilita = pTipoFruibilita,
               NomeGiorno = pNomeGiorno,
               GiornoIni = pGiornoIni,
               GiornoFin = pGiornoFin,
               OraIni = pOraIni,
               OraFin = pOraFin
         where NumTarga = pNumTarga
           and ProgrFascia = pProgrFascia;
    end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure InsUpdLimiteVelocita
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `InsUpdLimiteVelocita`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsUpdLimiteVelocita`(
pCodStrada varchar(12),
pNumCarreggiata tinyint(4),
pCodPosizione varchar(12),
pLimite decimal(5,2)
)
--
InsUpdAccount:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1602;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into LimiteVelocita (
        CodStrada, NumCarreggiata, CodPosizione, Limite
    ) VALUES (
        pCodStrada, pNumCarreggiata, pCodPosizione, pLimite
    );
    --
    if lvDuplicatedKey = 1 then
        update LimiteVelocita
           set NumCarreggiata = pNumCarreggiata,
               Limite = pLimite
         where CodStrada = pCodStrada
           and CodPosizione = pCodPosizione;
    end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure InsUpdPedaggio
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `InsUpdPedaggio`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsUpdPedaggio`(
pCodSvincoloE varchar(12),
pCodSvincoloU varchar(12),
pPedaggio decimal(9,2)
)
--
InsUpdUtente:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1062;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into Pedaggio (
        CodSvincoloE, CodSvincoloU, Pedaggio
    ) VALUES (
        pCodSvincoloE, pCodSvincoloU, pPedaggio
    );
    --
    if lvDuplicatedKey = 1 then
        update Svincolo
           set Pedaggio = pPedaggio
         where CodSvincoloE = pCodSvincoloE
           and CodSvincoloU = pCodSvincoloU;
    end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure InsUpdUtente
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `InsUpdUtente`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsUpdUtente`(
pCodFiscale varchar(16),
pCognome varchar(64),
pNome varchar(64),
pCodIndirizzo varchar(12),
pTelefono varchar(16),
pStato varchar(8)
)
InsUpdUtente:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1062;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into Utente (
        CodFiscale, Cognome, Nome, CodIndirizzo, Telefono, Stato, DataIscrizione
    ) VALUES (
        pCodFiscale, pCognome, pNome, pCodIndirizzo, pTelefono, pStato, now()
    );
    --
    if lvDuplicatedKey = 1 then
        update Utente
           set Cognome = pCognome,
               Nome = pNome,
               CodIndirizzo = pCodIndirizzo,
               Telefono = pTelefono,
               Stato = pStato
         where CodFiscale = pCodFiscale;
    end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure InsUpdValutazioneAspetto
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `InsUpdValutazioneAspetto`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsUpdValutazioneAspetto`(
pCodValutazione varchar(32),
pCodAspettoValutabile varchar(12),
pVoto decimal(3,2)
)
InsUpdValutazioneAspetto:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1062;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into ValutazioneAspetti (
        CodValutazione, CodAspettoValutabile, Voto
    ) VALUES (
        pCodValutazione, pCodAspettoValutabile, pVoto
    );
    --
    if lvDuplicatedKey = 1 then
        update ValutazioneAspetti
           set Voto = pVoto
         where CodValutazione = pCodValutazione
           and CodAspettoValutabile = pCodAspettoValutabile;
    end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function IsAlphabetic
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `IsAlphabetic`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `IsAlphabetic`(
pStr varchar(256)
) RETURNS char(1) CHARSET latin1
    COMMENT 'Restituisce S o N a seconda che pStr sia alfabetica o meno'
IsAlphabetic:BEGIN
    DECLARE lvLen int;
    DECLARE lvIdx int;
    DECLARE lvChr char(1);
    --
    set lvLen = length(pStr);
    set lvIdx = 1;
    while lvIdx <= lvLen do
        set lvChr = substr(pStr, lvIdx, 1);
        if upper(lvChr) < 'A' or upper(lvChr) > 'Z' then return 'N'; end if;
        set lvIdx = lvIdx + 1;
    end while;
    --
    return 'S';
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function IsAutovetturaCSFruibile
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `IsAutovetturaCSFruibile`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `IsAutovetturaCSFruibile`(
pNumTarga varchar(8),
pGiorno   date
) RETURNS char(1) CHARSET latin1
    COMMENT 'Restituisce S o N a seconda che l''autovettura (Car Sharing) individuata da pNumTarga sia fruibile o meno nel giorno pGiorno'
IsAutovetturaCSFruibile:BEGIN
    DECLARE lvRes char(1) default 'N';
    select 'S'
      into lvRes
      from Fruibilita
     where NumTarga = pNumTarga
       and (
            (TipoFruibilita = 'FAS' and pGiorno between GiornoIni and GiornoFin)
            or
            (TipoFruibilita = 'PER' and GiornoSettimana(NomeGiorno) = dayofweek(pGiorno))
           )
    ;
    return lvRes;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function IsAutovetturaCSPrenotata
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `IsAutovetturaCSPrenotata`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `IsAutovetturaCSPrenotata`(
pNumTarga varchar(8),
pGiorno   date
) RETURNS char(1) CHARSET latin1
    COMMENT 'Restituisce S o N a seconda che l''autovettura (Car Sharing) individuata da pNumTarga sia prenotata o meno nel giorno pGiorno'
IsAutovetturaCSPrenotata:BEGIN
    DECLARE lvRes char(1) default 'N';
    select 'S'
      into lvRes
      from PrenotazioneCS
     where NumTarga = pNumTarga
       and pGiorno between DataIni and DataFin
       and Stato = 'ACCETTATA';
    return lvRes;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function IsCategoria
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `IsCategoria`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `IsCategoria`(
pCategoria varchar(256)
) RETURNS char(1) CHARSET latin1
    COMMENT 'Restituisce S o N a seconda che pCategoria sia contenuto nella tabella CategoriaStrada'
IsCategoria:BEGIN
    DECLARE lvRes char(1) default 'N';
    -- DECLARE lvRecNotFound int default 0;
    -- DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    if upper(pCategoria) = ANY (
        select upper(CodCategStrada)
          from CategoriaStrada)
    then
        return 'S';
    else
        return 'N';
    end if;
    /*
    select 'S'
      into lvRes
      from CategoriaStrada
     where upper(CodCategStrada) = upper(pCategoria);
    --
    return lvRes;
    */
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function IsNumeric
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `IsNumeric`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `IsNumeric`(
pStr varchar(256)
) RETURNS char(1) CHARSET latin1
    COMMENT 'Restituisce S o N a seconda che pStr sia numerico o meno'
IsNumeric:BEGIN
    DECLARE lvLen int;
    DECLARE lvIdx int;
    DECLARE lvChr char(1);
    --
    set lvLen = length(pStr);
    set lvIdx = 1;
    while lvIdx <= lvLen do
        set lvChr = substr(pStr, lvIdx, 1);
        if lvChr < '0' or lvChr > '9' then return 'N'; end if;
        set lvIdx = lvIdx + 1;
    end while;
    --
    return 'S';
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function IsTipoStrada
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `IsTipoStrada`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `IsTipoStrada`(
pTipoStrada varchar(256)
) RETURNS char(1) CHARSET latin1
    COMMENT 'Restituisce S o N a seconda che pTipoStrada sia contenuto nella tabella TipoStrada'
IsTipoStrada:BEGIN
    DECLARE lvRes char(1) default 'N';
    -- DECLARE lvRecNotFound int default 0;
    -- DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    if pTipoStrada = ANY (select CodTipoStrada from TipoStrada) then return 'S'; else return 'N'; end if;
    /*
    select 'S'
      into lvRes
      from TipoStrada
     where CodTipoStrada = pTipoStrada;
    --
    return lvRes;
    */
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure MostraDisponibilitaAutoCS
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `MostraDisponibilitaAutoCS`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `MostraDisponibilitaAutoCS`(
pNumTarga varchar(12),
pDataIni date,
pDataFin date
)
MostraDisponibilitaAutoCS:BEGIN
    DECLARE lvGG date;
    DECLARE lvWD int;
    DECLARE lvFlgPrimaRiga bool default true;
    DECLARE lvSep char(1) default ',';
    DECLARE lvFru char(1) default 'N';
    DECLARE lvPrn char(1) default '';
    set lvGG = pDataIni;
    set @lvSQL = 'select ''DOM'', ''LUN'', ''MAR'', ''MER'', ''GIO'', ''VEN'', ''SAB'' ';
    while lvGG <= pDataFin do
        set lvWD = dayofweek(lvGG);
        if isAutovetturaCSFruibile(pNumTarga, lvGG) = 'S' then
            set lvPrn = case isAutovetturaCSPrenotata(pNumTarga, lvGG) when 'S' then '*' else '' end;
            if lvWD = 1 or lvFlgPrimaRiga then set @lvSQL = concat(@lvSQL, ' union select '); end if;
            if lvFlgPrimaRiga then 
                begin
                    DECLARE lvIdx int default 1;
                    while lvIdx < lvWD do
                        set @lvSQL = concat(@lvSQL, '''-''', lvSep);
                        set lvIdx = lvIdx + 1;
                    end while;
                    set lvFlgPrimaRIga = false;
                end;
            end if;
            set lvSep = case lvWD when 7 then '' else ',' end;
            set @lvSQL = concat(@lvSQL, '''', day(lvGG), lvPrn, '''', lvSep);
        end if;
        set lvGG = date_add(lvGG, interval 1 day);
    end while;
    while lvWD <= 6 do
        set lvSep = case lvWD when 6 then '' else ',' end;
        set @lvSQL = concat(@lvSQL, '''-''', lvSep);
        set lvWD = lvWD + 1;
    end while;
    -- select @lvSQL;
    prepare lvStmt from @lvSQL;
    execute lvStmt;
    deallocate prepare lvStmt;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function MyRound
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `MyRound`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `MyRound`(
pNumber decimal(65,30),
pStep   decimal(65,30)
) RETURNS decimal(65,30)
    COMMENT 'Restituisce il numero pNumber arrotondato ad un multiplo di pStep'
MyRound:BEGIN
    return round(pNumber/pStep,0)*pStep;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function NewProgressivo
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `NewProgressivo`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `NewProgressivo`(
pTipo varchar(3),
pOwnerTable varchar(64)
) RETURNS varchar(12) CHARSET latin1
    COMMENT 'Restituisce un progressivo di tipo pTipo univoco'
NewProgressivo:BEGIN
    DECLARE lvRecNotFound int default 0;
    DECLARE lvRes varchar(12);
    DECLARE lvNextProgr int;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    set lvRecNotFound = 0;
    select progressivo
      into lvNextProgr
      from cfg_progressivo
     where tipo = pTipo;
    --
    if lvRecNotFound = 1 then
        set lvNextProgr = 1;
        insert into cfg_progressivo VALUES (pTipo, lvNextProgr+1, pOwnerTable);
    else
        update cfg_progressivo set progressivo = lvNextProgr+1 where tipo = pTipo;
    end if;
    --
    set lvRes = concat(pTipo, lpad(convert(lvNextProgr,char), 9, '0'));
    return lvRes;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function OpenTrattaTracciata
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `OpenTrattaTracciata`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `OpenTrattaTracciata`(
pCodStrada varchar(32),
pNumCarreggiata tinyint,
pCodPosizioneIni varchar(12),
pCodTracciamentoE varchar(12),
pDataOraEntrata datetime
) RETURNS varchar(12) CHARSET latin1
OpenTrattaTracciata:BEGIN
    DECLARE lvCodTratta varchar(12);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    set lvCodTratta = NewProgressivo('TRT', 'Tratta');
    insert into Tratta(
        CodTratta, CodStrada, NumCarreggiata, Lunghezza, CodPosizioneIni, CodPosizioneFin
    ) VALUES (
        lvCodTratta, pCodStrada, pNumCarreggiata, 0, pCodPosizioneIni, NULL
    );
    --
    insert into TrattaTracciata (
        CodTratta, DataOraEntrata, CodTracciamentoE, DataOraUscita, CodTracciamentoU
    ) VALUES (
        lvCodTratta, pDataOraEntrata, pCodTracciamentoE, NULL, NULL
    );
    return lvCodTratta;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure RegistraAutovettura
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `RegistraAutovettura`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistraAutovettura`(
-- Dati per la tabella Autovettura
pNumTarga varchar(8),
pCFProponente varchar(16),
pNumPosti decimal(2),
pCilindrata decimal(5),
pAnnoImmatricolazione decimal(4),
pCasaProduttrice varchar(32),
pModello varchar(32),
pComfort decimal(3,2),
pVelocitaMax decimal(5,2),
pCapacitaSerbatoio decimal(3),
pTipoAlimentazione varchar(16),
-- Dati per la tabella CostoAutovettura (per 1 passeggero)
pCostoOperativo decimal(12,5),
pCostoUsura decimal(12,5),
pConsumoU decimal(5,3),
pConsumoXU decimal(5,3),
pConsumoM decimal(5,3)
)
RegistraAutovettura:BEGIN
    DECLARE AUTOVETTURA_ESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvIdx int;
    DECLARE lvFact decimal(4,3);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION begin
        GET DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
        select @p1, @p2;
        ROLLBACK;
    end;
    --
    if EsisteAutovettura(pNumTarga) = 'S' then
        SIGNAL AUTOVETTURA_ESISTENTE
           SET MESSAGE_TEXT = 'Autovettura già registrata';
    end if;
    --
    START TRANSACTION;
    call GestioneRuolo(pCFProponente, 'PROPONENTE', 'GRANT');
    call InsUpdAutovettura(pNumTarga, pCFProponente, pNumPosti, pCilindrata, pAnnoImmatricolazione, pCasaProduttrice, pModello, pComfort, pVelocitaMax, pCapacitaSerbatoio, pTipoAlimentazione);
    call InsUpdCostoAutovettura(pNumTarga, 1, pCostoOperativo, pCostoUsura, pConsumoU, pConsumoXU, pConsumoM);
    set lvIdx = 2;
    set lvFact = 1.025;
    while lvIdx <= pNumPosti do
        set pCostoOperativo = pCostoOperativo * lvFact;
        set pCostoUsura = pCostoUsura * lvFact;
        set pConsumoU = pConsumoU * lvFact;
        set pConsumoXU = pConsumoXU * lvFact;
        set pConsumoM = pConsumoM * lvFact;
        call InsUpdCostoAutovettura(pNumTarga, lvIdx, pCostoOperativo, pCostoUsura, pConsumoU, pConsumoXU, pConsumoM);
        set lvIdx = lvIdx + 1;
    end while;
    COMMIT;
 END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure RegistraAutovetturaCP
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `RegistraAutovetturaCP`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistraAutovetturaCP`(
pNumTarga varchar(8)
)
--
RegistraAutovetturaCP:BEGIN
    DECLARE AUTOVETTURA_INESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    if EsisteAutovettura(pNumTarga) = 'N' then
        SIGNAL AUTOVETTURA_INESISTENTE SET MESSAGE_TEXT = 'Autovettura inesistente nell''anagrafica delle autovetture';
    end if;
    --
    call InsAutoCarPooling(pNumTarga);
END$$
 
DELIMITER ;

-- -----------------------------------------------------
-- procedure RegistraAutovetturaCS
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `RegistraAutovetturaCS`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistraAutovetturaCS`(
pNumTarga varchar(8),
pDisponibilita varchar(16)
)
RegistraAutovetturaCS:BEGIN
    DECLARE AUTOVETTURA_INESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    if EsisteAutovettura(pNumTarga) = 'N' then
        SIGNAL AUTOVETTURA_INESISTENTE SET MESSAGE_TEXT = 'Autovettura inesistente nell''anagrafica delle autovetture';
    end if;
    --
    call InsUpdAutoCarSharing(pNumTarga, pDisponibilita);
 END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure RegistraAutovetturaRSoD
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `RegistraAutovetturaRSoD`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistraAutovetturaRSoD`(
pNumTarga varchar(8)
)
--
RegistraAutovetturaRSoD:BEGIN
    DECLARE AUTOVETTURA_INESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    if EsisteAutovettura(pNumTarga) = 'N' then
        SIGNAL AUTOVETTURA_INESISTENTE SET MESSAGE_TEXT = 'Autovettura inesistente nell''anagrafica delle autovetture';
    end if;
    --
    call InsAutoRideSharingOnDemand(pNumTarga);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure RegistraUtente
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `RegistraUtente`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistraUtente`(
-- Dati per la tabella Utente
pCodFiscale varchar(16),
pCognome varchar(64),
pNome varchar(64),
pTelefono varchar(16),
-- Dati per la tabella Indirizzo
pNazione varchar(2),
pRegione varchar(3),
pProvincia varchar(4),
pComune varchar(64),
pCAP varchar(5),
pDUG varchar(32),
pNomeStd varchar(64),
pCivico varchar(16),
pEsponente varchar(16),
-- Dati per la tabella DocumentoRiconoscimento
pTipoDocumento varchar(3),
pEnteRilascio varchar(64),
pNumeroDocumento varchar(16),
pScadenza date,
-- Dati per la tabella Account
pUsername varchar(32),
pPassword varchar(16),
pDomandaRiserva varchar(128),
pRisposta varchar(128)
)
RegistraUtente:BEGIN
    DECLARE CODFISCALE_ESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE USERNAME_ESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvCodStrada varchar(12) default NULL;
    DECLARE lvCodIndirizzo varchar(12) default NULL;
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    if EsisteUtente(pCodFiscale) = 'S' then
        SIGNAL CODFISCALE_ESISTENTE
           SET MESSAGE_TEXT = 'Utente già presente';
    end if;
    --
    if EsisteUsername(pUsername) = 'S' then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username già assegnato ad altro utente';
    end if;
    --
    set lvCodStrada = ChkInsStradaUR(pDUG, pNomeStd, pComune, pProvincia, pRegione, pNazione, pCAP, 0, 1, 'SUR');
    set lvCodIndirizzo = ChkInsIndirizzo(lvCodStrada, pCivico, pEsponente);
    call InsUpdUtente(pCodFiscale, pCognome, pNome, lvCodIndirizzo, pTelefono, 'INATTIVO');
    call InsUpdAccount(pCodFiscale, pUsername, pPassword, pDomandaRiserva, pRisposta);
    call InsUpdDocumentoRiconoscimento(pCodFiscale, pTipoDocumento, pEnteRilascio, pNumeroDocumento, pScadenza);
 END$$

DELIMITER ;

-- -----------------------------------------------------
-- function RegistraValutazione
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `RegistraValutazione`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `RegistraValutazione`(
pCFUtenteGiudicante varchar(16),
pRuoloUtenteGiudicante char(1),
pCFUtenteGiudicato varchar(16),
pRuoloUtenteGiudicato char(1),
pCodTragitto varchar(12),
pServizio varchar(32),
pRecensione varchar(256)
) RETURNS VARCHAR(12)
--
RegistraValutazione:BEGIN
    DECLARE TRAGITTO_INESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvCodValutazione varchar(12);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    if pCodTragitto is not null then
        if pServizio = 'CAR_SHARING' and EsisteTragitto(pCodTragitto) = 'N' then
            SIGNAL TRAGITTO_INESISTENTE
               SET MESSAGE_TEXT = 'Tragitto inesistente per il servizio CAR_SHARING';
        elseif pServizio = 'CAR_POOLING' and EsisteTragitto(pCodTragitto) = 'N' then
            SIGNAL TRAGITTO_INESISTENTE
               SET MESSAGE_TEXT = 'Tragitto inesistente per il servizio CAR_POOLING';
        elseif pServizio = 'RIDE_SHARING_ON_DEMAND' and EsisteTragitto(pCodTragitto) = 'N' then
            SIGNAL TRAGITTO_INESISTENTE
               SET MESSAGE_TEXT = 'Tragitto inesistente per il servizio RIDE_SHARING_ON_DEMAND';
        end if;
    end if;
    --
    set lvCodValutazione = ChkInsValutazione(pCFUtenteGiudicante, pRuoloUtenteGiudicante,
        pCFUtenteGiudicato, pRuoloUtenteGiudicato, pCodTragitto, pServizio, pRecensione);
    --
    return lvCodValutazione;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function Tracciamento
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `Tracciamento`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `Tracciamento`(
  pNumTarga  varchar(8),      -- Numero targa della vettura che ha inviato i dati di tracciamento,
  pTimestamp datetime,        -- Data e ora del momento in cui la vettura ha inviato i dati di tracciamento,
  pEvento varchar(16),        -- Evento che ha "innescato" l'invocazione della procedura: ACCENSIONE | PERIODICO | SPEGNIMENTO
  pLatitudine decimal(10,7),  -- Latitudine della posizione dell'autovettura al momento dell'invio di questi dati di tracciamento,
  pLongitudine decimal(10,7), -- Longitudine della posizione dell'autovettura al momento dell'invio di questi dati di tracciamento,
  pChilometro decimal(9,3),   -- Chilometro della strada in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento,
  -- Strada
  pNazione varchar(2),        -- Nazione in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento,
  pRegione varchar(3),        -- Codice della regione in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento,
  pProvincia varchar(4),      -- Sigla della provincia in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento,
  pComune varchar(64),        -- Comune in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento,
  pNumCarreggiata decimal(2), -- Numero della carreggiata della strada in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento 
  -- Strada URBANA
  pDUG varchar(32),           -- Dug della strada URBANA in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento,
  pNomeStd varchar(64),       -- Nome standard della strada URBANA in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento,
  -- Strada EXTRAURBANA
  pTipoStrada varchar(2),     -- Tipo della strada EXTRAURBANA in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento,
  pCategStrada varchar(8),    -- Categoria della strada EXTRAURBANA in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento,
  pNumero int(11),            -- Numero della strada EXTRAURBANA in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento,
  pNome varchar(64)           -- Nome della strada EXTRAURBANA in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento,
) RETURNS varchar(12) CHARSET latin1
Tracciamento:BEGIN
    declare lvCodTracciamento varchar(12);
    declare lvCodStrada varchar(12);
    declare lvServizio varchar(12);
    declare lvCodServizio varchar(12);
    declare lvCodTragitto varchar(12);
    declare lvPosizioneIniTragitto varchar(12);
    declare lvPosizioneFinTragitto varchar(12);
    declare lvPosizioneIniTratta varchar(12);
    declare lvPosizioneFinTratta varchar(12);
    declare lvCodTratta varchar(12);
    --
    declare lvPrevCodStrada varchar(12);
    -- Precedente tratta e record di tracciamento
    declare lvPrevCodTratta varchar(12);
    declare lvPrevCodTracciamento varchar(12);
    declare lvPrevTimestamp datetime;
    declare lvPrevLatitudine decimal(10,7);  -- Latitudine della posizione dell'autovettura al momento dell'invio di questi dati di tracciamento,
    declare lvPrevLongitudine decimal(10,7);
    declare lvPrevChilometro decimal(9,3);
    declare lvPrevNazione varchar(2);
    declare lvPrevRegione varchar(3);
    declare lvPrevProvincia varchar(4);
    declare lvPrevComune varchar(64);
    declare lvPrevNumCarreggiata decimal(2);
    declare lvPrevDUG varchar(32);
    declare lvPrevNomeStd varchar(64);
    declare lvPrevTipoStrada varchar(2);
    declare lvPrevCategStrada varchar(8);
    declare lvPrevNumero int(11);
    declare lvPrevNome varchar(64);
    -- Inseriamo il record di tracciamento appena arrivato
    set lvCodTracciamento = InsTracciamento(
        pNumTarga, pTimestamp, pLatitudine, pLongitudine, pChilometro,
        pNazione, pRegione, pProvincia, pComune, pDUG,
        pNomeStd, pTipoStrada, pCategStrada, pNumero, pNome);
    --
    -- Recuperiamo il codice della strada su cui si trova l'autovettura
    -- N.B. Se la strada non esiste viene creata con:
    -- Lunghezza = 0, NumCarreggiate = 1
    if (pDUG is not null and pNomeStd is not null) then -- STRADA URBANA
        set lvCodStrada = ChkInsStradaUR(
            pDUG, pNomeStd, pComune, pProvincia, pRegione, pNazione, NULL, 0, 1, NULL);
    elseif (pTipoStrada is not null and pNumero is not null) then -- STRADA EXTRAURBANA
        set lvCodStrada = ChkInsStradaXU(
            pTipoStrada, pCategStrada, pNumero, NULL, pNome, 0, 1, NULL);
    end if;
    -- Controlliamo se esiste la carreggiata della strada
    -- N.B. Se la carreggiata non esiste la creiamo con 2 sensi di marcia e 1 corsia per senso di marcia
    call ChkInsCarreggiata(lvCodSTrada, pNumCarreggiata, 1, 2);
    --
    if pEvento = 'ACCENSIONE' then
        -- Recuperiamo il servizio che sta facendo la vettura
        call GetServizioCorrente(pNumTarga, pTimestamp, lvServizio, lvCodServizio);
        -- Determino la posizione iniziale del tragitto
        set lvPosizioneIniTragitto = ChkInsPosizione(
            pLatitudine, pLongitudine, lvCodStrada, pChilometro, NULL);
        -- Creiamo il nuovo tragitto tracciato che sta per iniziare
        set lvCodTragitto = InsTragittoTracciato(lvPosizioneIniTragitto, lvServizio, lvCodServizio);
        -- Creiamo la posizione iniziale della nuova tratta tracciata
        set lvPosizioneIniTratta = ChkInsPosizione(
            pLatitudine, pLongitudine, lvCodStrada, pChilometro, NULL);
        -- Creiamo la nuova tratta tracciata
        set lvCodTratta = OpenTrattaTracciata(
            lvCodStrada, pNumCarreggiata, lvPosizioneIniTratta, lvCodTracciamento, pTimestamp);
        -- Leghiamo la tratta tracciata al tragitto tracciato dell'autovettura
        call InsTrattaTragittoTrc(lvCodTragitto, lvCodTratta, pTimestamp);
    elseif pEvento = 'PERIODICO' then
        -- Recuperiamo il codice del tragitto tracciato che sta facendo la vettura
        set lvCodTragitto = GetCodTragitto(pNumTarga, pTimestamp);
        -- Recuperiamo il record di tracciamento immediatamente precedente inviato dalla stessa auto
        call GetPrevTracciamento(
            pNumTarga, pTimestamp, lvPrevCodTracciamento, lvPrevTimestamp, lvPrevLatitudine, lvPrevLongitudine,
            lvPrevChilometro, lvPrevNazione, lvPrevRegione, lvPrevProvincia, lvPrevComune,
            lvPrevDUG, lvPrevNomeStd, lvPrevTipoStrada, lvPrevCategStrada, lvPrevNumero, lvPrevNome); 
        -- controlliamo se è cambiata la strada su cui si trova l'auto
        if (pNazione != lvPrevNazione or pRegione != lvPrevRegione or pProvincia != lvPrevProvincia or pComune != lvPrevComune
        or coalesce(pDUG, '@') != coalesce(lvPrevDUG, '@') or coalesce(pNomeStd, '@') != coalesce(lvPrevNomeStd, '@')
        or coalesce(pTipoStrada, '@') != coalesce(lvPrevTipoStrada, '@') or coalesce(pCategStrada, '@') != coalesce(lvPrevCategStrada, '@')
        or coalesce(pNumero, '@') != coalesce(lvPrevNumero, '@') or coalesce(pNome, '@') != coalesce(lvPrevNome, '@')) then
            -- La strada è cambiata
            if (lvPrevDUG is not null and lvPrevNomeStd is not null) then -- STRADA URBANA
                set lvPrevCodStrada = ChkInsStradaUR(
                    lvPrevDUG, lvPrevNomeStd, lvPrevComune, lvPrevProvincia, lvPrevRegione, lvPrevNazione, NULL, 0, 1, NULL);
            elseif (lvPrevTipoStrada is not null and lvPrevNumero is not null) then -- STRADA EXTRAURBANA
                set lvPrevCodStrada = ChkInsStradaXU(
                    lvPrevTipoStrada, lvPrevCategStrada, lvPrevNumero, NULL, lvPrevNome, 0, 1, NULL);
            end if;
            -- Chiudiamo la tratta precedente
            select TTT.CodTratta
              into lvPrevCodTratta
              from TrattaTragittoTrc TTT
             where TTT.CodTragitto = lvCodTragitto
               and TTT.DataOraEntrata = (
                       select max(T.DataOraEntrata)
                         from TrattaTragittoTrc T
                        where T.CodTragitto = TTT.CodTragitto
                   );
            --
            set lvPosizioneFinTratta = ChkInsPosizione(
                lvPrevLatitudine, lvPrevLongitudine, lvPrevCodStrada, lvPrevChilometro, NULL);
            call CloseTrattaTracciata(lvPrevCodTratta, lvPosizioneFinTratta, lvPrevCodTracciamento, lvPrevTimestamp);
            -- Apriamo una nuova tratta
            -- Creiamo la posizione iniziale della nuova tratta tracciata
            set lvPosizioneIniTratta = ChkInsPosizione(
                pLatitudine, pLongitudine, lvCodStrada, pChilometro, NULL);
            -- Creiamo la nuova tratta tracciata
            set lvCodTratta = OpenTrattaTracciata(
                lvCodStrada, pNumCarreggiata, lvPosizioneIniTratta, lvCodTracciamento, pTimestamp);
            -- Leghiamo la tratta tracciata al tragitto tracciato dell'autovettura
            call InsTrattaTragittoTrc(lvCodTragitto, lvCodTratta, pTimestamp);
        end if;
    elseif pEvento = 'SPEGNIMENTO' then -- Ipotesi: sullo SPEGNIMENTO non si ha cambio di strada!!!
        -- Recuperiamo il codice del tragitto tracciato che sta facendo la vettura
        set lvCodTragitto = GetCodTragitto(pNumTarga, pTimestamp);
        -- Chiudiamo la tratta corrente
        select TTT.CodTratta
          into lvCodTratta
          from TrattaTragittoTrc TTT
         where TTT.CodTragitto = lvCodTragitto
           and TTT.DataOraEntrata = (
                   select max(T.DataOraEntrata)
                     from TrattaTragittoTrc T
                    where T.CodTragitto = TTT.CodTragitto
               );
        -- recupero la posizione in cui è avvenuto lo spegnimento
        set lvPosizioneFinTratta = ChkInsPosizione(
            pLatitudine, pLongitudine, lvCodStrada, pChilometro, NULL);
        -- 
        call CloseTrattaTracciata(lvCodTratta, lvPosizioneFinTratta, lvCodTracciamento, pTimestamp);
        -- chiudiamo il tragitto assegnandogli una posizione di arrivo
        update Tragitto
           set CodPosizioneA = lvPosizioneFinTratta
         where CodTragitto = lvCodTragitto;
        --
    end if;
    return lvCodTracciamento;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure UpdInsTrattaTemporizzata
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `UpdInsTrattaTemporizzata`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdInsTrattaTemporizzata`(
pCodTratta varchar(12),
pCodFascia varchar(12),
pTempoMedio decimal(13,2)
)
UpdInsTrattaTemporizzata:BEGIN
    DECLARE lvPrevTempoMedio decimal(13,2);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select TempoMedio
      into lvPrevTempoMedio
      from TrattaTemporizzata
    where CodTratta = pCodTratta
       and CodFascia = pCodFascia;
    --
    if lvRecNotFound = 1 then
       insert into TrattaTemporizzata (
            CodTratta, CodFascia, TempoMedio
        ) VALUES (
            pCodTratta, pCodFascia, pTempoMedio
        );
    else
        update TrattaTemporizzata
           set TempoMedio = pTempoMedio
         where CodTratta = pCodTratta
           and CodFascia = pCodFascia;
    end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure UpdStatoChiamata
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `UpdStatoChiamata`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdStatoChiamata`(
pCodChiamata varchar(12),
pStato varchar(8),
pDataOraRisposta datetime
)
--
UpdStatoChiamata:BEGIN
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    update Chiamata
       set Stato = pStato,
		   DataOraRisposta = pDataOraRisposta
     where CodChiamata = pCodChiamata;
    --
    if lvRecNotFound = 1 then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UpdStatoChiamata: Chiamata inesistente';
    end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure UpdStatoPrenotazioneCP
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `UpdStatoPrenotazioneCP`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdStatoPrenotazioneCP`(
pCodPrenotazione varchar(12),
pStato varchar(16)
)
--
UpdStatoPrenotazioneCP:BEGIN
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    update PrenotazioneCP
       set Stato = pStato
     where CodPrenotazione = pCodPrenotazione;
    --
    if lvRecNotFound = 1 then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UpdStatoPrenotazioneCP: Prenotazione inesistente';
    end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure UpdStatoPrenotazioneCS
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `UpdStatoPrenotazioneCS`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdStatoPrenotazioneCS`(
pCodPrenotazione varchar(12),
pStato varchar(16)
)
UpdStatoPrenotazioneCS:BEGIN
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    update PrenotazioneCS
       set Stato = pStato
     where CodPrenotazione = pCodPrenotazione;
    --
    if lvRecNotFound = 1 then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UpdStatoPrenotazioneCS: Prenotazione inesistente';
    end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ValutaChiamata
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `ValutaChiamata`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ValutaChiamata`(
pCodChiamata varchar(12),
pStato varchar(8),
pDataOraRisposta datetime
)
--
ValutaChiamata:BEGIN
    DECLARE CHIAMATA_INESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    if EsisteChiamata(pCodChiamata) = 'N' then
        SIGNAL CHIAMATA_INESISTENTE SET MESSAGE_TEXT = 'ValutaChiamata: Chiamata inesistente';
    end if;
    --
    call UpdStatoChiamata(pCodChiamata, pStato, pDataOraRisposta);
 END$$
 
DELIMITER ;

-- -----------------------------------------------------
-- procedure ValutaPrenotazioneCP
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `ValutaPrenotazioneCP`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ValutaPrenotazioneCP`(
pCodPrenotazione varchar(12),
pEsito varchar(16)
)
--
ValutaPrenotazioneCP:BEGIN
    DECLARE PRENOTAZIONE_INESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    if EsistePrenotazioneCP(pCodPrenotazione) = 'N' then
        SIGNAL PRENOTAZIONE_INESISTENTE SET MESSAGE_TEXT = 'ValutaPrenotazioneCP: Prenotazione inesistente';
    end if;
    --
    call UpdStatoPrenotazioneCP(pCodPrenotazione, pEsito);
END$$
 
DELIMITER ;

-- -----------------------------------------------------
-- procedure ValutaPrenotazioneCS
-- -----------------------------------------------------

USE `smartmobility`;
DROP procedure IF EXISTS `ValutaPrenotazioneCS`;

DELIMITER $$
USE `smartmobility`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ValutaPrenotazioneCS`(
pCodPrenotazione varchar(12),
pEsito varchar(16)
)
ValutaPrenotazioneCS:BEGIN
    DECLARE PRENOTAZIONE_INESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    if EsistePrenotazioneCS(pCodPrenotazione) = 'N' then
        SIGNAL PRENOTAZIONE_INESISTENTE SET MESSAGE_TEXT = 'ValutaPrenotazioneCS: Prenotazione inesistente';
    end if;
    --
    call UpdStatoPrenotazioneCS(pCodPrenotazione, pEsito);
 END$$

DELIMITER ;

-- -----------------------------------------------------
-- function ViabilitaTratta
-- -----------------------------------------------------

USE `smartmobility`;
DROP function IF EXISTS `ViabilitaTratta`;

DELIMITER $$
USE `smartmobility`$$
CREATE FUNCTION `ViabilitaTratta` (
pCodTratta VARCHAR(12),
pCodFascia VARCHAR(12)
) RETURNS VARCHAR(13)
BEGIN

	DECLARE lvTempoMedio DECIMAL(13,2); -- secondi
    DECLARE lvStrada VARCHAR(12);
    DECLARE lvCarreggiata TINYINT(4);
    DECLARE lvLunghezza DECIMAL(9,3);
    DECLARE lvPosizioneIni VARCHAR(12);
    DECLARE lvLimite DECIMAL(5,2);
    DECLARE lvTempoOttimale DECIMAL(13,2); -- secondi
    DECLARE lvRes VARCHAR(13);
    
    SELECT IF(TempoMedio IS NULL, 0, TempoMedio) INTO lvTempoMedio
	  FROM TrattaTemporizzata
	 WHERE CodTratta = pCodTratta
		AND CodFascia = pCodFascia;
        
	
	SELECT CodStrada,
		   NumCarreggiata,
           Lunghezza,
           CodPosizioneIni
	  INTO lvStrada, lvCarreggiata, lvLunghezza, lvPosizioneIni
	  FROM Tratta
	 WHERE CodTratta = pCodTratta;
     
     
	SELECT Limite - 5 INTO lvLimite
      FROM LimiteVelocita
	 WHERE CodStrada = lvStrada
		AND NumCarreggiata = lvCarreggiata
        AND CodPosizione = lvPosizioneIni;
    
    -- la lunghezza è in km, la velocita è in km/h      
	SELECT 3600 * (lvLunghezza/lvLimite) INTO lvTempoOttimale;
    --
    IF lvTempoMedio <> 0 THEN
        IF lvTempoOttimale >= lvTempoMedio THEN
            SET lvRes = 'NonTrafficato';
        ELSE 
            SET lvRes = 'Trafficato';
        END IF;
    ELSE 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La tratta non esiste o non è mai stata percorsa nella fascia oraria selezionata';
    END IF;
    --
    RETURN lvRes;
    
END$$

DELIMITER ;

USE `smartmobility`;

DELIMITER $$

USE `smartmobility`$$
DROP TRIGGER IF EXISTS `Strada_BEFORE_INSERT` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`Strada_BEFORE_INSERT`
BEFORE INSERT ON `smartmobility`.`strada`
FOR EACH ROW
BEGIN

    if NEW.NumCarreggiate <=  0 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La strada deve avere almeno una carreggiata';
    end if;

END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `Strada_BEFORE_UPDATE` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`Strada_BEFORE_UPDATE`
BEFORE UPDATE ON `smartmobility`.`strada`
FOR EACH ROW
BEGIN

    if NEW.NumCarreggiate <=  0 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La strada deve avere almeno una carreggiata';
    end if;

END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `Account_BEFORE_INSERT` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`Account_BEFORE_INSERT`
BEFORE INSERT ON `smartmobility`.`account`
FOR EACH ROW
BEGIN

    DECLARE len INTEGER DEFAULT 0;
    
    select length(NEW.Password) into len;
    
	if len < 6 OR len > 64 then
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lunghezza della password non accettata(range: 6-64)';
    end if;

END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `Account_BEFORE_UPDATE` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`Account_BEFORE_UPDATE`
BEFORE UPDATE ON `smartmobility`.`account`
FOR EACH ROW
BEGIN

    DECLARE len INTEGER DEFAULT 0;
    
    select length(NEW.Password) into len;
    
	if len < 6 OR len > 64 then
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lunghezza della password non accettata(range: 6-64)';
    end if;

END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `AutovetturaRegistrata_BEFORE_INSERT` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`AutovetturaRegistrata_BEFORE_INSERT`
BEFORE INSERT ON `smartmobility`.`autovetturaregistrata`
FOR EACH ROW
BEGIN
    
    if NEW.NumPosti <=0 then
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il numero inserito non è accettabile';
    end if;
    
    if NEW.AnnoImmatricolazione > current_date() then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'L anno inserito non è valido';
    end if;    
    
    if NEW.Cilindrata <= 0 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cilindrata inserita non è valida';
    end if;  
    
    if NEW.CapacitaSerbatoio <= 0 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La capacità del serbatoio inserita non è valida';
    end if;  
    
    if NEW.VelocitaMax <= 0 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La velocità massima inserita non è valida';
    end if;  

END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `AutovetturaRegistrata_BEFORE_UPDATE` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`AutovetturaRegistrata_BEFORE_UPDATE`
BEFORE UPDATE ON `smartmobility`.`autovetturaregistrata`
FOR EACH ROW
BEGIN

    if NEW.NumPosti <=0 then
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il numero inserito non è accettabile';
    end if;
    
    if NEW.AnnoImmatricolazione > current_date() then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'L anno inserito non è valido';
    end if;    
    
    if NEW.Cilindrata <= 0 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cilindrata inserita non è valida';
    end if;  
    
    if NEW.CapacitaSerbatoio <= 0 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La capacità del serbatoio inserita non è valida';
    end if;  
    
    if NEW.VelocitaMax <= 0 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La velocità massima inserita non è valida';
    end if;  

END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `PrenotazioneCS_BI` $$
USE `smartmobility`$$
CREATE 
DEFINER=`root`@`localhost` 
TRIGGER `smartmobility`.`PrenotazioneCS_BI`
BEFORE INSERT ON `smartmobility`.`prenotazionecs`
FOR EACH ROW
BEGIN

    DECLARE lvTipoFruibilita varchar(3);
    DECLARE lvGiornoIni date;
    DECLARE lvGiornoFin date;
    DECLARE lvIteratore date default NEW.DataIni - interval 1 day;
   
    select TipoFruibilita, GiornoIni, GiornoFin
      into lvTipoFruibilita, lvGiornoIni, lvGiornoFin
      from Fruibilita
     where NumTarga = NEW.NumTarga;
     
    if lvTipoFruibilita = 'FAS' then
        if lvGiornoIni > NEW.DataIni
        or lvGiornoFin < NEW.DataFin then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Il periodo inserito non corrisponde con il periodo in cui la vettura può essere noleggiata';
        elseif exists(
            select *
              from PrenotazioneCS
             where NumTarga = NEW.NumTarga
               and NEW.DataIni < DataFin
               and NEW.DataFin > DataIni
               and Stato = 'ACCETTATA'
            ) then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Il periodo inserito non è valido poiché è stata già accettata un altra prenotazione negli stessi giorni';
        end if;
    elseif lvTipoFruibilita = 'PER' then
        if datediff(NEW.DataFin, NEW.DataIni) > 7 
       and (select count(*)
              from Fruibilita
             where NumTarga = NEW.NumTarga
               and ((OraIni = '00:00:00' and OraFin = '24:00:00')
                or (OraIni is null and OraFin is null))) < 7 then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La vettura non può essere prenotata per un periodo di tempo così esteso';
        end if;
        elseif datediff(NEW.DataFin, NEW.DataIni) <= 7 then
            verifica: LOOP
                SET lvIteratore = lvIteratore + interval 1 day;
                 if lvIteratore = NEW.DataIni then
                     if not exists(
                            select *
                              from Fruibilita
                             where NumTarga = NEW.NumTarga
                               and dayofweek(lvIteratore) = GiornoSettimana(NomeGiorno)
                            )   
                     or exists(
                        select *
                          from Fruibilita
                         where NumTarga = NEW.NumTarga
                           and dayofweek(lvIteratore) = GiornoSettimana(NomeGiorno)
                           and OraFin <> '24:00:00'
                        ) then
                            SIGNAL SQLSTATE '45000'
                            SET MESSAGE_TEXT = 'La vettura non può essere prenotata per un periodo di tempo così esteso, o non è disponibile per gli orari selezionati';
                     else ITERATE verifica;
                     end if;
             elseif lvIteratore > NEW.DataIni and lvIteratore < NEW.DataFin then
                     if not exists(
                            select *
                              from Fruibilita
                             where NumTarga = NEW.NumTarga
                               and dayofweek(lvIteratore) = GiornoSettimana(NomeGiorno)
                            )  
                     or exists(
                        select *
                          from Fruibilita
                         where NumTarga = NEW.NumTarga
                           and dayofweek(lvIteratore) = GiornoSettimana(NomeGiorno)
                           and (OraIni <> '00:00:00' or OraFin <> '24:00:00')
                        ) then
                            SIGNAL SQLSTATE '45000'
                            SET MESSAGE_TEXT = 'La vettura non può essere prenotata per un periodo di tempo così esteso, o non è disponibile per gli orari selezionati';
                     else ITERATE verifica;       
                     end if; 
             elseif lvIteratore = NEW.DataFin then
                     if not exists(
                            select *
                              from Fruibilita
                             where NumTarga = NEW.NumTarga
                               and dayofweek(lvIteratore) = GiornoSettimana(NomeGiorno)
                            )  
                     or exists(
                        select *
                          from Fruibilita
                         where NumTarga = NEW.NumTarga
                           and dayofweek(lvIteratore) = GiornoSettimana(NomeGiorno)
                           and (OraIni <> '00:00:00')
                        ) then
                            SIGNAL SQLSTATE '45000'
                            SET MESSAGE_TEXT = 'La vettura non può essere prenotata per un periodo di tempo così esteso, o non è disponibile per gli orari selezionati';
                     else LEAVE verifica;
                     end if;
                 end if;
            END LOOP verifica;
    end if;    
END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `PrenotazioneCS_BU` $$
USE `smartmobility`$$
CREATE 
DEFINER=`root`@`localhost` 
TRIGGER `smartmobility`.`PrenotazioneCS_BU`
BEFORE INSERT ON `smartmobility`.`prenotazionecs`
FOR EACH ROW
BEGIN

    DECLARE lvTipoFruibilita varchar(3);
    DECLARE lvGiornoIni date;
    DECLARE lvGiornoFin date;
    DECLARE lvIteratore date default NEW.DataIni - interval 1 day;
   
    select TipoFruibilita, GiornoIni, GiornoFin
      into lvTipoFruibilita, lvGiornoIni, lvGiornoFin
      from Fruibilita
     where NumTarga = NEW.NumTarga;
     
    if lvTipoFruibilita = 'FAS' then
        if lvGiornoIni > NEW.DataIni
        or lvGiornoFin < NEW.DataFin then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Il periodo inserito non corrisponde con il periodo in cui la vettura può essere noleggiata';
        elseif exists(
            select *
              from PrenotazioneCS
             where NumTarga = NEW.NumTarga
               and NEW.DataIni < DataFin
               and NEW.DataFin > DataIni
               and Stato = 'ACCETTATA'
            ) then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Il periodo inserito non è valido poiché è stata già accettata un altra prenotazione negli stessi giorni';
        end if;
    elseif lvTipoFruibilita = 'PER' then
        if datediff(NEW.DataFin, NEW.DataIni) > 7 
       and (select count(*)
              from Fruibilita
             where NumTarga = NEW.NumTarga
               and ((OraIni = '00:00:00' and OraFin = '24:00:00')
                or (OraIni is null and OraFin is null))) < 7 then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La vettura non può essere prenotata per un periodo di tempo così esteso';
        end if;
        elseif datediff(NEW.DataFin, NEW.DataIni) <= 7 then
            verifica: LOOP
                SET lvIteratore = lvIteratore + interval 1 day;
                 if lvIteratore = NEW.DataIni then
                     if not exists(
                            select *
                              from Fruibilita
                             where NumTarga = NEW.NumTarga
                               and dayofweek(lvIteratore) = GiornoSettimana(NomeGiorno)
                            )   
                     or exists(
                        select *
                          from Fruibilita
                         where NumTarga = NEW.NumTarga
                           and dayofweek(lvIteratore) = GiornoSettimana(NomeGiorno)
                           and OraFin <> '24:00:00'
                        ) then
                            SIGNAL SQLSTATE '45000'
                            SET MESSAGE_TEXT = 'La vettura non può essere prenotata per un periodo di tempo così esteso, o non è disponibile per gli orari selezionati';
                     else ITERATE verifica;
                     end if;
             elseif lvIteratore > NEW.DataIni and lvIteratore < NEW.DataFin then
                     if not exists(
                            select *
                              from Fruibilita
                             where NumTarga = NEW.NumTarga
                               and dayofweek(lvIteratore) = GiornoSettimana(NomeGiorno)
                            )  
                     or exists(
                        select *
                          from Fruibilita
                         where NumTarga = NEW.NumTarga
                           and dayofweek(lvIteratore) = GiornoSettimana(NomeGiorno)
                           and (OraIni <> '00:00:00' or OraFin <> '24:00:00')
                        ) then
                            SIGNAL SQLSTATE '45000'
                            SET MESSAGE_TEXT = 'La vettura non può essere prenotata per un periodo di tempo così esteso, o non è disponibile per gli orari selezionati';
                     else ITERATE verifica;       
                     end if; 
             elseif lvIteratore = NEW.DataFin then
                     if not exists(
                            select *
                              from Fruibilita
                             where NumTarga = NEW.NumTarga
                               and dayofweek(lvIteratore) = GiornoSettimana(NomeGiorno)
                            )  
                     or exists(
                        select *
                          from Fruibilita
                         where NumTarga = NEW.NumTarga
                           and dayofweek(lvIteratore) = GiornoSettimana(NomeGiorno)
                           and (OraIni <> '00:00:00')
                        ) then
                            SIGNAL SQLSTATE '45000'
                            SET MESSAGE_TEXT = 'La vettura non può essere prenotata per un periodo di tempo così esteso, o non è disponibile per gli orari selezionati';
                     else LEAVE verifica;
                     end if;
                 end if;
            END LOOP verifica;
    end if;    
END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `Noleggio_BEFORE_INSERT` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`Noleggio_BEFORE_INSERT`
BEFORE INSERT ON `smartmobility`.`noleggio`
FOR EACH ROW
BEGIN

    if NEW.QtaCarburanteIni < 0 OR NEW.KmPercorsiIni < 0 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Parametri non validi';
    end if;

END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `Noleggio_BEFORE_UPDATE` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`Noleggio_BEFORE_UPDATE`
BEFORE UPDATE ON `smartmobility`.`noleggio`
FOR EACH ROW
BEGIN

    if NEW.QtaCarburanteIni < 0 OR NEW.KmPercorsiIni < 0
		OR NEW.QtaCarburanteFin < 0 OR NEW.KmPercorsiFin < 0 
        OR NEW.KmPercorsiFin < NEW.KmPercorsiIni then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Parametri non validi';
    end if;

END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `Carreggiata_BEFORE_INSERT` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`Carreggiata_BEFORE_INSERT`
BEFORE INSERT ON `smartmobility`.`carreggiata`
FOR EACH ROW
BEGIN

    DECLARE NumMaxCarr INTEGER DEFAULT 0;
    
    select NumCarreggiate INTO NumMaxCarr
      from Strada
	 where CodStrada = NEW.CodStrada;
	
	if NEW.NumCarreggiata > NumMaxCarr then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La strada ha meno carreggiate';
    end if;

END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `CostoAutovettura_BEFORE_INSERT` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`CostoAutovettura_BEFORE_INSERT`
BEFORE INSERT ON `smartmobility`.`costoautovettura`
FOR EACH ROW
BEGIN

     DECLARE MaxNPos INTEGER DEFAULT 0;
    
    select NumPosti into MaxNPos
      from AutovetturaRegistrata
	 where NumTarga = NEW.NumTarga;
    
	if NEW.NumPasseggeri > MaxNPos or New.NumPasseggeri <= 0 then
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La vettura e omologata per meno persone';
    end if;

END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `CostoAutovettura_BEFORE_UPDATE` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`CostoAutovettura_BEFORE_UPDATE`
BEFORE UPDATE ON `smartmobility`.`costoautovettura`
FOR EACH ROW
BEGIN

     DECLARE MaxNPos INTEGER DEFAULT 0;
    
    select NumPosti into MaxNPos
      from AutovetturaRegistrata
	 where NumTarga = NEW.NumTarga;
    
	if NEW.NumPasseggeri > MaxNPos or New.NumPasseggeri <= 0 then
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La vettura e omologata per meno persone';
    end if;

END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `DocumentoRiconoscimento_BEFORE_INSERT` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`DocumentoRiconoscimento_BEFORE_INSERT`
BEFORE INSERT ON `smartmobility`.`documentoriconoscimento`
FOR EACH ROW
BEGIN

    if NEW.Scadenza <= CURRENT_DATE() then
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il documento è già scaduto';
    end if;
    
     if NEW.TipoDocumento <> 'CI' 
    and NEW.TipoDocumento <> 'P'
    and NEW.TipoDocumento <> 'PP' then
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il tipo di documento inserito non è velido';
    end if;

END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `DocumentoRiconoscimento_BEFORE_UPDATE` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`DocumentoRiconoscimento_BEFORE_UPDATE`
BEFORE UPDATE ON `smartmobility`.`documentoriconoscimento`
FOR EACH ROW
BEGIN

    if NEW.Scadenza <= CURRENT_DATE() then
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il documento è già scaduto';
    end if;
    
     if NEW.TipoDocumento <> 'CI' 
    and NEW.TipoDocumento <> 'P'
    and NEW.TipoDocumento <> 'PP' then
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il tipo di documento inserito non è velido';
    end if;

END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `Fruibilita_BI` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`Fruibilita_BI`
BEFORE INSERT ON `smartmobility`.`fruibilita`
FOR EACH ROW
BEGIN
    if NEW.TipoFruibilita <> 'PER' AND NEW.TipoFruibilita <> 'FAS' then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'TipoFruibilita non valida (PER: Periodico; FAS: Fascia)';
    end if;
    if NEW.TipoFruibilita = 'PER' and coalesce(NEW.NomeGiorno, '#') not in ('LUN', 'MAR', 'MER', 'GIO', 'VEN', 'SAB', 'DOM') then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Specificare un nome giorno valido per una fruibilità periodica';
    end if;
    if NEW.TipoFruibilita = 'PER' and (NEW.GiornoIni is not null or NEW.GiornoFin is not null) then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Specificare solamente un nome giorno valido per una fruibilità periodica';
    end if;
    if NEW.TipoFruibilita = 'FAS' and NEW.NomeGiorno is not null then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Specificare solamente un intervallo di giorni valido per una fruibilità a fasce';
    end if;
    if NEW.TipoFruibilita = 'FAS' and (NEW.GiornoIni is null or NEW.GiornoFin is null) then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Specificare un intervallo di giorni valido per una fruibilità a fasce';
    end if;
 /*   if NEW.TipoFruibilita = 'FAS' and (NEW.GiornoIni > NEW.GiornoFin) then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Specificare un intervallo di giorni valido per una fruibilità a fasce';
    end if;
    if NEW.TipoFruibilita = 'FAS' and (NEW.GiornoIni < current_date()) then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Specificare un intervallo di giorni valido per una fruibilità a fasce';
    end if;*/
END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `Fruibilita_BU` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`Fruibilita_BU`
BEFORE UPDATE ON `smartmobility`.`fruibilita`
FOR EACH ROW
BEGIN
    if NEW.TipoFruibilita <> 'PER' AND NEW.TipoFruibilita <> 'FAS' then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'TipoFruibilita non valida (PER: Periodico; FAS: Fascia)';
    end if;
    if NEW.TipoFruibilita = 'PER' and coalesce(NEW.NomeGiorno, '#') not in ('LUN', 'MAR', 'MER', 'GIO', 'VEN', 'SAB', 'DOM') then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Specificare un nome giorno valido per una fruibilità periodica';
    end if;
    if NEW.TipoFruibilita = 'PER' and (NEW.GiornoIni is not null or NEW.GiornoFin is not null) then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Specificare solamente un nome giorno valido per una fruibilità periodica';
    end if;
    if NEW.TipoFruibilita = 'FAS' and NEW.NomeGiorno is not null then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Specificare solamente un intervallo di giorni valido per una fruibilità a fasce';
    end if;
    if NEW.TipoFruibilita = 'FAS' and (NEW.GiornoIni is null or NEW.GiornoFin is null) then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Specificare un intervallo di giorni valido per una fruibilità a fasce';
    end if;
 /*   if NEW.TipoFruibilita = 'FAS' and (NEW.GiornoIni > NEW.GiornoFin) then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Specificare un intervallo di giorni valido per una fruibilità a fasce';
    end if;
    if NEW.TipoFruibilita = 'FAS' and (NEW.GiornoIni < current_date()) then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Specificare un intervallo di giorni valido per una fruibilità a fasce';
    end if;*/
END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `Incrocio_BEFORE_INSERT` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`Incrocio_BEFORE_INSERT`
BEFORE INSERT ON `smartmobility`.`incrocio`
FOR EACH ROW
BEGIN

    DECLARE ClassStrada1 VARCHAR(3) DEFAULT '';
    DECLARE ClassStrada2 VARCHAR(3) DEFAULT '';
    DECLARE lvCarreggiata1 TINYINT DEFAULT 0;
    DECLARE lvCarreggiata2 TINYINT DEFAULT 0;
    
    select CodClassTec into ClassStrada1
      from Strada
	 where CodStrada = NEW.CodStrada;
	
	select CodClassTec into ClassStrada2
      from Strada
	 where CodStrada = NEW.CodStradaX;
	
	select if(Numcorsie > NumSensiMarcia, 1, 0) into lvCarreggiata1
      from Carreggiata
	 where NumCarreggiata = NEW.NumCarreggiata
		   AND CodStrada = NEW.CodStrada;
	
	select if(Numcorsie > NumSensiMarcia, 1, 0) into lvCarreggiata2
      from Carreggiata
	 where CodStrada = NEW.CodStradaX
		   AND NumCarreggiata = NEW.NumCarreggiata;
    
	-- caso in cui hanno più di una corsia per senso di marcia
	if ClassStrada1 = 'SXP' OR ClassStrada2 = 'SXP'
           OR ClassStrada1 = 'AUT' OR ClassStrada2 = 'AUT' then
           SIGNAL SQLSTATE '45000'
		   SET MESSAGE_TEXT = 'Le strade non possono avere un incrocio';
    elseif (ClassStrada1 = 'SXS' AND lvCarreggiata1) OR (ClassStrada2 = 'SXS' AND lvCarreggiata2) then
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Le strade non possono avere un incrocio';
    end if;

END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `Incrocio_BEFORE_UPDATE` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`Incrocio_BEFORE_UPDATE`
BEFORE UPDATE ON `smartmobility`.`incrocio`
FOR EACH ROW
BEGIN

    DECLARE ClassStrada1 VARCHAR(3) DEFAULT '';
    DECLARE ClassStrada2 VARCHAR(3) DEFAULT '';
    DECLARE lvCarreggiata1 TINYINT DEFAULT 0;
    DECLARE lvCarreggiata2 TINYINT DEFAULT 0;
    
    select CodClassTec into ClassStrada1
      from Strada
	 where CodStrada = NEW.CodStrada;
	
	select CodClassTec into ClassStrada2
      from Strada
	 where CodStrada = NEW.CodStradaX;
	
	select if(Numcorsie > NumSensiMarcia, 1, 0) into lvCarreggiata1
      from Carreggiata
	 where NumCarreggiata = NEW.NumCarreggiata
		   AND CodStrada = NEW.CodStrada;
	
	select if(Numcorsie > NumSensiMarcia, 1, 0) into lvCarreggiata2
      from Carreggiata
	 where CodStrada = NEW.CodStradaX
		   AND NumCarreggiata = NEW.NumCarreggiata;
    
	-- caso in cui hanno più di una corsia per senso di marcia
	if ClassStrada1 = 'SXP' OR ClassStrada2 = 'SXP'
           OR ClassStrada1 = 'AUT' OR ClassStrada2 = 'AUT' then
           SIGNAL SQLSTATE '45000'
		   SET MESSAGE_TEXT = 'Le strade non possono avere un incrocio';
    elseif (ClassStrada1 = 'SXS' AND lvCarreggiata1) OR (ClassStrada2 = 'SXS' AND lvCarreggiata2) then
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Le strade non possono avere un incrocio';
    end if;

END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `Optional_BEFORE_INSERT` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`Optional_BEFORE_INSERT`
BEFORE INSERT ON `smartmobility`.`optional`
FOR EACH ROW
BEGIN

    if (NEW.CodOptional = 'BAGAGLIAIO' OR NEW.CodOptional = 'INSONORIZZAZIONE')
		AND NEW.Voto IS NOT NULL then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Non è possibile dare un voto a questi optional';
    end if;
    
    if (NEW.CodOptional = 'BAGAGLIAIO' OR NEW.CodOptional = 'INSONORIZZAZIONE')
		AND NEW.Voto < 0 OR NEW.Voto > 3 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Voto non accettabile';
    end if;

END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `Optional_BEFORE_UPDATE` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`Optional_BEFORE_UPDATE`
BEFORE UPDATE ON `smartmobility`.`optional`
FOR EACH ROW
BEGIN

    if (NEW.Descrizione = 'Bagagliaio' OR NEW.Descrizione = 'Insonorizzato')
		AND NEW.Voto IS NOT NULL then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Non è possibile dare un voto a questi optional';
    end if;
    
    if (NEW.Descrizione <> 'Bagagliaio' OR NEW.Descrizione <> 'Insonorizzato')
		AND NEW.Voto < 0 OR NEW.Voto > 3 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Voto non accettabile';
    end if;

END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `OptionalAuto_BEFORE_INSERT` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`OptionalAuto_BEFORE_INSERT`
BEFORE INSERT ON `smartmobility`.`optionalauto`
FOR EACH ROW
BEGIN

    if (NEW.CodOptional = 'BAGAGLIAIO' OR NEW.CodOptional = 'INSONORIZZAZIONE')
		AND NEW.Valore IS NULL then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Non è possibile non dare un valore a questi optional';
    end if;

END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `OptionalAuto_BEFORE_UPDATE` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`OptionalAuto_BEFORE_UPDATE`
BEFORE UPDATE ON `smartmobility`.`optionalauto`
FOR EACH ROW
BEGIN

    if (NEW.CodOptional = 'BAGAGLIAIO' OR NEW.CodOptional = 'INSONORIZZAZIONE')
		AND NEW.Valore IS NULL then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Non è possibile non dare un valore a questi optional';
    end if;
   
END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `Svincolo_BEFORE_INSERT` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`Svincolo_BEFORE_INSERT`
BEFORE INSERT ON `smartmobility`.`svincolo`
FOR EACH ROW
BEGIN

    DECLARE lvClassTec varchar(3);
    
    -- Ricavo il codice di classificazione tecnica della strada
    select CodClassTec
      into lvClassTec
      from Strada
     where CodStrada = NEW.CodStrada; 
    
    -- Eseguo i controlli
    if lvClassTec = 'SUR' then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Uno svincolo non può trovarsi in una strada urbana';
    end if;
    
    if lvClassTec = 'SXS' then
        if not exists(
            select *
              from Carreggiata
             where NumCorsie > NumSensiMarcia
               and NumCarreggiata = NEW.NumCarreggiata
            ) then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Uno svincolo non può trovarsi in una strada extraurbana secondaria con meno di 2 corsie per almeno un senso di marcia';
        end if;
    end if;
       
END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `Svincolo_BEFORE_UPDATE` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`Svincolo_BEFORE_UPDATE`
BEFORE UPDATE ON `smartmobility`.`svincolo`
FOR EACH ROW
BEGIN

    DECLARE lvClassTec varchar(3);
    
    -- Ricavo il codice di classificazione tecnica della strada
    select CodClassTec
      into lvClassTec
      from Strada
     where CodStrada = NEW.CodStrada; 
    
    -- Eseguo i controlli
    if lvClassTec = 'SUR' then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Uno svincolo non può trovarsi in una strada urbana';
    end if;
    
    if lvClassTec = 'SXS' then
        if not exists(
            select *
              from Carreggiata
             where NumCorsie > NumSensiMarcia
               and NumCarreggiata = NEW.NumCarreggiata
            ) then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Uno svincolo non può trovarsi in una strada extraurbana secondaria con meno di 2 corsie per almeno un senso di marcia';
        end if;
    end if;

END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `Pedaggio_BEFORE_INSERT` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`Pedaggio_BEFORE_INSERT`
BEFORE INSERT ON `smartmobility`.`pedaggio`
FOR EACH ROW
BEGIN

     DECLARE ClassStrada1 VARCHAR(3) DEFAULT '';
    DECLARE ClassStrada2 VARCHAR(3) DEFAULT '';
     
    select CodClassTec into ClassStrada1
      from Svincolo
		   natural join Strada
	 where CodSvincolo = NEW.CodSvincoloE;
	
	select CodClassTec into ClassStrada2
      from Svincolo
		   natural join Strada
	 where CodSvincolo = NEW.CodSvincoloU;
	
	if ClassStrada1 <> 'AUT' 
    or ClassStrada2 <> 'AUT' then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Le strade non sono autostrade';
    end if;

END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `Pedaggio_BEFORE_UPDATE` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`Pedaggio_BEFORE_UPDATE`
BEFORE UPDATE ON `smartmobility`.`pedaggio`
FOR EACH ROW
BEGIN

     DECLARE ClassStrada1 VARCHAR(3) DEFAULT '';
    DECLARE ClassStrada2 VARCHAR(3) DEFAULT '';
     
    select CodClassTec into ClassStrada1
      from Svincolo
		   natural join Strada
	 where CodSvincolo = NEW.CodSvincoloE;
	
	select CodClassTec into ClassStrada2
      from Svincolo
		   natural join Strada
	 where CodSvincolo = NEW.CodSvincoloU;
	
	if ClassStrada1 <> 'AUT' 
    or ClassStrada2 <> 'AUT' then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Le strade non sono autostrade';
    end if;

END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `Pool_BEFORE_INSERT` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`Pool_BEFORE_INSERT`
BEFORE INSERT ON `smartmobility`.`pool`
FOR EACH ROW
BEGIN

    if current_timestamp > (NEW.DataPartenza - interval 48 hour) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il pool non può essere creato a meno di 48 ore dalla partenza';
    end if;
    
    if NEW.Validita < 48 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La scadenza del pool non può essere impostata a meno di 48 ore dalla partenza';
    end if;
    
    if NEW.DataArrivo < NEW.DataPartenza then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La data di arrivo non può precedere la data di partenza';
    end if;
    
END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `Pool_BEFORE_UPDATE` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`Pool_BEFORE_UPDATE`
BEFORE UPDATE ON `smartmobility`.`pool`
FOR EACH ROW
BEGIN
    
    if NEW.Validita < 48 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La scadenza del pool non può essere impostata a meno di 48 ore dalla partenza';
    end if;
    
    if NEW.DataArrivo < NEW.DataPartenza then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La data di arrivo non può precedere la data di partenza';
    end if;

END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `PrenotazioneCP_BEFORE_INSERT` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`PrenotazioneCP_BEFORE_INSERT`
BEFORE INSERT ON `smartmobility`.`prenotazionecp`
FOR EACH ROW
BEGIN

    DECLARE posti INTEGER DEFAULT 0;
    
    select PostiDisponibili into posti
      from Pool
	 where CodPool = NEW.CodPool;
	
	if posti = 0 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nessun posto disponibile al momento';
    end if;

END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `ValutazioneAspetti_BI` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`ValutazioneAspetti_BI`
BEFORE INSERT ON `smartmobility`.`valutazioneaspetti`
FOR EACH ROW
BEGIN
    if NEW.Voto not between 0 and 5 then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Il voto deve essere compreso tra 0 e 5';
    end if;
END$$


USE `smartmobility`$$
DROP TRIGGER IF EXISTS `ValutazioneAspetti_BU` $$
USE `smartmobility`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `smartmobility`.`ValutazioneAspetti_BU`
BEFORE UPDATE ON `smartmobility`.`valutazioneaspetti`
FOR EACH ROW
BEGIN
    if NEW.Voto not between 0 and 5 then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Il voto deve essere compreso tra 0 e 5';
    end if;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;