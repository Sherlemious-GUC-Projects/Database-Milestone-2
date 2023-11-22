--2.2

-- A) Fetch details for all Active students.
CREATE VIEW view_Students AS
SELECT *
FROM Student
WHERE financial_status = 1;


-- B) Fetch details for all courses with their prerequisites
CREATE VIEW view_Course_prerequisites AS
SELECT
    C.*,
    P.prequisite_Course_id AS prerequisite_course_id
FROM Course C
LEFT JOIN preqCourse_course P ON C.course_id = P.course_id;


-- C) Fetch details for all Instructors along with their assigned courses
CREATE VIEW Instructors_AssignedCourses AS
SELECT
    I.*,
    C.course_id AS assigned_course_id,
    C.name AS assigned_course_name
FROM Instructor I
LEFT JOIN Instructor_Course IC ON I.instructor_id = IC.instructor_id
LEFT JOIN Course C ON IC.course_id = C.course_id;


-- D) Fetch details for all payments along with their corresponding student
CREATE VIEW Student_Payment AS
SELECT
    P.*,
    S.*
FROM Payment P
LEFT JOIN Student S ON P.student_id = S.student_id;

-- E) Fetch details for all courses along with their corresponding slots’ details and instructors
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

-- F) Fetch details for all courses along with their exams’ details.
CREATE VIEW Courses_MakeupExams AS
SELECT
    C.name AS course_name,
    C.semester AS course_semester,
    M.*
FROM Course C
LEFT JOIN MakeUpExam M ON C.course_id = M.course_id;

-- G) Fetch students along with their taken courses’ details
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

-- H) Fetch all semesters along with their offered courses
CREATE VIEW Semster_offered_Courses AS
SELECT
    S.semester_code,
    C.course_id,
    C.name AS course_name
FROM Semester S
LEFT JOIN Course_Semester CS ON S.semester_code = CS.semester_code
LEFT JOIN Course C ON CS.course_id = C.course_id;

-- I) Fetch all graduation plans along with their initiated advisors
CREATE VIEW Advisors_Graduation_Plan AS
SELECT
    G.*,
    A.advisor_id,
    A.name AS advisor_name
FROM Graduation_Plan G
LEFT JOIN Advisor A ON G.advisor_id = A.advisor_id;

