select cor.clinic,
       cor.department,
       cor.post,
       cor.role,
       cor.shift,
       cor.employee,
       emp.fio,
       cor.shift_date,
       -- Дата старта смены
       cast(concat(cor.shift_date, " ", cor.time_start) as datetime) as DTStart,
-- Дата конца смены
       case
           when cor.time_start < cor.time_end then
               cast(concat(cor.shift_date, " ", cor.time_end) as datetime)
           else
                   cast(concat(cor.shift_date, " ", cor.time_end) as datetime) + INTERVAL 1 DAY
           END                                                       as DTEnd,
-- Длительность смены
       timediff(
               cast(concat(cor.shift_date, " ", cor.time_start) as datetime),
               case
                   when cor.time_start < cor.time_end then
                       cast(concat(cor.shift_date, " ", cor.time_end) as datetime)
                   else
                           cast(concat(cor.shift_date, " ", cor.time_end) as datetime) + INTERVAL 1 DAY
                   END)                                              as DlSmen

from analyticdb.gs_correction_tmp as cor

-- Подставляем полное имя сотрудника
         left join analyticdb.gs_employee as emp on cor.employee = emp.fio_schedule