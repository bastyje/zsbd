CREATE OR ALTER PROCEDURE patient.add_new_study
    @patient_id_input INT,
    @date DATE,
    @edss DECIMAL(2, 1),
    @relapses dates READONLY
AS
BEGIN
    DECLARE @study_id INT;
    DECLARE @treatment_history_id_param INT;
    DECLARE @year_of_treatment INT;
    DECLARE @relapse DATE;

    IF @patient_id_input IS NULL
        BEGIN
            THROW 50000, 'patient_id cannot be empty', 1;
        END;

    IF @date IS NULL
        BEGIN
            THROW 50000, 'date cannot be empty', 1;
        END;

    IF @edss < 0 OR @edss > 10
        BEGIN
            THROW 50000, 'edss must be a number between 0 and 10', 1;
        END;

    SELECT TOP 1 @treatment_history_id_param = th.id
    FROM patient.treatment_history th
             JOIN patient.clinical_info ci ON th.clinical_info_id = ci.id
    WHERE ci.patient_id = @patient_id_input
    ORDER BY th.start_date DESC;

    SELECT TOP 1 @year_of_treatment = s.year_of_treatment
    FROM patient.study s
    WHERE s.treatment_history_id = @treatment_history_id_param
    ORDER BY s.date DESC;

    INSERT INTO patient.study (treatment_history_id, date, year_of_treatment, edss)
    VALUES (@treatment_history_id_param, @date, @year_of_treatment, @edss);

    SELECT @study_id = SCOPE_IDENTITY();

    IF EXISTS (SELECT 1 FROM @relapses)
        BEGIN
            DECLARE relapse_cursor CURSOR FOR
                SELECT value FROM @relapses;

            OPEN relapse_cursor;
            FETCH NEXT FROM relapse_cursor INTO @relapse;

            WHILE @@FETCH_STATUS = 0
                BEGIN
                    INSERT INTO patient.relapse (study_id, date) VALUES (@study_id, @relapse);
                    FETCH NEXT FROM relapse_cursor INTO @relapse;
                END;

            CLOSE relapse_cursor;
            DEALLOCATE relapse_cursor;
        END;
END;