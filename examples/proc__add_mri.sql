-- correct call
CALL patient.add_mri(1, '2020-01-01', 'file_address_uri');

[2024-11-16 15:59:08] completed in 20 ms

-- incorrect data
CALL patient.add_mri(NULL, '2020-01-01', 'file_address_uri');

[2024-11-16 15:59:11] [P0001] ERROR: study_id cannot be empty

CALL patient.add_mri(1, NULL, 'file_address_uri');

[2024-11-16 15:59:13] [P0001] ERROR: date cannot be empty

CALL patient.add_mri(1, '2020-01-01', NULL);

[2024-11-16 15:59:39] [P0001] ERROR: file_name cannot be empty

CALL patient.add_mri(1, '2020-01-01', '');

[2024-11-16 15:59:42] [P0001] ERROR: file_name cannot be empty