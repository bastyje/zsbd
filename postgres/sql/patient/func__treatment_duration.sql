CREATE OR REPLACE FUNCTION patient.treatment_duration(patient_id integer) RETURNS INTEGER
AS
$$
    SELECT COALESCE(last_treatment.date, current_date) - first_treatment.start_date AS duration
    FROM patient.clinical_info ci
    JOIN LATERAL (
        SELECT th.start_date
        FROM patient.treatment_history th
        WHERE th.clinical_info_id = ci.id
        ORDER BY th.start_date
        LIMIT 1
    ) first_treatment ON true
    JOIN LATERAL (
        SELECT ts.date
        FROM patient.treatment_history th
        LEFT JOIN patient.treatment_stop ts ON th.treatment_stop_id = ts.id
        WHERE th.clinical_info_id = ci.id
        ORDER BY th.start_date DESC
        LIMIT 1
    ) last_treatment ON true
    WHERE ci.patient_id = $1
$$ LANGUAGE SQL;