DO
$$
    DECLARE
        _study_id integer;
        _relapse_count integer;
        _relapse_date date;
        _study_date date;
    BEGIN
        FOR _study_id, _study_date IN SELECT id, date FROM patient.study
        LOOP
            _relapse_count := floor(random() * 5);
            FOR i IN 1.._relapse_count
            LOOP
                _relapse_date := _study_date - floor(random() * 365) * interval '1 day';
                INSERT INTO patient.relapse (study_id, date) VALUES (_study_id, _relapse_date);
            END LOOP;
        END LOOP;
    END;
$$;
