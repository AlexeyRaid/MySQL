select s.period,
       date(s.period)                               as DTSale,
       s.organization_key,
       s.employee,
       emp.fio,
       anal.description                             as type,
       s.price_without_discounts                    as price_with_disc,
       s.price,
       s.amount_of_costs,
       pay.role,

       pay.pers_of_serv_assign                      as ПерсНазУсл,
       pay.pers_of_serv_used                        as ПерсИспУсл,
       pay.pers_of_prescribed_med                   as ПерсНазМед,
       pay.pers_of_used_med                         as ПерсИспМед,
       pay.pers_of_assign_pharmacy_prem_under_limit as ПерсНазнАптекаДоЛимита,
       pay.pers_of_used_pharmacy_prem_under_limit   as ПерсИспАптекаДоЛимита


from analyticdb.et_sales as s

-- Подтягиваем тип продажи
         left join analyticdb.et_nomenclature as nom on s.nomenclature_key = nom.ref_key
         left join analyticdb.et_salary_analytics as anal on nom.salary_analytics_key = anal.ref_key

-- Тянем график с условиями
         left join analyticdb.zpn_sched_conditions_final as gr on s.period between gr.DTStart and gr.DTEnd and
                                                                  s.employee = gr.fio_ref
-- Подтягиваем сотрудников
         left join analyticdb.gs_employee as emp on s.employee = emp.ref_key

-- Тянем условия для самозванцев
         left join analyticdb.zpn_payconditions as pay on s.period between pay.date_from and pay.date_to and
                                                          pay.role = 'Самозванец'


where s.period between '2023-02-01' and '2023-02-28'
  and (s.price <> 0
    or s.amount_of_costs <> 0
    or s.price_without_discounts <> 0)
  and nom.is_folder = 0
  and anal.ref_key is not null
  and gr.DateSm is null
  and emp.ref_key is not null

