SELECT title, releasedate
FROM movies, releaselanguages
WHERE movies.movid = releaselanguages.movid AND language = 'English'
INTERSECT
SELECT title, releasedate
FROM movies, releaselanguages
WHERE movies.movid = releaselanguages.movid AND language = 'French'
INTERSECT
SELECT title, releasedate
FROM movies,(SELECT movid
        FROM review
        GROUP BY movid
        HAVING COUNT(rating)>=5)highreviews
WHERE movies.movid = highreviews.movid
ORDER BY releasedate, title
;

