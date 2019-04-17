CREATE OR REPLACE FUNCTION find_all_activities_for_owner(owner varchar(50)) RETURNS SETOF activity AS $$	
	SELECT activity.* FROM activity JOIN "user" ON activity.owner_id = "user".id  WHERE "user".username = find_all_activities_for_owner.owner;
$$ LANGUAGE SQL;