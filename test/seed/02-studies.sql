DO
$$
    DECLARE
        _clinical_info_id integer;
        _dmt_type_id integer;
        _start_date date;
        _edss_before_start numeric;
        _number_of_relapses_before_start integer;
        _treatment_stop_id integer;
    BEGIN
        FOR _clinical_info_id IN (
            SELECT
                id
            FROM patient.clinical_info
        )
        LOOP
            FOR _dmt_type_id IN (
                SELECT
                    id
                FROM patient.dmt_type
                ORDER BY RANDOM()
                LIMIT RANDOM() * 2 + 1
            )
            LOOP
                FOR _start_date IN (
                    SELECT
                        ci.first_ms_treatment_date + (RANDOM() * 365 * 3) * INTERVAL '1 day' AS treatment_start_date
                    FROM patient.clinical_info ci
                    WHERE ci.id = _clinical_info_id
                )
                LOOP
                    FOR _edss_before_start IN (
                        SELECT
                            ROUND((RANDOM() * 20)) * 0.5 AS value
                    )
                    LOOP
                        FOR _number_of_relapses_before_start IN (
                            SELECT
                                FLOOR(RANDOM() * 6) AS value
                        )
                        LOOP
                            INSERT INTO patient.treatment_history (clinical_info_id, dmt_type_id, start_date, edss_before_start, number_of_relapses_before_start, treatment_stop_id)
                            VALUES (_clinical_info_id, _dmt_type_id, _start_date, _edss_before_start, _number_of_relapses_before_start, null);
                        END LOOP;
                    END LOOP;
                END LOOP;
            END LOOP;
        END LOOP;
    END
$$;

DO
$$
    DECLARE
        _clinical_info_id integer;
        _treatment_history_start_date date;
        _next_treatment_start_date date;
        _treatment_stop_date date;
        _reason varchar;
        _random float;
        _treatment_history_id integer;
    BEGIN
        FOR _clinical_info_id IN (
            SELECT ci.id
            FROM patient.clinical_info ci
            JOIN patient.treatment_history th ON ci.id = th.clinical_info_id
            GROUP BY ci.id
            HAVING COUNT(th.id) > 1
        )
        LOOP
            FOR _treatment_history_start_date, _next_treatment_start_date, _treatment_history_id IN (
                SELECT th.start_date, th2.start_date, th.id
                FROM patient.treatment_history th
                JOIN LATERAL (
                    SELECT start_date
                    FROM patient.treatment_history th2
                    WHERE th2.clinical_info_id = th.clinical_info_id
                    AND th2.start_date > th.start_date
                    ORDER BY th2.start_date
                    LIMIT 1
                ) th2 ON true
                WHERE th.clinical_info_id = _clinical_info_id
            )
            LOOP
                _treatment_stop_date := _treatment_history_start_date + (RANDOM() * (_next_treatment_start_date - _treatment_history_start_date)) * INTERVAL '1 day';
                _random := RANDOM();
                _reason := CASE
                    WHEN _random < 0.25 THEN 'lack of efficacy'
                    WHEN _random < 0.5 THEN 'side effects'
                    WHEN _random < 0.75 THEN 'pregnancy'
                    ELSE 'patient decision'
                END;

                INSERT INTO patient.treatment_stop (reason, date)
                VALUES (_reason, _treatment_stop_date);

                -- update treatment history
                UPDATE patient.treatment_history
                SET treatment_stop_id = currval('patient.treatment_stop_id_seq')
                WHERE id = _treatment_history_id;
            END LOOP;
        END LOOP;
    END
$$;

DO
$$
    DECLARE
        _treatment_history RECORD;
        _year_of_treatment INTEGER;
        _study_date DATE;
        _edss NUMERIC;
        _previous_edss NUMERIC;
    BEGIN
        FOR _treatment_history IN (
            SELECT th.id, th.clinical_info_id, th.start_date, th.treatment_stop_id, th.edss_before_start, ts.date AS stop_date, th2.edss_before_start AS edss_at_stop
            FROM patient.treatment_history th
            LEFT JOIN LATERAL (
                SELECT th2.edss_before_start
                FROM patient.treatment_history th2
                WHERE th2.clinical_info_id = th.clinical_info_id AND th2.start_date > th.start_date
                ORDER BY th2.start_date
                LIMIT 1
            ) th2 ON true
            LEFT JOIN patient.treatment_stop ts ON th.treatment_stop_id = ts.id
        )
        LOOP
            IF _treatment_history.stop_date IS NOT NULL THEN
                FOR _year_of_treatment IN 0..EXTRACT(YEAR FROM AGE(_treatment_history.stop_date, _treatment_history.start_date))
                LOOP
                    _previous_edss := COALESCE((
                        SELECT edss
                        FROM patient.study
                        WHERE treatment_history_id = _treatment_history.id AND year_of_treatment = _year_of_treatment - 1
                        ORDER BY date DESC
                        LIMIT 1
                    ), _treatment_history.edss_before_start);
                    IF random() < 0.5 THEN
                        _study_date := _treatment_history.start_date + (_year_of_treatment * INTERVAL '1 year') + (RANDOM() * 90) * INTERVAL '1 day';
                    ELSE
                        _study_date := _treatment_history.start_date + (_year_of_treatment * INTERVAL '1 year') - (RANDOM() * 90) * INTERVAL '1 day';
                    END IF;
                    _edss := _previous_edss + (RANDOM() * (_treatment_history.edss_at_stop - _previous_edss));
                    IF _edss > 10 THEN
                        _edss := 10;
                    ELSEIF _edss < 0 THEN
                        _edss := 0;
                    END IF;
                    INSERT INTO patient.study (treatment_history_id, date, year_of_treatment, edss)
                    VALUES (_treatment_history.id, _study_date, _year_of_treatment, ROUND(_edss * 2) / 2);
                END LOOP;
            ELSE
                FOR _year_of_treatment IN 0..EXTRACT(YEAR FROM AGE(CURRENT_DATE, _treatment_history.start_date))
                LOOP
                    _previous_edss := COALESCE((
                        SELECT edss
                        FROM patient.study
                        WHERE treatment_history_id = _treatment_history.id AND year_of_treatment = _year_of_treatment - 1
                        ORDER BY date DESC
                        LIMIT 1
                    ), _treatment_history.edss_before_start);
                    IF random() < 0.5 THEN
                        _study_date := _treatment_history.start_date + (_year_of_treatment * INTERVAL '1 year') + (RANDOM() * 90) * INTERVAL '1 day';
                    ELSE
                        _study_date := _treatment_history.start_date + (_year_of_treatment * INTERVAL '1 year') - (RANDOM() * 90) * INTERVAL '1 day';
                    END IF;
                    _edss := _previous_edss + (RANDOM() * 2 - 1);
                    IF _edss > 10 THEN
                        _edss := 10;
                    ELSEIF _edss < 0 THEN
                        _edss := 0;
                    END IF;
                    INSERT INTO patient.study (treatment_history_id, date, year_of_treatment, edss)
                    VALUES (_treatment_history.id, _study_date, _year_of_treatment, ROUND(_edss * 2) / 2);
                END LOOP;
            END IF;
        END LOOP;
    END
$$;