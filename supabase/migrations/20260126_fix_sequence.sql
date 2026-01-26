-- Fix Primary Key Sequence Sync Issue
-- This resets the auto-increment counter to the correct next value.

SELECT setval(pg_get_serial_sequence('guides', 'id'), COALESCE(MAX(id), 1) + 1, false) FROM guides;

-- Also do it for other tables just in case manual inserts happened there too
SELECT setval(pg_get_serial_sequence('guide_steps', 'id'), COALESCE(MAX(id), 1) + 1, false) FROM guide_steps;
SELECT setval(pg_get_serial_sequence('guide_sections', 'id'), COALESCE(MAX(id), 1) + 1, false) FROM guide_sections;
