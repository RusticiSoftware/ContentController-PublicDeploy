DROP PROCEDURE IF EXISTS append_rewrite_to_source_url;

-- Creates a function that updates old source urls for tin can forwarding statements to include xAPI overlay rewrite querey param
DELIMITER $$
CREATE PROCEDURE append_rewrite_to_source_url()
BEGIN
    UPDATE ScormEngineDB.TinCanForwardingMap
    SET source_url = CONCAT(source_url, '&rusticiRewrite=true')
    WHERE source_url NOT LIKE '%rusticiRewrite%';
END $$
DELIMITER ;

CALL append_rewrite_to_source_url();
