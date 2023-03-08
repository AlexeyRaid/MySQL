select gr.employee, gr.fio, gr.level, gr.department, gr.DateSm
from analyticdb.zpn_sched_lev as gr
where gr.fio is null
   or gr.level is null