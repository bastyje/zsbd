IF OBJECT_ID('patient.patient_atrophy', 'V') IS NOT NULL
    DROP VIEW patient.patient_atrophy;
GO

CREATE VIEW patient.patient_atrophy AS
SELECT
    bvc.patient_id,
    (bvc.volume_change) / bvc.previous_volume AS atrophy,
    bvc.previous_year_of_treatment,
    bvc.next_year_of_treatment
FROM patient.brain_volume_changes bvc;
GO