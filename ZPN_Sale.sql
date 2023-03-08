select s.period,
       s.organization_key,
       s.employee,
       s.executor,
       s.nomenclature_key,
       anal.description,
       nom.code,
       s.price_without_discounts,
       s.price,
       s.amount_of_costs
from analyticdb.et_sales as s

-- Подтягиваем тип продажи
         left join analyticdb.et_nomenclature as nom on s.nomenclature_key = nom.ref_key
         left join analyticdb.et_salary_analytics as anal on nom.salary_analytics_key = anal.ref_key


where s.period between '2023-02-01' and '2023-02-28'
  and (s.price <> 0
    or s.amount_of_costs <> 0
    or s.price_without_discounts <> 0)
  and anal.description is null
  and nom.is_folder = 0
