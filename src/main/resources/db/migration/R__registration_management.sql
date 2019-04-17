CREATE OR REPLACE FUNCTION register_user_on_activity(in_user_id bigInt, in_activity_id bigInt) RETURNS registration AS $$
DECLARE
	res_registration registration%rowtype;
BEGIN
	SELECT * INTO res_registration FROM registration
			WHERE user_id = in_user_id
			AND   activity_id = in_activity_id;
		IF FOUND THEN
			RAISE EXCEPTION 'registration_already_exists';
		END IF;
	INSERT INTO registration (id, user_id, activity_id)
	VALUES (nextval('id_generator'), in_user_id, in_activity_id);
			
	SELECT * INTO res_registration FROM registration 
	WHERE user_id = in_user_id
	AND   activity_id = in_activity_id;
	RETURN res_registration;

END;

$$ language plpgsql;

DROP TRIGGER IF EXISTS trigger_log_action on registration ;

CREATE OR REPLACE FUNCTION trigger_log_action() RETURNS TRIGGER AS $action_log$

BEGIN
 	INSERT INTO action_log VALUES (nextval('id_generator'), 'insert', 'registration', user, NEW.id, now());
 
RETURN NEW;

END;
$action_log$ language plpgsql;


CREATE TRIGGER trigger_log_action
    AFTER INSERT ON registration
    FOR EACH ROW EXECUTE PROCEDURE trigger_log_action();



CREATE OR REPLACE FUNCTION unregister_user_on_activity(in_user_id bigInt, in_activity_id bigInt) RETURNS void AS $$
DECLARE
	res_registration registration%rowtype;
BEGIN
	SELECT * INTO res_registration FROM registration
			WHERE user_id = in_user_id
			AND   activity_id = in_activity_id;
		IF NOT FOUND THEN
			RAISE EXCEPTION 'registration_not_exists';
		END IF;
	DELETE FROM registration
	WHERE user_id = in_user_id AND activity_id = in_activity_id;
END;

$$ language plpgsql;

DROP TRIGGER IF EXISTS trigger_log_delete_action on registration ;

CREATE OR REPLACE FUNCTION trigger_log_delete_action() RETURNS TRIGGER AS $action_log$

BEGIN
 	INSERT INTO action_log VALUES (nextval('id_generator'), 'delete', 'registration', user, OLD.id, now());
 
RETURN OLD;

END;
$action_log$ language plpgsql;

CREATE TRIGGER trigger_log_delete_action
    AFTER DELETE ON registration
    FOR EACH ROW EXECUTE PROCEDURE trigger_log_delete_action();
    
CREATE OR REPLACE FUNCTION add_activity(in_title bigInt, in_description bigInt, in_owner_id bigInt) RETURNS void as $$
	--
$$ language plpgsql;