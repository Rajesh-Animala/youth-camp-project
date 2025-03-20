CREATE DATABASE Youth_Summer_Camp;

-- Create Participants Table
CREATE TABLE Participants (
    ParticipantID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50),
    DateOfBirth DATE NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
    PersonalPhone VARCHAR(20) NOT NULL,
    INDEX (LastName, FirstName)  -- For faster name searches
) 

-- Create Camps Table
CREATE TABLE Camps (
    CampID INT PRIMARY KEY AUTO_INCREMENT,
    CampTitle VARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Capacity INT NOT NULL CHECK (Capacity > 0),
    CHECK (EndDate > StartDate)  -- Ensure valid date range
)

-- Create Visit Records Table
CREATE TABLE VisitRecords (
    VisitID INT PRIMARY KEY AUTO_INCREMENT,
    ParticipantID INT NOT NULL,
    CampID INT NOT NULL,
    VisitDate DATE NOT NULL DEFAULT (CURRENT_DATE),
    UNIQUE (ParticipantID, CampID, VisitDate)  -- Prevent duplicate visits
) 


SELECT * FROM camps;
camps_table

-- Insert a participant
INSERT INTO Participants (FirstName, LastName, DateOfBirth, Email, Gender, PersonalPhone)
VALUES ('Sarah', 'Smith', '2010-05-15', 'sarah@email.com', 'Female', '+1234567890');

-- Create a camp
INSERT INTO Camps (CampTitle, StartDate, EndDate, Price, Capacity)
VALUES ('Summer Coding Camp', '2024-07-01', '2024-07-14', 299.99, 50);

-- Record a visit
INSERT INTO VisitRecords (ParticipantID, CampID, VisitDate)
VALUES (1, 1, '2024-07-01');

visitrecords

ALTER TABLE Participants MODIFY PersonalPhone VARCHAR(30);

ALTER TABLE Participants DROP email;
ALTER TABLE Participants ADD email VARCHAR(100) NOT NULL;

SELECT * FROM participants;
SELECT * FROM Camps;




DELIMITER $$ 

CREATE PROCEDURE GenerateVisits() 
BEGIN 
    DECLARE total_camps INT DEFAULT 5; 
    DECLARE camp_id INT; 
    DECLARE participant_count INT DEFAULT 5001; 
    DECLARE i INT DEFAULT 1; 

    -- For regular participants (1-5 visits) 
    WHILE i <= 5000 DO 
        SET camp_id = 1; 
        WHILE camp_id <= total_camps DO 
            IF RAND() < 0.3 THEN 
                INSERT INTO visitrecords (VisitID,ParticipantID, CampID, VisitDate) 
                SELECT i, camp_id, DATE_ADD(StartDate, INTERVAL FLOOR(RAND() * DATEDIFF(EndDate, StartDate)) DAY) 
                FROM Camps WHERE CampID = camp_id; 
            END IF; 
            SET camp_id = camp_id + 1; 
        END WHILE; 
        SET i = i + 1; 
    END WHILE; 

    -- For Lakshmi (multiple visits across all camps) 
    SET camp_id = 1; 
    WHILE camp_id <= total_camps DO 
        INSERT INTO VisitRecords (VisitID,ParticipantID, CampID, VisitDate) 
        SELECT 5001, camp_id, DATE_ADD(StartDate, INTERVAL FLOOR(RAND() * DATEDIFF(EndDate, StartDate)) DAY) 
        FROM Camps WHERE CampID = camp_id; 
        SET camp_id = camp_id + 1; 
    END WHILE; 

    -- Add extra visits for Lakshmi 
    INSERT INTO VisitRecords (VisitID,ParticipantID, CampID, VisitDate) 
    VALUES 
    (1,5001, 1, '2021-06-05'), (1,5001, 1, '2021-06-10'), 
    (2,5001, 2, '2021-12-15'), (2,5001, 2, '2021-12-18'), 
    (3,5001, 3, '2022-06-05'), (3,5001, 3, '2022-06-10'), 
    (4,5001, 4, '2022-12-12'), (4,5001, 4, '2022-12-15'), 
    (5,5001, 5, '2023-06-05'), (5,5001, 5, '2023-06-10'); 

END$$ 

DELIMITER ;



SELECT * FROM visitrecords;


SELECT COUNT(*) AS VisitCount
FROM VisitRecords VR
JOIN Participants P ON VR.ParticipantID = P.ParticipantID
WHERE P.FirstName = 'Lakshmi'
  AND P.DateOfBirth BETWEEN DATE_SUB(CURDATE(), INTERVAL 19 YEAR) 
                        AND DATE_SUB(CURDATE(), INTERVAL 13 YEAR)
  AND VR.VisitDate >= DATE_SUB(CURDATE(), INTERVAL 3 YEAR);

insert INTO visitrecords VALUES(501, 110000,50001,"2023-04-27");
