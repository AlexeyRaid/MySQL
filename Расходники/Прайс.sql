select pr.period                                               AS DTStart,
       pr.nomenclature_key                                     AS nomenclature_key,
       pr.price_type_key                                       AS price_type_key,
       pr.price                                                AS price,
       ifnull(
           (select pr2.period
               from analyticdb.et_nomenclature_prices as pr2
               where pr.period < pr2.period
                 and pr.nomenclature_key = pr2.nomenclature_key
                 and pr.price_type_key = pr2.price_type_key
               order by pr2.nomenclature_key, pr2.price_type_key, pr2.period
               limit 1),
           current_timestamp() + interval 1 day)               AS DTEnd,
       nom.unit_base_key                                       AS unit_base_key
                    from (analyticdb.et_nomenclature_prices as pr
                        left join analyticdb.et_nomenclature nom on pr.nomenclature_key = nom.ref_key and pr.measure_key = nom.unit_rest_key_storage
                        )
where pr.active = 1