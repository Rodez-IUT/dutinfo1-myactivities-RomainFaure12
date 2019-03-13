CREATE OR REPLACE FUNCTION get_default_owner() RETURNS void AS $$

	INSERT INTO "user"(id,unsername) VALUES(nextval('id_generator'),'Default Owner')
	WHERE NOT EXIST (SELECT * FROM "user" WHERE username = 'Default Owner');
$$ LANGUAGE PGSQL;