select el.id                                                         AS id,
       el.fio                                                        AS fio,
       el.date_from                                                  AS date_from,
       el.post                                                       AS post,
       el.department                                                 AS department,
       el.level                                                      AS level,
       if((select t3.date_from + interval -1 day
           from analyticdb.gs_employees_level t3
           where t3.fio = el.fio
             and t3.department = el.department
             and t3.post = el.post
             and t3.date_from > el.date_from
           order by t3.fio, t3.department, t3.post, t3.date_from
           limit 1) is null, curdate() + interval 30 day, (select t3.date_from + interval -1 day
                                                           from gs_employees_level t3
                                                           where t3.fio = el.fio
                                                             and t3.department = el.department
                                                             and t3.post = el.post
                                                             and t3.date_from > el.date_from
                                                           order by t3.fio, t3.department, t3.post, t3.date_from
                                                           limit 1)) AS date_to
from analyticdb.gs_employees_level as el


