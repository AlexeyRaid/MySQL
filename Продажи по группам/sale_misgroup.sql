select date(s.period)              as Date,
       s.organization_key          as Clinic,
       n.description               as Nomenclature,
       n.nomenclature_type         as Type,
       n.code                      as Code,
       n.deletion_mark             as Del,
       s.price                     as Summ,
       s.price_without_discounts   as SuumWODisc,
       s.price - s.amount_of_costs as Profit
from analyticdb.et_sales as s
         left join analyticdb.et_nomenclature as n on n.ref_key = s.nomenclature_key
         left join analyticdb.et_salary_analytics as a on a.ref_key = n.salary_analytics_key
where (s.price <> 0
    or s.amount_of_costs <> 0
    or s.price_without_discounts <> 0)
  and a.description is null
