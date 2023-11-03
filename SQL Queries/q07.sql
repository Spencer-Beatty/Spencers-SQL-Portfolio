SELECT title, releasedate, langs languages
FROM movies, (SELECT a.movid, a.language||','||b.language langs
              FROM releaselanguages a, releaselanguages b
              WHERE a.movid = b.movid AND a.language = 'French' AND b.language = 'Italian') double
WHERE double.movid = movies.movid
UNION
SELECT title, releasedate, langs languages
FROM movies, (SELECT a.movid
              FROM releaselanguages a
              WHERE a.language = 'French'
        EXCEPT
                SELECT b.movid
                FROM releaselanguages b
                WHERE b.language = 'Italian') singlemov,
                    (SELECT a.movid, a.language langs
                    FROM releaselanguages a
                    WHERE a.language = 'French' OR a.language = 'Italian') single

WHERE single.movid = movies.movid AND singlemov.movid = single.movid
ORDER BY releasedate, title
;
