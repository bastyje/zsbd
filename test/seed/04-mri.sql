DO
$$
    DECLARE
        _study_id integer;
        _mri_date date;
        _study_date date;
    BEGIN
        FOR _study_id, _study_date IN SELECT id, date FROM patient.study
        LOOP
            _mri_date := _study_date - floor(random() * 10) * interval '1 day';
            INSERT INTO patient.mri (study_id, date, file_address_uri) VALUES (_study_id, _mri_date, 'file://' || _study_id || '/mri/' || _mri_date || '.nii');
        END LOOP;
    END;
$$;