
-- Hospital Management System SQL Script

-- Drop tables if they already exist
DROP TABLE IF EXISTS Appointments, MedicalRecords, Patients, Doctors, Departments;

-- Departments Table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL,
    Location VARCHAR(100)
);

-- Doctors Table
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Specialization VARCHAR(100),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Patients Table
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    DOB DATE,
    Gender VARCHAR(10),
    Phone VARCHAR(15),
    Address VARCHAR(255)
);

-- Appointments Table
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATE,
    AppointmentTime TIME,
    Reason VARCHAR(255),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Medical Records Table
CREATE TABLE MedicalRecords (
    RecordID INT PRIMARY KEY,
    PatientID INT,
    Diagnosis VARCHAR(255),
    Treatment VARCHAR(255),
    RecordDate DATE,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- Sample Data for Departments
INSERT INTO Departments VALUES
(1, 'Cardiology', 'Block A'),
(2, 'Neurology', 'Block B'),
(3, 'Orthopedics', 'Block C');

-- Sample Data for Doctors
INSERT INTO Doctors VALUES
(101, 'Dr. Smith', 'Cardiologist', '9876543210', 'smith@hospital.com', 1),
(102, 'Dr. Johnson', 'Neurologist', '9876543211', 'johnson@hospital.com', 2),
(103, 'Dr. Lee', 'Orthopedic', '9876543212', 'lee@hospital.com', 3);

-- Sample Data for Patients
INSERT INTO Patients VALUES
(201, 'Alice Brown', '1985-03-15', 'Female', '9123456780', '123 Main St'),
(202, 'Bob White', '1990-07-20', 'Male', '9234567890', '456 Oak Ave');

-- Sample Data for Appointments
INSERT INTO Appointments VALUES
(301, 201, 101, '2025-08-15', '10:00:00', 'Regular Checkup'),
(302, 202, 102, '2025-08-16', '11:30:00', 'Headache');

-- Sample Data for Medical Records
INSERT INTO MedicalRecords VALUES
(401, 201, 'Hypertension', 'Medication', '2025-08-10'),
(402, 202, 'Migraine', 'Pain Relievers', '2025-08-11');
