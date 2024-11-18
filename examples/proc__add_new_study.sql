-- correct call
CALL patient.add_new_study(1, '2020-01-01', 2.5, ARRAY['2020-01-01'::date, '2020-02-01'::date]);

[2024-11-16 15:58:09] completed in 31 ms

-- incorrect data
CALL patient.add_new_study(NULL, '2020-01-01', 2.5, ARRAY['2020-01-01'::date, '2020-02-01'::date]);

[2024-11-16 15:58:13] [P0001] ERROR: patient_id cannot be empty

CALL patient.add_new_study(1, NULL, 2.5, ARRAY['2020-01-01'::date, '2020-02-01'::date]);

[2024-11-16 15:58:18] [P0001] ERROR: date cannot be empty

CALL patient.add_new_study(1, '2020-01-01', -1, ARRAY['2020-01-01'::date, '2020-02-01'::date]);

[2024-11-16 15:58:47] [P0001] ERROR: edss must be a number between 0 and 10

CALL patient.add_new_study(1, '2020-01-01', 1, ARRAY['2020-01-01', '2020-02-01']);

[2024-11-16 15:58:56] [42883] ERROR: procedure patient.add_new_study(integer, unknown, integer, text[]) does not exist