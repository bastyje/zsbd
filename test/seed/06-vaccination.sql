DO
$$
    DECLARE
        _patient_id integer;
        _clinical_info_id integer;
        _vaccination_date date;
        _vaccination_type_id integer;
        _random float;
    BEGIN
        FOR _patient_id IN (SELECT id FROM patient.patient)
        LOOP
            FOR _vaccination_type_id IN (SELECT id FROM patient.vaccination_type)
            LOOP
                FOR _vaccination_date IN (
                    SELECT current_date - age * interval '1 year' * random()
                    FROM patient.demographic_info
                    WHERE patient_id = _patient_id
                )
                LOOP
                    _random := RANDOM();
                    IF _random < 0.2 THEN
                        _clinical_info_id := (SELECT id FROM patient.clinical_info WHERE patient_id = _patient_id LIMIT 1);
                        INSERT INTO patient.vaccination (clinical_info_id, date, type)
                        VALUES (_clinical_info_id, _vaccination_date, _vaccination_type_id);
                    END IF;
                END LOOP;
            END LOOP;
        END LOOP;
    END
$$;