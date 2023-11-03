SELECT count(genre) nummovies
FROM moviegenres, movies
WHERE movies.movid = moviegenres.movid AND genre = 'Comedy' AND (EXTRACT(YEAR from movies.releasedate)) = 2021
;
