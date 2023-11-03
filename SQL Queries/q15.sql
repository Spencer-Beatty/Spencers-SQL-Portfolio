
SELECT title, numreviews
FROM (SELECT title, movid, COUNT(movid) numreviews
      FROM (SELECT title, movies.movid
                          FROM movies join review on movies.movid = review.movid,(SELECT movid
      FROM movies
      EXCEPT
        SELECT a.movid
      FROM movies a, movies b
      WHERE a.title = b.title AND a.movid <> b.movid AND a.releasedate<b.releasedate
    )movs
        WHERE movies.movid = movs.movid) mov
    GROUP BY mov.movid, title) revs
UNION
SELECT title, 0 numreviews
FROM movies
EXCEPT
SELECT title, 0 numreviews
FROM movies, review
WHERE movies.movid = review.movid
;
