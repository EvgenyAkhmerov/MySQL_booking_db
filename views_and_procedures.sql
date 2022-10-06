-- Create some VIEWS and PROCEDURE

USE book_and_trip;

-- I. VIEWS

-- 1. create views wich shows 5 most cheap hotels with apartments and admins phone number

DROP VIEW IF EXISTS cheap_aparts;
CREATE VIEW cheap_aparts AS
SELECT 
	hotels.name,
	hotels.address,
	prof.phone_num AS 'Admins phone',
	apart.is_taken AS 'Availability',
	apart.price,
	apart.num_of_people 
FROM hotels 
	RIGHT JOIN apartments AS apart ON hotels.id = apart.hotel_id
	INNER JOIN admins ON hotels.id = admins.hotel_id
	INNER JOIN profiles AS prof ON admins.user_id = prof.user_id
ORDER BY apart.price LIMIT 5;

SELECT * FROM cheap_aparts;

-- 2. create views which shows messages 10 years ago with name of users and tags admins or user

DROP VIEW IF EXISTS early_messages;
CREATE VIEW early_messages AS
SELECT
	messages.id,
	'admins' AS from_person,
	messages.from_user_id,
	messages.to_user_id,
	messages.created_at 
FROM messages
	RIGHT JOIN admins ON messages.from_user_id = admins.user_id
WHERE TIMESTAMPDIFF(YEAR, messages.created_at, CURRENT_DATE) > 10 AND 
	messages.to_user_id NOT IN (SELECT user_id FROM admins)
UNION ALL
SELECT
	messages.id,
	'user' AS from_person,
	messages.from_user_id,
	messages.to_user_id,
	messages.created_at 
FROM messages
	RIGHT JOIN admins ON messages.to_user_id = admins.user_id
WHERE TIMESTAMPDIFF(YEAR, messages.created_at, CURRENT_DATE) > 10 AND 
	messages.from_user_id NOT IN (SELECT user_id FROM admins);

SELECT * FROM early_messages;

-- II PROCEDURE

-- 1. procedure to count available apartments

DROP PROCEDURE IF EXISTS cnt_availble_apart;
DELIMITER //
CREATE PROCEDURE cnt_availble_apart ()
BEGIN
	SELECT COUNT(*) FROM apartments WHERE is_taken = 1;
END//
DELIMITER ;

CALL cnt_availble_apart();



	
