select s.period,
       s.organization_key,
       s.employee,
       s.executor,
       s.nomenclature_key,
       s.price_without_discounts,
       s.price,
       s.amount_of_costs
from analyticdb.et_sales as s
where s.period between '2023-02-01' and '2023-02-28'
  and (s.price <> 0
    or s.amount_of_costs <> 0
    or s.price_without_discounts <> 0)