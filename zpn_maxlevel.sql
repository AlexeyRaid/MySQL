SELECT fio, date_from, date_to, p.post, max(p.priority)
FROM zpn_levelsemployees zpn
         LEFT JOIN gs_posts AS p ON p.post = zpn.post AND p.level = zpn.level


group by fio, date_from, date_to

ORDER BY p.priority DESC
