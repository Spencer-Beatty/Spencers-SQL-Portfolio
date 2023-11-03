SELECT title, releasedate
FROM movies
WHERE movid IN (SELECT movid
                FROM releaselanguages
                WHERE language = 'French'
                EXCEPT
                SELECT movid
                FROM releaselanguages
                WHERE language = 'English')
ORDER BY releasedate, title
;
