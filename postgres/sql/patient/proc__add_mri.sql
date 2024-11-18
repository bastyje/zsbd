CREATE OR REPLACE PROCEDURE patient.add_mri (
    IN study_id INTEGER,
    IN date DATE,
    IN file_address_uri VARCHAR(512))
LANGUAGE plpgsql
AS $$
BEGIN
        IF (study_id IS NULL) THEN
            RAISE EXCEPTION 'study_id cannot be empty';
        END IF;

        IF (date IS NULL) THEN
            RAISE EXCEPTION 'date cannot be empty';
        END IF;

        IF (file_address_uri IS NULL OR file_address_uri = '') THEN
            RAISE EXCEPTION 'file_name cannot be empty';
        END IF;

        INSERT INTO patient.mri (study_id, date, file_address_uri)
        VALUES (study_id, date, file_address_uri);
    END;
$$;