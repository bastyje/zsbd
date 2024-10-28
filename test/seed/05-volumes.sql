DO
$$
    DECLARE
        _mri_id integer;
        _volume double precision;
        _part_of_brain patient.part_of_brain;
    BEGIN
        FOR _mri_id IN SELECT id FROM patient.mri
        LOOP
            FOR _part_of_brain IN SELECT unnest(enum_range(NULL::patient.part_of_brain))::patient.part_of_brain
            LOOP
                _volume := 200 + floor(random() * 800);
                INSERT INTO patient.brain_volume (mri_id, volume, part_of_brain) VALUES (_mri_id, _volume, _part_of_brain);
            END LOOP;
        END LOOP;
    END;
$$;