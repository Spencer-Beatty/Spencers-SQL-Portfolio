SELECT email
FROM users, (SELECT DISTINCT b.userid
FROM review a, review b, (SElECT userid
                       FROM users
                       WHERE email = 'cinebuff@movieinfo.com')cine
WHERE a.userid =  cine.userid AND a.movid = b.movid AND b.userid <> cine.userid AND
      ABS(a.rating-b.rating)<=1) userlist
WHERE userlist.userid = users.userid
ORDER BY email
;
