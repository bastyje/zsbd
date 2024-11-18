CREATE OR REPLACE PROCEDURE patient.add_brain_volume (
    IN study_id_input INTEGER,
    IN volume DOUBLE PRECISION,
    IN part_of_brain patient.part_of_brain
)
LANGUAGE plpgsql
AS $$
DECLARE
    mri_id INTEGER;
BEGIN
        IF (study_id_input IS NULL) THEN
            RAISE EXCEPTION 'study_id cannot be empty';
        END IF;

        IF (volume IS NULL) THEN
            RAISE EXCEPTION 'volume cannot be empty';
        END IF;

        IF (part_of_brain IS NULL) THEN
            RAISE EXCEPTION 'part_of_brain cannot be empty';
        END IF;

        SELECT id INTO mri_id
        FROM patient.mri
        WHERE study_id = study_id_input;

        INSERT INTO patient.brain_volume (mri_id, volume, part_of_brain)
        VALUES (mri_id, volume, part_of_brain);
    END;
$$;
