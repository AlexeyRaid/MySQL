select gr1.Korr,
       gr1.clinic     as Kl1,
       gr1.employee   as Kl1_Sotr,
       gr1.department as Kl1_Depart,
       gr1.post       as Kl1_post,
       gr1.Role       as Kl1_Role,
       gr1.Shift      as Kl1_Smena,
       gr1.DTStart    as Kl1_DTStart,
       gr1.DTEnd      as Kl1_DTEnd,
       gr2.DTStart    as Kl2_DTStart,
       gr2.DTEnd      as Kl2_DTEnd,
       gr2.clinic     as Kl2,
       gr2.employee   as Kl2_Sotr,
       gr2.department as Kl2_Depart,
       gr2.post       as Kl2_post,
       gr2.Role       as Kl2_Role,
       gr2.Shift      as Kl2_Smena


from analyticdb.zpn_schedule as gr1

         left join analyticdb.zpn_schedule as gr2 on gr2.employee = gr1.employee and
                                                     gr2.DTStart < gr1.DTStart and gr2.DTEnd > gr1.DTStart
where gr2.DTEnd is not null
  and gr1.DTStart >= '2023-02-01'