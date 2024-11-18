CREATE OR REPLACE FUNCTION check_no_overlapping_mri_dates()
    RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM patient.mri
        WHERE study_id = NEW.study_id
          AND date = NEW.date
    ) THEN
        RAISE EXCEPTION 'Patient cannot have overlapping MRI scan dates';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_no_overlapping_mri_dates
    BEFORE INSERT OR UPDATE ON patient.mri
    FOR EACH ROW
EXECUTE FUNCTION check_no_overlapping_mri_dates();
