SELECT movid, title
FROM movies
WHERE (EXTRACT(YEAR from movies.releasedate)) >= 2021
ORDER BY movid;
