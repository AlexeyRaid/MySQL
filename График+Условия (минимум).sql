select gr.*, pay.pers_of_serv_used
from analyticdb.zpn_sched_lev as gr

         left join analyticdb.zpn_payconditions as pay on gr.DateSm >= pay.date_from and gr.DateSm <= pay.date_to and
                                                          gr.clinic = pay.clinic and
                                                          gr.role = pay.role and
                                                          gr.post = pay.post and
                                                          gr.level = pay.level
where gr.DateSm >= '2023-01-01'

