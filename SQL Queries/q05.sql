SELECT title, releasedate
FROM movies
WHERE EXTRACT(YEAR from movies.releasedate) = 2021 AND
      movid IN (SELECT sci.movid
                FROM moviegenres sci,moviegenres com
                WHERE sci.movid = com.movid AND sci.genre = 'Sci-Fi' AND com.genre = 'Comedy')
ORDER BY releasedate, title
;
