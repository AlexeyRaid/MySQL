select gr.*,
       concat(ifnull(p_cl.clinic, 'ANY'), "_",
              ifnull(p_dpt.department, 'ANY'), "_",
              ifnull(p_pst.post, 'ANY'), "_",
              ifnull(p_shft.shift, 'ANY'), "_",
              ifnull(p_shft.fio, 'ANY'), "_",
              ifnull(p_lev.level, 'ANY')) as UniqPay
from analyticdb.zpn_sched_lev as gr

         left join zpn_payconditions as p_cl
                   on gr.clinic = p_cl.clinic and gr.DateSm >= p_cl.date_from and gr.DateSm <= p_cl.date_to
         left join zpn_payconditions as p_dpt
                   on gr.department = p_dpt.department and gr.DateSm >= p_dpt.date_from and gr.DateSm <= p_dpt.date_to
         left join zpn_payconditions as p_pst
                   on gr.post = p_pst.post and gr.DateSm >= p_pst.date_from and gr.DateSm <= p_pst.date_to
         left join zpn_payconditions as p_shft
                   on gr.shift = p_pst.shift and gr.DateSm >= p_shft.date_from and gr.DateSm <= p_shft.date_to
         left join zpn_payconditions as p_fio
                   on gr.fio = p_fio.fio and gr.DateSm >= p_fio.date_from and gr.DateSm <= p_fio.date_to
         left join zpn_payconditions as p_lev
                   on gr.level = p_lev.level and gr.DateSm >= p_lev.date_from and gr.DateSm <= p_lev.date_to