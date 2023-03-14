SELECT s.period,
       date(s.period)                                as DTSale,
       cast(date_format(s.period, '%H:%mm') as time) as TMSale,
       s.executor,
       s.price,
       s.price_without_discounts,
       s.amount_of_costs,
       post.post,
       post.level,
       anal.description,
       pay.pers_of_serv_used                         as ПерсИспУсл,
       pay.pers_of_used_med                          as ПерсИспМед,
       pay.pers_of_used_pharmacy_prem_under_limit    as ПерсИспАптекаДоЛимита

from analyticdb.et_sales as s
         RIGHT JOIN analyticdb.gs_employee AS em ON em.ref_key = s.executor
         LEFT JOIN analyticdb.zpn_schedule AS sh ON em.fio = sh.fio AND s.period >= sh.DTStart AND s.period < sh.DTEnd
         left join analyticdb.gs_posts as post on
        (SELECT l.priority
         FROM analyticdb.zpn_levelsemployees AS l
         WHERE em.fio = l.fio
           AND s.period >= l.date_from
           AND s.period <= l.date_to
         ORDER BY l.priority desc
         LIMIT 1) = post.priority

         left join analyticdb.et_nomenclature as n on s.nomenclature_key = n.ref_key
         left join analyticdb.analytic_salaries as anal on n.salary_analytics_key = anal.ref_key

         left join analyticdb.gs_clinics as cl on s.organization_key = cl.ref_key


-- Тянем условия
         left join analyticdb.zpn_payconditions as pay on pay.role = 'Самозванец' and
                                                          s.period >= pay.date_from and s.period <= pay.date_to and
                                                          pay.post = post.post and
                                                          pay.level = post.level and
                                                          cl.clinic = pay.clinic


where s.period >= '2023-02-01 00:00'

  and (s.price <> 0
    or s.amount_of_costs <> 0
    or s.price_without_discounts <> 0)

  AND sh.DateSm IS null
  and anal.description in ('Клиника', 'Медикаменты')
