/*
# Reset flashcards

Il problema "tutto già ripassato per oggi" appena apri l'app dipende dal
fatto che la tabella `flashcards` contiene già righe da test precedenti,
con `due` spinto in avanti (a volte anche di mesi). L'app carica sempre
quelle righe da Supabase e ignora il SEED nel codice se la tabella non è
vuota — quindi il nuovo mazzo di carte non viene mai caricato finché non
si svuota la tabella.

Questa migration cancella tutte le righe: al prossimo avvio l'app la
troverà vuota e riseminerà da zero con il nuovo contenuto e `due = adesso`
per ogni carta, cioè tutte "da ripassare" davvero.

Non tocca `study_stats` (streak e log giornaliero restano invariati).
*/

TRUNCATE TABLE flashcards;
