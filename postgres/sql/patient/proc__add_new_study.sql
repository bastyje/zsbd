CREATE OR REPLACE PROCEDURE patient.add_new_study(
    IN patient_id_input INTEGER,
    IN date DATE,
    IN edss DECIMAL(2, 1),
    IN relapses DATE[]
)
LANGUAGE plpgsql
AS $$
DECLARE
    study_id INTEGER;
    treatment_history_id_param INTEGER;
    year_of_treatment INTEGER;
    relapse DATE;
BEGIN

        IF (patient_id_input IS NULL) THEN
            RAISE EXCEPTION 'patient_id cannot be empty';
        END IF;

        IF (date IS NULL) THEN
            RAISE EXCEPTION 'date cannot be empty';
        END IF;

        IF (edss < 0 OR edss > 10) THEN
            RAISE EXCEPTION 'edss must be a number between 0 and 10';
        END IF;

        SELECT th.id INTO treatment_history_id_param
        FROM patient.treatment_history th
        JOIN patient.clinical_info ci ON th.clinical_info_id = ci.id
        WHERE ci.patient_id = patient_id_input
        ORDER BY th.start_date DESC
        LIMIT 1;

        SELECT s.year_of_treatment INTO year_of_treatment
        FROM patient.study s
        WHERE s.treatment_history_id = treatment_history_id_param
        ORDER BY s.date DESC
        LIMIT 1;

        INSERT INTO patient.study (treatment_history_id, date, year_of_treatment, edss)
        VALUES (treatment_history_id_param, date, year_of_treatment, edss);
        SELECT LASTVAL() INTO study_id;

        IF (relapses IS NOT NULL) THEN
            FOREACH relapse IN ARRAY relapses
            LOOP
                INSERT INTO patient.relapse (study_id, date) VALUES (study_id, relapse);
            END LOOP;
        END IF;
    END;
$$;