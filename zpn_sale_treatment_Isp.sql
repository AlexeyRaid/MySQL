select s.period,
       gr.DateSm,
       s.organization_key,
       gr.role,
       gr.post,
       s.executor,
       anal.description          as type,
       s.price_without_discounts as price_with_disc,
       s.price,
       s.amount_of_costs,
       gr.БрИспУсл,
       gr.БрИспМед,
       gr.ПерсИспУсл,
       gr.ПерсИспМед

from analyticdb.et_sales as s

-- Подтягиваем тип продажи
         left join analyticdb.et_nomenclature as nom on s.nomenclature_key = nom.ref_key
         left join analyticdb.et_salary_analytics as anal on nom.salary_analytics_key = anal.ref_key

-- Тянем график с условиями
         left join analyticdb.zpn_sched_conditions_final as gr on s.period between gr.DTStart and gr.DTEnd and
                                                                  s.executor = gr.fio_ref
where s.period between '2023-02-01' and '2023-02-28'
  and (s.price <> 0
    or s.amount_of_costs <> 0
    or s.price_without_discounts <> 0)
  and nom.is_folder = 0
  and anal.ref_key is not null
  and (gr.БрИспУсл is not null or gr.БрИспМед is not null or gr.ПерсИспУсл is not null or gr.ПерсИспМед is not null)
  and (anal.description = 'Клиника' or anal.description = 'Медикаменты')