DROP VIEW IF EXISTS patient.dmt_edss_increment;
CREATE VIEW patient.dmt_edss_increment AS
    SELECT
        AVG(last_study.edss - first_study.edss) AS edss_increment,
        dmt.name AS dmt_name
    FROM patient.treatment_history th
    JOIN LATERAL (
        SELECT edss
        FROM patient.study s
        WHERE s.treatment_history_id = th.id AND s.year_of_treatment = 0
    ) first_study ON true
    JOIN LATERAL (
        SELECT edss
        FROM patient.study s
        WHERE s.treatment_history_id = th.id
        ORDER BY s.year_of_treatment DESC
        LIMIT 1
    ) last_study ON true
    JOIN patient.dmt_type dmt ON th.dmt_type_id = dmt.id
    GROUP BY dmt.name;