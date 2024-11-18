CREATE TRIGGER instead_of_insert_mri
    ON patient.mri
    INSTEAD OF INSERT, UPDATE
    AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM patient.mri p
                 JOIN inserted i ON p.study_id = i.study_id AND p.date = i.date
    )
        BEGIN
            RAISERROR('Patient cannot have overlapping MRI scan dates', 16, 1);
        END

    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE file_address_uri IS NULL OR file_address_uri = ''
    )
        BEGIN
            RAISERROR('File address URI cannot be empty', 16, 1);
        END

    INSERT INTO patient.mri (study_id, date, file_address_uri)
    SELECT study_id, date, file_address_uri
    FROM inserted;
END;