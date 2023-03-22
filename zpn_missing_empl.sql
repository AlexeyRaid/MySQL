select gr.employee, empl.fio, date_add(gr.year_month, INTERVAL (gr.day - 1) day) as DateSm
from analyticdb.gs_schedule_tmp as gr

         left join analyticdb.gs_employee as empl on gr.employee = empl.fio_schedule

where gr.employee is not null
  and empl.ref_key is null