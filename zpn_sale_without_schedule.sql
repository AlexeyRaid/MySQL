select anal.description, s.*, empIsp.fio
from analyticdb.et_sales as s

         left join analyticdb.gs_employee as empIsp on s.executor = empIsp.ref_key
         left join analyticdb.et_nomenclature as nom on s.nomenclature_key = nom.ref_key
         left join analyticdb.et_salary_analytics as anal on nom.salary_analytics_key = anal.ref_key

         left join analyticdb.zpn_schedule as graf on s.period >= graf.DTStart and s.period <= graf.DTEnd

where s.period >= '2023-02-01 00:00'
  and empIsp.ref_key = s.executor
  and empIsp.ref_key is not null
  and graf.employee is null
