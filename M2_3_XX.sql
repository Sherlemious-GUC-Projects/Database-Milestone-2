--2.1.1 create database
create database Advising_Team_127;
Go
use Advising_Team_127;
Go

--2.1.2 procedure to create tables
create proc CreateAllTables
as
create table Advisor(
	advisor_id int identity(0,1) primary key,
	name varchar(40),
	email varchar(40),
	office varchar(40),
	password varchar(40),
);
create table Student
(
	student_id int primary key identity(0,1),
	f_name varchar(40),
	l_name varchar(40),
	gpa decimal(3,2),
	faculty varchar(40),
	email varchar(40),
	major varchar(40),
	password varchar(40),
	financial_status bit,
	semester int,
	aqcuired_hours int,
	assigned_hours int,
	advisor_id int
	foreign key(advisor_id) references Advisor(advisor_id)
);
create table Student_Phone(
	student_id int,
	phone_number varchar(40),
	primary key(student_id, phone_number),
	foreign key(student_id) references Student(student_id),
);	
create table Course(
	course_id int primary key identity(0,1),
	name varchar(40),
	major varchar(40),
	is_offered bit,
	credit_hours int,
	semester int,
);
create table preqCourse_course(
	course_id int,
	prequisite_Course_id int,
	primary key(course_id, prequisite_Course_id),
	foreign key(course_id) references Course(course_id),
	foreign key(prequisite_Course_id) references Course(course_id),
);
create table Instructor
(
	instructor_id int primary key identity(0,1),
	name varchar(40),
	email varchar(40),
	faculty varchar(40),
	office varchar(40),
);
create table Instructor_Course(
	instructor_id int,
	course_id int,
	primary key(instructor_id, course_id),
	foreign key(instructor_id) references Instructor(instructor_id),
	foreign key(course_id) references Course(course_id)
);
create table Student_Instructor_Course_Take(
	student_id int,
	course_id int,
	instructor_id int,
	semester_code varchar(40),
	exam_type varchar(40) default 'Normal',
	grade varchar(40),
	primary key(student_id, course_id, semester_code),
	foreign key(student_id) references Student(student_id),
	foreign key(instructor_id) references Instructor(instructor_id) ,
	foreign key(course_id) references Course(course_id) 
);
create table Semester(
	semester_code varchar(40) primary key,
	start_date date,
	end_date date,
);
create table Course_Semester(
	course_id int,
	semester_code varchar(40),
	primary key(course_id, semester_code),
	foreign key(course_id) references Course(course_id),
	foreign key(semester_code) references Semester(semester_code),
);
create table Slot(
	slot_id int primary key identity(0,1),
	day varchar(40),
	time varchar(40),
	location varchar(40),
	course_id int,
	instructor_id int,
	foreign key(instructor_id) references Instructor(instructor_id),
	foreign key(course_id) references Course(course_id)
);
create table Graduation_Plan(
	plan_id int identity(0,1),
	semster_code varchar(40),
	semester_credit_hours int,
	expected_grad_date date,
	advisor_id int,
	student_id int,
	primary key(plan_id, semster_code),
	foreign key(advisor_id) references Advisor(advisor_id),
	foreign key(student_id) references Student(student_id),
);
create table GradPlan_Course(
	plan_id int,
	semester_code varchar(40),
	course_id int,
	primary key(plan_id, course_id, semester_code),
	foreign key(semester_code) references Semester(semester_code)
);
create table Request(
	request_id int primary key identity(0,1),
	type varchar(40),
	comment varchar(40),
	status varchar(40) default 'pending',
	credit_hours int,
	student_id int,
	advisor_id int,
	course_id int,
	foreign key(student_id) references Student(student_id),
	foreign key(advisor_id) references Advisor(advisor_id),
	foreign key(course_id) references Course(course_id)
);
create table MakeUpExam(
    exam_id int primary key identity(0,1),
    date datetime,
	type varchar(40),
	course_id int,
	foreign key(course_id) references Course(course_id)
);
create table Exam_student(
	exam_id int,
	student_id int,
	course_id int,
	primary key(exam_id, student_id),
	foreign key(exam_id) references MakeUpExam(exam_id),
	foreign key(student_id) references Student(student_id)
);
create table Payment(
	payment_id int primary key identity(0,1),
	amount int,
	deadline datetime,
	n_installments int,
	status varchar(40) default 'notPaid',
	fund_percent decimal(5,2),
	start_date datetime,
	student_id int,
	semster_code varchar(40),
	foreign key(student_id) references Student(student_id),
	foreign key(semster_code) references Semester(semester_code)
);
create table Installment(
	payment_id int,
	deadline datetime,
	amount int,
	status varchar(40),
	start_date datetime,
	primary key(payment_id , deadline),
	foreign key(payment_id) references Payment(payment_id)
);
GO

--2.1.3 procedure to drop tables
create proc DropAllTables
as
drop table if Exists Student_Phone;
drop table if Exists preqCourse_course;
drop table if Exists Instructor_Course;	
drop table if Exists Student_Instructor_Course_Take;
drop table if Exists Course_Semester;
drop table if Exists GradPlan_Course;
drop table if Exists Exam_student;
drop table if Exists Installment;
drop table if Exists Slot;
drop table if Exists Graduation_Plan;
drop table if Exists Request;
drop table if Exists Payment;
drop table if Exists MakeUpExam;
drop table if Exists Student;
drop table if Exists Course;
drop table if Exists Instructor;
drop table if Exists Semester;
drop table if Exists Advisor;
GO

--2.1.4 procedure to clear tables
create proc clearAllTables
as
delete from Student_Phone;
delete from preqCourse_course;
delete from Instructor_Course;
delete from Student_Instructor_Course_Take;
delete from Course_Semester;
delete from GradPlan_Course;
delete from Exam_student;
delete from Installment;
delete from Slot;
delete from Graduation_Plan;
delete from Request;
delete from MakeUpExam;
delete from Student;
delete from Course;
delete from Instructor;
delete from Semester;
delete from Advisor;
delete from Payment;
GO

Exec CreateAllTables;
GO

Exec DropAllTables;
GO

Exec clearAllTables;
GO

--- ~~~~ ---

-- AA) Student Login using username and password.
-- i. Type: Scalar Function
-- ii. Name: FN_StudentLogin
-- iii. Input: Student ID int, password varchar (40)
-- iv. Output: Success bit

create proc FN_StudentLogin
	@StudentID int,
	@password varchar(40)
as
begin
	if exists (select * from Student where StudentID = @StudentID and password = @password)
		return 1
	return 0
end

-- BB) Add Student mobile number(s)
-- i. Type: Stored Procedure
-- ii. Name: Procedures_StudentaddMobile
-- iii. Input: StudentID int, mobile_number varchar (40)
-- iv. Output: Nothing

create proc Procedures_StudentaddMobile
	@StudentID int,
	@mobile_number varchar(40)
as
begin
	if exists (select * from Student where StudentID = @StudentID)
		insert into Student_Phone values (@StudentID, @mobile_number)
end

-- CC) View available courses in the current semester
-- i. Type: TVFunction
-- ii. Name: FN_SemsterAvailableCourses
-- iii. Input: semster_code varchar (40)
-- iv. Output: Table of available courses within the semester

create function FN_SemsterAvailableCourses
	(@semster_code varchar(40))
returns table
as
return
(
	select * from Course_Semester where semster_code = @semster_code
)

-- DD) Sending course’s request
-- i. Type: Stored Procedure
-- ii. Name: Procedures_StudentSendingCourseRequest
-- iii. Input: Student ID int, course ID int, type varchar (40), and
-- comment varchar (40)
-- iv. Output: Nothing

create proc Procedures_StudentSendingCourseRequest
	@StudentID int,
	@courseID int,
	@type varchar(40),
	@comment varchar(40)
as
begin
	if exists (select * from Student where StudentID = @StudentID)
		insert into Request values (@type, @comment, 'pending', null, @StudentID, null, @courseID)
end

-- EE) Sending extra credit hours’ request
-- i. Type: Stored Procedure
-- ii. Name: Procedures_StudentSendingCHRequest
-- iii. Input: Student ID int, credit hours int, type varchar (40),
-- and comment varchar (40)
-- iv. Output: Nothing

create proc Procedures_StudentSendingCHRequest
	@StudentID int,
	@credit_hours int,
	@type varchar(40),
	@comment varchar(40)
as
begin
	if exists (select * from Student where StudentID = @StudentID)
		insert into Request values (@type, @comment, 'pending', null, @StudentID, @credit_hours, null)
end

-- FF) View graduation plan along with the assigned courses
-- i. Type: TVFunction
-- ii. Name: FN_StudentViewGP
-- iii. Input: student_ID int
-- iv. Output: Table (Student Id, Student_name, graduation Plan
-- Id, Course id, Course name, Semester code, expected
-- graduation date, Semester credit hours, advisor id)

create function FN_StudentViewGP
	(@student_ID int)
returns table
as
return
(
	select * from GradPlan_Course, Graduation_Plan, Course_Semester, Student
	where GradPlan_Course.graduation_plan_id = Graduation_Plan.graduation_plan_id
	and Graduation_Plan.student_id = Student.student_id
	and GradPlan_Course.course_id = Course_Semester.course_id
	and GradPlan_Course.semster_code = Course_Semester.semster_code
	and Student.student_id = @student_ID
)

-- GG) Student view his first not paid installment deadline
-- i. Type: Scalar Function
-- ii. Name: FN_StudentUpcoming_installment
-- iii. Input: StudentID int
-- iv. Output: deadline date of first not paid installment

create function FN_StudentUpcoming_installment
	(@StudentID int)
returns date
as
begin
	return (select top 1 deadline from Installment where StudentID = @StudentID and paid = 0 order by deadline)
end

-- HH) View slots of certain course that is taught by a certain instructor
-- i. Type: TVFunction
-- ii. Name: FN_StudentViewSlot
-- iii. Input: CourseID int, InstructorID int
-- iv. Output: table of slots’ details (Slot ID, location, time, day)
-- with course name and Instructor name

create function FN_StudentViewSlot
	(@CourseID int, @InstructorID int)
returns table
as
return
(
	select * from Slot, Instructor_Course, Instructor, Course
	where Slot.slot_id = Instructor_Course.slot_id
	and Instructor_Course.instructor_id = Instructor.instructor_id
	and Instructor_Course.course_id = Course.course_id
	and Course.course_id = @CourseID
	and Instructor.instructor_id = @InstructorID
)

-- II) Register for first makeup exam {refer to eligibility section (2.4.1) in
-- Milestone 1}
-- i. Type: Stored Procedure
-- ii. Name: Procedures_StudentRegisterFirstMakeup
-- iii. Input: StudentID int, courseID int, studentCurrent semester
-- varchar (40)
-- iv. Output: Nothing

create proc Procedures_StudentRegisterFirstMakeup
	@StudentID int,
	@courseID int,
	@studentCurrent varchar(40)
as
begin
	if exists (select * from Student where StudentID = @StudentID)
		insert into Makeup_Exam values (@StudentID, @courseID, @studentCurrent, null, null, null, null)
end


-- JJ) Second makeup Eligibility Check {refer to eligibility section (2.4.1) in the
-- description}
-- i. Type: Scalar Function
-- ii. Name: FN_StudentCheckSMEligiability
-- iii. Input: CourseID int, Student ID int
-- iv. Output: Eligible bit {0 → not eligible, 1 → eligible}

create function FN_StudentCheckSMEligiability
	(@CourseID int, @StudentID int)
returns bit
as
begin
	return (select count(*) from Makeup_Exam where StudentID = @StudentID and course_id = @CourseID and makeup_type = 'second' and status = 'pending')
end

-- KK) Register for 2nd makeup exam {refer to eligibility section (2.4.1) in the
-- description}
-- i. Type: Stored Procedure
-- ii. Name: Procedures_StudentRegisterSecondMakeup
-- iii. Input: StudentID int, courseID int, Student Current
-- Semester Varchar (40)
-- iv. Output: Nothing

create proc Procedures_StudentRegisterSecondMakeup
	@StudentID int,
	@courseID int,
	@studentCurrent varchar(40)
as
begin
	if exists (select * from Student where StudentID = @StudentID)
		insert into Makeup_Exam values (@StudentID, @courseID, @studentCurrent, null, null, null, null)
end

-- LL) View required courses
-- i. Type: Stored Procedure
-- ii. Name: Procedures_ViewRequiredCourses
-- iii. Input: StudentID int, Current semester code Varchar (40)
-- iv. Output: Table of the required courses’ details.

create proc Procedures_ViewRequiredCourses
	@StudentID int,
	@CurrentSemester varchar(40)
as
begin
	select * from Course_Semester, Student, Graduation_Plan, GradPlan_Course
	where Course_Semester.course_id = GradPlan_Course.course_id
	and Course_Semester.semster_code = GradPlan_Course.semster_code
	and GradPlan_Course.graduation_plan_id = Graduation_Plan.graduation_plan_id
	and Graduation_Plan.student_id = Student.student_id
	and Student.student_id = @StudentID
	and Course_Semester.semster_code = @CurrentSemester
	and Course_Semester.type = 'required'
end

-- MM) View optional courses
-- i. Type: Stored Procedure
-- ii. Name: Procedures_ViewOptionalCourse
-- iii. Input: StudentID int, Current semester code Varchar (40)
-- iv. Output: Table of the optional courses’ details.

create proc Procedures_ViewOptionalCourse
	@StudentID int,
	@CurrentSemester varchar(40)
as
begin
	select * from Course_Semester, Student, Graduation_Plan, GradPlan_Course
	where Course_Semester.course_id = GradPlan_Course.course_id
	and Course_Semester.semster_code = GradPlan_Course.semster_code
	and GradPlan_Course.graduation_plan_id = Graduation_Plan.graduation_plan_id
	and Graduation_Plan.student_id = Student.student_id
	and Student.student_id = @StudentID
	and Course_Semester.semster_code = @CurrentSemester
	and Course_Semester.type = 'optional'
end

-- NN) View missing/remaining courses to specific student.
-- i. Type: Stored Procedure
-- ii. Name: Procedures_ViewMS
-- iii. Input: StudentID int
-- iv. Output: Table of missing courses’ details

create proc Procedures_ViewMS
	@StudentID int
as
begin
	select * from Course_Semester, Student, Graduation_Plan, GradPlan_Course
	where Course_Semester.course_id = GradPlan_Course.course_id
	and Course_Semester.semster_code = GradPlan_Course.semster_code
	and GradPlan_Course.graduation_plan_id = Graduation_Plan.graduation_plan_id
	and Graduation_Plan.student_id = Student.student_id
	and Student.student_id = @StudentID
	and Course_Semester.type = 'required'
	and Course_Semester.semster_code not in (select Course_Semester.semster_code from Course_Semester, Student, Graduation_Plan, GradPlan_Course
	where Course_Semester.course_id = GradPlan_Course.course_id
	and Course_Semester.semster_code = GradPlan_Course.semster_code
	and GradPlan_Course.graduation_plan_id = Graduation_Plan.graduation_plan_id
	and Graduation_Plan.student_id = Student.student_id
	and Student.student_id = @StudentID
	and Course_Semester.type = 'taken')
end

-- OO) Choose instructor for a certain selected course.
-- i. Type: Stored Procedure
-- ii. Name: Procedures_ChooseInstructor
-- iii. Input: Student ID int, Instructor ID int, Course ID int,
-- current_semester_code varchar(40)
-- iv. Output: nothing

create proc Procedures_ChooseInstructor
	@StudentID int,
	@InstructorID int,
	@CourseID int,
	@CurrentSemester varchar(40)
as
begin
	if exists (select * from Student where StudentID = @StudentID)
		insert into Instructor_Course values (@InstructorID, @CourseID, @CurrentSemester)
end
