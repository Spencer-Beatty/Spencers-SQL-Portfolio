SELECT userid
FROM review
WHERE movid IN (SELECT movid
                FROM movies
                WHERE title = 'Ben-Hur' AND
                      EXTRACT(YEAR from movies.releasedate)=1959)
      AND rating >= 7

INTERSECT
SELECT userid
FROM review
WHERE movid IN (SELECT movid
                FROM movies
                WHERE (title = 'Ben-Hur') AND
                        EXTRACT(YEAR from movies.releasedate)=2016)
      AND NOT rating <= 4
ORDER BY userid
;
