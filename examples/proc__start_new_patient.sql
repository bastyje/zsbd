-- correct call
CALL patient.start_new_patient(
    'pseudonym',
    25,
    'male',
    '2020-01-01',
    '2020-01-01',
    1,
    2.5,
    'comments',
    'reason',
    2.5,
    1,
    1,
    '2020-01-01'
);

[2024-11-16 15:57:44] completed in 22 ms

-- incorrect data
CALL patient.start_new_patient(
    NULL,
    25,
    'asd',
    '2020-01-01',
    '2020-01-01',
    1,
    2.5,
    'comments',
    'reason',
    2.5,
    1,
    1,
    '2020-01-01'
);

[2024-11-16 15:57:50] [P0001] ERROR: pseudonym_of_patient cannot be empty

CALL patient.start_new_patient(
    'pseudonym',
    -1,
    'male',
    '2020-01-01',
    '2020-01-01',
    1,
    2.5,
    'comments',
    'reason',
    2.5,
    1,
    1,
    '2020-01-01'
);

[2024-11-16 15:57:56] [P0001] ERROR: age_of_patient must be a positive number

CALL patient.start_new_patient(
    'pseudonym',
    25,
    'female',
    '2021-01-01',
    '2020-01-01',
    1,
    2.5,
    'comments',
    'reason',
    2.5,
    1,
    1,
    '2020-01-01'
);

[2024-11-16 15:58:01] [P0001] ERROR: diagnosis_date cannot be after first_treatment_date