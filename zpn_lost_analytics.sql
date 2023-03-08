use analyticdb
select nom.description, nom.code, nom.nomenclature_type, nom.view_key as articul
from analyticdb.et_nomenclature as nom

         left join analytic_salaries as anal on nom.salary_analytics_key = anal.ref_key

where anal.description is null
  and nom.is_folder = 0