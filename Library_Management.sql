-- library_management_system.sql
-- This file contains SQL commands to set up and manage a simple library system.

-- -----------------------------------------------------------------------------
-- 1. DATABASE AND TABLE CREATION
-- -----------------------------------------------------------------------------

-- Create the database
CREATE DATABASE IF NOT EXISTS library_management_system;
USE library_management_system;

-- Table for Books
CREATE TABLE IF NOT EXISTS Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    publisher VARCHAR(255),
    publication_year INT,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    genre VARCHAR(100),
    total_copies INT NOT NULL,
    available_copies INT NOT NULL
);

-- Table for Members
CREATE TABLE IF NOT EXISTS Members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    join_date DATE NOT NULL
);

-- Table for Loans
CREATE TABLE IF NOT EXISTS Loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT,
    member_id INT,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- -----------------------------------------------------------------------------
-- 2. DATA INSERTION
-- -----------------------------------------------------------------------------

-- Insert data into the Books table
INSERT INTO Books (title, author, publisher, publication_year, isbn, genre, total_copies, available_copies) VALUES
('The Hitchhiker''s Guide to the Galaxy', 'Douglas Adams', 'Pan Books', 1979, '978-0345391803', 'Science Fiction', 5, 3),
('Pride and Prejudice', 'Jane Austen', 'T. Egerton, Whitehall', 1813, '978-0141439518', 'Classic', 8, 8),
('To Kill a Mockingbird', 'Harper Lee', 'J. B. Lippincott & Co.', 1960, '978-0061120084', 'Fiction', 10, 6),
('1984', 'George Orwell', 'Secker & Warburg', 1949, '978-0451524935', 'Dystopian', 7, 7);

-- Insert data into the Members table
INSERT INTO Members (first_name, last_name, email, phone_number, join_date) VALUES
('John', 'Doe', 'john.doe@email.com', '123-456-7890', '2023-01-15'),
('Jane', 'Smith', 'jane.smith@email.com', '987-654-3210', '2022-11-20'),
('Peter', 'Jones', 'peter.jones@email.com', '555-123-4567', '2023-02-01');

-- Insert data into the Loans table
INSERT INTO Loans (book_id, member_id, loan_date, due_date, return_date) VALUES
(1, 1, '2024-05-10', '2024-05-24', NULL),
(3, 2, '2024-05-05', '2024-05-19', '2024-05-18'),
(3, 3, '2024-05-12', '2024-05-26', NULL);

-- -----------------------------------------------------------------------------
-- 3. COMMON QUERIES
-- -----------------------------------------------------------------------------

-- Find all books by a specific author
SELECT * FROM Books WHERE author = 'Douglas Adams';

-- Find all books currently on loan
SELECT 
    b.title, 
    m.first_name, 
    m.last_name, 
    l.loan_date, 
    l.due_date
FROM Loans l
JOIN Books b ON l.book_id = b.book_id
JOIN Members m ON l.member_id = m.member_id
WHERE l.return_date IS NULL;

-- Find all books that are overdue
SELECT 
    b.title, 
    m.first_name, 
    m.last_name, 
    l.loan_date, 
    l.due_date
FROM Loans l
JOIN Books b ON l.book_id = b.book_id
JOIN Members m ON l.member_id = m.member_id
WHERE l.return_date IS NULL AND l.due_date < CURDATE();

-- Find a member's loan history (by email)
SELECT 
    b.title, 
    l.loan_date, 
    l.return_date
FROM Loans l
JOIN Books b ON l.book_id = b.book_id
WHERE l.member_id = (SELECT member_id FROM Members WHERE email = 'jane.smith@email.com');

-- Update the status of a returned book (example for a loan with loan_id = 1)
START TRANSACTION;

-- Mark the book as returned in the Loans table
UPDATE Loans
SET return_date = CURDATE()
WHERE loan_id = 1;

-- Increase the available copies in the Books table
UPDATE Books
SET available_copies = available_copies + 1
WHERE book_id = (SELECT book_id FROM Loans WHERE loan_id = 1);

COMMIT;

-- Find the most popular genres (by number of loans)
SELECT 
    b.genre, 
    COUNT(l.loan_id) AS total_loans
FROM Loans l
JOIN Books b ON l.book_id = b.book_id
GROUP BY b.genre
ORDER BY total_loans DESC;

-- Find members who haven't borrowed a book in the last 6 months
SELECT *
FROM Members m
LEFT JOIN (
    SELECT member_id, MAX(loan_date) AS last_loan_date
    FROM Loans
    GROUP BY member_id
) AS l ON m.member_id = l.member_id
WHERE l.last_loan_date IS NULL OR l.last_loan_date < CURDATE() - INTERVAL '6' MONTH;