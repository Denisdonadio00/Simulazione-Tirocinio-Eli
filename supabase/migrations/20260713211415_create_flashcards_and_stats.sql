
/*
# Ripasso Logopedia — schema iniziale

## Tabelle nuove

### flashcards
Ogni carta flashcard con il suo stato SRS (spaced repetition).
- id (uuid, PK)
- cat (text) — categoria/argomento
- front (text) — fronte della carta (domanda)
- back (text) — retro della carta (risposta)
- custom (boolean) — true se aggiunta dall'utente, false se da seed
- ef (float) — fattore di facilità SRS (default 2.5)
- interval (int) — intervallo in giorni
- reps (int) — numero di ripetizioni riuscite
- lapses (int) — numero di errori
- due (bigint) — timestamp ms della prossima scadenza
- created_at (timestamptz)

### study_stats
Statistiche di studio (streak, log giornaliero dei ripassi).
- id (uuid, PK)
- streak (int) — giorni consecutivi di studio
- last_study_date (text) — data dell'ultimo studio (YYYY-MM-DD)
- review_log (jsonb) — oggetto { "YYYY-MM-DD": count }
- created_at (timestamptz)
- updated_at (timestamptz)

## Sicurezza
- RLS abilitato su entrambe le tabelle
- Policy anon + authenticated (app senza login)
*/

CREATE TABLE IF NOT EXISTS flashcards (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  cat text NOT NULL,
  front text NOT NULL,
  back text NOT NULL,
  custom boolean NOT NULL DEFAULT false,
  ef float NOT NULL DEFAULT 2.5,
  interval integer NOT NULL DEFAULT 0,
  reps integer NOT NULL DEFAULT 0,
  lapses integer NOT NULL DEFAULT 0,
  due bigint NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE flashcards ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_select_flashcards" ON flashcards;
CREATE POLICY "anon_select_flashcards" ON flashcards FOR SELECT
  TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "anon_insert_flashcards" ON flashcards;
CREATE POLICY "anon_insert_flashcards" ON flashcards FOR INSERT
  TO anon, authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "anon_update_flashcards" ON flashcards;
CREATE POLICY "anon_update_flashcards" ON flashcards FOR UPDATE
  TO anon, authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_delete_flashcards" ON flashcards;
CREATE POLICY "anon_delete_flashcards" ON flashcards FOR DELETE
  TO anon, authenticated USING (true);

CREATE TABLE IF NOT EXISTS study_stats (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  streak integer NOT NULL DEFAULT 0,
  last_study_date text,
  review_log jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE study_stats ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_select_study_stats" ON study_stats;
CREATE POLICY "anon_select_study_stats" ON study_stats FOR SELECT
  TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "anon_insert_study_stats" ON study_stats;
CREATE POLICY "anon_insert_study_stats" ON study_stats FOR INSERT
  TO anon, authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "anon_update_study_stats" ON study_stats;
CREATE POLICY "anon_update_study_stats" ON study_stats FOR UPDATE
  TO anon, authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_delete_study_stats" ON study_stats;
CREATE POLICY "anon_delete_study_stats" ON study_stats FOR DELETE
  TO anon, authenticated USING (true);

-- Aggiungi device_id a flashcards
ALTER TABLE flashcards ADD COLUMN IF NOT EXISTS device_id text;
CREATE INDEX IF NOT EXISTS idx_flashcards_device_id ON flashcards(device_id);

-- Aggiungi device_id a study_stats
ALTER TABLE study_stats ADD COLUMN IF NOT EXISTS device_id text;
CREATE INDEX IF NOT EXISTS idx_study_stats_device_id ON study_stats(device_id);

-- Rendi device_id obbligatorio e con default (così le righe vecchie avranno un device_id)
UPDATE flashcards SET device_id = 'legacy' WHERE device_id IS NULL;
ALTER TABLE flashcards ALTER COLUMN device_id SET NOT NULL;
ALTER TABLE flashcards ALTER COLUMN device_id SET DEFAULT 'legacy';

UPDATE study_stats SET device_id = 'legacy' WHERE device_id IS NULL;
ALTER TABLE study_stats ALTER COLUMN device_id SET NOT NULL;
ALTER TABLE study_stats ALTER COLUMN device_id SET DEFAULT 'legacy';