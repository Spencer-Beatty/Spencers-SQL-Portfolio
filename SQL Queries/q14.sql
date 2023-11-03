SELECT title, releasedate, avgrating
FROM movies,(SELECT movid, AVG(rating) avgrating
      FROM review
      GROUP BY movid
      HAVING COUNT(movid)>=2)revs
WHERE movies.movid = revs.movid
ORDER BY 3 DESC ,2,1
;
