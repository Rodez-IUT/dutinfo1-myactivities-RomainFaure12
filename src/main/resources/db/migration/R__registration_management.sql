
CREATE OR REPLACE FUNCTION register_user_on_activity (userId bigInt, activityId bigInt) RETURNS SETOF registration AS $$
DECLARE
	newId bigInt = nextval('id_generator');
BEGIN
	SELECT * FROM registration
			WHERE user_id = userId
			AND   activity_id = activityId;
		IF NOT FOUND THEN
			INSERT INTO registration VALUES (newId, now(), userId, activityId);
			
			RETURN QUERY SELECT * FROM registration
			WHERE id = newId;
		ELSE
			RAISE EXCEPTION 'registration_already_exists';
 		END IF;
 		

END;
$$ language plpgsql;

    