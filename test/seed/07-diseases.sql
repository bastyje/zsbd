DO
$$
    DECLARE
        _patient_id integer;
        _clinical_info_id integer;
        _disease_id integer;
        _diagnosis_date date;
    BEGIN
        FOR _patient_id IN SELECT id FROM patient.patient
        LOOP
            FOR _clinical_info_id IN SELECT id FROM patient.clinical_info WHERE patient_id = _patient_id
            LOOP
                IF random() < 0.07 THEN
                    _disease_id := (SELECT id FROM patient.disease ORDER BY random() LIMIT 1);
                    _diagnosis_date := (
                        SELECT current_date - age * interval '1 year' * random()
                        FROM patient.demographic_info
                        WHERE patient_id = _patient_id
                    );
                    INSERT INTO patient.concomitant_disease (clinical_info_id, disease_id, diagnosis_date)
                    VALUES (_clinical_info_id, _disease_id, _diagnosis_date);
                END IF;
            END LOOP;
        END LOOP;
    END;
$$;