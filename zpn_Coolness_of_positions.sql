SELECT zpn.fio, MAX(p.priority) AS priority, p.post, p.level -- , zpn.date_from, zpn.date_to
FROM zpn_levelsemployees zpn
         LEFT JOIN gs_posts AS p ON p.post = zpn.post AND p.level = zpn.level
where '2023-02-02' between zpn.date_from and zpn.date_to

GROUP BY zpn.fio

