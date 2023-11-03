SELECT DISTINCT uname, email
FROM users, review, (SELECT Distinct movid
            FROM releaselanguages
            EXCEPT
                SELECT DISTINCT movid
                FROM releaselanguages
                WHERE language<>'French') french

WHERE review.userid = users.userid AND review.movid = french.movid
ORDER BY email
;
