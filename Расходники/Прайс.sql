select pr.period as DTStart,
       nomenclature_key,
       price_type_key,
       pr.price,
-- Ставим дату действия прайса (дата окончания совпадает с датой следующей цены по номенклатуре и типу цен
       ifnull(
               (select pr2.period
                from analyticdb.et_nomenclature_prices as pr2
                where pr.period < pr2.period
                  and pr.nomenclature_key = pr2.nomenclature_key
                  and pr.price_type_key = pr2.price_type_key
                order by pr2.nomenclature_key, pr2.price_type_key, pr2.period
                limit 1), date_add(now(), interval 1 day)
           ) as DTEnd,
    pr.price_type_key

from analyticdb.et_nomenclature_prices as pr

where pr.active = 1
