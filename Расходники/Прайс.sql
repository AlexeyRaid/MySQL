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
           current_timestamp() + interval 1 day) AS DTEnd,

       nom.unit_base_key                                       AS unit_base_key



from (analyticdb.et_nomenclature_prices pr
    left join analyticdb.et_nomenclature as nom  on pr.nomenclature_key = nom.ref_key and pr.measure_key = nom.unit_rest_key_storage
    )
where pr.active = 1

#   and nomenclature_key = '0fc114bc-11f0-11e2-3095-0025905619ba'
#   and price_type_key = 'a21f0f3c-cf45-11e6-2e8e-00163e832f7d'
#
#   and pr.period <= '2023-04-07 15:44:57'
#   and ifnull(
#               (select pr2.period
#                           from analyticdb.et_nomenclature_prices pr2
#                           where pr.period < pr2.period
#                             and pr.nomenclature_key = pr2.nomenclature_key
#                             and pr.price_type_key = pr2.price_type_key
#                           order by pr2.nomenclature_key, pr2.price_type_key, pr2.period
#                           limit 1)
#               , current_timestamp() + interval 1 day)
#     > '2023-04-07 15:44:57'

group by pr.recorder, pr.price_type_key, pr.price -- убрать, когда уйдет ошибка дубля серении в апреле в еноте