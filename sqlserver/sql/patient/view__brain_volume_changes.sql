IF OBJECT_ID('patient.brain_volume_changes', 'V') IS NOT NULL
    DROP VIEW patient.brain_volume_changes;
GO

CREATE VIEW patient.brain_volume_changes AS
SELECT
    p.id AS patient_id,
    p.pseudonym,
    m1.id AS previous_mri_id,
    m1.date AS previous_mri_date,
    s1.year_of_treatment AS previous_year_of_treatment,
    SUM(bv1.volume) AS previous_volume,
    m2.id AS next_mri_id,
    m2.date AS next_mri_date,
    s2.year_of_treatment AS next_year_of_treatment,
    SUM(bv2.volume) AS next_volume,
    SUM(bv2.volume) - SUM(bv1.volume) AS volume_change
FROM patient.clinical_info ci
JOIN patient.treatment_history th ON ci.id = th.clinical_info_id
JOIN patient.study s1 ON th.id = s1.treatment_history_id
JOIN patient.mri m1 ON s1.id = m1.study_id
JOIN patient.brain_volume bv1 ON m1.id = bv1.mri_id
JOIN patient.study s2 ON th.id = s2.treatment_history_id AND s2.year_of_treatment = s1.year_of_treatment + 1
JOIN patient.mri m2 ON s2.id = m2.study_id
JOIN patient.brain_volume bv2 ON m2.id = bv2.mri_id
JOIN patient.patient p ON ci.patient_id = p.id
GROUP BY p.id, p.pseudonym, m1.id, m1.date, m2.id, m2.date, s1.year_of_treatment, s2.year_of_treatment;
GO