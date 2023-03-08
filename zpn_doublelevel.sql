-- Отбор дублей с уровней сотрудников
SELECT COUNT(*) AS col_rows,
       sched.clinic,
       sched.role,
       sched.post,
       sched.level,
       sched.department,
       sched.fio,
       sched.shift,
       sched.DateSm
FROM analyticdb.zpn_sched_lev AS sched
GROUP BY sched.clinic, sched.role, sched.post, sched.level, sched.department, sched.fio, sched.shift, sched.DateSm
HAVING COUNT(*) > 1