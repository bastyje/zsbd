CREATE OR ALTER PROCEDURE patient.add_brain_volume
    @study_id_input INT,
    @volume FLOAT,
    @part_of_brain NVARCHAR(255)
AS
BEGIN
    DECLARE @mri_id INT;

    IF @study_id_input IS NULL
        BEGIN
            THROW 50000, 'study_id cannot be empty', 1;
        END;

    IF @volume IS NULL
        BEGIN
            THROW 50000, 'volume cannot be empty', 1;
        END;

    IF @part_of_brain IS NULL
        BEGIN
            THROW 50000, 'part_of_brain cannot be empty', 1;
        END;

    SELECT @mri_id = id
    FROM patient.mri
    WHERE study_id = @study_id_input;

    INSERT INTO patient.brain_volume (mri_id, volume, part_of_brain)
    VALUES (@mri_id, @volume, @part_of_brain);
END;