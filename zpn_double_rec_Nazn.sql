select count(*), s.recorder, s.line_number, gr.DateSm, gr.fio
from analyticdb.et_sales as s


         left join analyticdb.zpn_sched_conditions_final as gr on s.period between gr.DTStart and gr.DTEnd
    and s.employee = gr.fio_ref


where s.period >= '2023-02-01 00:00'
  and gr.fio_ref is not null

group by s.recorder, s.line_number, gr.DateSm, gr.fio

having count(*) > 1