CREATE OR ALTER FUNCTION patient.treatment_duration(@patient_id INT)
    RETURNS INT
AS
BEGIN
    RETURN (
        SELECT DATEDIFF(DAY, first_treatment.start_date, COALESCE(last_treatment.date, GETDATE())) AS duration
        FROM patient.clinical_info ci
                 CROSS APPLY (
            SELECT TOP 1 th.start_date
            FROM patient.treatment_history th
            WHERE th.clinical_info_id = ci.id
            ORDER BY th.start_date
        ) first_treatment
                 CROSS APPLY (
            SELECT TOP 1 COALESCE(ts.date, th.start_date) AS date
            FROM patient.treatment_history th
                     LEFT JOIN patient.treatment_stop ts ON th.treatment_stop_id = ts.id
            WHERE th.clinical_info_id = ci.id
            ORDER BY th.start_date DESC
        ) last_treatment
        WHERE ci.patient_id = @patient_id
    );
END;