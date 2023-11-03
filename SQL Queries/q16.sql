SELECT title, releasedate, avgrating
FROM moviegenres, (SELECT  movies.movid, title, releasedate, avgrating
FROM movies, (SELECT movid, AVG(rating) avgrating
                     FROM(SELECT b.movid, b.rating
              FROM review a, review b, (SElECT userid
                                        FROM users
                                        WHERE email = 'cinebuff@movieinfo.com')cine
              WHERE a.userid = cine.userid AND a.movid = b.movid AND b.userid<>cine.userid AND
                    a.rating<=b.rating)movs
               GROUP BY movid)rate
WHERE movies.movid = rate.movid) movs
WHERE  movs.movid = moviegenres.movid AND genre = 'Comedy'
ORDER BY 3 DESC ,2,1
;
