CREATE OR ALTER PROCEDURE patient.add_mri
    @study_id INT,
    @date DATE,
    @file_address_uri NVARCHAR(512)
AS
BEGIN
    IF @study_id IS NULL
        BEGIN
            THROW 50000, 'study_id cannot be empty', 1;
        END;

    IF @date IS NULL
        BEGIN
            THROW 50000, 'date cannot be empty', 1;
        END;

    IF @file_address_uri IS NULL OR @file_address_uri = ''
        BEGIN
            THROW 50000, 'file_name cannot be empty', 1;
        END;

    INSERT INTO patient.mri (study_id, date, file_address_uri)
    VALUES (@study_id, @date, @file_address_uri);
END;