-- Fixes records that were incorrectly updated due to a bug with AssignLatestVersionInsteadOfRestartRegistration
-- Can be removed someday in the future, once it's had time to propagate to all CC installations

DROP PROCEDURE IF EXISTS fix_scorm_activity_records;

-- Create a procedure to use for running the migration
DELIMITER $$
CREATE PROCEDURE fix_scorm_activity_records()
BEGIN
    -- Get a lock in case this migration is run from multiple app servers
    SELECT GET_LOCK('fix_scorm_activity_records', 600);

    -- Check to see if we've already ran this migration
    IF (SELECT count(object_key_sha1)
        FROM `SystemObjectStore`
        WHERE object_key_sha1 = unhex('5d164e4828ade489250bc937bf4844298cc131b2')
    ) = 0 THEN
        -- Fix the SCORM Activity records
        UPDATE ScormRegistration sr
            INNER JOIN ScormActivity sa
                ON sr.scorm_registration_id = sa.scorm_registration_id AND sr.engine_tenant_id = sa.engine_tenant_id
            INNER JOIN ScormObject so_act
                ON sa.scorm_object_id = so_act.scorm_object_id AND sa.engine_tenant_id = so_act.engine_tenant_id
            INNER JOIN ScormObjectIdentifiers soi_act
                ON so_act.scorm_object_id = soi_act.scorm_object_id AND so_act.engine_tenant_id = soi_act.engine_tenant_id
            INNER JOIN ScormObject so_pkg
                ON so_pkg.scorm_package_id = sr.scorm_package_id AND so_pkg.engine_tenant_id = sr.engine_tenant_id
            INNER JOIN ScormObjectIdentifiers soi_pkg
                ON soi_pkg.scorm_object_id = so_pkg.scorm_object_id AND soi_pkg.engine_tenant_id = so_pkg.engine_tenant_id
        SET sa.scorm_object_id = so_pkg.scorm_object_id
        WHERE so_act.scorm_package_id <> sr.scorm_package_id AND soi_act.item_identifier = soi_pkg.item_identifier;

        -- Mark the migration as completed
        INSERT INTO `SystemObjectStore` (object_key_sha1, object_key, object_type, object_value, expiry)
            VALUES (unhex('5d164e4828ade489250bc937bf4844298cc131b2'), 'contentcontroller/fix_scorm_activity_records', 'string', '', null);
    END IF;

    SELECT RELEASE_LOCK('fix_scorm_activity_records');
END $$
DELIMITER ;

-- Run the migration
CALL fix_scorm_activity_records();

-- Cleanup
DROP PROCEDURE fix_scorm_activity_records;
