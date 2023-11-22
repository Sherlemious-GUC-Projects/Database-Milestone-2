--2.1.1 create database
create database Advising_Team_127;
Go;
use Advising_Team_127;
Go;

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
GO;

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
GO;

--2.1.4 procedure to clear tables
create proc clearAllTables
as
truncate table Student_Phone;
truncate table preqCourse_course;
truncate table Instructor_Course;
truncate table Student_Instructor_Course_Take;
truncate table Course_Semester;
truncate table GradPlan_Course;
truncate table Exam_student;
truncate table Installment;
truncate table Slot;
truncate table Graduation_Plan;
truncate table Request;
truncate table MakeUpExam;
truncate table Student;
truncate table Course;
truncate table Instructor;
truncate table Semester;
truncate table Advisor;
truncate table Payment;
GO;

Exec CreateAllTables;
GO;

Exec DropAllTables;
GO;

Exec clearAllTables;
GO;
