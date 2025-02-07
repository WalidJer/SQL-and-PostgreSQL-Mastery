-----------------------Name:Walid Jerjawi------------------------
------------QAP2_DATABASE------Problem#1--Check the PDF file for Data outputs ----------------
-------------------------2025-02-04 -  2025-02-06---------------


-- Problem 1 - University Course Enrollment System

--Create Tables

-- Creating Students Table
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    school_enrollment_date DATE 
);

-- Creating Professors Table
CREATE TABLE professors (
    professor_id SERIAL PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    department TEXT
);

-- Creating Courses Table
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name TEXT,
    course_description TEXT,
    professor_id INT REFERENCES professors(professor_id)
);

-- Creating Enrollments Table
CREATE TABLE enrollments (
    student_id INT REFERENCES students(student_id),
    course_id INT REFERENCES courses(course_id),
    enrollment_date DATE,
    PRIMARY KEY (student_id, course_id)
);

-----------------------------------------------------------------------------------


--Insert Data

-- Inserting Students Data
INSERT INTO students (first_name, last_name, email, school_enrollment_date) VALUES
('Walid', 'Ali', 'walid.ali@example.com', '2024-04-20'),
('Sarah', 'William', 'sarah.william@example.com', '2024-02-07'),
('Jane', 'Dan', 'jane.dan@example.com', '2023-12-03'),
('Peter', 'John', 'peter.john@example.com', '2024-01-13');
('David', 'Smith', 'david.smith@example.com', '2023-11-17'),


-- Confirmation query
SELECT * FROM students;
-- Check PDF file for Data outputs


-- Inserting Professors Data
INSERT INTO professors (first_name, last_name, department) VALUES
('Matthew', 'Evan', 'Chemistry'),
('Noah', 'Smith', 'Physics');
('Kalid', 'Ahmed', 'Computer Science');
('Heather', 'Russel', 'Mathematics');

-- Confirmation query
SELECT * FROM professors;


-- Inserting Courses Data
INSERT INTO courses (course_name, course_description, professor_id) VALUES
    ('Chemistry 101', 'Introduction to Chemistry', 1),
    ('Physics 101', 'Introduction to Physics', 2),
    ('Math 201', 'Advanced Mathematics', (SELECT professor_id FROM professors WHERE first_name = 'Heather' AND last_name = 'Russel'));

-- Confirmation query
SELECT * FROM courses;


-- Inserting Enrollments Data
INSERT INTO enrollments (student_id, course_id, enrollment_date) VALUES
    ((SELECT student_id FROM students WHERE first_name = 'Walid' AND last_name = 'Ali'),
     (SELECT course_id FROM courses WHERE course_name = 'Chemistry 101'), '2024-05-15'),
    (2, 2, '2024-05-14'),
    (3, 1, '2025-05-06'),
    (4, 2, '2023-05-14'),
    ((SELECT student_id FROM students WHERE first_name = 'David' AND last_name = 'Smith'), 3, '2024-05-15');

SELECT * FROM enrollments;


-----------------------------------------------------------------------------------


 --1) SQL Queries
-- 1.1) Retrieve full names of all students enrolled in "Physics 101"
SELECT first_name || ' ' || last_name AS full_name
FROM students
JOIN enrollments ON students.student_id = enrollments.student_id
JOIN courses ON enrollments.course_id = courses.course_id
WHERE course_name = 'Physics 101';



-- 1.2) Retrieve a list of all courses along with the professor's full name who teaches each course
SELECT course_name, first_name || ' ' || last_name AS professor_full_name
FROM courses
JOIN professors ON courses.professor_id = professors.professor_id;



-- 1.3) Retrieve all courses that have students enrolled in them
SELECT DISTINCT course_name FROM courses 
JOIN enrollments ON courses.course_id = enrollments.course_id;

--------------------------------------------------------------------

--2) Update Data
-- Update a Student's Email
UPDATE students
SET email = 'walid.ali.newemail@example.com'
WHERE first_name = 'Walid' AND last_name = 'Ali';

-- Confirmation query
SELECT email FROM students Where first_name = 'Walid' AND last_name = 'Ali';


-----------------------------------------------------------------------

--3) Delete Data
-- Remove a Student from a Course
DELETE FROM enrollments
WHERE student_id = (SELECT student_id FROM students WHERE first_name = 'Sarah' AND last_name = 'William')
AND course_id = (SELECT course_id FROM courses WHERE course_name = 'Physics 101');

-- Confirmation query
SELECT * FROM enrollments;