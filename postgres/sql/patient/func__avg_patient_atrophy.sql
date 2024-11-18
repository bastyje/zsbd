CREATE OR REPLACE FUNCTION patient.avg_patient_atrophy(patient_id integer) RETURNS double precision
AS
$$
    SELECT avg(atrophy) FROM patient.patient_atrophy WHERE patient_id = $1
$$ LANGUAGE sql;