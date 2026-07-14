/* One anonymous browser profile has one statistics record. */

DELETE FROM study_stats a
USING study_stats b
WHERE a.device_id = b.device_id
  AND a.created_at > b.created_at;

CREATE UNIQUE INDEX IF NOT EXISTS study_stats_one_row_per_device
  ON study_stats (device_id);
