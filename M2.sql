-- A
Create Procedure Procedures_StudentRegistration
@first_name varchar(40),
@last_name varchar(40),
@password varchar(40),
@faculty varchar(40),
@email varchar(40),
@major varchar(40),
@semester int,
@student_id int Output
As
Insert Into Student(f_name, l_name, password, faculty, email, semester)
Values(@first_name, @last_name, @password, @faculty, @email, @major, @semester)
GO;
--B
Create Procedure Procedures_AdminListStudents
@advisor_name varchar(40),
@password varchar(40),
@email varchar(40),
@office varchar(40),
@advisor_id int Output
As
Insert Into Advisor(name, email, office, password)
Values(@advisor_name, @email, @office, @password)
GO;

--C
Create Procedure Procedures_AdminListStudents
As
Select s.* From Student s
Inner Join Advisor a On s.advisor_id = a.advisor_id
GO;

--D
Create Procedure Procedures_AdminListAdvisors
As
Select * From Advisor
GO;

--E
Create Procedure AdminListStudentsWithAdvisors
As
Select s.*, a.name From Student s
Inner Join Advisor a On s.advisor_id = a.advisor_id
GO;
--msh mota2ked menha

--F
Create Procedure AdminAddingSemester
@start_date date,
@end_date date,
@semester_code int
As
Insert Into Semester(semester_code, start_date, end_date)
Values(@semester_code, @start_date, @end_date)
GO;

--G
Create Procedure Procedures_AdminAddingCourse
@major varchar (40),
@semester int,
@credit_hours int,
@course_name varchar (40),
@offered bit
As
Insert Into Course(name, major, is_offered, credit_hours, semester)
Values(@course_name, @major, @offered, @credit_hours, @semester)
GO;

--H
Create Procedure Procedures_AdminLinkInstructor
@InstructorID int,
@CourseID int,
@slotID int
As
Update Slot
Set 
Slot.instructor_id = @InstructorID,
Slot.course_id = @CourseID
Where Slot.slot_id = @slotID
GO;

--I
Create Procedure Procedures_AdminLinkStudent
@Instructor_ID int,
@student_ID int,
@course_ID int,
@semester_code varchar(40)
As 
Update Student_Instructor_Course_Take
Set 
Student_Instructor_Course_Take.student_id = @student_ID,
Student_Instructor_Course_Take.course_id = @course_ID,
Student_Instructor_Course_Take.semester_code = @semester_code
Where Student_Instructor_Course_Take.instructor_id = @Instructor_ID
GO;

--J
Create Procedure Procedures_AdminLinkStudentToAdvisor
@studentID int,
@advisorID int
As
Update Student
Set
Student.student_id = @studentID,
Student.advisor_id = @advisorID
GO;

--K
Create Procedure Procedures_AdminAddExam
@Type varchar (40),
@date datetime,
@courseID int
As
Insert Into MakeUpExam(type, date, course_id)
Values(@TYPE, @date, @courseID)
GO;

--O
Create Procedure all_Pending_Requests
As
Select * From Request
Where Request.status = 'pending'
GO;

--S
Create Procedure Procedures_AdvisorAddCourseGP
@student_id int,
@Semester_code varchar (40),
@course_name varchar (40)
As
--ba3den

--T
Create Procedure Procedures_AdvisorUpdateGP
@expected_grad_semster varchar (40),
@studentID int
As


