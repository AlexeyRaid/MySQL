select de.recorder,
       de.line_number,
       de.period,
       date(de.period)                         as DT,
       de.organization_key,
       de.warehouse_key,
       de.recorder_type,
       de.service_key,
       de.consumable_key,
       de.quantity,
       de.cost,
       round(de.cost / de.quantity, 2)         as price,
       nom.unit_rest_key_storage,
       nom.unit_base_key,
       mea.coefficient,
       de.cost / de.quantity / mea.coefficient as PurchaseBase, -- По коэфициенту высчитываем цену продажи Базовой единицы
       wh.type_price_key,
       pr.price as PriceBase,
       pr.price*mea.coefficient as PriceSale, -- цена продажи за ед в единицах ХраненияОстатков
       pr.price*mea.coefficient*de.quantity as CostSale -- Сумма продажи в единицах ХраненияОстатков



from analyticdb.et_decommissioned_consumables as de

-- Тянем Единицу хранения остатков с каталога номенклатура
         left join analyticdb.et_nomenclature as nom on de.consumable_key = nom.ref_key

-- Тянем Коефициент с единиц измерения
         left join analyticdb.et_measure as mea on de.consumable_key = mea.owner_key

-- Подтягиваем ТипыЦен по складу продажи
         left join analyticdb.et_warehouses as wh on de.warehouse_key = wh.ref_key

-- Тянем Цены номенклатуры, единица Измерения - базовая
left join analyticdb.rash_price as pr on de.consumable_key=pr.nomenclature_key
                                                 and  wh.type_price_key = pr.price_type_key
and de.period >= pr.DTStart and de.period < pr.DTEnd
and nom.unit_base_key = pr.unit_base_key


where de.active = 1 and de.period >= '2023-01-01 00:00'
