select s.period,
       s.recorder,
       s.line_number,
       s.executor,
       s.price,
       s.price_without_discounts,
       s.amount_of_costs,
       pay.recipient,
       pay.share_donor_used_services
from analyticdb.et_sales as s

         left join analyticdb.zpn_sched_conditions_final as graf
                   on s.period >= graf.DTStart and s.period <= graf.DTEnd and
                      s.executor = graf.fio_ref
         left join analyticdb.zpn_paycond_zavotd as pay on s.period >= pay.date_from and s.period <= pay.date_to
    and s.executor = pay.ref_donor
    and pay.department = graf.department

-- Подтягиваем тип продажи
         left join analyticdb.et_nomenclature as nom on s.nomenclature_key = nom.ref_key
         left join analyticdb.et_salary_analytics as anal on nom.salary_analytics_key = anal.ref_key


where s.period >= '2023-02-01 00:00'
  -- and pay.share_donor_used_services is not null
  and (s.price <> 0
    or s.amount_of_costs <> 0
    or s.price_without_discounts <> 0)
  and anal.description = 'Клиника'