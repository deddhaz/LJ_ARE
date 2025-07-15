Drop Table PBI_LearningJourneyARE_Log
SELECT 
    qq.username AS "NIK",
    de.Name,
    de.JobTitle,
    de.[Join Date],
    qq.course_id,
    qq.course_title,
    qq.quiz_id,
    qq.quiz_title,
    qq.quiz_type,
    qq.score,
    qq.quiz_created,
    qq.is_pass,
    CASE 
        WHEN qq.is_pass = 1 THEN 'Lulus' 
        ELSE 'Tidak Lulus' 
    END AS "Status Kelulusan",
    CASE 
        WHEN qq.is_pass = 1 
             OR (SELECT COUNT(*) 
                 FROM quizzes_quizsession2 q2 
                 WHERE q2.username = qq.username 
                   AND q2.quiz_id = qq.quiz_id) >= 3 
        THEN 'Completed' 
        ELSE 'Incompleted' 
    END AS "Completion Status",
    (SELECT COUNT(*) 
     FROM quizzes_quizsession2 q2 
     WHERE q2.username = qq.username 
       AND q2.quiz_id = qq.quiz_id) AS num_attempts,
    
    -- New column: Course Level
    CASE 
        WHEN qq.course_title LIKE '%Learning Journey ARE : Intermediate Course Lv I %' 
        THEN 'Intermediate Course Level 1'
        WHEN qq.course_title LIKE '%Learning Journey ARE : Intermediate Course Lv II%' 
        THEN 'Intermediate Course Level 2'
        WHEN qq.course_title LIKE '%Learning Journey ARE : Advance Course Lv I %' 
        THEN 'Advance Course Level 1'
        WHEN qq.course_title LIKE '%Learning Journey ARE : Advance Course Lv II%' 
        THEN 'Advance Course Level 2'
		WHEN qq.course_title like '%Learning Journey SPV Agency : Intermediate Course%'
		THEN 'Intermediate Course'
		WHEN qq.course_title like '%Learning Journey SPV Agency : Advance Course%'
		THEN 'Advance Course'
        ELSE 'Unknown Course Level'
    END AS "Course Level"

into PBI_LearningJourneyARE_Log
FROM quizzes_quizsession2 qq
LEFT JOIN DataEmployeeMbeat de ON de.nik = qq.username
WHERE (qq.course_title LIKE '%Learning Journey ARE : %' or qq.course_title LIKE '%Learning Journey SPV %')
--AND qq.quiz_type = 'Post Test'
AND qq.quiz_created = (
    SELECT MIN(q3.quiz_created) 
    FROM quizzes_quizsession2 q3 
    WHERE q3.username = qq.username 
      AND q3.quiz_id = qq.quiz_id
      AND q3.score = (
          SELECT MAX(q4.score) 
          FROM quizzes_quizsession2 q4 
          WHERE q4.username = qq.username 
            AND q4.quiz_id = qq.quiz_id
      )
) 
ORDER BY qq.course_title asc, de.nik ASC;




