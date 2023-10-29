SELECT gr1.DateSm                             as Kl1_DateSm,
       gr1.clinic                             as Kl1,
       gr1.employee                           as Kl1_Sotr,
       gr1.department                         as Kl1_Depart,
       gr1.post                               as Kl1_post,
       gr1.Role                               as Kl1_Role,
       gr1.Shift                              as Kl1_Smena,
       gr1.DTStart                            as Kl1_DTStart,
       DATE_SUB(gr1.DTEnd, INTERVAL 1 SECOND) as Kl1_DTEnd,
       gr1.Korr                               as Kl1_Korr,

       gr2.DateSm                             as Kl2_DateSm,
       gr2.clinic                             as Kl2,
       gr2.employee                           as Kl2_Sotr,
       gr2.department                         as Kl2_Depart,
       gr2.post                               as Kl2_post,
       gr2.Role                               as Kl2_Role,
       gr2.Shift                              as Kl2_Smena,
       gr2.DTStart                            as Kl2_DTStart,
       DATE_SUB(gr2.DTEnd, INTERVAL 1 SECOND) as Kl2_DTEnd,
       gr2.Korr                               as Kl2_Korr


from analyticdb.zpn_schedule as gr1
         LEFT JOIN analyticdb.zpn_schedule AS gr2 ON gr1.employee = gr2.employee AND (
        (gr2.DTStart BETWEEN gr1.DTStart AND DATE_SUB(gr1.DTEnd, INTERVAL 1 SECOND))
        or
        (DATE_SUB(gr2.DTEnd, INTERVAL 1 SECOND) BETWEEN gr1.DTStart AND DATE_SUB(gr1.DTEnd, INTERVAL 1 SECOND))
    )


WHERE CONCAT_WS("_", gr1.clinic, gr1.department, gr1.post, gr1.role, gr1.shift, gr1.employee, gr1.fio, gr1.DateSm,
                gr1.DTStart, gr1.DTEnd, gr1.DlSmen)
    <>
      CONCAT_WS("_", gr2.clinic, gr2.department, gr2.post, gr2.role, gr2.shift, gr2.employee, gr2.fio, gr2.DateSm,
                gr2.DTStart, gr2.DTEnd, gr2.DlSmen)

  and gr1.DTStart >= '2023-10-01' and gr1.department = 'Фронт-Офис'


ORDER BY gr1.employee, gr1.DTStart