select gr.DateSm,
       gr.DTStart,
       gr.DTEnd,
       hour(gr.DlSmen)             as DlSmenH,
       s.organization_key,
       s.employee,
       gr.post,
       s.price_without_discounts   as price_with_disc,
       s.price,
       s.amount_of_costs,
       gr.НормаАптеки_в_Смену / 12 as НормаАптеки_в_Час,
       gr.БрНазнАптекаДоЛимита,
       gr.БрНазнАптекаПремия,
       gr.ПерсНазнАптекаДоЛимита,
       gr.ПерсНазнАптекаПремия

from analyticdb.et_sales as s

-- Подтягиваем тип продажи
         left join analyticdb.et_nomenclature as nom on s.nomenclature_key = nom.ref_key
         left join analyticdb.et_salary_analytics as anal on nom.salary_analytics_key = anal.ref_key

-- Тянем график с условиями
         left join analyticdb.zpn_sched_conditions_final as gr on s.period >= gr.DTStart and s.period < gr.DTEnd and
                                                                  s.employee = gr.fio_ref
where s.period between '2023-02-01' and '2023-02-28'
  and (s.price <> 0
    or s.amount_of_costs <> 0
    or s.price_without_discounts <> 0)
  and nom.is_folder = 0
  and anal.ref_key is not null
  and (gr.БрНазнАптекаДоЛимита is not null or gr.БрНазнАптекаПремия is not null or
       gr.ПерсНазнАптекаДоЛимита is not null or gr.ПерсНазнАптекаПремия is not null)
  and anal.description = 'Аптека+Зоомагазин'
