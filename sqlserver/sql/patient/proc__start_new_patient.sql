CREATE OR ALTER PROCEDURE patient.start_new_patient
    @pseudonym_of_patient NVARCHAR(255),
    @age_of_patient INT,
    @sex_of_patient NVARCHAR(50),
    @diagnosis_date DATE,
    @first_treatment_date DATE,
    @no_of_previous_treatments INT,
    @edss_grade_at_diagnosis DECIMAL(2, 1),
    @comments_from_doctor NVARCHAR(MAX),
    @reason_treatment_stopped NVARCHAR(MAX),
    @edss_at_start_of_new_treatment DECIMAL(2, 1),
    @dmt_type INT,
    @no_of_relapses_before_start INT,
    @new_treatment_start_date DATE
AS
BEGIN
    DECLARE @patient_id INT;
    DECLARE @clinical_info_id INT;

    IF @pseudonym_of_patient IS NULL OR @pseudonym_of_patient = ''
        BEGIN
            THROW 50000, 'pseudonym_of_patient cannot be empty', 1;
        END;

    INSERT INTO patient.patient (pseudonym) VALUES (@pseudonym_of_patient);
    SELECT @patient_id = SCOPE_IDENTITY();

    IF @sex_of_patient NOT IN ('male', 'female', 'other')
        BEGIN
            THROW 50000, 'sex_of_patient must be either ''male'', ''female'' or ''other''', 1;
        END;

    IF @age_of_patient < 0
        BEGIN
            THROW 50000, 'age_of_patient must be a positive number', 1;
        END;

    INSERT INTO patient.demographic_info (patient_id, age, sex) VALUES (@patient_id, @age_of_patient, @sex_of_patient);

    IF @diagnosis_date IS NULL
        BEGIN
            THROW 50000, 'diagnosis_date cannot be empty', 1;
        END;

    IF @first_treatment_date IS NULL
        BEGIN
            THROW 50000, 'first_treatment_date cannot be empty', 1;
        END;

    IF @no_of_previous_treatments < 0
        BEGIN
            THROW 50000, 'no_of_previous_treatments must be a positive number', 1;
        END;

    IF @edss_grade_at_diagnosis < 0 OR @edss_grade_at_diagnosis > 10
        BEGIN
            THROW 50000, 'edss_grade_at_diagnosis must be a number between 0 and 10', 1;
        END;

    IF @reason_treatment_stopped IS NULL OR @reason_treatment_stopped = ''
        BEGIN
            THROW 50000, 'reason_treatment_stopped cannot be empty', 1;
        END;

    IF @diagnosis_date > @first_treatment_date
        BEGIN
            THROW 50000, 'diagnosis_date cannot be after first_treatment_date', 1;
        END;

    INSERT INTO patient.clinical_info (patient_id, ms_diagnosis_date, first_ms_treatment_date, number_of_previous_treatments, edss_at_diagnosis, comments, reason_of_stopping_treatment)
    VALUES (@patient_id, @diagnosis_date, @first_treatment_date, @no_of_previous_treatments, @edss_grade_at_diagnosis, @comments_from_doctor, @reason_treatment_stopped);
    SELECT @clinical_info_id = SCOPE_IDENTITY();

    IF @edss_at_start_of_new_treatment < 0 OR @edss_at_start_of_new_treatment > 10
        BEGIN
            THROW 50000, 'edss_at_start_of_new_treatment must be a number between 0 and 10', 1;
        END;

    IF @dmt_type < 0
        BEGIN
            THROW 50000, 'dmt_type must be a positive number', 1;
        END;

    IF @no_of_relapses_before_start < 0
        BEGIN
            THROW 50000, 'no_of_relapses_before_start must be a positive number', 1;
        END;

    IF @new_treatment_start_date IS NULL
        BEGIN
            THROW 50000, 'new_treatment_start_date cannot be empty', 1;
        END;

    INSERT INTO patient.treatment_history (clinical_info_id, dmt_type_id, start_date, edss_before_start, number_of_relapses_before_start)
    VALUES (@clinical_info_id, @dmt_type, @new_treatment_start_date, @edss_at_start_of_new_treatment, @no_of_relapses_before_start);
END;