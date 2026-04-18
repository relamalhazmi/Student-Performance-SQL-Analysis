-- 1. Ranking students based on overall average score.
SELECT gender, race_ethnicity, parent_education,
      (math_score + reading_score + writing_score)/3  AS overall_score
FROM student_performance_dataset ORDER BY overall_score DESC;

-- 2. Calculating the average overall score per parental education level.
SELECT parent_education,
       ROUND(AVG((math_score + reading_score + writing_score)/3),2) AS avg_overall
FROM student_performance_dataset
GROUP BY parent_education ORDER BY avg_overall DESC;

-- 3. Calculating average scores for each subject by gender.
SELECT gender,  
        AVG(math_score) AS avg_math, 
         AVG(reading_score) AS avg_reading, 
         AVG(writing_score) AS avg_writing
  FROM student_performance_dataset GROUP BY gender ORDER BY avg_math DESC;

-- 4. Counting students by gender and lunch type.
SELECT  gender,lunch,
COUNT(*) AS student_count
FROM student_performance_dataset GROUP BY gender, lunch ORDER BY gender,lunch;

-- 5. Calculating average scores based on test preparation course completion.
SELECT  test_prep_course,
    AVG(math_score) AS avg_math,
    AVG(reading_score) AS avg_reading,
    AVG(writing_score) AS avg_writing
FROM student_performance_dataset
GROUP BY test_prep_course;

-- 6. Identifying maximum and minimum scores for each subject by gender.
SELECT gender,
    MAX(math_score) AS max_math_score,
    MIN(math_score) AS min_math_score,
    MAX(reading_score) AS max_reading_score,
    MIN(reading_score) AS min_reading_score,
    MAX(writing_score) AS max_writing_score,
    MIN(writing_score) AS min_writing_score
FROM student_performance_dataset GROUP BY gender;

-- 7. Counting students per ethnicity/race group.
SELECT  race_ethnicity,
    COUNT(*) AS student_count
FROM student_performance_dataset GROUP BY race_ethnicity;

-- 8. Comparing average scores between standard and free/reduced lunch types.
   SELECT lunch,
    AVG(math_score) AS avg_math_score,
    AVG(reading_score) AS avg_reading_score,
    AVG(writing_score) AS avg_writing_score,
    COUNT(*) AS total_students
FROM student_performance_dataset WHERE lunch IN ('standard' , 'free/reduced')
GROUP BY lunch;

-- 9. Classifying students by Math performance and analyzing their average scores in other subjects.
 SELECT 
    CASE 
        WHEN math_score <65 THEN 'Weak in math'
        ELSE  'Good in math'
    END AS math_category,
    AVG(reading_score) AS avg_reading_score,
    AVG(writing_score) AS avg_writing_score,
    COUNT(*) AS total_students
FROM student_performance_dataset GROUP BY math_category;

-- 10. Multi-subject performance classification (Math, Reading, Writing, and Overall).
SELECT gender,math_score, reading_score, writing_score,
    CASE 
        WHEN math_score >= 85 THEN 'Excellent'
        WHEN math_score >= 60 THEN 'Average'
        ELSE 'Weak'
    END AS math_level,
    CASE 
        WHEN reading_score >= 85 THEN 'Excellent'
        WHEN reading_score >= 60 THEN 'Average'
        ELSE 'Weak'
    END AS reading_level,
    CASE 
        WHEN writing_score >= 85 THEN 'Excellent'
        WHEN writing_score >= 60 THEN 'Average'
        ELSE 'Weak'
    END AS writing_level,
    CASE 
        WHEN (math_score + reading_score + writing_score)/3 >= 85 THEN 'Excellent'
        WHEN (math_score + reading_score + writing_score)/3 >= 60 THEN 'Average'
        ELSE 'Weak'
    END AS overall_level
FROM student_performance_dataset;

-- 11. Performance analysis by gender and test preparation impact.
SELECT gender,
    ROUND(AVG(math_score), 2) AS avg_math,
    ROUND(AVG(reading_score), 2) AS avg_reading,
    ROUND(AVG(writing_score), 2) AS avg_writing,
    CASE
        WHEN AVG(math_score + reading_score + writing_score)/3 >= 70 THEN 'Improved'
        ELSE 'No Significant Change'
    END AS effect
FROM student_performance_dataset
GROUP BY gender;

-- 12. Advanced student segmentation (Top, Average, Low) based on scores, prep courses, and parental education.
SELECT gender,  
 ROUND((math_score + reading_score + writing_score)/3, 2) AS avg_score,
    CASE
        WHEN ((math_score + reading_score + writing_score)/3 >= 85 
              AND test_prep_course = 'completed' 
              AND parent_education IN ('bachelor''s degree', 'master''s degree')) 
        THEN 'Top Performer'
    WHEN ((math_score + reading_score + writing_score)/3 <= 50
        AND test_prep_course = 'none') 
        THEN 'Low Performer'
        ELSE 'Average Performer'
    END AS performance_group
FROM student_performance_dataset;

-- 13. Calculating the percentage distribution of students across performance levels.
SELECT 
    CASE 
        WHEN (math_score + reading_score + writing_score)/3 >= 85 THEN 'Top'
        WHEN (math_score + reading_score + writing_score)/3 >= 60 THEN 'Average'
     ELSE 'Low'
    END AS performance_level,
    COUNT(*) AS student_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM student_performance_dataset), 2) AS percentage
FROM student_performance_dataset GROUP BY performance_level;

-- 14. Ranking students globally based on Math scores.
    SELECT 
  race_ethnicity,
  math_score,
  DENSE_RANK() OVER(ORDER BY math_score DESC) AS DenseRankMath
FROM student_performance_dataset;

-- 15. Ranking students within their specific ethnicity group based on Math scores.
    SELECT 
  race_ethnicity,
  math_score,
  RANK() OVER(PARTITION BY race_ethnicity ORDER BY math_score DESC) AS RankInGroup
FROM student_performance_dataset;

-- 16. Comparative analysis of student Math scores within the same lunch type.
SELECT a.gender AS gender_a,
       b.gender AS gender_b,
       a.lunch,
       a.math_score AS math_a,
       b.math_score AS math_b
FROM student_performance_dataset a
JOIN student_performance_dataset b
  ON a.lunch = b.lunch
 AND a.math_score < b.math_score;

-- 17. Counting students categorized by gender and lunch type using self-join logic.
SELECT 
    a.gender,
    a.lunch,
    COUNT(*) AS student_count
FROM student_performance_dataset a
JOIN student_performance_dataset b
  ON a.gender = b.gender
 AND a.lunch = b.lunch
 AND a.math_score < b.math_score  
GROUP BY a.gender, a.lunch
ORDER BY a.gender, a.lunch;