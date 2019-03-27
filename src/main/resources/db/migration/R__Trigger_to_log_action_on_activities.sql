DROP TRIGGER IF EXISTS trigger_log_action on activity ;

CREATE OR REPLACE FUNCTION trigger_log_action () RETURNS TRIGGER AS $action_log$

BEGIN
 	INSERT INTO action_log VALUES (nextval('id_generator'), 'delete', 'activity', user, OLD.id);
 
RETURN OLD;

END;
$action_log$ language plpgsql;


CREATE TRIGGER trigger_log_action
    AFTER DELETE ON activity
    FOR EACH ROW EXECUTE PROCEDURE trigger_log_action();
    
    