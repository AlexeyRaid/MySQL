select s.period,
       gr.DateSm,
       gr.DTStart,
       gr.DTEnd,
       hour(gr.DlSmen)           as DlSmen,
       s.organization_key,
       gr.role,
       gr.post,
       s.employee,
       anal.description          as type,
       s.price_without_discounts as price_with_disc,
       s.price,
       s.amount_of_costs,
       gr.БрНазУсл,
       gr.БрНазМед,
       gr.ПерсНазУсл,
       gr.ПерсНазМед,
       gr.ПерсГарСм

from analyticdb.et_sales as s

-- Подтягиваем тип продажи
         left join analyticdb.et_nomenclature as nom on s.nomenclature_key = nom.ref_key
         left join analyticdb.et_salary_analytics as anal on nom.salary_analytics_key = anal.ref_key

-- Тянем график с условиями
         left join analyticdb.zpn_sched_conditions_final as gr on s.period between gr.DTStart and gr.DTEnd and
                                                                  s.employee = gr.fio_ref
where s.period >= '2023-02-01 00:00'
  and s.period < '2023-03-01 00:00'
  and (s.price <> 0
    or s.amount_of_costs <> 0
    or s.price_without_discounts <> 0)
  and nom.is_folder = 0
  and anal.ref_key is not null
  and (gr.БрНазУсл is not null or gr.БрНазМед is not null or gr.ПерсНазУсл is not null or gr.ПерсНазМед is not null)
  and (anal.description = 'Клиника' or anal.description = 'Медикаменты')
