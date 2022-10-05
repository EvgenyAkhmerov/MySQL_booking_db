USE book_and_trip;

###### I. Create some constraint on insert, update and delete DATA with TRIGGER ######

-- 1. messages : conversation can be only beetwen users and admin

DROP TRIGGER IF EXISTS conv_user_admin;
DELIMITER //
CREATE TRIGGER conv_user_admin BEFORE INSERT ON messages
FOR EACH ROW
BEGIN
	
	IF NEW.from_user_id NOT IN (SELECT user_id FROM admins) AND NEW.to_user_id NOT IN (SELECT user_id FROM admins) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Conversation must be only beetwen user and admin, not beetwen users!';
	END IF;
	IF NEW.from_user_id IN (SELECT user_id FROM admins) AND NEW.to_user_id IN (SELECT user_id FROM admins) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Conversation must be only beetwen user and admin, not beetwen admins!';
	END IF;
END//
DELIMITER ;

-- check
/*
INSERT IGNORE INTO messages
VALUES (101, 1, 2, '2012-04-28 21:15:40', 'Hello!');

INSERT IGNORE INTO messages 
VALUES (101, 11, 12, '2012-04-18 21:15:40', 'Hello!'); 
*/

-- 2. reviews must be only from users

DROP TRIGGER IF EXISTS rev_from_user;
DELIMITER //
CREATE TRIGGER rev_from_user BEFORE INSERT ON reviews
FOR EACH ROW
BEGIN
	
	IF NEW.user_id IN (SELECT user_id FROM admins) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'reviews must be only from users!';
	END IF;
END//
DELIMITER ;

-- check
/*
INSERT IGNORE INTO reviews (user_id)
VALUES (1);
*/

-- 3. Restriction on order : if order is ended then end_time > create_time; if order is going then end_time > CURRENT_TIME

DROP TRIGGER IF EXISTS restr_order;
DELIMITER //
CREATE TRIGGER restr_order BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
	IF NEW.order_status = 'ended' AND NEW.created_at > NEW.ended_at THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ended_time < created_time!';
	END IF;
	IF NEW.order_status = 'is going' AND NEW.ended_at < NOW() THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ended_time < CURRENT_TIME!';
	END IF;
END//
DELIMITER ;

-- check
/*
INSERT IGNORE INTO orders (order_status, created_at, ended_at)
VALUES ('ended', '2022-04-28 21:15:40', '2022-04-27 21:15:40' );

INSERT IGNORE INTO orders (order_status, created_at, ended_at)
VALUES ('is going', '2022-10-3 21:15:40', '2022-10-4 21:15:40' );
*/

###### II. Make some CRUD - operations ######

-- 1. SELECT 

-- task1 : show hotels with their apartments, which price < 500 and free places > 20 --

SELECT 
	hotels.name as 'Hotel name',
	apart.id,
	apart.is_taken 'Availability',
	hotels.general_mark,
	hotels.free_place,
	apart.price as 'price for one night',
	apart.num_of_people as 'People in one apart'
FROM hotels RIGHT JOIN apartments AS apart ON hotels.id = apart.hotel_id
WHERE hotels.free_place > 20 AND apart.price < 500
ORDER BY hotels.name;

-- task2 : Show adminisrators with next criterios AGE > 25, GENDER = f

SELECT * FROM
(SELECT
	admins.id AS 'admin_id',
	users.name,
	prof.gender,
	TIMESTAMPDIFF(YEAR, prof.birthday, CURRENT_DATE) AS age,
	prof.email,
	prof.phone_num
FROM admins 
	INNER JOIN users ON admins.user_id = users.id
	INNER JOIN profiles AS prof ON admins.user_id = prof.user_id
	INNER JOIN hotels ON admins.hotel_id = hotels.id
) AS tbl1
WHERE age > 25 and tbl1.gender = 'f'
ORDER BY age;





