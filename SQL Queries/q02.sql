SELECT DISTINCT userid
FROM review
WHERE movid IN (SELECT movid
                FROM movies
                WHERE title = 'Casablanca')
ORDER BY userid
;
