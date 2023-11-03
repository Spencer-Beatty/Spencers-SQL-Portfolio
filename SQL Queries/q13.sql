SELECT title, releasedate
FROM movies, (SELECT movid, count(movid) numreviews
              FROM review
              GROUP BY movid) revs
WHERE movies.movid = revs.movid AND revs.numreviews = (SELECT MAX(numreviews)
                                                        FROM (SELECT movid, count(movid) numreviews
                                                          FROM review
                                                          GROUP BY movid) revs)
ORDER BY releasedate, title
;
