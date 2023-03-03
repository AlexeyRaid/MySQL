select pc.*, -- , pc.date_from as date_from, pc.clinic as clinic, pc.role as role, pc.post as post, pc.level as level, pc.department as department, pc.fio as fio, pc.shift as shift,

-- Формируем дату по
       if(
               (select pc2.date_from + interval -1 day
                from analyticdb.gs_pay_conditions_tmp as pc2
                where pc2.date_from > pc.date_from
                  and pc2.clinic = pc.clinic
                  and pc2.role = pc.role
                  and pc2.post = pc.post
                  and pc2.level = pc.level
                  and pc2.department = pc.department
                  and pc2.fio = pc.fio
                  and pc2.shift = pc.shift
                order by pc2.clinic, pc2.role, pc2.post, pc2.level, pc2.department, pc2.fio, pc2.shift, pc2.date_from
                limit 1) is null, curdate(),
               (select pc2.date_from + interval -1 day
                from analyticdb.gs_pay_conditions_tmp as pc2
                where pc2.date_from > pc.date_from
                  and pc2.clinic = pc.clinic
                  and pc2.role = pc.role
                  and pc2.post = pc.post
                  and pc2.level = pc.level
                  and pc2.department = pc.department
                  and pc2.fio = pc.fio
                  and pc2.shift = pc.shift
                order by pc2.clinic, pc2.role, pc2.post, pc2.level, pc2.department, pc2.fio, pc2.shift, pc2.date_from
                limit 1)
           )                                                                                                        as date_to,

-- Формируем Уник для графика
       concat(pc.clinic, "_", pc.department, "_", pc.post, "_", pc.role, "_", pc.level, "_", pc.shift, "_",
              pc.fio)                                                                                               as Uniq

from analyticdb.gs_pay_conditions_tmp as pc
where pc.date_from is not null
