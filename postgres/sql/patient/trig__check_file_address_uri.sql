CREATE OR REPLACE FUNCTION check_file_address_uri() RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.file_address_uri IS NULL OR NEW.file_address_uri = '' THEN
        RAISE EXCEPTION 'File address URI cannot be empty';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_file_address_uri
    BEFORE INSERT ON patient.mri
    FOR EACH ROW
EXECUTE FUNCTION check_file_address_uri();