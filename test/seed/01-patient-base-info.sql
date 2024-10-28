DO
$$
    DECLARE
        _pseudonym varchar(128);
        _count integer := 3000;
    BEGIN
        FOR i IN 1.._count LOOP
            _pseudonym := (
                SELECT array_to_string(array(
                    SELECT chr(97 + floor(random() * 26)::int)
                    FROM generate_series(1, 10)
                ), '')
            );

            INSERT INTO patient.patient (pseudonym)
            VALUES (_pseudonym);
        END LOOP;
    END
$$;

DO
$$
    DECLARE
        _age integer;
        _sex patient.sex;
        _patient_id integer;
    BEGIN
        FOR _patient_id IN (
            SELECT
                id
            FROM patient.patient
            WHERE id NOT IN (SELECT patient_id FROM patient.demographic_info)
        )
        LOOP
            _age := floor(random() * 101);
            _sex := CASE WHEN random() < 0.5 THEN 'male' ELSE 'female' END;

            INSERT INTO patient.demographic_info (patient_id, age, sex)
            VALUES (_patient_id, _age, _sex);
        END LOOP;
    END
$$;

DO
$$
    DECLARE
        _ms_diagnosis_date date;
        _first_ms_treatment_date date;
        _number_of_previous_treatments integer;
        _edss_at_diagnosis numeric;
        _patient_id integer;
        _comments varchar;
        _reason_of_stopping varchar;
    BEGIN
        FOR _patient_id IN (
            SELECT
                id
            FROM patient.patient
            WHERE id NOT IN (SELECT patient_id FROM patient.clinical_info)
        )
        LOOP
            _ms_diagnosis_date := (CURRENT_DATE - (floor(random() * 7300 + 1))::int);
            _first_ms_treatment_date := _ms_diagnosis_date + (floor(random() * 365 + 1))::int;
            _number_of_previous_treatments := floor(random() * 6);
            _edss_at_diagnosis := round((floor(random() * 21) * 0.5)::numeric, 1);
            _comments := CASE WHEN random() < 0.2 THEN 'No major issues' ELSE NULL END;
            _reason_of_stopping := CASE WHEN random() < 0.2 THEN 'Adverse effects' ELSE NULL END;

            INSERT INTO patient.clinical_info (
                patient_id, ms_diagnosis_date, first_ms_treatment_date,
                number_of_previous_treatments, edss_at_diagnosis,
                comments, reason_of_stopping_treatment
            ) VALUES (
                _patient_id, _ms_diagnosis_date, _first_ms_treatment_date,
                 _number_of_previous_treatments, _edss_at_diagnosis,
                 _comments, _reason_of_stopping
            );
        END LOOP;
    END
$$;
