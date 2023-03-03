select gr.*, lev.level, gr.fio


from analyticdb.zpn_schedule as gr

         left join analyticdb.zpn_levelsemployees as lev
                   on gr.fio = lev.fio and
                      gr.department = lev.department and
                      gr.post = lev.post and
                      gr.DateSm >= lev.date_from and gr.DateSm <= lev.date_to

