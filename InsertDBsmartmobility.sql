/***********************************************************************
** smartmobility.CategoriaStrada
***********************************************************************/
INSERT INTO smartmobility.CategoriaStrada (CodCategStrada, Descrizione) VALUES ('dir', 'diramazione');
INSERT INTO smartmobility.CategoriaStrada (CodCategStrada, Descrizione) VALUES ('var', 'variante');
INSERT INTO smartmobility.CategoriaStrada (CodCategStrada, Descrizione) VALUES ('racc', 'raccordo');
INSERT INTO smartmobility.CategoriaStrada (CodCategStrada, Descrizione) VALUES ('radd', 'raddoppio');
INSERT INTO smartmobility.CategoriaStrada (CodCategStrada, Descrizione) VALUES ('bis', 'bis');
INSERT INTO smartmobility.CategoriaStrada (CodCategStrada, Descrizione) VALUES ('ter', 'ter');
INSERT INTO smartmobility.CategoriaStrada (CodCategStrada, Descrizione) VALUES ('quater', 'quater');

/***********************************************************************
** smartmobility.TipoStrada
***********************************************************************/
INSERT INTO smartmobility.TipoStrada (CodTipoStrada, Descrizione) VALUES ('SS', 'Strada Statale');
INSERT INTO smartmobility.TipoStrada (CodTipoStrada, Descrizione) VALUES ('SR', 'Strada Regionale');
INSERT INTO smartmobility.TipoStrada (CodTipoStrada, Descrizione) VALUES ('SP', 'Strada Provinciale');
INSERT INTO smartmobility.TipoStrada (CodTipoStrada, Descrizione) VALUES ('SC', 'Strada Comunale');
INSERT INTO smartmobility.TipoStrada (CodTipoStrada, Descrizione) VALUES ('SV', 'Strada Vicinale');
INSERT INTO smartmobility.TipoStrada (CodTipoStrada, Descrizione) VALUES ('A', 'Autostrada');

/***********************************************************************
** smartmobility.CodClassificazioneTecnica
***********************************************************************/
INSERT INTO smartmobility.ClassTecStrada (CodClassificazioneTecnica, Descrizione) VALUES ('SUR', 'Strada Urbana');
INSERT INTO smartmobility.ClassTecStrada (CodClassificazioneTecnica, Descrizione) VALUES ('SXP', 'Strada eXtraurbana Principale');
INSERT INTO smartmobility.ClassTecStrada (CodClassificazioneTecnica, Descrizione) VALUES ('SXS', 'Strada eXtraurbana Secondaria');
INSERT INTO smartmobility.ClassTecStrada (CodClassificazioneTecnica, Descrizione) VALUES ('AUT', 'Autostrada');

/***********************************************************************
** smartmobility.Strada Urbane
***********************************************************************/
select smartmobility.ChkInsStradaUR('VIA', 'BRIGATE PARTIGIANE', 'FOLLO', 'SP', 'LIG', 'IT', '19020', 2.485, 1, 'SUR');
call InsUpdCarreggiata('STR000000001', 1, 2, 2);
select smartmobility.ChkInsTratta('STR000000001', 1, 2.485, 44.159168, 9.866092, 44.182984, 9.853582);
call InsUpdLimiteVelocita('STR000000001', 1, ChkInsPosizione(44.159168, 9.866092, NULL, NULL, NULL), 50);
insert into pietramiliare (CodStrada, NumCarreggiata, CodPosizione) values ('STR000000001', 1, ChkInsPosizione(44.165182, 9.861364, NULL, NULL, NULL));
insert into pietramiliare (CodStrada, NumCarreggiata, CodPosizione) values ('STR000000001', 1, ChkInsPosizione(44.162176, 9.863219, NULL, NULL, NULL));

select smartmobility.ChkInsStradaUR('PIAZZA', 'GIACOMO MATTEOTTI', 'FOLLO', 'SP', 'LIG', 'IT', '19020', 0.081, 1, 'SUR');
call InsUpdCarreggiata('STR000000002', 1, 1, 1);
select smartmobility.ChkInsTratta('STR000000002', 1, 0.081, 44.162840, 9.862767, 44.162713, 9.862831);
call InsUpdLimiteVelocita('STR000000002', 1, ChkInsPosizione(44.162840, 9.862767, NULL, NULL, NULL), 50);

select smartmobility.ChkInsStradaUR('VIA', 'DEL PIANO', 'FOLLO', 'SP', 'LIG', 'IT', '19020', 0.160, 1, 'SUR');
call InsUpdCarreggiata('STR000000003', 1, 2, 2);
select smartmobility.ChkInsTratta('STR000000003', 1, 0.160, 44.161282, 9.863714, 44.160643, 9.861895);
select smartmobility.ChkInsIncrocio('STR000000001', 1, 2.000, 44.160643, 9.861895, 'STR000000003', 1, 0.160);
call InsUpdLimiteVelocita('STR000000003', 1, ChkInsPosizione(44.161282, 9.863714, NULL, NULL, NULL), 30);

select smartmobility.ChkInsStradaUR('VIA', 'EUROPA', 'FOLLO', 'SP', 'LIG', 'IT', '19020', 0.534, 1, 'SUR');
call InsUpdCarreggiata('STR000000004', 1, 2, 2);
select smartmobility.ChkInsTratta('STR000000004', 1, 0.534, 44.159161, 9.863891, 44.162456, 9.860968);
call InsUpdLimiteVelocita('STR000000004', 1, ChkInsPosizione(44.159161, 9.863891, NULL, NULL, NULL), 50);

select smartmobility.ChkInsStradaUR('PIAZZA', 'GIUSEPPE GARIBALDI', 'FOLLO', 'SP', 'LIG', 'IT', '19020', 0.159, 1, 'SUR');
call InsUpdCarreggiata('STR000000005', 1, 2, 2);
select smartmobility.ChkInsTratta('STR000000005', 1, 0.159, 44.164804, 9.861592, 44.163755, 9.860824);
call InsUpdLimiteVelocita('STR000000005', 1, ChkInsPosizione(44.164804, 9.861592, NULL, NULL, NULL), 30);

select smartmobility.ChkInsStradaUR('VIA', 'CHIESA', 'FOLLO', 'SP', 'LIG', 'IT', '19020', 0.160, 1, 'SUR');
call InsUpdCarreggiata('STR000000006', 1, 2, 2);
select smartmobility.ChkInsTratta('STR000000006', 1, 0.160, 44.159963, 9.864655, 44.159128, 9.863915);
call InsUpdLimiteVelocita('STR000000006', 1, ChkInsPosizione(44.159963, 9.864655, NULL, NULL, NULL), 50);

/*select S.CodStrada, C.NumCarreggiata, C.NumSensiMarcia, SU.DUG, S.Nome, SU.CAP, S.Lunghezza, S.NumCarreggiate, SU.Nazione, SU.Regione, SU.Provincia, SU.Comune,
       T.CodTratta, T.Lunghezza, T.CodPosizioneIni, PI.Latitudine, PI.Longitudine, T.CodPosizioneFin, PF.Latitudine, PF.Longitudine
  from Strada S
       inner join Carreggiata C on (C.CodStrada = S.CodStrada)
       inner join StradaUrbana SU on (SU.CodStrada = S.CodStrada)
       left outer join Tratta T on (T.CodStrada = S.CodStrada and T.NumCarreggiata = C.NumCarreggiata)
       left outer join Posizione PI on (PI.CodPosizione = T.CodPosizioneIni)
       left outer join Posizione PF on (PF.CodPosizione = T.CodPosizioneFin)
  ;*/

/***********************************************************************
** smartmobility.Strada Extraurbane
***********************************************************************/
select smartmobility.ChkInsStradaXU('SP', NULL, 10, NULL, NULL, 13.40, 1, 'SXS');
call InsUpdCarreggiata('STR000000007', 1, 2, 2);
select smartmobility.ChkInsTratta('STR000000007', 1, 13.40, 44.159120, 9.874254, 44.197270, 9.766991);
call InsUpdLimiteVelocita('STR000000007', 1, ChkInsPosizione(44.159120, 9.874254, NULL, NULL, NULL), 70);

select smartmobility.ChkInsStradaXU('SP', NULL, 330, NULL, NULL, 7.72, 1, 'SXS');
call InsUpdCarreggiata('STR000000008', 1, 2, 2);
select smartmobility.ChkInsTratta('STR000000008', 1, 7.72, 44.122910, 9.846729, 44.167993, 9.892381);
call InsUpdLimiteVelocita('STR000000008', 1, ChkInsPosizione(44.122910, 9.846729, NULL, NULL, NULL), 70);

select smartmobility.ChkInsStradaXU('SR', NULL, 250, NULL, 'SANTA RITA', 25, 2, 'SXP');
call InsUpdCarreggiata('STR000000009', 1, 2, 2);
call InsUpdCarreggiata('STR000000009', 2, 1, 1);
select smartmobility.ChkInsTratta('STR000000009', 1, 25, 44.165301, 9.878124, 44.045025, 10.048608);
select smartmobility.ChkInsTratta('STR000000009', 2, 25, 44.045025, 10.048608, 44.165301, 9.878124);
call InsUpdLimiteVelocita('STR000000009', 1, ChkInsPosizione(44.165301, 9.878124, NULL, NULL, NULL), 90);
call InsUpdLimiteVelocita('STR000000009', 2, ChkInsPosizione(44.045025, 10.048608, NULL, NULL, NULL), 90);
select smartmobility.ChkInsSvincolo('STR000000009', 1, ChkInsPosizione(44.165301, 9.878124, NULL, NULL, NULL), 'E');
select smartmobility.ChkInsSvincolo('STR000000009', 1, ChkInsPosizione(44.045025, 10.048608, NULL, NULL, NULL), 'U');
select smartmobility.ChkInsSvincolo('STR000000009', 2, ChkInsPosizione(44.045025, 10.048608, NULL, NULL, NULL), 'E');
select smartmobility.ChkInsSvincolo('STR000000009', 2, ChkInsPosizione(44.165301, 9.878124, NULL, NULL, NULL), 'U');

select smartmobility.ChkInsStradaXU('A', NULL, 35, NULL, 'SAN EDOARDO RE', 167, 2, 'AUT');
call InsUpdCarreggiata('STR000000010', 1, 2, 1);
call InsUpdCarreggiata('STR000000010', 2, 2, 1);
select smartmobility.ChkInsTratta('STR000000010', 1, 167, 44.140411, 9.905761, 43.335501, 11.315183);
select smartmobility.ChkInsTratta('STR000000010', 2, 167, 43.335501, 11.315183, 44.140411, 9.905761);
call InsUpdLimiteVelocita('STR000000010', 1, ChkInsPosizione(44.140411, 9.905761, NULL, NULL, NULL), 130);
call InsUpdLimiteVelocita('STR000000010', 2, ChkInsPosizione(43.335501, 11.315183, NULL, NULL, NULL), 130);
select smartmobility.ChkInsSvincolo('STR000000010', 1, ChkInsPosizione(44.140411, 9.905761, NULL, NULL, NULL), 'E');
select smartmobility.ChkInsSvincolo('STR000000010', 1, ChkInsPosizione(43.335501, 11.315183, NULL, NULL, NULL), 'U');
select smartmobility.ChkInsSvincolo('STR000000010', 2, ChkInsPosizione(43.335501, 11.315183, NULL, NULL, NULL), 'E');
select smartmobility.ChkInsSvincolo('STR000000010', 2, ChkInsPosizione(44.140411, 9.905761, NULL, NULL, NULL), 'U');
call InsUpdPedaggio(ChkInsSvincolo('STR000000010', 1, ChkInsPosizione(44.140411, 9.905761, NULL, NULL, NULL), 'E'),
					ChkInsSvincolo('STR000000010', 1, ChkInsPosizione(43.335501, 11.315183, NULL, NULL, NULL), 'U'),
                    16);
call InsUpdPedaggio(ChkInsSvincolo('STR000000010', 2, ChkInsPosizione(43.335501, 11.315183, NULL, NULL, NULL), 'E'),
					ChkInsSvincolo('STR000000010', 2, ChkInsPosizione(44.140411, 9.905761, NULL, NULL, NULL), 'U'),
                    16);

select smartmobility.ChkInsStradaXU('A', NULL, 34, NULL, 'SAN MARTINO', 102, 2, 'AUT');
call InsUpdCarreggiata('STR000000011', 1, 2, 1);
call InsUpdCarreggiata('STR000000011', 2, 2, 1);
select smartmobility.ChkInsTratta('STR000000011', 1, 102, 44.107158, 9.936118, 43.305507, 10.547336);
select smartmobility.ChkInsTratta('STR000000011', 2, 102, 43.305507, 10.547336, 44.107158, 9.936118);
call InsUpdLimiteVelocita('STR000000011', 1, ChkInsPosizione(44.107158, 9.936118, NULL, NULL, NULL), 130);
call InsUpdLimiteVelocita('STR000000011', 2, ChkInsPosizione(43.305507, 10.547336, NULL, NULL, NULL), 130);
select smartmobility.ChkInsRaccordo('STR000000010', 1, ChkInsPosizione(44.107158, 9.936118, NULL, NULL, NULL), 'STR000000011', 2, ChkInsPosizione(43.638895, 10.578195, NULL, NULL, NULL));
select smartmobility.ChkInsSvincolo('STR000000011', 1, ChkInsPosizione(44.140411, 9.905761, NULL, NULL, NULL), 'E');
select smartmobility.ChkInsSvincolo('STR000000011', 1, ChkInsPosizione(43.305507, 10.547336, NULL, NULL, NULL), 'U');
select smartmobility.ChkInsSvincolo('STR000000011', 2, ChkInsPosizione(43.305507, 10.547336, NULL, NULL, NULL), 'E');
select smartmobility.ChkInsSvincolo('STR000000011', 2, ChkInsPosizione(44.107158, 9.936118, NULL, NULL, NULL), 'U');
call InsUpdPedaggio(ChkInsSvincolo('STR000000011', 1, ChkInsPosizione(44.107158, 9.936118, NULL, NULL, NULL), 'E'),
					ChkInsSvincolo('STR000000011', 1, ChkInsPosizione(43.305507, 10.547336, NULL, NULL, NULL), 'U'),
                    12);
call InsUpdPedaggio(ChkInsSvincolo('STR000000011', 2, ChkInsPosizione(43.305507, 10.547336, NULL, NULL, NULL), 'E'),
					ChkInsSvincolo('STR000000011', 2, ChkInsPosizione(44.107158, 9.936118, NULL, NULL, NULL), 'U'),
                    12);

/*select S.CodStrada, C.NumCarreggiata, C.NumSensiMarcia, SX.CodTipoStrada, SX.Numero, S.Nome, S.Lunghezza, S.NumCarreggiate,
       T.CodTratta, T.Lunghezza, T.CodPosizioneIni, PI.Latitudine, PI.Longitudine, T.CodPosizioneFin, PF.Latitudine, PF.Longitudine
  from Strada S
       inner join Carreggiata C on (C.CodStrada = S.CodStrada)
       inner join Stradaextraurbana SX on (SX.CodStrada = S.CodStrada)
       left outer join Tratta T on (T.CodStrada = S.CodStrada and T.NumCarreggiata = C.NumCarreggiata)
       left outer join Posizione PI on (PI.CodPosizione = T.CodPosizioneIni)
       left outer join Posizione PF on (PF.CodPosizione = T.CodPosizioneFin)
;*/

/***********************************************************************
** smartmobility.Registrazione Utente
***********************************************************************/
call RegistraUtente('CRMNNN61H25F158H', 'CREMENTE', 'MARCELLO', '3337197934', 'IT', 'LIG', 'SP', 'FOLLO', '19020', 'VIA', 'EUROPA', '37', NULL, 'CI', 'Comune di Follo', '12345', '2030-01-01', 'marcello.cremente', 'password', 'Bella domanda', 'Bella risposta');
call RegistraUtente('CRMDRD98M24F463J', 'CREMENTE', 'EDOARDO', '3339985564', 'IT', 'LIG', 'SP', 'FOLLO', '19020', 'VIA', 'EUROPA', '37', NULL, 'CI', 'Comune di Follo', '12346', '2030-01-01', 'edoardo.cremente', 'password', 'Dammi una bella risposta', 'Bella risposta');
call RegistraUtente('FZZDRD98Z11I499Z', 'FAZZARI', 'EDOARDO', '3495592579', 'IT', 'LIG', 'SP', 'FOLLO', '19020', 'PIAZZA', 'GARIBALDI', '5', NULL, 'CI', 'Comune di Follo', '12347', '2030-01-01', 'edoardo.fazzari', 'drowssap', 'imaihc it emoc', 'odraode');
call RegistraUtente('LSAMCL63L47C773X', 'ALOISI', 'MARCELLA', '3393470865', 'IT', 'LIG', 'SP', 'FOLLO', '19020', 'VIA', 'EUROPA', '37', NULL, 'CI', 'Comune di Follo', '12348', '2030-01-01', 'marcella.aloisi', 'passwordmamma', 'Dammi una bella risposta', 'risposta bella');
call RegistraUtente('SMNMNC67P49E463Y', 'SIMONINI', 'MONICA', '3472639767', 'IT', 'LIG', 'SP', 'FOLLO', '19020', 'PIAZZA', 'GARIBALDI', '5', NULL, 'CI', 'Comune di Follo', '12349', '2030-01-01', 'monica.simonini', 'simonica', 'nome gatto', 'lulu');
call RegistraUtente('GPPFZZ62H27E370M', 'FAZZARI', 'GIUSEPPE', '3478896138', 'IT', 'LIG', 'SP', 'FOLLO', '19020', 'PIAZZA', 'GARIBALDI', '5', NULL, 'CI', 'Comune di Follo', '12350', '2030-01-01', 'giuseppe.fazzari', 'nonsisa', 'cosa non si sa', 'password');
-- Posizione Indirizzi
select ChkInsPosizione(44.160646, 9.861820, 'STR000000004', 0.232, 'IND000000001'); -- Via Europa 37, 19020 Follo (SP)
select ChkInsPosizione(44.160646, 9.861820, 'STR000000005', 0.066, 'IND000000002'); -- Piazza Giuseppe Garibaldi 5, 19020 Follo (SP)


/*select U.CodFiscale, U.Cognome, U.Nome, U.CodIndirizzo, P.*, U.Telefono, U.Stato, U.DataIscrizione,
       A.*, D.*
  from Utente U
       left outer join Posizione P on (P.CodIndirizzo = U.CodIndirizzo)
       left outer join Account A on (A.CodFiscale = U.CodFiscale)
       left outer join DocumentoRiconoscimento D on (D.CodFiscale = U.CodFiscale)
;
call EliminaUtente('CRMNNN61H25F158H');*/

/***********************************************************************
** smartmobility.FasceOrarie
***********************************************************************/
INSERT INTO FasciaOraria (CodFascia, OraIni, OraFin) VALUES (NewProgressivo('FAS', 'FasciaOraria'), '00:00:00', '02:59:59');
INSERT INTO FasciaOraria (CodFascia, OraIni, OraFin) VALUES (NewProgressivo('FAS', 'FasciaOraria'), '03:00:00', '05:59:59');
INSERT INTO FasciaOraria (CodFascia, OraIni, OraFin) VALUES (NewProgressivo('FAS', 'FasciaOraria'), '06:00:00', '08:59:59');
INSERT INTO FasciaOraria (CodFascia, OraIni, OraFin) VALUES (NewProgressivo('FAS', 'FasciaOraria'), '09:00:00', '11:59:59');
INSERT INTO FasciaOraria (CodFascia, OraIni, OraFin) VALUES (NewProgressivo('FAS', 'FasciaOraria'), '12:00:00', '14:59:59');
INSERT INTO FasciaOraria (CodFascia, OraIni, OraFin) VALUES (NewProgressivo('FAS', 'FasciaOraria'), '15:00:00', '17:59:59');
INSERT INTO FasciaOraria (CodFascia, OraIni, OraFin) VALUES (NewProgressivo('FAS', 'FasciaOraria'), '18:00:00', '20:59:59');
INSERT INTO FasciaOraria (CodFascia, OraIni, OraFin) VALUES (NewProgressivo('FAS', 'FasciaOraria'), '21:00:00', '23:59:59');

/***********************************************************************
** smartmobility.Optional
***********************************************************************/
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('CLIMA', 'Climatizzatore', 'P', NULL);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('AIRBAG', 'Air Bag', 'P', NULL);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('SEDILI_SMART', 'Sedili regolabili', 'P', NULL);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('SERVOSTERZO', 'Servo-sterzo', 'P', NULL);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('FENDINEBBIA', 'Fendi-nebbia', 'P', NULL);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('CAMBIO_AUTO', 'Cambio automatico', 'S', 2.2);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('AUTOPILOT', 'Pilota automatico', 'S', 3);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('FARI_LED', 'Fari a led', 'S', 0.8);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('FRENATA_AUTO', 'Frenata Automatica', 'S', 1.9);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('AUTORADIO', 'Autoradio', 'S', 0.7);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('NAVIGATORE', 'Navigatore integrato', 'S', 2.6);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('LIVING_HOME', 'Living home', 'S', 0.3);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('ALZACRISTALLI', 'Alzacristalli elettrici', 'S', 0.2);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('SPECCHIETTI_AUTO', 'Chiusura automatica specchietti', 'S', 0.3);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('CHIUSURA_CENTR', 'Chiusura centralizzata', 'S', 0.3);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('PARK_ASSIST', 'Parcheggio assistito', 'S', 2.7);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('FRONT_SENSORS', 'Sensori di parcheggio anteriori', 'S', 1.3);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('BACK_SENSORS', 'Sensori di parcheggio posteriori', 'S', 1.4);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('RAIN_SENSORS', 'Sensori di pioggia', 'S', 0.4);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('FATIGUE_SENSORS', 'Sensori di stanchezza', 'S', 2);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('RETROCAMERA', 'Videocamera posteriore', 'S', 2.1);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('SEDILI_PELLE', 'Sedili in pelle', 'S', 0.8);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('CERCHI_LEGA', 'Cerchi in lega', 'S', 0.2);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('VOCAL_COMMANDS', 'Comandi vocali', 'S', 1.7);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('AUDIO_SUPPORT', 'Supporto audio', 'S', 0.4);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('INSONORIZZAZIONE', 'Abitacolo insonorizzato', 'S', NULL);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('BAGAGLIAIO', 'Capacità del bagagliaio', 'S', NULL);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('VOLANTE_SMART', 'Volante con tasti comando', 'S', 1.1);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('CRUISE_CONTROL', 'Impostazione velocità di crociera', 'S', 2);
INSERT INTO smartmobility.Optional (CodOptional, Descrizione, TipoOptional, Voto ) VALUES ('SPEED_LIMIT', 'Limitatore di velocità', 'S', 1.5);

-- select * from Optional;

/***********************************************************************
** smartmobility.Registrazione Autovettura
***********************************************************************/
call RegistraAutovettura('DL871EZ', 'CRMNNN61H25F158H', 5, 2000, 2008, 'VOLKSWAGEN', 'TIGUAN', NULL, 200, 80, 'DIESEL', 0.05, 0.05, 7.0, 7.5, 8.0);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('DL871EZ', 'CLIMA', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('DL871EZ', 'AIRBAG', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('DL871EZ', 'SEDILI_SMART', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('DL871EZ', 'SERVOSTERZO', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('DL871EZ', 'FENDINEBBIA', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('DL871EZ', 'AUTORADIO', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('DL871EZ', 'NAVIGATORE', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('DL871EZ', 'ALZACRISTALLI', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('DL871EZ', 'CHIUSURA_CENTR', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('DL871EZ', 'SEDILI_PELLE', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('DL871EZ', 'AUDIO_SUPPORT', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('DL871EZ', 'VOLANTE_SMART', NULL, NULL);
UPDATE AutovetturaRegistrata SET comfort = GetComfortAuto(NumTarga) WHERE NumTarga = 'DL871EZ';
--
call RegistraAutovettura('EH732KV', 'LSAMCL63L47C773X', 5, 1100, 2008, 'HYUNDAI', 'I10', NULL, 160, 50, 'BENZINA', 0.03, 0.03, 9.0, 9.5, 10);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('EH732KV', 'CLIMA', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('EH732KV', 'AIRBAG', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('EH732KV', 'SEDILI_SMART', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('EH732KV', 'SERVOSTERZO', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('EH732KV', 'FENDINEBBIA', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('EH732KV', 'AUTORADIO', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('EH732KV', 'ALZACRISTALLI', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('EH732KV', 'CHIUSURA_CENTR', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('EH732KV', 'VOCAL_COMMANDS', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('EH732KV', 'AUDIO_SUPPORT', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('EH732KV', 'VOLANTE_SMART', NULL, NULL);
UPDATE AutovetturaRegistrata SET comfort = GetComfortAuto(NumTarga) WHERE NumTarga = 'EH732KV';
--
call RegistraAutovettura('AB123CD', 'FZZDRD98Z11I499Z', 5, 1600, 2010, 'CITROEN', 'C3 PICASSO', NULL, 190, 80, 'DIESEL', 0.05, 0.05, 6.5, 7.0, 7.5);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('AB123CD', 'CLIMA', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('AB123CD', 'AIRBAG', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('AB123CD', 'SEDILI_SMART', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('AB123CD', 'SERVOSTERZO', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('AB123CD', 'FENDINEBBIA', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('AB123CD', 'AUTORADIO', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('AB123CD', 'LIVING_HOME', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('AB123CD', 'ALZACRISTALLI', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('AB123CD', 'SPECCHIETTI_AUTO', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('AB123CD', 'CHIUSURA_CENTR', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('AB123CD', 'BACK_SENSORS', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('AB123CD', 'RAIN_SENSORS', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('AB123CD', 'CERCHI_LEGA', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('AB123CD', 'VOCAL_COMMANDS', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('AB123CD', 'AUDIO_SUPPORT', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('AB123CD', 'VOLANTE_SMART', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('AB123CD', 'CRUISE_CONTROL', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('AB123CD', 'SPEED_LIMIT', NULL, NULL);
UPDATE AutovetturaRegistrata SET comfort = GetComfortAuto(NumTarga) WHERE NumTarga = 'AB123CD';
--
call RegistraAutovettura('EF456GH', 'FZZDRD98Z11I499Z', 4, 1000, 2006, 'RENAULT', 'TWINGO', NULL, 140, 50, 'BENZINA', 0.03, 0.03, 9.0, 9.5, 10);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('EF456GH', 'CLIMA', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('EF456GH', 'AIRBAG', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('EF456GH', 'SEDILI_SMART', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('EF456GH', 'SERVOSTERZO', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('EF456GH', 'FENDINEBBIA', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('EF456GH', 'AUTORADIO', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('EF456GH', 'ALZACRISTALLI', NULL, NULL);
INSERT INTO smartmobility.OptionalAuto (NumTarga, CodOptional, Valore, UnitaMisura) VALUES ('EF456GH', 'CHIUSURA_CENTR', NULL, NULL);
UPDATE AutovetturaRegistrata SET comfort = GetComfortAuto(NumTarga) WHERE NumTarga = 'EF456GH';

/*-- COSTI AUTOVETTURA
set @Targa = NULL;
select A.*,
       AR.CodFiscale, AR.NumPosti, AR.Cilindrata, AR.AnnoImmatricolazione, AR.Comfort, AR.VelocitaMax, AR.CapacitaSerbatoio, AR.TipoAlimentazione,
       CA.NUmPasseggeri, CA.CostoOperativo, CA.CostoUsura, CA.ConsumoU, CA.ConsumoXU, CA.ConsumoM
  from Autovettura A
       left outer join AutovetturaRegistrata AR on (AR.NumTarga = A.NumTarga)
       left outer join CostoAutovettura CA on (CA.NumTarga = AR.NumTarga)
where A.NumTarga = coalesce(@Targa, A.NumTarga);
-- OPTIONAL AUTOVETTURA
set @Targa = 'EH732KV';
select A.*,
       AR.CodFiscale, AR.NumPosti, AR.Cilindrata, AR.AnnoImmatricolazione, AR.Comfort, AR.VelocitaMax, AR.CapacitaSerbatoio, AR.TipoAlimentazione,
       OA.CodOptional, O.Descrizione, OA.Valore, OA.UnitaMisura
  from Autovettura A
       left outer join AutovetturaRegistrata AR on (AR.NumTarga = A.NumTarga)
       left outer join OptionalAuto OA on (OA.NumTarga = AR.NumTarga)
       left outer join Optional O on (O.CodOptional = OA.CodOptional)
where A.NumTarga = @Targa;
--
call EliminaAutovettura('DL871EZ');*/
--
/***********************************************************************
** smartmobility.AspettoValutabili
***********************************************************************/
INSERT INTO smartmobility.AspettoValutabile (CodAspettoValutabile, Descrizione) VALUES (NewProgressivo('ASP', 'AspettoValutabile'), 'Giudizio sulla persona');
INSERT INTO smartmobility.AspettoValutabile (CodAspettoValutabile, Descrizione) VALUES (NewProgressivo('ASP', 'AspettoValutabile'), 'Comportamento della persona');
INSERT INTO smartmobility.AspettoValutabile (CodAspettoValutabile, Descrizione) VALUES (NewProgressivo('ASP', 'AspettoValutabile'), 'Serietà della persona');
INSERT INTO smartmobility.AspettoValutabile (CodAspettoValutabile, Descrizione) VALUES (NewProgressivo('ASP', 'AspettoValutabile'), 'Piacere di viaggio');
INSERT INTO smartmobility.AspettoValutabile (CodAspettoValutabile, Descrizione) VALUES (NewProgressivo('ASP', 'AspettoValutabile'), 'Rispetto degli orari');
INSERT INTO smartmobility.AspettoValutabile (CodAspettoValutabile, Descrizione) VALUES (NewProgressivo('ASP', 'AspettoValutabile'), 'Rispetto limiti di velocità');

-- select * from AspettoValutabile;

/***********************************************************************
** smartmobility.Registrazione Autovettura per CarSharing
***********************************************************************/
call RegistraAutovetturaCS('EF456GH', 'DISPONIBILE');
call InsUpdFruibilita('EF456GH', 1, 'PER', 'SAB', NULL, NULL, '8:00', '24:00');
call InsUpdFruibilita('EF456GH', 2, 'PER', 'DOM', NULL, NULL, NULL, NULL);
call InsUpdFruibilita('EF456GH', 3, 'PER', 'LUN', NULL, NULL, '00:00', '22:00');
call RegistraAutovetturaCS('DL871EZ', 'DISPONIBILE');
call InsUpdFruibilita('DL871EZ', 1, 'FAS', NULL, '2018-10-01', '2018-10-31', '8:00', '22:00');

-- select isAutovetturaCSFruibile('DL871EZ', '2018-10-30');

/*select CS.*,
       F.ProgrFascia, F.TipoFruibilita, F.NomeGiorno, F.GiornoIni, F.OraIni, F.GiornoFin, F.OraFin
  from AutoCarSharing CS
       left outer join Fruibilita F on (F.NumTarga = CS.NumTarga)
;*/

/***********************************************************************
** smartmobility.Inserimento Prenotazione per CarSharing
***********************************************************************/
-- call MostraDisponibilitaAutoCS('DL871EZ', '2018-10-01', '2018-10-31');
select ChkInsPrenotazioneCS('SMNMNC67P49E463Y', 'DL871EZ', '2018-10-05', '2018-10-15');
call ValutaPrenotazioneCS('PRN000000001', 'ACCETTATA');
-- call MostraDisponibilitaAutoCS('DL871EZ', '2018-09-01', '2018-10-31');

/*select *
  from PrenotazioneCS
 where CodPrenotazione = 'PRN000000001'
;*/

/***********************************************************************
** smartmobility.CambioStatoPrenotazioni
***********************************************************************/
-- call smartmobility.ValutaPrenotazioneCS ('PCS000000001', 'ACCETTATA');

/***********************************************************************
** smartmobility.ConsegnaAutovetturaCS
***********************************************************************/
select smartmobility.ChkInsNoleggio ('PRN000000001', 65, 120000);

/***********************************************************************
** smartmobility.TracciamentoCarSharing
***********************************************************************/
select smartmobility.Tracciamento('DL871EZ', '2018-10-15 12:00:00', 'ACCENSIONE', 44.164458, 9.860873, 0.066, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'PIAZZA', 'GIUSEPPE GARIBALDI', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('DL871EZ', '2018-10-15 12:00:05', 'PERIODICO', 44.164655, 9.861265, 0.038, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'PIAZZA', 'GIUSEPPE GARIBALDI', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('DL871EZ', '2018-10-15 12:00:10', 'PERIODICO', 44.164788, 9.861546, 0.010, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'PIAZZA', 'GIUSEPPE GARIBALDI', NULL, NULL, NULL, NULL);
--
select smartmobility.Tracciamento('DL871EZ', '2018-10-15 12:00:15', 'PERIODICO', 44.164615, 9.861705, 0.715, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('DL871EZ', '2018-10-15 12:00:20', 'PERIODICO', 44.164640, 9.861688, 0.687, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('DL871EZ', '2018-10-15 12:00:25', 'PERIODICO', 44.164219, 9.861941, 0.645, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('DL871EZ', '2018-10-15 12:00:30', 'PERIODICO', 44.163830, 9.862175, 0.589, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('DL871EZ', '2018-10-15 12:00:35', 'PERIODICO', 44.163232, 9.862539, 0.526, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('DL871EZ', '2018-10-15 12:00:40', 'PERIODICO', 44.162717, 9.862851, 0.463, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('DL871EZ', '2018-10-15 12:00:45', 'PERIODICO', 44.162196, 9.863163, 0.400, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('DL871EZ', '2018-10-15 12:00:50', 'PERIODICO', 44.161677, 9.863480, 0.337, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('DL871EZ', '2018-10-15 12:00:55', 'PERIODICO', 44.161389, 9.863652, 0.302, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('DL871EZ', '2018-10-15 12:01:00', 'PERIODICO', 44.161297, 9.863705, 0.291, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
--
select smartmobility.Tracciamento('DL871EZ', '2018-10-15 12:01:05', 'PERIODICO', 44.161237, 9.863547, 0.013, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'DEL PIANO', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('DL871EZ', '2018-10-15 12:01:10', 'PERIODICO', 44.161102, 9.863166, 0.047, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'DEL PIANO', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('DL871EZ', '2018-10-15 12:01:15', 'PERIODICO', 44.160941, 9.862703, 0.088, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'DEL PIANO', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('DL871EZ', '2018-10-15 12:01:20', 'PERIODICO', 44.160779, 9.862240, 0.129, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'DEL PIANO', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('DL871EZ', '2018-10-15 12:01:25', 'SPEGNIMENTO', 44.160668, 9.861921, 0.160, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'DEL PIANO', NULL, NULL, NULL, NULL);

/***********************************************************************
** smartmobility.RionsegnaAutovetturaCS
***********************************************************************/
call smartmobility.ConsegnaNoleggio ('PRN000000001', 64, 121000);

/***********************************************************************
** smartmobility.Registrazione Valutazione
***********************************************************************/
select RegistraValutazione('SMNMNC67P49E463Y', 'F', 'CRMNNN61H25F158H', 'P', 'TGT000000001', 'CAR_SHARING', 'Bello!');
call InsUpdValutazioneAspetto('VAL000000001', 'ASP000000001', 4); -- Giudizio sulla persona
call InsUpdValutazioneAspetto('VAL000000001', 'ASP000000002', 4.1); -- Comportamento della persona
call InsUpdValutazioneAspetto('VAL000000001', 'ASP000000003', 4.2); -- Serietà della persona
call InsUpdValutazioneAspetto('VAL000000001', 'ASP000000005', 4.1); -- Rispetto degli orari

/*select V.*,
       VA.CodAspettoValutabile, AV.Descrizione, VA.Voto
  from Valutazione V
       inner join ValutazioneAspetti VA on (VA.CodValutazione = V.CodValutazione)
       inner join AspettoValutabile AV on (AV.CodAspettoValutabile = VA.CodAspettoValutabile)
;*/

/***********************************************************************
** smartmobility.Registrazione Autovettura per CarPooling e creazione Pool
***********************************************************************/
call RegistraAutovetturaCP('EF456GH');
select smartmobility.ChkInsPool('EF456GH', 
								InsTragittoProgrammato(ChkInsPosizione(44.164458, 9.860873, NULL, NULL, NULL),
													   ChkInsPosizione(44.160668, 9.861921, NULL, NULL, NULL),
                                                       NULL,
                                                       NULL), 
								NULL,
                                '2018-12-15',
                                '12:00:00',
                                '2018-12-15',
                                GetFlessibilita(3),
                                48,
                                2,
                                NULL,
                                GetPostiIniziali('EF456GH')
                                );
insert into smartmobility.trattatragittoprg (CodTragitto, CodTratta) values ('TGT000000002', 'TRT000000015');
insert into smartmobility.trattatragittoprg (CodTragitto, CodTratta) values ('TGT000000002', 'TRT000000016');
insert into smartmobility.trattatragittoprg (CodTragitto, CodTratta) values ('TGT000000002', 'TRT000000017');
call GetLunghezzaTrgPrg('TGT000000002');
call AggiornaStatoTragittoPrg('TGT000000002');
call AggiornaCostoPool('POL000000001', 1.6, NULL);
select smartmobility.ChkInsPrenotazioneCP('POL000000001', 'CRMDRD98M24F463J');
insert into smartmobility.variazionecp (CodVariazione, CodPrenotazione) values (NewProgressivo('VAR', 'Variazione'), 'PRN000000002');
insert into smartmobility.variazionetrattacp (CodVariazione, Operazione, CodTratta) values ('VAR000000001', 'E', ChkInsTratta('STR000000001', 1, 0.754, 44.1646000, 9.8617000, 44.1613000, 9.8637000));
insert into smartmobility.variazionetrattacp (CodVariazione, Operazione, CodTratta) values ('VAR000000001', 'I', ChkInsTratta('STR000000001', 1, 0.754, 44.1591500, 9.8661000, 44.160460, 9.864212));
insert into smartmobility.variazionetrattacp (CodVariazione, Operazione, CodTratta) values ('VAR000000001', 'I', ChkInsTratta('STR000000006', 1, 0.160, 44.1599500, 9.8646500, 44.1591500, 9.8639000));
insert into smartmobility.variazionetrattacp (CodVariazione, Operazione, CodTratta) values ('VAR000000001', 'I', ChkInsTratta('STR000000006', 1, 0.160, 44.1591500, 9.8639000, 44.1599500, 9.8646500));
insert into smartmobility.variazionetrattacp (CodVariazione, Operazione, CodTratta) values ('VAR000000001', 'I', ChkInsTratta('STR000000001', 1, 0.235, 44.160460, 9.864212, 44.161275, 9.863729));
call ValutaPrenotazioneCP('PRN000000002', 'RIFIUTATA');
select smartmobility.ChkInsPrenotazioneCP('POL000000001', 'LSAMCL63L47C773X');
call ValutaPrenotazioneCP('PRN000000003', 'ACCETTATA');
call AggiornaCostoPool('POL000000001', 1.6, 'ACCETTAZIONE');

/***********************************************************************
** smartmobility.TracciamentoCarPooling
***********************************************************************/
select smartmobility.Tracciamento('EF456GH', '2018-12-15 14:00:00', 'ACCENSIONE', 44.164458, 9.860873, 0.066, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'PIAZZA', 'GIUSEPPE GARIBALDI', NULL, NULL, NULL, NULL);
update pool
   set CodTragittoTrc = 'TGT000000003'
 where CodPool = 'POL000000001';  
select smartmobility.Tracciamento('EF456GH', '2018-12-15 14:00:05', 'PERIODICO', 44.164788, 9.861546, 0.010, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'PIAZZA', 'GIUSEPPE GARIBALDI', NULL, NULL, NULL, NULL);
--
select smartmobility.Tracciamento('EF456GH', '2018-12-15 14:00:10', 'PERIODICO', 44.164615, 9.861705, 0.715, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EF456GH', '2018-12-15 14:00:15', 'PERIODICO', 44.164640, 9.861688, 0.687, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EF456GH', '2018-12-15 14:00:20', 'PERIODICO', 44.164219, 9.861941, 0.645, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EF456GH', '2018-12-15 14:00:25', 'PERIODICO', 44.163830, 9.862175, 0.589, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EF456GH', '2018-12-15 14:00:30', 'PERIODICO', 44.163232, 9.862539, 0.526, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EF456GH', '2018-12-15 14:00:35', 'PERIODICO', 44.162717, 9.862851, 0.463, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EF456GH', '2018-12-15 14:00:40', 'PERIODICO', 44.162196, 9.863163, 0.400, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EF456GH', '2018-12-15 14:00:45', 'PERIODICO', 44.161677, 9.863480, 0.337, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EF456GH', '2018-12-15 14:00:50', 'PERIODICO', 44.161297, 9.863705, 0.291, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
--
select smartmobility.Tracciamento('EF456GH', '2018-12-15 14:00:55', 'PERIODICO', 44.161237, 9.863547, 0.013, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'DEL PIANO', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EF456GH', '2018-12-15 14:01:00', 'PERIODICO', 44.161102, 9.863166, 0.047, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'DEL PIANO', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EF456GH', '2018-12-15 14:01:05', 'PERIODICO', 44.160941, 9.862703, 0.088, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'DEL PIANO', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EF456GH', '2018-12-15 14:01:10', 'SPEGNIMENTO', 44.160668, 9.861921, 0.160, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'DEL PIANO', NULL, NULL, NULL, NULL);

/***********************************************************************
** smartmobility.Registrazione Valutazione Car Pooling
***********************************************************************/
select RegistraValutazione('LSAMCL63L47C773X', 'F', 'FZZDRD98Z11I499Z', 'P', 'TGT000000003', 'CAR_POOLING', 'Non male');
call InsUpdValutazioneAspetto('VAL000000002', 'ASP000000001', 4);
call InsUpdValutazioneAspetto('VAL000000002', 'ASP000000002', 4);
call InsUpdValutazioneAspetto('VAL000000002', 'ASP000000003', 3);
call InsUpdValutazioneAspetto('VAL000000002', 'ASP000000004', 3);
call InsUpdValutazioneAspetto('VAL000000002', 'ASP000000005', 4);
call InsUpdValutazioneAspetto('VAL000000002', 'ASP000000006', 5);
select RegistraValutazione('FZZDRD98Z11I499Z', 'P', 'LSAMCL63L47C773X', 'F', 'TGT000000003', 'CAR_POOLING', 'Soddisfatto');
call InsUpdValutazioneAspetto('VAL000000003', 'ASP000000001', 5);
call InsUpdValutazioneAspetto('VAL000000003', 'ASP000000002', 4);
call InsUpdValutazioneAspetto('VAL000000003', 'ASP000000003', 4);
call InsUpdValutazioneAspetto('VAL000000003', 'ASP000000004', 4);
call InsUpdValutazioneAspetto('VAL000000003', 'ASP000000005', 3);

/***********************************************************************
** smartmobility.Registrazione Autovettura per RideSharingOnDemand e creazione Sharing
***********************************************************************/
call RegistraAutovetturaRSoD('EH732KV');
select smartmobility.ChkInsSharing('EH732KV', 
								   InsTragittoProgrammato(ChkInsPosizione(44.164458, 9.860873, NULL, NULL, NULL),
													      ChkInsPosizione(44.160668, 9.861921, NULL, NULL, NULL),
                                                          NULL,
                                                          NULL), 
								   '2018-12-14',
                                   '12:30:00'
                                   );
insert into smartmobility.trattatragittoprg (CodTragitto, CodTratta) values ('TGT000000004', 'TRT000000015');
insert into smartmobility.trattatragittoprg (CodTragitto, CodTratta) values ('TGT000000004', 'TRT000000016');
insert into smartmobility.trattatragittoprg (CodTragitto, CodTratta) values ('TGT000000004', 'TRT000000017');
call GetLunghezzaTrgPrg('TGT000000004');
call AggiornaStatoTragittoPrg('TGT000000004');

/***********************************************************************
** smartmobility.TracciamentoCarPooling con una chiamata accettata, lungo il tragitto
***********************************************************************/
select smartmobility.InsChiamata('CRMDRD98M24F463J', 'SRG000000001', 
								 ChkInsPosizione(44.164458, 9.860873, NULL, NULL, NULL),
                                 ChkInsPosizione(44.160668, 9.861921, NULL, NULL, NULL),
                                 '2018-12-14 12:58:26',
                                 'PENDING',
                                 null
                                 );
call ValutaChiamata('CMT000000001', 'ACCEPTED', '2018-12-14 12:58:43');
insert into Corsa (CodChiamata, CodTragittoTrc, DataOraInizioCorsa, DataOraFineCorsa) VALUES ('CMT000000001', null, '2018-12-14 12:59:30', null);
select smartmobility.Tracciamento('EH732KV', '2018-12-14 13:00:00', 'ACCENSIONE', 44.164458, 9.860873, 0.066, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'PIAZZA', 'GIUSEPPE GARIBALDI', NULL, NULL, NULL, NULL);
update Corsa
   set CodTragittoTrc = 'TGT000000005'
 where CodChiamata = 'CMT000000001';
select smartmobility.Tracciamento('EH732KV', '2018-12-14 13:00:05', 'PERIODICO', 44.164655, 9.861265, 0.038, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'PIAZZA', 'GIUSEPPE GARIBALDI', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EH732KV', '2018-12-14 13:00:10', 'PERIODICO', 44.164788, 9.861546, 0.010, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'PIAZZA', 'GIUSEPPE GARIBALDI', NULL, NULL, NULL, NULL);
--
select smartmobility.Tracciamento('EH732KV', '2018-12-14 13:00:15', 'PERIODICO', 44.164615, 9.861705, 0.715, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EH732KV', '2018-12-14 13:00:20', 'PERIODICO', 44.164640, 9.861688, 0.687, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EH732KV', '2018-12-14 13:00:25', 'PERIODICO', 44.164640, 9.861688, 0.687, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EH732KV', '2018-12-14 13:00:30', 'PERIODICO', 44.164640, 9.861688, 0.687, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EH732KV', '2018-12-14 13:00:35', 'PERIODICO', 44.164640, 9.861688, 0.687, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EH732KV', '2018-12-14 13:00:40', 'PERIODICO', 44.164640, 9.861688, 0.687, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EH732KV', '2018-12-14 13:00:45', 'PERIODICO', 44.164219, 9.861941, 0.645, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EH732KV', '2018-12-14 13:00:50', 'PERIODICO', 44.163830, 9.862175, 0.589, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EH732KV', '2018-12-14 13:00:55', 'PERIODICO', 44.163232, 9.862539, 0.526, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EH732KV', '2018-12-14 13:01:00', 'PERIODICO', 44.162717, 9.862851, 0.463, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EH732KV', '2018-12-14 13:01:05', 'PERIODICO', 44.162196, 9.863163, 0.400, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EH732KV', '2018-12-14 13:01:10', 'PERIODICO', 44.161677, 9.863480, 0.337, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EH732KV', '2018-12-14 13:01:15', 'PERIODICO', 44.161389, 9.863652, 0.302, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EH732KV', '2018-12-14 13:01:20', 'PERIODICO', 44.161297, 9.863705, 0.291, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'BRIGATE PARTIGIANE', NULL, NULL, NULL, NULL);
--
select smartmobility.Tracciamento('EH732KV', '2018-12-14 13:01:25', 'PERIODICO', 44.161237, 9.863547, 0.013, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'DEL PIANO', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EH732KV', '2018-12-14 13:01:30', 'PERIODICO', 44.161102, 9.863166, 0.047, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'DEL PIANO', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EH732KV', '2018-12-14 13:01:35', 'PERIODICO', 44.160941, 9.862703, 0.088, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'DEL PIANO', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EH732KV', '2018-12-14 13:01:40', 'PERIODICO', 44.160779, 9.862240, 0.129, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'DEL PIANO', NULL, NULL, NULL, NULL);
select smartmobility.Tracciamento('EH732KV', '2018-12-14 13:01:45', 'SPEGNIMENTO', 44.160668, 9.861921, 0.160, 'IT', 'LIG', 'SP', 'FOLLO', 1, 'VIA', 'DEL PIANO', NULL, NULL, NULL, NULL);

/***********************************************************************
** smartmobility.Registrazione Valutazione Ride Sharing On Demand
***********************************************************************/
select RegistraValutazione('CRMDRD98M24F463J', 'F', 'LSAMCL63L47C773X', 'P', 'TGT000000005', 'RIDE_SHARING', 'Grazie mamma');
call InsUpdValutazioneAspetto('VAL000000004', 'ASP000000001', 5);
call InsUpdValutazioneAspetto('VAL000000004', 'ASP000000002', 5);
call InsUpdValutazioneAspetto('VAL000000004', 'ASP000000003', 3);
call InsUpdValutazioneAspetto('VAL000000004', 'ASP000000004', 4);
call InsUpdValutazioneAspetto('VAL000000004', 'ASP000000005', 4);
call InsUpdValutazioneAspetto('VAL000000004', 'ASP000000006', 5);
select RegistraValutazione('LSAMCL63L47C773X', 'P', 'CRMDRD98M24F463J', 'F', 'TGT000000005', 'RIDE_SHARING', 'Prego figlio');
call InsUpdValutazioneAspetto('VAL000000005', 'ASP000000001', 4);
call InsUpdValutazioneAspetto('VAL000000005', 'ASP000000002', 3);
call InsUpdValutazioneAspetto('VAL000000005', 'ASP000000003', 3);
call InsUpdValutazioneAspetto('VAL000000005', 'ASP000000004', 5);
call InsUpdValutazioneAspetto('VAL000000005', 'ASP000000005', 3);

/***********************************************************************
** smartmobility.Sinistri
***********************************************************************/
-- select smartmobility.ChkInsSinistro(CodNoleggio, DataOraSinistro, CodPosizione, Dinamica);
-- select smartmobility.InsAutoCoinvolta(CodSinistro, NumTarga, CasaProduttrice. Modello);

