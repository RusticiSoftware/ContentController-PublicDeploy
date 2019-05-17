DROP PROCEDURE IF EXISTS content_controller_update_setting;

-- Creates a function that updates setting values from one to another
DELIMITER $$
CREATE PROCEDURE content_controller_update_setting (
    property_name VARCHAR(100),
    old_property_value VARCHAR(1000),
    new_property_value VARCHAR(1000)
)
BEGIN
    UPDATE
        `SystemProperties`
    SET
        property_value = new_property_value
    WHERE
        property_name = property_name AND
        property_value = old_property_value;
END $$
DELIMITER ;

CALL content_controller_update_setting ('PlayerInternetExplorerCompatibilityMode', 'IE7', 'IE9');
CALL content_controller_update_setting ('PlayerInternetExplorerCompatibilityMode', 'EMULATE_IE7', 'EMULATE_IE9');
CALL content_controller_update_setting ('PlayerInternetExplorerCompatibilityMode', 'IE8', 'IE9');
CALL content_controller_update_setting ('PlayerInternetExplorerCompatibilityMode', 'EMULATE_IE8', 'EMULATE_IE9');
