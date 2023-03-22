SELECT COUNT(*)                                                 AS col_rows,
       sched.clinic,
       sched.role,
       sched.post,
       sched.department,
       sched.employee,
       sched.shift,
       date_add(sched.year_month, INTERVAL (sched.day - 1) day) as DTSmen,

       sched.time_start,
       sched.time_end
FROM analyticdb.gs_schedule_tmp AS sched
where sched.employee is not null
GROUP BY sched.employee, date_add(sched.year_month, INTERVAL (sched.day - 1) day), sched.time_start, sched.time_end
HAVING COUNT(*) > 1