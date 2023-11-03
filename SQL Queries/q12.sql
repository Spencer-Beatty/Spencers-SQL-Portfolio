SELECT title, releasedate, numreviews
FROM movies, (SELECT movid, count(movid) numreviews
              FROM review
              GROUP BY movid) revs
WHERE revs.movid = movies.movid AND (EXTRACT(YEAR from movies.releasedate)) = 2021
UNION
SELECT  title, releasedate, 0 numreviews
FROM movies
WHERE (EXTRACT(YEAR from movies.releasedate)) = 2021
EXCEPT
SELECT title, releasedate, 0 numreviews
FROM movies, review
WHERE (EXTRACT(YEAR from movies.releasedate)) = 2021 AND movies.movid = review.movid
ORDER BY 3 DESC, 2, 1
;
