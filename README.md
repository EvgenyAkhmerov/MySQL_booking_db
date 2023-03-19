# MySQL_booking_db

The project is database which is based on popular site booking.com. DB is called 'book and trip'

------------------------------------------------------------------------------------------------------------------------------------------------------

I. DB consists of 10 tables like as:

	1)  Users  	(id, name, created_at, password_hash) 

# users like as unit

	2)  Profiles  	(user_id, name, gender, birthday, email, phone_numb, address, status, total_num_of_orders, cur_orders, prof_image_id) 

# General information about user

	3)  Hotels 	(id, name, address, general_mark, total_place_num, free_place, hotel_image)	

# General information about hotels

	4)  Apartments	(id, hotel_id, num_of_people, price, is_taken, apart_image_id) 

# Apartments in the hotel and their status

	5)  Orders 	(id, user_id, hotel_id, order_status, apart_id, created_at, ended_at) 

# Orders made by users

	6)  Reviews	(id, user_id, hotel_id, apart_id, order_id, review, grade, created_at) 

# Reviews on the orders

	7)  Places	(id, name, type_plc, avrg_price, grade, address, plc_image_id) 

# Place like as cafe, museum, park, market and other same attraction

	8)  Media	(id, media_type, meta_data) 

# Photos of user profile, hotel, ...

	9)  Admins	(id, user_id, hotel_id) 

# Admins of hotel (he is also user)

	10) Messages	(id, from_user_id, to_user_id, created_at, message) 

# Messages between users and admins, NOT between users

------------------------------------------------------------------------------------------------------------------------------------------------------

II. Foreign keys

1) Profile

	Profiles.user_id -> Users.id
	Profiles.prof_image_id -> media.id
	Profiles.cur_orders -> Orders.user_id

2) Hotels

	Hotels.hotel_image -> media.id
	
4) Apartments

	Apartments.hotel_id -> Hotel.id
	Apartments.apart_image_id -> media.id

5) Orders

	Orders.user_id -> Users.id
	Orders.hotel_id -> Hotels.id
	Orders.apart_id -> Apartments.id

6) Review

	Review.user_id -> Users.id
	Review.hotel_id -> Hotels.id
	Review.apart_id -> Apartments.id
	Review.order_id -> Orders.id

7) Places

	Places.plc_image_id -> media.id

9) Admins

	Admins.user_id -> Users.id
	Admins.hotel_id -> Hotels.id

8) Messages 

	Messages.from_user_id -> Users.id
	Messages.to_user_id -> Users.id
