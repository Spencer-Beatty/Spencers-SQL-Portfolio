SELECT language, genre
FROM
     (SELECT language, genre, COUNT(genre) nums
      FROM moviegenres join releaselanguages r on moviegenres.movid = r.movid
      GROUP BY language, genre
      ORDER BY 1,2,3
     ) lang
WHERE (lang.language, lang.nums) IN (SELECT language, MAX(nums)
                    FROM (SELECT language, genre, COUNT(genre) nums
                          FROM moviegenres join releaselanguages r on moviegenres.movid = r.movid
                          GROUP BY language, genre
                          ORDER BY 1,2,3
                         ) lang
                    GROUP BY language)
ORDER BY 1,2
;
