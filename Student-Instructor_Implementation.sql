CREATE DATABASE student_instructor;

USE student_instructor;

-- student
CREATE TABLE STUDENT (
    StudentID VARCHAR(4) PRIMARY KEY NOT NULL,
    Lastname VARCHAR(128) NOT NULL,
    Firstname VARCHAR(128) NOT NULL,
    Address VARCHAR(128) NOT NULL,
    City VARCHAR(64) NOT NULL,
    State VARCHAR(12) NOT NULL,
    Zip INT NOT NULL,
    Enroll_Date DATE NOT NULL,
    `UnderGrad?` VARCHAR(12)
);

insert into STUDENT values ('0103', "O'Casey", 'Harnet', '4088 Ottumwa Way', 'Lexington', 'KY', 40515, '1997-08-25', 'Yes' ),
("0122", "Logan", 'Janet', ' 860 Charleston ST', 'Lexington', 'MA', 55500, '1998-01-19', 'No' ),
("0123", "Hagen", 'Greg', '6065 Rainbow Falls RD.', 'SpringField','MO', 65803, '1997-06-10', 'Yes'),
("0139", "Carroll", 'Pat', '4018 Landers Lane', 'Lafayette', 'CO', 84548,'1997-08-25', 'Yes'),
("0148", "Wolf", 'Bee', '1775 Bear Trail', 'Cincinnati', 'OH', 45208, '1998-01-19', 'Yes'),
("0167", "Krumpie", 'Scott', '580 E Main ST', 'Lexington', 'KY', 40506-0034, '1997-08-25', 'No'),
("0171", "Harvey", 'Elliot', '34 Kerry DR', 'El Mano', 'CO', 80646,'1997-08-25', 'Yes'),
("0181", "Zygote", 'Carrie', '8607 Ferndale St', 'Grenoble', 'CA', 91360-4260, '1997-08-25', 'Yes'),
("0194", "Loftus", 'Abner', '8077 Montana Place', 'Big Fish Bay', 'WI', 53717, '1998-01-19', 'Yes'),
("0251", "Grainger", 'John', '2256 N Sante Fe DR', 'Illiase', 'CA', 91210, '1998-01-19', 'Yes');
SELECT 
    *
FROM
    STUDENT;

-- instructor
CREATE TABLE Instructor (
    InstName VARCHAR(128) PRIMARY KEY NOT NULL,
    InstOffice VARCHAR(32) NOT NULL,
    `Rank` VARCHAR(64) NOT NULL
);
insert INTO INSTRUCTOR VALUES("Lujan","BE109","Assistant"),
("Morris","BE110","Full"),
("Presley","BE144","Associate"),
("Wilke","BE220","Full");
SELECT 
    *
FROM
    Instructor;

-- course
CREATE TABLE course (
    CourseID VARCHAR(12) PRIMARY KEY,
    Title VARCHAR(128) NOT NULL,
    CrHour INT NOT NULL,
    InstName VARCHAR(128),
    FOREIGN KEY (InstName)
        REFERENCES Instructor (InstName)
); 

insert into COURSE values( 'DIS 110', 'Intro to DOS', 2, 'Lujan'),
( 'DIS 118', 'Microcomputer Applications', 3, 'Wilke'),
( 'DIS 138', 'Intro to Windows', 2, 'Lujan'),
( 'DIS 140', 'Intro to Database/Access', 3, 'Presley'),
( 'DIS 150', 'Intro to Spreadsheet/Excel', 2, 'Morris');
SELECT 
    *
FROM
    COURSE;

-- Take 
CREATE TABLE Take (
    StudentID VARCHAR(4),
    CourseID VARCHAR(12),
    Grade VARCHAR(1),
    PRIMARY KEY (STUDENTID , COURSEID),
    FOREIGN KEY (StudentID)
        REFERENCES STUDENT (StudentID),
    FOREIGN KEY (CourseID)
        REFERENCES COURSE (CourseID)
);

insert into TAKE values( '0103', 'DIS 110', 'A'), 
( "0103", 'DIS 118', 'B'),
( '0122', 'DIS 118', 'A'),
( '0122', 'DIS 138', 'C'), 
( '0122', 'DIS 140', 'C'),
( '0123', 'DIS 110', 'D'), 
( '0123', 'DIS 140', 'E'),
( '0148', 'DIS 140', 'A'), 
( '0148', 'DIS 150', 'B'), 
( '0167', 'DIS 138', 'C'),
( '0167', 'DIS 140', 'C'), 
( '0167', 'DIS 150', 'B'),
( '0181', 'DIS 118', 'A'),
( '0181', 'DIS 140', 'A'), 
( '0181', 'DIS 150', 'D');

SELECT 
    *
FROM
    TAKE;
    
 -- procedure   
DELIMITER $$
CREATE PROCEDURE getStudent()
BEGIN
   SELECT Firstname, Lastname,
           Title, Grade
   FROM Course
   INNER JOIN Take 
       USING (courseid)
   INNER JOIN student 
       USING (studentid)
   WHERE CrHour >= 3;
END $$
DELIMITER ;
call getStudent();

-- function
DELIMITER $$
CREATE FUNCTION timeSpan(studentid VARCHAR(4))
RETURNS INTEGER
READS SQL DATA
BEGIN
   DECLARE span DECIMAL(9, 2);
   DECLARE enroll_date DATE;
   SELECT s.enroll_date
   INTO enroll_date
   FROM student s
   WHERE s.studentid = studentid;
  
   SET span = DATEDIFF(NOW(), enroll_date);
   RETURN span;
END $$
DELIMITER ;
SELECT timeSpan('0103');

-- updated grades
CREATE TABLE updated_grades (
    StudentID VARCHAR(4),
    CourseID VARCHAR(7),
    old_grades VARCHAR(1),
    new_grades VARCHAR(1),
    date_updated DATE,
    PRIMARY KEY (studentid , courseid)
);

--  TRIGGER
DELIMITER $$
CREATE TRIGGER grades_afterUpdate
AFTER UPDATE ON Take
FOR EACH ROW
BEGIN
   INSERT INTO updated_grades
   VALUES
   (
       NEW.StudentID,
       NEW.CourseID,
       OLD.Grade,
       NEW.Grade,
       NOW()
   );
END $$
DELIMITER ;

UPDATE TAKE SET GRADE = "F" WHERE STUDENTID = "0148";
select * From updated_grades;