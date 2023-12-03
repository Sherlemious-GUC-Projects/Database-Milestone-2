--- ~~~~~~~~~~ ---
-- ~~~~ 2.1 ~~~ --
--- ~~~~~~~~~~ ---

--2.1.1 create database
create database Advising_Team_127;
create database test1;
Go
use Advising_Team_127;
Go

--2.1.2 procedure to create tables
create proc CreateAllTables
as
create table Advisor(
	advisor_id int identity(1,1) primary key,
	name varchar(40),
	email varchar(40),
	office varchar(40),
	password varchar(40),
);
create table Student
(
	student_id int primary key identity(1,1),
	f_name varchar(40),
	l_name varchar(40),
	gpa decimal(3,2),
	faculty varchar(40),
	email varchar(40),
	major varchar(40),
	password varchar(40),
	financial_status bit,
	semester int,
	acquired_hours int,
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
	course_id int primary key identity(1,1),
	name varchar(40),
	major varchar(40),
	is_offered bit,
	credit_hours int,
	semester int,
);
create table preqCourse_course(
	course_id int,
	prerequisite_Course_id int,
	primary key(course_id, prerequisite_Course_id),
	foreign key(course_id) references Course(course_id),
	foreign key(prerequisite_Course_id) references Course(course_id),
);
create table Instructor
(
	instructor_id int primary key identity(1,1),
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
	slot_id int primary key identity(1,1),
	day varchar(40),
	time varchar(40),
	location varchar(40),
	course_id int,
	instructor_id int,
	foreign key(instructor_id) references Instructor(instructor_id),
	foreign key(course_id) references Course(course_id)
);
create table Graduation_Plan(
	plan_id int identity(1,1),
	semester_code varchar(40),
	semester_credit_hours int,
	expected_grad_date date,
	advisor_id int,
	student_id int,
	primary key(plan_id, semester_code),
	foreign key(advisor_id) references Advisor(advisor_id),
	foreign key(student_id) references Student(student_id),
);
create table GradPlan_Course(
	plan_id int,
	semester_code varchar(40),
	course_id int,
	primary key(plan_id, course_id, semester_code),
	foreign key(plan_id ,semester_code) references Graduation_plan(plan_id ,semester_code)
);
create table Request(
	request_id int primary key identity(1,1),
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
create table MakeUp_Exam(
    exam_id int primary key identity(1,1),
    date datetime,
	type varchar(40) ,
	course_id int,
	foreign key(course_id) references Course(course_id)
);
create table Exam_student(
	exam_id int,
	student_id int,
	course_id int,
	primary key(exam_id, student_id),
	foreign key(exam_id) references MakeUp_Exam(exam_id),
	foreign key(student_id) references Student(student_id)
);
create table Payment(
	payment_id int primary key identity(1,1),
	amount int,
	deadline datetime,
	n_installments int,
	status varchar(40) default 'notPaid',
	fund_percentage decimal(5,2),
	start_date datetime,
	student_id int,
	semester_code varchar(40),
	foreign key(student_id) references Student(student_id),
	foreign key(semester_code) references Semester(semester_code)
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
drop table if Exists MakeUp_Exam;
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
delete from Payment;
delete from MakeUp_Exam;
delete from Student;
delete from Course;
delete from Instructor;
delete from Semester;
delete from Advisor;


--- ~~~~~~~~~~ ---
-- ~~~~ 2.2 ~~~ --
--- ~~~~~~~~~~ ---

--2.2

-- A) Fetch details for all Active students.
GO
CREATE VIEW view_Students AS
SELECT *
FROM Student
WHERE financial_status = 1;
GO


-- B) Fetch details for all courses with their prerequisites
GO
CREATE VIEW view_Course_prerequisites AS
SELECT
    C.*,
    P.prerequisite_Course_id AS prerequisite_course_id
FROM Course C
LEFT JOIN preqCourse_course P ON C.course_id = P.course_id;
GO


-- C) Fetch details for all Instructors along with their assigned courses
GO
CREATE VIEW Instructors_AssignedCourses AS
SELECT
    I.*,
    C.course_id AS assigned_course_id,
    C.name AS assigned_course_name
FROM Instructor I
LEFT JOIN Instructor_Course IC ON I.instructor_id = IC.instructor_id
LEFT JOIN Course C ON IC.course_id = C.course_id;
GO


-- D) Fetch details for all payments along with their corresponding student
GO
CREATE VIEW Student_Payment AS
SELECT
    P.amount,
	P.deadline,
	P.n_installments,
	P.status,
	P.fund_percentage,
	P.start_date,
	P.semester_code,
	p.payment_id,
    S.*
FROM Payment P
LEFT JOIN Student S ON P.student_id = S.student_id;

-- E) Fetch details for all courses along with their corresponding slots’ details and instructors
GO
CREATE VIEW Courses_Slots_Instructor AS
SELECT
    C.course_id,
    C.name AS course_name,
    S.slot_id,
    S.day AS slot_day,
    S.time AS slot_time,
    S.location AS slot_location,
    I.name AS instructor_name
FROM Course C
LEFT JOIN Slot S ON C.course_id = S.course_id
LEFT JOIN Instructor_Course IC ON C.course_id = IC.course_id
LEFT JOIN Instructor I ON IC.instructor_id = I.instructor_id;
GO

-- F) Fetch details for all courses along with their exams’ details.
CREATE VIEW Courses_MakeupExams AS
SELECT
    C.name AS course_name,
    C.semester AS course_semester,
    M.*
FROM Course C
LEFT JOIN MakeUp_Exam M ON C.course_id = M.course_id;

-- G) Fetch students along with their taken courses’ details
GO
CREATE VIEW Students_Courses_transcript AS
SELECT
    S.student_id,
    S.f_name AS student_name,
    E.course_id,
    C.name AS course_name,
    E.exam_type,
    E.grade,
    E.semester_code,
    I.name AS instructor_name
FROM Student S
LEFT JOIN Student_Instructor_Course_Take E ON S.student_id = E.student_id
LEFT JOIN Course C ON E.course_id = C.course_id
LEFT JOIN Instructor I ON E.instructor_id = I.instructor_id;
GO

-- H) Fetch all semesters along with their offered courses
GO
CREATE VIEW Semster_offered_Courses AS
SELECT
    C.course_id,
    C.name AS course_name,
	S.semester_code
FROM Semester S
LEFT JOIN Course_Semester CS ON S.semester_code = CS.semester_code
LEFT JOIN Course C ON CS.course_id = C.course_id;
GO

-- I) Fetch all graduation plans along with their initiated advisors
GO
CREATE VIEW Advisors_Graduation_Plan AS
SELECT
    G.*,
    A.name AS advisor_name
FROM Graduation_Plan G
LEFT JOIN Advisor A ON G.advisor_id = A.advisor_id;
GO

--- ~~~~~~~~~~ ---
-- ~~~~ 2.3 ~~~ --
--- ~~~~~~~~~~ ---

-- A)

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
	Insert Into Student(f_name, l_name, password, faculty, email, major, semester)
		Values(@first_name, @last_name, @password, @faculty, @email, @major, @semester)
		Select @student_id = student_id from Student where email = @email and password = @password
GO

-- B)

Create Procedure Procedures_AdminRegistration
@advisor_name varchar(40),
@password varchar(40),
@email varchar(40),
@office varchar(40),
@advisor_id int Output
As
Insert Into Advisor(name, email, office, password)
Values(@advisor_name, @email, @office, @password)
select @advisor_id = advisor_id from Advisor where name = @advisor_name and password = @password
GO

-- C)

Create Procedure Procedures_AdminListStudents
As
Select s.* From Student s
GO

-- D)

Create Procedure Procedures_AdminListAdvisors
As
Select * From Advisor
GO

-- E)

Create Procedure AdminListStudentsWithAdvisors
As
Select s.*, a.name as advisor_name From Student s
Inner Join Advisor a On s.advisor_id = a.advisor_id
GO --msh mota2ked menha

-- F)

Create Procedure AdminAddingSemester
		@start_date date,
		@end_date date,
		@semester_code varchar(40)
As
	Insert Into Semester(semester_code, start_date, end_date)
		Values(@semester_code, @start_date, @end_date)
GO

-- G)

Create Procedure Procedures_AdminAddingCourse
	@major varchar (40),
	@semester int,
	@credit_hours int,
	@course_name varchar (40),
	@offered bit
As
	Insert Into Course(name, major, is_offered, credit_hours, semester)
		Values(@course_name, @major, @offered, @credit_hours, @semester)
GO

-- H)

Create Procedure Procedures_AdminLinkInstructor
	@InstructorID int,
	@CourseID int,
	@slotID int
As
	insert into Slot(slot_id, instructor_id, course_id)
		values(@slotID, @InstructorID, @CourseID)
				
GO

-- I)

Create Procedure Procedures_AdminLinkStudent
	@Instructor_ID int,
	@student_ID int,
	@course_ID int,
	@semester_code varchar(40)
As 
	insert into Student_Instructor_Course_Take(instructor_id, student_id, course_id, semester_code)
		values(@Instructor_ID, @student_ID, @course_ID, @semester_code)
GO

-- J)

Create Procedure Procedures_AdminLinkStudentToAdvisor
	@studentID int,
	@advisorID int
As
	Update Student
	Set
	Student.advisor_id = @advisorID
	where Student.student_id = @studentID
GO

-- K)

Create Procedure Procedures_AdminAddExam
	@Type varchar (40),
	@date datetime,
	@courseID int
As
	Insert Into MakeUp_Exam(type, date, course_id)
	Values(@TYPE, @date, @courseID)
GO
-- l)
create procedure  Procedures_AdminIssueInstallment
	@payment_ID int
	as
	declare @amount int
	select @amount = amount from Payment where payment_id = @payment_ID



	declare @n_installments int
	select @n_installments = n_installments from Payment where payment_id = @payment_ID

	declare @start_date datetime
	select @start_date = start_date from Payment where payment_id = @payment_ID

	declare @deadline datetime
	declare @counter int = 0
	while @counter < @n_installments
	Begin
			set @deadline = dateadd(month, 1, @deadline)	
	insert into Installment(payment_id, deadline, amount,start_date)	
		values(@payment_ID, @deadline, @amount/@n_installments,@start_date)
		set @counter = @counter + 1
		set @start_date = dateadd(month, 1, @start_date)
	End
	go
-- M)
	create proc Procedures_AdminDeleteCourse
	@courseID int
	as
	delete from Course where course_id = @courseID
	delete from Course_Semester where course_id = @courseID

	go
-- N)
	create proc Procedure_AdminUpdateStudentStatus
	@studentID int
	as
	declare @payment_id int
	select @payment_id = payment_id from Payment where student_id = @studentID

	declare @current_date datetime
	select @current_date = getdate()

	if(exists (select * from Installment where payment_id = @payment_id and deadline < @current_date and status = 'notPaid'))
	begin
	update Student set Status = 0 where student_id = @studentID
	end
	else
	begin
	update Student set Status = 1 where student_id = @studentID
	end
	go
-- O)

Create Procedure all_Pending_Requests
As
	Select R.*,S.f_name as Student_First_name,S.l_name as Student_last_name, A.name as Advisor_name  From Request R inner join Student S on R.student_id = S.student_id inner join Advisor A on R.advisor_id = A.advisor_id
	where R.status = 'pending'
GO
-- P)
create proc Procedures_AdminDeleteSlots
@current_semester_code varchar(40)
as

delete from	Slot where course_id in ((select course_id from Slot) Except (select course_id from Course_Semester where semester_code = @current_semester_code))

go

-- Q)
create function FN_AdvisorLogin
	(@advisor_id int,@password varchar(40))
	returns bit
	as
	begin
	declare @success_bit bit
	if exists (select * from Advisor where advisor_id = @advisor_id and password = @password)
	set @success_bit = 1
	else
	set @success_bit = 0
	return @success_bit
	end
	go
-- R)
create proc Procedures_AdvisorCreateGP
	@semester_code varchar(40),
	@expected_grad_date date,
	@sem_credit_hours int,
	@advisor_id int,
	@student_id int
	as
	insert into Graduation_Plan(semester_code, expected_grad_date, semester_credit_hours, advisor_id, student_id)
	values(@semester_code, @expected_grad_date, @sem_credit_hours, @advisor_id, @student_id)
	go
-- S) Add course inside certain plan of specific student
-- i. Type: Stored Procedure
-- ii. Name: Procedures_AdvisorAddCourseGP
-- iii. Input: student id int, Semester_code varchar (40), course
-- name varchar (40).
-- iv. Output: Nothing

create procedure Procedures_AdvisorAddCourseGP
	@student_id int,
	@semester_code varchar(40),
	@course_name varchar(40)
as
	declare @course_id int
	declare @plan_id int
	select @plan_id = plan_id from Graduation_Plan where student_id = @student_id and semester_code = @semester_code
	select @course_id = course_id from Course where name = @course_name
	insert into GradPlan_Course(plan_id, semester_code, course_id)
	values(@plan_id, @semester_code, @course_id)
GO

-- T) Update expected graduation date in a certain graduation plan
-- i. Type: Stored Procedure
-- ii. Name: Procedures_AdvisorUpdateGP
-- iii. Input: expected_grad_date date and studentID int
-- iv. Output: nothing

create procedure Procedures_AdvisorUpdateGP
	@expected_grad_date date,
	@student_id int
as
	update Graduation_Plan
	set expected_grad_date = @expected_grad_date
	where student_id = @student_id
GO

-- U) Delete course from certain graduation plan in certain semester
-- i. Type: stored procedure
-- ii. Name: Procedures_AdvisorDeleteFromGP
-- iii. Input: studentID int, semester code varchar (40) and course
-- ID (the course he/she wants to delete)
-- iv. Output: nothing

create procedure Procedures_AdvisorDeleteFromGP
	@student_id int,
	@semester_code varchar(40),
	@course_id int
as
	declare @plan_id int
	select @plan_id = plan_id from Graduation_Plan where student_id = @student_id and semester_code = @semester_code

	delete from GradPlan_Course where @plan_id = plan_id and @semester_code = semester_code and @course_id = course_id
GO

-- V) Retrieve requests for certain advisor
-- i. Type: TVFunction
-- ii. Name: FN_Advisors_Requests
-- iii. Input: advisorID int
-- iv. Output: Table (Requests details related to this advisor)

create function FN_Advisors_Requests
	(@advisor_id int)
returns table
as
return
(
	select * from Request
	where advisor_id = @advisor_id
)

-- W) Approve/Reject extra credit hours’ request
-- i. Type: Stored Procedure
-- ii. Name: Procedures_AdvisorApproveRejectCHRequest
-- iii. Input: RequestID int, Current semester code varchar (40)
-- iv. Output: nothing

GO
create proc Procedures_AdvisorApproveRejectCHRequest
@request_id int,
@Semester_code varchar(40)
as
declare @student_id int;
declare @credit_hours int;
declare @assigned_hours int;
declare @gpa decimal(3,2);
declare @payment_amount int;
declare @payment_id int;
declare @installment_deadline date;
declare @installment_ammount int;
select @student_id = student_id from Request where request_id = @request_id;
select @credit_hours = credit_hours from Request where request_id = @request_id;
select @gpa = gpa from Student where student_id = @student_id;
select @payment_id = payment_id from Payment where student_id = @student_id and semster_code = @Semester_code
select @payment_amount = amount from Payment where student_id = @student_id and semester_code = @semester_code;
select @assigned_hours = assigned_hours from Student where student_id = @student_id;
select @installment_deadline = min(deadline) from Installment where status = 'notPaid' and payment_id = @payment_id 
select @installment_ammount = amount from Installment where payment_id = @payment_id and @installment_deadline = deadline;
if(@credit_hours is null)
print ' this in not a credit hour request';
else
begin
if(@gpa > 3.7)
begin
update Request set status = 'rejected' where request_id = @request_id;
print 'this student is on probation';
end
else
begin
if(@credit_hours > 3 or @credit_hours < 0)
begin
update Request set status = 'rejected' where request_id = @request_id;
print 'credit_hours that can be added should be up to 3'
end
else 
begin
if(@assigned_hours + @credit_hours > 34)
begin
update Request set status = 'rejected' where request_id = @request_id;
print 'assigned hours would pass the 34 hours threshold'
end
else
begin
update Request set status = 'approved' where request_id = @request_id;
update Student set assigned_hours = @assigned_hours + @credit_hours where student_id = @student_id; 
update Payment set amount = @payment_amount + 1000 where @student_id = student_id and @Semester_code = semster_code;
update Installment set amount = @installment_ammount + 1000 where payment_id = @payment_id and deadline = @installment_deadline;
print 'request approved succesfully';
end
end
end
end
GO

-- X) View all students assigned to specific advisor from a certain major along
-- with their taken courses
-- i. Type: Stored Procedure
-- ii. Name: Procedures_AdvisorViewAssignedStudents
-- iii. Input: AdvisorID int and major varchar (40)
-- iv. Output: Table (Student id, Student name, Student major,
-- Course name)

create procedure Procedures_AdvisorViewAssignedStudents
	@advisor_id int,
	@major varchar(40)
as
	select Student.student_id, Student.name, Student.major, Course.name
	from Student, Course, Student_Instructor_Course_Take
	where Student.student_id = Student_Instructor_Course_Take.student_id and
	Student.major = @major and
	Student.advisor_id = @advisor_id and
	Course.course_id = Student_Instructor_Course_Take.course_id
GO

-- Y) Approve/Reject courses request
-- After approving/rejecting the request, the status of the request should be
-- updated and all consequences should be handled. The approving/rejecting
-- is based on the below conditions:
-- ● All the Requested course’s prerequisites are taken.
-- ● Student has enough assigned hours for the requested course.
-- i. Type: Stored Procedure
-- ii. Name:Procedures_AdvisorApproveRejectCourseRequest
-- iii. Input: RequestID int, current_semester_code varchar(40)
-- iv. Output: nothing
create proc Procedures_AdvisorApproveRejectCourseRequest
@request_id int,
@current_semester_code varchar(40)
as
declare @assigned_hours int;
declare @coure_id varchar(40);
declare @credit_hours int;
declare @student_credithours_sum int;
declare @student_id int;
select @student_id = student_id from Request where request_id = @request_id;
select @assigned_hours = assigned_hours from Student where student_id = @student_id;
select @coure_id = course_id from Request where request_id = @request_id;
select @credit_hours = credit_hours from Course where course_id = @coure_id;
select @student_credithours_sum = sum(C.credit_hours) from Student_Instructor_Course_Take sc inner join Course C on C.course_id = sc.course_id  where @student_id = sc.student_id and sc.semester_code = @current_semester_code; 
if(@coure_id is null)
begin
print 'this is not a course request';
end
else
begin
if( Exists((select prequisite_Course_id from preqCourse_course where course_id = @coure_id) except (select course_id from Student_Instructor_Course_Take 
where student_id = @student_id and not (grade is null or grade ='F' or grade = 'FF' or grade = 'FA') and semester_code <> @current_semester_code)))
begin
update Request set status = 'rejected' where @request_id = request_id
print 'student still needs to take all prequisite courses';
end
else
begin
if(@assigned_hours < @student_credithours_sum + @credit_hours)
begin
print 'student does not have enough assigned hours';
update Request set status = 'rejected' where request_id = @request_id;
end
else
begin
if(not exists (select course_id from Course_Semester where course_id = @coure_id and semester_code = @current_semester_code))
begin
print ' course is not offered in the current semester'
update Request set status = 'rejected' where request_id = @request_id;
end
else
begin
update Request set status = 'approved' where request_id = @request_id;
insert into Student_Instructor_Course_Take (student_id,course_id,semester_code) values(@student_id,@coure_id,@current_semester_code)
print 'request approved succesfuully';
end
end
end
end
Go

-- Z) View pending requests of specific advisor students
-- i. Type: Stored Procedure
-- ii. Name: Procedures_AdvisorViewPendingRequests
-- iii. Input: Advisor ID int {this advisor should be the one
-- advising the student}

create procedure Procedures_AdvisorViewPendingRequests
	@advisor_id int
as
	select * from Request where advisor_id = @advisor_id and status = 'pending'
GO;


-- AA) Student Login using username and password.
-- i. Type: Scalar Function
-- ii. Name: FN_StudentLogin
-- iii. Input: Student ID int, password varchar (40)
-- iv. Output: Success bit

create Function FN_StudentLogin
	(@StudentID int,
	@password varchar(40))
	returns bit
as
begin
	declare @success_bit bit
	if exists (select * from Student where StudentID = @StudentID and password = @password)
		set @success_bit = 1
	else
		set @success_bit = 0
	return @succes_bit
end

-- BB) Add Student mobile number(s)
-- i. Type: Stored Procedure
-- ii. Name: Procedures_StudentaddMobile
-- iii. Input: StudentID int, mobile_number varchar (40)
-- iv. Output: Nothing

GO
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
-- iii. Input: semester_code varchar (40)
-- iv. Output: Table of available courses within the semester

GO
create function FN_SemsterAvailableCourses
	(@semester_code varchar(40))
returns table
as
return
(
	select C.* from Course C inner join Course_Semester CS on C.course_id =cs.course_id where semester_code = @semester_code
)
GO

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
	declare @advisor_id int
	select @advisor_id = advisor_id from Student where S.student_id = @StudentID
	if exists (select * from Student where StudentID = @StudentID)
		insert into Request (type, comment, credit_hours, student_id, advisor_id, course_id)
		values (@type, @comment, null, @StudentID, @advisor_id, @courseID)
end

-- EE) Sending extra credit hours’ request
-- i. Type: Stored Procedure
-- ii. Name: Procedures_StudentSendingCHRequest
-- iii. Input: Student ID int, credit hours int, type varchar (40),
-- and comment varchar (40)
-- iv. Output: Nothing

GO
create proc Procedures_StudentSendingCHRequest
	@StudentID int,
	@credit_hours int,
	@type varchar(40),
	@comment varchar(40)
as
begin
    declare @advisor_id int
	select @advisor_id = advisor_id from Student where S.student_id = @StudentID
	if exists (select * from Student where StudentID = @StudentID)
		insert into Request	(type, comment, credit_hours, student_id, advisor_id, course_id)
		values (@type, @comment, @credit_hours, @StudentID,@advisor_id, null)
end
GO

-- FF) View graduation plan along with the assigned courses
-- i. Type: TVFunction
-- ii. Name: FN_StudentViewGP
-- iii. Input: student_ID int
-- iv. Output: Table (Student Id, Student_name, graduation Plan
-- Id, Course id, Course name, Semester code, expected
-- graduation date, Semester credit hours, advisor id)

GO
create function FN_StudentViewGP
	(@student_ID int)
returns table
as
return
(
	select S.student_id,concat(S.f_name,S.l_name) as Student_name, Gp.plan_id as Graduation_plan_Id,C.course_id as Course_id,
	C.name as course_name ,CS.semester_code as Semester_code, GP.expected_grad_date as expected_graduation_date ,
	Gp.semester_credit_hours, S.advisor_id  from GradPlan_Course GC, Graduation_Plan GP, Student_Instructor_Course_Take CS, Student S, Course C
	where GradPlan_Course.plan_id = Graduation_Plan.plan_id
	and Graduation_Plan.student_id = Student.student_id
	and GradPlan_Course.course_id = Course_Semester.course_id
	and GradPlan_Course.semester_code = Student_Instructor_Course_Take.semester_code
	and Student_Instructor_Course_Take.student_id = Student.student_id
	and Student.student_id = @student_ID
)
GO
-- GG) Student view his first not paid installment deadline
-- i. Type: Scalar Function
-- ii. Name: FN_StudentUpcoming_installment
-- iii. Input: StudentID int
-- iv. Output: deadline date of first not paid installment
GO
create function FN_StudentUpcoming_installment
	(@StudentID int)
returns date
as
begin
	declare @installment_deadline date
	declare @payment_id int
	select @payment_id = payment_id from Payment where student_id = @StudentID
	select @installment_deadline = min(deadline) from Installment where status = 'notPaid' and payment_id = @payment_id
	return @installment_deadline
end
GO
-- HH) View slots of certain course that is taught by a certain instructor
-- i. Type: TVFunction
-- ii. Name: FN_StudentViewSlot
-- iii. Input: CourseID int, InstructorID int
-- iv. Output: table of slots’ details (Slot ID, location, time, day)
-- with course name and Instructor name

GO
create function FN_StudentViewSlot
	(@CourseID int, @InstructorID int)
returns table
as
return
(
	select S.slot_id, S.location, S.time, S.day, C.name, I.name from Slot S, Instructor I , Course C
	where Slot.slot_id = Instructor_Course.slot_id
	and Slot.instructor_id = Instructor.instructor_id
	and Slot.course_id = Course.course_id
	and Course.course_id = @CourseID
	and Instructor.instructor_id = @InstructorID
)
GO

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
	declare @exam_id int
	declare @current_sem_start_date date
	select @current_sem_start_date = start_date from Semester where semester_code = @studentCurrent
	select @exam_id = exam_id from MakeUp_Exam where course_id = @courseID and type = 'first' and date = (select min(start_date) from MakeUp_Exam
	where start_date > @current_sem_start_date and course_id = @courseID and type = 'first');
	if (exists (select * from Student where StudentID = @StudentID))
	begin
		insert into Exam_student (exam_id, student_id, course_id)
		values (@exam_id,@StudentID, @courseID)
	end
end


-- JJ) Second makeup Eligibility Check {refer to eligibility section (2.4.1) in the
-- description}
-- i. Type: Scalar Function
-- ii. Name: FN_StudentCheckSMEligiability
-- iii. Input: CourseID int, Student ID int
-- iv. Output: Eligible bit {0 → not eligible, 1 → eligible}

GO
create function FN_StudentCheckSMEligiability
	(@CourseID int, @StudentID int)
returns bit
as
begin
	return (select count(*) from Makeup_Exam where StudentID = @StudentID and course_id = @CourseID and makeup_type = 'second' and status = 'pending')
end
GO

-- KK) Register for 2nd makeup exam {refer to eligibility section (2.4.1) in the
-- description}
-- i. Type: Stored Procedure
-- ii. Name: Procedures_StudentRegisterSecondMakeup
-- iii. Input: StudentID int, courseID int, Student Current
-- Semester Varchar (40)
-- iv. Output: Nothing
GO
create proc Procedures_StudentRegisterSecondMakeup
	@StudentID int,
	@courseID int,
	@studentCurrent varchar(40)
as
begin
	if exists (select * from Student where StudentID = @StudentID)
		insert into Makeup_Exam values (@StudentID, @courseID, @studentCurrent, null, null, null, null)
end
GO

-- LL) View required courses
-- i. Type: Stored Procedure
-- ii. Name: Procedures_ViewRequiredCourses
-- iii. Input: StudentID int, Current semester code Varchar (40)
-- iv. Output: Table of the required courses’ details.

GO
create proc Procedures_ViewRequiredCourses
	@StudentID int,
	@CurrentSemester varchar(40)
as
begin
	select * from Course_Semester, Student, Graduation_Plan, GradPlan_Course
	where Course_Semester.course_id = GradPlan_Course.course_id
	and Course_Semester.semester_code = GradPlan_Course.semester_code
	and GradPlan_Course.graduation_plan_id = Graduation_Plan.graduation_plan_id
	and Graduation_Plan.student_id = Student.student_id
	and Student.student_id = @StudentID
	and Course_Semester.semester_code = @CurrentSemester
	and Course_Semester.type = 'required'
end

-- MM) View optional courses
-- i. Type: Stored Procedure
-- ii. Name: Procedures_ViewOptionalCourse
-- iii. Input: StudentID int, Current semester code Varchar (40)
-- iv. Output: Table of the optional courses’ details.

GO
create proc Procedures_ViewOptionalCourse
	@StudentID int,
	@CurrentSemester varchar(40)
as
begin
	select * from Course_Semester, Student, Graduation_Plan, GradPlan_Course
	where Course_Semester.course_id = GradPlan_Course.course_id
	and Course_Semester.semester_code = GradPlan_Course.semester_code
	and GradPlan_Course.graduation_plan_id = Graduation_Plan.graduation_plan_id
	and Graduation_Plan.student_id = Student.student_id
	and Student.student_id = @StudentID
	and Course_Semester.semester_code = @CurrentSemester
	and Course_Semester.type = 'optional'
end
GO

-- NN) View missing/remaining courses to specific student.
-- i. Type: Stored Procedure
-- ii. Name: Procedures_ViewMS
-- iii. Input: StudentID int
-- iv. Output: Table of missing courses’ details

GO
create proc Procedures_ViewMS
	@StudentID int
as
begin
	select * from Course_Semester, Student, Graduation_Plan, GradPlan_Course
	where Course_Semester.course_id = GradPlan_Course.course_id
	and Course_Semester.semester_code = GradPlan_Course.semester_code
	and GradPlan_Course.graduation_plan_id = Graduation_Plan.graduation_plan_id
	and Graduation_Plan.student_id = Student.student_id
	and Student.student_id = @StudentID
	and Course_Semester.type = 'required'
	and Course_Semester.semester_code not in (select Course_Semester.semester_code from Course_Semester, Student, Graduation_Plan, GradPlan_Course
	where Course_Semester.course_id = GradPlan_Course.course_id
	and Course_Semester.semester_code = GradPlan_Course.semester_code
	and GradPlan_Course.graduation_plan_id = Graduation_Plan.graduation_plan_id
	and Graduation_Plan.student_id = Student.student_id
	and Student.student_id = @StudentID
	and Course_Semester.type = 'taken')
end
GO

-- OO) Choose instructor for a certain selected course.
-- i. Type: Stored Procedure
-- ii. Name: Procedures_ChooseInstructor
-- iii. Input: Student ID int, Instructor ID int, Course ID int,
-- current_semester_code varchar(40)
-- iv. Output: nothing

GO
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
GO
