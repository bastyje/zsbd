-- correct call
CALL patient.add_brain_volume(1, 0.5, 'cerebrum');

[2024-11-16 15:52:09] completed in 20 ms

-- incorrect data
CALL patient.add_brain_volume(NULL, 0.5, 'cerebrum');

[2024-11-16 15:59:53] [P0001] ERROR: study_id cannot be empty

CALL patient.add_brain_volume(1, NULL, 'cerebrum');

[2024-11-16 15:59:56] [P0001] ERROR: volume cannot be empty

CALL patient.add_brain_volume(1, 0.5, NULL);

[2024-11-16 15:59:58] [P0001] ERROR: part_of_brain cannot be empty

CALL patient.add_brain_volume(1, 0.5, '');

[2024-11-16 16:00:00] [22P02] ERROR: invalid input value for enum patient.part_of_brain: ""