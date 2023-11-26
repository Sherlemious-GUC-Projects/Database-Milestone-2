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
