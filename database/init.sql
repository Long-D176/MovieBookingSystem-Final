CREATE DATABASE IF NOT EXISTS movie_booking_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE movie_booking_db;

-- 1. CATALOG SERVICE
CREATE TABLE cinemas (
    cinema_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL
);

CREATE TABLE screens (
    screen_id INT AUTO_INCREMENT PRIMARY KEY,
    cinema_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    total_seats INT DEFAULT 0,
    FOREIGN KEY (cinema_id) REFERENCES cinemas(cinema_id) ON DELETE CASCADE
);

CREATE TABLE movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    duration_minutes INT NOT NULL,
    status ENUM('COMING_SOON', 'NOW_SHOWING', 'ENDED') DEFAULT 'COMING_SOON',
    poster_url VARCHAR(500)
);

CREATE TABLE showtimes (
    showtime_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT NOT NULL,
    screen_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    base_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    FOREIGN KEY (screen_id) REFERENCES screens(screen_id)
);

CREATE TABLE seat_types (
    seat_type_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    surcharge_rate DECIMAL(10, 2) DEFAULT 0.00
);

CREATE TABLE seats (
    seat_id INT AUTO_INCREMENT PRIMARY KEY,
    screen_id INT NOT NULL,
    seat_type_id INT NOT NULL,
    row_code CHAR(2) NOT NULL,
    seat_number INT NOT NULL,
    FOREIGN KEY (screen_id) REFERENCES screens(screen_id) ON DELETE CASCADE,
    FOREIGN KEY (seat_type_id) REFERENCES seat_types(seat_type_id),
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE concession_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- 2. IDENTITY & OTP
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('MEMBER', 'ADMIN', 'MANAGER', 'TICKET_CHECKER') DEFAULT 'MEMBER',
    is_verified BOOLEAN DEFAULT FALSE
);

CREATE TABLE otps (
    otp_id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(100) NOT NULL,
    otp_code VARCHAR(10) NOT NULL,
    expires_at DATETIME NOT NULL
);

-- 3. BOOKING & PAYMENT
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    showtime_id INT NOT NULL,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(11, 2) NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'CANCELLED') DEFAULT 'PENDING',
    payment_status ENUM('UNPAID', 'PAID', 'REFUNDED') DEFAULT 'UNPAID',
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (showtime_id) REFERENCES showtimes(showtime_id)
);

CREATE TABLE tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    seat_id INT NOT NULL,
    price DECIMAL(11, 2) NOT NULL,
    qr_code VARCHAR(255),
    is_used BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (seat_id) REFERENCES seats(seat_id)
);

CREATE TABLE booking_concessions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT DEFAULT 1,
    price DECIMAL(11, 2) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES concession_items(item_id)
);

CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    amount DECIMAL(11, 2) NOT NULL,
    transaction_type ENUM('PAYMENT', 'REFUND') NOT NULL,
    status ENUM('SUCCESS', 'FAILED', 'PENDING') DEFAULT 'PENDING',
    payment_method VARCHAR(50),
    gateway_ref_id VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

-- ====================================================
-- SEED DATA 
-- ====================================================

-- Rạp & Phòng
INSERT INTO cinemas (name, address) VALUES 
('CGV Aeon Mall', 'Tan Phu'), ('CGV Vincom', 'Quan 1'), 
('Galaxy Nguyen Du', 'Quan 1'), ('Lotte Cinema', 'Tan Binh'), ('BHD Star', 'Quan 10');

INSERT INTO screens (screen_id, cinema_id, name, total_seats) VALUES 
(1, 1, 'IMAX 1', 50), (2, 2, 'Gold 1', 50), (3, 3, 'Cinema 1', 50), (4, 4, 'Screen 5', 50), (5, 5, 'Hall 3', 50);

-- Loại ghế & Menu
INSERT INTO seat_types (name, surcharge_rate) VALUES ('Standard', 0), ('VIP', 20000), ('Couple', 40000);
INSERT INTO concession_items (name, price) VALUES ('Popcorn Caramel', 50000), ('Pepsi Large', 30000);

-- Phim
INSERT INTO movies (movie_id, title, duration_minutes, status, poster_url) VALUES 
(1, 'Godzilla x Kong: The New Empire', 115, 'NOW_SHOWING', 'https://image.tmdb.org/t/p/w500/tMefBSflR6PGQLv7WvFPpKLZkyk.jpg'),
(2, 'Dune: Part Two', 166, 'NOW_SHOWING', 'https://image.tmdb.org/t/p/w500/1pdfLvkbY9ohJlCjQH2CZjjYVvJ.jpg'),
(3, 'Kung Fu Panda 4', 94, 'NOW_SHOWING', 'https://image.tmdb.org/t/p/w500/kDp1vUBnMpe8ak4rjgl3cLELqjU.jpg'),
(4, 'Exhuma', 134, 'NOW_SHOWING', 'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSgK5PFmQ-0SEEh2Ap_q6NZOAGOB2CyBHfyNaJaVhY21tIUo78h');

-- Lịch chiếu 
INSERT INTO showtimes (showtime_id, movie_id, screen_id, start_time, base_price) VALUES 
(1, 1, 1, NOW(), 50000), 
(2, 2, 2, NOW(), 60000), 
(3, 3, 3, NOW(), 55000),
(4, 4, 4, NOW(), 50000), 
(5, 1, 5, NOW(), 70000); 

-- Screen 1
INSERT INTO seats (screen_id, seat_type_id, row_code, seat_number) VALUES 
(1,1,'A',1),(1,1,'A',2),(1,1,'A',3),(1,1,'A',4),(1,1,'A',5),(1,1,'A',6),(1,1,'A',7),(1,1,'A',8),(1,1,'A',9),(1,1,'A',10),
(1,1,'B',1),(1,1,'B',2),(1,1,'B',3),(1,1,'B',4),(1,1,'B',5),(1,1,'B',6),(1,1,'B',7),(1,1,'B',8),(1,1,'B',9),(1,1,'B',10),
(1,1,'C',1),(1,1,'C',2),(1,1,'C',3),(1,1,'C',4),(1,1,'C',5),(1,1,'C',6),(1,1,'C',7),(1,1,'C',8),(1,1,'C',9),(1,1,'C',10),
(1,1,'D',1),(1,1,'D',2),(1,1,'D',3),(1,1,'D',4),(1,1,'D',5),(1,1,'D',6),(1,1,'D',7),(1,1,'D',8),(1,1,'D',9),(1,1,'D',10),
(1,1,'E',1),(1,1,'E',2),(1,1,'E',3),(1,1,'E',4),(1,1,'E',5),(1,1,'E',6),(1,1,'E',7),(1,1,'E',8),(1,1,'E',9),(1,1,'E',10);

-- Screen 2 
INSERT INTO seats (screen_id, seat_type_id, row_code, seat_number) SELECT 2, seat_type_id, row_code, seat_number FROM seats WHERE screen_id = 1;

-- Screen 3
INSERT INTO seats (screen_id, seat_type_id, row_code, seat_number) SELECT 3, seat_type_id, row_code, seat_number FROM seats WHERE screen_id = 1;

-- Screen 4
INSERT INTO seats (screen_id, seat_type_id, row_code, seat_number) SELECT 4, seat_type_id, row_code, seat_number FROM seats WHERE screen_id = 1;

-- Screen 5
INSERT INTO seats (screen_id, seat_type_id, row_code, seat_number) SELECT 5, seat_type_id, row_code, seat_number FROM seats WHERE screen_id = 1;