select date(s.period) as Date, nom.description, nom.code, sum(s.price * s.quantity_paid) as price
from analyticdb.et_sales as s

-- Подтягиваем тип продажи
         left join analyticdb.et_nomenclature as nom on s.nomenclature_key = nom.ref_key
         left join analyticdb.et_salary_analytics as anal on nom.salary_analytics_key = anal.ref_key

where s.period >= '2022-04-01'
  and anal.description is null

group by DATE_FORMAT(s.period, '%M %Y')