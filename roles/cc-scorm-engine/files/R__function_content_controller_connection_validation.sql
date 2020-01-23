DROP FUNCTION IF EXISTS content_controller_connection_validation;

-- Creates a function that will attempt to do an insert (to make sure the connection is not read-only) and then return 1
DELIMITER $$
CREATE FUNCTION content_controller_connection_validation() RETURNS INTEGER
BEGIN
    INSERT INTO `SystemObjectStore` (object_key_sha1, object_key, object_type, object_value, expiry)
        VALUES (unhex('ad522e07a0ee37459059aa16eb6a45d000827a32'), 'contentcontroller/healthcheck', 'string', '', now())
        ON DUPLICATE KEY UPDATE update_dt = now();

    RETURN 1;
END $$
DELIMITER ;
