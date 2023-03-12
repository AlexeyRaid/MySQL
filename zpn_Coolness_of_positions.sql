SELECT zpn.fio, MAX(p.priority) AS priority, p.post, p.level, zpn.date_from, zpn.date_to
FROM zpn_levelsemployees zpn
         LEFT JOIN gs_posts AS p ON p.post = zpn.post AND p.level = zpn.level
GROUP BY zpn.fio