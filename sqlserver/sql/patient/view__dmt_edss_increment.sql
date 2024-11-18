IF OBJECT_ID('patient.dmt_edss_increment', 'V') IS NOT NULL
    DROP VIEW patient.dmt_edss_increment;
GO

CREATE VIEW patient.dmt_edss_increment AS
SELECT
    AVG(last_study.edss - first_study.edss) AS edss_increment,
    dmt.name AS dmt_name
FROM patient.treatment_history th
         CROSS APPLY (
    SELECT edss
    FROM patient.study s
    WHERE s.treatment_history_id = th.id AND s.year_of_treatment = 0
) first_study
         CROSS APPLY (
    SELECT TOP 1 edss
    FROM patient.study s
    WHERE s.treatment_history_id = th.id
    ORDER BY s.year_of_treatment DESC
               ) last_study
         JOIN patient.dmt_type dmt ON th.dmt_type_id = dmt.id
GROUP BY dmt.name;
GO