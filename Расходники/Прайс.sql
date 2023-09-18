select pr.period,
       nomenclature_key,
       price_type_key,
       pr.price,


    (select pr2.period
from analyticdb.et_nomenclature_prices as pr2
where pr.period < pr2.period
  and pr.nomenclature_key = pr2.nomenclature_key
and pr.price_type_key = pr2.price_type_key
order by   pr2.nomenclature_key, pr2.price_type_key, pr2.period limit 1

    ) as DTto





from analyticdb.et_nomenclature_prices as pr

where pr.active = 1
and pr.nomenclature_key='db18b1a4-e455-11e8-999f-005056002892' and pr.price_type_key = 'd2077018-8fa9-11e5-4a86-5254a2011c0f'