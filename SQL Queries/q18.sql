SELECT revs.genre
FROM
     (SELECT moviegenres.genre, AVG(rating) avgrating
        FROM moviegenres join (SELECT movid, rating
                               FROM review, (SElECT userid
                                             FROM users
                                            WHERE email = 'cinebuff@movieinfo.com')cine
                               WHERE review.userid = cine.userid) a
            on moviegenres.movid = a.movid
        GROUP BY moviegenres.genre) revs
WHERE (revs.avgrating)  = (SELECT MAX(avgrating)
                        FROM (SELECT moviegenres.genre, AVG(rating) avgrating
                        FROM moviegenres join (SELECT movid, rating
                                               FROM review, (SElECT userid
                                                             FROM users
                                                             WHERE email = 'cinebuff@movieinfo.com')cine
                                               WHERE review.userid = cine.userid) a
                                              on moviegenres.movid = a.movid
                        GROUP BY moviegenres.genre) revs)
ORDER BY 1
;
