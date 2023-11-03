SELECT rating, title, releasedate
FROM review, movies
WHERE movies.movid = review.movid AND review.userid IN (SELECT userid FROM users WHERE email = 'talkiesdude@movieinfo.com')
ORDER BY rating DESC, releasedate, title
;
