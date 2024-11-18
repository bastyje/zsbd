CREATE OR ALTER FUNCTION patient.avg_patient_atrophy(@patient_id INT)
    RETURNS FLOAT
AS
BEGIN
RETURN (
           SELECT AVG(atrophy)
           FROM patient.patient_atrophy
           WHERE patient_id = @patient_id
       );
END;