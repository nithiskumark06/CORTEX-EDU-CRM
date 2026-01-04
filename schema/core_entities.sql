-- CORE ENTITIES --
-- DOMAIN: EDTECH ANALYTICS --


USE cortex_crms;


-- 1. STUDENTS --
CREATE TABLE students (
student_id INT AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name varchar(50) NOT NULL,
email varchar(50) UNIQUE NOT NULL,
phone BIGINT NOT NULL,
gender varchar(10) DEFAULT 'Unknown',
date_of_birth DATE,
country varchar(50),
is_active BOOLEAN DEFAULT TRUE,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- 2. INSTRUCTORS --
CREATE TABLE instructors(
instructor_id INT AUTO_INCREMENT PRIMARY KEY,
full_name VARCHAR(50) NOT NULL,
email VARCHAR(50) UNIQUE NOT NULL,
subject VARCHAR(100) NOT NULL,
experience_years INT,
salary_per_course DECIMAL(10,2) NOT NULL,
is_active BOOLEAN DEFAULT TRUE,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. COURSES --
CREATE TABLE courses(
course_id INT AUTO_INCREMENT PRIMARY KEY,
course_title VARCHAR(100) NOT NULL,
category VARCHAR(100) NOT NULL,
difficulty ENUM('Beginner', 'Intermediate', 'Advanced'),
price DECIMAL(10,2) NOT NULL,
instructor_id INT NOT NULL,
course_duration INT,
published_date DATE,
start_at DATE NOT NULL,

	FOREIGN KEY(instructor_id) REFERENCES instructors(instructor_id)
);

-- 4. ENROLLMENTS --
CREATE TABLE enrollments(
enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
student_id INT NOT NULL,
course_id INT NOT NULL,
is_certificate_applied BOOLEAN DEFAULT FALSE,
status ENUM('Enrolled', 'Completed', 'Droppped') DEFAULT 'Enrolled',


	FOREIGN KEY(student_id) REFERENCES students(student_id),
    FOREIGN KEY(course_id) REFERENCES courses(course_id)
);

-- 5. STUDENT PROGRESS --
CREATE TABLE student_progress(
progress_id INT AUTO_INCREMENT PRIMARY KEY,
student_id INT NOT NULL,
course_id INT NOT NULL,
progress_percent DECIMAL(5,2) CHECK (progress_percent BETWEEN 0 AND 100),
	
    FOREIGN KEY(student_id) REFERENCES students(student_id),
    FOREIGN KEY(course_id) REFERENCES courses(course_id)
);

-- 6. COURSE REVIEWS --
CREATE TABLE course_reviews(
review_id INT AUTO_INCREMENT PRIMARY KEY,
student_id INT NOT NULL,
course_id INT NOT NULL,
rating INT CHECK(rating BETWEEN 1 AND 10),
review TEXT,
review_date date,

	FOREIGN KEY(student_id) REFERENCES students(student_id),
    FOREIGN KEY(course_id) REFERENCES courses(course_id)
    
);

-- 7. SUBSCRIPTION PLANS --
CREATE TABLE subscription_plans(
plan_id INT AUTO_INCREMENT PRIMARY KEY,
plan_name VARCHAR(50) NOT NULL,
plan_price DECIMAL(10,2) NOT NULL,
plan_validity ENUM('Weekly', 'Monthly','Quarterly','Yearly') NOT NULL,
course_discount DECIMAL(5,2) DEFAULT 0.00,
free_certicates BOOLEAN DEFAULT FALSE
);

-- 8. STUDENT LOGINS --
CREATE TABLE logins (
login_id INT AUTO_INCREMENT PRIMARY KEY,   
student_id INT NOT NULL,                   
login_date DATETIME NOT NULL,              
device_type VARCHAR(50) DEFAULT 'web',    
ip_address VARCHAR(45),                    
location VARCHAR(100),                     
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
	
    FOREIGN KEY(student_id) REFERENCES students(student_id)
);
