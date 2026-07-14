/*
# Reset flashcards (mazzo ridotto al solo materiale di tirocinio)

Il mazzo è stato ridotto da 129 a 19 carte: ora contiene SOLO le domande
del quaderno di tirocinio (quiz 1-18, esclusa la 12 perché priva di
risposta nel testo fornito), niente più contenuto generico.

Questa migration svuota di nuovo la tabella `flashcards` in produzione
(la precedente TRUNCATE è già stata eseguita e la tabella si era
ripopolata con le 129 carte vecchie). Al prossimo avvio l'app la troverà
vuota e riseminerà da zero con le 19 carte nuove.

Non tocca `study_stats`.
*/

TRUNCATE TABLE flashcards;
