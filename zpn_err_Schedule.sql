select gr.employee,
       gr.fio,
       gr.post,
       gr.level,
       gr.department,
       min(gr.DateSm) as Date_From,
       max(gr.DateSm) as Date_To
from analyticdb.zpn_sched_lev as gr
where gr.fio is null
   or gr.level is null
   or gr.post
group by gr.employee, gr.fio, gr.post, gr.level, gr.department