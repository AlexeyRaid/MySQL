select nom.Корм,
       sum(sale.quantity_paid) as QTU,
       date(sale.period)       as DT,
       sale.organization_key   as clinic,
       sale.employee           as empl
from to_analytics.rc_endsale as nom

         left join analyticdb.et_sales as sale on nom.ref_key = sale.nomenclature_key


where sale.period >= '2022-04-01 00:00'

group by date(sale.period), nom.Корм, sale.organization_key, sale.employee