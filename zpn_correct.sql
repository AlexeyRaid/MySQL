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

       'DTEnd',
       'DlSmen'
from analyticdb.gs_correction_tmp as cor

-- Подставляем полное имя сотрудника
         left join gs_employee as emp on cor.employee = emp.fio_schedule