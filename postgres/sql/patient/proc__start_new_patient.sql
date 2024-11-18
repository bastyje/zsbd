CREATE OR REPLACE PROCEDURE patient.start_new_patient(
    IN pseudonym_of_patient VARCHAR(255),
    IN age_of_patient INTEGER,
    IN sex_of_patient VARCHAR,
    IN diagnosis_date DATE,
    IN first_treatment_date DATE,
    IN no_of_previous_treatments INTEGER,
    IN edss_grade_at_diagnosis DECIMAL(2, 1),
    IN comments_from_doctor TEXT,
    IN reason_treatment_stopped TEXT,
    IN edss_at_start_of_new_treatment DECIMAL(2, 1),
    IN dmt_type INTEGER,
    IN no_of_relapses_before_start INTEGER,
    IN new_treatment_start_date DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
    patient_id INTEGER;
    clinical_info_id INTEGER;
BEGIN

    IF (pseudonym_of_patient IS NULL OR pseudonym_of_patient = '') THEN
        RAISE EXCEPTION 'pseudonym_of_patient cannot be empty';
    END IF;

    INSERT INTO patient.patient (pseudonym) VALUES (pseudonym_of_patient);
    SELECT LASTVAL() INTO patient_id;

    IF (sex_of_patient <> 'male' AND sex_of_patient <> 'female' AND sex_of_patient <> 'other') THEN
        RAISE EXCEPTION 'sex_of_patient must be either ''male'', ''female'' or ''other''';
    END IF;

    IF (age_of_patient < 0) THEN
        RAISE EXCEPTION 'age_of_patient must be a positive number';
    END IF;

    INSERT INTO patient.demographic_info (patient_id, age, sex) VALUES (patient_id, age_of_patient, sex_of_patient::patient.sex);

    IF (diagnosis_date IS NULL) THEN
        RAISE EXCEPTION 'diagnosis_date cannot be empty';
    END IF;

    IF (first_treatment_date IS NULL) THEN
        RAISE EXCEPTION 'first_treatment_date cannot be empty';
    END IF;

    IF (no_of_previous_treatments < 0) THEN
        RAISE EXCEPTION 'no_of_previous_treatments must be a positive number';
    END IF;

    IF (edss_grade_at_diagnosis < 0 OR edss_grade_at_diagnosis > 10) THEN
        RAISE EXCEPTION 'edss_grade_at_diagnosis must be a number between 0 and 10';
    END IF;

    IF (reason_treatment_stopped IS NULL OR reason_treatment_stopped = '') THEN
        RAISE EXCEPTION 'reason_treatment_stopped cannot be empty';
    END IF;

    IF (diagnosis_date::date > first_treatment_date::date) THEN
        RAISE EXCEPTION 'diagnosis_date cannot be after first_treatment_date';
    END IF;

    INSERT INTO patient.clinical_info (patient_id, ms_diagnosis_date, first_ms_treatment_date, number_of_previous_treatments, edss_at_diagnosis, comments, reason_of_stopping_treatment)
        VALUES (patient_id, diagnosis_date, first_treatment_date, no_of_previous_treatments, edss_grade_at_diagnosis, comments_from_doctor, reason_treatment_stopped);
    SELECT LASTVAL() INTO clinical_info_id;

    IF (edss_at_start_of_new_treatment < 0 OR edss_at_start_of_new_treatment > 10) THEN
        RAISE EXCEPTION 'edss_at_start_of_new_treatment must be a number between 0 and 10';
    END IF;

    IF (dmt_type < 0) THEN
        RAISE EXCEPTION 'dmt_type must be a positive number';
    END IF;

    IF (no_of_relapses_before_start < 0) THEN
        RAISE EXCEPTION 'no_of_relapses_before_start must be a positive number';
    END IF;

    IF (new_treatment_start_date IS NULL) THEN
        RAISE EXCEPTION 'new_treatment_start_date cannot be empty';
    END IF;

    INSERT INTO patient.treatment_history (clinical_info_id, dmt_type_id, start_date, edss_before_start, number_of_relapses_before_start)
        VALUES (clinical_info_id, dmt_type, new_treatment_start_date, edss_at_start_of_new_treatment, no_of_relapses_before_start);
END;
$$;