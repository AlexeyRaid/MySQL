SELECT pr.nomenclature_key, pr.price_type_key, date(pr.period) as DateSetPrice, pr.price
FROM analyticdb.et_nomenclature_prices AS pr

         INNER JOIN (SELECT nomenclature_key, MAX(period) AS max_period, price_type_key
                     FROM analyticdb.et_nomenclature_prices
                     GROUP BY nomenclature_key, price_type_key) AS sub
                    ON pr.nomenclature_key = sub.nomenclature_key AND pr.period = sub.max_period and
                       pr.price_type_key = sub.price_type_key

GROUP BY pr.nomenclature_key, pr.price_type_key