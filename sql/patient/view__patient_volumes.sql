DROP VIEW IF EXISTS patient.patient_volumes;
CREATE VIEW patient.patient_volumes AS
    SELECT
        clinical.patient_id,
        clinical.pseudonym,
        clinical.treatment_id,
        clinical.year_of_treatment,
        clinical.edss,
        clinical.relapses,
        clinical.dmt_type,
        MAX(CASE WHEN bv.part_of_brain = 'cerebrum' THEN bv.volume END) AS cerebrum,
        MAX(CASE WHEN bv.part_of_brain = 'frontal_lobe' THEN bv.volume END) AS frontal_lobe,
        MAX(CASE WHEN bv.part_of_brain = 'parietal_lobe' THEN bv.volume END) AS parietal_lobe,
        MAX(CASE WHEN bv.part_of_brain = 'temporal_lobe' THEN bv.volume END) AS temporal_lobe,
        MAX(CASE WHEN bv.part_of_brain = 'occipital_lobe' THEN bv.volume END) AS occipital_lobe,
        MAX(CASE WHEN bv.part_of_brain = 'cerebellum' THEN bv.volume END) AS cerebellum,
        MAX(CASE WHEN bv.part_of_brain = 'brain_stem' THEN bv.volume END) AS brain_stem,
        MAX(CASE WHEN bv.part_of_brain = 'midbrain' THEN bv.volume END) AS midbrain,
        MAX(CASE WHEN bv.part_of_brain = 'pons' THEN bv.volume END) AS pons,
        MAX(CASE WHEN bv.part_of_brain = 'medulla_oblongata' THEN bv.volume END) AS medulla_oblongata,
        MAX(CASE WHEN bv.part_of_brain = 'thalamus' THEN bv.volume END) AS thalamus,
        MAX(CASE WHEN bv.part_of_brain = 'hypothalamus' THEN bv.volume END) AS hypothalamus,
        MAX(CASE WHEN bv.part_of_brain = 'amygdala' THEN bv.volume END) AS amygdala,
        MAX(CASE WHEN bv.part_of_brain = 'hippocampus' THEN bv.volume END) AS hippocampus,
        MAX(CASE WHEN bv.part_of_brain = 'basal_ganglia' THEN bv.volume END) AS basal_ganglia,
        MAX(CASE WHEN bv.part_of_brain = 'corpus_callosum' THEN bv.volume END) AS corpus_callosum,
        MAX(CASE WHEN bv.part_of_brain = 'meninges' THEN bv.volume END) AS meninges,
        MAX(CASE WHEN bv.part_of_brain = 'cerebrospinal_fluid' THEN bv.volume END) AS cerebrospinal_fluid,
        MAX(CASE WHEN bv.part_of_brain = 'blood_brain_barrier' THEN bv.volume END) AS blood_brain_barrier,
        MAX(CASE WHEN bv.part_of_brain = 'neurons' THEN bv.volume END) AS neurons,
        MAX(CASE WHEN bv.part_of_brain = 'glial_cells' THEN bv.volume END) AS glial_cells
    FROM patient.brain_volume bv
    JOIN LATERAL (
        SELECT
            p.id AS patient_id,
            p.pseudonym,
            th.id AS treatment_id,
            s.year_of_treatment,
            s.edss,
            count(r.id) AS relapses,
            m.id AS mri_id,
            dmt.name AS dmt_type
        FROM patient.patient p
        JOIN patient.clinical_info ci ON p.id = ci.patient_id
        JOIN patient.treatment_history th ON ci.id = th.clinical_info_id
        JOIN patient.study s ON th.id = s.treatment_history_id
        JOIN patient.mri m ON s.id = m.study_id
        JOIN patient.dmt_type dmt ON th.dmt_type_id = dmt.id
        LEFT JOIN patient.relapse r ON s.id = r.study_id
        GROUP BY p.id, p.pseudonym, th.id, s.year_of_treatment, s.edss, m.id, dmt.name
    ) clinical ON bv.mri_id = clinical.mri_id
    GROUP BY clinical.patient_id, clinical.pseudonym, clinical.treatment_id, clinical.year_of_treatment, clinical.edss, clinical.relapses, clinical.dmt_type;


DROP INDEX IF EXISTS idx_year_of_treatment;

\timing
SELECT * FROM patient.patient_volumes;