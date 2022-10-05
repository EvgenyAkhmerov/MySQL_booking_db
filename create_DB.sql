-- create database

DROP DATABASE IF EXISTS book_and_trip;
CREATE DATABASE book_and_trip;

USE book_and_trip;

-- create tables

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL, 
    name VARCHAR(50),
    created_at DATETIME DEFAULT NOW(),
	password_hash VARcHAR(100) UNIQUE,
    INDEX users_name (name)
    );

DROP TABLE IF EXISTS profiles; 
CREATE TABLE profiles (
	id SERIAL, 
	user_id BIGINT UNSIGNED NOT NULL,
    gender CHAR(1),
    birthday DATE,
    email VARCHAR(20) NOT NULL UNIQUE, 
    phone_num BIGINT UNSIGNED NOT NULL UNIQUE,
    address VARCHAR(50),
    status ENUM('1', '2', '3', '4', '5') COMMENT 'Feedback from admins',
    total_num_of_orders INT COMMENT 'How much orders have been made during all time',
    cur_orders BIGINT UNSIGNED COMMENT 'current order if exists',
	prof_image_id BIGINT UNSIGNED
);

DROP TABLE IF EXISTS hotels; 
CREATE TABLE hotels (
	id SERIAL,
	name VARCHAR(50),
	address VARCHAR(50),
    general_mark ENUM('1', '2', '3', '4', '5') COMMENT 'Num od stars',
    total_place_num INT COMMENT 'All apartments in hotel',
    free_place INT COMMENT 'Num of available apartments',
    hotel_image_id BIGINT UNSIGNED,
    created_at DATETIME DEFAULT NOW() COMMENT 'Add on the site'
);
    
DROP TABLE IF EXISTS apartments;
CREATE TABLE apartments (
	id SERIAL,
	hotel_id BIGINT UNSIGNED,
	num_of_people INT COMMENT 'How much people can live',
	price BIGINT,
	is_taken BOOL COMMENT '1 -- not available, 0 -- available',
	apart_image_id BIGINT UNSIGNED
);

DROP TABLE IF EXISTS orders; 
CREATE TABLE orders (
	id SERIAL,
	user_id BIGINT UNSIGNED,
	hotel_id BIGINT UNSIGNED,
	order_status ENUM('ended', 'is going'),
	apart_id BIGINT UNSIGNED,
	created_at DATETIME,
	ended_at DATETIME
);

DROP TABLE IF EXISTS reviews; 
CREATE TABLE reviews (
	id SERIAL,
	user_id BIGINT UNSIGNED,
	hotel_id BIGINT UNSIGNED,
	apart_id BIGINT UNSIGNED,
	order_id BIGINT UNSIGNED,
	review TEXT,
	grade ENUM('1', '2', '3', '4', '5'),
	created_at DATETIME
);

DROP TABLE IF EXISTS places;
CREATE TABLE places (
	id SERIAL,
	name VARCHAR(50),
	type_plc ENUM('park', 'museum', 'cafe', 'restaraunt', 'market'),
	avrg_price INT,
	grade ENUM('1', '2', '3', '4', '5') COMMENT 'Grade is made by users',
	address VARCHAR(50),
	plc_image_id BIGINT UNSIGNED
);
	
DROP TABLE IF EXISTS media;
CREATE TABLE media (
	id SERIAL,
	media_type VARCHAR(50),
	metadata JSON 
);
	
DROP TABLE IF EXISTS admins;
CREATE TABLE admins (
	id SERIAL,
	user_id BIGINT UNSIGNED,
	hotel_id BIGINT UNSIGNED
);

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL,
	from_user_id BIGINT UNSIGNED COMMENT 'conversation only beetwen user and admin',
	to_user_id BIGINT UNSIGNED,
	created_at DATETIME,
	message TEXT 
);

-- add foreign keys

ALTER TABLE profiles
	ADD CONSTRAINT fk_prof_user_id FOREIGN KEY (user_id) REFERENCES users(id),
	ADD CONSTRAINT fk_prof_media_id FOREIGN KEY (prof_image_id) REFERENCES media(id),
	ADD CONSTRAINT fk_prof_order_id FOREIGN KEY (cur_orders) REFERENCES orders(id);

ALTER TABLE places ADD CONSTRAINT fk_plc_media_id FOREIGN KEY (plc_image_id) REFERENCES media(id);

ALTER TABLE apartments 
	ADD CONSTRAINT fk_apart_media_id FOREIGN KEY (apart_image_id) REFERENCES media(id),
	ADD CONSTRAINT fk_apart_hotel_id FOREIGN KEY (hotel_id) REFERENCES hotels(id);

ALTER TABLE orders
	ADD CONSTRAINT fk_ord_user_id FOREIGN KEY (user_id) REFERENCES users(id),
	ADD CONSTRAINT fk_ord_prof_id FOREIGN KEY (hotel_id) REFERENCES hotels(id),
	ADD CONSTRAINT fk_ord_apart_id FOREIGN KEY (apart_id) REFERENCES apartments(id);

ALTER TABLE hotels ADD CONSTRAINT fk_hotel_media_id FOREIGN KEY (hotel_image_id) REFERENCES media(id);

ALTER TABLE reviews 
	ADD CONSTRAINT fk_rev_user_id FOREIGN KEY (user_id) REFERENCES users(id),
	ADD CONSTRAINT fk_rev_hotel_id FOREIGN KEY (hotel_id) REFERENCES hotels(id),
	ADD CONSTRAINT fk_rev_apart_id FOREIGN KEY (apart_id) REFERENCES apartments(id),
	ADD CONSTRAINT fk_rev_order_id FOREIGN KEY (order_id) REFERENCES orders(id);
	
ALTER TABLE admins 
	ADD CONSTRAINT fk_admin_user_id FOREIGN KEY (user_id) REFERENCES users(id),
	ADD CONSTRAINT fk_admin_hotel_id FOREIGN KEY (hotel_id) REFERENCES hotels(id);

ALTER TABLE messages 
	ADD CONSTRAINT fk_messg_fr_user_id FOREIGN KEY (from_user_id) REFERENCES users(id),
	ADD CONSTRAINT fk_messg_to_user_id FOREIGN KEY (to_user_id) REFERENCES users(id);



